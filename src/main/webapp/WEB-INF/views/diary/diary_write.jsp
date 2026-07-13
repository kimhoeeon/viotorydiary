<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ko">
<head>
    <meta name="naver-site-verification" content="07e0fdf4e572854d6fbe274f47714d3e7bbb9fbd"/>
    <meta charset="utf-8"/>
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover"/>
    <meta name="format-detection" content="telephone=no,email=no,address=no"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="mobile-web-app-capable" content="yes"/>

    <meta property="og:type" content="website">
    <meta property="og:locale" content="ko_KR">
    <meta property="og:site_name" content="승요일기">
    <meta property="og:title" content="승요일기 | 야구 직관 기록 앱">
    <meta property="og:description" content="야구 직관 기록을 더 쉽고 재미있게! 경기 결과, 기록, 사진과 함께 나만의 야구 직관일기를 남겨보세요.">
    <meta name="keywords" content="승요일기 / 야구 직관 / 프로야구 직관 / 직관 후기 / 직관일기 / KBO / KBO 직관 / 프로야구 앱 / 야구팬 앱">
    <meta property="og:url" content="https://myseungyo.com/">
    <meta property="og:image" content="https://myseungyo.com/img/og_img.jpg">

    <link rel="icon" href="/favicon.ico"/>
    <link rel="shortcut icon" href="/favicon.ico"/>
    <link rel="manifest" href="/site.webmanifest"/>

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>일기 작성 | 승요일기</title>

    <style>
        /* 선택된 항목 하이라이트 스타일 */
        .select-sheet_list li button.active {
            background-color: #f5f5f5;
            color: #2c7fff; /* 메인 컬러(파랑) */
            font-weight: 700;
        }

        /* 이미지 미리보기 스타일 보정 */
        .upload img {
            width: 90%;
            height: 100%;
            object-fit: cover;
            border-radius: 8px;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">

        <header class="app-header">
            <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main">

            <div class="app-tit">
                <div class="page-tit">직관일기</div>

                <div class="location-certify">
                    <button class="btn btn-certify w-auto" type="button" id="btnVerify" onclick="certifyLocation()">
                        직관 인증하기
                    </button>
                </div>
            </div>

            <ul class="comment">
                <li>직관일기는 한 경기당 1개만 기록할 수 있어요.</li>
                <li>경기 시작 1시간 전까지는 다시 수정할 수 있어요.</li>
            </ul>

            <form id="diaryForm" action="/diary/write" method="post" enctype="multipart/form-data">
                <input type="hidden" name="gameId" id="gameId" value="${targetGameId}">
                <input type="hidden" name="verified" id="isVerified" value="false">
                <input type="hidden" name="rating" value="5">

                <input type="hidden" name="companionType" id="companionType" value="">
                <input type="hidden" name="taggedMembers" id="taggedMembers" value="">

                <div class="page-main_wrap">
                    <div class="history">
                        <div class="history-list mt-24">
                            <div class="diary_write_form">

                                <div class="diary_write_list req clr diary_character">
                                    <div class="tit">경기 선택하기</div>
                                    <button type="button" class="select-field"
                                            <c:if test="${not isScoreEditable}">disabled
                                            style="background-color:#f5f5f5; cursor:not-allowed;"</c:if>
                                            <c:if test="${isScoreEditable}">onclick="openGameSheet()"</c:if> >
                                        <c:choose>
                                            <c:when test="${not empty selectedGame}">
                                                  <span class="select-field_value" style="color:#000; font-weight:bold;">
                                                      ${selectedGame.awayTeamName} vs ${selectedGame.homeTeamName}
                                                  </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="select-field_value" id="gameSelectText">경기를 선택해주세요</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </button>
                                </div>

                                <%--<div class="diary_write_list req clr diary_character yellow" id="scoreInputWrap">
                                    <div class="tit">오늘의 스코어 예상해 본다면?</div>
                                    <div class="card_item">
                                        <div class="game-board">
                                            <div class="row row-center gap-6">
                                                <div class="team" id="awayTeamBox">
                                                    <div class="my-team" id="awayMyTeam" style="display:none;">MY</div>
                                                    <div class="team-logo mb-4">
                                                        <img id="awayTeamLogo" src="/img/team_default.svg" alt="원정팀" style="width: 48px; height: 48px; object-fit: contain;">
                                                    </div>
                                                    <div class="team-name" id="awayTeamName">AWAY</div>
                                                </div>

                                                <div class="game-score schedule">
                                                    <div class="left-team-score">
                                                        <input type="number" name="predScoreAway" min="0" max="99"
                                                           <c:if test="${not isScoreEditable}">readonly placeholder="-" style="background-color:transparent; color:#999;"</c:if>
                                                           <c:if test="${isScoreEditable}">oninput="if(this.value > 99) this.value = 99; if(this.value !== '' && this.value < 0) this.value = 0;" placeholder="0"</c:if> >
                                                    </div>
                                                    <div class="game-info-wrap">VS</div>
                                                    <div class="right-team-score">
                                                        <input type="number" name="predScoreHome" min="0" max="99"
                                                               <c:if test="${not isScoreEditable}">readonly placeholder="-" style="background-color:transparent; color:#999;"</c:if>
                                                               <c:if test="${isScoreEditable}">oninput="if(this.value > 99) this.value = 99; if(this.value !== '' && this.value < 0) this.value = 0;" placeholder="0"</c:if> >
                                                    </div>
                                                </div>

                                                <div class="team" id="homeTeamBox">
                                                    <div class="my-team" id="homeMyTeam" style="display:none;">MY</div>
                                                    <div class="team-logo mb-4">
                                                        <img id="homeTeamLogo" src="/img/team_default.svg" alt="홈팀" style="width: 48px; height: 48px; object-fit: contain;">
                                                    </div>
                                                    <div class="team-name" id="homeTeamName">HOME</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>--%>

                                <div class="diary_write_list req">
                                    <div class="tit">오늘의 수훈선수는?</div>
                                    <input type="text" name="heroName" id="heroName" maxlength="100"
                                           placeholder="선수 이름을 입력해 주세요.">
                                </div>

                                <div class="diary_write_list req">
                                    <div class="tit">경기 한 줄 요약</div>
                                    <input type="text" name="oneLineComment" id="oneLine" maxlength="100"
                                           placeholder="오늘 경기의 한 줄 요약을 남겨보세요.">
                                </div>

                                <div class="diary_write_list req">
                                    <div class="tit">오늘의 직관 일기</div>
                                    <textarea name="content" maxlength="1000" placeholder="오늘의 직관 이야기를 들려주세요!"></textarea>
                                </div>

                                <div class="diary_write_list clr">
                                    <div class="tit">직관 사진을 올려주세요 <span>(선택)</span></div>
                                    <button type="button" class="btn btn-primary gap-4"
                                            onclick="document.getElementById('fileUpload').click();">
                                        사진 올리기 (최대 4장)
                                        <span><img src="/img/ico_plus.svg" alt="플러스 아이콘"></span>
                                    </button>
                                    <input type="file" id="fileUpload" name="files" style="display:none;"
                                           accept="image/jpeg, image/png" multiple onchange="handleFileSelect(this)">

                                    <div class="upload" id="imagePreviewBox"
                                         style="display:none; margin-top:12px; white-space: nowrap; overflow-x: auto; padding-bottom: 8px;"></div>
                                    <div class="file-mes"><img src="/img/ico_not_mark_blue.svg" alt="주의 아이콘">최대 10MB 의 JPG,
                                        PNG만 등록 가능합니다.
                                    </div>
                                </div>

                                <div class="diary_write_list clr">
                                    <div class="tit">누구와 함께했나요? <span>(선택)</span></div>
                                    <div class="check_box">
                                        <ul>
                                            <li><label onclick="selectCompanion('ALONE', this)">
                                                <img src="/img/check_together01.svg" alt="">
                                                <button type="button">혼자</button>
                                            </label></li>
                                            <li><label onclick="selectCompanion('FRIEND', this)">
                                                <img src="/img/check_together02.svg" alt="">
                                                <button type="button">친구</button>
                                            </label></li>
                                            <li><label onclick="selectCompanion('FAMILY', this)">
                                                <img src="/img/check_together03.svg" alt="">
                                                <button type="button">가족</button>
                                            </label></li>
                                            <li><label onclick="selectCompanion('COUPLE', this)">
                                                <img src="/img/check_together04.svg" alt="">
                                                <button type="button">연인</button>
                                            </label></li>
                                            <li><label onclick="selectCompanion('COLLEAGUE', this)">
                                                <img src="/img/check_together05.svg" alt="">
                                                <button type="button">직장동료</button>
                                            </label></li>
                                            <li><label onclick="selectCompanion('ETC', this)">
                                                <img src="/img/check_together06.svg" alt="">
                                                <button type="button">기타</button>
                                            </label></li>
                                        </ul>
                                    </div>
                                    <div class="tag_box">
                                        <div class="flex">
                                            <div id="taggedFriendsDisplay">함께한 친구를 태그해보세요!</div>
                                            <a href="javascript:void(0);" class="tag_link" onclick="openFriendTagLayer()">
                                                <img src="/img/check_tag.svg" alt="">친구 태그하기
                                            </a>
                                        </div>
                                    </div>
                                </div>

                                <ul class="disClose">
                                    <li><label class="check"><input type="radio" name="isPublic" value="PUBLIC" checked>전체공개</label>
                                    </li>
                                    <li><label class="check"><input type="radio" name="isPublic" value="FRIENDS">맞팔
                                        공개</label></li>
                                    <li><label class="check"><input type="radio" name="isPublic" value="PRIVATE">비공개</label>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <div class="bottom-action bottom-main">
            <button type="button" class="btn btn-primary" id="btnNext" onclick="submitDiary()">
                기록하기
            </button>
        </div>

        <div class="sheet-backdrop" id="selectSheet">
            <div class="sheet select-sheet" role="dialog" aria-modal="true">
                <div class="select-sheet_header">
                    <div class="select-sheet_title">경기를 선택해주세요</div>
                </div>

                <div class="select-sheet_body">
                    <ul class="select-sheet_list" id="selectSheetList">
                    </ul>
                </div>

                <div class="select-sheet_footer">
                    <button type="button" class="btn btn-gray" onclick="closeGameSheet()">취소</button>
                    <button type="button" class="btn btn-primary" id="selectSheetApply" disabled
                            onclick="applyGameSelection()">저장
                    </button>
                </div>
            </div>
        </div>

    </div>

    <div id="friendTagLayer" class="app"
         style="display:none; position:fixed; top:0; left:0; right:0; bottom:0; z-index:99999; background:#fff; flex-direction:column;">

        <header class="app-header" style="flex-shrink: 0;">
            <button class="app-header_btn app-header_back" type="button" onclick="closeFriendTagLayer()">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main column" style="flex: 1; overflow-y: auto;">
            <div class="app-tit">
                <div class="page-tit">친구 태그하기</div>
            </div>
            <div class="page-main_wrap">
                <div class="history-list mt-24">
                    <ul class="diary_write_form" id="friendListUl" style="padding-bottom: 20px;">
                        <li style="text-align:center; padding:30px; color:#999;">로딩 중입니다...</li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="bottom-action bottom-main" style="flex-shrink: 0; background: #fff;">
            <button type="button" class="btn btn-primary" id="btnCompleteTag" onclick="completeFriendSelection()">
                선택 완료
            </button>
        </div>

    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js?v=1.1"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        // 임시 저장용 변수 (팝업 내 선택값)
        let tempSelectedGame = null;
        $(document).ready(function () {
            // 초기 로드 시 선택된 경기 UI 세팅
            if ('${targetGameId}' !== '') {
                // 원정 무조건 왼쪽, 홈 무조건 오른쪽
                $('#awayTeamName').text('${selectedGame.awayTeamName}');
                $('#homeTeamName').text('${selectedGame.homeTeamName}');

                const aCode = '${selectedGame.awayTeamCode}';
                const hCode = '${selectedGame.homeTeamCode}';

                // DB에서 가져온 로고 이미지 URL 직접 할당 (없을 경우 기본 이미지)
                $('#awayTeamLogo').attr('src', '${selectedGame.awayTeamLogo}' || '/img/team_default.svg');
                $('#homeTeamLogo').attr('src', '${selectedGame.homeTeamLogo}' || '/img/team_default.svg');

                // MY 팀 배지 처리
                const myTeam = '${sessionScope.loginMember.myTeamCode}';
                if (aCode === myTeam) $('#awayMyTeam').show();
                if (hCode === myTeam) $('#homeMyTeam').show();

                $('#btnNext').prop('disabled', false);

                // 컨트롤러에서 넘겨준 인증 상태(isAttended)를 감지하여 UI 즉시 반영
                if ('${isAttended}' === 'true') {
                    $('#isVerified').val('true');
                    $('#btnVerify').text('인증 완료')
                        .prop('disabled', true)
                        .css({'background-color': '#ccc', 'color': '#fff', 'border': 'none', 'cursor': 'not-allowed'});
                }
            }
        });

        // 동행인 유형 UI 선택 및 토글(해제) 처리
        function selectCompanion(type, element) {
            // 현재 선택된 값 확인
            let currentVal = $('#companionType').val();

            // 1. 모든 항목의 스타일 및 이미지 초기화
            $('.check_box label img').each(function () {
                let src = $(this).attr('src');
                if (src.includes('_on.svg')) {
                    $(this).attr('src', src.replace('_on.svg', '.svg'));
                }
            });
            $('.check_box label').removeClass('check');

            // 2. 토글 로직 (재클릭 시 해제 vs 신규 클릭 시 선택)
            if (currentVal === type) {
                // 이미 선택된 버튼을 다시 누른 경우 -> 값 비우기 (선택 해제)
                $('#companionType').val('');
            } else {
                // 다른 버튼을 누르거나 처음 누른 경우 -> 값 세팅 및 스타일 적용
                $('#companionType').val(type);
                $(element).addClass('check');
                let $img = $(element).find('img');
                $img.attr('src', $img.attr('src').replace('.svg', '_on.svg'));
            }
        }

        // ----------------------------------------------------
        // 친구 태그 레이어 팝업 로직
        // ----------------------------------------------------
        let selectedFriends = [];

        function openFriendTagLayer() {
            $('#friendTagLayer').show();
            loadFriends();
        }

        function closeFriendTagLayer() {
            $('#friendTagLayer').hide();
        }

        function loadFriends() {
            $.get('/diary/api/friends', function (data) {
                let html = '';
                if (!data || data.length === 0) {
                    html = '<li style="text-align:center; padding:30px; color:#999;">팔로우한 친구가 없습니다.</li>';
                } else {
                    data.forEach(f => {
                        let isSelected = selectedFriends.find(x => x.id == f.memberId);
                        html += `<li>
                        <div class="diary_write_list nodt_line friend_info_wrap bg-gray">
                            <div class="friend_info">
                                <div class="friend_item">
                                    <div class="name">\${f.nickname}</div>
                                    <div class="friend_team">\${f.myTeamCode}</div>
                                </div>
                            </div>
                            <div class="follow-btn">
                                <button class="btn w-auto \${isSelected ? 'following' : 'follow'}" type="button"
                                        data-id="\${f.memberId}" data-name="\${f.nickname}"
                                        onclick="toggleFriendSelect(this)">
                                    \${isSelected ? '선택됨' : '선택'}
                                </button>
                            </div>
                        </div>
                    </li>`;
                    });
                }
                $('#friendListUl').html(html);
            });
        }

        function toggleFriendSelect(btn) {
            let id = $(btn).data('id');
            let name = $(btn).data('name');
            if ($(btn).hasClass('following')) {
                $(btn).removeClass('following').addClass('follow').text('선택');
                selectedFriends = selectedFriends.filter(x => x.id != id);
            } else {
                $(btn).removeClass('follow').addClass('following').text('선택됨');
                selectedFriends.push({id: id, name: name});
            }
        }

        function completeFriendSelection() {
            $('#taggedMembers').val(selectedFriends.map(x => x.id).join(','));
            let tagHtml = '';
            if (selectedFriends.length > 0) {
                selectedFriends.forEach(f => {
                    tagHtml += `<span class="tag-badge">@\${f.name} <button type="button" onclick="removeTag(\${f.id})">✕</button></span>`;
                });
                $('#taggedFriendsDisplay').html(tagHtml);
            } else {
                $('#taggedFriendsDisplay').html('함께한 친구를 태그해보세요!');
            }
            closeFriendTagLayer();
        }

        function removeTag(id) {
            selectedFriends = selectedFriends.filter(x => x.id != id);
            completeFriendSelection(); // UI 동기화
        }

        // ----------------------------------------------------

        // 1. 경기 선택 팝업 열기
        function openGameSheet() {
            $('#selectSheet').addClass('is-open');

            // 팝업 열 때마다 초기화
            tempSelectedGame = null;
            $('#selectSheetApply').prop('disabled', true);

            $.get('/diary/api/games', function (data) {
                const list = $('#selectSheetList');
                list.empty();

                if (!data || data.length === 0) {
                    list.append('<li style="text-align:center; padding:20px;">경기 일정이 없습니다.</li>');
                    return;
                }

                data.forEach(game => {
                    const title = game.awayTeamName + ' vs ' + game.homeTeamName;
                    const itemHtml = `
                        <li>
                            <button type="button"
                                data-id="\${game.gameId}"
                                data-home-name="\${game.homeTeamName}"
                                data-away-name="\${game.awayTeamName}"
                                data-home-code="\${game.homeTeamCode}"
                                data-away-code="\${game.awayTeamCode}"
                                data-home-logo="\${game.homeTeamLogo}"
                                data-away-logo="\${game.awayTeamLogo}"
                                data-status="\${game.status}"
                                data-date="\${game.gameDate}"
                                data-time="\${game.gameTime}"
                                onclick="selectGameItem(this)">
                                <span class="match">\${title}</span>
                                <span class="place">(\${game.stadiumName})</span>
                            </button>
                        </li>
                    `;
                    list.append(itemHtml);
                });
            });
        }

        function closeGameSheet() {
            $('#selectSheet').removeClass('is-open');
        }

        // 리스트 아이템 클릭 시 (바로 닫지 않고 선택 상태만 변경)
        function selectGameItem(btn) {
            // 스타일 변경 (모든 버튼 active 제거 -> 현재 버튼 active 추가)
            $('#selectSheetList button').removeClass('active');
            $(btn).addClass('active');

            // 데이터 임시 저장
            tempSelectedGame = {
                id: $(btn).data('id'),
                homeName: $(btn).data('home-name'),
                awayName: $(btn).data('away-name'),
                homeCode: $(btn).data('home-code'),
                awayCode: $(btn).data('away-code'),
                homeLogo: $(btn).data('home-logo'),
                awayLogo: $(btn).data('away-logo'),
                status: $(btn).data('status'),
                date: $(btn).data('date'),
                time: $(btn).data('time')
            };

            // 저장 버튼 활성화
            $('#selectSheetApply').prop('disabled', false);
        }

        /**
         * [최종] 경기 선택 적용 함수
         * 1. UI: 내 응원팀을 무조건 왼쪽(HOME 위치)에 배치하여 입력 편의성 제공
         * 2. Data: 실제 홈/원정 여부에 따라 input name 속성을 동적으로 변경하여 서버 데이터 정합성 유지
         */
        function applyGameSelection() {
            if (!tempSelectedGame) return;

            const g = tempSelectedGame;
            const myTeamCode = '${sessionScope.loginMember.myTeamCode}';

            // 1. 게임 ID 설정
            $('#gameId').val(g.id);

            // 2. 상단 텍스트 표기
            $('#gameSelectText').text(g.awayName + ' vs ' + g.homeName)
                .css('color', '#000').css('font-weight', 'bold');

            // 3. 화면 업데이트 (원정은 무조건 왼쪽, 홈은 무조건 오른쪽)
            $('#awayTeamName').text(g.awayName);
            $('#homeTeamName').text(g.homeName);

            // DB에 저장된 로고 경로를 바로 적용 (없을 경우 기본 이미지 매핑)
            $('#awayTeamLogo').attr('src', g.awayLogo || '/img/team_default.svg');
            $('#homeTeamLogo').attr('src', g.homeLogo || '/img/team_default.svg');

            // 4. MY 뱃지 표시 제어
            if (g.awayCode === myTeamCode) $('#awayMyTeam').show(); else $('#awayMyTeam').hide();
            if (g.homeCode === myTeamCode) $('#homeMyTeam').show(); else $('#homeMyTeam').hide();

            // 모든 시간 및 날짜 제약 로직 완전히 제거 (언제든 스코어 입력 및 작성 가능)
            // 주석 처리된 UI지만 추후 부활 시 정상 작동을 위해 readonly 속성 해제
            const $scoreAway = $('input[name="predScoreAway"]');
            const $scoreHome = $('input[name="predScoreHome"]');
            $scoreAway.prop('readonly', false).css({'background-color': '', 'color': '#000'});
            $scoreHome.prop('readonly', false).css({'background-color': '', 'color': '#000'});
            $('#scoreInputWrap').addClass('clr');

            $('#btnNext').prop('disabled', false);

            // 다른 경기를 선택하면 서버에 해당 경기의 인증 여부를 다시 물어보고 버튼 상태 세팅
            $.get('/diary/api/check-attendance?gameId=' + g.id, function(res) {
                if (res === 'true') {
                    $('#isVerified').val('true');
                    $('#btnVerify').text('인증 완료')
                        .prop('disabled', true)
                        .css({'background-color': '#ccc', 'color': '#fff', 'border': 'none', 'cursor': 'not-allowed'});
                } else {
                    $('#isVerified').val('false');
                    $('#btnVerify').text('직관 인증하기')
                        .prop('disabled', false)
                        .css({'background-color': '', 'color': '', 'cursor': 'pointer', 'opacity': '1'});
                }
            });

            closeGameSheet();
        }

        // 직관 인증 함수
        async function certifyLocation() {
            const gameId = $('#gameId').val();
            if (!gameId) {
                alert('먼저 기록할 경기를 선택해주세요.');
                openGameSheet();
                return;
            }

            const $btn = $('#btnVerify');
            const originalText = $btn.text();

            $btn.text('위치 확인 중...').prop('disabled', true).css('opacity', '0.7');

            let lat = 0, lon = 0;

            try {
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

                $.ajax({
                    url: '/diary/verify/gps',
                    type: 'POST',
                    data: { gameId: gameId, lat: lat, lon: lon },
                    success: function(res) {
                        if (res === 'ok') {
                            alert('직관 인증 성공! 🎉');
                            // 성공 시 상태값 true 로 변경 및 버튼 회색 처리
                            $('#isVerified').val('true');
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
                            $btn.text('인증 시간 전')
                                .css({'background-color': '#ccc', 'color': '#fff', 'border': 'none', 'cursor': 'not-allowed'})
                                .prop('disabled', true);
                        } else if (res === 'fail:timeout') {
                            alert('경기 시작 후 2시간이 지나 인증이 마감되었습니다.');
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

        // 3. 이미지 미리보기
        // 사진 다중 업로드 관리 로직
        let selectedFiles = [];
        const MAX_FILES = 4;

        function handleFileSelect(input) {
            const files = input.files;
            if (!files || files.length === 0) return;

            let total = selectedFiles.length + files.length;
            if (total > MAX_FILES) {
                alert('사진은 최대 4장까지 업로드 가능합니다.');
            }

            // 용량 및 확장자 체크 기준 설정
            const maxSize = 10 * 1024 * 1024; // 10MB
            const validTypes = ['image/jpeg', 'image/png'];

            for (let i = 0; i < files.length; i++) {
                const file = files[i];

                // 1. 용량 검사 (10MB 초과 시 통과 안 됨)
                if (file.size > maxSize) {
                    alert('[' + file.name + '] 파일 용량이 10MB를 초과합니다.');
                    continue;
                }

                // 2. 확장자 검사 (JPG, PNG 외 통과 안 됨)
                if (!validTypes.includes(file.type)) {
                    alert('[' + file.name + '] JPG, PNG 파일만 업로드 가능합니다.');
                    continue;
                }

                // 조건 통과 & 최대 4장 제한에 걸리지 않는 파일만 최종 배열에 추가
                if (selectedFiles.length < MAX_FILES) {
                    selectedFiles.push(file);
                }
            }
            renderPreviews();
            input.value = ''; // 재선택 가능하도록 초기화
        }

        function removeFile(index) {
            selectedFiles.splice(index, 1);
            renderPreviews();
        }

        function renderPreviews() {
            const box = $('#imagePreviewBox');
            box.empty();
            if (selectedFiles.length === 0) {
                box.hide();
                return;
            }
            box.show();

            selectedFiles.forEach((file, index) => {
                const divId = 'preview_new_' + index;
                const html = `<div id="\${divId}" style="position:relative; display:inline-block; margin-right:8px; width:80px; height:80px;">
                              <img src="" style="width:100%; height:100%; object-fit:cover; border-radius:8px;">
                              <button type="button" onclick="removeFile(\${index})" style="position:absolute; top:-6px; right:-6px; background:#fff; border-radius:50%; padding:2px; border:1px solid #ddd; width:24px; height:24px; display:flex; align-items:center; justify-content:center;">
                                  <img src="/img/ico_del.svg" style="width:14px;">
                              </button>
                            </div>`;
                box.append(html);

                const reader = new FileReader();
                reader.onload = function (e) {
                    $('#' + divId + ' img').first().attr('src', e.target.result);
                };
                reader.readAsDataURL(file);
            });
        }

        // 4. 제출
        function submitDiary() {

            // 터치 시 짧은 진동 피드백
            if (typeof vibrateSuccess === 'function') vibrateSuccess();

            // 1) 필수값 체크: 경기 선택 (req 클래스 항목)
            if (!$('#gameId').val()) {
                if (typeof vibrateError === 'function') vibrateError(); // 에러 진동
                alert('경기를 선택해주세요.', function () {
                    openGameSheet();
                });
                return;
            }

            // 2) 필수값 체크: 수훈선수
            if (!$('#heroName').val().trim()) {
                if (typeof vibrateError === 'function') vibrateError();
                alert('오늘의 수훈선수를 입력해 주세요.', function () {
                    $('#heroName').focus();
                });
                return;
            }

            // 3) 필수값 체크: 경기 한 줄 요약
            if (!$('#oneLine').val().trim()) {
                if (typeof vibrateError === 'function') vibrateError();
                alert('경기 한 줄 요약을 입력해 주세요.', function () {
                    $('#oneLine').focus();
                });
                return;
            }

            // 4) 필수값 체크: 직관 일기 내용
            if (!$('textarea[name="content"]').val().trim()) {
                if (typeof vibrateError === 'function') vibrateError();
                alert('오늘의 직관 이야기를 입력해 주세요.', function () {
                    $('textarea[name="content"]').focus();
                });
                return;
            }

            // 폼 전송 직전, 배열에 모아둔 파일들을 실제 input에 옮겨 담기
            const dataTransfer = new DataTransfer();
            selectedFiles.forEach(file => {
                dataTransfer.items.add(file);
            });
            document.getElementById('fileUpload').files = dataTransfer.files;

            // 프론트 인증 상태 체크
            const isVerified = $('#isVerified').val();

            if (isVerified !== 'true') {
                // 인증을 하지 않은 경우 customConfirm 실행
                customConfirm("정말로 직관 인증을 하지 않고 저장하시겠어요?\n인증 시, 승률 계산에 반영돼요!",
                    function() {
                        // [확인] 폼 제출 진행
                        $('#diaryForm').submit();
                    },
                    function() {
                        // [취소] 팝업만 닫히고 폼 전송 안됨
                    }
                );
            } else {
                // 인증된 상태면 바로 제출
                $('#diaryForm').submit();
            }
        }
    </script>
</body>
</html>