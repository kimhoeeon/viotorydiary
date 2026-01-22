<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
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
    <title>작성 완료 | 승요일기</title>
</head>

<body>
    <div class="app comp-bg">
        <div class="app-main center">
            <div class="comp gap-24">
                <img src="/img/ico_diary_comp.svg" alt="직관 일기 완료">
                <div class="comp-txt">
                    <div class="comp_title">오늘의 한 수, 남겼어요</div>
                    <p>이제 경기를 즐기면 돼요.</p>
                </div>
            </div>
        </div>

        <div class="bottom-action bottom-main" style="gap: 0 !important;">
            <button type="button" class="btn border" onclick="location.href='/diary/detail?diaryId=${diary.diaryId}'">
                내가 쓴 일기 보기
            </button>
            <button type="button" class="btn btn-primary" onclick="location.href='/main'">
                홈으로
            </button>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="/js/script.js"></script>
</body>
</html>