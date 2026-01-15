<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
    <title>친구 일기 | 승요일기</title>
</head>

<body>
    <div class="app">
        <div class="top_wrap" style="position:sticky; top:0; background:#fff; z-index:10; border-bottom:1px solid #f0f0f0;">
            <div class="main-top" style="justify-content: center; gap: 24px; padding: 16px 0;">
                <a href="/diary/winyo" style="font-size:18px; color:#999; font-weight:500;">나의 기록</a>
                <a href="/diary/friend/list"
                   style="font-size:18px; color:#000; font-weight:700; border-bottom:2px solid #000; padding-bottom:4px;">친구
                    일기</a>
            </div>
        </div>

        <div class="app-main">
            <div class="page-main_wrap">

                <div class="mt-24">
                    <c:choose>
                        <%-- 친구 일기가 없을 때 --%>
                        <c:when test="${empty list}">
                            <div class="no-data" style="text-align:center; padding:60px 0;">
                                <div style="margin-bottom:16px;">
                                    <img src="/img/ico_friend.svg" alt="친구 없음" style="width:48px; opacity:0.5;">
                                </div>
                                <div style="color:#999; font-size:14px; margin-bottom:24px;">
                                    아직 친구들의 소식이 없어요.<br>
                                    새로운 승요 친구를 찾아보세요!
                                </div>
                                <a href="/member/search" class="btn btn-sm btn-secondary"
                                   style="display:inline-block; width:auto; padding:8px 20px;">
                                    새 친구 찾기
                                </a>
                            </div>
                        </c:when>

                        <%-- 친구 일기 리스트 --%>
                        <c:otherwise>
                            <c:forEach var="item" items="${list}">
                                <div class="card_item mb-16" onclick="location.href='/diary/detail?diaryId=${item.diaryId}'"
                                     style="cursor:pointer; background:#fff; padding:20px; border-radius:16px;">

                                    <div class="row align-center mb-12">
                                        <div class="profile-img"
                                             style="width:36px; height:36px; border-radius:50%; overflow:hidden; margin-right:10px; border:1px solid #eee;">
                                            <img src="${not empty item.profileImage ? item.profileImage : '/img/ico_user.svg'}"
                                                 alt="프로필" style="width:100%; height:100%; object-fit:cover;">
                                        </div>
                                        <div class="info">
                                            <div class="nickname"
                                                 style="font-weight:700; font-size:14px;">${item.nickname}</div>
                                            <div class="date" style="font-size:12px; color:#999;">
                                                <fmt:parseDate value="${item.gameDate}" pattern="yyyy-MM-dd" var="pDate"
                                                               type="date"/>
                                                <fmt:formatDate value="${pDate}" pattern="yyyy년 M월 d일"/> 직관
                                            </div>
                                        </div>
                                    </div>

                                    <div class="diary-content">
                                        <div class="match-info mb-8" style="font-size:13px; color:#555;">
                                            <span style="font-weight:bold; color:#2c7fff;">${item.homeTeamName}</span> vs
                                            <span>${item.awayTeamName}</span>
                                            <c:if test="${not empty item.gameResult}">
                                                    <span class="badge ${item.gameResult == 'WIN' ? 'badge-win' : 'badge-lose'}"
                                                          style="margin-left:6px; font-size:11px; padding:2px 6px; border-radius:4px; background:${item.gameResult == 'WIN' ? '#e8f3ff' : '#ffe8e8'}; color:${item.gameResult == 'WIN' ? '#2c7fff' : '#ff4d4f'};">
                                                            ${item.gameResult == 'WIN' ? '승리' : (item.gameResult == 'DRAW' ? '무승부' : '패배')}
                                                    </span>
                                            </c:if>
                                        </div>

                                        <div class="text text-ellipsis-2"
                                             style="font-size:14px; line-height:1.5; color:#333;">
                                                ${item.content}
                                        </div>

                                        <c:if test="${not empty item.imageUrl}">
                                            <div class="thum mt-12"
                                                 style="height:160px; border-radius:8px; overflow:hidden;">
                                                <img src="${item.imageUrl}" alt="일기 사진"
                                                     style="width:100%; height:100%; object-fit:cover;">
                                            </div>
                                        </c:if>
                                    </div>

                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </div>

        <a href="/diary/write" class="floating-btn">
            <img src="/img/ico_plus.svg" alt="글쓰기">
        </a>

        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <script src="/js/script.js"></script>
    <style>
        .text-ellipsis-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    </style>
</body>
</html>