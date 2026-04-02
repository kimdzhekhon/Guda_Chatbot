/**
 * 문서 데이터 시딩 스크립트
 *
 * lib/data/tripitaka/ 의 JSON 청크 파일을 읽어서 Supabase 테이블에 삽입합니다.
 * 주역 문서는 Gemini 임베딩도 함께 생성합니다.
 *
 * 사용법:
 *   1. 환경 변수 설정:
 *      export SUPABASE_URL=https://xxx.supabase.co
 *      export SUPABASE_SERVICE_ROLE_KEY=eyJ...
 *      export GEMINI_API_KEY=AIza...
 *
 *   2. 실행:
 *      deno run --allow-read --allow-net --allow-env scripts/seed_documents.ts
 *
 * JSON 실제 구조:
 *   zhouyi-chunks.json:
 *     [{ "id": "주역_상경_chunk0", "content": "...", "metadata": { "volume": 0, "chapter": "주역 상경", "source": "주역 상경" } }]
 *
 *   tripitaka-chunks.json:
 *     [{ "id": "tripitaka_금강경_001_chunk0", "content": "...", "metadata": { "volume": 1, "chapter": "...", "source": "팔만대장경: 금강경" } }]
 *
 *   guda-chunks.json:
 *     [{ "id": "vol1_chunk0", "content": "...", "metadata": { "volume": 0, "chapter": "...", "source": "..." } }]
 */

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0"

// ─── 환경 변수 ────────────────────────────────────────────

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error('SUPABASE_URL과 SUPABASE_SERVICE_ROLE_KEY 환경 변수가 필요합니다.')
  Deno.exit(1)
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

// ─── Gemini 임베딩 생성 ───────────────────────────────────

