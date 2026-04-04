/**
 * 주역(周易) 전용 Chat Edge Function
 *
 * 플로우: 질문 → Gemini 임베딩 → 벡터 검색(폴백: 키워드) → 캐시 확인 → LLM 스트리밍
 * 환경변수: GEMINI_API_KEY (필수), ANTHROPIC_API_KEY (선택)
 */

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0"
import { crypto } from "https://deno.land/std@0.168.0/crypto/mod.ts"

// ─── 타입 ────────────────────────────────────────────

interface ChatMessage { role: 'system' | 'user' | 'assistant'; content: string }

interface ChatRequest {
  messages: ChatMessage[]
  hexagram_id: string
  persona_id?: string
  debug_embedding?: boolean
}

interface DocumentResult { content: string; metadata?: Record<string, unknown> }

// ─── CORS ────────────────────────────────────────────

function corsHeaders(req?: Request) {
  const allowedOrigins = (Deno.env.get('ALLOWED_ORIGINS') ?? '').split(',').map(s => s.trim()).filter(Boolean)
  const origin = req?.headers.get('Origin') ?? ''
  const isAllowed = allowedOrigins.length === 0 || allowedOrigins.includes(origin)
  return {
    'Access-Control-Allow-Origin': isAllowed ? origin : allowedOrigins[0] || '',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Max-Age': '86400',
    'Vary': 'Origin',
  }
}

// ─── 페르소나 ────────────────────────────────────────

const PERSONA: Record<string, string> = {
  basic: '답변 시 차분하고 격식 있는 말투를 사용해 주세요. 고전의 깊은 지혜가 느껴지도록 문장을 구성하고, 사용자에게 예의를 갖추어 조언을 건넵니다.',
  friendly: '답변 시 다정하고 따뜻한 말투를 사용해 주세요. 사용자의 고민에 깊이 공감하고 위로와 격려를 건네며, 친근한 조언자처럼 부드럽게 대화를 이끌어 주세요.',
  strict: '답변 시 군더더기 없이 핵심만 짚어서 간결하고 명확하게 말씀해 주세요. 감정적인 서술보다는 논리적이고 객관적인 상황 분석을 우선하며, 단도직입적으로 해결책이나 고찰을 제시합니다.',
}

// ─── 시스템 프롬프트 ─────────────────────────────────

function buildSystemPrompt(hexagramId: string, contexts: DocumentResult[]): string {
  const contextBlock = contexts.length > 0
    ? contexts.map((c, i) => `[참고 원문 ${i + 1}]\n${c.content}`).join('\n\n')
    : ''

  return `당신은 주역(周易)에 정통한 학자이자 해설가입니다.

사용자가 뽑은 괘는 '${hexagramId}'입니다.

${contextBlock ? `다음은 이 괘와 관련된 주역 원전 내용입니다:\n\n${contextBlock}\n\n` : ''}다음 3단계로 답변해 주세요:

**1단계: 점괘 결과**
- 이 괘의 전체적인 길흉(吉凶) 판단을 먼저 밝혀 주세요.
- 사용자의 질문 맥락에 맞춰 핵심 메시지를 한두 줄로 정리합니다.

**2단계: 원전 해석**
- 괘사(卦辭)와 효사(爻辭)를 인용하며 근거를 제시해 주세요.
- 상전(象傳), 단전(彖傳) 등 전(傳)의 해석도 포함합니다.

**3단계: 쉬운 풀이**
- 현대적 상황에 비유하여 누구나 이해할 수 있도록 풀어서 설명합니다.
- 사용자의 고민에 대한 구체적인 조언으로 마무리합니다.

**주의사항:** 응답에 이모지(emoji)를 절대 사용하지 마세요. 텍스트만 사용합니다.`
}

// ─── Gemini 임베딩 ───────────────────────────────────

