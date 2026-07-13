<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta name="naver-site-verification" content="07e0fdf4e572854d6fbe274f47714d3e7bbb9fbd" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes" />

    <meta property="og:type" content="website">
    <meta property="og:locale" content="ko_KR">
    <meta property="og:site_name" content="승요일기">
    <meta property="og:title" content="승요일기 | 야구 직관 기록 앱">
    <meta property="og:description" content="야구 직관 기록을 더 쉽고 재미있게! 경기 결과, 기록, 사진과 함께 나만의 야구 직관일기를 남겨보세요.">
    <meta name="keywords" content="승요일기 / 야구 직관 / 프로야구 직관 / 직관 후기 / 직관일기 / KBO / KBO 직관 / 프로야구 앱 / 야구팬 앱">
    <meta property="og:url" content="https://myseungyo.com/">
    <meta property="og:image" content="https://myseungyo.com/img/og_img.jpg">

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css">
    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

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

        /* 구단 콘텐츠 배너 스타일 */
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
</head>

<body>

    <div class="app">
        <div class="top_wrap">
            <div class="main-top">
                <div class="main-title" style="display: flex; align-items: center; gap: 8px;">
                    <div><span id="userName">${loginMember.nickname}</span>님</div>
                    <c:if test="${not empty winYo.countLevelName}">
                        <span style="font-size: 13px; font-weight: 600; color: #1A7CFF; background-color: #EBF4FF; padding: 4px 10px; border-radius: 12px; letter-spacing: -0.3px;">
                            ${winYo.countLevelName}
                        </span>
                    </c:if>
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
                                    <div class="tit game_tit">오늘 우리팀 경기는?
                                        <c:if test="${not empty todayGames}">
                                            <div class="location-certify">
                                                <button class="btn btn-certify w-auto" type="button" id="btnVerifyMain_${todayGames[0].gameId}"
                                                        onclick="certifyLocationMain(${todayGames[0].gameId})">
                                                    직관 인증하기
                                                </button>
                                            </div>
                                        </c:if>
                                    </div>

                                    <c:choose>
                                        <c:when test="${not empty todayGames}">
                                            <c:forEach var="todayGame" items="${todayGames}">
                                                <div class="game-board" onclick="location.href='/play'">
                                                    <div class="row row-center gap-6">

                                                        <div class="team ${todayGame.status == 'FINISHED' && todayGame.scoreAway > todayGame.scoreHome ? 'win' : ''}">
                                                            <img src="${todayGame.awayTeamLogo}" alt="${todayGame.awayTeamName}" onerror="this.src='/img/team_default.svg'">
                                                        </div>

                                                        <c:set var="statusClass" value="schedule"/>
                                                        <c:if test="${todayGame.status == 'LIVE'}"><c:set var="statusClass" value="during"/></c:if>
                                                        <c:if test="${todayGame.status == 'FINISHED'}"><c:set var="statusClass" value="end"/></c:if>
                                                        <c:if test="${todayGame.status == 'CANCELLED'}"><c:set var="statusClass" value="cancel"/></c:if>

                                                        <div class="game-score ${statusClass}">

                                                            <div class="left-team-score ${todayGame.scoreAway > todayGame.scoreHome ? 'high' : ''}">
                                                                ${todayGame.status == 'SCHEDULED' ? '-' : todayGame.scoreAway}
                                                            </div>

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
                                                                    <div class="day">
                                                                        <c:out value="${fn:substring(todayGame.gameTime, 0, 5)}"/>
                                                                    </div>
                                                                    <div class="place">${todayGame.stadiumName}</div>
                                                                </div>
                                                            </div>

                                                            <div class="right-team-score ${todayGame.scoreHome > todayGame.scoreAway ? 'high' : ''}">
                                                                ${todayGame.status == 'SCHEDULED' ? '-' : todayGame.scoreHome}
                                                            </div>
                                                        </div>

                                                        <div class="team ${todayGame.status == 'FINISHED' && todayGame.scoreHome > todayGame.scoreAway ? 'win' : ''}">
                                                            <img src="${todayGame.homeTeamLogo}" alt="${todayGame.homeTeamName}"
                                                                 onerror="this.src='/img/team_default.svg'">
                                                        </div>

                                                    </div>
                                                </div>
                                                <div class="btn-wrap">
                                                    <%-- 일기 작성 여부 체크 (diaryId가 있으면 작성한 것으로 간주) --%>
                                                    <c:set var="isWritten" value="${not empty todayGame.diaryId and todayGame.diaryId > 0}"/>

                                                    <c:choose>
                                                        <c:when test="${isWritten}">
                                                            <a href="/diary/detail?diaryId=${todayGame.diaryId}"
                                                               class="btn btn-primary"
                                                               style="background-color:#EBF4FF; color:#1A7CFF; border:none;">
                                                                일기 보기
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="/diary/write?gameId=${todayGame.gameId}"
                                                               class="btn btn-primary">
                                                                일기 쓰기<span><img src="/img/ico_right_arrow.svg" alt=""></span>
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </c:forEach>
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

                            <c:if test="${not empty events}">
                                <div class="card_wrap event">
                                    <div class="swiper_box">
                                        <div class="swiper swiperMainEvt">
                                            <div class="swiper-wrapper">
                                                <c:forEach var="event" items="${events}">
                                                <div class="swiper-slide item">
                                                    <c:choose>
                                                        <c:when test="${event.linkType eq 'EXTERNAL'}">
                                                            <div onclick="if(typeof appify !== 'undefined' && appify.isWebview) { appify.linking.inappBrowser('${event.linkUrl}'); } else { window.open('${event.linkUrl}'); }" style="cursor:pointer; width: 100%; height: 100%;">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div onclick="location.href='/locker/event/detail?eventId=${event.eventId}'" style="cursor:pointer; width: 100%; height: 100%;">
                                                        </c:otherwise>
                                                    </c:choose>
                                                        <img src="${not empty event.imageUrl ? event.imageUrl : '/img/card_event.png'}" alt="이벤트 이미지" style="width:100%; height:100%; object-fit:cover; border-radius:12px;">
                                                    </div>
                                                </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <div class="card_wrap live">
                                <div class="card_item gap-16">
                                    <div class="tit live_tit"
                                         style="display: flex; align-items: center; justify-content: space-between;">
                                        <span>나의 승요력은 얼마?</span>
                                        <c:if test="${not empty winYo.rateLevelName}">
                                            <span style="font-size: 13px; font-weight: 600; color: #FF4D4D; background-color: #FFF0F0; padding: 4px 8px; border-radius: 6px;">
                                                ${winYo.rateLevelName}
                                            </span>
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
                                                <div class="data">
                                                    ${winYo.winGames}승 <c:if test="${winYo.drawGames > 0}">${winYo.drawGames}무 </c:if>${winYo.loseGames}패
                                                </div>
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

                            <div class="card_wrap score_card">
                                <div class="card_item">
                                    <div class="row history-head">
                                        <div class="tit score_card_tit">직관 일기 다시 보기</div>
                                        <a href="/diary/winyo">
                                            <img src="/img/ico_next_arrow.svg" alt="모두 보기">
                                        </a>
                                    </div>
                                    <div class="score_wrap">
                                        <%-- 1. 구단 선택 여부에 따라 디폴트 이미지 경로를 미리 세팅해 둡니다. --%>
                                        <c:choose>
                                            <c:when test="${not empty loginMember.myTeamCode}">
                                                <c:set var="defaultImgPath" value="/img/card_default_${loginMember.myTeamCode}.png" />
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="defaultImgPath" value="/img/card_default_none.svg" />
                                            </c:otherwise>
                                        </c:choose>
                                        <c:choose>
                                            <c:when test="${not empty diaries}">
                                                <c:forEach var="diary" items="${diaries}">
                                                    <div class="score_list"
                                                         onclick="location.href='/diary/detail?diaryId=${diary.diaryId}'">

                                                        <c:set var="firstImage" value=""/>
                                                        <c:if test="${not empty diary.imageUrl}">
                                                            <c:set var="imgArr" value="${fn:split(diary.imageUrl, ',')}"/>
                                                            <c:set var="firstImage" value="${imgArr[0]}"/>
                                                        </c:if>
                                                        <div class="img">
                                                            <img src="${not empty firstImage ? firstImage : defaultImgPath}"
                                                                 alt="썸네일"
                                                                 onerror="this.src='/img/card_default_none.svg'">
                                                        </div>

                                                        <div class="score_txt">
                                                            <div class="txt_box">
                                                                <div class="tit">
                                                                    ${diary.scoreAway} ${diary.awayTeamName} vs ${diary.homeTeamName} ${diary.scoreHome}
                                                                </div>
                                                                <div class="date">${diary.gameDate}</div>
                                                            </div>
                                                            <c:choose>
                                                                <%-- 1. 경기중 --%>
                                                                <c:when test="${diary.gameStatus eq 'LIVE'}">
                                                                    <div class="during">
                                                                        <div class="badge">경기중</div>
                                                                    </div>
                                                                </c:when>

                                                                <%-- 2. 취소된 경기 --%>
                                                                <c:when test="${diary.gameStatus eq 'CANCELLED'}">
                                                                    <div class="cancel">
                                                                        <div class="badge">
                                                                            취소(${not empty diary.cancelReason ? diary.cancelReason : '우천'})
                                                                        </div>
                                                                    </div>
                                                                </c:when>

                                                                <%-- 3. 승리한 경기 --%>
                                                                <c:when test="${diary.gameStatus eq 'FINISHED' and diary.gameResult eq 'WIN'}">
                                                                    <div class="score_win">
                                                                        <img src="/img/thumbs-up.svg" alt="승리">
                                                                    </div>
                                                                </c:when>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="score_list empty">
                                                    <div class="score_txt">
                                                        <div class="txt_box">
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
                                        <div class="tit clip_tit">우리 팀 추천 콘텐츠</div>
                                        <a href="/locker/main">
                                            <img src="/img/ico_next_arrow.svg" alt="모두 보기">
                                        </a>
                                    </div>
                                    <div class="clip_wrap">
                                        <c:choose>
                                            <c:when test="${not empty latestContent}">
                                                <c:forEach var="content" items="${latestContent}">
                                                    <div class="clip_list"
                                                         onclick="location.href='/locker/content/detail?contentId=${content.contentId}'">
                                                        <div class="img">
                                                            <c:choose>
                                                                <%-- 1. 유효한 이미지 URL (http로 시작하거나 /로 시작)인 경우 --%>
                                                                <c:when test="${not empty content.imageUrl and (fn:startsWith(content.imageUrl, 'http') or fn:startsWith(content.imageUrl, '/'))}">
                                                                    <img src="${content.imageUrl}" alt="썸네일"
                                                                         onerror="this.src='/img/card_default.svg'">
                                                                </c:when>
                                                                <%-- 2. 그 외 (URL이 없거나 잘못된 데이터) --%>
                                                                <c:otherwise>
                                                                    <img src="/img/card_default.svg" alt="기본 썸네일">
                                                                </c:otherwise>
                                                            </c:choose>
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
                                                    <div class="clip_txt">
                                                        <div class="txt_box">
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

    <%@ include file="include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js?v=1.1"></script>
    <script src="/js/app_interface.js"></script>

    <script>
        // [직관 인증 함수]
        async function certifyLocationMain(gameId) {
            if (!gameId) {
                alert('오늘 예정된 경기가 없습니다.');
                return;
            }

            // 고유 ID를 통해 특정 게임의 버튼만 상태를 변경
            const $btn = $('#btnVerifyMain_' + gameId);
            const originalText = $btn.text();

            // 클릭 즉시 로딩 상태로 변경하여 중복 터치 방지
            $btn.text('위치 확인 중...').prop('disabled', true).css('opacity', '0.7');

            let lat = 0, lon = 0;

            try {
                // ----------------------------------------------------
                // [1] GPS 좌표 획득 로직
                // ----------------------------------------------------
                if (typeof appify !== 'undefined' && appify.isWebview) {
                    const permStatus = await appify.permission.check('location');
                    if (permStatus === 'denied') {
                        customConfirm("위치 권한이 필요합니다. 설정으로 이동하시겠습니까?", async function() {
                            await appify.linking.openSettings();
                        });
                        $btn.text(originalText).prop('disabled', false).css('opacity', '1');
                        return;
                    } else if (permStatus === 'undetermined') {
                        const reqStatus = await appify.permission.request('location');
                        if (reqStatus !== 'granted') throw new Error("권한 요청 거부됨");
                    }

                    const position = await appify.location.getCurrentPosition();
                    lat = position.latitude;
                    lon = position.longitude;
                } else {
                    if (!navigator.geolocation) {
                        alert("위치 정보를 사용할 수 없는 브라우저입니다.");
                        throw new Error("Geolocation 미지원");
                    }
                    const position = await new Promise((resolve, reject) => {
                        navigator.geolocation.getCurrentPosition(resolve, reject, { enableHighAccuracy: true, timeout: 10000 });
                    });
                    lat = position.coords.latitude;
                    lon = position.coords.longitude;
                }

                console.log('좌표 획득 성공: ', lat, lon);

                // ----------------------------------------------------
                // [2] 백엔드에 인증 요청 (방안 B 테이블 분리 로직 기반)
                // ----------------------------------------------------
                $.ajax({
                    url: '/diary/verify/gps',
                    type: 'POST',
                    data: { gameId: gameId, lat: lat, lon: lon },
                    success: function(res) {
                        if (res === 'ok') {
                            alert('직관 인증 성공! 🎉\n나중에 자유롭게 일기를 작성해보세요.');

                            // 성공 시 텍스트 변경 및 회색 비활성화
                            $btn.text('인증 완료')
                                .css({'background-color': '#ccc', 'color': '#fff', 'border': 'none', 'cursor': 'not-allowed'})
                                .prop('disabled', true);

                        } else if (res === 'fail:not_my_team') {
                            alert('내 응원팀의 경기만 인증할 수 있습니다.');
                            $btn.text(originalText).prop('disabled', false).css('opacity', '1');
                        } else if (res === 'fail:distance') {
                            alert('경기장과 거리가 너무 멀어요! 🏟️\n경기장 근처에서 다시 시도해주세요.');
                            $btn.text(originalText).prop('disabled', false).css('opacity', '1');
                        } else if (res === 'fail:not_yet') {
                            alert('직관 인증은 경기 시작 2시간 전부터 가능합니다.');

                            // 시간 전일 경우 텍스트 변경 및 회색 비활성화
                            $btn.text('인증 시간 전')
                                .css({'background-color': '#ccc', 'color': '#fff', 'border': 'none', 'cursor': 'not-allowed'})
                                .prop('disabled', true);

                        } else if (res === 'fail:timeout') {
                            alert('경기 시작 후 2시간이 지나 인증이 마감되었습니다.');

                            // 시간 초과 시 텍스트 변경 및 회색 비활성화
                            $btn.text('시간 초과')
                                .css({'background-color': '#ccc', 'color': '#fff', 'border': 'none', 'cursor': 'not-allowed'})
                                .prop('disabled', true);

                        } else {
                            alert('인증 처리에 실패했습니다.');
                            $btn.text(originalText).prop('disabled', false).css('opacity', '1');
                        }
                    },
                    error: function() {
                        alert('서버 통신 중 오류가 발생했습니다.');
                        $btn.text(originalText).prop('disabled', false).css('opacity', '1');
                    }
                });
            } catch (error) {
                console.error(error);
                if (error.message !== "권한 거부됨") {
                    alert("위치 정보를 가져올 수 없습니다.\n스마트폰의 GPS 기능이 켜져 있는지 확인해주세요.");
                }
                $btn.text(originalText).prop('disabled', false).css('opacity', '1');
            }
        }
    </script>
</body>
</html>