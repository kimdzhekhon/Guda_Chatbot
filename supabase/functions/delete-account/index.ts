import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

// 허용된 Origin 목록 (운영 배포 시 실제 도메인으로 교체)
const ALLOWED_ORIGINS = [
  'http://localhost',
  'https://guda-chatbot.vercel.app',
]

function getCorsHeaders(req: Request) {
  const origin = req.headers.get('Origin') || ''
  const allowedOrigin = ALLOWED_ORIGINS.find(o => origin.startsWith(o)) || ALLOWED_ORIGINS[0]
  return {
    'Access-Control-Allow-Origin': allowedOrigin,
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  }
}

serve(async (req) => {
  const corsHeaders = getCorsHeaders(req)

  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // 1. 요청자의 JWT에서 사용자 인증 확인
    const authHeader = req.headers.get('Authorization')
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return new Response(
        JSON.stringify({ error: '인증 토큰이 필요합니다.' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      )
    }

    // 2. Service Role 클라이언트로 JWT에서 유저 검증
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!

    const adminClient = createClient(supabaseUrl, supabaseServiceKey)

    const token = authHeader.replace('Bearer ', '')
    const { data: { user }, error: userError } = await adminClient.auth.getUser(token)
    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: '유효하지 않은 인증입니다.' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      )
    }

    // 3. 트랜잭션으로 사용자 데이터 삭제 (원자적 처리)
    //    profiles에 ON DELETE CASCADE가 설정되어 있으므로
    //    profiles 삭제 시 chat_rooms, user_subscriptions, chat_usage_logs 등이 연쇄 삭제됨.
    //    단, auth.users 삭제가 실패하면 public 데이터만 남는 것을 방지하기 위해
    //    auth.users를 먼저 삭제 (auth.users → profiles CASCADE 연쇄)
    const { error: deleteError } = await adminClient.auth.admin.deleteUser(user.id)
    if (deleteError) {
      return new Response(
        JSON.stringify({ error: '계정 삭제에 실패했습니다. 잠시 후 다시 시도해 주세요.' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      )
    }

    return new Response(
      JSON.stringify({ success: true }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
    )

  } catch (error) {
    console.error('[DeleteAccount Error]', error)
    return new Response(
      JSON.stringify({ error: '서버 오류가 발생했습니다.' }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
    )
  }
})
