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

    <title>상세보기 | 승요일기</title>

    <style>
        .team img { width: 48px; height: 48px; object-fit: contain; display: block; margin: 0 auto; }
        .review_list li.hidden-cmt { display: none; }
        .del-btn { background: none; border: none; padding: 0; cursor: pointer; }

        .result-badge { font-size: 13px; font-weight: 700; padding: 4px 10px; border-radius: 4px; display: inline-flex; align-items: center; gap: 4px; border: 1px solid var(--color-border); }
        .result-badge.win { background-color: #E8F3FF; color: var(--color-primary); border-color: #E8F3FF; }
        .result-badge.lose { background-color: #FEE8E8; color: var(--color-danger); border-color: #FEE8E8; }
        .result-badge.draw { background-color: #F1F1F1; color: #666; border-color: #F1F1F1; }
        .result-badge.none { background-color: #f5f5f5; color: #999; }

         /* 로딩 스피너 애니메이션 CSS */
         .capture-spinner {
             width: 40px;
             height: 40px;
             border: 4px solid rgba(255, 255, 255, 0.3);
             border-top: 4px solid #ffffff;
             border-radius: 50%;
             animation: capture-spin 1s linear infinite;
         }
        @keyframes capture-spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>

    <!-- swiper 외부 라이브러리 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" crossorigin="anonymous" />

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">

        <header class="app-header">
            <button class="app-header_btn app-header_back" type="button"
                    onclick="if(document.referrer) { history.back(); } else { location.href='/diary/all'; }">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main">

            <div class="app-tit">
                <div class="page-tit">
                    직관일기
                </div>
                <c:if test="${isOwner and isEditable}">
                    <a href="/diary/update?diaryId=${diary.diaryId}" class="btn btn-primary w-auto small">수정</a>
                </c:if>
            </div>

            <ul class="comment">
                <li>내가 작성한 직관일기를 저장할 수 있어요.</li>
                <li>이미지로 저장해 친구들과 공유해보세요!</li>
            </ul>

            <div class="page-main_wrap">
                <div class="history">
                    <div class="history-list mt-24">
                        <div class="card_wrap play_wrap gap-16">

                            <div class="card_item inquiry_item">
                                <div class="location-certify">
                                    <button class="btn btn-inquiry w-auto" type="button">
                                        내가 직관한 경기
                                    </button>

                                    <c:if test="${diary.verified}">
                                        <button class="btn btn-certify-comp w-auto" type="button" id="verifyComplete">
                                            직관 인증완료!
                                        </button>
                                    </c:if>

                                    <c:if test="${isOwner}">
                                        <div class="page-down">
                                            <a href="javascript:void(0);" onclick="captureCard();" class="capture-hide-btn">
                                                <img src="/img/ico_pagedown.svg" alt="페이지 캡쳐 다운로드">
                                            </a>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="inquiry_img">
                                    <div class="swiper_btn">
                                        <div class="swiper-button-prev swiperMainCntPrev"></div>
                                        <div class="swiper-button-next swiperMainCntNext"></div>
                                    </div>
                                    <div class="swiper_box">
                                        <div class="swiper swiperMainCnt">
                                            <div class="swiper-wrapper">
                                                <c:choose>
                                                    <c:when test="${not empty diary.imageUrl}">
                                                        <c:set var="imgArr" value="${fn:split(diary.imageUrl, ',')}" />
                                                        <c:forEach var="imgSrc" items="${imgArr}">
                                                            <c:if test="${not empty imgSrc}">
                                                                <div class="swiper-slide item" style="position: relative;">
                                                                    <img src="${imgSrc}" alt="직관 사진" onclick="viewImage(this.src)">
                                                                </div>
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="swiper-slide item">
                                                            <img src="/img/card_defalut.svg" alt="top banner img">
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="inquiry_game">
                                    <div class="row row-center gap-6">
                                        <div class="team">
                                            <img src="${diary.awayTeamLogo}" alt="${diary.awayTeamName}" onerror="this.src='/img/team_default.svg'">
                                            <div class="team-name mt-4">${diary.awayTeamName}</div>
                                            <div class="pitcher-name">${diary.awayStarter}</div>
                                        </div>
                                        <div class="game-score schedule">
                                            <div class="left-team-score ${diary.scoreAway > diary.scoreHome ? 'high' : ''}">${diary.scoreAway}</div>
                                            <div class="game-info-wrap">
                                                <div class="badge">
                                                    <c:choose>
                                                        <c:when test="${diary.gameStatus eq 'SCHEDULED'}">예정</c:when>
                                                        <c:when test="${diary.gameStatus eq 'LIVE'}">진행중</c:when>
                                                        <c:when test="${diary.gameStatus eq 'FINISHED'}">종료</c:when>
                                                        <c:when test="${diary.gameStatus eq 'CANCELLED'}">취소</c:when>
                                                    </c:choose>
                                                </div>

                                                <div class="game-info">
                                                    <div class="day">
                                                        <c:if test="${not empty diary.gameDate}">
                                                            <fmt:parseDate value="${diary.gameDate}" pattern="yyyy-MM-dd" var="pDate" type="date"/>
                                                            <fmt:formatDate value="${pDate}" pattern="MM.dd"/>
                                                        </c:if>
                                                    </div>
                                                    <div class="place">${diary.stadiumName}</div>
                                                </div>
                                            </div>
                                            <div class="right-team-score ${diary.scoreHome > diary.scoreAway ? 'high' : ''}">${diary.scoreHome}</div>
                                        </div>
                                        <div class="team">
                                            <img src="${diary.homeTeamLogo}" alt="${diary.homeTeamName}" onerror="this.src='/img/team_default.svg'">
                                            <div class="team-name mt-4">${diary.homeTeamName}</div>
                                            <div class="pitcher-name">${diary.homeStarter}</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="inquiry_txt">
                                    <div class="txt_box">
                                        <div class="txt_player">
                                            <div class="inquiry_badge">
                                                수훈선수
                                            </div>
                                            <div class="player">
                                                ${empty diary.heroName ? '-' : diary.heroName}
                                            </div>
                                        </div>
                                        <div class="txt_game">
                                            <div class="inquiry_badge">
                                                오늘의 경기는?
                                            </div>
                                            <div>
                                                ${empty diary.oneLineComment ? '-' : diary.oneLineComment}
                                            </div>
                                        </div>
                                    </div>

                                    <%-- 두 번째 줄: 예상 스코어 / 공개 여부 --%>
                                    <%--<div class="txt_box mt-24">
                                        <div class="inquiry_score">
                                            <div class="inquiry_badge">
                                                예상 스코어
                                            </div>
                                            <div class="score">
                                                <c:choose>
                                                    <c:when test="${not empty diary.predScoreAway and not empty diary.predScoreHome}">
                                                    <div>${diary.predScoreAway} : ${diary.predScoreHome}</div>
                                                        <c:if test="${diary.gameStatus eq 'FINISHED'}">
                                                            <c:choose>
                                                                <c:when test="${diary.predScoreHome == diary.scoreHome and diary.predScoreAway == diary.scoreAway}">
                                                                    <img src="/img/ico_check.svg" alt="체크">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="/img/ico_fail.svg" alt="실패">
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise><div>-</div></c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="inquiry_public">
                                            <div class="inquiry_badge">
                                                공개 여부
                                            </div>
                                            <div>
                                                <c:choose>
                                                    <c:when test="${diary.isPublic eq 'PUBLIC'}">전체 공개</c:when>
                                                    <c:when test="${diary.isPublic eq 'FRIENDS'}">맞팔 공개</c:when>
                                                    <c:otherwise>비공개</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>--%>

                                    <%-- 일기 본문 영역 (스크립트 제어 대상) --%>
                                    <div class="diary_desc">
                                        <div class="inquiry_badge">
                                            승요 일기
                                        </div>
                                        <div>
                                            <c:set var="trimmedContent" value="${fn:trim(diary.content)}" />
                                            <c:choose>
                                                <c:when test="${empty trimmedContent}">
                                                    -
                                                </c:when>
                                                <c:otherwise>
                                                    <% pageContext.setAttribute("newLineChar", "\n"); %>
                                                    ${fn:replace(diary.content, newLineChar, '<br/>')}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                                <div class="stamp">
                                    <c:choose>
                                        <c:when test="${diary.gameStatus eq 'FINISHED'}">
                                            <c:choose>
                                                <c:when test="${diary.gameResult eq 'WIN'}">
                                                    <img src="/img/ico_win_mark.svg" class="win_mark" alt="승리 스탬프">
                                                </c:when>
                                                <c:when test="${diary.gameResult eq 'LOSE'}">
                                                    <img src="/img/ico_lose_mark.svg" alt="패배 스탬프">
                                                </c:when>
                                                <c:when test="${diary.gameResult eq 'DRAW'}">
                                                    <img src="/img/ico_draw_mark.svg" class="draw" alt="무승부 스탬프">
                                                </c:when>
                                                <%--<c:when test="${diary.gameResult eq 'NONE'}">
                                                    <span class="result-badge none">타팀 관전</span>
                                                </c:when>--%>
                                            </c:choose>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>

                            <button class="more-btn" type="button">
                                + 일기 전체보기
                            </button>

                            <div class="card_item pt-24 pb-24">
                                <div class="review_wrap">
                                    <ul class="review_list" id="reviewList">
                                        <c:forEach var="cmt" items="${comments}" varStatus="status">
                                            <li class="${status.index >= 5 ? 'hidden-cmt' : ''}">
                                                <div class="name">
                                                    <c:if test="${not empty cmt.memberTeamCode}">
                                                        <span>${fn:substring(cmt.memberTeamCode, 0, 1)}</span>
                                                    </c:if>
                                                    ${cmt.nickname}
                                                </div>
                                                <div class="nae">${cmt.content}</div>

                                                <c:if test="${cmt.memberId eq sessionScope.loginMember.memberId or isOwner}">
                                                    <button class="del-btn" onclick="deleteComment(${cmt.commentId}, this)">
                                                        <span><img src="/img/ico_del.svg" alt="삭제"></span>
                                                    </button>
                                                </c:if>
                                            </li>
                                        </c:forEach>

                                        <c:if test="${empty comments}">
                                            <li style="text-align:center; padding:20px; color:#999; border:none; justify-content: center;">
                                                아직 작성된 댓글이 없습니다.
                                            </li>
                                        </c:if>
                                    </ul>

                                    <c:if test="${fn:length(comments) > 5}">
                                        <div class="more-btn" onclick="showAllComments(this)">
                                            <div class="btn">더 보기</div>
                                        </div>
                                    </c:if>

                                    <div class="review_write">
                                        <div class="tit">댓글 작성하기</div>
                                        <div class="write_input">
                                            <input type="text" id="cmtContent" placeholder="댓글을 입력하세요. (30자 내 이내)" maxlength="30" onkeyup="checkCmtInput()">
                                            <button class="send wpx-80" id="btnCmtSend" disabled onclick="submitComment()">
                                                작성
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="viewers">
                        <fmt:formatNumber value="${diary.viewCount}" pattern="#,###"/> view
                    </div>

                    <c:if test="${!isScoreEditable}">
                        <div class="horizon-mes">
                            <img src="/img/ico_not_mark_red.svg" alt="수정 불가">
                            <c:choose>
                                <c:when test="${lockReason eq 'FINISHED'}">종료/취소된 경기의 예측 스코어는 수정 불가합니다.</c:when>
                                <c:otherwise>경기가 임박해 기록이 잠겼어요. (수정 불가)</c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </div>

            </div>
        </div>

        <div class="bottom-action bottom-main">
            <button type="button" class="btn btn-primary" onclick="shareDiary()">공유하기</button>
        </div>
    </div>

    <div id="captureLoading" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.6); z-index: 9999; justify-content: center; align-items: center; flex-direction: column; color: white;">
        <div class="capture-spinner"></div>
        <p style="margin-top: 15px; font-size: 16px; font-weight: bold; letter-spacing: -0.5px;">이미지를 생성 중입니다...</p>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/html-to-image/1.11.11/html-to-image.min.js"></script>

    <script>
        // [댓글 제어]
        function checkCmtInput() {
            const val = $('#cmtContent').val().trim();
            $('#btnCmtSend').prop('disabled', val.length === 0);
        }

        // [댓글 등록]
        function submitComment() {
            const content = $('#cmtContent').val().trim();
            const diaryId = '${diary.diaryId}';

            if (!content) return;

            $('#btnCmtSend').prop('disabled', true).text('등록중..');

            $.post('/diary/comment/write', { diaryId: diaryId, content: content }, function (res) {
                if (res === 'ok') {
                    location.reload(); // 등록 후 새로고침 (간편 구현)
                } else if (res.startsWith('fail:login')) {
                    alert('로그인이 필요합니다.');
                    location.href = '/member/login';
                } else {
                    // 3. 금칙어 알럿 발생 시 (그 외의 문자열)
                    alert(res);

                    // 그리고 버튼을 다시 활성화
                    $('#btnCmtSend').prop('disabled', false).text('작성');
                }
            }).fail(function() {
                alert('서버 오류');
                $('#btnCmtSend').prop('disabled', false).text('작성');
            });
        }

        // [댓글 삭제]
        function deleteComment(commentId, btn) {
            if (!confirm('댓글을 삭제하시겠습니까?')) return;

            $.post('/diary/comment/delete', { commentId: commentId }, function (res) {
                if (res === 'ok') {
                    $(btn).closest('li').fadeOut(300, function() { $(this).remove(); });
                } else {
                    alert('삭제 권한이 없거나 실패했습니다.');
                }
            });
        }

        function showAllComments(element) {
            $('.hidden-cmt').slideDown();
            $(element).hide();
        }

        // --- 기능 로직 유지 ---
        function viewImage(src) {
            // 앱 환경 또는 브라우저 새창 열기
            if (typeof appify !== 'undefined' && appify.isWebview) {
                 // 앱 내 이미지 뷰어 호출 로직이 있다면 사용
            } else {
                window.open(src, '_blank');
            }
        }

        async function downloadImage(imgUrl) {
            if (!imgUrl) return;
            if (typeof appify !== 'undefined' && appify.isWebview) {
                try {
                    const result = await appify.download.image(imgUrl);
                    if (result) alert("갤러리에 저장되었습니다. 📸");
                    else alert("저장에 실패했습니다.");
                } catch (e) {
                    alert("오류: " + e.message);
                }
            } else {
                if (confirm("이미지를 다운로드(새 창) 하시겠습니까?")) {
                    window.open(imgUrl, '_blank');
                }
            }
        }

        function shareDiary() {
            // 공유 기능 구현
            $.post('/diary/share/create', { diaryId: '${diary.diaryId}' }, async function(uuid) {

                // 1. 서버에서 공유를 거절한 경우 (원인을 정확히 파악하여 알림)
                if (uuid && uuid.startsWith('fail')) {
                    if (uuid === 'fail:login') alert('로그인이 필요합니다. (다시 로그인해 주세요)');
                    else if (uuid === 'fail:permission') alert('작성자 본인만 공유할 수 있습니다.');
                    else if (uuid === 'fail:private') alert('비공개 일기는 공유할 수 없습니다.');
                    else if (uuid === 'fail:not_found') alert('해당 일기를 찾을 수 없습니다.');
                    else alert('공유 링크 생성 중 오류가 발생했습니다.');
                    return;
                }

                const shareUrl = window.location.origin + '/share/diary/' + uuid;
                const shareTitle = '${diary.nickname}님의 승요일기';
                const shareText = '오늘의 직관 기록을 확인해보세요!';

                try {
                    // 2. 앱(Appify Webview) 환경인 경우
                    if (typeof appify !== 'undefined' && appify.isWebview) {
                        await appify.share.systemShare({
                            title: shareTitle, message: shareText, url: shareUrl
                        });
                    }
                    // 3. 일반 모바일 브라우저 환경 (Share API)
                    else if (navigator.share && /Mobi|Android/i.test(navigator.userAgent)) {
                        try {
                            await navigator.share({
                                title: shareTitle, text: shareText, url: shareUrl
                            });
                        } catch (err) {
                            // 사용자가 취소한 것이 아니라, 비동기 통신(Ajax) 지연으로 인해
                            // 브라우저가 공유 창 호출을 보안상 강제 차단했다면 클립보드 복사로 자동 전환
                            if (err.name !== 'AbortError') {
                                copyToClipboard(shareUrl);
                            }
                        }
                    }
                    // 4. PC 브라우저 등 API 미지원 환경
                    else {
                        copyToClipboard(shareUrl);
                    }
                } catch (e) {
                    console.error("공유 실행 중 예외 발생:", e);
                    copyToClipboard(shareUrl);
                }
            }).fail(function() {
                alert("서버와 통신 중 오류가 발생했습니다.");
            });
        }

        // ==========================================
        // 클립보드 복사 로직 (execCommand 제거, 최신 API 적용)
        // ==========================================
        async function copyToClipboard(text) {
            // 1. 앱(Webview) 클립보드 브릿지
            if (typeof appify !== 'undefined' && appify.isWebview) {
                const success = await appify.clipboard.setText(text);
                if(success) alert('공유 링크가 복사되었습니다!');
            }
            // 2. 최신 웹 표준 Clipboard API (HTTPS 환경 필수)
            else if (navigator.clipboard && window.isSecureContext) {
                try {
                    await navigator.clipboard.writeText(text);
                    alert('공유 링크가 복사되었습니다!');
                } catch (err) {
                    // 브라우저 설정으로 클립보드 접근이 막힌 경우 가장 안전한 Prompt 창 제공
                    prompt("아래 링크를 복사하여 공유해주세요.", text);
                }
            }
            // 3. HTTP 로컬 환경 등 최신 API가 동작하지 않는 경우 (execCommand 대체안)
            else {
                prompt("아래 링크를 복사하여 공유해주세요.", text);
            }
        }

        // [가운데 정렬 완벽 보존 + 꿀렁임 원천 차단(복제 기법)] + [로딩 인디케이터 적용]
        async function captureCard() {
            const originalTarget = document.querySelector('.inquiry_item');
            if(!originalTarget) return;

            // 1. 캡쳐 시작 전 로딩 화면 즉시 노출
            const loadingOverlay = document.getElementById("captureLoading");
            if (loadingOverlay) loadingOverlay.style.display = "flex";

            // 2. 브라우저가 화면에 로딩 UI를 그릴 시간을 벌어줍니다. (메인 스레드 블로킹 방지)
            await new Promise(resolve => setTimeout(resolve, 100));

            try {
                // [기존 코드 동일] 화면을 똑같이 복제하여 안 보이는 곳에 숨김
                const captureWrapper = document.createElement('div');
                captureWrapper.style.cssText = 'position: fixed; top: -9999px; left: -9999px; z-index: -9999;';

                const clone = originalTarget.cloneNode(true);
                clone.style.width = originalTarget.offsetWidth + 'px';
                clone.style.backgroundColor = '#ffffff';

                captureWrapper.appendChild(clone);
                document.body.appendChild(captureWrapper);

                // [기존 코드 동일] 복제본 내부 방해 요소 제거
                clone.querySelectorAll('.page-down, .capture-hide-btn, .more-btn, .swiper_btn, .more_box, a[onclick*="captureCard"]').forEach(el => {
                    el.style.setProperty('display', 'none', 'important');
                });

                // [기존 코드 동일] 숨겨진 일기 펼치기 및 말줄임표 해제
                const diaryDesc = clone.querySelector('.diary_desc');
                if (diaryDesc) {
                    diaryDesc.style.cssText += 'padding: 16px !important; margin-top: 16px !important; border-top: 1px solid #e1e1e1 !important; transition: none !important; max-height: none !important; height: auto !important; overflow: visible !important; display: block !important;';
                }
                const txtGameList = clone.querySelector('.txt_game_list');
                if (txtGameList) {
                    txtGameList.style.cssText += 'max-height: none !important; height: auto !important;';
                }
                clone.querySelectorAll('.txt_game > div:not(.inquiry_badge), .diary_desc > div:not(.inquiry_badge), .player').forEach(el => {
                    el.style.cssText += '-webkit-line-clamp: unset !important; -webkit-box-orient: unset !important; max-height: none !important;';
                });

                // [기존 코드 동일] 팀 로고 정렬 보정
                clone.querySelectorAll('.team, .game-info-wrap').forEach(wrap => {
                    wrap.style.cssText += 'display: grid !important; justify-items: center !important; align-items: center !important; text-align: center !important;';
                });
                clone.querySelectorAll('.team img').forEach(img => {
                    img.setAttribute('width', '48');
                    img.setAttribute('height', '48');
                    img.style.cssText += 'width: 48px !important; height: 48px !important; display: block !important; margin: 0 auto !important;';
                });

                // [기존 코드 동일] Swiper를 순정 액자로 교체
                const swiperBox = clone.querySelector('.swiper_box');
                const inquiryImg = clone.querySelector('.inquiry_img');

                if (swiperBox && inquiryImg) {
                    const activeImg = swiperBox.querySelector('.swiper-slide-active img') || swiperBox.querySelector('.swiper-slide img');
                    if (activeImg) {
                        swiperBox.remove();
                        const perfectWrapper = document.createElement('div');
                        perfectWrapper.style.cssText = `
                            width: 100% !important;
                            height: 200px !important;
                            border: 1px solid #E0E3E8 !important;
                            border-radius: 8px !important;
                            overflow: hidden !important;
                            display: block !important;
                            margin: 0 auto !important;
                            background-color: #25282F !important;
                            box-sizing: border-box !important;
                        `;
                        const perfectImg = document.createElement('img');
                        perfectImg.src = activeImg.src;
                        perfectImg.style.cssText = `
                            width: 100% !important;
                            height: 100% !important;
                            object-fit: cover !important;
                            display: block !important;
                            margin: 0 !important;
                            padding: 0 !important;
                            border: none !important;
                            transform: none !important;
                        `;
                        perfectWrapper.appendChild(perfectImg);
                        inquiryImg.appendChild(perfectWrapper);
                    }
                }

                // 캡쳐 실행 전 레이아웃 안정화
                await new Promise(resolve => setTimeout(resolve, 300));

                // [기존 코드 동일] 캡쳐 실행 (오류가 수정된 복제본을 캡쳐)
                const imgData = await htmlToImage.toPng(clone, {
                    pixelRatio: 2,
                    backgroundColor: '#ffffff',
                    useCORS: true,
                    style: { transform: 'none' }
                });

                // 메모리에서 복제본 삭제
                captureWrapper.remove();

                // 파일 다운로드 로직
                const gameDate = '${diary.gameDate}'.replace(/-/g, '');
                const awayTeam = '${diary.awayTeamName}';
                const homeTeam = '${diary.homeTeamName}';
                const fileName = '승요일기_' + gameDate + '_' + awayTeam + 'vs' + homeTeam + '.png';

                if (typeof appify !== 'undefined' && appify.isWebview) {
                    try {
                        if (appify.download && appify.download.base64Image) {
                            const result = await appify.download.base64Image(imgData, fileName);
                            if (result) alert("갤러리에 저장되었습니다. 📸");
                        } else downloadURI(imgData, fileName);
                    } catch (e) { downloadURI(imgData, fileName); }
                } else {
                    downloadURI(imgData, fileName);
                }

            } catch (err) {
                console.error("Capture Error:", err);
                alert("이미지 생성 중 오류가 발생했습니다.");
            } finally {
                // 3. 성공하든 에러가 나든 작업이 끝나면 무조건 로딩 화면 숨김
                if (loadingOverlay) loadingOverlay.style.display = "none";
            }
        }

        // 다운로드 헬퍼 함수 (모바일 호환성 개선)
        function downloadURI(uri, name) {
            // 1. 긴 Base64(URI)를 안전한 Blob(파일) 객체로 변환
            fetch(uri)
                .then(res => res.blob())
                .then(blob => {
                    const file = new File([blob], name, { type: 'image/png' });

                    // 2. 모바일 기기인 경우 (iOS, Android) - 네이티브 공유/저장 팝업 띄우기
                    if (navigator.canShare && navigator.canShare({ files: [file] }) && /Mobi|Android/i.test(navigator.userAgent)) {
                        navigator.share({
                            files: [file],
                            title: '승요일기 직관기록'
                        }).catch(err => {
                            // 사용자가 공유 창을 닫았을 때 발생하는 에러 무시
                            console.log("공유 취소됨:", err);
                        });
                    }
                    // 3. PC 브라우저이거나 Share API를 지원하지 않는 경우 - 안전한 강제 다운로드
                    else {
                        forceDownload(blob, name);
                    }
                });
        }

        // 안전한 파일 다운로드를 실행하는 함수 (Blob URL 사용)
        function forceDownload(blob, name) {
            const url = window.URL.createObjectURL(blob);
            const link = document.createElement("a");
            link.style.display = "none";
            link.href = url;
            link.download = name;

            document.body.appendChild(link);
            link.click();

            // 사용한 객체 URL 메모리 정리
            setTimeout(() => {
                document.body.removeChild(link);
                window.URL.revokeObjectURL(url);
            }, 100);
        }

        /*function deleteDiary(diaryId) {
            if (!confirm('정말로 이 일기를 삭제하시겠습니까?')) return;

            $.post('/diary/delete', { diaryId: diaryId }, function(res) {
                if (res === 'ok') {
                    alert('삭제되었습니다.');
                    location.href = '/diary/list';
                } else if (res.startsWith('fail:')) {
                    alert(res.substring(5)); // 서버에서 보낸 거절 사유 노출
                } else {
                    alert('삭제에 실패했습니다.');
                }
            }).fail(function() {
                alert('서버 통신 중 오류가 발생했습니다.');
            });
        }

        function editDiary() {
            location.href = '/diary/update?diaryId=${diary.diaryId}';
        }*/
    </script>
</body>
</html>