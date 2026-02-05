<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
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

    <title>직관일기 로드 실패 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">
        <header class="app-header" style="justify-content:center;">
            <div class="page-tit" style="font-weight:700;">승요일기</div>
        </header>

        <div class="app-main"
             style="display: flex; flex-direction: column; justify-content: center; height: calc(100vh - 140px);">
            <div style="text-align:center;">
                <div class="img-box" style="margin-bottom: 24px;">
                    <img src="/img/ico_warning.svg" alt="경고 아이콘" style="width: 60px; opacity: 0.5;">
                </div>

                <div class="tit" style="font-size: 20px; font-weight: 700; margin-bottom: 12px; color: #333;">
                    기록을 볼 수 없어요
                </div>
                <div class="txt" style="font-size: 15px; color: #888; line-height: 1.5;">
                    <c:out value="${errorMsg}" default="삭제되었거나 존재하지 않는 일기입니다."/>
                </div>
            </div>
        </div>

        <div class="bottom-action">
            <button type="button" class="btn btn-primary" onclick="location.href='/'">
                승요일기 홈으로 이동
            </button>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
</body>
</html>