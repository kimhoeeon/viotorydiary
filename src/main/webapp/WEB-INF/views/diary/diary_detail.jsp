<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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

    <title>상세보기 | 승요일기</title>

    <style>
        .result-badge-wrap {
            background-color: #f8f9fa; border-radius: 12px; padding: 16px; margin-bottom: 16px; display: flex; align-items: center; justify-content: space-between; border: 1px solid #eee;
        }
        .result-badge-wrap .tit { font-size: 14px; font-weight: 700; color: #555; margin-bottom:0; }
        .result-badge { font-size: 14px; font-weight: 700; padding: 6px 12px; border-radius: 6px; display: inline-flex; align-items: center; gap: 4px; }
        .result-badge.win { background-color: #E8F3FF; color: #1A7CFF; }
        .result-badge.lose { background-color: #FEE8E8; color: #FF4D4D; }
        .result-badge.draw { background-color: #F1F1F1; color: #666; }
        .result-badge.none { background-color: #f5f5f5; color: #999; }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">

        <header class="app-header">
            <button class="app-header_btn app-header_back" type="button" onclick="location.href='/diary/winyo'">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main">
            <div class="app-tit">
                <div class="page-tit">나의 직관일기</div>
                <c:if test="${diary.verified}">
                    <div class="location-certify">
                        <button class="btn btn-certify-comp w-auto" type="button" id="verifyComplete">
                            직관 인증완료!
                        </button>
                    </div>
                </c:if>
            </div>

            <c:if test="${isOwner}">
                <div class="mt-16 flex-end">
                    <%-- 삭제 불가 요청으로 임시 주석 처리 --%>
                    <%--<button type="button" class="btn sub-btn w-auto small" onclick="deleteDiary(${diary.diaryId})">삭제</button>--%>
                    <a href="/diary/update?diaryId=${diary.diaryId}" class="btn btn-primary w-auto small">수정</a>
                </div>
            </c:if>

            <div class="page-main_wrap">
                <div class="history">
                    <div class="history-list mt-24">

                        <div class="diary_write_form">

                            <div class="diary_write_list req diary_character">
                                <div class="tit">직관한 경기</div>
                                <button type="button" class="select-field" style="opacity: 1; cursor: default;">
                                    <span class="select-field_value" style="color: #000; font-weight: bold;">
                                        <%--<c:choose>
                                            <c:when test="${diary.gameType eq 'EXHIBITION'}">
                                                <span class="badge-game-type badge-exhibition">시범</span>
                                            </c:when>
                                            <c:when test="${diary.gameType eq 'REGULAR'}">
                                                <span class="badge-game-type badge-regular">정규</span>
                                            </c:when>
                                            <c:when test="${diary.gameType eq 'POST'}">
                                                <span class="badge-game-type badge-post">포스트</span>
                                            </c:when>
                                            <c:when test="${diary.gameType eq 'ALLSTAR'}">
                                                <span class="badge-game-type badge-allstar">올스타</span>
                                            </c:when>
                                        </c:choose>--%>

                                        [${diary.stadiumName}] ${diary.awayTeamName} vs ${diary.homeTeamName}
                                        <span style="font-weight:400; font-size:13px; margin-left:4px;">
                                            (${fn:substring(diary.gameDate, 5, 7)}.${fn:substring(diary.gameDate, 8, 10)})
                                        </span>
                                    </span>
                                </button>
                            </div>

                            <%-- 내 직관 승패 결과 뱃지 노출 --%>
                            <div class="result-badge-wrap">
                                <div class="tit">직관 승패 결과</div>
                                <div>
                                    <c:choose>
                                        <c:when test="${diary.gameStatus eq 'FINISHED'}">
                                            <c:choose>
                                                <c:when test="${diary.gameResult eq 'WIN'}">
                                                    <span class="result-badge win"><img src="/img/ico_crown.svg" style="width:16px;"> 승리 요정 달성!</span>
                                                </c:when>
                                                <c:when test="${diary.gameResult eq 'LOSE'}">
                                                    <span class="result-badge lose">패배 요정 (응원팀 패배)</span>
                                                </c:when>
                                                <c:when test="${diary.gameResult eq 'DRAW'}">
                                                    <span class="result-badge draw">무승부</span>
                                                </c:when>
                                                <c:when test="${diary.gameResult eq 'NONE'}">
                                                    <span class="result-badge none">승패 무관 (타팀 관전)</span>
                                                </c:when>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="result-badge none" style="background:transparent; border:1px solid #ddd;">경기 진행 전/중</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="diary_write_list req diary_character yellow">
                                <div class="tit">내가 예상한 스코어</div>
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
                                                    <input type="text" value="${diary.predScoreAway}" readonly style="background:transparent; border:none; text-align:center; font-size:24px; font-weight:bold; color:#000;">
                                                </div>
                                                <div class="game-info-wrap">VS</div>
                                                <div class="right-team-score">
                                                    <input type="text" value="${diary.predScoreHome}" readonly style="background:transparent; border:none; text-align:center; font-size:24px; font-weight:bold; color:#000;">
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
                            </div>

                            <div class="diary_write_list">
                                <div class="tit">오늘의 히어로는 누구일까?</div>
                                <input type="text" value="${diary.heroName}" placeholder="최대 100자까지 입력하실 수 있습니다." readonly>
                            </div>

                            <div class="diary_write_list">
                                <div class="tit">오늘의 경기를 한 마디로 평가한다면?!</div>
                                <input type="text" value="${diary.oneLineComment}" placeholder="최대 100자까지 입력하실 수 있습니다." readonly>
                            </div>

                            <div class="diary_write_list">
                                <div class="tit">오늘의 경기를 기록해 보세요</div>
                                <textarea placeholder="최대 1,000자까지 입력하실 수 있습니다." readonly style="height: auto; min-height: 120px; background-color: #f9f9f9;">${diary.content}</textarea>
                            </div>

                            <c:if test="${not empty diary.imageUrl}">
                                <div class="diary_write_list">
                                    <div class="tit">오늘 경기 사진</div>
                                    <div class="upload" style="display:flex; flex-direction:column; gap:16px; width:100%;">
                                        <c:set var="imgArr" value="${fn:split(diary.imageUrl, ',')}" />
                                        <c:forEach var="imgSrc" items="${imgArr}">
                                            <c:if test="${not empty imgSrc}">
                                                <div>
                                                    <img src="${imgSrc}" alt="직관 사진" onclick="viewImage(this.src)"
                                                         style="width:100%; border-radius:12px; display:block; object-fit:cover;">

                                                    <c:if test="${isOwner}">
                                                        <button type="button" onclick="downloadImage('${imgSrc}')"
                                                                style="margin-top:8px; padding:8px 12px; border-radius:8px; background:#fff; border:1px solid #ddd; font-size:13px; display:inline-flex; align-items:center; gap:6px; color:#555;">
                                                            <span>📥 사진 저장하기</span>
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>

                            <div class="diary_write_list">
                                <div class="tit">공개 여부</div>
                                <c:choose>
                                    <c:when test="${diary.isPublic eq 'PUBLIC'}">
                                        <input type="text" value="전체 공개" readonly>
                                    </c:when>
                                    <c:when test="${diary.isPublic eq 'FRIENDS'}">
                                        <input type="text" value="맞팔 공개" readonly>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="text" value="비공개" readonly>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                        </div>

                        <div class="card_wrap play_wrap gap-16">
                            <div class="card_item pt-24 pb-24">
                                <div class="review_wrap">
                                    <ul class="review_list" id="reviewList">
                                        <c:forEach var="cmt" items="${comments}" varStatus="status">
                                            <li class="${status.index >= 5 ? 'hidden-cmt' : ''}">
                                                <div class="name" style="display: flex; align-items: center; gap: 8px;">
                                                    <c:choose>
                                                        <c:when test="${not empty cmt.profileImage}">
                                                            <img src="${cmt.profileImage}" alt="프로필" style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover; border: 1px solid #eee;">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="/img/ico_user.svg" alt="기본 프로필" style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover; background: #f5f5f5; padding: 2px;">
                                                        </c:otherwise>
                                                    </c:choose>
                                                    ${cmt.nickname}
                                                </div>
                                                <div class="nae">${cmt.content}</div>

                                                <%-- 댓글 작성자 본인이거나, 일기 원글 작성자(isOwner)인 경우에만 삭제 버튼 노출 --%>
                                                <c:if test="${cmt.memberId eq sessionScope.loginMember.memberId or isOwner}">
                                                    <button class="del-btn" style="float:right;" onclick="deleteComment(${cmt.commentId}, this)">
                                                        <img src="/img/ico_del.svg" alt="삭제" style="width:16px; opacity:0.5;">
                                                    </button>
                                                </c:if>
                                            </li>
                                        </c:forEach>

                                        <c:if test="${empty comments}">
                                            <li style="text-align:center; padding:20px; color:#999; border:none;">
                                                아직 작성된 댓글이 없습니다.
                                            </li>
                                        </c:if>
                                    </ul>

                                    <c:if test="${fn:length(comments) > 5}">
                                        <div class="more-btn" id="moreBtn" onclick="showAllComments()">
                                            <div class="btn">더 보기</div>
                                        </div>
                                    </c:if>

                                    <div class="review_write">
                                        <div class="tit">댓글 작성하기</div>
                                        <div class="write_input">
                                            <input type="text" id="cmtContent" placeholder="댓글을 입력하세요. (30자 이내)" maxlength="30" onkeyup="checkCmtInput()">
                                            <button class="send wpx-80" id="btnCmtSend" disabled onclick="submitComment()">
                                                작성
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="viewers" style="margin-top:16px;">
                            <fmt:formatNumber value="${diary.viewCount}" pattern="#,###"/> view
                        </div>

                        <c:if test="${!isScoreEditable}">
                            <div class="horizon-mes" style="margin-top:16px;">
                                <img src="/img/ico_not_mark_red.svg" alt="수정 불가">
                                <c:choose>
                                    <c:when test="${lockReason eq 'FINISHED'}">
                                        종료되거나 취소된 경기의 승부 예측(스코어)은 수정할 수 없어요.<br>(후기 및 사진은 수정 가능)
                                    </c:when>
                                    <c:when test="${lockReason eq 'IMMINENT'}">
                                        경기가 임박해 승부 예측(스코어)이 잠겼어요.<br>(후기 및 사진은 수정 가능)
                                    </c:when>
                                    <c:otherwise>
                                        승부 예측(스코어)은 현재 수정이 불가능합니다.
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>

                    </div>
                </div>
            </div>
        </div>

        <c:if test="${isOwner}">
            <div class="bottom-action">
                <%-- 삭제 불가 요청으로 임시 주석 처리 --%>
                <%--<button type="button" class="btn border" onclick="deleteDiary()">
                    삭제
                </button>--%>

                <c:choose>
                    <c:when test="${isEditable}">
                        <button type="button" class="btn btn-primary" onclick="editDiary()">
                            수정
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn btn-primary" disabled>
                            수정
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <%--<c:if test="${!isOwner}">--%>
            <div class="bottom-action bottom-main">
                <button type="button" class="btn btn-primary" onclick="shareDiary()">공유하기</button>
            </div>
        <%--</c:if>--%>

    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>

    <script>
        // [댓글 입력 감지]
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
                    alert('댓글 등록에 실패했습니다.');
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

        // --- 기능 로직 유지 ---
        function viewImage(src) {
            // 앱 환경 또는 브라우저 새창 열기
            if (typeof appify !== 'undefined' && appify.isWebview) {
                 // 앱 내 이미지 뷰어 호출 로직이 있다면 사용
            } else {
                window.open(src, '_blank');
            }
        }

        function deleteDiary(diaryId) {
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
        }

        function shareDiary() {
            // 공유 기능 구현
            $.post('/diary/share/create', { diaryId: '${diary.diaryId}' }, async function(uuid) {
                if(uuid && uuid.startsWith('fail')) {
                    alert('오류가 발생했습니다.'); return;
                }
                const shareUrl = window.location.origin + '/share/diary/' + uuid;
                const shareTitle = '${diary.nickname}님의 승요일기';
                const shareText = '오늘의 직관 기록을 확인해보세요!';

                try {
                    if (typeof appify !== 'undefined' && appify.isWebview) {
                        await appify.share.systemShare({
                            title: shareTitle, message: shareText, url: shareUrl
                        });
                    } else if (navigator.share) {
                        await navigator.share({
                            title: shareTitle, text: shareText, url: shareUrl
                        });
                    } else {
                        copyToClipboard(shareUrl);
                    }
                } catch (e) {
                    console.error(e);
                }
            });
        }

        async function copyToClipboard(text) {
             if (typeof appify !== 'undefined' && appify.isWebview) {
                const success = await appify.clipboard.setText(text);
                if(success) alert('공유 링크가 복사되었습니다!');
            } else {
                navigator.clipboard.writeText(text).then(() => {
                    alert('공유 링크가 복사되었습니다!');
                });
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
    </script>
</body>
</html>