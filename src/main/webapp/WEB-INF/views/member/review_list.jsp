<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
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

    <title>댓글 관리 | 승요일기</title>

    <style>
        /* 데이터 없을 때 스타일 추가 */
        .no-data { text-align: center; padding: 60px 0; color: #999; font-size: 14px; }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">

        <header class="app-header">
            <button class="app-header_btn app-header_back" type="button" onclick="location.href='/member/mypage'">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main">

            <div class="app-tit">
                <div class="page-tit">댓글 관리</div>
            </div>

            <div class="review review_wrap mt-24">
                <ul class="review_list">
                    <c:choose>
                        <c:when test="${empty list}">
                            <li class="no-data" style="background: none;">작성한 댓글이 없습니다.</li>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${list}">
                                <li>
                                    <div class="name"><span>${item.diaryTeamCode}</span> ${item.diaryTitle}</div>
                                    <div class="nae">${item.content}</div>
                                    <button class="del-btn" type="button" onclick="deleteComment(${item.commentId}, this)">
                                        <span><img src="/img/ico_del.svg" alt="삭제 아이콘"></span>
                                    </button>
                                </li>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>

        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        function deleteComment(commentId, btn) {
            if (!confirm('정말 삭제하시겠습니까?')) return;

            $.post('/member/review/delete', { commentId: commentId }, function(res) {
                if (res === 'ok') {
                    // 삭제 성공 시 리스트에서 제거 (애니메이션 효과)
                    $(btn).closest('li').fadeOut(300, function() {
                        $(this).remove();
                        if ($('.review_list li').length === 0) {
                            location.reload(); // 리스트 비면 갱신 (no-data 표시)
                        }
                    });
                } else {
                    alert('삭제에 실패했습니다.');
                }
            }).fail(function() {
                alert('서버 오류가 발생했습니다.');
            });
        }
    </script>
</body>
</html>