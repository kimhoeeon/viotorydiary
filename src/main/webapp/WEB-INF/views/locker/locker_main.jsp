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
    <title>라커룸 | 승요일기</title>
</head>

<body>
    <div class="app">
        <div class="top_wrap">
            <div class="main-top">
                <div class="main-title">라커룸</div>
                <button class="noti-btn has-badge" onclick="location.href='/alarm/list'">
                    <span class="noti-btn_icon"><img src="/img/ico_noti.svg" alt="알림"></span>
                    <span class="noti-dot"></span>
                </button>
            </div>
        </div>

        <div class="app-main">
            <div class="page-main_wrap">

                <div class="history">
                    <div class="history-list mt-24">

                        <div class="card_wrap ev">
                            <div class="row history-head">
                                <div class="tit ev_tit">야구 200% 즐기기</div>
                            </div>
                            <div class="card_item">
                                <c:choose>
                                    <c:when test="${not empty event}">
                                        <div class="img" onclick="location.href='/locker/detail?postId=${event.postId}'"
                                             style="cursor:pointer;">
                                            <img src="${not empty event.imageUrl ? event.imageUrl : '/img/card_sample02.jpg'}"
                                                 alt="이벤트 배너" style="border-radius:12px;">
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="nodt_wrap only_txt">
                                            <div class="cont">
                                                <div class="nodt_txt">진행 중인 이벤트가 없습니다.</div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="card_wrap content">
                            <div class="row history-head">
                                <div class="tit content_tit">우리 팀 추천 콘텐츠</div>
                                <a href="/locker/content/list">
                                    <img src="/img/ico_next_arrow.svg" alt="모두 보기">
                                </a>
                            </div>
                            <div class="card_item">
                                <div class="score_wrap"
                                     style="display:flex; overflow-x:auto; gap:12px; padding-bottom:10px;">
                                    <c:choose>
                                        <c:when test="${not empty contents}">
                                            <c:forEach var="content" items="${contents}">
                                                <div class="score_list"
                                                     onclick="location.href='/locker/detail?postId=${content.postId}'"
                                                     style="min-width:140px; cursor:pointer;">
                                                    <div class="img">
                                                        <img src="${not empty content.imageUrl ? content.imageUrl : '/img/card_defalut.svg'}"
                                                             alt="콘텐츠 이미지"
                                                             style="width:100%; height:100px; object-fit:cover; border-radius:8px;">
                                                    </div>
                                                    <div class="score_txt">
                                                        <div class="txt_box">
                                                            <div class="tit text-ellipsis">${content.title}</div>
                                                            <div class="date">
                                                                <fmt:parseDate value="${content.createdAt}"
                                                                               pattern="yyyy-MM-dd'T'HH:mm" var="pDate"
                                                                               type="both"/>
                                                                <fmt:formatDate value="${pDate}" pattern="yyyy-MM-dd"/>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="nodt_wrap only_txt" style="width:100%;">
                                                <div class="cont">
                                                    <div class="nodt_txt">등록된 콘텐츠가 없습니다.</div>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="card_wrap notice">
                            <div class="row history-head">
                                <div class="tit notice_tit">공지 및 설문</div>
                                <a href="/locker/notice/list">
                                    <img src="/img/ico_next_arrow.svg" alt="모두 보기">
                                </a>
                            </div>
                            <div class="card_item">
                                <div class="notice_wrap">
                                    <c:choose>
                                        <c:when test="${not empty notices}">
                                            <c:forEach var="notice" items="${notices}">
                                                <div class="notice_list"
                                                     onclick="location.href='/locker/detail?postId=${notice.postId}'"
                                                     style="cursor:pointer;">
                                                    <div class="notice_thum">
                                                        <img src="${not empty notice.imageUrl ? notice.imageUrl : '/img/sample03.png'}"
                                                             alt="공지 썸네일"
                                                             style="width:60px; height:60px; object-fit:cover; border-radius:8px;">
                                                    </div>
                                                    <div class="notice_item">
                                                        <div class="notice_txt">
                                                            <div class="notice_badge">공지</div>
                                                            <div class="tit text-ellipsis">${notice.title}</div>
                                                        </div>
                                                        <div class="date">
                                                            <fmt:parseDate value="${notice.createdAt}"
                                                                           pattern="yyyy-MM-dd'T'HH:mm" var="nDate"
                                                                           type="both"/>
                                                            <fmt:formatDate value="${nDate}" pattern="yyyy-MM-dd"/>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="nodt_wrap only_txt">
                                                <div class="cont">
                                                    <div class="nodt_txt">등록된 공지가 없습니다.</div>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <script src="/js/script.js"></script>
    <script>
        // 탭바 활성화 처리 (라커룸 탭 Active)
        $(document).ready(function () {
            $('.app-tabbar_item').removeClass('active'); // 기존 active 제거
            // 라커룸 링크를 찾아 active 추가 (href에 locker가 포함된 요소)
            $('.app-tabbar_item[href*="/locker/"]').addClass('active');

            // 이미지 변경 (active 아이콘으로)
            $('.app-tabbar_item.active img').attr('src', '/img/tabbar_locker_active.svg');
        });
    </script>

    <style>
        /* 가로 스크롤 숨김 처리 */
        .score_wrap::-webkit-scrollbar {
            display: none;
        }

        .text-ellipsis {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    </style>
</body>
</html>