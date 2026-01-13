<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">
    <title>가입완료 | 승요일기</title>
</head>
<body class="page-login">
    <header class="app-header">
        <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
            <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
        </button>
    </header>

    <div class="page-login_wrap">
        <div class="login-card">
            <div class="login gap-24">
                <img src="/img/ico_complete.svg" alt="완료">
                <div class="login-txt">
                    <h1 class="login_title">
                        <span class="name color-p">${param.name}</span>님<br />
                        가입을 완료했어요!
                    </h1>
                </div>
            </div>
            <div class="login-bottom mt-50">
                <button class="join-btn btn-primary" onclick="location.href='/member/login'">로그인 하기</button>
            </div>
        </div>
    </div>
</body>
</html>