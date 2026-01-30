<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
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

    <title>팔로우 관리 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
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

            <div class="stack mt-24">

                <ul class="tab_menu">
                    <li class="${param.tab eq 'following' ? 'on' : ''}" onclick="location.href='/member/follow/list?tab=following'">
                        팔로잉
                    </li>
                    <li class="${empty param.tab or param.tab eq 'follower' ? 'on' : ''}" onclick="location.href='/member/follow/list?tab=follower'">
                        팔로워
                    </li>
                </ul>

                <div class="tab_cont ${param.tab eq 'following' ? 'on' : ''}">
                    <c:if test="${param.tab eq 'following'}">
                        <c:choose>
                            <c:when test="${empty list}">
                                <div class="score_list nodt_list pd-24">
                                    <div class="nodt_wrap">
                                        <div class="cont">
                                            <img src="/img/ico_not_mark.svg" alt="데이터 비었을 때">
                                            <div class="nodt_tit">아직 팔로잉하는 친구가 없어요.<br /><span style="font-size: var(--fs-15);">친구를 추가해 직관 기록을 함께 확인해 보세요.</span></div>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="people">${fn:length(list)}명</div>
                                <ul class="make gap-16">
                                    <c:forEach var="item" items="${list}">
                                        <li>
                                            <div class="diary_write_list nodt_line friend_info_wrap bg-gray">
                                                <div class="friend_info" onclick="location.href='/diary/friend/view?memberId=${item.memberId}'" style="cursor:pointer;">
                                                    <div class="friend_item ${item.mutual ? 'follow-back' : ''}">
                                                        <div class="name">${item.nickname}</div>
                                                        <c:if test="${not empty item.myTeamCode}">
                                                            <div class="friend_team">${item.myTeamCode}</div>
                                                        </c:if>
                                                    </div>
                                                    <div class="win_rate">승요력 ${item.winRate}%</div>
                                                </div>
                                                <div class="follow-btn">
                                                    <button class="btn not-follow w-auto" type="button"
                                                            onclick="toggleFollow(${item.memberId}, 'unfollow', this)">취소</button>
                                                </div>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </div>

                <div class="tab_cont ${empty param.tab or param.tab eq 'follower' ? 'on' : ''}">
                    <c:if test="${empty param.tab or param.tab eq 'follower'}">
                        <c:choose>
                            <c:when test="${empty list}">
                                <div class="score_list nodt_list pd-24">
                                    <div class="nodt_wrap">
                                        <div class="cont">
                                            <img src="/img/ico_not_mark.svg" alt="데이터 비었을 때">
                                            <div class="nodt_tit">아직 나를 팔로우하는 친구가 없어요.</div>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="people">${fn:length(list)}명</div>
                                <ul class="make gap-16">
                                    <c:forEach var="item" items="${list}">
                                        <li>
                                            <div class="diary_write_list nodt_line friend_info_wrap bg-gray">
                                                <div class="friend_info" onclick="location.href='/diary/friend/view?memberId=${item.memberId}'" style="cursor:pointer;">
                                                    <div class="friend_item ${item.mutual ? 'follow-back' : ''}">
                                                        <div class="name">${item.nickname}</div>
                                                        <c:if test="${not empty item.myTeamCode}">
                                                            <div class="friend_team">${item.myTeamCode}</div>
                                                        </c:if>
                                                    </div>
                                                    <div class="win_rate">승요력 ${item.winRate}%</div>
                                                </div>
                                                <div class="follow-btn">
                                                    <c:choose>
                                                        <c:when test="${item.mutual}">
                                                            <button class="btn not-follow w-auto" type="button"
                                                                    onclick="toggleFollow(${item.memberId}, 'unfollow', this)">취소</button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn follow w-auto" type="button"
                                                                    onclick="toggleFollow(${item.memberId}, 'follow', this)">팔로우</button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </div>

            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        function toggleFollow(targetId, action, btn) {
            if (btn.disabled) return;
            const $btn = $(btn);
            $btn.prop('disabled', true);

            $.post('/member/follow/toggle', { targetId: targetId, action: action }, function(res) {
                if (res === 'ok') {
                    if (action === 'follow') {
                        // 팔로우 성공 (파란색 -> 회색)
                        $btn.removeClass('follow').addClass('not-follow').text('취소');
                        $btn.attr('onclick', "toggleFollow(" + targetId + ", 'unfollow', this)");
                    } else {
                        // 언팔로우 성공
                        if ('${param.tab}' === 'following') {
                            // 팔로잉 목록에서는 즉시 삭제
                            $btn.closest('li').fadeOut(300, function() { $(this).remove(); });
                        } else {
                            // 팔로워 목록에서는 버튼 변경 (회색 -> 파란색)
                            $btn.removeClass('not-follow').addClass('follow').text('팔로우');
                            $btn.attr('onclick', "toggleFollow(" + targetId + ", 'follow', this)");
                        }
                    }
                } else {
                    alert('요청을 처리하지 못했습니다.');
                }
            }).fail(function() {
                alert('서버 통신 오류가 발생했습니다.');
            }).always(function() {
                $btn.prop('disabled', false);
            });
        }
    </script>
</body>
</html>