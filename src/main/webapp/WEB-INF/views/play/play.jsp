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
</head>

<body>
    <div class="app">
        <div class="top_wrap">
            <div class="main-top">
                <div class="main-title">
                    <span id="userName">${sessionScope.loginMember.nickname}</span>님
                </div>
                <button class="noti-btn has-badge" onclick="location.href='/member/alarm/setting'">
                    <span class="noti-btn_icon"><img src="/img/ico_noti.svg" alt="알림"></span>
                    <span class="noti-dot"></span>
                </button>
            </div>
        </div>

        <div class="app-main">
            <div class="tab_wrap">
                <div class="tab_menu">
                    <button type="button" class="tab-btn active" data-tab="tab-1">전체 경기</button>
                    <button type="button" class="tab-btn" data-tab="tab-2">승부예측</button>
                </div>
            </div>

            <div id="tab-1" class="tab-content active">
                <div class="page-main_wrap">

                    <div class="calendar-wrap">
                        <div class="calendar-head">
                            <button type="button" id="prevWeek" class="prev-week">
                                <img src="/img/picker_prev.svg" alt="이전주">
                            </button>

                            <button type="button" class="picker-popup current-month" id="weekLabel">
                                </button>
                            <input type="hidden" id="selectedDate" value="${today}">

                            <button type="button" id="nextWeek" class="next-week">
                                <img src="/img/picker_next.svg" alt="다음주">
                            </button>
                        </div>
                        <div class="calendar-body">
                            <div class="weekdays">
                                <span>일</span><span>월</span><span>화</span><span>수</span><span>목</span><span>금</span><span>토</span>
                            </div>
                            <div class="days" id="dateGrid"></div>
                        </div>
                    </div>

                    <div class="history">
                        <div class="history-list mt-24">
                            <div class="tit" id="selectedDateTitle">오늘의 경기</div>
                            <div class="game-list_wrap" id="gameListArea">
                                <c:choose>
                                    <c:when test="${empty todayGames}">
                                        <div class="no-data" style="text-align:center; padding:40px 0; color:#999;">
                                            <div class="nodt_tit">해당 날짜에 경기가 없습니다.</div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="game" items="${todayGames}">
                                            <div class="game-list_item">
                                                <div class="time">${fn:substring(game.gameTime, 0, 5)}</div>
                                                <div class="match-info">
                                                    <div class="team home">
                                                        <div class="logo ${fn:toLowerCase(game.homeTeamCode)}"></div>
                                                        <div class="name">${game.homeTeamName}</div>
                                                    </div>
                                                    <div class="vs">vs</div>
                                                    <div class="team away">
                                                        <div class="logo ${fn:toLowerCase(game.awayTeamCode)}"></div>
                                                        <div class="name">${game.awayTeamName}</div>
                                                    </div>
                                                </div>
                                                <div class="place">${game.stadiumName}</div>

                                                <c:choose>
                                                    <c:when test="${not empty game.myPredictedTeam}">
                                                        <button type="button" class="btn btn-gray w-auto" disabled>예측완료</button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button" class="btn btn-primary w-auto"
                                                                onclick="openPredictPopup(${game.gameId}, '${game.homeTeamName}', '${game.awayTeamName}', '${game.homeTeamCode}', '${game.awayTeamCode}')">
                                                            승부예측
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div id="tab-2" class="tab-content">
                <div class="page-main_wrap">
                    <div class="history">
                        <div class="chart-wrap" style="text-align:center; padding:20px 0;">
                            <div style="position:relative; display:inline-block;">
                                <img src="/img/chart_sample.svg" alt="차트 예시">
                                <div style="position:absolute; top:50%; left:50%; transform:translate(-50%, -50%); text-align:center;">
                                    <div style="font-size:12px; color:#666;">예측 성공률</div>
                                    <div style="font-size:24px; font-weight:bold; color:#2c7fff;">
                                        <fmt:formatNumber value="${stats.total > 0 ? (stats.success / stats.total * 100) : 0}" pattern="#,##0"/>%
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="history-list mt-24">
                            <div class="tit">승부예측 히스토리</div>
                            <ul class="prediction-list">
                                <c:forEach var="item" items="${history}">
                                    <li class="game-list_item" style="display:block; padding:15px; margin-bottom:10px;">
                                        <div style="display:flex; justify-content:space-between; margin-bottom:8px;">
                                            <span style="font-size:13px; color:#999;">${item.gameDate}</span>
                                            <span style="font-size:13px; font-weight:bold; color:${item.isCorrect ? '#2c7fff' : (item.isCorrect eq false ? '#ff4d4f' : '#666')}">
                                                ${item.isCorrect == null ? '진행중' : (item.isCorrect ? '적중' : '실패')}
                                            </span>
                                        </div>
                                        <div class="match-info" style="justify-content:center;">
                                            ${item.homeTeamName} vs ${item.awayTeamName}
                                        </div>
                                        <div style="text-align:center; margin-top:8px; font-size:14px;">
                                            나의 예측: <b>
                                                <c:choose>
                                                    <c:when test="${item.predictedTeam eq item.homeTeamCode}">${item.homeTeamName}</c:when>
                                                    <c:when test="${item.predictedTeam eq item.awayTeamCode}">${item.awayTeamName}</c:when>
                                                    <c:otherwise>무승부</c:otherwise>
                                                </c:choose>
                                            </b>
                                        </div>
                                    </li>
                                </c:forEach>
                                <c:if test="${empty history}">
                                    <li style="text-align:center; padding:20px; color:#999;">아직 승부예측 기록이 없습니다.</li>
                                </c:if>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <div class="sheet-backdrop" id="monthPickerSheet">
        <div class="sheet month-sheet">
            <div class="sheet-head">
                <button type="button" id="monthPrev"><img src="/img/picker_prev.svg" alt="이전달"></button>
                <div id="monthLabel" class="month-label"></div>
                <button type="button" id="monthNext"><img src="/img/picker_next.svg" alt="다음달"></button>
                <button type="button" class="close-btn" id="monthCloseBtn"><img src="/img/ico_close.svg" alt="닫기"></button>
            </div>
            <div class="sheet-body">
                <div class="weekdays">
                    <span>일</span><span>월</span><span>화</span><span>수</span><span>목</span><span>금</span><span>토</span>
                </div>
                <div class="days" id="monthGrid"></div>
            </div>

            <div class="month-match">
                <div class="month-match_label" id="monthMatchLabel">오늘의 경기</div>
                <div class="month-match_text" id="monthMatchText"></div>
            </div>

            <div class="sheet-foot">
                <button type="button" class="btn btn-primary" id="monthApplyBtn" disabled>확인</button>
            </div>
        </div>
    </div>

    <div class="sheet-backdrop" id="predictPopup">
        <div class="sheet select-sheet" style="height:auto;">
            <div class="select-sheet_header">
                <div class="select-sheet_title">어느 팀이 이길까요?</div>
            </div>
            <div class="select-sheet_body" style="padding:20px;">
                <input type="hidden" id="popGameId">
                <div class="row gap-16">
                    <button type="button" class="btn border team-select-btn" id="btnHome" onclick="selectTeam('HOME')" style="flex:1; padding:15px;">
                        <div id="popHomeName" style="font-weight:700;">HOME</div>
                    </button>
                    <button type="button" class="btn border team-select-btn" id="btnAway" onclick="selectTeam('AWAY')" style="flex:1; padding:15px;">
                        <div id="popAwayName" style="font-weight:700;">AWAY</div>
                    </button>
                </div>
            </div>
            <div class="select-sheet_footer">
                <button type="button" class="btn btn-gray" onclick="$('#predictPopup').hide()">취소</button>
                <button type="button" class="btn btn-primary" onclick="submitPrediction()">선택 완료</button>
            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>

    <script>
        $(document).ready(function() {

            // 탭 전환
            $('.tab-btn').on('click', function() {
                $('.tab-btn').removeClass('active');
                $(this).addClass('active');
                $('.tab-content').hide();
                $('#' + $(this).data('tab')).show();
            });

            // ============================================================
            // [경기 달력 Logic] - date-picker.js 기반 재작성 (AJAX 연동)
            // ============================================================
            (function () {
                const weekLabelEl    = document.getElementById('weekLabel');
                const dateGridEl     = document.getElementById('dateGrid');
                const prevWeekBtn    = document.getElementById('prevWeek');
                const nextWeekBtn    = document.getElementById('nextWeek');
                const selectedInput  = document.getElementById('selectedDate');
                const pickerPopupBtn = document.querySelector('.picker-popup');

                // 바텀시트(월 캘린더)
                const monthSheetBackdrop = document.getElementById('monthPickerSheet');
                const monthLabelEl  = document.getElementById('monthLabel');
                const monthGridEl   = document.getElementById('monthGrid');
                const monthPrevBtn  = document.getElementById('monthPrev');
                const monthNextBtn  = document.getElementById('monthNext');
                const monthApplyBtn = document.getElementById('monthApplyBtn');
                const monthCloseBtn = document.getElementById('monthCloseBtn');

                // 오늘의 경기 박스 (팝업 내부)
                const monthMatchBox   = document.querySelector('.month-match');
                const monthMatchLabel = document.getElementById('monthMatchLabel');
                const monthMatchText  = document.getElementById('monthMatchText');

                // 상태 변수
                let currentWeekDate = new Date();     // 주간 달력 기준일
                let monthCursor     = new Date();     // 월간 팝업 기준월
                monthCursor.setDate(1);
                let popupSelectedDateStr = '';        // 팝업에서 선택한 날짜

                // --- 유틸 함수 ---
                function formatYMD(date) {
                    const y = date.getFullYear();
                    const m = String(date.getMonth() + 1).padStart(2, '0');
                    const d = String(date.getDate()).padStart(2, '0');
                    return y + '-' + m + '-' + d;
                }

                function parseYMD(str) {
                    if (!str) return null;
                    const parts = str.split('-');
                    return new Date(parts[0], parts[1] - 1, parts[2]);
                }

                function getSundayOfWeek(date) {
                    const copy = new Date(date);
                    const dow  = copy.getDay(); // 0=일
                    copy.setDate(copy.getDate() - dow);
                    return copy;
                }

                function getWeekLabel(date) {
                    const year  = date.getFullYear();
                    const month = date.getMonth();
                    const day   = date.getDate();
                    const yy = String(year).slice(-2);

                    // 해당 월 기준 몇 주차인지 계산
                    const firstOfMonth = new Date(year, month, 1);
                    const firstDow     = firstOfMonth.getDay();
                    const weekIndex = Math.floor((firstDow + day - 1) / 7) + 1;

                    return yy + '년 ' + (month + 1) + '월 ' + weekIndex + '주';
                }

                // --- 주간 뷰 렌더링 ---
                function renderWeekView() {
                    if (!weekLabelEl || !dateGridEl) return;

                    weekLabelEl.textContent = getWeekLabel(currentWeekDate);
                    dateGridEl.innerHTML = '';

                    const ctxYear  = currentWeekDate.getFullYear();
                    const ctxMonth = currentWeekDate.getMonth();
                    const sunday = getSundayOfWeek(currentWeekDate);
                    const todayStr = formatYMD(new Date());
                    const selectedStr = selectedInput.value || todayStr;

                    for (let i = 0; i < 7; i++) {
                        const d = new Date(sunday);
                        d.setDate(sunday.getDate() + i);

                        const btn = document.createElement('button');
                        btn.type = 'button';
                        btn.className = 'schedule-day';
                        btn.textContent = d.getDate();

                        const ymd = formatYMD(d);
                        btn.dataset.date = ymd;

                        // 다른 월 흐릿하게
                        if (d.getFullYear() !== ctxYear || d.getMonth() !== ctxMonth) {
                            btn.classList.add('is-other-month');
                        }
                        // 오늘
                        if (ymd === todayStr) {
                            btn.classList.add('is-today');
                        }
                        // 선택됨
                        if (ymd === selectedStr) {
                            btn.classList.add('is-selected');
                        }

                        // 클릭 이벤트: 날짜 선택 및 리스트 로드
                        btn.addEventListener('click', () => {
                            const isOtherMonth = (d.getFullYear() !== ctxYear || d.getMonth() !== ctxMonth);
                            selectedInput.value = ymd;

                            if (isOtherMonth) {
                                currentWeekDate = d;
                                renderWeekView();
                            } else {
                                document.querySelectorAll('.schedule-day.is-selected').forEach(el => el.classList.remove('is-selected'));
                                btn.classList.add('is-selected');
                            }

                            // [중요] 실제 데이터 로드
                            loadGames(ymd);
                        });

                        dateGridEl.appendChild(btn);
                    }
                }

                // --- 월간 팝업 렌더링 ---
                function renderMonthView() {
                    if (!monthLabelEl || !monthGridEl) return;

                    const year  = monthCursor.getFullYear();
                    const month = monthCursor.getMonth();

                    monthLabelEl.textContent = year + '년 ' + (month + 1) + '월';
                    monthGridEl.innerHTML = '';

                    const firstDay = new Date(year, month, 1);
                    const firstDow = firstDay.getDay();
                    const lastDay  = new Date(year, month + 1, 0).getDate();
                    const todayStr = formatYMD(new Date());

                    // 빈칸 채우기
                    for (let i = 0; i < firstDow; i++) {
                        const empty = document.createElement('div');
                        empty.className = 'month-day is-empty';
                        monthGridEl.appendChild(empty);
                    }

                    // 날짜 채우기
                    for (let d = 1; d <= lastDay; d++) {
                        const btn = document.createElement('button');
                        btn.type = 'button';
                        btn.className = 'month-day';
                        btn.textContent = d;

                        const dateObj = new Date(year, month, d);
                        const ymd = formatYMD(dateObj);
                        btn.dataset.date = ymd;

                        if (ymd === todayStr) btn.classList.add('is-today');
                        if (ymd === popupSelectedDateStr) btn.classList.add('is-selected');

                        btn.addEventListener('click', () => {
                            document.querySelectorAll('.month-day.is-selected').forEach(el => el.classList.remove('is-selected'));
                            btn.classList.add('is-selected');

                            popupSelectedDateStr = ymd;
                            updateMonthApplyBtn();
                            updateMonthMatchInfo(ymd); // 선택한 날짜의 경기 미리보기 로드
                        });

                        monthGridEl.appendChild(btn);
                    }
                }

                // 팝업 하단 미리보기 (AJAX)
                function updateMonthMatchInfo(dateStr) {
                    if (!monthMatchLabel || !monthMatchText) return;

                    // 초기화
                    monthMatchText.innerHTML = '<div style="color:#999; padding:10px;">로딩중...</div>';
                    monthMatchBox.classList.add('is-show');

                    $.get('/play/games', { date: dateStr }, function(data) {
                        if (data && data.length > 0) {
                            let html = '<ul class="month-match_list">';
                            data.forEach(game => {
                                html += '<li class="month-match_item">' +
                                        game.gameTime.substring(0,5) + ' ' +
                                        game.homeTeamName + ' vs ' + game.awayTeamName +
                                        '</li>';
                            });
                            html += '</ul>';
                            monthMatchText.innerHTML = html;
                        } else {
                            monthMatchText.innerHTML = '<div style="color:#999;">경기가 없습니다.</div>';
                        }
                    });
                }

                function updateMonthApplyBtn() {
                    if (!monthApplyBtn) return;
                    monthApplyBtn.disabled = !popupSelectedDateStr;
                }

                // --- 이벤트 핸들러 ---

                // 1. 팝업 열기
                pickerPopupBtn?.addEventListener('click', () => {
                    const baseDate = parseYMD(selectedInput.value) || new Date();
                    monthCursor = new Date(baseDate.getFullYear(), baseDate.getMonth(), 1);
                    popupSelectedDateStr = selectedInput.value;

                    renderMonthView();
                    updateMonthApplyBtn();
                    // 처음 열 때는 미리보기 비움
                    monthMatchBox.classList.remove('is-show');
                    monthSheetBackdrop.classList.add('is-open');
                });

                // 2. 팝업 닫기
                function closeMonthSheet() {
                    monthSheetBackdrop.classList.remove('is-open');
                }
                monthCloseBtn?.addEventListener('click', closeMonthSheet);
                monthSheetBackdrop?.addEventListener('click', (e) => {
                    if (e.target === monthSheetBackdrop) closeMonthSheet();
                });

                // 3. 월 이동
                monthPrevBtn?.addEventListener('click', () => {
                    monthCursor.setMonth(monthCursor.getMonth() - 1);
                    renderMonthView();
                });
                monthNextBtn?.addEventListener('click', () => {
                    monthCursor.setMonth(monthCursor.getMonth() + 1);
                    renderMonthView();
                });

                // 4. 적용 버튼
                monthApplyBtn?.addEventListener('click', () => {
                    if (!popupSelectedDateStr) return;

                    selectedInput.value = popupSelectedDateStr;
                    const d = parseYMD(popupSelectedDateStr);

                    if (d) {
                        currentWeekDate = d; // 선택한 날짜가 포함된 주간으로 이동
                        renderWeekView();
                        loadGames(popupSelectedDateStr); // 리스트 갱신
                    }
                    closeMonthSheet();
                });

                // 5. 주간 이동
                prevWeekBtn?.addEventListener('click', () => {
                    currentWeekDate.setDate(currentWeekDate.getDate() - 7);
                    renderWeekView();
                });
                nextWeekBtn?.addEventListener('click', () => {
                    currentWeekDate.setDate(currentWeekDate.getDate() + 7);
                    renderWeekView();
                });

                // 초기 실행
                const initDate = parseYMD(selectedInput.value);
                if(initDate) currentWeekDate = initDate;
                renderWeekView();

            })(); // End of Calendar IIFE

        });

        // ==========================================
        // [공통] 경기 리스트 로드 및 승부예측 기능
        // ==========================================

        function loadGames(dateStr) {
            $('#selectedDateTitle').text(dateStr + ' 경기');

            $.get('/play/games', { date: dateStr }, function(data) {
                const list = $('#gameListArea');
                list.empty();

                if (!data || data.length === 0) {
                    list.html('<div class="no-data" style="text-align:center; padding:40px 0; color:#999;"><div class="nodt_tit">해당 날짜에 경기가 없습니다.</div></div>');
                    return;
                }

                data.forEach(game => {
                    let btnHtml = '';
                    if (game.myPredictedTeam) {
                        btnHtml = '<button type="button" class="btn btn-gray w-auto" disabled>예측완료</button>';
                    } else {
                        btnHtml = `<button type="button" class="btn btn-primary w-auto"
                                    onclick="openPredictPopup(\${game.gameId}, '\${game.homeTeamName}', '\${game.awayTeamName}', '\${game.homeTeamCode}', '\${game.awayTeamCode}')">
                                    승부예측
                                   </button>`;
                    }

                    const item = `
                        <div class="game-list_item">
                            <div class="time">\${game.gameTime.substring(0, 5)}</div>
                            <div class="match-info">
                                <div class="team home">
                                    <div class="logo \${(game.homeTeamCode || '').toLowerCase()}"></div>
                                    <div class="name">\${game.homeTeamName}</div>
                                </div>
                                <div class="vs">vs</div>
                                <div class="team away">
                                    <div class="logo \${(game.awayTeamCode || '').toLowerCase()}"></div>
                                    <div class="name">\${game.awayTeamName}</div>
                                </div>
                            </div>
                            <div class="place">\${game.stadiumName}</div>
                            \${btnHtml}
                        </div>`;
                    list.append(item);
                });
            });
        }

        let selectedGameId = null;
        let selectedTeamCode = null;

        function openPredictPopup(gameId, homeName, awayName, homeCode, awayCode) {
            selectedGameId = gameId;
            selectedTeamCode = null;

            $('#popGameId').val(gameId);
            $('#popHomeName').text(homeName);
            $('#popAwayName').text(awayName);

            $('#btnHome').data('code', homeCode).removeClass('active').css({'background':'#fff', 'color':'#000', 'border-color':'#ddd'});
            $('#btnAway').data('code', awayCode).removeClass('active').css({'background':'#fff', 'color':'#000', 'border-color':'#ddd'});

            $('#predictPopup').css('display', 'flex');
        }

        function selectTeam(side) {
            $('.team-select-btn').removeClass('active').css({'background':'#fff', 'color':'#000', 'border-color':'#ddd'});

            if (side === 'HOME') {
                $('#btnHome').addClass('active').css({'background':'#e6f7ff', 'color':'#2c7fff', 'border-color':'#2c7fff'});
                selectedTeamCode = $('#btnHome').data('code');
            } else {
                $('#btnAway').addClass('active').css({'background':'#e6f7ff', 'color':'#2c7fff', 'border-color':'#2c7fff'});
                selectedTeamCode = $('#btnAway').data('code');
            }
        }

        function submitPrediction() {
            if (!selectedTeamCode) {
                alert('승리할 팀을 선택해주세요.');
                return;
            }

            $.post('/play/predict', {
                gameId: selectedGameId,
                teamCode: selectedTeamCode
            }, function(res) {
                if (res === 'ok') {
                    alert('예측이 저장되었습니다.');
                    location.reload();
                } else if (res === 'fail:login') {
                    alert('로그인이 필요합니다.');
                    location.href = '/member/login';
                } else {
                    alert('오류가 발생했습니다.');
                }
            });
        }
    </script>

    <style>
        /* 팝업 스타일 보정 */
        .sheet-backdrop { display: none; align-items: flex-end; justify-content: center; }
        .sheet-backdrop.is-open { display: flex; }

        .calendar-body .day { cursor: pointer; }

        /* 탭 버튼 스타일 */
        .tab-content { display: none; }
        .tab-content.active { display: block; }
        .tab-btn.active { color: #000; border-bottom: 2px solid #000; font-weight: 700; }
        .tab-btn { color: #999; font-weight: 500; }

        /* 월간 팝업 내 스타일 */
        .month-match { display: none; padding: 20px; background: #f9f9f9; border-top: 1px solid #eee; }
        .month-match.is-show { display: block; }
        .month-match_label { font-weight: 700; margin-bottom: 10px; font-size: 14px; }
        .month-match_item { font-size: 13px; color: #555; margin-bottom: 4px; }
    </style>
</body>
</html>