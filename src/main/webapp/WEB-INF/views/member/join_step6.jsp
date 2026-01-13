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
                <input class="login-input" id="nickname" type="text" placeholder="닉네임">
            </div>
            <div class="login-bottom">
                <button class="join-btn btn-primary" id="finalBtn" onclick="submitJoin()">가입 완료</button>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    // join_step6.jsp 스크립트 전면 수정 (운영 기준)
    <script>
        // [보완 1] 비정상 접근 차단 (데이터 없이 URL로 바로 들어온 경우)
        $(document).ready(function() {
            if (!sessionStorage.getItem('join_email')) {
                alert('가입 정보가 없습니다. 처음부터 다시 진행해주세요.');
                location.replace('/member/join'); // history 남기지 않고 이동
            }
        });

        let isSubmitting = false; // 중복 전송 방지 플래그

        function submitJoin() {
            if (isSubmitting) return;

            const nickname = $('#nickname').val().trim();
            if (!nickname) {
                alert('닉네임을 입력해주세요.');
                return;
            }

            const data = {
                email: sessionStorage.getItem('join_email'),
                password: sessionStorage.getItem('join_pw'),
                phoneNumber: sessionStorage.getItem('join_phone'),
                birthdate: sessionStorage.getItem('join_birth'),
                nickname: nickname,
                gender: 'U',
                // [보완 2] 마케팅 동의 여부 전송 (값이 없으면 N 처리)
                marketingAgree: sessionStorage.getItem('join_marketing') || 'N'
            };

            // 유효성 재검증 (운영 환경 필수)
            if (!data.email || !data.password || !data.phoneNumber) {
                alert('필수 정보가 누락되었습니다.');
                location.replace('/member/join');
                return;
            }

            isSubmitting = true; // 전송 시작 -> 버튼 잠금
            $('#finalBtn').prop('disabled', true).text('처리중...');

            $.post('/member/join', data, function(res) {
                if (res === 'ok') {
                    sessionStorage.clear(); // 보안상 저장된 정보 즉시 삭제
                    // 이름 인코딩하여 전달
                    location.replace('/member/join/complete?name=' + encodeURIComponent(data.nickname));
                } else {
                    alert(res); // 에러 메시지 출력
                    isSubmitting = false;
                    $('#finalBtn').prop('disabled', false).text('가입 완료');
                }
            }).fail(function() {
                alert('서버 통신 중 오류가 발생했습니다.');
                isSubmitting = false;
                $('#finalBtn').prop('disabled', false).text('가입 완료');
            });
        }
    </script>
</body>
</html>