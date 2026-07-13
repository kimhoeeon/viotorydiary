<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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

    <title>일기 수정 | 승요일기</title>

    <style>
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
                <div class="page-tit">일기 수정</div>
            </div>

            <form id="diaryForm" action="/diary/update" method="post" enctype="multipart/form-data">
                <input type="hidden" name="diaryId" value="${diary.diaryId}">
                <input type="hidden" name="gameId" value="${diary.gameId}">

                <!-- 기존 동행인 및 태그 친구 데이터를 세팅하여 서버로 전송할 hidden input -->
                <input type="hidden" name="companionType" id="companionType" value="${diary.companionType}">

                <!-- 기존에 태그된 친구 리스트의 ID를 콤마(,)로 연결 -->
                <c:set var="tagIds" value=""/>
                <c:if test="${not empty diary.taggedMemberList}">
                    <c:forEach var="friend" items="${diary.taggedMemberList}" varStatus="status">
                        <c:set var="tagIds" value="${tagIds}${friend.memberId}${!status.last ? ',' : ''}" />
                    </c:forEach>
                </c:if>
                <input type="hidden" name="taggedMembers" id="taggedMembers" value="${tagIds}">

                <div class="page-main_wrap">
                    <div class="history">
                        <div class="history-list mt-24">
                            <div class="diary_write_form">

                                <div class="diary_write_list req diary_character">
                                    <div class="tit">직관한 경기</div>
                                    <button type="button" class="select-field" disabled style="opacity: 1; cursor: default;">
                                        <span class="select-field_value" style="color:#000; font-weight:bold;">
                                            [${diary.stadiumName}] ${diary.awayTeamName} vs ${diary.homeTeamName}
                                            <span style="font-weight:400; font-size:13px; margin-left:4px;">
                                                (${fn:substring(diary.gameDate, 5, 7)}.${fn:substring(diary.gameDate, 8, 10)})
                                            </span>
                                        </span>
                                    </button>
                                </div>

                                <%--<div class="diary_write_list req diary_character yellow ${isScoreEditable ? 'clr' : ''}">
                                    <div class="tit">
                                        <c:choose>
                                            <c:when test="${isScoreEditable}">스코어를 수정하시겠어요?</c:when>
                                            <c:otherwise>내가 예상한 스코어 <span style="font-size:12px; color:#ff4d4d; font-weight:normal;">(스코어 수정 불가)</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="card_item">
                                        <div class="game-board">
                                            <div class="row row-center gap-6">

                                                <div class="team">
                                                    <div class="team-logo mb-8">
                                                        <img src="${diary.awayTeamLogo}" alt="${diary.awayTeamName}" style="height: 48px; width: auto; object-fit: contain;">
                                                    </div>

                                                    <div class="team-name">${diary.awayTeamName}</div>
                                                    <div class="starting mt-4">${diary.awayStarter}</div>
                                                </div>

                                                <div class="game-score schedule">
                                                    <div class="left-team-score">
                                                        <c:choose>
                                                            <c:when test="${isScoreEditable}">
                                                                <input type="number" name="predScoreAway" value="${diary.predScoreAway}" min="0" max="99" oninput="if(this.value > 99) this.value = 99; if(this.value !== '' && this.value < 0) this.value = 0;" placeholder="0">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <input type="number" name="predScoreAway" value="${diary.predScoreAway}" readonly style="background:transparent; border:none; text-align:center; font-size:24px; font-weight:bold; color:#000;" min="0" max="99" oninput="if(this.value > 99) this.value = 99; if(this.value !== '' && this.value < 0) this.value = 0;" placeholder="0">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="game-info-wrap">VS</div>
                                                    <div class="right-team-score">
                                                        <c:choose>
                                                            <c:when test="${isScoreEditable}">
                                                                <input type="number" name="predScoreHome" value="${diary.predScoreHome}" min="0" max="99" oninput="if(this.value > 99) this.value = 99; if(this.value !== '' && this.value < 0) this.value = 0;" placeholder="0">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <input type="number" name="predScoreHome" value="${diary.predScoreHome}" readonly style="background:transparent; border:none; text-align:center; font-size:24px; font-weight:bold; color:#000;" min="0" max="99" oninput="if(this.value > 99) this.value = 99; if(this.value !== '' && this.value < 0) this.value = 0;" placeholder="0">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                                <div class="team">
                                                    <div class="team-logo mb-8">
                                                        <img src="${diary.homeTeamLogo}" alt="${diary.homeTeamName}" style="height: 48px; width: auto; object-fit: contain;">
                                                    </div>

                                                    <div class="team-name">${diary.homeTeamName}</div>
                                                    <div class="starting mt-4">${diary.homeStarter}</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>--%>

                                <div class="diary_write_list req">
                                    <div class="tit">오늘의 수훈선수는?</div>
                                    <input type="text" name="heroName" id="heroName" value="${diary.heroName}" maxlength="100" placeholder="선수 이름을 입력해 주세요.">
                                </div>

                                <div class="diary_write_list req">
                                    <div class="tit">경기 한 줄 요약</div>
                                    <input type="text" name="oneLineComment" id="oneLine" value="${diary.oneLineComment}" maxlength="100" placeholder="오늘 경기의 한 줄 요약을 남겨보세요.">
                                </div>

                                <div class="diary_write_list req">
                                    <div class="tit">오늘의 직관 일기</div>
                                    <textarea name="content" maxlength="1000" placeholder="오늘의 직관 이야기를 들려주세요!">${diary.content}</textarea>
                                </div>

                                <div class="diary_write_list clr">
                                    <div class="tit">직관 사진을 올려주세요 <span>(선택)</span></div>
                                    <button type="button" class="btn btn-primary gap-4" onclick="document.getElementById('fileUpload').click();">
                                        사진 변경하기 (최대 4장)
                                        <span><img src="/img/ico_plus.svg" alt="플러스 아이콘"></span>
                                    </button>
                                    <input type="file" id="fileUpload" name="files" style="display:none;" accept="image/jpeg, image/png" multiple onchange="handleFileSelect(this)">

                                    <div class="upload" id="imagePreviewBox" style="display:none; margin-top:12px; white-space: nowrap; overflow-x: auto; padding-bottom: 8px;"></div>
                                    <div class="file-mes"><img src="/img/ico_not_mark_blue.svg" alt="주의 아이콘">최대 10MB 의 JPG, PNG만 등록 가능합니다.</div>
                                </div>

                                <div class="diary_write_list clr">
                                    <div class="tit">누구와 함께했나요? <span>(선택)</span></div>
                                    <div class="check_box">
                                        <ul>
                                            <li><label class="${diary.companionType eq 'ALONE' ? 'check' : ''}" onclick="selectCompanion('ALONE', this)"><img src="${diary.companionType eq 'ALONE' ? '/img/check_together01_on.svg' : '/img/check_together01.svg'}" alt=""><button type="button">혼자</button></label></li>
                                            <li><label class="${diary.companionType eq 'FRIEND' ? 'check' : ''}" onclick="selectCompanion('FRIEND', this)"><img src="${diary.companionType eq 'FRIEND' ? '/img/check_together02_on.svg' : '/img/check_together02.svg'}" alt=""><button type="button">친구</button></label></li>
                                            <li><label class="${diary.companionType eq 'FAMILY' ? 'check' : ''}" onclick="selectCompanion('FAMILY', this)"><img src="${diary.companionType eq 'FAMILY' ? '/img/check_together03_on.svg' : '/img/check_together03.svg'}" alt=""><button type="button">가족</button></label></li>
                                            <li><label class="${diary.companionType eq 'COUPLE' ? 'check' : ''}" onclick="selectCompanion('COUPLE', this)"><img src="${diary.companionType eq 'COUPLE' ? '/img/check_together04_on.svg' : '/img/check_together04.svg'}" alt=""><button type="button">연인</button></label></li>
                                            <li><label class="${diary.companionType eq 'COLLEAGUE' ? 'check' : ''}" onclick="selectCompanion('COLLEAGUE', this)"><img src="${diary.companionType eq 'COLLEAGUE' ? '/img/check_together05_on.svg' : '/img/check_together05.svg'}" alt=""><button type="button">직장동료</button></label></li>
                                            <li><label class="${diary.companionType eq 'ETC' ? 'check' : ''}" onclick="selectCompanion('ETC', this)"><img src="${diary.companionType eq 'ETC' ? '/img/check_together06_on.svg' : '/img/check_together06.svg'}" alt=""><button type="button">기타</button></label></li>
                                        </ul>
                                    </div>
                                    <div class="tag_box mt-16">
                                        <div class="flex" style="justify-content: space-between; align-items: center;">
                                            <div id="taggedFriendsDisplay">
                                                <c:choose>
                                                    <c:when test="${not empty diary.taggedMemberList}">
                                                        <c:forEach var="friend" items="${diary.taggedMemberList}">
                                                            <span class="tag-badge">@${friend.nickname} <button type="button" onclick="removeTag(${friend.memberId})">✕</button></span>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>함께한 친구를 태그해보세요!</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <a href="javascript:void(0);" class="tag_link" onclick="openFriendTagLayer()">
                                                <img src="/img/check_tag.svg" alt="">친구 태그하기
                                            </a>
                                        </div>
                                    </div>
                                </div>

                                <ul class="disClose">
                                    <li><label class="check"><input type="radio" name="isPublic" value="PUBLIC" ${diary.isPublic eq 'PUBLIC' ? 'checked' : ''}>전체공개</label></li>
                                    <li><label class="check"><input type="radio" name="isPublic" value="FRIENDS" ${diary.isPublic eq 'FRIENDS' ? 'checked' : ''}>맞팔 공개</label></li>
                                    <li><label class="check"><input type="radio" name="isPublic" value="PRIVATE" ${diary.isPublic eq 'PRIVATE' ? 'checked' : ''}>비공개</label></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <div class="bottom-action bottom-main">
            <button type="button" class="btn btn-primary" onclick="submitDiary()">
                수정 완료
            </button>
        </div>

    </div>

    <div id="friendTagLayer" class="app" style="display:none; position:fixed; top:0; left:0; right:0; bottom:0; z-index:99999; background:#fff; flex-direction:column;">

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

        // ----------------------------------------------------
        // [업데이트] 동행인 UI 관련 및 친구 태그 스크립트
        // ----------------------------------------------------
        let selectedFriends = [];

        // 기존에 선택되었던 친구가 있다면 자바스크립트 배열에도 세팅해줍니다.
        <c:if test="${not empty diary.taggedMemberList}">
            <c:forEach var="friend" items="${diary.taggedMemberList}">
                selectedFriends.push({id: ${friend.memberId}, name: '${friend.nickname}'});
            </c:forEach>
        </c:if>

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

        function openFriendTagLayer() {
            // 디스플레이를 flex로 변경하여 앱 레이아웃 구조(app) 유지
            $('#friendTagLayer').css('display', 'flex');
            loadFriends();
        }

        function closeFriendTagLayer() {
            $('#friendTagLayer').hide();
        }

        function loadFriends() {
            $.get('/diary/api/friends', function(data) {
                let html = '';
                if(!data || data.length === 0) {
                    html = '<li style="text-align:center; padding:30px; color:#999;">팔로우한 친구가 없습니다.</li>';
                } else {
                    data.forEach(f => {
                        let isSelected = selectedFriends.find(x => x.id == f.memberId);
                        // style.css / base.css에 정의된 .btn.follow 및 .btn.not-follow 규칙 적용
                        let btnClass = isSelected ? 'btn not-follow w-auto' : 'btn follow w-auto';
                        let btnText = isSelected ? '선택됨' : '선택';

                        // API에 winRate 필드가 존재할 경우 방어코드 추가 처리
                        let winRateHtml = (f.winRate !== undefined && f.winRate !== null)
                            ? `<div class="win_rate">승요력 \${f.winRate}%</div>` : '';

                        html += `<li>
                            <div class="diary_write_list nodt_line friend_info_wrap bg-gray">
                                <div class="friend_info">
                                    <div class="friend_item">
                                        <div class="name">\${f.nickname}</div>
                                        <div class="friend_team">\${f.myTeamCode}</div>
                                    </div>
                                    \${winRateHtml}
                                </div>
                                <div class="follow-btn">
                                    <button class="\${btnClass}" type="button"
                                            data-id="\${f.memberId}" data-name="\${f.nickname}"
                                            onclick="toggleFriendSelect(this)">
                                        \${btnText}
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

            if ($(btn).hasClass('not-follow')) {
                // 선택 해제 상태로 변경
                $(btn).removeClass('not-follow').addClass('follow').text('선택');
                selectedFriends = selectedFriends.filter(x => x.id != id);
            } else {
                // 선택 상태로 변경
                $(btn).removeClass('follow').addClass('not-follow').text('선택됨');
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
            completeFriendSelection(); // UI 강제 업데이트 동기화
        }
        // ----------------------------------------------------

        let existingImages = [];
        // 서버에서 받아온 콤마 구분자 이미지를 배열에 초기 세팅
        <c:if test="${not empty diary.imageUrl}">
            <c:set var="imgArr" value="${fn:split(diary.imageUrl, ',')}" />
            <c:forEach var="imgSrc" items="${imgArr}">
                existingImages.push('${imgSrc}');
            </c:forEach>
        </c:if>

        let selectedFiles = [];
        const MAX_FILES = 4;

        $(document).ready(function() {
            renderPreviews(); // 진입 시 기존 이미지 렌더링
        });

        function handleFileSelect(input) {
            const files = input.files;
            if (!files || files.length === 0) return;

            let total = existingImages.length + selectedFiles.length + files.length;
            if (total > MAX_FILES) {
                alert('사진은 최대 4장까지 업로드 가능합니다.');
            }

            // 용량 및 확장자 체크 기준 설정
            const maxSize = 10 * 1024 * 1024; // 10MB
            const validTypes = ['image/jpeg', 'image/png'];

            for (let i = 0; i < files.length; i++) {
                const file = files[i];

                // 1. 용량 검사
                if (file.size > maxSize) {
                    alert('[' + file.name + '] 파일 용량이 10MB를 초과합니다.');
                    continue;
                }

                // 2. 확장자 검사
                if (!validTypes.includes(file.type)) {
                    alert('[' + file.name + '] JPG, PNG 파일만 업로드 가능합니다.');
                    continue;
                }

                // 조건 통과 & (기존 이미지 + 새로 선택한 이미지)가 최대 4장 이내일 때 추가
                if (existingImages.length + selectedFiles.length < MAX_FILES) {
                    selectedFiles.push(file);
                }
            }
            renderPreviews();
            input.value = '';
        }

        function removeFile(index) {
            selectedFiles.splice(index, 1);
            renderPreviews();
        }

        function removeExistingImage(index) {
            existingImages.splice(index, 1); // 기존 이미지 삭제 시 배열에서 제거
            renderPreviews();
        }

        function renderPreviews() {
            const box = $('#imagePreviewBox');
            box.empty();
            if (selectedFiles.length === 0 && existingImages.length === 0) {
                box.hide(); return;
            }
            box.show();

            // 1. 기존 이미지 노출 (hidden 폼 전송 포함)
            existingImages.forEach((url, index) => {
                const html = `<div style="position:relative; display:inline-block; margin-right:8px; width:80px; height:80px;">
                                <img src="\${url}" style="width:100%; height:100%; object-fit:cover; border-radius:8px;">
                                <button type="button" onclick="removeExistingImage(\${index})" style="position:absolute; top:-6px; right:-6px; background:#fff; border-radius:50%; padding:2px; border:1px solid #ddd; width:24px; height:24px; display:flex; align-items:center; justify-content:center;">
                                    <img src="/img/ico_del.svg" style="width:14px;">
                                </button>
                                <input type="hidden" name="existingImages" value="\${url}">
                              </div>`;
                box.append(html);
            });

            // 2. 신규 추가 파일 노출
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
                reader.onload = function(e) {
                    $('#' + divId + ' img').first().attr('src', e.target.result);
                };
                reader.readAsDataURL(file);
            });
        }

        // 제출
        function submitDiary() {
            // 터치 시 짧은 진동 피드백
            if (typeof vibrateSuccess === 'function') vibrateSuccess();

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

            // 폼 전송 직전, 배열에 새로 추가한 파일들을 실제 input에 옮겨 담기
            const dataTransfer = new DataTransfer();
            selectedFiles.forEach(file => {
                dataTransfer.items.add(file);
            });
            document.getElementById('fileUpload').files = dataTransfer.files;

            // 폼 전송
            document.getElementById('diaryForm').submit();
        }
    </script>
</body>
</html>