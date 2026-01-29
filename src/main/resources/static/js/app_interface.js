/* ==========================================
   [Appify SDK] 초기화 및 푸시 토큰 연동
   ========================================== */
document.addEventListener('DOMContentLoaded', async function() {
    // 1. SDK 로드 여부 확인
    if (typeof appify === 'undefined') return;

    try {
        // [초기화] 디버그 모드 활성화 (개발 중: true, 배포 시: false 권장)
        await appify.initialize({ debug: false });

        // 2. 앱 환경인지 확인
        if (appify.isWebview) {
            console.log("Appify 앱 환경 감지됨 📱");

            // [푸시 알림] 권한 확인 및 토큰 획득
            const isAllowed = await appify.notification.checkPermission();
            if (isAllowed) {
                const token = await appify.notification.getToken();
                if (token) {
                    console.log("FCM Token:", token);
                    updateServerToken(token); // 서버 전송
                }
            } else {
                console.warn("알림 권한이 없습니다.");
            }
        }
    } catch (e) {
        console.error("Appify SDK 초기화 오류:", e);
    }
});

// [서버 통신] 토큰 DB 저장 (중복 호출 방지)
function updateServerToken(token) {
    const oldToken = localStorage.getItem("fcm_token");
    if (token === oldToken) return;

    $.post('/member/updateToken', { token: token }, function(res) {
        if(res === 'ok') {
            console.log("서버에 토큰 저장 완료 ✅");
            localStorage.setItem("fcm_token", token);
        }
    });
}