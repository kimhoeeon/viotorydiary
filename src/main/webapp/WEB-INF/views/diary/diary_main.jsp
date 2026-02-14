<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
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

    <title>직관 일기 메인 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">
        <div class="top_wrap">
            <div class="main-top">
                <div class="main-title">
                    직관일기
                </div>

                <button class="noti-btn ${hasUnreadAlarm ? 'has-badge' : ''}" onclick="location.href='/alarm/list'">
                    <span class="noti-btn_icon" aria-hidden="true"><img src="/img/ico_noti.svg" alt="알림 아이콘"></span>
                    <span class="noti-dot" aria-hidden="true"></span>
                </button>
            </div>
        </div>

        <div class="app-main">

            <div class="tab-pill mb-16">
                <button type="button" class="tab-pill_btn on" onclick="location.href='/diary/winyo'">나의 기록</button>
                <button type="button" class="tab-pill_btn" onclick="location.href='/diary/friend/list'">친구 일기</button>
            </div>

            <div class="page-main_wrap">

                <div class="history">
                    <div class="history-list">

                        <div class="card_wrap clover">
                            <div class="card_item gap-16">
                                <div class="tit clover_tit">
                                    <c:out value="${winYo.mainMessage}" default="승요력 상승 중! 이번주도 직관 파이팅!" />
                                </div>
                                <div class="live-certify">
                                    <c:if test="${hasTodayGame}">
                                        <a href="/diary/write" class="btn btn-primary">
                                            오늘의 직관 일기 쓰기<span><img src="/img/ico_right_arrow.svg" alt=""></span>
                                        </a>
                                    </c:if>
                                </div>

                                <ul class="live-score">
                                    <li>
                                        <div>
                                            <p>나의 직관 승률</p>
                                            <div class="data">
                                                <fmt:formatNumber value="${winYo.winRate}" pattern="#,##0"/>%
                                            </div>
                                        </div>
                                        <c:choose>
                                            <c:when test="${winYo.winRate < 50}">
                                                <img src="/img/score_character01-2.svg" alt="스코어 캐릭터(패배)">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="/img/score_character01.svg" alt="스코어 캐릭터(승리)">
                                            </c:otherwise>
                                        </c:choose>
                                    </li>

                                    <li>
                                        <div>
                                            <p>나의 직관 경기</p>
                                            <div class="data">${winYo.totalGames}경기</div>
                                        </div>
                                        <img src="/img/score_character02.svg" alt="스코어 캐릭터">
                                    </li>

                                    <li>
                                        <div>
                                            <p>우리팀 전적</p>
                                            <div class="data">${winYo.winGames}승 ${winYo.loseGames}패</div>
                                        </div>
                                        <c:choose>
                                            <c:when test="${winYo.winRate < 50}">
                                                <img src="/img/score_character03-2.svg" alt="스코어 캐릭터(패배)">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="/img/score_character03.svg" alt="스코어 캐릭터(승리)">
                                            </c:otherwise>
                                        </c:choose>
                                    </li>

                                    <li>
                                        <div>
                                            <p>최다 방문 구장</p>
                                            <div class="data">${not empty winYo.topStadium ? winYo.topStadium : '-'}</div>
                                        </div>
                                        <img src="/img/score_character04.svg" alt="스코어 캐릭터">
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <div class="card_wrap diary_card">
                            <div class="card_item gap-16">
                                <div class="row history-head">
                                    <div class="tit diary_card_tit">나의 직관 일기</div>
                                    <a href="/diary/list">
                                        <img src="/img/ico_next_arrow.svg" alt="모두 보기">
                                    </a>
                                </div>

                                <c:if test="${empty myDiaries}">
                                    <div class="nodt_wrap only_txt">
                                        <div class="cont">
                                            <div class="nodt_txt">아직 직관 기록이 없어요.</div>
                                        </div>
                                    </div>
                                </c:if>

                                <div class="score_wrap">
                                    <c:forEach var="diary" items="${myDiaries}">
                                        <div class="score_list" onclick="location.href='/diary/detail?diaryId=${diary.diaryId}'">
                                            <div class="img">
                                                <img src="/img/card_defalut.svg" alt="스코어카드 이미지">
                                            </div>
                                            <div class="score_txt">
                                                <div class="txt_box">
                                                    <div class="tit">
                                                        <c:choose>
                                                            <c:when test="${diary.gameType eq 'EXHIBITION'}">
                                                                <span class="badge-game-type badge-exhibition">시범</span>
                                                            </c:when>
                                                            <c:when test="${diary.gameType eq 'REGULAR'}">
                                                                <span class="badge-game-type badge-regular">정규</span>
                                                            </c:when>
                                                            <c:when test="${diary.gameType eq 'POST'}">
                                                                <span class="badge-game-type badge-post">포스트</span>
                                                            </c:when>
                                                            <c:when test="${diary.gameType eq 'ALLSTAR'}">
                                                                <span class="badge-game-type badge-allstar">올스타</span>
                                                            </c:when>
                                                        </c:choose>

                                                        ${diary.homeTeamName} ${diary.scoreHome} vs ${diary.scoreAway} ${diary.awayTeamName}
                                                    </div>
                                                    <div class="date">
                                                        <fmt:parseDate value="${diary.gameDate}" pattern="yyyy-MM-dd" var="pDate" type="date"/>
                                                        <fmt:formatDate value="${pDate}" pattern="yyyy-MM-dd"/>
                                                    </div>
                                                </div>
                                                <c:choose>
                                                    <%-- 1. 경기중 --%>
                                                    <c:when test="${diary.gameStatus eq 'LIVE'}">
                                                        <div class="during"><div class="badge">경기중</div></div>
                                                    </c:when>

                                                    <%-- 2. 취소된 경기 --%>
                                                    <c:when test="${diary.gameStatus eq 'CANCELLED'}">
                                                        <div class="cancel">
                                                            <div class="badge">취소(${not empty diary.cancelReason ? diary.cancelReason : '우천'})</div>
                                                        </div>
                                                    </c:when>

                                                    <%-- 3. 승리한 경기 --%>
                                                    <c:when test="${diary.gameStatus eq 'FINISHED' and diary.gameResult eq 'WIN'}">
                                                        <div class="score_win">
                                                            <img src="/img/ico_check.svg" alt="승리">
                                                        </div>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <div class="card_wrap friend">
                            <div class="card_item gap-16">
                                <div class="row history-head">
                                    <div class="tit friend_tit">친구들의 직관 일기는?</div>
                                    <a href="/diary/friend/list">
                                        <img src="/img/ico_next_arrow.svg" alt="모두 보기">
                                    </a>
                                </div>

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
                                        <c:forEach var="stadium" items="${stadiumStatus}">
                                            <li>
                                                <%-- [수정] item 객체의 visited 속성 확인 --%>
                                                <c:choose>
                                                    <c:when test="${stadium.visited}">
                                                        <img src="/img/score_on.svg" alt="${stadium.name} 방문 완료" title="${stadium.name}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="/img/score_off.svg" alt="${stadium.name} 미방문" title="${stadium.name}">
                                                    </c:otherwise>
                                                </c:choose>

                                                <%-- (선택사항) 구장 이름 표시가 필요하다면 아래 주석 해제 --%>
                                                <%-- <div class="stadium-name" style="text-align:center; font-size:10px;">${stadium.name}</div> --%>
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

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
</body>
</html>