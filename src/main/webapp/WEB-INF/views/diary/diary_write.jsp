<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
              <div class="page-tit">직관일기</div>

              <div class="location-certify">
                  <button class="btn btn-certify w-auto" type="button" id="btnVerify" onclick="certifyLocation()">
                      직관 인증하기
                  </button>
                  <button class="btn btn-certify-comp w-auto" type="button" id="verifyComplete" style="display:none;">
                      직관 인증완료!
                  </button>
              </div>
          </div>

          <ul class="comment">
              <li>직관일기는 한 경기당 1개만 기록할 수 있어요.</li>
              <li>경기 시작 1시간 전까지는 다시 수정할 수 있어요.</li>
          </ul>

          <form id="diaryForm" action="/diary/write" method="post" enctype="multipart/form-data">
              <input type="hidden" name="gameId" id="gameId" value="${targetGameId}">
              <input type="hidden" name="isVerified" id="isVerified" value="false">
              <input type="hidden" name="rating" value="5">

              <div class="page-main_wrap">
                  <div class="history">
                      <div class="history-list mt-24">
                          <div class="diary_write_form">

                              <div class="diary_write_list req">
                                  <div class="tit">오늘, 직관 가세요?</div>
                                  <button type="button" class="select-field" onclick="openGameSheet()">
                                      <c:choose>
                                          <c:when test="${not empty selectedGame}">
                                                  <span class="select-field_value" style="color:#000; font-weight:bold;">
                                                      ${selectedGame.homeTeamName} vs ${selectedGame.awayTeamName}
                                                  </span>
                                          </c:when>
                                          <c:otherwise>
                                              <span class="select-field_value" id="gameSelectText">경기를 선택해주세요</span>
                                          </c:otherwise>
                                      </c:choose>
                                  </button>
                              </div>

                              <div class="diary_write_list req">
                                  <div class="tit">오늘의 스코어 예상해 본다면?</div>
                                  <div class="card_item">
                                      <div class="game-board">
                                          <div class="row row-center gap-24">
                                              <div class="team" id="homeTeamBox">
                                                  <div class="my-team" id="homeMyTeam" style="display:none;">MY</div>
                                                  <div class="team-name" id="homeTeamName">HOME</div>
                                              </div>

                                              <div class="game-score schedule">
                                                  <div class="left-team-score">
                                                      <input type="number" name="predScoreHome" placeholder="0">
                                                  </div>
                                                  <div class="game-info-wrap">VS</div>
                                                  <div class="right-team-score">
                                                      <input type="number" name="predScoreAway" placeholder="0">
                                                  </div>
                                              </div>

                                              <div class="team" id="awayTeamBox">
                                                  <div class="my-team" id="awayMyTeam" style="display:none;">MY</div>
                                                  <div class="team-name" id="awayTeamName">AWAY</div>
                                              </div>
                                          </div>
                                      </div>
                                  </div>
                              </div>

                              <div class="diary_write_list">
                                  <div class="tit">오늘의 히어로는 누구일까?</div>
                                  <input type="text" name="heroName" placeholder="텍스트를 입력하세요.">
                              </div>

                              <div class="diary_write_list">
                                  <div class="tit">오늘의 경기를 한 마디로 평가한다면?!</div>
                                  <input type="text" name="oneLineComment" id="oneLine" placeholder="텍스트를 입력하세요.">
                              </div>

                              <div class="diary_write_list">
                                  <div class="tit">오늘의 경기를 기록해 보세요</div>
                                  <textarea name="content" placeholder="최대 100자까지 입력하실 수 있습니다."></textarea>
                              </div>

                              <div class="diary_write_list">
                                  <div class="tit">오늘 경기 사진을 올려보세요</div>
                                  <button type="button" class="btn btn-primary gap-4"
                                          onclick="document.getElementById('fileUpload').click();">
                                      사진 올리기
                                      <span><img src="/img/ico_plus.svg" alt="플러스 아이콘"></span>
                                  </button>
                                  <input type="file" id="fileUpload" name="file" style="display:none;" accept="image/*"
                                         onchange="previewImage(this)">

                                  <div class="upload" id="imagePreviewBox" style="display:none;">
                                      <img id="imagePreview" src="" alt="미리보기">
                                      <button class="del" type="button" onclick="deleteImage()">
                                          <img src="/img/ico_del.svg" alt="삭제">
                                      </button>
                                  </div>
                              </div>

                              <ul class="disClose">
                                  <li>
                                      <label class="check">
                                          <input type="radio" name="isPublic" value="PUBLIC" checked>
                                          전체공개
                                      </label>
                                  </li>
                                  <li>
                                      <label class="check">
                                          <input type="radio" name="isPublic" value="FRIENDS">
                                          맞팔 공개
                                      </label>
                                  </li>
                                  <li>
                                      <label class="check">
                                          <input type="radio" name="isPublic" value="PRIVATE">
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

  <%@ include file="../include/popup.jsp" %>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="/js/script.js"></script>
  <script>
      // 임시 저장용 변수 (팝업 내 선택값)
      let tempSelectedGame = null;

      $(document).ready(function () {
          // 초기 로드 시 선택된 경기 UI 세팅
          if ('${targetGameId}' !== '') {
              $('#homeTeamName').text('${selectedGame.homeTeamName}');
              $('#awayTeamName').text('${selectedGame.awayTeamName}');

              const myTeam = '${sessionScope.loginMember.myTeamCode}';
              if ('${selectedGame.homeTeamCode}' === myTeam) $('#homeMyTeam').show();
              if ('${selectedGame.awayTeamCode}' === myTeam) $('#awayMyTeam').show();

              $('#btnNext').prop('disabled', false);
          }
      });

      // 1. 경기 선택 팝업 열기
      function openGameSheet() {
          $('#selectSheet').show();
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
                  const title = game.homeTeamName + ' vs ' + game.awayTeamName;
                  // 데이터 속성에 필요한 정보 담기
                  const itemHtml = `
                          <li>
                              <button type="button"
                                  data-id="\${game.gameId}"
                                  data-home-name="\${game.homeTeamName}"
                                  data-away-name="\${game.awayTeamName}"
                                  data-home-code="\${game.homeTeamCode}"
                                  data-away-code="\${game.awayTeamCode}"
                                  onclick="selectGameItem(this)">
                                  <span class="match">\${title}</span>
                                  <span class="place">\${game.stadiumName}</span>
                              </button>
                          </li>
                      `;
                  list.append(itemHtml);
              });
          });
      }

      function closeGameSheet() {
          $('#selectSheet').hide();
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
              awayCode: $(btn).data('away-code')
          };

          // 저장 버튼 활성화
          $('#selectSheetApply').prop('disabled', false);
      }

      // 저장 버튼 클릭 시 실제 반영
      function applyGameSelection() {
          if (!tempSelectedGame) return;

          const g = tempSelectedGame;

          // 폼 값 적용
          $('#gameId').val(g.id);
          $('#gameSelectText').text(g.homeName + ' vs ' + g.awayName).css('color', '#000').css('font-weight', 'bold');

          // 스코어 보드 업데이트
          $('#homeTeamName').text(g.homeName);
          $('#awayTeamName').text(g.awayName);

          // 내 팀 배지 표시
          const myTeam = '${sessionScope.loginMember.myTeamCode}';
          $('#homeMyTeam').hide();
          $('#awayMyTeam').hide();
          if (g.homeCode === myTeam) $('#homeMyTeam').show();
          if (g.awayCode === myTeam) $('#awayMyTeam').show();

          $('#btnNext').prop('disabled', false);

          closeGameSheet();
      }

      // 2. 직관 인증
      function certifyLocation() {
          $('#btnVerify').hide();
          $('#verifyComplete').show();
          $('#isVerified').val('true');
      }

      // 3. 이미지 미리보기
      function previewImage(input) {
          if (input.files && input.files[0]) {
              const reader = new FileReader();
              reader.onload = function (e) {
                  $('#imagePreview').attr('src', e.target.result);
                  $('#imagePreviewBox').show();
              }
              reader.readAsDataURL(input.files[0]);
          }
      }

      function deleteImage() {
          $('#fileUpload').val('');
          $('#imagePreviewBox').hide();
      }

      // 4. 제출
      function submitDiary() {
          if (!$('#gameId').val()) {
              alert('경기를 선택해주세요.', function() {
                  // 경기 선택 팝업 열기 등의 후속 조치
                  openGameSheet();
              });
              return;
          }
          if (!$('#oneLine').val()) {
              alert('오늘 경기에 대한 한줄평을 남겨주세요!', function() {
                  $('#oneLine').focus();
              });
              return;
          }
          $('#diaryForm').submit();
      }
  </script>
</body>
</html>