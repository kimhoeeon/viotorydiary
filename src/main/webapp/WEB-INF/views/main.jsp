<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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

    <title>승요일기</title>

    <style>
        /* 로고 이미지 스타일 강제 적용 */
        .team img {
            width: 48px;
            height: 48px;
            object-fit: contain;
            display: block;
            margin: 0 auto;
        }
        /* 데이터 없음 및 리스트 이미지 사이즈 제어 */
        .score_list .img img,
        .clip_list .img img,
        .nodt_wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        /* 알림 배지 */
        .noti-btn .noti-dot { display: none; }
        .noti-btn.has-badge .noti-dot { display: block; position: absolute; top: 0; right: 0; width: 4px; height: 4px; background: #FF4D4D; border-radius: 50%; }

        /* [추가] 구단 콘텐츠 배너 스타일 */
        .banner-card {
            margin-bottom: 24px;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        }
        .banner-card img {
            width: 100%;
            height: auto;
            display: block;
            object-fit: cover;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>

    <div class="app">
        <div class="top_wrap">
            <div class="main-top">
                <div class="main-title">
                    <span id="userName">${loginMember.nickname}</span>님
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

                        <div class="card_wrap game">
                            <div class="card_item">
                                <div class="tit game_tit">오늘 우리팀 경기는?</div>

                                <c:choose>
                                    <c:when test="${not empty todayGame}">
                                        <div class="game-board" onclick="location.href='/play'">
                                            <div class="row row-center gap-24">
                                                <div class="team ${todayGame.status == 'FINISHED' && todayGame.scoreHome > todayGame.scoreAway ? 'win' : ''}">
                                                    <img src="${todayGame.homeTeamLogo}" alt="${todayGame.homeTeamName}" onerror="this.src='/img/logo/default.svg'">
                                                    </div>

                                                <c:set var="statusClass" value="schedule" />
                                                <c:if test="${todayGame.status == 'LIVE'}"><c:set var="statusClass" value="during" /></c:if>
                                                <c:if test="${todayGame.status == 'FINISHED'}"><c:set var="statusClass" value="end" /></c:if>
                                                <c:if test="${todayGame.status == 'CANCELLED'}"><c:set var="statusClass" value="cancel" /></c:if>

                                                <div class="game-score ${statusClass}">
                                                    <div class="left-team-score ${todayGame.scoreHome > todayGame.scoreAway ? 'high' : ''}">
                                                        ${todayGame.status == 'SCHEDULED' ? '-' : todayGame.scoreHome}
                                                    </div>

                                                    <div class="game-info-wrap">
                                                        <div class="badge">
                                                            <c:choose>
                                                                <c:when test="${todayGame.status == 'SCHEDULED'}">예정</c:when>
                                                                <c:when test="${todayGame.status == 'LIVE'}">LIVE</c:when>
                                                                <c:when test="${todayGame.status == 'FINISHED'}">종료</c:when>
                                                                <c:when test="${todayGame.status == 'CANCELLED'}">취소</c:when>
                                                            </c:choose>
                                                        </div>
                                                        <div class="game-info">
                                                            <div class="day">
                                                                <c:out value="${fn:substring(todayGame.gameTime, 0, 5)}" />
                                                            </div>
                                                            <div class="place">${todayGame.stadiumName}</div>
                                                        </div>
                                                    </div>

                                                    <div class="right-team-score ${todayGame.scoreAway > todayGame.scoreHome ? 'high' : ''}">
                                                        ${todayGame.status == 'SCHEDULED' ? '-' : todayGame.scoreAway}
                                                    </div>
                                                </div>

                                                <div class="team ${todayGame.status == 'FINISHED' && todayGame.scoreAway > todayGame.scoreHome ? 'win' : ''}">
                                                    <img src="${todayGame.awayTeamLogo}" alt="${todayGame.awayTeamName}" onerror="this.src='/img/logo/default.svg'">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="btn-wrap mt-16">
                                            <a href="/play" class="btn btn-primary">오늘의 경기 기록하기<span><img src="/img/ico_right_arrow.svg" alt=""></span></a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="nodt_wrap">
                                            <div class="cont">
                                                <img src="/img/ico_not.svg" alt="데이터 없음">
                                                <div class="nodt_tit">오늘 우리팀 경기가 없어요</div>
                                                <div class="nodt_txt">대진표를 확인해 보세요!</div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="card_wrap live">
                            <div class="card_item gap-16">
                                <div class="tit live_tit">나의 승요력은 얼마?</div>
                                <ul class="live-score">
                                    <li>
                                        <div>
                                            <p>나의 직관 승률</p>
                                            <div class="data">${winYo.winRate}%</div>
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

                        <c:if test="${not empty teamBannerItem}">
                            <div class="banner-card">
                                <a href="/content/click?cid=${teamBannerItem.contentId}&url=${teamBannerItem.contentUrl}" target="_blank">
                                    <img src="/upload/${teamBannerItem.imageUrl}"
                                         alt="${teamBannerItem.title}"
                                         onerror="this.style.display='none';"/>
                                </a>
                            </div>
                        </c:if>
                        <c:if test="${not empty latestEvent}">
                            <div class="card_wrap event" onclick="location.href='/locker/detail?postId=${latestEvent.postId}'">
                                <img src="${not empty latestEvent.imageUrl ? latestEvent.imageUrl : '/img/card_event.png'}"
                                     alt="이벤트 이미지" style="width:100%; object-fit:cover; border-radius:12px;">
                            </div>
                        </c:if>

                        <div class="card_wrap score_card">
                            <div class="card_item">
                                <div class="row history-head">
                                    <div class="tit score_card_tit">직관 일기 다시 보기</div>
                                    <a href="/diary/winyo">
                                        <img src="/img/ico_next_arrow.svg" alt="모두 보기">
                                    </a>
                                </div>
                                <div class="score_wrap">
                                    <c:choose>
                                        <c:when test="${not empty diaries}">
                                            <c:forEach var="diary" items="${diaries}">
                                                <div class="score_list" onclick="location.href='/diary/detail?diaryId=${diary.diaryId}'">
                                                    <div class="img">
                                                        <c:choose>
                                                            <c:when test="${diary.gameResult == 'WIN'}"><img src="/img/ico_diary_comp.svg" alt="승리"></c:when>
                                                            <c:when test="${diary.gameResult == 'LOSE'}"><img src="/img/ico_diary_fail.svg" alt="패배"></c:when>
                                                            <c:otherwise><img src="/img/card_defalut.svg" alt="기본"></c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="score_txt">
                                                        <div class="txt_box">
                                                            <div class="tit">
                                                                ${diary.homeTeamName} ${diary.scoreHome} vs ${diary.scoreAway} ${diary.awayTeamName}
                                                            </div>
                                                            <div class="date">${diary.gameDate}</div>
                                                        </div>
                                                        <c:if test="${diary.gameResult == 'WIN'}">
                                                            <div class="score_win">
                                                                <img src="/img/ico_check.svg" alt="승리">
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="score_list empty">
                                                <div class="score_txt" style="justify-content: center; width: 100%;">
                                                    <div class="txt_box" style="text-align: center;">
                                                        <div class="tit">작성된 일기가 없어요</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="card_wrap clip">
                            <div class="card_item">
                                <div class="row history-head">
                                    <div class="tit clip_tit">우리 팀 새 소식</div>
                                    <a href="/locker/main">
                                        <img src="/img/ico_next_arrow.svg" alt="모두 보기">
                                    </a>
                                </div>
                                <div class="clip_wrap">
                                    <c:choose>
                                        <c:when test="${not empty latestContent}">
                                            <c:forEach var="content" items="${latestContent}">
                                                <div class="clip_list" onclick="location.href='/locker/detail?postId=${content.postId}'">
                                                    <div class="img">
                                                        <img src="${not empty content.thumbnailUrl ? content.thumbnailUrl : '/img/card_defalut.svg'}" alt="썸네일">
                                                    </div>
                                                    <div class="clip_txt">
                                                        <div class="txt_box">
                                                            <div class="tit">${content.title}</div>
                                                            <div class="date">${fn:substring(content.createdAt, 0, 10)}</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="clip_list empty">
                                                <div class="clip_txt" style="justify-content: center; width: 100%;">
                                                    <div class="txt_box" style="text-align: center;">
                                                        <div class="tit">새로운 소식이 없습니다.</div>
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

        <%@ include file="include/tabbar.jsp" %>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
</body>
</html>