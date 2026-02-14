<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
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

    <title>일기 수정 | 승요일기</title>

    <style>
        .upload img {
            width: 100%;
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
                <input type="hidden" name="imageUrl" value="${diary.imageUrl}">

                <div class="page-main_wrap">
                    <div class="history">
                        <div class="history-list mt-24">
                            <div class="diary_write_form">

                                <div class="diary_write_list req diary_character">
                                    <div class="tit">직관한 경기</div>
                                    <button type="button" class="select-field" disabled style="opacity: 1; cursor: default;">
                                            <span class="select-field_value" style="color:#000; font-weight:bold;">
                                                [${diary.stadiumName}] ${diary.homeTeamName} vs ${diary.awayTeamName}
                                                <span style="font-weight:400; font-size:13px; margin-left:4px;">
                                                    (${fn:substring(diary.gameDate, 5, 7)}.${fn:substring(diary.gameDate, 8, 10)})
                                                </span>
                                            </span>
                                    </button>
                                </div>

                                <div class="diary_write_list req diary_character yellow">
                                    <div class="tit">스코어를 수정하시겠어요?</div>
                                    <div class="card_item">
                                        <div class="game-board">
                                            <div class="row row-center gap-24">
                                                <div class="team">
                                                    <div class="team-logo mb-8"> <img src="/img/logo/logo_${fn:toLowerCase(diary.homeTeamCode)}.svg"
                                                                                      alt="${diary.homeTeamName}"
                                                                                      style="height: 48px; width: auto; object-fit: contain;"
                                                                                      onerror="this.src='/img/logo/logo_default.svg'">
                                                    </div>

                                                    <div class="team-name">${diary.homeTeamName}</div>
                                                    <div class="text-12 color-gray mt-4">${diary.homeStarter}</div>
                                                </div>

                                                <div class="game-score schedule">
                                                    <div class="left-team-score">
                                                        <input type="number" name="predScoreHome" value="${diary.predScoreHome}" placeholder="0">
                                                    </div>
                                                    <div class="game-info-wrap">VS</div>
                                                    <div class="right-team-score">
                                                        <input type="number" name="predScoreAway" value="${diary.predScoreAway}" placeholder="0">
                                                    </div>
                                                </div>

                                                <div class="team">
                                                    <div class="team-logo mb-8">
                                                        <img src="/img/logo/logo_${fn:toLowerCase(diary.awayTeamCode)}.svg"
                                                             alt="${diary.awayTeamName}"
                                                             style="height: 48px; width: auto; object-fit: contain;"
                                                             onerror="this.src='/img/logo/logo_default.svg'">
                                                    </div>

                                                    <div class="team-name">${diary.awayTeamName}</div>
                                                    <div class="text-12 color-gray mt-4">${diary.awayStarter}</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="diary_write_list">
                                    <div class="tit">오늘의 히어로는 누구일까?</div>
                                    <input type="text" name="heroName" id="heroName" value="${diary.heroName}" placeholder="오늘의 히어로 선수는?">
                                </div>

                                <div class="diary_write_list">
                                    <div class="tit">오늘의 경기를 한 마디로 평가한다면?!</div>
                                    <input type="text" name="oneLineComment" id="oneLine" value="${diary.oneLineComment}" placeholder="오늘의 경기는 어떠셨나요?">
                                </div>

                                <div class="diary_write_list">
                                    <div class="tit">오늘의 경기를 기록해 보세요</div>
                                    <textarea name="content" placeholder="최대 100자까지 입력하실 수 있습니다.">${diary.content}</textarea>
                                </div>

                                <div class="diary_write_list">
                                    <div class="tit">오늘 경기 사진을 올려보세요</div>
                                    <button type="button" class="btn btn-primary gap-4" onclick="document.getElementById('fileUpload').click();">
                                        사진 변경하기
                                        <span><img src="/img/ico_plus.svg" alt="플러스 아이콘"></span>
                                    </button>
                                    <input type="file" id="fileUpload" name="file" style="display:none;" accept="image/*" onchange="previewImage(this)">

                                    <div class="upload" id="imagePreviewBox" style="${not empty diary.imageUrl ? 'display:block;' : 'display:none;'}">
                                        <img id="imagePreview" src="${not empty diary.imageUrl ? diary.imageUrl : ''}" alt="미리보기">
                                        <button class="del" type="button" onclick="deleteImage()">
                                            <img src="/img/ico_del.svg" alt="삭제">
                                        </button>
                                    </div>
                                </div>

                                <div class="diary_write_list">
                                    <ul class="disClose">
                                        <li>
                                            <label class="check">
                                                <input type="radio" name="isPublic" value="PUBLIC" ${diary.isPublic eq 'PUBLIC' ? 'checked' : ''}>
                                                전체공개
                                            </label>
                                        </li>
                                        <li>
                                            <label class="check">
                                                <input type="radio" name="isPublic" value="FRIENDS" ${diary.isPublic eq 'FRIENDS' ? 'checked' : ''}>
                                                맞팔 공개
                                            </label>
                                        </li>
                                        <li>
                                            <label class="check">
                                                <input type="radio" name="isPublic" value="PRIVATE" ${diary.isPublic eq 'PRIVATE' ? 'checked' : ''}>
                                                비공개
                                            </label>
                                        </li>
                                    </ul>
                                </div>

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

    <%@ include file="../include/popup.jsp" %>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>

    <script>
        // 이미지 미리보기
        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('imagePreview').src = e.target.result;
                    document.getElementById('imagePreviewBox').style.display = 'block';
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        // 이미지 삭제
        function deleteImage() {
            document.getElementById('fileUpload').value = '';
            document.getElementById('imagePreview').src = '';
            document.getElementById('imagePreviewBox').style.display = 'none';
            // 기존 이미지 삭제 플래그 처리 필요 시 추가 (여기서는 빈값 처리)
            document.getElementsByName('imageUrl')[0].value = '';
        }

        // 제출
        function submitDiary() {
            // 1) 필수값 체크: 스코어 (req 클래스 항목)
            var scoreHome = $('input[name="predScoreHome"]');
            var scoreAway = $('input[name="predScoreAway"]');

            if (scoreHome.val() === '' || scoreAway.val() === '') {
                alert('스코어를 입력해주세요!', function() {
                    if(scoreHome.val() === '') scoreHome.focus();
                    else scoreAway.focus();
                });
                return;
            }

            // 2) 히어로(MVP) 필수 입력 체크
            /*var heroInput = document.getElementById('heroName');
            if (!heroInput || !heroInput.value.trim()) {
                alert('오늘의 히어로(MVP)를 입력해주세요!', function() {
                    if(heroInput) heroInput.focus();
                });
                return;
            }*/

            // 3) 한줄평 체크
            /*var oneLineInput = document.getElementById('oneLine');
            if (!oneLineInput || !oneLineInput.value.trim()) {
                alert('한줄평을 입력해주세요.', function() {
                    if(oneLineInput) oneLineInput.focus();
                });
                return;
            }*/

            /*
            if (!$('#fileUpload').val() && $('#imagePreview').attr('src') === "") {
                alert('직관 인증샷을 등록해주세요! 📸');
                return;
            }
            */

            // vibrateSuccess(); // 햅틱 진동 (함수가 script.js 등에 있다면 주석 해제)
            document.getElementById('diaryForm').submit();
        }
    </script>
</body>
</html>