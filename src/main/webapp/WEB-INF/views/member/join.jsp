<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
    <link rel="icon" href="/img/favicon.png" />
    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">
    <title>로그인 | 승요일기</title>
</head>

<body class="page-login">

    <div class="page-login_wrap">
        <div class="login-card">
            <div class="login">
                <div class="login_logo" aria-hidden="true">
                    <img src="/img/logo.svg" alt="로고 이미지">
                </div>
            </div>

            <form class="login-form" id="serverLoginForm" action="/member/login" method="post">
                <div class="login-field_wrap">
                    <div class="login-field">
                        <input class="login-input" id="loginId" name="email" type="text" inputmode="email" autocomplete="username" placeholder="아이디(이메일)를 입력해주세요" required />
                    </div>

                    <div class="login-field">
                        <div class="login-inputwrap">
                            <input class="login-input" id="loginPw" name="password" type="password" autocomplete="current-password" placeholder="비밀번호를 입력해주세요" required/>
                            <button class="login-eye" type="button" id="togglePw" aria-label="비밀번호 표시">
                                <img src="/img/pass_off.svg" alt="비밀번호 보기">
                            </button>
                        </div>

                        <div class="login-message ${not empty error ? 'is-show is-error' : ''}" id="loginMessage" role="status">
                            ${error}
                        </div>
                    </div>
                </div>
                <div class="login-bottom">
                    <div class="login-actions">
                        <button class="login-btn btn-primary" type="submit" id="loginBtn">
                            이메일로 계속하기
                        </button>
                    </div>

                    <div class="login-options">
                        <label class="check">
                            <input type="checkbox" name="remember" id="remember" />
                            자동 로그인
                        </label>
                        <a class="login-link" href="/member/find-password">비밀번호 찾기</a>
                    </div>

                    <div class="login-kakao">
                        <p>또는</p>
                        <button class="login-btn btn-kakao" type="button" onclick="alert('준비중입니다.')">
                            카카오 로그인
                        </button>
                    </div>

                    <ul class="join mt-16">
                        <li><a href="/member/join">회원가입</a></li>
                        <li><a href="/member/find-id">계정찾기</a></li>
                    </ul>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="/js/script.js"></script>
    <script>
        // script.js의 토글 기능은 ID 기반이므로 form ID가 바뀌어도 정상 작동합니다.
        // 혹시 작동하지 않을 경우를 대비한 안전 장치
        document.addEventListener('DOMContentLoaded', () => {
            const pwInput = document.getElementById('loginPw');
            const toggleBtn = document.getElementById('togglePw');
            if(pwInput && toggleBtn && !toggleBtn.onclick) {
                // script.js가 바인딩하지 못했을 경우 수동 바인딩
                toggleBtn.addEventListener('click', () => {
                    const isHidden = pwInput.type === 'password';
                    pwInput.type = isHidden ? 'text' : 'password';
                    toggleBtn.querySelector('img').src = isHidden ? '/img/pass_on.svg' : '/img/pass_off.svg';
                });
            }
        });
    </script>
</body>
</html>