async function generateEmbedding(text: string): Promise<number[]> {
  if (!GEMINI_API_KEY) throw new Error('GEMINI_API_KEY가 필요합니다.')

  // 임베딩 API는 최대 ~10000 토큰 → 긴 텍스트는 앞부분만 사용
  const truncated = text.slice(0, 8000)

  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/text-embedding-004:embedContent?key=${GEMINI_API_KEY}`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: 'models/text-embedding-004',
        content: { parts: [{ text: truncated }] },
      }),
    }
  )

  if (!response.ok) {
    const err = await response.text()
    throw new Error(`Embedding 실패: ${response.status} - ${err}`)
  }

  const data = await response.json()
  return data.embedding.values
}

// ─── 배치 삽입 유틸 ───────────────────────────────────────

async function insertBatch<T>(
  table: string,
  rows: T[],
  batchSize = 50,
): Promise<number> {
  let inserted = 0
  for (let i = 0; i < rows.length; i += batchSize) {
    const batch = rows.slice(i, i + batchSize)
    const { error } = await supabase.from(table).insert(batch)
    if (error) {
      console.error(`[${table}] 배치 ${i}~${i + batch.length} 삽입 실패:`, error.message)
    } else {
      inserted += batch.length
    }
    if (inserted % 500 === 0 || i + batchSize >= rows.length) {
      console.log(`[${table}] ${inserted}/${rows.length} 삽입 완료`)
    }
  }
  return inserted
}

// ─── JSON 파일 로드 ───────────────────────────────────────

async function loadJson<T>(path: string): Promise<T[]> {
  try {
    const text = await Deno.readTextFile(path)
    return JSON.parse(text)
  } catch (e) {
    console.warn(`[경고] ${path} 파일을 찾을 수 없습니다: ${e.message}`)
    return []
  }
}

// ─── 주역 섹션 판별 ──────────────────────────────────────

function detectSection(id: string, metadata: Record<string, unknown>): string | null {
  const chapter = (metadata?.chapter as string) || ''
  const source = (metadata?.source as string) || ''
  const combined = `${id} ${chapter} ${source}`

  if (combined.includes('상경')) return 'upper'
  if (combined.includes('하경')) return 'lower'
  if (combined.includes('단전') || combined.includes('상전') || combined.includes('단상전')) return 'commentary'
  if (combined.includes('계사') || combined.includes('설괘') || combined.includes('서괘') || combined.includes('잡괘')) return 'commentary'
  return null
}

// ─── 불경 언어 판별 ──────────────────────────────────────

function detectLanguage(id: string, content: string): string {
  // id에 '원문' 포함 → 한문
  if (id.includes('원문')) return 'zh'

  // 내용 분석: 한자 비율로 판별
  const cjkChars = content.match(/[\u4e00-\u9fff]/g)?.length || 0
  const hangulChars = content.match(/[\uac00-\ud7af]/g)?.length || 0
  const totalChars = content.length

  if (totalChars === 0) return 'ko'

  const cjkRatio = cjkChars / totalChars
  const hangulRatio = hangulChars / totalChars

  if (cjkRatio > 0.3 && cjkRatio > hangulRatio) return 'zh'
  if (hangulRatio > 0.1) return 'ko'

  // 영어 판별
  const englishChars = content.match(/[a-zA-Z]/g)?.length || 0
  if (englishChars / totalChars > 0.3) return 'en'

  // 산스크리트 (데바나가리)
  const devanagari = content.match(/[\u0900-\u097f]/g)?.length || 0
  if (devanagari / totalChars > 0.1) return 'sa'

  return 'ko'
}

// ─── 주역 문서 시딩 (임베딩 포함) ─────────────────────────

interface ChunkData {
  id: string
  content: string
  metadata?: Record<string, unknown>
}

async function seedIChing() {
  const chunks = await loadJson<ChunkData>('lib/data/tripitaka/zhouyi-chunks.json')
  if (chunks.length === 0) {
    console.log('[주역] 데이터 없음, 건너뜀')
    return
  }

  console.log(`[주역] ${chunks.length}개 청크 시딩 시작...`)

  const rows = []
  for (let i = 0; i < chunks.length; i++) {
    const chunk = chunks[i]
    let embedding: number[] | null = null

    if (GEMINI_API_KEY) {
      try {
        embedding = await generateEmbedding(chunk.content)
        // Rate limit 대응 (분당 1500 요청 제한)
        if (i % 30 === 29) {
          console.log(`[주역] 임베딩 ${i + 1}/${chunks.length} 생성 완료, 대기 중...`)
          await new Promise(r => setTimeout(r, 3000))
        }
      } catch (e) {
        console.error(`[주역] 임베딩 생성 실패 (${i}):`, e.message)
        // 429 에러 시 더 오래 대기
        if (e.message.includes('429')) {
          console.log('[주역] Rate limit, 30초 대기...')
          await new Promise(r => setTimeout(r, 30000))
        }
      }
    }

    rows.push({
      content: chunk.content,
      section: detectSection(chunk.id, chunk.metadata || {}),
      hexagram_number: null,  // 청크 단위에서는 특정 괘 번호 추출이 어려움
      metadata: { ...(chunk.metadata || {}), original_id: chunk.id },
      embedding: embedding ? `[${embedding.join(',')}]` : null,
    })
  }

  const inserted = await insertBatch('i_ching_documents', rows)
  console.log(`[주역] 시딩 완료: ${inserted}/${chunks.length}건`)
}

// ─── 불경/구사론 문서 시딩 ────────────────────────────────

async function seedTripitaka() {
  const tripitakaChunks = await loadJson<ChunkData>('lib/data/tripitaka/tripitaka-chunks.json')
  const gudaChunks = await loadJson<ChunkData>('lib/data/tripitaka/guda-chunks.json')

  const allChunks = [
    ...tripitakaChunks.map(c => ({ ...c, source: 'tripitaka' as const })),
    ...gudaChunks.map(c => ({ ...c, source: 'guda' as const })),
  ]

  if (allChunks.length === 0) {
    console.log('[불경] 데이터 없음, 건너뜀')
    return
  }

  console.log(`[불경] ${allChunks.length}개 청크 시딩 시작 (tripitaka: ${tripitakaChunks.length}, guda: ${gudaChunks.length})...`)

  const rows = allChunks.map(chunk => ({
    content: chunk.content,
    source: chunk.source,
    source_lang: detectLanguage(chunk.id, chunk.content),
    metadata: { ...(chunk.metadata || {}), original_id: chunk.id },
  }))

  const inserted = await insertBatch('tripitaka_documents', rows)
  console.log(`[불경] 시딩 완료: ${inserted}/${allChunks.length}건`)
}

// ─── 메인 실행 ────────────────────────────────────────────

async function main() {
  console.log('=== Guda Chatbot 문서 시딩 시작 ===')
  console.log(`Supabase URL: ${SUPABASE_URL}`)
  console.log(`Gemini API Key: ${GEMINI_API_KEY ? '설정됨' : '미설정 (임베딩 생략)'}`)
  console.log('')

  await seedIChing()
  console.log('')
  await seedTripitaka()

  console.log('')
  console.log('=== 시딩 완료 ===')
}

main()
