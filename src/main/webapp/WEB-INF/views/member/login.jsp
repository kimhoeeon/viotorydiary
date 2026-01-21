<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>승요일기 - 로그인</title>
</head>

<body class="page-login">

    <div class="page-login_wrap">
        <div class="login-card">
            <div class="login">
                <div class="login_logo" aria-hidden="true">
                    <img src="/img/logo.svg" alt="로고 이미지">
                </div>
            </div>

            <form class="login-form" id="loginForm" action="/member/login" method="post" autocomplete="on">
                <div class="login-field_wrap">
                    <div class="login-field">
                        <input class="login-input" id="loginId" name="email" type="text" inputmode="email" autocomplete="username" placeholder="이메일을 입력해주세요" required />
                    </div>

                    <div class="login-field">
                        <div class="login-inputwrap">
                            <input class="login-input" id="loginPw" name="password" type="password" autocomplete="current-password" placeholder="비밀번호를 입력해주세요" required/>
                            <button class="login-eye" type="button" id="togglePw" aria-label="비밀번호 표시">
                                <img src="/img/pass_off.svg" alt="비밀번호 보기">
                            </button>
                        </div>

                        <div class="login-message" id="loginMessage" role="status" aria-live="polite"></div>
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
                        <button class="login-btn btn-kakao" type="button" onclick="alert('준비중입니다.');">
                            카카오 로그인
                        </button>
                    </div>

                    <ul class="join mt-16">
                        <li>
                            <a href="/member/join">회원가입</a>
                        </li>
                        <li>
                            <a href="/member/find-id">계정찾기</a>
                        </li>
                    </ul>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 1. 요소 선택
            const idInput = document.getElementById('loginId');
            const pwInput = document.getElementById('loginPw');
            const loginMessage = document.getElementById('loginMessage');

            // 2. 에러 메시지 숨김 처리 함수
            function hideErrorMessage() {
                if (loginMessage && loginMessage.classList.contains('is-show')) {
                    loginMessage.classList.remove('is-show', 'is-error');
                    loginMessage.innerText = '';
                }
            }

            // 3. 입력 필드에 이벤트 리스너 추가 (타이핑 시 에러 숨김)
            if (idInput) { idInput.addEventListener('input', hideErrorMessage); }
            if (pwInput) { pwInput.addEventListener('input', hideErrorMessage); }

            // [추가] AJAX 로그인 전송
            $('#loginForm').on('submit', function(e) {
                e.preventDefault(); // 페이지 새로고침 방지

                $.ajax({
                    url: '/member/login',
                    type: 'POST',
                    data: $(this).serialize(),
                    success: function(res) {
                        if (res.status === 'ok') {
                            // 로그인 성공 시 페이지 이동
                            location.replace(res.redirect);
                        } else {
                            // 로그인 실패 시 에러 메시지만 노출 (페이지 리로드 X)
                            $('#loginMessage').text(res.message).addClass('is-show is-error');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error(error);
                        alert('로그인 처리 중 오류가 발생했습니다.');
                    }
                });
            });
        });
    </script>
</body>
</html>