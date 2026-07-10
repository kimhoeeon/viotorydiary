<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta name="naver-site-verification" content="07e0fdf4e572854d6fbe274f47714d3e7bbb9fbd" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes" />

    <meta property="og:type" content="website">
    <meta property="og:locale" content="ko_KR">
    <meta property="og:site_name" content="승요일기">
    <meta property="og:title" content="승요일기 | 야구 직관 기록 앱">
    <meta property="og:description" content="야구 직관 기록을 더 쉽고 재미있게! 경기 결과, 기록, 사진과 함께 나만의 야구 직관일기를 남겨보세요.">
    <meta name="keywords" content="승요일기 / 야구 직관 / 프로야구 직관 / 직관 후기 / 직관일기 / KBO / KBO 직관 / 프로야구 앱 / 야구팬 앱">
    <meta property="og:url" content="https://myseungyo.com/">
    <meta property="og:image" content="https://myseungyo.com/img/og_img.jpg">

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>승요랭킹 | 승요일기</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css">
    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
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
                <div class="page-tit">
                    승요랭킹
                </div>
                <div class="rank_select">
                    <select name="season" id="seasonSelect" onchange="filterRanking()">
                        <option value="" ${empty selectedSeason ? 'selected' : ''}>전체 시즌</option>
                        <option value="2026" ${selectedSeason eq '2026' ? 'selected' : ''}>2026 시즌</option>
                        <option value="2025" ${selectedSeason eq '2025' ? 'selected' : ''}>2025 시즌</option>
                        <option value="2024" ${selectedSeason eq '2024' ? 'selected' : ''}>2024 시즌</option>
                    </select>
                    <select name="teamCode" id="teamSelect" onchange="filterRanking()">
                        <option value="" ${empty selectedTeamCode ? 'selected' : ''}>전체보기</option>
                        <option value="SAMSUNG" ${selectedTeamCode eq 'SAMSUNG' ? 'selected' : ''}>삼성</option>
                        <option value="LG" ${selectedTeamCode eq 'LG' ? 'selected' : ''}>LG</option>
                        <option value="DOOSAN" ${selectedTeamCode eq 'DOOSAN' ? 'selected' : ''}>두산</option>
                        <option value="KIA" ${selectedTeamCode eq 'KIA' ? 'selected' : ''}>KIA</option>
                        <option value="LOTTE" ${selectedTeamCode eq 'LOTTE' ? 'selected' : ''}>롯데</option>
                        <option value="HANWHA" ${selectedTeamCode eq 'HANWHA' ? 'selected' : ''}>한화</option>
                        <option value="SSG" ${selectedTeamCode eq 'SSG' ? 'selected' : ''}>SSG</option>
                        <option value="KIWOOM" ${selectedTeamCode eq 'KIWOOM' ? 'selected' : ''}>키움</option>
                        <option value="KT" ${selectedTeamCode eq 'KT' ? 'selected' : ''}>KT</option>
                        <option value="NC" ${selectedTeamCode eq 'NC' ? 'selected' : ''}>NC</option>
                    </select>
                </div>
            </div>

            <ul class="comment regular">
                <li>승요랭킹은 “승요일기 보정승률 방식”을 적용하여 매주 월요일에 업데이트 됩니다.</li>
                <li>* 직관 인증 완료 경기만 집계됩니다</li>
            </ul>

            <div class="page-main_wrap">
                <div class="history">
                    <div class="history-list mt-24">
                        <div class="card_wrap">

                            <c:forEach var="rank" items="${top100List}" end="2" varStatus="status">
                                <div class="card_item rank-item">
                                    <div class="rank-board">

                                        <c:choose>
                                            <c:when test="${status.index == 0}"><c:set var="rankClass" value="rank_first"/></c:when>
                                            <c:when test="${status.index == 1}"><c:set var="rankClass" value="rank_second"/></c:when>
                                            <c:when test="${status.index == 2}"><c:set var="rankClass" value="rank_third"/></c:when>
                                        </c:choose>

                                        <div class="row ${rankClass}">
                                            <div class="rank_team">
                                                <div class="rank-badge">${rank.ranking}위</div>
                                                <div class="rank-profile">
                                                    <img src="/img/logo_${fn:toLowerCase(rank.myTeamCode)}.svg" alt="${rank.myTeamCode}" onerror="this.src='/img/team_default.svg'">
                                                    <div>
                                                        <div class="name">${rank.nickname}</div>
                                                        <div class="match">직관 ${rank.totalGames}경기</div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="rank_rate">
                                                <div class="txt">승률</div>
                                                <div class="rate_number">
                                                    <fmt:formatNumber value="${rank.winRate}" pattern="#,##0.#"/>%
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </c:forEach>

                            <c:if test="${empty selectedTeamCode or selectedTeamCode eq sessionScope.loginMember.myTeamCode}">
                                <div class="card_item rank-item my-rank">
                                    <div class="rank-board">
                                        <div class="tit">나의 승요랭킹</div>
                                        <c:choose>
                                            <c:when test="${not empty myRanking and myRanking.ranking > 0}">
                                                <div class="row">
                                                    <div class="rank_team">
                                                        <div class="rank-badge">${myRanking.ranking}위</div>
                                                        <div class="rank-profile">
                                                            <img src="/img/logo_${fn:toLowerCase(myRanking.myTeamCode)}.svg" alt="${myRanking.myTeamCode}" onerror="this.src='/img/team_default.svg'">
                                                            <div>
                                                                <div class="name">${myRanking.nickname}</div>
                                                                <div class="match">직관 ${myRanking.totalGames}경기</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="rank_rate">
                                                        <div class="txt">승률</div>
                                                        <div class="rate_number">
                                                            <fmt:formatNumber value="${myRanking.winRate}" pattern="#,##0.#"/>%
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="row" style="justify-content: center; padding: 20px 0; color: #999;">
                                                    해당 조건에 집계된 직관 기록이 없습니다.
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:if>

                            <c:forEach var="rank" items="${top100List}" begin="3" varStatus="status">

                                <c:if test="${status.first}">
                                    <div class="card_item rank-item">
                                        <div class="rank-board">
                                </c:if>

                                <div class="row rank_all">
                                    <div class="rank_team">
                                        <div class="rank-badge">${rank.ranking}위</div>
                                        <div class="rank-profile">
                                            <img src="/img/logo_${fn:toLowerCase(rank.myTeamCode)}.svg" alt="${rank.myTeamCode}" onerror="this.src='/img/team_default.svg'">
                                            <div>
                                                <div class="name">${rank.nickname}</div>
                                                <div class="match">직관 ${rank.totalGames}경기</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="rank_rate">
                                        <div class="rate_number">
                                            <fmt:formatNumber value="${rank.winRate}" pattern="#,##0.#"/>%
                                        </div>
                                    </div>
                                </div>

                                <c:if test="${status.last}">
                                    </div>
                                    </div>
                                </c:if>

                            </c:forEach>

                            <c:if test="${empty top100List}">
                                <div class="card_item rank-item">
                                    <div class="rank-board" style="text-align: center; padding: 40px; color: #999;">
                                        선택하신 조건에 해당하는 랭킹 데이터가 없습니다.
                                    </div>
                                </div>
                            </c:if>

                        </div>
                    </div>
                </div>

            </div>
        </div>

        <%@ include file="../include/tabbar.jsp" %>

    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js?v=1.1"></script>
    <script src="/js/app_interface.js"></script>

    <script>
        function filterRanking() {
            const season = document.getElementById('seasonSelect').value;
            const teamCode = document.getElementById('teamSelect').value;

            // 필터 선택 시 파라미터를 담아 새로고침
            location.href = '/locker/ranking?season=' + season + '&teamCode=' + teamCode;
        }
    </script>
</body>
</html>