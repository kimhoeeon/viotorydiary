<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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

    <title>나의 직관일기 | 승요일기</title>

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
                <div class="page-tit">나의 직관일기</div>
            </div>

            <div class="page-main_wrap">
                <div class="history">
                    <div class="history-list mt-24">
                        <div class="score_wrap row_wrap">

                            <c:if test="${empty list}">
                                <div class="score_list nodt_list">
                                    <div class="nodt_wrap">
                                        <div class="cont">
                                            <img src="/img/ico_not_mark.svg" alt="데이터 없음" style="width:40px;">
                                            <div class="nodt_tit">아직 작성한 직관 기록이 없어요.</div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <c:forEach var="item" items="${list}">
                                <div class="score_list ${item.gameResult eq 'CANCELLED' ? 'cancel_list' : ''}"
                                     onclick="location.href='/diary/detail?diaryId=${item.diaryId}'"
                                     style="cursor:pointer;">

                                    <div class="img">
                                        <img src="${not empty item.imageUrl ? item.imageUrl : '/img/card_defalut.svg'}"
                                             alt="스코어카드 이미지"
                                             onerror="this.src='/img/card_defalut.svg'">
                                    </div>

                                    <div class="column gap-16">
                                        <div class="score_txt">
                                            <div class="txt_box">
                                                <div class="tit">
                                                    ${item.homeTeamName} ${item.scoreHome} vs ${item.scoreAway} ${item.awayTeamName}
                                                </div>
                                                <div class="date">
                                                    <fmt:parseDate value="${item.gameDate}" pattern="yyyy-MM-dd" var="pDate" type="date"/>
                                                    <fmt:formatDate value="${pDate}" pattern="yyyy-MM-dd"/>

                                                    <%--<c:choose>
                                                        <c:when test="${item.gameType eq 'EXHIBITION'}">
                                                            <span class="badge-game-type badge-exhibition">시범</span>
                                                        </c:when>
                                                        <c:when test="${item.gameType eq 'REGULAR'}">
                                                            <span class="badge-game-type badge-regular">정규</span>
                                                        </c:when>
                                                        <c:when test="${item.gameType eq 'POST'}">
                                                            <span class="badge-game-type badge-post">포스트</span>
                                                        </c:when>
                                                        <c:when test="${item.gameType eq 'ALLSTAR'}">
                                                            <span class="badge-game-type badge-allstar">올스타</span>
                                                        </c:when>
                                                    </c:choose>--%>
                                                </div>
                                            </div>

                                            <c:choose>
                                                <%-- 1. 경기중 --%>
                                                <c:when test="${item.gameStatus eq 'LIVE'}">
                                                    <div class="during"><div class="badge">경기중</div></div>
                                                </c:when>

                                                <%-- 2. 취소된 경기 --%>
                                                <c:when test="${item.gameStatus eq 'CANCELLED'}">
                                                    <div class="cancel">
                                                        <div class="badge">취소(${not empty item.cancelReason ? item.cancelReason : '우천'})</div>
                                                    </div>
                                                </c:when>

                                                <%-- 3. 승리한 경기 --%>
                                                <c:when test="${item.gameStatus eq 'FINISHED' and item.gameResult eq 'WIN'}">
                                                    <div class="score_win">
                                                        <img src="/img/ico_check.svg" alt="승리">
                                                    </div>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                        <div class="diary_review">${item.oneLineComment}</div>
                                    </div>
                                </div>
                            </c:forEach>

                        </div>
                    </div>
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