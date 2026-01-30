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
    <meta name="mobile-web-app-capable" content="yes" />

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>우리 팀 콘텐츠 | 승요일기</title>

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
                <div class="page-tit">우리 팀 추천 콘텐츠</div>
            </div>

            <div class="page-main_wrap">
                <div class="score_wrap list_type mt-24">

                    <c:choose>
                        <c:when test="${empty list}">
                            <div class="no-data" style="text-align:center; padding:50px 0; color:#999;">
                                등록된 콘텐츠가 없습니다.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${list}">
                                <div class="score_list"
                                     onclick="location.href='/locker/content/detail?postId=${item.postId}'"
                                     style="cursor:pointer;">
                                    <div class="img">
                                        <img src="${not empty item.imageUrl ? item.imageUrl : '/img/card_defalut.svg'}"
                                             alt="콘텐츠 이미지">
                                    </div>
                                    <div class="score_txt">
                                        <div class="txt_box">
                                            <div class="tit">${item.title}</div>
                                            <div class="date">
                                                <fmt:parseDate value="${item.createdAt}" pattern="yyyy-MM-dd'T'HH:mm"
                                                               var="parsedDate" type="both"/>
                                                <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd"/>
                                            </div>
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