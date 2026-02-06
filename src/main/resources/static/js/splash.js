/**
 * splash.js
 * 앱 초기 실행 및 버전 체크 로직
 */

document.addEventListener('DOMContentLoaded', async () => {
    // 스크롤 방지
    document.body.classList.add('no-scroll');

    // Appify가 로드되었는지 확인 (앱 환경 체크)
    if (typeof appify !== 'undefined') {
        try {
            await checkAppVersion();
        } catch (error) {
            console.error("Version Check Error:", error);
            startSplashAnimation(); // 에러 시에도 앱 진입은 허용
        }
    } else {
        // 웹 브라우저 환경: 바로 스플래시 애니메이션 진행
        console.log("Web Environment: Skip version check");
        startSplashAnimation();
    }
});


/**
 * 앱 버전 체크 및 업데이트 분기 처리
 */
async function checkAppVersion() {
    // 1. 현재 앱 정보 가져오기
    const currentOs = appify.system.os; // 'android' or 'ios'
    const currentBuild = appify.system.build || 0; // 빌드 번호 (int)

    console.log(`[App Info] OS: ${currentOs}, Build: ${currentBuild}`);

    if (!currentOs) {
        startSplashAnimation();
        return;
    }

    // 2. 서버에 최신 버전 요청
    try {
        const response = await $.ajax({
            url: '/api/app/version',
            type: 'GET',
            data: { os: currentOs },
            dataType: 'json'
        });

        if (response.code === 'OK' && response.data) {
            const serverData = response.data;
            const latestBuild = serverData.versionCode; // DB: version_code
            const forceYn = serverData.forceUpdateYn;   // DB: force_update_yn
            const msg = serverData.message || "더 나은 서비스를 위해 업데이트가 필요합니다.";

            console.log(`[Server Info] Latest: ${latestBuild}, Force: ${forceYn}`);

            // 3. 버전 비교 (서버 버전이 현재 버전보다 크면 업데이트 필요)
            if (latestBuild > currentBuild) {
                if (forceYn === 'Y') {
                    // [A] 강제 업데이트: 취소 불가
                    // showPopup은 script.js 또는 popup.jsp에 정의된 커스텀 팝업 함수 사용
                    showPopup({
                        title: '업데이트 안내',
                        msg: msg,
                        btn: '업데이트 하러가기',
                        cancel: false // 취소 버튼 숨김 (닫기 불가)
                    }, function() {
                        moveToStore(currentOs);
                    });
                } else {
                    // [B] 선택 업데이트: 취소 가능
                    showPopup({
                        title: '업데이트 안내',
                        msg: msg,
                        btn: '업데이트',
                        cancel: true,
                        cancelBtn: '다음에 하기'
                    }, function() {
                        // 확인 클릭 시
                        moveToStore(currentOs);
                    }, function() {
                        // 취소 클릭 시 -> 앱 진입
                        startSplashAnimation();
                    });
                }
            } else {
                // 최신 버전임 -> 앱 진입
                startSplashAnimation();
            }
        } else {
            // 서버 응답 없음 -> 앱 진입
            startSplashAnimation();
        }
    } catch (e) {
        console.error("API Call Failed", e);
        startSplashAnimation();
    }
}

/**
 * 기존 스플래시 애니메이션 및 페이지 이동 로직
 */
function startSplashAnimation() {
    const splash = document.getElementById('splash');

    // 2.5초 후 페이드 아웃
    setTimeout(() => {
        splash.style.opacity = '0';

        // 0.3초 뒤(페이드 아웃 후) 요소 제거 및 페이지 이동
        setTimeout(() => {
            splash.style.display = 'none';
            document.body.classList.remove('no-scroll');

            // 로그인 여부 체크가 필요하다면 여기서 분기 처리
            // 예: 자동 로그인 토큰이 있다면 /main, 없다면 /member/login
            location.replace('/member/login');
        }, 300);
    }, 2500);
}


/**
 * 스토어 이동 함수
 */
function moveToStore(os) {
    if (os === 'android') {
        // TODO: 실제 안드로이드 패키지명 입력
        const packageId = 'com.viotory.diary';
        location.href = `market://details?id=${packageId}`;
    } else if (os === 'ios') {
        // TODO: 실제 iOS 앱스토어 ID 입력
        const appId = '123456789';
        location.href = `itms-apps://itunes.apple.com/app/id${appId}`;
    }
}

// 스크롤 방지 이벤트 리스너
document.addEventListener('touchmove', preventScroll, { passive: false });

function preventScroll(e) {
    if (document.body.classList.contains('no-scroll')) {
        e.preventDefault();
    }
}