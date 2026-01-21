<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
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
    <title>일기 수정 | 승요일기</title>
    <style>
        .upload img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 8px;
        }
    </style>
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

                                <div class="diary_write_list req">
                                    <div class="tit">직관한 경기</div>
                                    <button type="button" class="select-field" disabled>
                                            <span class="select-field_value" style="color:#000; font-weight:bold;">
                                                ${selectedGame.homeTeamName} vs ${selectedGame.awayTeamName}
                                            </span>
                                    </button>
                                </div>

                                <div class="diary_write_list req">
                                    <div class="tit">스코어 예상 수정</div>
                                    <div class="card_item">
                                        <div class="game-board">
                                            <div class="row row-center gap-24">
                                                <div class="team">
                                                    <div class="team-name">${selectedGame.homeTeamName}</div>
                                                </div>
                                                <div class="game-score schedule">
                                                    <div class="left-team-score">
                                                        <input type="number" name="predScoreHome"
                                                               value="${diary.predScoreHome}">
                                                    </div>
                                                    <div class="game-info-wrap">VS</div>
                                                    <div class="right-team-score">
                                                        <input type="number" name="predScoreAway"
                                                               value="${diary.predScoreAway}">
                                                    </div>
                                                </div>
                                                <div class="team">
                                                    <div class="team-name">${selectedGame.awayTeamName}</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="diary_write_list">
                                    <div class="tit">오늘의 히어로는 누구일까?</div>
                                    <input type="text" name="heroName" value="${diary.heroName}">
                                </div>

                                <div class="diary_write_list">
                                    <div class="tit">오늘의 경기를 한 마디로 평가한다면?!</div>
                                    <input type="text" name="oneLineComment" id="oneLine" value="${diary.oneLineComment}">
                                </div>

                                <div class="diary_write_list">
                                    <div class="tit">오늘의 경기를 기록해 보세요</div>
                                    <textarea name="content">${diary.content}</textarea>
                                </div>

                                <div class="diary_write_list">
                                    <div class="tit">오늘 경기 사진</div>
                                    <button type="button" class="btn btn-primary gap-4"
                                            onclick="document.getElementById('fileUpload').click();">
                                        사진 변경하기
                                        <span><img src="/img/ico_plus.svg" alt="플러스"></span>
                                    </button>
                                    <input type="file" id="fileUpload" name="file" style="display:none;" accept="image/*"
                                           onchange="previewImage(this)">

                                    <div class="upload" id="imagePreviewBox"
                                         style="${empty diary.imageUrl ? 'display:none;' : 'display:block;'}">
                                        <img id="imagePreview" src="${empty diary.imageUrl ? '' : diary.imageUrl}"
                                             alt="미리보기">
                                        <button class="del" type="button" onclick="deleteImage()">
                                            <img src="/img/ico_del.svg" alt="삭제">
                                        </button>
                                    </div>
                                </div>

                                <ul class="disClose">
                                    <li>
                                        <label class="check">
                                            <input type="radio" name="isPublic"
                                                   value="PUBLIC" ${diary.isPublic eq 'PUBLIC' ? 'checked' : ''}>
                                            전체공개
                                        </label>
                                    </li>
                                    <li>
                                        <label class="check">
                                            <input type="radio" name="isPublic"
                                                   value="FRIENDS" ${diary.isPublic eq 'FRIENDS' ? 'checked' : ''}>
                                            맞팔 공개
                                        </label>
                                    </li>
                                    <li>
                                        <label class="check">
                                            <input type="radio" name="isPublic"
                                                   value="PRIVATE" ${diary.isPublic eq 'PRIVATE' ? 'checked' : ''}>
                                            비공개
                                        </label>
                                    </li>
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

    <%@ include file="../include/popup.jsp" %>

    <script src="/js/script.js"></script>
    <script>
        // 이미지 미리보기
        function previewImage(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    document.getElementById('imagePreview').src = e.target.result;
                    document.getElementById('imagePreviewBox').style.display = 'block';
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        // 이미지 삭제 (화면상에서만 안 보이게, 실제로는 빈 값 전송 필요할 수도 있음)
        function deleteImage() {
            document.getElementById('fileUpload').value = '';
            document.getElementById('imagePreview').src = '';
            document.getElementById('imagePreviewBox').style.display = 'none';
            // 기존 이미지도 삭제하고 싶다면 hidden input 값을 비워야 함
            document.getElementsByName('imageUrl')[0].value = '';
        }

        // 제출
        function submitDiary() {
            if (!document.getElementById('oneLine').value) {
                alert('한줄평을 입력해주세요.');
                return;
            }
            document.getElementById('diaryForm').submit();
        }
    </script>
</body>
</html>