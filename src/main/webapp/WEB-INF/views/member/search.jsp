<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
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

    <title>친구찾기 | 승요일기</title>

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
                <div class="page-tit">친구찾기</div>
            </div>

            <form action="/member/search/result" method="get">
                <div class="search-box" style="padding: 16px;">
                    <div class="input-row" style="display:flex; gap:8px;">
                        <input type="text" name="keyword" value="${keyword}" placeholder="닉네임을 검색해보세요" style="flex:1; padding:10px; border:1px solid #ddd; border-radius:8px;">
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
                            <div class="user-item" onclick="location.href='/diary/friend/list?targetMemberId=${mem.memberId}'"
                                 style="display:flex; align-items:center; padding:12px 0; border-bottom:1px solid #eee; cursor:pointer;">

                                <%-- [수정] 로고를 감싸는 원형 박스 디자인 적용 --%>
                                <div style="width: 48px; height: 48px; min-width: 48px; margin-right: 12px; border-radius: 50%; background-color: #f8f9fa; border: 1px solid #eee; display: flex; align-items: center; justify-content: center; overflow: hidden;">
                                    <c:choose>
                                        <%-- 1. 응원팀이 없는 경우 --%>
                                        <c:when test="${empty mem.myTeamCode or mem.myTeamCode eq 'NONE'}">
                                            <img src="/img/logo/logo_default.svg" alt="기본 로고" style="width: 60%; height: 60%; object-fit: contain;">
                                        </c:when>

                                        <%-- 2. 응원팀이 있는 경우 --%>
                                        <c:otherwise>
                                            <c:set var="lowerTeamCode" value="${fn:toLowerCase(mem.myTeamCode)}" />
                                            <img src="/img/logo/logo_${lowerTeamCode}.svg"
                                                 alt="${mem.myTeamName}"
                                                 title="${mem.myTeamName}"
                                                 onerror="this.src='/img/logo/logo_default.svg'"
                                                 style="width: 65%; height: 65%; object-fit: contain;">
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="info" style="flex:1;">
                                    <div class="nick" style="font-weight:bold; font-size: 15px; color: #333; margin-bottom: 2px;"
                                        ${mem.nickname}
                                    </div>
                                    <div style="display: grid; gap: 8px; position: relative; font-size:12px; color:#888;">
                                        ${not empty mem.myTeamName ? mem.myTeamName : '응원팀 없음'}
                                    </div>
                                </div>

                                <c:choose>
                                    <c:when test="${mem.following}">
                                        <button type="button" id="btn_${mem.memberId}" class="btn btn-xs btn-gray"
                                                onclick="event.stopPropagation(); toggleFollow(${mem.memberId})"
                                                style="width: 60px; padding: 6px 0; font-size: 12px; border-radius: 6px; background-color: #eee; color: #777; border: none;">
                                            팔로잉
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" id="btn_${mem.memberId}" class="btn btn-xs btn-primary"
                                                onclick="event.stopPropagation(); toggleFollow(${mem.memberId})"
                                                style="width: 60px; padding: 6px 0; font-size: 12px; border-radius: 6px; background-color: #007bff; color: #fff; border: none;">
                                            팔로우
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        function toggleFollow(targetId) {
            const btn = document.getElementById('btn_' + targetId);

            // 버튼 비활성화 (중복 클릭 방지)
            btn.disabled = true;

            fetch('/member/follow/toggle?targetId=' + targetId, {method: 'POST'})
                .then(response => response.text())
                .then(res => {
                    btn.disabled = false;

                    if (res === 'followed') {
                        // 팔로우 성공 처리
                        btn.innerText = '팔로잉';
                        btn.classList.remove('btn-primary'); // 파란색 제거
                        btn.classList.add('btn-gray');       // 회색 추가
                        // alert('팔로우했습니다.'); // (선택사항) 너무 잦은 알림 방지 위해 제거 추천
                    } else if (res === 'unfollowed') {
                        // 언팔로우 성공 처리
                        btn.innerText = '팔로우';
                        btn.classList.remove('btn-gray');
                        btn.classList.add('btn-primary');
                    } else {
                        alert('오류가 발생했습니다.');
                    }
                })
                .catch(err => {
                    console.error(err);
                    btn.disabled = false;
                    alert('서버 통신 오류');
                });
        }
    </script>
</body>
</html>