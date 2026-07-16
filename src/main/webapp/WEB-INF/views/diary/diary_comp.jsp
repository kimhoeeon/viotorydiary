<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ko">
<head>
    <meta name="naver-site-verification" content="07e0fdf4e572854d6fbe274f47714d3e7bbb9fbd" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes" />

    <meta property="og:type" content="website">
    <meta property="og:locale" content="ko_KR">
    <meta property="og:site_name" content="승요일기">
    <meta property="og:title" content="승요일기 | 야구 직관 기록 앱">
    <meta property="og:description" content="야구 직관 기록을 더 쉽고 재미있게! 경기 결과, 기록, 사진과 함께 나만의 야구 직관일기를 남겨보세요.">
    <meta name="keywords" content="승요일기 / 야구 직관 / 프로야구 직관 / 직관 후기 / 직관일기 / KBO / KBO 직관 / 프로야구 앱 / 야구팬 앱">
    <meta property="og:url" content="https://myseungyo.com/">
    <meta property="og:image" content="https://myseungyo.com/img/og_img.jpg">

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>작성 완료 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>

    <style>
        /* 리뷰 팝업 커스텀 스타일 */
        .review-popup-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); z-index: 99999; justify-content: center; align-items: center; padding: 20px; }
        .review-popup-box { background: #fff; border-radius: 16px; width: 100%; max-width: 340px; padding: 28px 24px; text-align: center; box-shadow: 0 4px 20px rgba(0,0,0,0.15); animation: popFadeIn 0.3s ease-out; }
        @keyframes popFadeIn { from { opacity: 0; transform: scale(0.95); } to { opacity: 1; transform: scale(1); } }
        .star-rating-box { display: flex; justify-content: center; gap: 8px; margin: 20px 0 28px; }
        .star-icon { width: 40px; height: 40px; cursor: pointer; filter: grayscale(100%); opacity: 0.2; transition: all 0.2s; }
        .star-icon.active { filter: none; opacity: 1; transform: scale(1.1); }
    </style>
</head>

<body>
    <div class="app comp-bg">
        <div class="app-main center">
            <div class="comp">
                <img id="randomCompImg" src="" alt="직관 일기 작성 완료">
            </div>
        </div>

        <div class="bottom-action bottom-main" style="gap: 0 !important;">
            <button type="button" class="btn border" onclick="location.href='/diary/detail?diaryId=${diary.diaryId}'">
                내가 쓴 일기 보기
            </button>
            <button type="button" class="btn btn-primary" onclick="location.href='/main'">
                홈으로
            </button>
        </div>
    </div>

    <div id="reviewPopup1" class="review-popup-overlay">
        <div class="review-popup-box">
            <h2 style="font-size:20px; font-weight:800; color:#111; margin-bottom:8px; letter-spacing:-0.5px;">승요일기, 어떠셨나요?</h2>
            <p style="font-size:15px; color:#666; margin-bottom:0;">사용 경험을 별점으로 알려주세요.</p>

            <div class="star-rating-box">
                <img src="/img/follow_star.svg" data-score="1" class="star-icon">
                <img src="/img/follow_star.svg" data-score="2" class="star-icon">
                <img src="/img/follow_star.svg" data-score="3" class="star-icon">
                <img src="/img/follow_star.svg" data-score="4" class="star-icon">
                <img src="/img/follow_star.svg" data-score="5" class="star-icon">
            </div>

            <div style="display:flex; gap:10px;">
                <button type="button" class="btn btn-gray" style="flex:1; border-radius:10px;" onclick="closeReviewPopup1()">취소</button>
                <button type="button" class="btn btn-primary" style="flex:1; border-radius:10px;" id="btnSendRating" disabled onclick="submitRating()">보내기</button>
            </div>
        </div>
    </div>

    <div id="reviewPopup2" class="review-popup-overlay">
        <div class="review-popup-box">
            <img src="/img/ico_crown.svg" alt="왕관" style="width:56px; margin:0 auto 16px; display:block;">
            <h2 style="font-size:20px; font-weight:800; color:#111; margin-bottom:10px; letter-spacing:-0.5px;">리뷰 한 줄 부탁드려요!</h2>
            <p style="font-size:15px; color:#555; margin-bottom:28px; line-height:1.5;">승요일기를 더 좋은 야구팬 앱으로<br>만드는 데 큰 도움이 됩니다.</p>

            <div style="display:flex; gap:10px;">
                <button type="button" class="btn btn-gray" style="flex:1; border-radius:10px; height:48px; background:#f4f5f7; color:#666;" onclick="closeReviewPopup2()">나중에</button>
                <button type="button" class="btn btn-primary" style="flex:1; border-radius:10px; height:48px;" onclick="openAppifyReview()">리뷰 작성하기</button>
            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js?v=1.1"></script>
    <script src="/js/app_interface.js"></script>

    <script>

        // ----------------------------------------------------
        // [스토어 설정] 실제 앱의 고유 ID를 입력해 주세요.
        // ----------------------------------------------------
        const AOS_PACKAGE_NAME = 'com.myseungyo.app'; // 구글 플레이 패키지명
        const IOS_APPLE_ID = '6760984924'; // 애플 앱스토어 ID 숫자

        // 현재 유저의 아이디와 총 작성 일기 개수
        const memberId = '${sessionScope.loginMember.memberId}';
        const currentDiaryCount = parseInt('${not empty totalDiaryCount ? totalDiaryCount : 0}', 10);
        let selectedStar = 0;

        $(document).ready(function() {
            // 랜덤 이미지 세팅 로직 (기존 유지)
            const randomNum = Math.floor(Math.random() * 5) + 1;
            $('#randomCompImg').attr('src', '/img/comp_' + randomNum + '.png');

            // 별점 클릭 이벤트
            $('.star-icon').on('click', function() {
                selectedStar = parseInt($(this).data('score'), 10);

                $('.star-icon').each(function() {
                    if (parseInt($(this).data('score'), 10) <= selectedStar) {
                        $(this).addClass('active');
                    } else {
                        $(this).removeClass('active');
                    }
                });
                $('#btnSendRating').prop('disabled', false);
            });

            // 화면 진입 후 1.2초 뒤에 리뷰 노출 조건 체크 (유저가 완료 이미지를 충분히 본 뒤)
            setTimeout(checkAndShowReviewPrompt, 1200);
        });

        // ----------------------------------------------------
        // 리뷰 팝업 노출 조건 검사 (로컬 스토리지 기반)
        // ----------------------------------------------------
        function checkAndShowReviewPrompt() {
            if (!memberId) return;

            const storageKey = 'review_state_' + memberId;
            let state = JSON.parse(localStorage.getItem(storageKey));

            // 초기 상태 세팅
            if (!state) {
                state = { isCompleted: false, promptCount: 0, lastPromptDate: null, diaryCountAtLastPrompt: 0 };
            }

            // [방어] 이미 리뷰를 남겼거나, 최대 노출 횟수(3회)를 채웠다면 무시
            if (state.isCompleted || state.promptCount >= 3) return;

            let shouldShow = false;

            if (state.promptCount === 0) {
                // [조건 1] 직관 일기 3회 작성 완료 시 최초 노출
                if (currentDiaryCount >= 3) shouldShow = true;
            } else {
                // [조건 2] 재노출 조건: 30일 경과 OR 일기 10회 추가 작성 시
                const now = new Date().getTime();
                const lastDate = new Date(state.lastPromptDate).getTime();
                const daysPassed = (now - lastDate) / (1000 * 60 * 60 * 24);
                const diariesAdded = currentDiaryCount - state.diaryCountAtLastPrompt;

                if (daysPassed >= 30 || diariesAdded >= 10) {
                    shouldShow = true;
                }
            }

            // 조건 달성 시 팝업 띄우고 상태 저장
            if (shouldShow) {
                state.promptCount += 1;
                state.lastPromptDate = new Date().toISOString();
                state.diaryCountAtLastPrompt = currentDiaryCount;
                localStorage.setItem(storageKey, JSON.stringify(state));

                $('#reviewPopup1').css('display', 'flex');
            }
        }

        // ----------------------------------------------------
        // 1차 팝업 액션 (별점에 따른 분기)
        // ----------------------------------------------------
        function submitRating() {
            $('#reviewPopup1').hide();

            // 백엔드로 별점 전송 (AJAX)
            $.post('/diary/review/save', { rating: selectedStar }, function(res) {
                if(res === 'fail:login') {
                    console.log('별점 저장을 위한 로그인 세션이 만료되었습니다.');
                }
            });

            if (selectedStar >= 4) {
                // 4~5점: 앱스토어 인앱 리뷰 유도
                setTimeout(function() {
                    $('#reviewPopup2').css('display', 'flex');
                }, 300);
            }/* else {
                // 1~3점: 내부 피드백 수집 폼으로 이동 (고객센터 1:1 문의 등 URL)
                alert("솔직한 의견을 남겨주셔서 감사합니다.\n더 나은 승요일기가 되도록 불편하신 점을 귀담아듣겠습니다!");
                location.href = '/member/mypage/inquiry';
            }*/
        }

        // ----------------------------------------------------
        // 2차 팝업 액션 (Appify 인앱 리뷰 요청)
        // ----------------------------------------------------
        async function openAppifyReview() {
            $('#reviewPopup2').hide();

            // "작성하기"를 누르면 무조건 영구 완료 상태로 마킹 (다시 안 뜨게)
            markReviewCompleted();

            if (typeof appify !== 'undefined' && appify.isWebview) {
                try {
                    const result = await appify.review.request();

                    if (result === null) {
                        console.log('이 환경에서는 인앱 리뷰를 지원하지 않습니다.');
                        fallbackToStore(); // 브릿지 미지원 시 수동 스토어 이동
                    } else if (result) {
                        console.log('리뷰 다이얼로그 표시 성공');
                    }
                } catch (error) {
                    console.error('리뷰 호출 중 오류:', error);
                    fallbackToStore(); // 에러 발생 시 수동 스토어 이동
                }
            } else {
                // 앱 웹뷰 환경이 아닌 일반 모바일/PC 웹 브라우저일 경우
                fallbackToStore();
            }
        }

        // ----------------------------------------------------
        // 스토어 수동 이동 우회 함수 (OS 감지)
        // ----------------------------------------------------
        function fallbackToStore() {
            const userAgent = navigator.userAgent.toLowerCase();
            let storeUrl = '';

            if (userAgent.indexOf("android") > -1) {
                // 안드로이드 유저
                storeUrl = 'https://play.google.com/store/apps/details?id=' + AOS_PACKAGE_NAME;
            } else if (userAgent.indexOf("iphone") > -1 || userAgent.indexOf("ipad") > -1 || userAgent.indexOf("ipod") > -1) {
                // iOS 유저
                storeUrl = 'https://apps.apple.com/app/id' + IOS_APPLE_ID + '?action=write-review';
            } else {
                // PC 등 기타 환경 (임시로 플레이스토어 연결)
                storeUrl = 'https://play.google.com/store/apps/details?id=' + AOS_PACKAGE_NAME;
            }

            alert("리뷰 작성을 위해 앱 스토어로 이동합니다.\n소중한 의견 감사합니다!");
            window.open(storeUrl, '_blank');
        }

        // 팝업 닫기 유틸
        function closeReviewPopup1() { $('#reviewPopup1').hide(); }
        function closeReviewPopup2() { $('#reviewPopup2').hide(); }

        // 로컬스토리지 리뷰 완료 마킹
        function markReviewCompleted() {
            const storageKey = 'review_state_' + memberId;
            let state = JSON.parse(localStorage.getItem(storageKey));
            if(state) {
                state.isCompleted = true;
                localStorage.setItem(storageKey, JSON.stringify(state));
            }
        }
    </script>
</body>
</html>