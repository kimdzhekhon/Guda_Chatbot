/**
 * 불경(팔만대장경) 전용 Chat Edge Function
 *
 * 플로우: 질문 → 키워드 검색(DB) + 로컬 검색(Flutter에서 전달) → LLM 스트리밍
 * 임베딩 없음 — GEMINI_API_KEY 불필요 (LLM 폴백용으로만 사용)
 */

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0"

// ─── 타입 ────────────────────────────────────────────

interface ChatMessage { role: 'system' | 'user' | 'assistant'; content: string }

interface ChatRequest {
  messages: ChatMessage[]
  persona_id?: string
  search_context?: string   // Flutter 로컬 검색 결과
}

interface DocumentResult {
  content: string
  source_lang?: string
  metadata?: Record<string, unknown>
}

// ─── CORS ────────────────────────────────────────────

const ALLOWED_ORIGINS = ['http://localhost', 'https://guda-chatbot.vercel.app']

function corsHeaders(req: Request) {
  const origin = req.headers.get('Origin') || ''
  return {
    'Access-Control-Allow-Origin': ALLOWED_ORIGINS.find(o => origin.startsWith(o)) || ALLOWED_ORIGINS[0],
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  }
}

// ─── 페르소나 ────────────────────────────────────────

const PERSONA: Record<string, string> = {
  basic: '답변 시 차분하고 격식 있는 말투를 사용해 주세요. 고전의 깊은 지혜가 느껴지도록 문장을 구성하고, 사용자에게 예의를 갖추어 조언을 건넵니다.',
  friendly: '답변 시 다정하고 따뜻한 말투를 사용해 주세요. 사용자의 고민에 깊이 공감하고 위로와 격려를 건네며, 친근한 조언자처럼 부드럽게 대화를 이끌어 주세요.',
  strict: '답변 시 군더더기 없이 핵심만 짚어서 간결하고 명확하게 말씀해 주세요. 감정적인 서술보다는 논리적이고 객관적인 상황 분석을 우선하며, 단도직입적으로 해결책이나 고찰을 제시합니다.',
}

// ─── 시스템 프롬프트 ─────────────────────────────────

function buildSystemPrompt(contexts: DocumentResult[], searchContext?: string): string {
  const contextBlock = contexts.length > 0
    ? contexts.map((c, i) => {
        const langLabel = { ko: '한글', zh: '한문', en: '영어', sa: '산스크리트' }[c.source_lang || 'ko'] || c.source_lang
        return `[참고 경전 ${i + 1} (${langLabel})]\n${c.content}`
      }).join('\n\n')
    : ''

  const combinedContext = [searchContext, contextBlock].filter(Boolean).join('\n\n---\n\n')

  return `당신은 불교 경전(팔만대장경, 구사론 포함)에 정통한 학자이자 해설가입니다.

${combinedContext ? `다음은 사용자의 질문과 관련된 경전 내용입니다:\n\n${combinedContext}\n\n` : ''}다음 2단계로 답변해 주세요:

**1단계: 경전에 기반한 설명**
- 관련 경전의 핵심 구절을 인용하며 정확하게 설명합니다.
- 원문(한문, 산스크리트 등)이 있다면 함께 제시합니다.

**2단계: 쉬운 설명**
- 어려운 불교 용어를 현대적 언어로 풀어서 설명합니다.
- 사용자의 질문에 대한 구체적인 답을 제시하며 마무리합니다.

**주의사항:** 응답에 이모지(emoji)를 절대 사용하지 마세요. 텍스트만 사용합니다.`
}

// ─── DB 키워드 검색 ──────────────────────────────────

async function searchDocuments(
  supabase: ReturnType<typeof createClient>,
  query: string,
): Promise<DocumentResult[]> {
  const { data, error } = await supabase.rpc('search_tripitaka_documents', {
    query_text: query,
    match_count: 10,
  })

  if (error) {
    console.error('[Search] 키워드 검색 실패:', error)
    return []
  }

  console.log(`[Search] 불경 검색 ${data?.length ?? 0}건 히트`)
  return (data ?? []).slice(0, 4)
}

// ─── SSE 변환 ────────────────────────────────────────

function transformClaudeStream(src: ReadableStream): ReadableStream {
  const reader = src.getReader()
  const decoder = new TextDecoder()
  const encoder = new TextEncoder()
  let buffer = ''

  return new ReadableStream({
    async pull(ctrl) {
      try {
        const { done, value } = await reader.read()
        if (done) { ctrl.enqueue(encoder.encode('data: [DONE]\n\n')); ctrl.close(); return }

        buffer += decoder.decode(value, { stream: true })
        const lines = buffer.split('\n')
        buffer = lines.pop() || ''

        for (const line of lines) {
          const t = line.trim()
          if (!t.startsWith('data: ') || t === 'data: [DONE]') continue
          try {
            const d = JSON.parse(t.substring(6))
            if (d.type === 'content_block_delta' && d.delta?.text)
              ctrl.enqueue(encoder.encode(`data: ${JSON.stringify({ text: d.delta.text })}\n\n`))
            if (d.type === 'message_stop') { ctrl.enqueue(encoder.encode('data: [DONE]\n\n')); ctrl.close(); return }
          } catch { /* ignore */ }
        }
      } catch (e) { console.error('[Stream Error]', e); ctrl.enqueue(encoder.encode('data: [DONE]\n\n')); ctrl.close() }
    },
  })
}

