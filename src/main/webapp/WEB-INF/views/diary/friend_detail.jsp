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
    <title>친구들의 직관 | 승요일기</title>

    <style>
        /* 로고 이미지 스타일 강제 적용 */
        .team img {
            width: 48px; height: 48px; object-fit: contain; display: block; margin: 0 auto;
        }
        .review_list li.hidden-cmt { display: none; }
    </style>
</head>

<body>
    <div class="app">

        <header class="app-header" style="position:sticky; top:0; left:0; transform:none; width:100%; max-width:460px; margin:0 auto; background:#fff; z-index:100; border-bottom:1px solid #f0f0f0;">
            <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main">

            <div class="app-tit">
                <div class="page-tit">
                    친구들의 직관
                </div>
                <div class="location-certify">
                    <c:choose>
                        <c:when test="${diary.isVerified}">
                            <div class="certify_mes"><img src="/img/ico_certify-comp_p.svg" alt="인증완료">직관 인증완료!</div>
                        </c:when>
                        <c:otherwise>
                            <div class="certify_mes"><img src="/img/ico_certify-not_p.svg" alt="미인증">인증하지 않았어요</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="page-main_wrap">
                <div class="history">
                    <div class="history-list mt-24">
                        <div class="diary_write_form">

                            <div class="diary_write_list nodt_line friend_info_wrap">
                                <div class="friend_info">
                                    <div class="friend_item">
                                        <div class="name">${writer.nickname}</div>
                                        <div class="friend_team">${writer.myTeamCode}</div>
                                    </div>
                                    <div class="win_rate">승요력 <fmt:formatNumber value="${writerWinYo.winRate}" pattern="#,##0"/>%</div>
                                </div>
                                <div class="follow-btn">
                                    <c:choose>
                                        <c:when test="${isFollowing}">
                                            <button class="btn following w-auto" type="button" onclick="toggleFollow(${writer.memberId})">팔로잉</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn follow w-auto" type="button" onclick="toggleFollow(${writer.memberId})">팔로우</button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="diary_write_list">
                                <div class="tit">직관할 경기</div>
                                <button class="select-field" disabled>
                                    <span class="select-field_value">
                                        [${diary.stadiumName}] ${diary.homeTeamName} vs ${diary.awayTeamName}
                                        <fmt:parseDate value="${diary.gameDate}" pattern="yyyy-MM-dd" var="pDate" type="date"/>
                                        <fmt:formatDate value="${pDate}" pattern="MM. dd"/> ${diary.gameTime}
                                    </span>
                                </button>
                            </div>

                            <div class="diary_write_list">
                                <div class="tit">오늘의 스코어 예상해 본다면?</div>
                                <div class="card_item">
                                    <div class="game-board">
                                        <div class="row row-center gap-24">
                                            <div class="team">
                                                <c:if test="${diary.homeTeamCode eq writer.myTeamCode}">
                                                    <div class="my-team">MY</div>
                                                </c:if>
                                                <img src="${diary.homeTeamLogo}" alt="${diary.homeTeamName}" onerror="this.src='/img/logo/default.svg'">
                                                <div class="team-name mt-4">${diary.homeTeamName}</div>
                                            </div>

                                            <div class="game-score schedule">
                                                <div class="left-team-score">
                                                    <div class="score-data">${diary.predScoreHome}</div>
                                                </div>
                                                <div class="game-info-wrap">VS</div>
                                                <div class="right-team-score">
                                                    <div class="score-data">${diary.predScoreAway}</div>
                                                </div>
                                            </div>

                                            <div class="team">
                                                <c:if test="${diary.awayTeamCode eq writer.myTeamCode}">
                                                    <div class="my-team">MY</div>
                                                </c:if>
                                                <img src="${diary.awayTeamLogo}" alt="${diary.awayTeamName}" onerror="this.src='/img/logo/default.svg'">
                                                <div class="team-name mt-4">${diary.awayTeamName}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="diary_write_list">
                                <div class="tit">오늘의 히어로는 누구일까?</div>
                                <input type="text" value="${diary.heroName}" disabled>
                            </div>

                            <div class="diary_write_list">
                                <div class="tit">오늘의 경기를 한 마디로 평가한다면?!</div>
                                <input type="text" value="${diary.oneLineComment}" disabled>
                            </div>

                            <div class="diary_write_list">
                                <div class="tit">오늘의 경기를 기록해 보세요</div>
                                <textarea disabled>${diary.content}</textarea>
                            </div>

                            <div class="diary_write_list">
                                <div class="tit">오늘 경기 사진</div>
                                <c:if test="${not empty diary.imageUrl}">
                                    <img src="${diary.imageUrl}" alt="업로드 이미지" style="width:100%; border-radius:8px;">
                                </c:if>
                                <c:if test="${empty diary.imageUrl}">
                                    <div style="color:#999; font-size:13px; padding:10px 0;">등록된 사진이 없습니다.</div>
                                </c:if>
                            </div>
                        </div>

                        <div class="card_wrap play_wrap gap-16">
                            <div class="card_item pt-24 pb-24">
                                <div class="review_wrap">
                                    <ul class="review_list" id="reviewList">
                                        <c:forEach var="cmt" items="${comments}" varStatus="status">
                                            <li class="${status.index >= 5 ? 'hidden-cmt' : ''}">
                                                <div class="name"><span>${cmt.memberTeamCode}</span> ${cmt.nickname}</div>
                                                <div class="nae">${cmt.content}</div>

                                                <c:if test="${cmt.memberId eq sessionScope.loginMember.memberId}">
                                                    <button class="del-btn" style="float:right;" onclick="deleteComment(${cmt.commentId}, this)">
                                                        <img src="/img/ico_del.svg" alt="삭제" style="width:16px;">
                                                    </button>
                                                </c:if>
                                            </li>
                                        </c:forEach>
                                        <c:if test="${empty comments}">
                                            <li style="text-align:center; padding:20px; color:#999;">작성된 댓글이 없습니다.</li>
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
                                            <input type="text" id="cmtContent" placeholder="댓글을 입력하세요. (30자 내 이내)" onkeyup="checkCmtInput()">
                                            <button class="send wpx-80" id="btnCmtSend" disabled onclick="submitComment()">
                                                작성
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <div class="bottom-action bottom-main">
            <button type="button" class="btn btn-primary" onclick="location.href='/diary/friend/list'">
                목록으로
            </button>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>

    <script>
        // 팔로우 토글
        function toggleFollow(memberId) {
            const $btn = $('.follow-btn button');
            const isFollowing = $btn.hasClass('following');
            const action = isFollowing ? 'unfollow' : 'follow';

            $.post('/member/follow/toggle', { targetId: memberId, action: action }, function(res) {
                if (res === 'ok') {
                    if (action === 'follow') {
                        $btn.removeClass('follow').addClass('following').text('팔로잉');
                    } else {
                        $btn.removeClass('following').addClass('follow').text('팔로우');
                    }
                } else if (res.startsWith('fail:login')) {
                    alert('로그인이 필요합니다.');
                    location.href = '/member/login';
                } else if (res === 'fail:self') {
                    alert('자기 자신은 팔로우할 수 없습니다.');
                } else {
                    alert('요청 처리에 실패했습니다.');
                }
            }).fail(function() {
                alert('서버 통신 오류가 발생했습니다.');
            });
        }

        // 댓글 입력 감지
        function checkCmtInput() {
            const val = $('#cmtContent').val().trim();
            $('#btnCmtSend').prop('disabled', val.length === 0);
        }

        // 댓글 등록
        function submitComment() {
            const content = $('#cmtContent').val();
            if (!content) return;
            $.post('/diary/comment/write', {diaryId: '${diary.diaryId}', content: content}, function (res) {
                if (res === 'ok') location.reload();
                else alert('댓글 등록 실패');
            });
        }

        // 댓글 삭제
        function deleteComment(id, btn) {
            if (!confirm('삭제하시겠습니까?')) return;
            $.post('/diary/comment/delete', {commentId: id}, function (res) {
                if (res === 'ok') $(btn).closest('li').remove();
            });
        }

        // 댓글 더보기
        function showAllComments() {
            $('.hidden-cmt').slideDown();
            $('#moreBtn').hide();
        }
    </script>
</body>
</html>