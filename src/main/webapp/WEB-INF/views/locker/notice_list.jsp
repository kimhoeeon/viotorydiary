<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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

    <title>공지 및 설문 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">
        <header class="app-header">
            <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main">
            <div class="app-tit">
                <div class="page-tit">공지 및 설문</div>
            </div>

            <div class="page-main_wrap">
                <div class="notice_wrap mt-24">

                    <c:choose>
                        <c:when test="${empty list}">
                            <div class="no-data" style="text-align:center; padding:50px 0; color:#999;">
                                등록된 공지가 없습니다.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${list}">
                                <div class="notice_list"
                                     onclick="location.href='/locker/notice/detail?postId=${item.postId}'"
                                     style="cursor:pointer;">
                                    <div class="notice_thum">
                                        <img src="${not empty item.imageUrl ? item.imageUrl : '/img/sample03.png'}"
                                             alt="공지 썸네일">
                                    </div>
                                    <div class="notice_item">
                                        <div class="notice_txt">
                                            <div class="notice_badge">공지</div>
                                            <div class="tit">${item.title}</div>
                                        </div>
                                        <div class="date">
                                            <fmt:parseDate value="${item.createdAt}" pattern="yyyy-MM-dd'T'HH:mm"
                                                           var="parsedDate" type="both"/>
                                            <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd"/>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
        </div>

        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
</body>
</html>