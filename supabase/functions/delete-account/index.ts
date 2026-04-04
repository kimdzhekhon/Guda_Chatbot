import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const _allowedOrigins = (Deno.env.get('ALLOWED_ORIGINS') ?? '').split(',').map(s => s.trim()).filter(Boolean)

function getCorsHeaders(req?: Request) {
  const origin = req?.headers.get('Origin') ?? ''
  const isAllowed = _allowedOrigins.includes(origin)
  return {
    'Access-Control-Allow-Origin': isAllowed ? origin : _allowedOrigins[0] || '',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Max-Age': '86400',
    'Vary': 'Origin',
    'X-Content-Type-Options': 'nosniff',
    'X-Frame-Options': 'DENY',
  }
}

serve(async (req) => {
  const corsHeaders = getCorsHeaders(req)

  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'POST 메서드만 허용됩니다.' }),
      { status: 405, headers: { ...corsHeaders, 'Content-Type': 'application/json' } })
  }
  const contentLength = parseInt(req.headers.get('content-length') || '0')
  if (contentLength > 10000) {
    return new Response(JSON.stringify({ error: '요청이 너무 큽니다.' }),
      { status: 413, headers: { ...corsHeaders, 'Content-Type': 'application/json' } })
  }

  try {
    // 1. JWT 인증 확인
    const authHeader = req.headers.get('Authorization')
    if (!authHeader?.startsWith('Bearer ')) {
      return new Response(
        JSON.stringify({ error: '인증 토큰이 필요합니다.' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      )
    }

    // 2. Service Role 클라이언트 (RLS 우회)
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const adminClient = createClient(supabaseUrl, supabaseServiceKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    })

    // 3. JWT에서 유저 검증
    const token = authHeader.replace('Bearer ', '')
    const { data: { user }, error: userError } = await adminClient.auth.getUser(token)
    if (userError || !user) {
      console.error('[Auth]', userError?.message)
      return new Response(
        JSON.stringify({ error: '유효하지 않은 인증입니다.' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      )
    }

    const userId = user.id
    const userEmail = user.email || ''
    const provider = user.app_metadata?.provider || 'unknown'
    console.log(`[DeleteAccount] 시작: ${userId.substring(0, 8)}***`)

    // 4. 탈퇴 기록 저장 (30일 재가입 방지용)
    const { error: recordErr } = await adminClient
      .from('deleted_accounts')
      .insert({ email: userEmail, provider, user_id: userId })
    if (recordErr) console.error('[DeleteAccount] 탈퇴 기록 저장 실패:', recordErr?.message ?? 'unknown')

    // 5. SECURITY DEFINER RPC로 사용자 데이터 일괄 삭제
    //    (messages, chat_usage_logs, chat_rooms, user_subscriptions, profiles)
    //    transaction_logs는 결제 감사 이력으로 보존
    const { error: rpcErr } = await adminClient.rpc('delete_user_data', {
      target_user_id: userId,
    })
    if (rpcErr) {
      console.error('[DeleteAccount] delete_user_data RPC 실패:', rpcErr?.message ?? 'unknown')
      return new Response(
        JSON.stringify({ error: '사용자 데이터 삭제에 실패했습니다.' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      )
    }

    // 6. auth.users 삭제
    const { error: deleteError } = await adminClient.auth.admin.deleteUser(userId)
    if (deleteError) {
      console.error('[DeleteAccount] auth.users 삭제 실패:', deleteError?.message ?? 'unknown')
      return new Response(
        JSON.stringify({ error: '계정 삭제에 실패했습니다. 잠시 후 다시 시도해 주세요.' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      )
    }

    console.log(`[DeleteAccount] 완료: ${userId.substring(0, 8)}***`)
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
