<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
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
                <div class="page-tit">나의 직관일기</div>
                <c:if test="${diary.verified}">
                    <div class="location-certify">
                        <div class="certify_mes">
                            <img src="/img/ico_certify-comp_p.svg" alt="인증완료">직관 인증완료!
                        </div>
                    </div>
                </c:if>
            </div>

            <div class="page-main_wrap">
                <div class="history">
                    <div class="history-list mt-24">

                        <div class="diary_write_form">

                            <div class="diary_write_list req diary_character">
                                <div class="tit">직관한 경기</div>
                                <button type="button" class="select-field" style="opacity: 1; cursor: default;">
                                    <span class="select-field_value" style="color: #000; font-weight: bold;">
                                        <c:choose>
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
                                        </c:choose>

                                        [${diary.stadiumName}] ${diary.homeTeamName} vs ${diary.awayTeamName}
                                        <span style="font-weight:400; font-size:13px; margin-left:4px;">
                                            (${fn:substring(diary.gameDate, 5, 7)}.${fn:substring(diary.gameDate, 8, 10)})
                                        </span>
                                    </span>
                                </button>
                            </div>

                            <div class="diary_write_list req diary_character yellow">
                                <div class="tit">내가 예상한 스코어</div>
                                <div class="card_item">
                                    <div class="game-board">
                                        <div class="row row-center gap-24">
                                            <div class="team">
                                                <div class="team-name">${diary.homeTeamName}</div>
                                            </div>

                                            <div class="game-score schedule">
                                                <div class="left-team-score">
                                                    <input type="text" value="${diary.scoreHome}" readonly
                                                           style="background:transparent; border:none; text-align:center; font-size:24px; font-weight:bold; color:#000;">
                                                </div>
                                                <div class="game-info-wrap">VS</div>
                                                <div class="right-team-score">
                                                    <input type="text" value="${diary.scoreAway}" readonly
                                                           style="background:transparent; border:none; text-align:center; font-size:24px; font-weight:bold; color:#000;">
                                                </div>
                                            </div>

                                            <div class="team">
                                                <div class="team-name">${diary.awayTeamName}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="diary_write_list">
                                <div class="tit">오늘의 히어로는 누구일까?</div>
                                <input type="text" value="${diary.heroName}" readonly>
                            </div>

                            <div class="diary_write_list">
                                <div class="tit">오늘의 경기를 한 마디로 평가한다면?!</div>
                                <input type="text" value="${diary.oneLineComment}" readonly>
                            </div>

                            <div class="diary_write_list">
                                <div class="tit">오늘의 경기를 기록해 보세요</div>
                                <textarea readonly style="height: auto; min-height: 120px; background-color: #f9f9f9;">${diary.content}</textarea>
                            </div>

                            <c:if test="${not empty diary.imageUrl}">
                                <div class="diary_write_list">
                                    <div class="tit">오늘 경기 사진</div>
                                    <div class="upload" style="display:block; width:100%; height:auto;">
                                        <img src="${diary.imageUrl}" alt="직관 사진" onclick="viewImage(this.src)"
                                             style="width:100%; border-radius:12px; display:block;">

                                        <button type="button" onclick="downloadImage('${diary.imageUrl}')"
                                                style="margin-top:8px; padding:8px 12px; border-radius:8px; background:#fff; border:1px solid #ddd; font-size:13px; display:inline-flex; align-items:center; gap:6px; color:#555;">
                                            <span>📥 사진 저장하기</span>
                                        </button>
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

                        <div class="card_wrap play_wrap gap-16" style="margin-top: 24px;">
                            <div class="card_item">
                                <div class="review_wrap">
                                    <div class="tit">댓글 <span>(0)</span></div>

                                    <div class="review_list">
                                        <div class="nodata" style="padding: 20px 0; text-align: center; color: #999; font-size: 13px;">
                                            아직 작성된 댓글이 없어요.
                                        </div>
                                    </div>

                                    <div class="review_write">
                                        <div class="tit">댓글 작성하기</div>
                                        <div class="write_input">
                                            <input type="text" placeholder="댓글을 입력하세요. (30자 내 이내)">
                                            <button class="send wpx-80" disabled>
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

                        <c:if test="${!isEditable}">
                            <div class="horizon-mes" style="margin-top:16px;">
                                <img src="/img/ico_not_mark_red.svg" alt="수정 불가"> 경기가 임박해 기록이 잠겼어요. (수정 불가)
                            </div>
                        </c:if>

                    </div>
                </div>
            </div>
        </div>

        <c:if test="${isOwner}">
            <div class="bottom-action">
                <button type="button" class="btn border" onclick="deleteDiary()">
                    삭제
                </button>

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

        <c:if test="${!isOwner}">
            <div class="bottom-action bottom-main">
                <button type="button" class="btn btn-primary" onclick="shareDiary()">공유하기</button>
            </div>
        </c:if>

    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>

    <script>
        // --- 기능 로직 유지 ---

        function viewImage(src) {
            // 앱 환경 또는 브라우저 새창 열기
            if (typeof appify !== 'undefined' && appify.isWebview) {
                 // 앱 내 이미지 뷰어 호출 로직이 있다면 사용
            } else {
                window.open(src, '_blank');
            }
        }

        function deleteDiary() {
            if(!confirm('정말 삭제하시겠습니까? 삭제 후 복구할 수 없습니다.')) return;

            $.post('/diary/delete', { diaryId: '${diary.diaryId}' }, function(res) {
                if (res === 'ok') {
                    alert('삭제되었습니다.', function() {
                        location.href = '/diary/list';
                    });
                } else if (res === 'fail:login') {
                    alert('로그인이 필요합니다.', function() {
                        location.href = '/member/login';
                    });
                } else {
                    alert('일기 삭제에 실패했습니다.');
                }
            }).fail(function() {
                alert('서버 통신 오류가 발생했습니다.');
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