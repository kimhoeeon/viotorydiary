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

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">
    <title>직관 일기 메인 | 승요일기</title>
</head>

<body>
    <div class="app">
        <div class="top_wrap">
            <div class="main-top">
                <div class="main-title" style="display: flex; align-items: center; gap: 12px;">
                    <a href="/diary/winyo" style="font-size: clamp(18px, 5vw, 20px); font-weight:700; color:#0E0F12; border-bottom:2px solid #0E0F12; padding-bottom:2px; line-height: 1.2;">
                        나의 기록
                    </a>
                    <a href="/diary/friend/list" style="font-size: clamp(18px, 5vw, 20px); font-weight:400; color:#A6A9B0; line-height: 1.2;">
                        친구 일기
                    </a>
                </div>

                <button class="noti-btn ${hasUnreadAlarm ? 'has-badge' : ''}" onclick="location.href='/alarm/list'">
                    <span class="noti-btn_icon" aria-hidden="true"><img src="/img/ico_noti.svg" alt="알림 아이콘"></span>
                    <span class="noti-dot" aria-hidden="true"></span>
                </button>
            </div>
        </div>

        <div class="app-main">
            <div class="page-main_wrap">

                <div class="history">
                    <div class="history-list">

                        <div class="card_wrap fire">
                            <div class="tit fire_tit" style="font-size: var(--fs-16);">
                                <c:out value="${winYo.mainMessage}" default="승요력 상승 중! 이번주도 직관 파이팅!" />
                            </div>

                            <div class="card_item gap-16">
                                <div class="live-certify">
                                    <a href="/diary/write" class="btn btn-primary">
                                        오늘의 직관 일기 쓰기
                                        <span><img src="/img/ico_right_arrow.svg" alt=""></span>
                                    </a>
                                </div>
                                <ul class="live-score">
                                    <li>
                                        <p>승률</p>
                                        <div class="data">
                                            <fmt:formatNumber value="${winYo.winRate}" pattern="#,##0"/>%
                                        </div>
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
                                                <img src="/img/card_defalut.svg" alt="스코어카드 이미지">
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
                                            <div class="nodt_txt">아직 친구들의 직관 기록이 없어요.</div>
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
                                                    <div class="tit">
                                                        ${item.homeTeamName} ${item.scoreHome} vs ${item.scoreAway} ${item.awayTeamName}
                                                    </div>
                                                    <div class="date">
                                                        ${item.nickname}
                                                    </div>
                                                </div>
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
                                        <c:forEach var="visited" items="${stadiumStatus}">
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
                                        <%-- 데이터 개수가 부족할 경우 빈 칸 채우기 (옵션) --%>
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

    <%@ include file="../include/popup.jsp" %>
    <script src="/js/script.js"></script>
</body>
</html>