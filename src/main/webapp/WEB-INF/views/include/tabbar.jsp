<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%-- 1. URL 추출 로직 (Forward된 원본 URL 우선 확인) --%>
<c:set var="req" value="${pageContext.request}" />
<c:set var="forwardUri" value="${requestScope['javax.servlet.forward.request_uri']}" />
<c:set var="reqUri" value="${req.requestURI}" />

<%-- forwardUri가 존재하면 그것을(실제 주소), 없으면 reqUri(내부 주소)를 사용 --%>
<c:set var="targetUri" value="${(not empty forwardUri) ? forwardUri : reqUri}" />

<%-- Context Path(/viotorydiary 등) 제거 --%>
<c:set var="cp" value="${req.contextPath}" />
<c:set var="lenCp" value="${fn:length(cp)}" />
<c:set var="lenUri" value="${fn:length(targetUri)}" />
<c:set var="path" value="${fn:substring(targetUri, lenCp, lenUri)}" />

<%-- 2. 활성화 여부 판단 (이중 체크: URL 시작점 OR 내부 폴더명 포함 여부) --%>

<%-- 홈: /, /main, 또는 main.jsp/index.jsp 파일명 포함 시 --%>
<c:set var="isHome" value="${path eq '/' || path eq '/main' || fn:contains(path, '/main.jsp') || fn:contains(path, '/index.jsp')}" />

<%-- 경기: /play로 시작 하거나, /views/play/ 폴더 안에 있을 때 --%>
<c:set var="isPlay" value="${fn:startsWith(path, '/play') || fn:contains(path, '/views/play/')}" />

<%-- 일기: /diary로 시작 하거나, /views/diary/ 폴더 안에 있을 때 --%>
<c:set var="isDiary" value="${fn:startsWith(path, '/diary') || fn:contains(path, '/views/diary/') || fn:contains(path, '/member/search')}" />

<%-- 라커룸: /locker로 시작 하거나, /views/locker/ 폴더 안에 있을 때 --%>
<c:set var="isLocker" value="${fn:startsWith(path, '/locker') || fn:contains(path, '/views/locker/')}" />

<%-- My: /member로 시작 하거나 /views/member/ 폴더 (단, 로그인/가입/친구찾기 제외) --%>
<c:set var="isMy" value="${(fn:startsWith(path, '/member') || fn:contains(path, '/views/member/')) && !fn:contains(path, 'login') && !fn:contains(path, 'join') && !fn:contains(path, 'search')}" />

<%-- [DEBUG] 적용 후 로그 확인 (확인 후 주석 처리하세요) --%>
<nav class="app-tabbar" aria-label="하단 메뉴">

    <a class="app-tabbar_item ${isHome ? 'active' : ''}" href="/" ${isHome ? 'aria-current="page"' : ''}>
        <span aria-hidden="true">
            <img src="/img/tabbar_home${isHome ? '_active' : ''}.svg" alt="홈 아이콘">
        </span>
        <span style="${isHome ? 'color:#000; font-weight:700;' : 'color:#999;'}">홈</span>
    </a>

    <a class="app-tabbar_item ${isPlay ? 'active' : ''}" href="/play" ${isPlay ? 'aria-current="page"' : ''}>
        <span aria-hidden="true">
            <img src="/img/tabbar_play${isPlay ? '_active' : ''}.svg" alt="경기 아이콘">
        </span>
        <span style="${isPlay ? 'color:#000; font-weight:700;' : 'color:#999;'}">경기</span>
    </a>

    <a class="app-tabbar_item ${isDiary ? 'active' : ''}" href="/diary/winyo" ${isDiary ? 'aria-current="page"' : ''}>
        <span aria-hidden="true">
            <img src="/img/tabbar_note${isDiary ? '_active' : ''}.svg" alt="일기 아이콘">
        </span>
        <span style="${isDiary ? 'color:#000; font-weight:700;' : 'color:#999;'}">일기</span>
    </a>

    <a class="app-tabbar_item ${isLocker ? 'active' : ''}" href="/locker/main" ${isLocker ? 'aria-current="page"' : ''}>
        <span aria-hidden="true">
            <img src="/img/tabbar_locker${isLocker ? '_active' : ''}.svg" alt="라커룸 아이콘">
        </span>
        <span style="${isLocker ? 'color:#000; font-weight:700;' : 'color:#999;'}">라커룸</span>
    </a>

    <a class="app-tabbar_item ${isMy ? 'active' : ''}" href="/member/mypage" ${isMy ? 'aria-current="page"' : ''}>
        <span aria-hidden="true">
            <img src="/img/tabbar_my${isMy ? '_active' : ''}.svg" alt="My 아이콘">
        </span>
        <span style="${isMy ? 'color:#000; font-weight:700;' : 'color:#999;'}">My</span>
    </a>

</nav>