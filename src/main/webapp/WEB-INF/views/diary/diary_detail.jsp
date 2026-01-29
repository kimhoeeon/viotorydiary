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

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>상세보기 | 승요일기</title>

    <style>
        /* 더보기 기능용: 5번째 이후 댓글 숨김 */
        .review_list li:nth-child(n+6) { display: none; }

        /* 상세 페이지 전용 스타일 */
        .diary-header-info {
            border-bottom: 1px solid #f0f0f0;
            padding-bottom: 20px;
            margin-bottom: 20px;
        }
        .one-line-box .label { font-size: 13px; color: #999; margin-bottom: 6px; display: block; }
        .one-line-box .text { font-size: 18px; font-weight: 700; color: #111; line-height: 1.4; }

        .hero-box { margin-top: 12px; display: flex; align-items: center; gap: 8px; }
        .hero-badge {
            background: #e8f3ff; color: #2c7fff;
            font-size: 12px; font-weight: 700;
            padding: 4px 8px; border-radius: 6px;
        }
        .hero-name { font-size: 16px; font-weight: 600; color: #333; }

        .cancel-badge {
            background-color: #ffebeb; color: #ff4d4f;
            font-size: 12px; padding: 2px 6px; border-radius: 4px;
            margin-left: 6px; font-weight: 500;
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
            <div class="page-tit">직관일기</div>

            <c:if test="${isOwner}">
                <div class="app-header_action">
                    <c:if test="${isEditable}">
                        <button type="button" class="btn-text" onclick="editDiary()">수정</button>
                    </c:if>

                    <button type="button" class="btn-text warning" onclick="deleteDiary()">삭제</button>
                </div>
            </c:if>
        </header>

        <div class="app-main">
            <div class="page-main_wrap">
                <div class="card_wrap gap-16">

                    <div class="card_item game-item">
                        <div class="game-board">
                            <div class="row row-center gap-24">
                                <div class="team ${diary.status == 'FINISHED' && diary.scoreHome > diary.scoreAway ? 'win' : ''}">
                                    <div class="team-name mb-4">${diary.homeTeamName}</div>
                                    <img src="/img/logo/logo_${fn:toLowerCase(diary.homeTeamCode)}.svg" alt="${diary.homeTeamName}">
                                </div>

                                <div class="game-score ${diary.status == 'FINISHED' ? 'end' : (diary.status == 'LIVE' ? 'during' : 'cancel')}">
                                    <div class="left-team-score ${diary.scoreHome > diary.scoreAway ? 'high' : ''}">
                                        ${diary.status == 'SCHEDULED' ? '-' : diary.scoreHome}
                                    </div>
                                    <div class="game-info-wrap">
                                        <c:choose>
                                            <c:when test="${diary.status == 'FINISHED'}">
                                                <div class="badge">종료</div>
                                            </c:when>
                                            <c:when test="${diary.status == 'LIVE'}">
                                                <div class="badge">경기중</div>
                                            </c:when>
                                            <c:when test="${diary.status == 'CANCELLED'}">
                                                <div class="badge cancel">취소</div>
                                                <c:if test="${not empty diary.cancelReason}">
                                                    <span class="cancel-badge">${diary.cancelReason}</span>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="badge schedule">예정</div>
                                            </c:otherwise>
                                        </c:choose>

                                        <div class="game-info">
                                            <div class="day">${fn:substring(diary.gameDate, 5, 7)}.${fn:substring(diary.gameDate, 8, 10)} ${fn:substring(diary.gameTime, 0, 5)}</div>
                                            <div class="place">${diary.stadiumName}</div>
                                        </div>
                                    </div>
                                    <div class="right-team-score ${diary.scoreAway > diary.scoreHome ? 'high' : ''}">
                                        ${diary.status == 'SCHEDULED' ? '-' : diary.scoreAway}
                                    </div>
                                </div>

                                <div class="team ${diary.status == 'FINISHED' && diary.scoreAway > diary.scoreHome ? 'win' : ''}">
                                    <div class="team-name mb-4">${diary.awayTeamName}</div>
                                    <img src="/img/logo/logo_${fn:toLowerCase(diary.awayTeamCode)}.svg" alt="${diary.awayTeamName}">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card_item">
                        <div class="diary-header-info">
                            <div class="one-line-box">
                                <span class="label">한줄평</span>
                                <div class="text">"${diary.oneLineComment}"</div>
                            </div>

                            <c:if test="${not empty diary.heroName}">
                                <div class="hero-box">
                                    <span class="hero-badge">🏆 My Hero</span>
                                    <span class="hero-name">${diary.heroName}</span>
                                </div>
                            </c:if>
                        </div>

                        <c:if test="${not empty diary.imageUrl}">
                            <div class="diary-img" style="margin-bottom:16px; position: relative;">
                                <img src="${diary.imageUrl}" alt="직관 사진" onclick="viewImage(this.src)"
                                     style="width:100%; border-radius:12px; border: 1px solid #eee;">

                                <button type="button" onclick="downloadImage('${diary.imageUrl}')"
                                        style="position: absolute; bottom: 10px; right: 10px;
                                               background: rgba(0,0,0,0.6); color: #fff;
                                               border: none; border-radius: 20px;
                                               padding: 6px 12px; font-size: 12px; font-weight: bold;
                                               display: flex; align-items: center; gap: 4px; cursor: pointer;">
                                    <span>📥 저장</span>
                                </button>
                            </div>
                        </c:if>

                        <div class="diary-txt" style="white-space:pre-line; line-height:1.6; color:#333; font-size: 15px;">${diary.content}</div>
                    </div>

                </div>
            </div>
        </div>

        <div class="bottom-action bottom-main">
            <button type="button" class="btn btn-primary" onclick="shareDiary()">공유하기</button>
        </div>

        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        // 이미지 크게 보기 (간단 구현)
        function viewImage(src) {
            // 필요 시 라이트박스 플러그인 연동
            window.open(src, '_blank');
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
                    alert('일기 삭제에 실패했습니다. (권한이 없거나 이미 삭제됨)');
                }
            }).fail(function() {
                alert('서버 통신 오류가 발생했습니다.');
            });
        }

        function editDiary() {
            // 수정 페이지 이동
            location.href = '/diary/update?diaryId=${diary.diaryId}';
        }

        // 공유하기 기능
        function shareDiary() {
            $.post('/diary/share/create', { diaryId: '${diary.diaryId}' }, async function(uuid) {
                if(uuid.startsWith('fail')) {
                    alert('로그인이 필요하거나 오류가 발생했습니다.');
                    return;
                }

                const shareUrl = window.location.origin + '/share/diary/' + uuid;
                const shareTitle = '${diary.nickname}님의 승요일기';
                const shareText = '오늘의 직관 기록을 확인해보세요!';

                try {
                    // 1. Appify 앱 환경인 경우
                    if (typeof appify !== 'undefined' && appify.isWebview) {
                        await appify.share.systemShare({
                            title: shareTitle,
                            message: shareText,
                            url: shareUrl
                        });
                    }
                    // 2. 일반 모바일 웹 (Navigator Share API)
                    else if (navigator.share) {
                        await navigator.share({
                            title: shareTitle,
                            text: shareText,
                            url: shareUrl
                        });
                    }
                    // 3. PC 등 미지원 환경 (클립보드 복사)
                    else {
                        copyToClipboard(shareUrl);
                    }
                } catch (e) {
                    console.error("공유 실패:", e);
                    // 공유 취소 등을 고려하여 에러 시 별도 처리 안 함 (필요 시 alert)
                }
            });
        }

        // 클립보드 복사 (Appify SDK 활용)
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

        /* ==========================================
           [Appify SDK] 이미지 다운로드 기능
           ========================================== */
        async function downloadImage(imgUrl) {
            // 1. URL 유효성 체크
            if (!imgUrl) {
                alert("저장할 이미지가 없습니다.");
                return;
            }

            // 2. Appify 앱 환경인지 확인
            if (typeof appify !== 'undefined' && appify.isWebview) {
                try {
                    // [SDK 호출] 이미지 다운로드 및 갤러리 저장 (문서 17.txt 참고)
                    const result = await appify.download.image(imgUrl);

                    if (result) {
                        alert("갤러리에 저장되었습니다. 📸");
                    } else {
                        alert("저장에 실패했습니다.");
                    }
                } catch (e) {
                    console.error("이미지 다운로드 오류:", e);
                    alert("오류가 발생했습니다: " + e.message);
                }
            } else {
                // 3. 일반 웹 브라우저일 경우 (새 탭으로 열기 또는 다운로드 시도)
                if (confirm("이미지를 보시겠습니까? (새 탭 열기)")) {
                    window.open(imgUrl, '_blank');
                }
            }
        }
    </script>
</body>
</html>