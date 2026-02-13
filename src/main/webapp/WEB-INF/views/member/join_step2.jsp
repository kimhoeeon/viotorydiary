<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes" />

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>이메일 입력 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // [보안] 진입 차단: 1단계 완료 여부 확인
        if (sessionStorage.getItem('join_agree') !== 'Y') {
            alert('약관 동의가 필요합니다.');
            location.replace('/member/join/step1');
        }
    </script>
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
                    <p class="login_desc">로그인 및 계정 찾기에 사용됩니다.</p>
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
    <script src="/js/app_interface.js"></script>
    <script>
        const emailInput = document.getElementById('loginId');
        const nextBtn = document.getElementById('termsNext');
        const msg = document.getElementById('loginMessage');

        // 카카오 이메일 자동 입력
        const savedEmail = sessionStorage.getItem('join_email');

        // 1. 카카오 임시 이메일(@kakao.viotory.com)이 감지되면 -> 바로 Step 3(비밀번호)로 이동
        if (savedEmail && savedEmail.indexOf('@kakao.viotory.com') > -1) {
            location.replace('/member/join/step3');
        }
        // 2. 일반 이메일이 저장되어 있는 경우 -> 입력창에 채워주기
        else if(savedEmail && savedEmail !== 'null') {
            emailInput.value = savedEmail;
            // 유효성 검사 트리거
            emailInput.dispatchEvent(new Event('input'));
        }

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
            const email = emailInput.value.trim();

            // 이메일 중복 체크 (운영 기준 필수)
            $.post('/member/check/email', {email: email}, function(res) {
                if(res === 'ok') {
                    sessionStorage.setItem('join_email', email);
                    location.href = '/member/join/step3';
                } else {
                    alert('이미 가입된 이메일입니다.');
                }
            }).fail(function() {
                alert('서버 통신 오류가 발생했습니다.');
            });
        }
    </script>
</body>
</html>