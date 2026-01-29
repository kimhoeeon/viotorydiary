/* ==========================================
   [Appify SDK] 초기화 및 푸시 토큰 연동
   ========================================== */
document.addEventListener('DOMContentLoaded', async function() {
    // 1. SDK 로드 여부 확인
    if (typeof appify === 'undefined') return;

    try {
        // [초기화] 디버그 모드 활성화 (개발 중: true, 배포 시: false 권장)
        await appify.initialize({
            debug: false,
            enableRefresh: true
        });

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

/* ==========================================
   [Appify] 외부 링크 처리 (시스템 브라우저로 열기)
   ========================================== */
$(document).on('click', 'a', function(e) {
    const url = $(this).attr('href');

    // http로 시작하고, 우리 도메인이 아닌 경우 외부 브라우저로 열기
    if (url && (url.startsWith('http') || url.startsWith('https'))) {
        const isMyDomain = url.includes(window.location.host);

        if (!isMyDomain) {
            e.preventDefault();
            if (typeof appify !== 'undefined' && appify.isWebview) {
                appify.linking.externalBrowser(url);
            } else {
                window.open(url, '_blank');
            }
        }
    }
});

/* ==========================================
   [UX] 햅틱 피드백 (진동)
   ========================================== */
function vibrateSuccess() {
    // 짧게 한 번 진동 (안드로이드/iOS 웹뷰 지원 시 동작)
    if (navigator.vibrate) {
        navigator.vibrate(10); // 10ms (아주 짧게)
    }
}

function vibrateError() {
    // 실패 시 웅-웅 두 번
    if (navigator.vibrate) {
        navigator.vibrate([30, 50, 30]);
    }
}