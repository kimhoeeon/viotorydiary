<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />

    <link rel="icon" href="/img/favicon.png" />
    <link rel="shortcut icon" href="/img/favicon.png" />
    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>팔로우 관리 | 승요일기</title>

    <style>
        /* 탭 메뉴 스타일 (제공된 CSS에 없다면 추가) */
        .tab-wrap { display: flex; border-bottom: 1px solid #F5F5F5; background: #fff; }
        .tab-item { flex: 1; text-align: center; padding: 14px 0; font-size: 15px; color: #999; font-weight: 500; cursor: pointer; }
        .tab-item.active { color: #0E0F12; border-bottom: 2px solid #0E0F12; font-weight: 700; }
        .no-data { text-align: center; padding: 60px 0; color: #999; font-size: 14px; }
    </style>
</head>

<body>
    <div class="app">

        <header class="app-header">
            <button class="app-header_btn app-header_back" type="button" onclick="location.href='/member/mypage'">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main column">

            <div class="app-tit">
                <div class="page-tit">팔로우 관리</div>
            </div>

            <div class="tab-wrap">
                <div class="tab-item ${tab eq 'following' ? 'active' : ''}" onclick="location.href='/member/follow/list?tab=following'">
                    팔로잉
                </div>
                <div class="tab-item ${tab eq 'follower' ? 'active' : ''}" onclick="location.href='/member/follow/list?tab=follower'">
                    팔로워
                </div>
            </div>

            <div class="stack mt-24">
                <div class="my-follow_list">
                    <ul>
                        <c:choose>
                            <c:when test="${empty list}">
                                <li class="no-data">
                                    <c:if test="${tab eq 'following'}">아직 팔로우한 친구가 없어요.</c:if>
                                    <c:if test="${tab eq 'follower'}">아직 나를 팔로우한 친구가 없어요.</c:if>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="item" items="${list}">
                                    <li>
                                        <div class="diary_write_list nodt_line friend_info_wrap bg-gray">
                                            <div class="friend_info">
                                                <div class="friend_item ${item.mutual ? 'follow-back' : ''}">
                                                    <div class="name">${item.nickname}</div>
                                                    <div class="friend_team">${item.myTeamCode}</div>
                                                </div>
                                                <div class="win_rate">승요력 ${item.winRate}%</div>
                                            </div>

                                            <div class="follow-btn">
                                                <c:choose>
                                                    <%-- [팔로잉 탭] 항상 '취소' 버튼 --%>
                                                    <c:when test="${tab eq 'following'}">
                                                        <button class="btn not-follow w-auto" type="button"
                                                                onclick="toggleFollow(${item.memberId}, 'unfollow', this)">
                                                            취소
                                                        </button>
                                                    </c:when>

                                                    <%-- [팔로워 탭] 내가 팔로우 중이면 '취소', 아니면 '팔로우' --%>
                                                    <c:when test="${tab eq 'follower'}">
                                                        <c:choose>
                                                            <c:when test="${item.following}">
                                                                <button class="btn not-follow w-auto" type="button"
                                                                        onclick="toggleFollow(${item.memberId}, 'unfollow', this)">
                                                                    취소
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button class="btn follow w-auto" type="button"
                                                                        onclick="toggleFollow(${item.memberId}, 'follow', this)">
                                                                    팔로우
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </li>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>

        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script>
        function toggleFollow(targetId, action, btn) {
            // 중복 클릭 방지
            if (btn.disabled) return;
            const $btn = $(btn);

            $.post('/member/follow/toggle', { targetId: targetId, action: action }, function(res) {
                if (res === 'ok') {
                    if (action === 'follow') {
                        // 팔로우 성공 -> 취소 버튼으로 변경
                        $btn.removeClass('follow').addClass('not-follow').text('취소');
                        $btn.attr('onclick', "toggleFollow(" + targetId + ", 'unfollow', this)");
                    } else {
                        // 언팔로우 성공
                        if ('${tab}' === 'following') {
                            // 팔로잉 목록에서는 항목 삭제
                            $btn.closest('li').fadeOut(300, function() { $(this).remove(); });
                        } else {
                            // 팔로워 목록에서는 팔로우 버튼으로 변경
                            $btn.removeClass('not-follow').addClass('follow').text('팔로우');
                            $btn.attr('onclick', "toggleFollow(" + targetId + ", 'follow', this)");
                        }
                    }
                } else {
                    alert('요청을 처리하지 못했습니다.');
                }
            }).fail(function() {
                alert('서버 통신 오류가 발생했습니다.');
            });
        }
    </script>
</body>
</html>