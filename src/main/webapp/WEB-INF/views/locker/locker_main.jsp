<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
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

    <title>라커룸 | 승요일기</title>

    <style>
        /* 가로 스크롤 전용 클래스 (CSS 충돌 해결) */
        .score_wrap.scroll-x {
            display: flex;             /* Grid -> Flex 변경 */
            overflow-x: auto;          /* 가로 스크롤 활성화 */
            gap: 12px;
            padding-bottom: 10px;
            grid-template-columns: none; /* 기존 Grid 속성 해제 */

            /* 스크롤바 숨김 */
            -ms-overflow-style: none;
            scrollbar-width: none;
        }
        .score_wrap.scroll-x::-webkit-scrollbar {
            display: none;
        }

        /* 텍스트 말줄임 */
        .text-ellipsis {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">
        <div class="top_wrap">
            <div class="main-top">
                <div class="main-title">
                    라커룸
                </div>

                <button class="noti-btn ${hasUnreadAlarm ? 'has-badge' : ''}" onclick="location.href='/alarm/list'">
                    <span class="noti-btn_icon" aria-hidden="true"><img src="/img/ico_noti.svg" alt="알림 아이콘"></span>
                    <span class="noti-dot" aria-hidden="true"></span>
                </button>
            </div>
        </div>

        <div class="app-main">
            <div class="page-main_wrap">

                <div class="history">
                    <div class="history-list">

                        <div class="card_wrap ev">
                            <div class="card_item">
                                <div class="row history-head">
                                    <div class="tit ev_tit">야구 200% 즐기기</div>
                                </div>

                                <c:choose>
                                    <c:when test="${not empty events}">
                                        <c:forEach var="event" items="${events}">
                                            <c:choose>
                                                <c:when test="${event.linkType eq 'EXTERNAL'}">
                                                    <div class="img" onclick="window.open('${event.linkUrl}')" style="cursor:pointer;">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="img" onclick="location.href='/locker/event/detail?eventId=${event.eventId}'" style="cursor:pointer;">
                                                </c:otherwise>
                                            </c:choose>
                                                <img src="${not empty event.imageUrl ? event.imageUrl : '/img/card_sample02.jpg'}"
                                                     alt="이벤트 배너" style="border-radius: 12px;">
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="nodt_wrap only_txt">
                                            <div class="cont"><div class="nodt_txt">진행 중인 이벤트가 없습니다.</div></div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="card_wrap content">
                            <div class="card_item">
                                <div class="row history-head">
                                    <div class="tit content_tit">우리 팀 추천 콘텐츠</div>
                                    <a href="/locker/content/list"><img src="/img/ico_next_arrow.svg" alt="모두 보기"></a>
                                </div>

                                <c:choose>
                                    <c:when test="${not empty contents}">
                                        <div class="score_wrap scroll-x">
                                            <c:forEach var="content" items="${contents}">
                                                <div class="score_list"
                                                     onclick="location.href='/locker/content/detail?contentId=${content.contentId}'"
                                                     style="min-width:140px; cursor:pointer;">
                                                    <div class="img">
                                                        <c:choose>
                                                            <%-- 1. 유효한 이미지 URL 체크 --%>
                                                            <c:when test="${not empty content.imageUrl and (fn:startsWith(content.imageUrl, 'http') or fn:startsWith(content.imageUrl, '/'))}">
                                                                <img src="${content.imageUrl}"
                                                                     alt="콘텐츠 이미지"
                                                                     style="width:100%; height:100px; object-fit:cover;"
                                                                     onerror="this.src='/img/card_defalut.svg'">
                                                            </c:when>
                                                            <%-- 2. 기본 이미지 --%>
                                                            <c:otherwise>
                                                                <img src="/img/card_defalut.svg"
                                                                     alt="기본 콘텐츠 이미지"
                                                                     style="width:100%; height:100px; object-fit:cover;">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="score_txt">
                                                        <div class="txt_box">
                                                            <div class="tit text-ellipsis">${content.title}</div>
                                                            <div class="date">
                                                                <fmt:parseDate value="${content.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="pDate" type="both"/>
                                                                <fmt:formatDate value="${pDate}" pattern="yyyy-MM-dd"/>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="nodt_wrap only_txt">
                                            <div class="cont"><div class="nodt_txt">등록된 콘텐츠가 없습니다.</div></div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="card_wrap notice">
                            <div class="card_item">
                                <div class="row history-head">
                                    <div class="tit notice_tit">공지 및 설문</div>
                                    <a href="/locker/notice/list">
                                        <img src="/img/ico_next_arrow.svg" alt="모두 보기">
                                    </a>
                                </div>

                                <div class="notice_wrap">
                                    <c:choose>
                                        <c:when test="${not empty notices}">
                                            <c:forEach var="notice" items="${notices}">
                                                <div class="notice_list" onclick="location.href='/locker/notice/detail?noticeId=${notice.noticeId}'" style="cursor:pointer;">
                                                    <div class="notice_thum">
                                                        <img src="${not empty notice.imageUrl ? notice.imageUrl : '/img/card_defalut.svg'}" alt="공지 썸네일">
                                                    </div>
                                                    <div class="notice_item">
                                                        <div class="notice_txt">
                                                            <div class="notice_badge ${notice.category eq 'SURVEY' ? 'quest_badge' : ''}">
                                                                ${notice.category eq 'SURVEY' ? '설문' : '공지'}
                                                            </div>
                                                            <div class="tit text-ellipsis">${notice.title}</div>
                                                        </div>
                                                        <div class="date">
                                                            <fmt:parseDate value="${notice.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="nDate" type="both"/>
                                                            <fmt:formatDate value="${nDate}" pattern="yyyy-MM-dd"/>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="nodt_wrap only_txt">
                                                <div class="cont"><div class="nodt_txt">등록된 공지가 없습니다.</div></div>
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

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
</body>
</html>