<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
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

    <title>친구 일기 | 승요일기</title>

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
                <div class="page-tit">
                    친구들의 직관
                </div>
            </div>

            <div class="tab-pill">
                <button type="button" class="tab-pill_btn ${param.tab == null || param.tab == 'all' ? 'on' : ''}" onclick="location.href='?tab=all'">
                    전체
                </button>
                <button type="button" class="tab-pill_btn ${param.tab == 'follower' ? 'on' : ''}" onclick="location.href='?tab=follower'">
                    팔로우
                </button>
                <button type="button" class="tab-pill_btn ${param.tab == 'following' ? 'on' : ''}" onclick="location.href='?tab=following'">
                    팔로잉
                </button>
            </div>

            <div class="page-main_wrap">
                <div class="history">
                    <div class="history-list mt-24">
                        <div class="score_wrap row_wrap">

                            <c:choose>
                                <%-- 데이터가 없을 때 --%>
                                <c:when test="${empty list}">
                                    <div class="score_list nodt_list">
                                        <div class="nodt_wrap">
                                            <div class="cont">
                                                <img src="/img/ico_not_mark.svg" alt="데이터 비었을 때">
                                                <div class="nodt_tit">아직 작성한 직관 기록이 없어요.</div>
                                            </div>
                                        </div>
                                    </div>
                                </c:when>

                                <%-- 데이터 리스트 출력 --%>
                                <c:otherwise>
                                    <c:forEach var="item" items="${list}">
                                        <div class="score_list" onclick="location.href='/diary/friend/detail?diaryId=${item.diaryId}'" style="cursor: pointer;">
                                            <div class="img">
                                                <img src="${not empty item.imageUrl ? item.imageUrl : '/img/card_defalut.svg'}" alt="스코어카드 이미지" style="width:100%; height:100%; object-fit:cover;">
                                            </div>
                                            <div class="column gap-16" style="flex:1;">
                                                <div class="score_txt">
                                                    <div class="txt_box">
                                                        <div class="tit">
                                                            ${item.homeTeamName} ${item.scoreHome} vs ${item.scoreAway} ${item.awayTeamName}
                                                        </div>
                                                        <div class="date">
                                                            ${item.nickname}
                                                        </div>
                                                    </div>

                                                    <c:if test="${item.gameResult eq 'WIN'}">
                                                        <div class="score_win">
                                                            <img src="/img/ico_check.svg" alt="승리">
                                                        </div>
                                                    </c:if>
                                                    </div>

                                                <div class="diary_review text-ellipsis-1">
                                                    ${item.oneLineComment}
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <style>
        /* 한줄평 말줄임 처리 */
        .text-ellipsis-1 {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            font-size: 14px;
            color: #333;
        }
    </style>
</body>
</html>