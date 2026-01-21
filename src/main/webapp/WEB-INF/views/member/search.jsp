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
    <title>친구 찾기</title>
</head>
<body>
    <div class="app">
        <header class="app-header">
            <button class="app-header_btn" onclick="history.back()"><img src="/img/ico_back_arrow.svg"></button>
            <div class="page-tit">친구 찾기</div>
        </header>

        <div class="app-main">
            <form action="/member/search/result" method="get">
                <div class="search-box" style="padding: 16px;">
                    <div class="input-row" style="display:flex; gap:8px;">
                        <input type="text" name="keyword" value="${keyword}" placeholder="닉네임을 검색해보세요"
                               style="flex:1; padding:10px; border:1px solid #ddd; border-radius:8px;">
                        <button type="submit" class="btn btn-primary" style="width:60px;">검색</button>
                    </div>
                </div>
            </form>

            <div class="list-wrap" style="padding: 0 16px;">
                <c:choose>
                    <c:when test="${empty list and not empty keyword}">
                        <div class="no-data" style="text-align:center; margin-top:50px; color:#999;">검색 결과가 없습니다.</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="mem" items="${list}">
                            <div class="user-item"
                                 style="display:flex; align-items:center; padding:12px 0; border-bottom:1px solid #eee;">
                                <img src="${not empty mem.profileImage ? mem.profileImage : '/img/ico_user.svg'}"
                                     style="width:40px; height:40px; border-radius:50%; object-fit:cover; margin-right:12px;">
                                <div class="info" style="flex:1;">
                                    <div class="nick" style="font-weight:bold;">${mem.nickname}</div>
                                    <div class="team" style="font-size:12px; color:#888;">${mem.myTeamName}</div>
                                </div>
                                <button type="button" class="btn btn-xs btn-outline"
                                        onclick="toggleFollow(${mem.memberId})">팔로우
                                </button>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="/js/script.js"></script>
    <script>
        function toggleFollow(targetId) {
            // 기존에 만든 팔로우 토글 API 활용
            fetch('/member/follow/toggle?targetId=' + targetId, {method: 'POST'})
                .then(response => response.text())
                .then(res => {
                    if (res.includes('fail')) alert('오류가 발생했습니다.');
                    else alert('처리되었습니다.');
                });
        }
    </script>
</body>
</html>