async function generateEmbedding(text: string, apiKey: string): Promise<number[]> {
  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=${apiKey}`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: 'models/gemini-embedding-001',
        content: { parts: [{ text }] },
      }),
    }
  )

  if (!response.ok) {
    const err = await response.text()
    console.error('[Embedding Error]', err)
    throw new Error(`Embedding 실패: ${response.status}`)
  }

  const data = await response.json()
  return data.embedding.values
}

// ─── 문서 검색 (벡터 → 키워드 폴백) ─────────────────

async function searchDocuments(
  supabase: ReturnType<typeof createClient>,
  query: string,
  geminiApiKey: string,
): Promise<{ contexts: DocumentResult[]; embeddingInfo: { dimension: number; elapsed_ms: number; preview: number[] } | null }> {
  let embeddingInfo = null

  // 1차: 벡터 유사도 검색
  try {
    const startTime = Date.now()
    const embedding = await generateEmbedding(query, geminiApiKey)
    const elapsed = Date.now() - startTime

    embeddingInfo = {
      dimension: embedding.length,
      elapsed_ms: elapsed,
      preview: embedding.slice(0, 5),
    }

    console.log(`[Embedding] ${embedding.length}차원, ${elapsed}ms`)

    const { data, error } = await supabase.rpc('match_i_ching_documents', {
      query_embedding: embedding,
      match_threshold: 0.3,
      match_count: 10,
    })

    if (!error && data && data.length > 0) {
      console.log(`[Search] 벡터 검색 ${data.length}건 히트`)
      return { contexts: data.slice(0, 4), embeddingInfo }
    }
  } catch (e) {
    console.error('[Search] 벡터 검색 실패, 키워드 폴백:', e)
  }

  // 2차: 키워드 검색 폴백
  const { data, error } = await supabase.rpc('search_i_ching_by_keyword', {
    query_text: query,
    match_count: 10,
  })

  if (error) {
    console.error('[Search] 키워드 검색도 실패:', error)
    return { contexts: [], embeddingInfo }
  }

  console.log(`[Search] 키워드 검색 ${data?.length ?? 0}건 히트`)
  return { contexts: (data ?? []).slice(0, 4), embeddingInfo }
}

// ─── 캐시 ────────────────────────────────────────────

async function sha256(text: string): Promise<string> {
  const data = new TextEncoder().encode(text)
  const hash = await crypto.subtle.digest('SHA-256', data)
  return Array.from(new Uint8Array(hash)).map(b => b.toString(16).padStart(2, '0')).join('')
}

async function getCachedResponse(
  supabase: ReturnType<typeof createClient>,
  hexagramNumber: number,
  question: string,
): Promise<string | null> {
  const queryHash = await sha256(question.trim().toLowerCase())
  const { data } = await supabase
    .from('i_ching_cache')
    .select('interpretation, hit_count')
    .eq('query_hash', queryHash)
    .single()

  if (data?.interpretation) {
    await supabase
      .from('i_ching_cache')
      .update({ hit_count: (data.hit_count || 0) + 1 })
      .eq('query_hash', queryHash)
  }

  return data?.interpretation ?? null
}

async function setCachedResponse(
  supabase: ReturnType<typeof createClient>,
  hexagramNumber: number,
  question: string,
  response: string,
): Promise<void> {
  const queryHash = await sha256(question.trim().toLowerCase())
  await supabase.from('i_ching_cache').upsert({
    hexagram_number: hexagramNumber,
    query_hash: queryHash,
    interpretation: response,
  }, { onConflict: 'query_hash' })
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

function createCachedSSEStream(text: string): ReadableStream {
  const encoder = new TextEncoder()
  const chunks = text.match(/.{1,50}/g) || [text]
  let i = 0
  return new ReadableStream({
    pull(ctrl) {
      if (i < chunks.length) { ctrl.enqueue(encoder.encode(`data: ${JSON.stringify({ text: chunks[i++] })}\n\n`)) }
      else { ctrl.enqueue(encoder.encode('data: [DONE]\n\n')); ctrl.close() }
    },
  })
}

// ─── 메인 핸들러 ─────────────────────────────────────

serve(async (req) => {
  const cors = corsHeaders(req)
  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors })
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'POST 메서드만 허용됩니다.' }),
      { status: 405, headers: { ...cors, 'Content-Type': 'application/json' } })
  }
  const contentLength = parseInt(req.headers.get('content-length') || '0')
  if (contentLength > 512000) {
    return new Response(JSON.stringify({ error: '요청이 너무 큽니다.' }),
      { status: 413, headers: { ...cors, 'Content-Type': 'application/json' } })
  }

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
    const { messages, hexagram_id, persona_id, debug_embedding } = await req.json() as ChatRequest

    if (!messages?.length) throw new Error('messages 배열이 필요합니다.')
    if (messages.length > 50) throw new Error('messages는 최대 50개까지 허용됩니다.')
    for (const m of messages) {
      if (typeof m.content !== 'string' || m.content.length > 10000) {
        throw new Error('유효하지 않은 메시지 형식입니다.')
      }
    }

    const hNum = parseInt(hexagram_id, 10)
    if (!hexagram_id || isNaN(hNum) || hNum < 1 || hNum > 64) {
      throw new Error('유효하지 않은 hexagram_id입니다.')
    }

    // 환경변수
    const claudeApiKey = Deno.env.get('ANTHROPIC_API_KEY')
    const geminiApiKey = Deno.env.get('GEMINI_API_KEY')
    if (!claudeApiKey && !geminiApiKey) throw new Error('API 키가 필요합니다.')
    if (!geminiApiKey) throw new Error('GEMINI_API_KEY가 필요합니다. (임베딩용)')

    // 사용자 질문 추출
    const userMessages = messages.filter(m => m.role === 'user')
    const latestQuestion = userMessages[userMessages.length - 1]?.content || ''

    // 캐시 확인 + 벡터 검색을 병렬 실행
    const isFirstQuestion = userMessages.length === 1
    const [cached, searchResult] = await Promise.all([
      isFirstQuestion ? getCachedResponse(supabase, hNum, latestQuestion) : Promise.resolve(null),
      searchDocuments(supabase, latestQuestion, geminiApiKey),
    ])

    // 디버그 임베딩 모드 (프로덕션에서 비활성화)
    if (debug_embedding && Deno.env.get("ENVIRONMENT") === "development") {
      return new Response(JSON.stringify({
        debug: true,
        input_text: latestQuestion,
        embedding: searchResult.embeddingInfo,
        search_results: searchResult.contexts.length,
        cached: !!cached,
      }), { headers: { ...cors, 'Content-Type': 'application/json' } })
    }

    // 캐시 히트
    if (cached && isFirstQuestion) {
      console.log('[Cache Hit]')
      return new Response(createCachedSSEStream(cached), {
        headers: { ...cors, 'Content-Type': 'text/event-stream', 'Cache-Control': 'no-cache' },
      })
    }

    // 프롬프트 구성
    const finalMessages: ChatMessage[] = [
      { role: 'system', content: buildSystemPrompt(hexagram_id, searchResult.contexts) },
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
      rawStream = await callGemini(finalMessages, geminiApiKey)
      transform = transformGeminiStream
    }

    let outputStream = transform(rawStream)

    // 첫 질문이면 백그라운드에서 캐시 저장
    if (isFirstQuestion) {
      const [forClient, forCache] = outputStream.tee()
      collectAndCache(forCache, supabase, hNum, latestQuestion)
      outputStream = forClient
    }

    return new Response(outputStream, {
      headers: { ...cors, 'Content-Type': 'text/event-stream', 'Cache-Control': 'no-cache' },
    })

  } catch (error) {
    console.error('[Error]', error)
    const clientMsg = error.message?.startsWith('유효하지 않은') || error.message?.startsWith('messages')
      ? error.message
      : '요청을 처리할 수 없습니다.'
    return new Response(JSON.stringify({ error: clientMsg }), {
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

function collectAndCache(stream: ReadableStream, supabase: ReturnType<typeof createClient>, hexNum: number, question: string) {
  const reader = stream.getReader()
  const decoder = new TextDecoder()
  ;(async () => {
    try {
      let fullText = ''
      while (true) {
        const { done, value } = await reader.read()
        if (done) break
        for (const line of decoder.decode(value, { stream: true }).split('\n')) {
          const t = line.trim()
          if (t.startsWith('data: ') && t !== 'data: [DONE]') {
            try { const d = JSON.parse(t.substring(6)); if (d.text) fullText += d.text } catch { /* ignore */ }
          }
        }
      }
      if (fullText) {
        await setCachedResponse(supabase, hexNum, question, fullText)
        console.log('[Cache] 저장 완료')
      }
    } catch (e) { console.error('[Cache Error]', e) }
  })()
}
