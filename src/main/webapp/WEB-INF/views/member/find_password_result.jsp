<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
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

    <title>비밀번호 초기화 완료 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>
<body class="page-login">

    <div class="page-login_wrap">
        <div class="login-card">
            <div class="login gap-24">
                <img src="/img/ico_initia.svg" alt="비밀번호 초기화">
                <div class="login-txt">
                    <h1 class="login_title">
                        <span class="name color-p">${name}</span>님의 비밀번호가<br />초기화 되었습니다.
                    </h1>
                    <p class="login_success">임시 비밀번호를 문자로 발송해 드렸어요.<br/>SMS 미수신 시, 스팸보관함을 확인해 주세요.</p>
                </div>
            </div>

            <div class="login-bottom mt-50">
                <div class="login-actions">
                    <button class="join-btn btn-primary" onclick="location.href='/member/login'">
                        로그인 하기
                    </button>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
</body>
</html>