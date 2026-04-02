/**
 * Guda Chatbot - AI Chat Edge Function
 *
 * 역할: RAG 파이프라인 + LLM 직접 호출 + SSE 스트리밍
 * 기존 Next.js 프록시를 제거하고, 이 Edge Function이 전체 AI 응답을 담당합니다.
 *
 * 플로우:
 *   Flutter → 이 Edge Function → (RAG 검색 + 프롬프트 구성 + LLM 호출) → SSE 스트리밍 응답
 */

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0"
import { crypto } from "https://deno.land/std@0.168.0/crypto/mod.ts"

// ─── 타입 정의 ────────────────────────────────────────────

interface ChatMessage {
  role: 'system' | 'user' | 'assistant'
  content: string
}

interface ChatRequest {
  messages: ChatMessage[]
  topic_code: string        // 'iching' | 'tripitaka'
  hexagram_id?: string      // 주역 괘 이름 (예: "건괘")
  persona_id?: string       // 'basic' | 'friendly' | 'strict'
  search_context?: string   // Flutter에서 전달된 로컬 검색 결과
}

interface DocumentResult {
  content: string
  section?: string
  source_lang?: string
  metadata?: Record<string, unknown>
  similarity?: number
  weighted_rank?: number
}

// ─── CORS 헤더 ────────────────────────────────────────────

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

// ─── 페르소나 프롬프트 ────────────────────────────────────

const PERSONA_PROMPTS: Record<string, string> = {
  basic: '답변 시 차분하고 격식 있는 말투를 사용해 주세요. 고전의 깊은 지혜가 느껴지도록 문장을 구성하고, 사용자에게 예의를 갖추어 조언을 건넵니다.',
  friendly: '답변 시 다정하고 따뜻한 말투를 사용해 주세요. 사용자의 고민에 깊이 공감하고 위로와 격려를 건네며, 친근한 조언자처럼 부드럽게 대화를 이끌어 주세요.',
  strict: '답변 시 군더더기 없이 핵심만 짚어서 간결하고 명확하게 말씀해 주세요. 감정적인 서술보다는 논리적이고 객관적인 상황 분석을 우선하며, 단도직입적으로 해결책이나 고찰을 제시합니다.',
}

// ─── 주역 시스템 프롬프트 (3단계 구조) ────────────────────

function buildIChingSystemPrompt(hexagramName: string, contexts: DocumentResult[]): string {
  const contextBlock = contexts.length > 0
    ? contexts.map((c, i) => `[참고 원문 ${i + 1}]\n${c.content}`).join('\n\n')
    : ''

  return `당신은 주역(周易)에 정통한 학자이자 해설가입니다.

사용자가 뽑은 괘는 '${hexagramName}'입니다.

${contextBlock ? `다음은 이 괘와 관련된 주역 원전 내용입니다:\n\n${contextBlock}\n\n` : ''}다음 3단계로 답변해 주세요:

**1단계: 점괘 결과**
- 이 괘의 전체적인 길흉(吉凶) 판단을 먼저 밝혀 주세요.
- 사용자의 질문 맥락에 맞춰 핵심 메시지를 한두 줄로 정리합니다.

**2단계: 원전 해석**
- 괘사(卦辭)와 효사(爻辭)를 인용하며 근거를 제시해 주세요.
- 상전(象傳), 단전(彖傳) 등 전(傳)의 해석도 포함합니다.

**3단계: 쉬운 풀이**
- 현대적 상황에 비유하여 누구나 이해할 수 있도록 풀어서 설명합니다.
- 사용자의 고민에 대한 구체적인 조언으로 마무리합니다.`
}

// ─── 불경 시스템 프롬프트 (2단계 구조) ────────────────────

function buildTripitakaSystemPrompt(contexts: DocumentResult[], searchContext?: string): string {
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
- 사용자의 질문에 대한 구체적인 답을 제시하며 마무리합니다.`
}

// ─── Gemini 임베딩 생성 ───────────────────────────────────

async function generateEmbedding(text: string, apiKey: string): Promise<number[]> {
  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/text-embedding-004:embedContent?key=${apiKey}`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: 'models/text-embedding-004',
        content: { parts: [{ text }] },
      }),
    }
  )

  if (!response.ok) {
    const err = await response.text()
    console.error('[Embedding Error]', err)
    throw new Error(`Embedding 생성 실패: ${response.status}`)
  }

  const data = await response.json()
  return data.embedding.values
}

