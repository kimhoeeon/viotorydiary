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
    <title>회원 가입 | 승요일기</title>
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
                <div class="login-txt">
                    <h1 class="login_title">회원 가입</h1>
                </div>
            </div>
            <div class="join-btn-warp">
                <button class="login-btn btn-primary" onclick="location.href='/member/join/step1'" type="button">
                    이메일로 계속하기
                </button>

                <button class="login-btn btn-kakao" type="button" onclick="alert('준비중입니다.')">
                    카카오 로그인
                </button>
            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="/js/script.js"></script>
</body>
</html>