<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
    <title>공지 상세 | 승요일기</title>
</head>

<body>
    <div class="app">
        <header class="app-header">
            <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main">
            <div class="page-main_wrap">
                <div class="notice_view">

                    <div class="notice_view_head">
                        <div class="notice_badge">공지</div>
                        <div class="tit">${post.title}</div>
                        <div class="date">
                            <fmt:parseDate value="${post.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate"
                                           type="both"/>
                            <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd"/>
                        </div>
                    </div>

                    <div class="notice_view_body">
                        <c:if test="${not empty post.imageUrl}">
                            <div class="img-box" style="margin-bottom:20px;">
                                <img src="${post.imageUrl}" alt="첨부 이미지" style="width:100%; border-radius:8px;">
                            </div>
                        </c:if>

                        <div class="txt">
                            <%-- 줄바꿈 처리 --%>
                            ${post.content.replaceAll("\\n", "<br>")}
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="/js/script.js"></script>
</body>
</html>