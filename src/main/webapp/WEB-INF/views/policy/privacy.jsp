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
    <title>개인정보처리방침 | 승요일기</title>
    <style>
        /* 약관 내용 스타일 보정 */
        .policy-content {
            padding: 20px;
            font-size: 14px;
            line-height: 1.6;
            color: #333;
            white-space: pre-wrap; /* 줄바꿈 유지 */
            word-break: break-all;
        }

        .policy-date {
            padding: 0 20px 30px;
            text-align: right;
            font-size: 12px;
            color: #888;
        }
    </style>
</head>
<body>
    <header class="app-header">
        <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
            <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
        </button>
        <h1 class="app-header_title">
            <c:out value="${term.title != null ? term.title : '개인정보처리방침'}" />
        </h1>
    </header>

    <div class="app-container">
        <div class="policy-content">
            <c:choose>
                <c:when test="${not empty term}">
                    <c:out value="${term.content}" escapeXml="false"/>
                </c:when>
                <c:otherwise>
                    <div style="text-align:center; padding:50px 0; color:#999;">
                        등록된 약관 내용이 없습니다.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${not empty term}">
            <div class="policy-date">
                시행일자 :
                <fmt:parseDate value="${term.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both"/>
                <fmt:formatDate value="${parsedDate}" pattern="yyyy년 MM월 dd일"/>
            </div>
        </c:if>
    </div>
</body>
</html>