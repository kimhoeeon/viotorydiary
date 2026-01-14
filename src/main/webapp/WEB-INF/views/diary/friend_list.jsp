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
    <title>친구들의 직관 | 승요일기</title>
</head>

<body>
    <div class="app">

        <header class="app-header">
            <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main column">

            <div class="app-tit">
                <div class="page-tit">친구들의 직관</div>
            </div>

            <div class="stack mt-24">
                <div class="my-diary_list">
                    <div class="score_wrap row_wrap">

                        <c:if test="${empty list}">
                            <div class="score_list nodt_list">
                                <div class="nodt_wrap">
                                    <div class="cont">
                                        <img src="/img/ico_nodt.png" alt="데이터 없음" style="width:40px;">
                                        <div class="nodt_tit">아직 친구들의 직관 기록이 없어요.</div>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <c:forEach var="item" items="${list}">
                            <div class="score_list" onclick="location.href='/diary/detail?diaryId=${item.diaryId}'"
                                 style="cursor:pointer;">
                                <div class="img">
                                    <img src="/img/card_defalut.svg" alt="썸네일">
                                </div>
                                <div class="column gap-16">
                                    <div class="score_txt">
                                        <div class="txt_box">
                                            <div class="tit" style="font-size:13px; margin-bottom:4px;">
                                                <span style="color:#2c7fff; font-weight:600;">${item.nickname}</span>
                                            </div>
                                            <div class="tit">
                                                    ${item.homeTeamName} ${item.scoreHome}
                                                vs ${item.scoreAway} ${item.awayTeamName}
                                            </div>
                                            <div class="date">
                                                <fmt:parseDate value="${item.gameDate}" pattern="yyyy-MM-dd" var="pDate"
                                                               type="date"/>
                                                <fmt:formatDate value="${pDate}" pattern="yyyy.MM.dd"/>
                                            </div>
                                        </div>

                                        <c:if test="${item.gameResult eq 'WIN'}">
                                            <div class="score_win">
                                                <img src="/img/ico_check.svg" alt="승리">
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="diary_review">${item.oneLineComment}</div>
                                </div>
                            </div>
                        </c:forEach>

                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <script src="/js/script.js"></script>
</body>
</html>