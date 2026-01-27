<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"/>
    <meta name="format-detection" content="telephone=no,email=no,address=no"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>

    <link rel="icon" href="/favicon.ico"/>
    <link rel="shortcut icon" href="/favicon.ico"/>
    <link rel="manifest" href="/site.webmanifest"/>

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">
    <title>경기 | 승요일기</title>

    <style>
        /* 팝업 스타일 (가운데 정렬) */
        .popup-dim {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            z-index: 1000;
            display: none;
        }

        .popup-box {
            background: #fff;
            width: 90%;
            max-width: 320px;
            border-radius: 16px;
            padding: 24px;
            box-sizing: border-box;

            /* 화면 정중앙 배치 */
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }

        .popup-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .popup-tit {
            font-size: 18px;
            font-weight: 700;
            color: #111;
        }

        .popup-close {
            width: 24px;
            height: 24px;
            padding: 0;
            border: none;
            background: none;
            cursor: pointer;
        }

        .popup-close img {
            width: 100%;
            height: 100%;
        }

        .team-select-btn {
            width: 100%;
            height: 48px;
            border-radius: 12px;
            border: 1px solid #ddd;
            background: #fff;
            font-size: 16px;
            font-weight: 600;
            color: #999;
            cursor: pointer;
        }

        .team-select-btn.active {
            border-color: #FF2F32;
            color: #FF2F32;
            background: #FFF0F0;
        }

        /* 기타 스타일 */
        .team img {
            width: 48px;
            height: 48px;
            object-fit: contain;
            display: block;
            margin: 0 auto;
        }

        .team::before {
            display: none !important;
        }

        .sheet-backdrop {
            display: none;
            align-items: flex-end;
            justify-content: center;
        }

        .sheet-backdrop.is-open {
            display: flex;
        }

        .month-match.is-show {
            display: block;
        }

        .no-data {
            text-align: center;
            padding: 40px 0;
            color: #999;
        }
    </style>
</head>

