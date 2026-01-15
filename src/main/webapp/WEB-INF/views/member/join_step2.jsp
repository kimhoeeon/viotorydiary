<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">
    <title>이메일 입력 | 승요일기</title>
</head>
<body class="page-login">
    <header class="app-header">
        <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
            <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
        </button>
    </header>

    <div class="page-login_wrap">
        <div class="login-card">
            <div class="login">
                <img src="/img/ico_check.svg" alt="체크이미지">
                <div class="login-txt">
                    <h1 class="login_title">이메일을 입력해 주세요</h1>
                </div>
            </div>

            <div class="login-form gap-50">
                <div class="login-field_wrap gap-16">
                    <div class="login-field">
                        <input class="login-input" id="loginId" type="text" inputmode="email" autocomplete="username" placeholder="아이디(이메일)을 입력해주세요">
                        <div class="login-message" id="loginMessage" role="status"></div>
                        <span class="login-message login-message-right" onclick="document.getElementById('loginId').value='';"><img src="/img/ico_clear.svg" alt="삭제"></span>
                    </div>
                </div>
                <div class="login-bottom">
                    <div class="login-actions">
                        <button class="join-btn btn-primary" id="termsNext" disabled onclick="goNext()">
                            다음
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="/js/script.js"></script>
    <script>
        const emailInput = document.getElementById('loginId');
        const nextBtn = document.getElementById('termsNext');
        const msg = document.getElementById('loginMessage');

        emailInput.addEventListener('input', () => {
            const val = emailInput.value;
            // 간단한 이메일 정규식
            const isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val);

            if (isValid) {
                nextBtn.disabled = false;
                msg.textContent = '';
                msg.classList.remove('is-show', 'is-error');
            } else {
                nextBtn.disabled = true;
                msg.textContent = '올바른 이메일 형식이 아닙니다.';
                msg.classList.add('is-show', 'is-error');
            }
        });

        function goNext() {
            sessionStorage.setItem('join_email', emailInput.value);
            location.href = '/member/join/step3';
        }
    </script>
</body>
</html>