// ─── 문서 검색: 주역 (벡터 → 키워드 폴백) ────────────────

async function searchIChingDocuments(
  supabase: ReturnType<typeof createClient>,
  query: string,
  geminiApiKey: string,
): Promise<DocumentResult[]> {
  // 1차: 벡터 유사도 검색
  try {
    const embedding = await generateEmbedding(query, geminiApiKey)
    const { data, error } = await supabase.rpc('match_i_ching_documents', {
      query_embedding: embedding,
      match_threshold: 0.3,
      match_count: 10,
    })

    if (!error && data && data.length > 0) {
      console.log(`[Search] 주역 벡터 검색 ${data.length}건 히트`)
      return data.slice(0, 4) as DocumentResult[]
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
    return []
  }

  console.log(`[Search] 주역 키워드 검색 ${data?.length ?? 0}건 히트`)
  return (data ?? []).slice(0, 4) as DocumentResult[]
}

// ─── 문서 검색: 불경 (키워드) ─────────────────────────────

async function searchTripitakaDocuments(
  supabase: ReturnType<typeof createClient>,
  query: string,
): Promise<DocumentResult[]> {
  const { data, error } = await supabase.rpc('search_tripitaka_documents', {
    query_text: query,
    match_count: 10,
  })

  if (error) {
    console.error('[Search] 불경 키워드 검색 실패:', error)
    return []
  }

  console.log(`[Search] 불경 검색 ${data?.length ?? 0}건 히트`)
  return (data ?? []).slice(0, 4) as DocumentResult[]
}

// ─── 캐시 관리 (주역 전용) ────────────────────────────────

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
    .select('interpretation')
    .eq('query_hash', queryHash)
    .single()

  if (data?.interpretation) {
    // hit_count 증가
    await supabase
      .from('i_ching_cache')
      .update({ hit_count: (data as any).hit_count + 1 || 1 })
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

// ─── Claude API 스트리밍 호출 ─────────────────────────────

async function streamClaude(
  messages: ChatMessage[],
  apiKey: string,
): Promise<ReadableStream> {
  const systemMessages = messages.filter(m => m.role === 'system')
  const nonSystemMessages = messages.filter(m => m.role !== 'system')
  const systemPrompt = systemMessages.map(m => m.content).join('\n\n')

  const response = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': apiKey,
      'anthropic-version': '2023-06-01',
    },
    body: JSON.stringify({
      model: 'claude-sonnet-4-20250514',
      max_tokens: 4096,
      system: systemPrompt || undefined,
      messages: nonSystemMessages.map(m => ({
        role: m.role,
        content: m.content,
      })),
      stream: true,
    }),
  })

  if (!response.ok) {
    const err = await response.text()
    console.error('[Claude Error]', err)
    throw new Error(`Claude API 오류: ${response.status}`)
  }

  return response.body!
}

// ─── Gemini API 스트리밍 호출 (대안) ──────────────────────

