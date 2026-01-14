<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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
                <div class="main-title">
                    <span id="userName">${sessionScope.loginMember.nickname}</span>님
                </div>

                <div class="main-profile" style="width:40px; height:40px; border-radius:50%; overflow:hidden; margin-left: auto; margin-right: 10px;">
                    <img src="${not empty sessionScope.loginMember.profileImage ? sessionScope.loginMember.profileImage : '/img/ico_user.svg'}"
                         alt="내 프로필"
                         onclick="location.href='/member/mypage'"
                         style="width:100%; height:100%; object-fit:cover; cursor:pointer;">
                </div>
                <button class="noti-btn has-badge" onclick="location.href='/alarm/list'">
                    <span class="noti-btn_icon" aria-hidden="true"><img src="/img/ico_noti.svg" alt="알림 아이콘"></span>
                    <span class="noti-dot" aria-hidden="true"></span>
                </button>
            </div>
        </div>

        <div class="app-main">
            <div class="page-main_wrap">
                <div class="history">
                    <div class="history-list">

                        <div class="card_wrap game">
                            <div class="tit game_tit">오늘 우리팀 경기는?</div>
                            <div class="card_item">
                                <c:choose>
                                    <%-- 경기가 없는 경우 --%>
                                    <c:when test="${empty todayGame}">
                                        <div class="nodt_wrap">
                                            <div class="cont">
                                                <img src="/img/ico_not.svg" alt="데이터 없음">
                                                <div class="nodt_tit">오늘 우리팀 경기가 없어요</div>
                                                <div class="nodt_txt">대진표를 확인해 보세요!</div>
                                            </div>
                                        </div>
                                        <div class="btn-wrap mt-16">
                                            <a href="/play" class="btn btn-secondary">전체 일정 보기</a>
                                        </div>
                                    </c:when>

                                    <%-- 경기가 있는 경우 --%>
                                    <c:otherwise>
                                        <div class="game-board">
                                            <div class="row row-center gap-24">
                                                <div class="team ${todayGame.scoreHome > todayGame.scoreAway ? 'win' : ''}">
                                                    <img src="/img/logo/logo_${todayGame.homeTeamCode}.png" alt="${todayGame.homeTeamCode}" class="team-logo" style="width:50px;">
                                                    <div class="starting">
                                                        <div class="start-name">${todayGame.homeTeamName}</div>
                                                    </div>
                                                </div>

                                                <div class="game-score ${todayGame.status == 'FINISHED' ? 'end' : (todayGame.status == 'LIVE' ? 'during' : 'schedule')}">
                                                    <div class="left-team-score ${todayGame.scoreHome > todayGame.scoreAway ? 'high' : ''}">${todayGame.scoreHome}</div>

                                                    <div class="game-info-wrap">
                                                        <div class="badge">
                                                            <c:choose>
                                                                <c:when test="${todayGame.status == 'SCHEDULED'}">예정</c:when>
                                                                <c:when test="${todayGame.status == 'LIVE'}">경기중</c:when>
                                                                <c:when test="${todayGame.status == 'FINISHED'}">종료</c:when>
                                                                <c:when test="${todayGame.status == 'CANCELLED'}">취소</c:when>
                                                            </c:choose>
                                                        </div>
                                                        <div class="game-info">
                                                            <div class="day"><fmt:formatDate value="${todayGame.gameTime}" pattern="HH:mm"/></div>
                                                            <div class="place">${todayGame.stadiumName}</div>
                                                        </div>
                                                    </div>

                                                    <div class="right-team-score ${todayGame.scoreAway > todayGame.scoreHome ? 'high' : ''}">${todayGame.scoreAway}</div>
                                                </div>

                                                <div class="team ${todayGame.scoreAway > todayGame.scoreHome ? 'win' : ''}">
                                                    <img src="/img/logo/logo_${todayGame.awayTeamCode}.png" alt="${todayGame.awayTeamCode}" class="team-logo" style="width:50px;">
                                                    <div class="starting">
                                                        <div class="start-name">${todayGame.awayTeamName}</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="btn-wrap mt-16">
                                            <a href="/diary/write?gameId=${todayGame.gameId}" class="btn btn-primary">오늘의 경기 기록하기<span><img src="/img/ico_right_arrow.svg" alt=""></span></a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="card_wrap live">
                            <div class="tit live_tit">나의 승요력은 얼마?</div>
                            <div class="card_item gap-16">
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
                                        <div class="data">${not empty winYo.topStadium ? winYo.topStadium : '-'}</div>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <div class="card_wrap event">
                            <c:choose>
                                <c:when test="${not empty latestEvent}">
                                    <a href="/locker/content/detail?postId=${latestEvent.postId}">
                                        <img src="${not empty latestEvent.imageUrl ? latestEvent.imageUrl : '/img/card_event.png'}"
                                             alt="이벤트 배너" style="width:100%; border-radius:12px; object-fit:cover;">
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="/locker/main">
                                        <img src="/img/card_event.png" alt="이벤트 준비중">
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="card_wrap score_card">
                            <div class="row history-head">
                                <div class="tit score_card_tit">직관 일기 다시 보기</div>
                                <a href="/diary/list">
                                    <img src="/img/ico_next_arrow.svg" alt="모두 보기">
                                </a>
                            </div>
                            <div class="card_item">
                                <div class="score_wrap">
                                    <c:choose>
                                        <c:when test="${empty diaries}">
                                            <div class="text-center py-3 text-gray-500">작성된 일기가 없습니다.</div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="diary" items="${diaries}">
                                                <div class="score_list" onclick="location.href='/diary/detail?diaryId=${diary.diaryId}'">
                                                    <div class="img">
                                                        <img src="/img/card_defalut.svg" alt="일기 썸네일">
                                                    </div>
                                                    <div class="score_txt">
                                                        <div class="txt_box">
                                                            <div class="tit">
                                                                    ${diary.snapshotTeamCode} vs ${diary.snapshotTeamCode eq diary.homeTeamCode ? diary.awayTeamCode : diary.homeTeamCode}
                                                            </div>
                                                            <div class="date">
                                                                <fmt:parseDate value="${diary.gameDate}" pattern="yyyy-MM-dd" var="parsedDate" type="date"/>
                                                                <fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd"/>
                                                            </div>
                                                        </div>
                                                        <c:if test="${diary.gameResult eq 'WIN'}">
                                                            <div class="score_win">
                                                                <img src="/img/ico_check.svg" alt="승리">
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="card_wrap clip">
                            <div class="row history-head">
                                <div class="tit clip_tit">우리 팀 새 소식</div>
                                <a href="/locker/content/list">
                                    <img src="/img/ico_next_arrow.svg" alt="모두 보기">
                                </a>
                            </div>
                            <div class="card_item">
                                <div class="clip_wrap">

                                    <c:choose>
                                        <%-- 최신 소식이 있을 때 --%>
                                        <c:when test="${not empty latestContent}">
                                            <div class="clip_list" onclick="location.href='/locker/content/detail?postId=${latestContent.postId}'" style="cursor:pointer;">
                                                <div class="img">
                                                    <img src="${not empty latestContent.imageUrl ? latestContent.imageUrl : '/img/card_defalut.svg'}"
                                                         alt="콘텐츠 썸네일" style="width:100%; height:100%; object-fit:cover;">
                                                </div>
                                                <div class="clip_txt">
                                                    <div class="txt_box">
                                                        <div class="tit text-ellipsis">${latestContent.title}</div>
                                                        <div class="date">
                                                            <fmt:parseDate value="${latestContent.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="cDate" type="both"/>
                                                            <fmt:formatDate value="${cDate}" pattern="yyyy.MM.dd"/>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:when>

                                        <%-- 소식이 없을 때 --%>
                                        <c:otherwise>
                                            <div class="clip_list">
                                                <div class="img"><img src="/img/card_defalut.svg" alt="clip"></div>
                                                <div class="clip_txt">
                                                    <div class="txt_box">
                                                        <div class="tit">새로운 소식이 없습니다.</div>
                                                        <div class="date">-</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <nav class="app-tabbar" aria-label="하단 메뉴">
            <a class="app-tabbar_item" href="/main" aria-current="page">
                <span aria-hidden="true"><img src="/img/tabbar_home_active.svg" alt="홈 아이콘"></span>
                <span>홈</span>
            </a>
            <a class="app-tabbar_item" href="/play">
                <span aria-hidden="true"><img src="/img/tabbar_play.svg" alt="경기 아이콘"></span>
                <span>경기</span>
            </a>
            <a class="app-tabbar_item" href="/diary/winyo">
                <span aria-hidden="true"><img src="/img/tabbar_note.svg" alt="일기 아이콘"></span>
                <span>일기</span>
            </a>
            <a class="app-tabbar_item" href="/locker/list">
                <span aria-hidden="true"><img src="/img/tabbar_locker.svg" alt="라커룸 아이콘"></span>
                <span>라커룸</span>
            </a>
            <a class="app-tabbar_item" href="/member/mypage">
                <span aria-hidden="true"><img src="/img/tabbar_my.svg" alt="My 아이콘"></span>
                <span>My</span>
            </a>
        </nav>
    </div>

    <script src="/js/script.js"></script>
</body>
</html>