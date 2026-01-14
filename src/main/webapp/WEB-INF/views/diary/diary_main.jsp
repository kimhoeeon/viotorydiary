<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
    <link rel="icon" href="/img/favicon.png" />
    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">
    <title>승요일기</title>
</head>

<body>
    <div class="app">
        <div class="top_wrap">
            <div class="main-top">
                <div class="main-title">직관일기</div>
                <button class="noti-btn has-badge" onclick="location.href='/alarm/setting'">
                    <span class="noti-btn_icon"><img src="/img/ico_noti.svg" alt="알림"></span>
                    <span class="noti-dot"></span>
                </button>
            </div>
        </div>

        <div class="app-main">
            <div class="page-main_wrap">
                <div class="history">
                    <div class="history-list">

                        <div class="card_wrap fire">
                            <div class="tit fire_tit">${winYo.mainMessage}</div>
                            <div class="card_item gap-16">
                                <div class="live-certify">
                                    <a href="/diary/write" class="btn btn-primary">
                                        오늘의 직관 일기 쓰기<span><img src="/img/ico_right_arrow.svg" alt=""></span>
                                    </a>
                                </div>
                                <ul class="live-score">
                                    <li>
                                        <p>승률</p>
                                        <div class="data"><fmt:formatNumber value="${winYo.winRate}" pattern="#,##0"/>%</div>
                                    </li>
                                    <li>
                                        <p>직관</p>
                                        <div class="data">${winYo.totalGames}경기</div>
                                    </li>
                                    <li>
                                        <p>전적</p>
                                        <div class="data">${winYo.winGames}승 ${winYo.loseGames}패</div>
                                    </li>
                                    <li>
                                        <p>최다 구장</p>
                                        <div class="data">${winYo.topStadium}</div>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <div class="card_wrap diary_card">
                            <div class="row history-head">
                                <div class="tit diary_card_tit">나의 직관 일기</div>
                                <a href="/diary/list">
                                    <img src="/img/ico_next_arrow.svg" alt="모두 보기">
                                </a>
                            </div>
                            <div class="card_item">
                                <c:if test="${empty myDiaries}">
                                    <div class="nodt_wrap only_txt">
                                        <div class="cont">
                                            <div class="nodt_txt">아직 직관 기록이 없어요.</div>
                                        </div>
                                    </div>
                                </c:if>

                                <div class="score_wrap">
                                    <c:forEach var="item" items="${myDiaries}">
                                        <div class="score_list" onclick="location.href='/diary/detail?diaryId=${item.diaryId}'">
                                            <div class="img">
                                                <img src="/img/card_defalut.svg" alt="썸네일">
                                            </div>
                                            <div class="score_txt">
                                                <div class="txt_box">
                                                    <div class="tit">
                                                        ${item.homeTeamName} ${item.scoreHome} vs ${item.scoreAway} ${item.awayTeamName}
                                                    </div>
                                                    <div class="date">
                                                        <fmt:parseDate value="${item.gameDate}" pattern="yyyy-MM-dd" var="pDate" type="date"/>
                                                        <fmt:formatDate value="${pDate}" pattern="yyyy-MM-dd"/>
                                                    </div>
                                                </div>
                                                <c:if test="${item.gameResult eq 'WIN'}">
                                                    <div class="score_win">
                                                        <img src="/img/ico_check.svg" alt="승리">
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <div class="card_wrap friend">
                            <div class="row history-head">
                                <div class="tit friend_tit">친구들의 직관 일기는?</div>
                                <a href="/diary/friend/list">
                                    <img src="/img/ico_next_arrow.svg" alt="모두 보기">
                                </a>
                            </div>
                            <div class="card_item">
                                <c:if test="${empty friendDiaries}">
                                    <div class="nodt_wrap only_txt">
                                        <div class="cont">
                                            <div class="nodt_txt">아직 친구들의 기록이 없어요.</div>
                                        </div>
                                    </div>
                                </c:if>

                                <div class="score_wrap">
                                    <c:forEach var="item" items="${friendDiaries}">
                                        <div class="score_list" onclick="location.href='/diary/detail?diaryId=${item.diaryId}'">
                                            <div class="img">
                                                <img src="/img/card_defalut.svg" alt="썸네일">
                                            </div>
                                            <div class="score_txt">
                                                <div class="txt_box">
                                                    <div class="tit" style="font-size:13px; margin-bottom:4px;">
                                                        <span style="color:#2c7fff;">${item.nickname}</span>님의 직관
                                                    </div>
                                                    <div class="tit">
                                                        ${item.homeTeamName} vs ${item.awayTeamName}
                                                    </div>
                                                </div>
                                                <c:if test="${item.gameResult eq 'WIN'}">
                                                    <div class="score_win">
                                                        <img src="/img/ico_check.svg" alt="승리">
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <div class="card_wrap score_card">
                            <div class="row history-head">
                                <div class="tit score_card_tit">직관 스코어카드</div>
                            </div>
                            <div class="card_item">
                                <div class="score_card_wrap">
                                    <div class="tit">9개 구장 중, ${visitedCount}개 구장에 방문했어요!</div>
                                    <ul class="score_card_item">
                                        <c:forEach var="visited" items="${stadiumStatus}" varStatus="status">
                                            <li>
                                                <c:choose>
                                                    <c:when test="${visited}">
                                                        <img src="/img/score_on.svg" alt="방문 완료">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="/img/score_off.svg" alt="미방문">
                                                    </c:otherwise>
                                                </c:choose>
                                                </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <script src="/js/script.js"></script>
</body>
</html>