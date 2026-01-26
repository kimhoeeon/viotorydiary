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

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">
    <title>경기 | 승요일기</title>

    <style>
        /* 로고 이미지 스타일 */
        .team img {
            width: 48px;
            height: 48px;
            object-fit: contain;
            display: block;
            margin: 0 auto;
        }
        /* 기존 CSS 초기화 */
        .team::before { display: none !important; }

        /* 팝업 스타일 보정 */
        .sheet-backdrop { display: none; align-items: flex-end; justify-content: center; }
        .sheet-backdrop.is-open { display: flex; }
        .month-match.is-show { display: block; }

        /* 데이터 없음 스타일 */
        .no-data { text-align: center; padding: 40px 0; color: #999; }
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
                                <div class="month-match_text" id="monthMatchText">
                                    날짜를 선택하면 해당 날의 경기가 표시됩니다.
                                </div>
                            </div>
                            <div class="month-sheet_footer">
                                <button type="button" class="btn btn-primary" id="monthApplyBtn" disabled>
                                    보기
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="history-list">
                        <label class="check myTeam_check">
                            <input type="checkbox" name="myTeam" id="myTeam" onchange="filterMyTeam()" />
                            우리팀만 보기
                        </label>

                        <div class="card_wrap play_wrap gap-16" id="gameListArea">
                            <c:choose>
                                <c:when test="${not empty todayGames}">
                                    <c:forEach var="game" items="${todayGames}">
                                        <div class="card_item game-item"
                                             data-home="${game.homeTeamCode}"
                                             data-away="${game.awayTeamCode}">

                                            <div class="game-board">
                                                <div class="row row-center gap-24">
                                                    <div class="team ${game.scoreHome > game.scoreAway && game.status == 'END' ? 'win' : ''}">
                                                        <c:if test="${game.homeTeamCode eq sessionScope.loginMember.myTeamCode}">
                                                            <div class="my-team">MY</div>
                                                        </c:if>
                                                        <img src="${game.homeTeamLogo}" alt="${game.homeTeamName}" onerror="this.src='/img/logo/default.svg'">
                                                        <div class="team-name mt-4">${game.homeTeamName}</div>
                                                    </div>

                                                    <c:set var="statusClass" value="schedule" />
                                                    <c:if test="${game.status == 'LIVE'}"><c:set var="statusClass" value="during" /></c:if>
                                                    <c:if test="${game.status == 'END'}"><c:set var="statusClass" value="end" /></c:if>
                                                    <c:if test="${game.status == 'CANCEL'}"><c:set var="statusClass" value="cancel" /></c:if>

                                                    <div class="game-score ${statusClass}">
                                                        <div class="left-team-score ${game.scoreHome > game.scoreAway ? 'high' : ''}">
                                                            ${game.status == 'PRE' ? '0' : game.scoreHome}
                                                        </div>
                                                        <div class="game-info-wrap">
                                                            <div class="badge">
                                                                <c:choose>
                                                                    <c:when test="${game.status == 'PRE'}">예정</c:when>
                                                                    <c:when test="${game.status == 'LIVE'}">경기중</c:when>
                                                                    <c:when test="${game.status == 'END'}">종료</c:when>
                                                                    <c:when test="${game.status == 'CANCEL'}">취소</c:when>
                                                                </c:choose>
                                                            </div>
                                                            <div class="game-info">
                                                                <div class="day">${fn:substring(game.gameTime, 0, 5)}</div>
                                                                <div class="place">${game.stadiumName}</div>
                                                            </div>
                                                        </div>
                                                        <div class="right-team-score ${game.scoreAway > game.scoreHome ? 'high' : ''}">
                                                            ${game.status == 'PRE' ? '0' : game.scoreAway}
                                                        </div>
                                                    </div>

                                                    <div class="team ${game.scoreAway > game.scoreHome && game.status == 'END' ? 'win' : ''}">
                                                        <c:if test="${game.awayTeamCode eq sessionScope.loginMember.myTeamCode}">
                                                            <div class="my-team">MY</div>
                                                        </c:if>
                                                        <img src="${game.awayTeamLogo}" alt="${game.awayTeamName}" onerror="this.src='/img/logo/default.svg'">
                                                        <div class="team-name mt-4">${game.awayTeamName}</div>
                                                    </div>
                                                </div>
                                            </div>

                                            <c:if test="${game.status == 'PRE'}">
                                                <c:choose>
                                                    <c:when test="${not empty game.myPredictedTeam}">
                                                        <button type="button" class="btn btn-gray mt-8" disabled>예측 완료 (${game.myPredictedTeam})</button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button" class="btn btn-primary mt-8"
                                                                onclick="openPredictPopup('${game.gameId}', '${game.homeTeamName}', '${game.awayTeamName}', '${game.homeTeamCode}', '${game.awayTeamCode}')">
                                                            승부예측 하기
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                            <c:if test="${game.status == 'END'}">
                                                <a href="/diary/write?gameId=${game.gameId}" class="btn sub-btn mt-8">
                                                    오늘의 직관 인증
                                                    <svg viewBox="0 0 5.5 9.5"><path d="M.75.75l4,4L.75,8.75"/></svg>
                                                </a>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-data">
                                        <div class="nodt_tit">오늘 경기가 없습니다.</div>
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
                <p class="txt-center mb-16">승리할 팀을 선택해주세요!</p>
                <div class="row gap-10">
                    <button type="button" class="btn team-select-btn" id="btnHome" onclick="selectTeam('HOME')">HOME</button>
                    <button type="button" class="btn team-select-btn" id="btnAway" onclick="selectTeam('AWAY')">AWAY</button>
                </div>
                <input type="hidden" id="popGameId">
            </div>
            <div class="popup-foot">
                <button type="button" class="btn btn-primary" onclick="submitPrediction()">저장하기</button>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        const MY_TEAM_CODE = "${sessionScope.loginMember.myTeamCode}";

        // --- 달력 로직 ---
        (function() {
            const weekLabelEl = document.getElementById('weekLabel');
            const prevWeekBtn = document.getElementById('prevWeek');
            const nextWeekBtn = document.getElementById('nextWeek');
            const dateGridEl = document.getElementById('dateGrid');
            const selectedInput = document.getElementById('selectedDate');
            const pickerPopupBtn = document.getElementById('pickerPopupBtn');

            // 팝업 관련
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
                const dow  = copy.getDay();
                copy.setDate(copy.getDate() - dow);
                return copy;
            }

            function getWeekLabel(date) {
                const year  = date.getFullYear();
                const month = date.getMonth();
                const day   = date.getDate();
                const yy = String(year).slice(-2);
                const firstOfMonth = new Date(year, month, 1);
                const firstDow     = firstOfMonth.getDay();
                const weekIndex = Math.floor((firstDow + day - 1) / 7) + 1;
                return `\${yy}년 \${month + 1}월 \${weekIndex}주`;
            }

            // 주간 렌더링 - 클래스명 'schedule-day' 적용
            function renderWeekView() {
                if (!weekLabelEl || !dateGridEl) return;

                weekLabelEl.textContent = getWeekLabel(currentWeekDate);
                dateGridEl.innerHTML = '';

                const sunday = getSundayOfWeek(currentWeekDate);
                const todayStr = formatYMD(new Date());
                const selectedStr = selectedInput.value || todayStr;

                for (let i = 0; i < 7; i++) {
                    const d = new Date(sunday);
                    d.setDate(sunday.getDate() + i);
                    const ymd = formatYMD(d);

                    const span = document.createElement('span');
                    // [핵심 수정] CSS에 정의된 'schedule-day' 클래스 사용
                    span.className = 'schedule-day';
                    span.textContent = d.getDate();
                    span.dataset.date = ymd;

                    // [핵심 수정] 선택 클래스 'is-selected' (CSS 표준)
                    if (ymd === selectedStr) span.classList.add('is-selected');

                    span.addEventListener('click', () => {
                        selectedInput.value = ymd;
                        const activeEl = dateGridEl.querySelector('.schedule-day.is-selected');
                        if(activeEl) activeEl.classList.remove('is-selected');
                        span.classList.add('is-selected');
                        loadGames(ymd);
                    });

                    dateGridEl.appendChild(span);
                }
            }

            // 월간 팝업 렌더링 - 클래스명 'month-day' 적용
            function renderMonthView() {
                if (!monthLabelEl || !monthGridEl) return;

                const year  = monthCursor.getFullYear();
                const month = monthCursor.getMonth();
                monthLabelEl.textContent = `\${year}년 \${month + 1}월`;
                monthGridEl.innerHTML = '';

                const firstDay = new Date(year, month, 1);
                const firstDow = firstDay.getDay();
                const lastDay  = new Date(year, month + 1, 0).getDate();
                const todayStr = formatYMD(new Date());

                // 빈칸
                for (let i = 0; i < firstDow; i++) {
                    const empty = document.createElement('div');
                    monthGridEl.appendChild(empty);
                }

                // 날짜 생성
                for (let d = 1; d <= lastDay; d++) {
                    const btn = document.createElement('button');
                    btn.type = 'button';
                    // [핵심 수정] CSS에 정의된 'month-day' 클래스 사용
                    btn.className = 'month-day';
                    btn.textContent = d;

                    const ymd = formatYMD(new Date(year, month, d));
                    if (ymd === todayStr) btn.classList.add('is-today'); // 오늘 날짜
                    if (ymd === popupSelectedDateStr) btn.classList.add('is-selected'); // 선택

                    btn.addEventListener('click', () => {
                        const prev = monthGridEl.querySelector('.month-day.is-selected');
                        if(prev) prev.classList.remove('is-selected');
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

                $.get('/play/games', { date: dateStr }, function(data) {
                    if (data && data.length > 0) {
                        let html = '';
                        data.forEach(game => {
                            html += `<div class="month-match_item" style="margin-bottom:4px;">\${game.homeTeamName} vs \${game.awayTeamName}</div>`;
                        });
                        monthMatchText.innerHTML = html;
                    } else {
                        monthMatchText.innerHTML = '<div style="color:#999;">경기가 없습니다.</div>';
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
                if(!popupSelectedDateStr) return;
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
            if(initD) currentWeekDate = initD;
            renderWeekView();

        })();

        // --- 경기 리스트 및 승부예측 로직 (기존 동일) ---
        let cachedGames = [];

        function loadGames(dateStr) {
            $.get('/play/games', { date: dateStr }, function(data) {
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

            if (isMyTeamOnly && MY_TEAM_CODE && MY_TEAM_CODE !== 'NONE') {
                games = games.filter(g => g.homeTeamCode === MY_TEAM_CODE || g.awayTeamCode === MY_TEAM_CODE);
            }

            if (games.length === 0) {
                list.html('<div class="no-data"><div class="nodt_tit">경기가 없습니다.</div></div>');
                return;
            }

            games.forEach(game => {
                let statusClass = 'schedule';
                let statusText = '예정';
                if (game.status === 'LIVE') { statusClass = 'during'; statusText = '경기중'; }
                else if (game.status === 'END') { statusClass = 'end'; statusText = '종료'; }
                else if (game.status === 'CANCEL') { statusClass = 'cancel'; statusText = '취소'; }

                let btnHtml = '';
                if (game.status === 'PRE') {
                    if (game.myPredictedTeam) {
                        btnHtml = `<button class="btn btn-gray mt-8" disabled>예측 완료 (\${game.myPredictedTeam})</button>`;
                    } else {
                        btnHtml = `<button class="btn btn-primary mt-8" onclick="openPredictPopup('\${game.gameId}', '\${game.homeTeamName}', '\${game.awayTeamName}', '\${game.homeTeamCode}', '\${game.awayTeamCode}')">승부예측 하기</button>`;
                    }
                } else if (game.status === 'END') {
                    btnHtml = `<a href="/diary/write?gameId=\${game.gameId}" class="btn sub-btn mt-8">오늘의 직관 인증 <svg viewBox="0 0 5.5 9.5"><path d="M.75.75l4,4L.75,8.75"/></svg></a>`;
                }

                const html = `
                    <div class="card_item">
                        <div class="game-board">
                            <div class="row row-center gap-24">
                                <div class="team \${game.scoreHome > game.scoreAway && game.status === 'END' ? 'win' : ''}">
                                    \${game.homeTeamCode === MY_TEAM_CODE ? '<div class="my-team">MY</div>' : ''}
                                    <img src="\${game.homeTeamLogo}" alt="홈" onerror="this.src='/img/logo/default.svg'">
                                    <div class="team-name mt-4">\${game.homeTeamName}</div>
                                </div>

                                <div class="game-score \${statusClass}">
                                    <div class="left-team-score \${game.scoreHome > game.scoreAway ? 'high' : ''}">
                                        \${game.status === 'PRE' ? '0' : game.scoreHome}
                                    </div>
                                    <div class="game-info-wrap">
                                        <div class="badge">\${statusText}</div>
                                        <div class="game-info">
                                            <div class="day">\${game.gameTime.substring(0,5)}</div>
                                            <div class="place">\${game.stadiumName}</div>
                                        </div>
                                    </div>
                                    <div class="right-team-score \${game.scoreAway > game.scoreHome ? 'high' : ''}">
                                        \${game.status === 'PRE' ? '0' : game.scoreAway}
                                    </div>
                                </div>

                                <div class="team \${game.scoreAway > game.scoreHome && game.status === 'END' ? 'win' : ''}">
                                    \${game.awayTeamCode === MY_TEAM_CODE ? '<div class="my-team">MY</div>' : ''}
                                    <img src="\${game.awayTeamLogo}" alt="원정" onerror="this.src='/img/logo/default.svg'">
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

        function openPredictPopup(gameId, homeName, awayName, homeCode, awayCode) {
            selectedGameId = gameId;
            selectedTeamCode = null;
            $('#btnHome').text(homeName).data('code', homeCode).removeClass('active');
            $('#btnAway').text(awayName).data('code', awayCode).removeClass('active');
            $('#predictPopup').fadeIn();
        }

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
            $.post('/play/predict', { gameId: selectedGameId, teamCode: selectedTeamCode }, function(res) {
                if (res === 'ok') { alert('저장되었습니다.'); location.reload(); }
                else if (res === 'fail:login') location.href = '/member/login';
                else alert('오류가 발생했습니다.');
            });
        }
    </script>
</body>
</html>