<body>
    <div class="app">
        <div class="top_wrap">
            <div class="main-top">
                <div class="main-title">
                    <span id="userName">${sessionScope.loginMember.nickname}</span>님
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

                    <div class="card schedule-picker">
                        <div class="schedule-header">
                            <button type="button" class="week-btn" id="prevWeek" aria-label="저번 주">
                                <img src="/img/picker_prev.svg" alt="저번 주">
                            </button>
                            <div class="week-label" id="weekLabel"></div>
                            <button type="button" class="week-btn" id="nextWeek" aria-label="다음 주">
                                <img src="/img/picker_next.svg" alt="다음 주">
                            </button>
                            <button class="picker-popup" id="pickerPopupBtn">
                                <img src="/img/ico_picker.svg" alt="달력 모달">
                            </button>
                        </div>

                        <div class="schedule-weekdays">
                            <span>일</span>
                            <span>월</span>
                            <span>화</span>
                            <span>수</span>
                            <span>목</span>
                            <span>금</span>
                            <span>토</span>
                        </div>
                        <div class="schedule-grid" id="dateGrid"></div>
                        <input type="hidden" id="selectedDate" value="${today}">
                    </div>

                    <div class="sheet-backdrop" id="monthPickerSheet">
                        <div class="sheet month-sheet" role="dialog" aria-modal="true" aria-labelledby="monthSheetTitle">
                            <div class="month-sheet_header">
                                <button type="button" class="month-sheet_close" id="monthCloseBtn" aria-label="닫기">
                                    <img src="/img/ico_close.svg" alt="닫기">
                                </button>
                            </div>
                            <div class="month-sheet_nav">
                                <button type="button" class="month-nav_btn" id="monthPrev" aria-label="이전 달">
                                    <img src="/img/picker_prev.svg" alt="이전 달">
                                </button>
                                <div class="month-label" id="monthLabel"></div>
                                <button type="button" class="month-nav_btn" id="monthNext" aria-label="다음 달">
                                    <img src="/img/picker_next.svg" alt="다음 달">
                                </button>
                            </div>
                            <div class="month-weekdays">
                                <span class="sun">일</span>
                                <span>월</span>
                                <span>화</span>
                                <span>수</span>
                                <span>목</span>
                                <span>금</span>
                                <span class="sat">토</span>
                            </div>
                            <div class="month-grid-wrap">
                                <div class="month-grid" id="monthGrid"></div>
                            </div>
                            <div class="match-notice">날짜를 선택하면 그날의 경기를 볼 수 있어요.</div>
                            <div class="month-match">
                                <div class="month-match_label" id="monthMatchLabel">오늘의 경기</div>
                                <div class="month-match_text" id="monthMatchText"></div>
                            </div>
                            <div class="month-sheet_footer">
                                <button type="button" class="btn btn-primary" id="monthApplyBtn" disabled>보기</button>
                            </div>
                        </div>
                    </div>

                    <div class="history-list">
                        <label class="check myTeam_check">
                            <input type="checkbox" name="myTeam" id="myTeam" onchange="filterMyTeam()"/>
                            우리팀만 보기
                        </label>

                        <div class="card_wrap play_wrap gap-16" id="gameListArea">
                            <c:choose>
                                <c:when test="${not empty todayGames}">
                                    <c:forEach var="game" items="${todayGames}">
                                        <div class="card_item game-item" data-home="${game.homeTeamCode}" data-away="${game.awayTeamCode}">

                                            <div class="game-board">
                                                <div class="row row-center gap-24">
                                                    <div class="team ${game.scoreHome > game.scoreAway && game.status == 'FINISHED' ? 'win' : ''}">
                                                        <c:if test="${game.homeTeamCode eq sessionScope.loginMember.myTeamCode}">
                                                            <div class="my-team">MY</div>
                                                        </c:if>

                                                        <c:set var="homeCodeLower" value="${fn:toLowerCase(game.homeTeamCode)}"/>
                                                        <img src="${not empty game.homeTeamLogo ? game.homeTeamLogo : '/img/logo/logo_'.concat(homeCodeLower).concat('.svg')}"
                                                             alt="${game.homeTeamName}"
                                                             onerror="handleLogoError(this, '${homeCodeLower}')">

                                                        <div class="team-name mt-4">${game.homeTeamName}</div>
                                                    </div>

                                                    <c:set var="statusClass" value="schedule"/>
                                                    <c:set var="statusText" value="예정"/>
                                                    <c:if test="${game.status == 'LIVE'}">
                                                        <c:set var="statusClass" value="during"/>
                                                        <c:set var="statusText" value="경기중"/>
                                                    </c:if>
                                                    <c:if test="${game.status == 'FINISHED'}">
                                                        <c:set var="statusClass" value="end"/>
                                                        <c:set var="statusText" value="종료"/>
                                                    </c:if>
                                                    <c:if test="${game.status == 'CANCEL'}">
                                                        <c:set var="statusClass" value="cancel"/>
                                                        <c:set var="statusText" value="취소"/>
                                                    </c:if>

                                                    <div class="game-score ${statusClass}">
                                                        <div class="left-team-score ${game.scoreHome > game.scoreAway ? 'high' : ''}">
                                                                ${game.status == 'SCHEDULED' ? '0' : game.scoreHome}
                                                        </div>
                                                        <div class="game-info-wrap">
                                                            <div class="badge">${statusText}</div>
                                                            <div class="game-info">
                                                                <div class="day">${fn:substring(game.gameTime, 0, 5)}</div>
                                                                <div class="place">${game.stadiumName}</div>
                                                            </div>
                                                        </div>
                                                        <div class="right-team-score ${game.scoreAway > game.scoreHome ? 'high' : ''}">
                                                                ${game.status == 'SCHEDULED' ? '0' : game.scoreAway}
                                                        </div>
                                                    </div>

                                                    <div class="team ${game.scoreAway > game.scoreHome && game.status == 'FINISHED' ? 'win' : ''}">
                                                        <c:if test="${game.awayTeamCode eq sessionScope.loginMember.myTeamCode}">
                                                            <div class="my-team">MY</div>
                                                        </c:if>

                                                        <c:set var="awayCodeLower"
                                                               value="${fn:toLowerCase(game.awayTeamCode)}"/>
                                                        <img src="${not empty game.awayTeamLogo ? game.awayTeamLogo : '/img/logo/logo_'.concat(awayCodeLower).concat('.svg')}"
                                                             alt="${game.awayTeamName}"
                                                             onerror="handleLogoError(this, '${awayCodeLower}')">

                                                        <div class="team-name mt-4">${game.awayTeamName}</div>
                                                    </div>
                                                </div>
                                            </div>

                                            <c:if test="${game.status == 'SCHEDULED'}">
                                                <c:choose>
                                                    <c:when test="${not empty game.myPredictedTeam}">
                                                        <button type="button" class="btn btn-gray mt-8" disabled>예측 완료
                                                            (${game.myPredictedTeam})
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button" class="btn btn-primary mt-8 btn-predict"
                                                                data-game-id="${game.gameId}"
                                                                data-home-name="${game.homeTeamName}"
                                                                data-away-name="${game.awayTeamName}"
                                                                data-home-code="${game.homeTeamCode}"
                                                                data-away-code="${game.awayTeamCode}">
                                                            승부예측 하기
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                            <c:if test="${game.status == 'FINISHED'}">
                                                <a href="/diary/write?gameId=${game.gameId}" class="btn sub-btn mt-8">
                                                    오늘의 직관 인증
                                                    <svg viewBox="0 0 5.5 9.5">
                                                        <path d="M.75.75l4,4L.75,8.75"/>
                                                    </svg>
                                                </a>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-data">
                                        <div class="nodt_tit">해당 날짜에는 등록된 경기가 없습니다.</div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <div class="popup-dim" id="predictPopup" style="display:none;">
        <div class="popup-box">
            <div class="popup-head">
                <h3 class="popup-tit">승부 예측</h3>
                <button type="button" class="popup-close" onclick="$('#predictPopup').hide()">
                    <img src="/img/ico_close.svg" alt="닫기">
                </button>
            </div>
            <div class="popup-body">
                <p class="txt-center mb-16" style="color:#666; font-size:14px;">승리할 팀을 선택해주세요!</p>
                <div class="row gap-10">
                    <button type="button" class="team-select-btn" id="btnHome" onclick="selectTeam('HOME')">HOME</button>
                    <button type="button" class="team-select-btn" id="btnAway" onclick="selectTeam('AWAY')">AWAY</button>
                </div>
                <input type="hidden" id="popGameId">
            </div>
            <div class="popup-foot mt-16">
                <button type="button" class="btn btn-primary" onclick="submitPrediction()">저장하기</button>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script>
        const MY_TEAM_CODE = "${sessionScope.loginMember.myTeamCode}";

        function handleLogoError(img, teamCode) {
            const localPath = `/img/logo/logo_\${teamCode}.svg`;
            if (img.getAttribute('data-tried') === 'local') {
                img.onerror = null;
                img.src = '/img/logo/default.png';
            } else {
                img.setAttribute('data-tried', 'local');
                img.src = localPath;
            }
        }

        // [이벤트 위임]
        $(document).on('click', '.btn-predict', function () {
            const gameId = $(this).data('gameId');
            const homeName = $(this).data('homeName');
            const awayName = $(this).data('awayName');
            const homeCode = $(this).data('homeCode');
            const awayCode = $(this).data('awayCode');

            selectedGameId = gameId;
            selectedTeamCode = null;

            $('#btnHome').text(homeName).data('code', homeCode).removeClass('active');
            $('#btnAway').text(awayName).data('code', awayCode).removeClass('active');
            $('#popGameId').val(gameId);

            $('#predictPopup').fadeIn();
        });

        // 달력 및 로직
        (function () {
            const weekLabelEl = document.getElementById('weekLabel');
            const dateGridEl = document.getElementById('dateGrid');
            const selectedInput = document.getElementById('selectedDate');
            const pickerPopupBtn = document.getElementById('pickerPopupBtn');
            const prevWeekBtn = document.getElementById('prevWeek');
            const nextWeekBtn = document.getElementById('nextWeek');

            const monthSheetBackdrop = document.getElementById('monthPickerSheet');
            const monthCloseBtn = document.getElementById('monthCloseBtn');
            const monthPrevBtn = document.getElementById('monthPrev');
            const monthNextBtn = document.getElementById('monthNext');
            const monthLabelEl = document.getElementById('monthLabel');
            const monthGridEl = document.getElementById('monthGrid');
            const monthApplyBtn = document.getElementById('monthApplyBtn');
            const monthMatchBox = document.querySelector('.month-match');
            const monthMatchText = document.getElementById('monthMatchText');

            let currentWeekDate = new Date();
            let monthCursor = new Date();
            let popupSelectedDateStr = '';

            function formatYMD(date) {
                const y = date.getFullYear();
                const m = String(date.getMonth() + 1).padStart(2, '0');
                const d = String(date.getDate()).padStart(2, '0');
                return `\${y}-\${m}-\${d}`;
            }

            function parseYMD(str) {
                if (!str) return null;
                const parts = str.split('-');
                return new Date(parts[0], parts[1] - 1, parts[2]);
            }

            function getSundayOfWeek(date) {
                const copy = new Date(date);
                const dow = copy.getDay();
                copy.setDate(copy.getDate() - dow);
                return copy;
            }

            function getWeekLabel(date) {
                const year = date.getFullYear();
                const month = date.getMonth();
                const day = date.getDate();
                const yy = String(year).slice(-2);
                const firstOfMonth = new Date(year, month, 1);
                const firstDow = firstOfMonth.getDay();
                const weekIndex = Math.floor((firstDow + day - 1) / 7) + 1;
                return `\${yy}년 \${month + 1}월 \${weekIndex}주`;
            }

            function renderWeekView() {
                if (!weekLabelEl || !dateGridEl) return;
                weekLabelEl.textContent = getWeekLabel(currentWeekDate);
                dateGridEl.innerHTML = '';
                const sunday = getSundayOfWeek(currentWeekDate);
                const selectedStr = selectedInput.value || formatYMD(new Date());

                for (let i = 0; i < 7; i++) {
                    const d = new Date(sunday);
                    d.setDate(sunday.getDate() + i);
                    const ymd = formatYMD(d);
                    const span = document.createElement('span');
                    span.className = 'schedule-day';
                    span.textContent = d.getDate();
                    span.dataset.date = ymd;
                    if (ymd === selectedStr) span.classList.add('is-selected');
                    span.addEventListener('click', () => {
                        selectedInput.value = ymd;
                        const activeEl = dateGridEl.querySelector('.schedule-day.is-selected');
                        if (activeEl) activeEl.classList.remove('is-selected');
                        span.classList.add('is-selected');
                        loadGames(ymd);
                    });
                    dateGridEl.appendChild(span);
                }
            }

            function renderMonthView() {
                const year = monthCursor.getFullYear();
                const month = monthCursor.getMonth();
                monthLabelEl.textContent = `\${year}년 \${month + 1}월`;
                monthGridEl.innerHTML = '';
                const firstDay = new Date(year, month, 1);
                const firstDow = firstDay.getDay();
                const lastDay = new Date(year, month + 1, 0).getDate();
                const todayStr = formatYMD(new Date());

                for (let i = 0; i < firstDow; i++) monthGridEl.appendChild(document.createElement('div'));
                for (let d = 1; d <= lastDay; d++) {
                    const btn = document.createElement('button');
                    btn.type = 'button';
                    btn.className = 'month-day';
                    btn.textContent = d;
                    const ymd = formatYMD(new Date(year, month, d));
                    if (ymd === todayStr) btn.classList.add('is-today');
                    if (ymd === popupSelectedDateStr) btn.classList.add('is-selected');
                    btn.addEventListener('click', () => {
                        const prev = monthGridEl.querySelector('.month-day.is-selected');
                        if (prev) prev.classList.remove('is-selected');
                        btn.classList.add('is-selected');
                        popupSelectedDateStr = ymd;
                        monthApplyBtn.disabled = false;
                        updateMonthMatchInfo(ymd);
                    });
                    monthGridEl.appendChild(btn);
                }
            }

            function updateMonthMatchInfo(dateStr) {
                monthMatchText.innerHTML = '<div style="padding:10px;">로딩중...</div>';
                monthMatchBox.classList.add('is-show');
                $.get('/play/games', {date: dateStr}, function (data) {
                    if (data && data.length > 0) {
                        let html = '';
                        data.forEach(game => {
                            html += `<div class="month-match_item" style="margin-bottom:4px;">\${game.homeTeamName} vs \${game.awayTeamName}</div>`;
                        });
                        monthMatchText.innerHTML = html;
                    } else {
                        monthMatchText.innerHTML = '<div style="color:#999;">해당 날짜에는 등록된 경기가 없습니다.</div>';
                    }
                });
            }

            pickerPopupBtn.addEventListener('click', () => {
                const base = parseYMD(selectedInput.value) || new Date();
                monthCursor = new Date(base.getFullYear(), base.getMonth(), 1);
                popupSelectedDateStr = selectedInput.value;
                renderMonthView();
                monthSheetBackdrop.classList.add('is-open');
            });

            monthCloseBtn.addEventListener('click', () => monthSheetBackdrop.classList.remove('is-open'));
            monthPrevBtn.addEventListener('click', () => {
                monthCursor.setMonth(monthCursor.getMonth() - 1);
                renderMonthView();
            });
            monthNextBtn.addEventListener('click', () => {
                monthCursor.setMonth(monthCursor.getMonth() + 1);
                renderMonthView();
            });
            monthApplyBtn.addEventListener('click', () => {
                if (!popupSelectedDateStr) return;
                selectedInput.value = popupSelectedDateStr;
                currentWeekDate = parseYMD(popupSelectedDateStr);
                renderWeekView();
                loadGames(popupSelectedDateStr);
                monthSheetBackdrop.classList.remove('is-open');
            });
            prevWeekBtn.addEventListener('click', () => {
                currentWeekDate.setDate(currentWeekDate.getDate() - 7);
                renderWeekView();
            });
            nextWeekBtn.addEventListener('click', () => {
                currentWeekDate.setDate(currentWeekDate.getDate() + 7);
                renderWeekView();
            });

            const initD = parseYMD(selectedInput.value);
            if (initD) currentWeekDate = initD;
            renderWeekView();
        })();

        // AJAX 경기 목록 로드
        let cachedGames = [];

        function loadGames(dateStr) {
            $.get('/play/games', {date: dateStr}, function (data) {
                cachedGames = data || [];
                renderGameList();
            });
        }

        function filterMyTeam() {
            renderGameList();
        }

        function renderGameList() {
            const list = $('#gameListArea');
            list.empty();
            const isMyTeamOnly = $('#myTeam').is(':checked');
            let games = cachedGames;
            if (isMyTeamOnly) {
                games = games.filter(g => g.homeTeamCode === MY_TEAM_CODE || g.awayTeamCode === MY_TEAM_CODE);
            }

            if (games.length === 0) {
                // [수정] 데이터 없음 문구 변경
                list.html('<div class="no-data"><div class="nodt_tit">해당 날짜에는 등록된 경기가 없습니다.</div></div>');
                return;
            }

            games.forEach(game => {
                const homeCodeLower = (game.homeTeamCode || '').toLowerCase();
                const awayCodeLower = (game.awayTeamCode || '').toLowerCase();
                const homeSrc = game.homeTeamLogo ? game.homeTeamLogo : `/img/logo/logo_\${homeCodeLower}.svg`;
                const awaySrc = game.awayTeamLogo ? game.awayTeamLogo : `/img/logo/logo_\${awayCodeLower}.svg`;

                let winClassHome = (game.status === 'FINISHED' && game.scoreHome > game.scoreAway) ? 'win' : '';
                let winClassAway = (game.status === 'FINISHED' && game.scoreAway > game.scoreHome) ? 'win' : '';
                let myTeamBadgeHome = (game.homeTeamCode === MY_TEAM_CODE) ? '<div class="my-team">MY</div>' : '';
                let myTeamBadgeAway = (game.awayTeamCode === MY_TEAM_CODE) ? '<div class="my-team">MY</div>' : '';

                let statusClass = 'schedule';
                let statusText = '예정';
                if (game.status === 'LIVE') {
                    statusClass = 'during';
                    statusText = '경기중';
                } else if (game.status === 'FINISHED') {
                    statusClass = 'end';
                    statusText = '종료';
                } else if (game.status === 'CANCEL') {
                    statusClass = 'cancel';
                    statusText = '취소';
                }

                let scoreHome = (game.status === 'SCHEDULED') ? '0' : game.scoreHome;
                let scoreAway = (game.status === 'SCHEDULED') ? '0' : game.scoreAway;

                let btnHtml = '';
                if (game.status === 'SCHEDULED') {
                    if (game.myPredictedTeam) {
                        btnHtml = `<button type="button" class="btn btn-gray mt-8" disabled>예측 완료 (\${game.myPredictedTeam})</button>`;
                    } else {
                        btnHtml = `<button type="button" class="btn btn-primary mt-8 btn-predict"
                                               data-game-id="\${game.gameId}"
                                               data-home-name="\${game.homeTeamName}"
                                               data-away-name="\${game.awayTeamName}"
                                               data-home-code="\${game.homeTeamCode}"
                                               data-away-code="\${game.awayTeamCode}">
                                       승부예측 하기</button>`;
                    }
                } else if (game.status === 'FINISHED') {
                    btnHtml = `<a href="/diary/write?gameId=\${game.gameId}" class="btn sub-btn mt-8">
                                   오늘의 직관 인증
                                   <svg viewBox="0 0 5.5 9.5"><path d="M.75.75l4,4L.75,8.75"/></svg></a>`;
                }

                let html = `
                        <div class="card_item game-item" data-home="\${game.homeTeamCode}" data-away="\${game.awayTeamCode}">
                            <div class="game-board">
                                <div class="row row-center gap-24">
                                    <div class="team \${winClassHome}">
                                        \${myTeamBadgeHome}
                                        <img src="\${homeSrc}" alt="\${game.homeTeamName}" onerror="handleLogoError(this, '\${homeCodeLower}')">
                                        <div class="team-name mt-4">\${game.homeTeamName}</div>
                                    </div>
                                    <div class="game-score \${statusClass}">
                                        <div class="left-team-score \${game.scoreHome > game.scoreAway ? 'high' : ''}">\${scoreHome}</div>
                                        <div class="game-info-wrap">
                                            <div class="badge">\${statusText}</div>
                                            <div class="game-info">
                                                <div class="day">\${game.gameTime ? game.gameTime.substring(0,5) : ''}</div>
                                                <div class="place">\${game.stadiumName}</div>
                                            </div>
                                        </div>
                                        <div class="right-team-score \${game.scoreAway > game.scoreHome ? 'high' : ''}">\${scoreAway}</div>
                                    </div>
                                    <div class="team \${winClassAway}">
                                        \${myTeamBadgeAway}
                                        <img src="\${awaySrc}" alt="\${game.awayTeamName}" onerror="handleLogoError(this, '\${awayCodeLower}')">
                                        <div class="team-name mt-4">\${game.awayTeamName}</div>
                                    </div>
                                </div>
                            </div>
                            \${btnHtml}
                        </div>
                    `;
                list.append(html);
            });
        }

        let selectedGameId = null;
        let selectedTeamCode = null;

        function selectTeam(side) {
            $('.team-select-btn').removeClass('active');
            const btn = side === 'HOME' ? $('#btnHome') : $('#btnAway');
            btn.addClass('active');
            selectedTeamCode = btn.data('code');
        }

        function submitPrediction() {
            if (!selectedTeamCode) {
                alert('팀을 선택해주세요.');
                return;
            }
            $.post('/play/predict', {gameId: selectedGameId, teamCode: selectedTeamCode}, function (res) {
                if (res === 'ok') {
                    alert('저장되었습니다.');
                    location.reload();
                } else if (res === 'fail:login') location.href = '/member/login';
                else alert('오류가 발생했습니다.');
            });
        }

        // [추가] 초기 페이지 로딩 시 오늘 날짜 데이터 강제 로드
        $(document).ready(function () {
            const initDate = $('#selectedDate').val();
            if (initDate) {
                loadGames(initDate);
            }
        });
    </script>
</body>
</html>