function transformGeminiStream(src: ReadableStream): ReadableStream {
  const reader = src.getReader()
  const decoder = new TextDecoder()
  const encoder = new TextEncoder()
  let buffer = ''

  return new ReadableStream({
    async pull(ctrl) {
      try {
        const { done, value } = await reader.read()
        if (done) { ctrl.enqueue(encoder.encode('data: [DONE]\n\n')); ctrl.close(); return }

        buffer += decoder.decode(value, { stream: true })
        const lines = buffer.split('\n')
        buffer = lines.pop() || ''

        for (const line of lines) {
          const t = line.trim()
          if (!t.startsWith('data: ')) continue
          try {
            const d = JSON.parse(t.substring(6))
            const text = d.candidates?.[0]?.content?.parts?.[0]?.text
            if (text) ctrl.enqueue(encoder.encode(`data: ${JSON.stringify({ text })}\n\n`))
          } catch { /* ignore */ }
        }
      } catch (e) { console.error('[Stream Error]', e); ctrl.enqueue(encoder.encode('data: [DONE]\n\n')); ctrl.close() }
    },
  })
}

// ─── 메인 핸들러 ─────────────────────────────────────

serve(async (req) => {
  const cors = corsHeaders(req)
  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors })

  try {
    // 인증
    const authHeader = req.headers.get('Authorization')
    if (!authHeader?.startsWith('Bearer ')) {
      return new Response(JSON.stringify({ error: '인증 토큰이 필요합니다.' }),
        { status: 401, headers: { ...cors, 'Content-Type': 'application/json' } })
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    const token = authHeader.replace('Bearer ', '')
    const { data: { user }, error: authError } = await supabase.auth.getUser(token)
    if (authError || !user) {
      console.error('[Auth]', authError?.message)
      return new Response(JSON.stringify({ error: '유효하지 않은 인증입니다.' }),
        { status: 401, headers: { ...cors, 'Content-Type': 'application/json' } })
    }

    // 요청 파싱
    const { messages, persona_id, search_context } = await req.json() as ChatRequest
    if (!messages?.length) throw new Error('messages 배열이 필요합니다.')

    // 환경변수
    const claudeApiKey = Deno.env.get('ANTHROPIC_API_KEY')
    const geminiApiKey = Deno.env.get('GEMINI_API_KEY')
    if (!claudeApiKey && !geminiApiKey) throw new Error('API 키가 필요합니다.')

    // 사용자 질문 추출 + DB 검색
    const userMessages = messages.filter(m => m.role === 'user')
    const latestQuestion = userMessages[userMessages.length - 1]?.content || ''
    const contexts = await searchDocuments(supabase, latestQuestion)

    // 프롬프트 구성
    const finalMessages: ChatMessage[] = [
      { role: 'system', content: buildSystemPrompt(contexts, search_context) },
    ]
    if (persona_id && PERSONA[persona_id]) {
      finalMessages.push({ role: 'system', content: PERSONA[persona_id] })
    }
    finalMessages.push(...messages.filter(m => m.role !== 'system'))

    // LLM 호출 (Claude 우선, Gemini 폴백)
    let rawStream: ReadableStream
    let transform: (s: ReadableStream) => ReadableStream

    if (claudeApiKey) {
      try {
        const systemMsgs = finalMessages.filter(m => m.role === 'system')
        const nonSystemMsgs = finalMessages.filter(m => m.role !== 'system')
        const res = await fetch('https://api.anthropic.com/v1/messages', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', 'x-api-key': claudeApiKey, 'anthropic-version': '2023-06-01' },
          body: JSON.stringify({
            model: 'claude-sonnet-4-20250514', max_tokens: 4096, stream: true,
            system: systemMsgs.map(m => m.content).join('\n\n') || undefined,
            messages: nonSystemMsgs.map(m => ({ role: m.role, content: m.content })),
          }),
        })
        if (!res.ok) throw new Error(`Claude ${res.status}`)
        rawStream = res.body!
        transform = transformClaudeStream
      } catch (e) {
        console.error('[Claude Fallback]', e)
        if (!geminiApiKey) throw e
        rawStream = await callGemini(finalMessages, geminiApiKey)
        transform = transformGeminiStream
      }
    } else {
      rawStream = await callGemini(finalMessages, geminiApiKey!)
      transform = transformGeminiStream
    }

    return new Response(transform(rawStream), {
      headers: { ...cors, 'Content-Type': 'text/event-stream', 'Cache-Control': 'no-cache' },
    })

  } catch (error) {
    console.error('[Error]', error)
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400, headers: { ...cors, 'Content-Type': 'application/json' },
    })
  }
})

// ─── 헬퍼 ────────────────────────────────────────────

async function callGemini(messages: ChatMessage[], apiKey: string): Promise<ReadableStream> {
  const systemMsgs = messages.filter(m => m.role === 'system')
  const nonSystemMsgs = messages.filter(m => m.role !== 'system')
  const res = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:streamGenerateContent?alt=sse&key=${apiKey}`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        system_instruction: systemMsgs.length ? { parts: [{ text: systemMsgs.map(m => m.content).join('\n\n') }] } : undefined,
        contents: nonSystemMsgs.map(m => ({ role: m.role === 'assistant' ? 'model' : 'user', parts: [{ text: m.content }] })),
        generationConfig: { maxOutputTokens: 4096 },
      }),
    }
  )
  if (!res.ok) { const err = await res.text(); console.error('[Gemini Error]', err); throw new Error(`Gemini ${res.status}`) }
  return res.body!
}
