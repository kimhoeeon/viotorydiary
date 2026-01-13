<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">
    <title>생년월일 입력 | 승요일기</title>
</head>
<body class="page-login">
    <header class="app-header">
        <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
            <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
        </button>
    </header>

    <div class="page-login_wrap">
        <div class="login-form gap-50">
            <div class="login-field_wrap">
                <div class="dob-wrap">
                    <input class="login-input" type="date" id="birthdate" max="2012-12-31">
                </div>
                <ul class="word"><li>* 만 14세 이상 가입 가능합니다.</li></ul>
            </div>
            <div class="login-bottom">
                <button class="join-btn btn-primary" id="nextBtn" disabled onclick="goNext()">다음</button>
            </div>
        </div>
    </div>

    <script>
        const birthInput = document.getElementById('birthdate');
        const nextBtn = document.getElementById('nextBtn');

        birthInput.addEventListener('change', () => {
            if(birthInput.value) nextBtn.disabled = false;
        });

        function goNext() {
            sessionStorage.setItem('join_birth', birthInput.value);
            location.href = '/member/join/step5';
        }
    </script>
</body>
</html>