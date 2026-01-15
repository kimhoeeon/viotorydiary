<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"/>
    <link rel="icon" href="/img/favicon.png"/>
    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">
    <title>상세보기 | 승요일기</title>
    <style>
        /* 더보기 기능용: 5번째 이후 댓글 숨김 */
        .review_list li.hidden-cmt {
            display: none;
        }
    </style>
</head>

<body>
    <div class="app">
        <header class="app-header">
            <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>

            <c:if test="${isOwner and diary.isPublic ne 'PRIVATE'}">
                <button class="app-header_btn" type="button" onclick="shareDiary()" style="margin-left:auto;">
                    <img src="/img/ico_clip.svg" alt="공유하기"> </button>
            </c:if>
        </header>

        <div class="app-main">
            <div class="card_wrap play_wrap gap-16">
                <div class="card_item pt-24 pb-24">
                    <div class="review_wrap">
                        <ul class="review_list" id="reviewList">
                            <c:forEach var="cmt" items="${comments}" varStatus="status">
                                <li class="${status.index >= 5 ? 'hidden-cmt' : ''}">
                                    <div class="name"><span>${cmt.memberTeamCode}</span> ${cmt.nickname}</div>
                                    <div class="nae">${cmt.content}</div>

                                    <c:if test="${cmt.memberId eq sessionScope.loginMember.memberId or isOwner}">
                                        <button class="del-btn" type="button"
                                                onclick="deleteComment(${cmt.commentId}, this)">
                                            <span><img src="/img/ico_del.svg" alt="삭제 아이콘"></span>
                                        </button>
                                    </c:if>
                                </li>
                            </c:forEach>
                            <c:if test="${empty comments}">
                                <li style="text-align:center; padding:10px; color:#999;">작성된 댓글이 없습니다.</li>
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
                                <input type="text" id="cmtContent" placeholder="댓글을 입력하세요. (30자 내 이내)"
                                       onkeyup="checkCmtInput()">
                                <button class="send wpx-80" id="btnCmtSend" disabled onclick="submitComment()">
                                    작성
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <c:if test="${not isEditable and isOwner}">
                <div class="horizon-mes">
                    <img src="/img/ico_not_mark_red.svg" alt="수정 불가"> 경기 시간이 임박하여 수정할 수 없어요.
                </div>
            </c:if>
        </div>

        <c:if test="${isOwner}">
            <div class="bottom-action">
                <button type="button" class="btn border" onclick="deleteDiary()">삭제</button>

                <button type="button" class="btn btn-primary"
                        onclick="editDiary()"
                    ${not isEditable ? 'disabled' : ''}>
                    수정
                </button>
            </div>
        </c:if>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script>
        // 댓글 입력 감지
        function checkCmtInput() {
            const val = $('#cmtContent').val().trim();
            $('#btnCmtSend').prop('disabled', val.length === 0);
        }

        // 댓글 작성
        function submitComment() {
            const content = $('#cmtContent').val();
            if (!content) return;

            $.post('/diary/comment/write', {
                diaryId: '${diary.diaryId}',
                content: content
            }, function (res) {
                if (res === 'ok') location.reload();
                else alert('작성 실패');
            });
        }

        // 댓글 삭제
        function deleteComment(id, btn) {
            if (!confirm('댓글을 삭제하시겠습니까?')) return;

            $.post('/diary/comment/delete', {commentId: id}, function (res) {
                if (res === 'ok') {
                    $(btn).closest('li').remove();
                } else {
                    alert('삭제 권한이 없거나 오류가 발생했습니다.');
                }
            });
        }

        // 댓글 더보기
        function showAllComments() {
            $('.hidden-cmt').slideDown();
            $('#moreBtn').hide();
        }

        // 일기 삭제
        function deleteDiary() {
            if(!confirm('정말 일기를 삭제하시겠습니까?\n삭제 후에는 복구할 수 없습니다.')) {
                return;
            }

            // AJAX로 삭제 요청
            $.post('/diary/delete', { diaryId: '${diary.diaryId}' }, function(res) {
                if (res === 'ok') {
                    alert('일기가 삭제되었습니다.');
                    location.href = '/diary/list'; // 목록으로 이동
                } else if (res.startsWith('fail:login')) {
                    alert('로그인이 필요합니다.');
                    location.href = '/member/login';
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
            $.post('/diary/share/create', { diaryId: '${diary.diaryId}' }, function(uuid) {
                if(uuid.startsWith('fail')) {
                    alert('로그인이 필요하거나 오류가 발생했습니다.');
                    return;
                }

                const shareUrl = window.location.origin + '/share/diary/' + uuid;

                // 모바일 공유 기능 (Navigator Share API)
                if (navigator.share) {
                    navigator.share({
                        title: '${diary.nickname}님의 승요일기',
                        text: '오늘의 직관 기록을 확인해보세요!',
                        url: shareUrl
                    }).catch(console.error);
                } else {
                    // PC 등에서는 클립보드 복사
                    navigator.clipboard.writeText(shareUrl).then(() => {
                        alert('공유 링크가 복사되었습니다!');
                    });
                }
            });
        }
    </script>
</body>
</html>