async function streamGemini(
  messages: ChatMessage[],
  apiKey: string,
): Promise<ReadableStream> {
  const systemMessages = messages.filter(m => m.role === 'system')
  const nonSystemMessages = messages.filter(m => m.role !== 'system')
  const systemInstruction = systemMessages.map(m => m.content).join('\n\n')

  const contents = nonSystemMessages.map(m => ({
    role: m.role === 'assistant' ? 'model' : 'user',
    parts: [{ text: m.content }],
  }))

  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:streamGenerateContent?alt=sse&key=${apiKey}`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        system_instruction: systemInstruction ? { parts: [{ text: systemInstruction }] } : undefined,
        contents,
        generationConfig: {
          maxOutputTokens: 4096,
        },
      }),
    }
  )

  if (!response.ok) {
    const err = await response.text()
    console.error('[Gemini Error]', err)
    throw new Error(`Gemini API 오류: ${response.status}`)
  }

  return response.body!
}

// ─── SSE 변환: Claude API 응답 → 클라이언트 SSE 포맷 ─────

function transformClaudeStream(sourceStream: ReadableStream): ReadableStream {
  const reader = sourceStream.getReader()
  const decoder = new TextDecoder()
  const encoder = new TextEncoder()
  let buffer = ''

  return new ReadableStream({
    async pull(controller) {
      try {
        const { done, value } = await reader.read()
        if (done) {
          controller.enqueue(encoder.encode('data: [DONE]\n\n'))
          controller.close()
          return
        }

        buffer += decoder.decode(value, { stream: true })
        const lines = buffer.split('\n')
        buffer = lines.pop() || ''

        for (const line of lines) {
          const trimmed = line.trim()
          if (!trimmed.startsWith('data: ')) continue
          if (trimmed === 'data: [DONE]') continue

          try {
            const data = JSON.parse(trimmed.substring(6))

            // content_block_delta 이벤트에서 텍스트 추출
            if (data.type === 'content_block_delta' && data.delta?.text) {
              controller.enqueue(encoder.encode(`data: ${JSON.stringify({ text: data.delta.text })}\n\n`))
            }
            // message_stop 이벤트
            if (data.type === 'message_stop') {
              controller.enqueue(encoder.encode('data: [DONE]\n\n'))
              controller.close()
              return
            }
          } catch {
            // JSON 파싱 실패 시 무시
          }
        }
      } catch (e) {
        console.error('[Stream Transform Error]', e)
        controller.enqueue(encoder.encode('data: [DONE]\n\n'))
        controller.close()
      }
    },
  })
}

// ─── SSE 변환: Gemini API 응답 → 클라이언트 SSE 포맷 ─────

function transformGeminiStream(sourceStream: ReadableStream): ReadableStream {
  const reader = sourceStream.getReader()
  const decoder = new TextDecoder()
  const encoder = new TextEncoder()
  let buffer = ''

  return new ReadableStream({
    async pull(controller) {
      try {
        const { done, value } = await reader.read()
        if (done) {
          controller.enqueue(encoder.encode('data: [DONE]\n\n'))
          controller.close()
          return
        }

        buffer += decoder.decode(value, { stream: true })
        const lines = buffer.split('\n')
        buffer = lines.pop() || ''

        for (const line of lines) {
          const trimmed = line.trim()
          if (!trimmed.startsWith('data: ')) continue

          try {
            const data = JSON.parse(trimmed.substring(6))
            const text = data.candidates?.[0]?.content?.parts?.[0]?.text
            if (text) {
              controller.enqueue(encoder.encode(`data: ${JSON.stringify({ text })}\n\n`))
            }
          } catch {
            // JSON 파싱 실패 시 무시
          }
        }
      } catch (e) {
        console.error('[Gemini Stream Transform Error]', e)
        controller.enqueue(encoder.encode('data: [DONE]\n\n'))
        controller.close()
      }
    },
  })
}

// ─── 캐시 히트 시 non-streaming 응답 생성 ─────────────────

function createCachedSSEStream(text: string): ReadableStream {
  const encoder = new TextEncoder()
  const chunks = text.match(/.{1,50}/g) || [text]
  let index = 0

  return new ReadableStream({
    pull(controller) {
      if (index < chunks.length) {
        controller.enqueue(encoder.encode(`data: ${JSON.stringify({ text: chunks[index] })}\n\n`))
        index++
      } else {
        controller.enqueue(encoder.encode('data: [DONE]\n\n'))
        controller.close()
      }
    },
  })
}

// ─── 메인 핸들러 ──────────────────────────────────────────

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { messages, topic_code, hexagram_id, persona_id, search_context } = await req.json() as ChatRequest

    if (!messages || !Array.isArray(messages)) {
      throw new Error('messages 배열이 필요합니다.')
    }

    // ── 환경 변수 로드 ──
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const claudeApiKey = Deno.env.get('ANTHROPIC_API_KEY')
    const geminiApiKey = Deno.env.get('GEMINI_API_KEY')

    if (!claudeApiKey && !geminiApiKey) {
      throw new Error('ANTHROPIC_API_KEY 또는 GEMINI_API_KEY가 필요합니다.')
    }

    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    // ── 마지막 사용자 메시지 추출 (검색 쿼리로 사용) ──
    const userMessages = messages.filter(m => m.role === 'user')
    const latestUserMessage = userMessages[userMessages.length - 1]?.content || ''

    // ── topic_code별 RAG 검색 + 시스템 프롬프트 구성 ──
    const finalMessages: ChatMessage[] = []
    let fullResponseForCache = ''
    let shouldCache = false

    // hexagram_id는 Flutter에서 괘 이름(string) 또는 번호(string)로 전달됨
    const hexagramNumber = hexagram_id ? parseInt(hexagram_id, 10) : null

    if (topic_code === 'iching' && hexagram_id) {
      // ── 주역 플로우 ──

      // 캐시 확인 (질문이 1개이고 대화 이력이 없는 경우만)
      if (userMessages.length === 1 && latestUserMessage && hexagramNumber) {
        const cached = await getCachedResponse(supabase, hexagramNumber, latestUserMessage)
        if (cached) {
          console.log('[Cache Hit] 주역 캐시 히트')
          return new Response(createCachedSSEStream(cached), {
            headers: {
              ...corsHeaders,
              'Content-Type': 'text/event-stream',
              'Cache-Control': 'no-cache',
            },
          })
        }
        shouldCache = true
      }

      // 벡터 → 키워드 폴백 검색
      const contexts = geminiApiKey
        ? await searchIChingDocuments(supabase, latestUserMessage, geminiApiKey)
        : []

      // 시스템 프롬프트 구성
      finalMessages.push({
        role: 'system',
        content: buildIChingSystemPrompt(hexagram_id, contexts),
      })

    } else if (topic_code === 'tripitaka') {
      // ── 불경 플로우 ──
      const contexts = await searchTripitakaDocuments(supabase, latestUserMessage)

      finalMessages.push({
        role: 'system',
        content: buildTripitakaSystemPrompt(contexts, search_context),
      })

    } else {
      // ── 일반 대화 (RAG 없음) ──
      finalMessages.push({
        role: 'system',
        content: '당신은 동양 고전과 철학에 깊은 지식을 가진 지혜로운 상담사입니다. 사용자의 질문에 성심성의껏 답변해 주세요.',
      })
    }

    // ── 페르소나 프롬프트 추가 ──
    if (persona_id && PERSONA_PROMPTS[persona_id]) {
      finalMessages.push({
        role: 'system',
        content: PERSONA_PROMPTS[persona_id],
      })
    }

    // ── 대화 이력 + 현재 메시지 추가 ──
    finalMessages.push(...messages.filter(m => m.role !== 'system'))

    // ── LLM 호출 (Claude 우선, Gemini 폴백) ──
    let outputStream: ReadableStream

    if (claudeApiKey) {
      try {
        const rawStream = await streamClaude(finalMessages, claudeApiKey)
        outputStream = transformClaudeStream(rawStream)
      } catch (e) {
        console.error('[Claude Fallback]', e)
        if (!geminiApiKey) throw e
        const rawStream = await streamGemini(finalMessages, geminiApiKey)
        outputStream = transformGeminiStream(rawStream)
      }
    } else {
      const rawStream = await streamGemini(finalMessages, geminiApiKey!)
      outputStream = transformGeminiStream(rawStream)
    }

    // ── 캐시 수집을 위한 스트림 분기 (주역 + 첫 질문인 경우) ──
    if (shouldCache && hexagramNumber) {
      const [streamForClient, streamForCache] = outputStream.tee()

      // 백그라운드에서 캐시 수집
      const cacheReader = streamForCache.getReader()
      const cacheDecoder = new TextDecoder()

      ;(async () => {
        try {
          let fullText = ''
          while (true) {
            const { done, value } = await cacheReader.read()
            if (done) break
            const chunk = cacheDecoder.decode(value, { stream: true })
            const lines = chunk.split('\n')
            for (const line of lines) {
              const trimmed = line.trim()
              if (trimmed.startsWith('data: ') && trimmed !== 'data: [DONE]') {
                try {
                  const data = JSON.parse(trimmed.substring(6))
                  if (data.text) fullText += data.text
                } catch { /* ignore */ }
              }
            }
          }
          if (fullText) {
            await setCachedResponse(supabase, hexagramNumber!, latestUserMessage, fullText)
            console.log('[Cache] 주역 응답 캐시 저장 완료')
          }
        } catch (e) {
          console.error('[Cache Error]', e)
        }
      })()

      outputStream = streamForClient
    }

    return new Response(outputStream, {
      headers: {
        ...corsHeaders,
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache',
      },
    })

  } catch (error) {
    console.error('[Chat Error]', error)
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})
