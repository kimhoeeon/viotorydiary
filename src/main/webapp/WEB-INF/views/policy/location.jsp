<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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

    <title>위치정보 이용약관 | 승요일기</title>

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
                <div class="page-tit">
                    <c:out value="${term.title != null ? term.title : '위치정보 이용약관'}"/>
                </div>
            </div>

            <div class="stack mt-24 terms_wrap">

                <c:choose>
                    <c:when test="${not empty term}">
                        <c:out value="${term.content}" escapeXml="false"/>
                    </c:when>
                    <c:otherwise>
                        <div class="sec">
                            <div class="text" style="text-align:center; color:#999; padding: 40px 0;">
                                등록된 약관 내용이 없습니다.
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>

                <c:if test="${not empty term and not empty term.createdAt}">
                    <div class="sec" style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
                        <div class="tit">시행일자</div>
                        <div class="text">
                            본 약관은
                            <span>
                                <fmt:parseDate value="${term.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both"/>
                                <fmt:formatDate value="${parsedDate}" pattern="yyyy년 MM월 dd일"/>
                            </span>
                            부터 시행합니다.
                        </div>
                    </div>
                </c:if>

            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
</body>
</html>