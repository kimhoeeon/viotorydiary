<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">
    <title>닉네임 입력 | 승요일기</title>
</head>
<body class="page-login">
    <header class="app-header">
        <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
            <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
        </button>
    </header>

    <div class="page-login_wrap">
        <div class="login-form gap-50">
            <div class="login-field">
                <input class="login-input" id="nickname" type="text" placeholder="닉네임 (2~6자)">
                <p id="nickErrorMsg" style="display:none; color:#FF2F32; font-size:12px; margin-top:5px; padding-left:8px;">
                    2~6자리의 한글 또는 영문만 가능합니다.
                </p>
            </div>
            <div class="login-bottom">
                <button class="join-btn btn-primary" id="finalBtn" onclick="submitJoin()">가입 완료</button>
            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>

    <script>
        /* * [비정상 접근 차단]
         * 페이지 진입 시점에 이전 단계 데이터가 있는지 체크합니다.
         */
        $(document).ready(function() {
            if (!sessionStorage.getItem('join_email')) {
                // 데이터가 없으면 경고 후 첫 단계로 이동
                alert('잘못된 접근입니다.\n처음부터 다시 시도해주세요.', function() {
                    location.replace('/member/join');
                });
            }
        });

        /* * [가입 완료 처리]
         */
        function submitJoin() {
            // 1. 닉네임 입력 체크
            const nickname = $('#nickname').val().trim();
            const errorMsg = $('#nickErrorMsg');

            // [신규] 닉네임 정규식 검사 (한글, 영문 대소문자 2~6자리)
            const nickRegex = /^[가-힣a-zA-Z]{2,6}$/;

            if (!nickname) {
                alert('닉네임을 입력해주세요.');
                return;
            }

            if (!nickRegex.test(nickname)) {
                // 입력창 아래 빨간색 에러 메시지 표시
                errorMsg.show();
                // 또는 팝업으로 알림
                alert('닉네임은 2~6자리의 한글 또는 영문만 가능합니다.');
                return;
            } else {
                errorMsg.hide();
            }

            // 전송할 데이터 준비 (세션 스토리지)
            const data = {
                email: sessionStorage.getItem('join_email'),
                password: sessionStorage.getItem('join_pw'),
                phoneNumber: sessionStorage.getItem('join_phone'),
                birthdate: sessionStorage.getItem('join_birth'),
                nickname: nickname,
                gender: 'U',
                marketingAgree: sessionStorage.getItem('join_marketing') || 'N'
            };

            // 데이터 누락 확인 (방어 로직)
            if (!data.email || !data.password || !data.phoneNumber) {
                alert('필수 정보가 누락되었습니다.\n처음부터 다시 시도해주세요.', function() {
                    location.replace('/member/join');
                });
                return;
            }

            // 4. 중복 클릭 방지
            let isSubmitting = true;
            $('#finalBtn').prop('disabled', true).text('처리중...');

            // 5. 서버 전송
            $.post('/member/join', data, function(res) {
                if (res === 'ok') {
                    // 성공 시: 세션 스토리지 비우고 완료 페이지 이동
                    sessionStorage.clear();
                    location.replace('/member/join/complete?name=' + encodeURIComponent(data.nickname));
                } else {
                    // 실패 시: 에러 메시지 출력 후 버튼 복구
                    alert(res);
                    isSubmitting = false;
                    $('#finalBtn').prop('disabled', false).text('가입 완료');
                }
            }).fail(function() {
                // 통신 오류 시
                alert('서버 통신 중 오류가 발생했습니다.');
                isSubmitting = false;
                $('#finalBtn').prop('disabled', false).text('가입 완료');
            });
        }
    </script>
</body>
</html>