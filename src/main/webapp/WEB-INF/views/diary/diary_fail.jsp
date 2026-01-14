<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"/>
    <link rel="icon" href="/img/favicon.png"/>
    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">
    <title>저장 실패 | 승요일기</title>
</head>

<body>
    <div class="app comp-bg">
        <header class="app-header comp-bg">
            <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main center">
            <div class="comp gap-24">
                <img src="/img/ico_diary_fail.svg" alt="저장 실패">
                <div class="comp-txt">
                    <div class="comp_title">저장에 실패했어요</div>
                    <p>잠시 후 다시 시도해 주세요.</p>

                    <c:if test="${not empty error}">
                        <p style="font-size:12px; color:#ff4d4f; margin-top:10px;">(${error})</p>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="bottom-action bottom-main">
            <button type="button" class="btn border" onclick="history.back()">
                다시 시도하기
            </button>
            <button type="button" class="btn btn-primary" onclick="location.href='/main'">
                홈으로
            </button>
        </div>
    </div>

    <script src="/js/script.js"></script>
</body>
</html>