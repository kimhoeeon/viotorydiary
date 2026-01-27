<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <meta property="og:title" content="${diary.nickname}님의 직관 일기">
    <meta property="og:description" content="${diary.oneLineComment}">
    <meta property="og:image" content="${not empty diary.imageUrl ? diary.imageUrl : '/img/logo.png'}">

    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">
    <title>직관일기 공유 | 승요일기</title>

    <style>
        /* 상세 페이지 스타일 가져옴 */
        .diary-header-info {
            border-bottom: 1px solid #f0f0f0;
            padding-bottom: 16px;
            margin-bottom: 16px;
        }
        .one-line-box .label { font-size: 13px; color: #999; margin-bottom: 6px; display: block; }
        .one-line-box .text { font-size: 18px; font-weight: 700; color: #111; line-height: 1.4; }

        .hero-box { margin-top: 12px; display: flex; align-items: center; gap: 8px; }
        .hero-badge {
            background: #e8f3ff; color: #2c7fff;
            font-size: 12px; font-weight: 700;
            padding: 4px 8px; border-radius: 6px;
        }
        .hero-name { font-size: 16px; font-weight: 600; color: #333; }
    </style>
</head>

<body>
    <div class="app">
        <header class="app-header" style="justify-content:center;">
            <div class="page-tit" style="font-weight:700;">승요일기</div>
        </header>

        <div class="app-main">
            <div class="card_wrap play_wrap gap-16">
                <div class="card_item pt-16 pb-16">
                    <div class="row align-center">
                        <div class="profile-img"
                             style="width:40px; height:40px; border-radius:50%; overflow:hidden; margin-right:10px; border:1px solid #eee;">
                            <img src="${not empty diary.profileImage ? diary.profileImage : '/img/ico_user.svg'}"
                                 style="width:100%; height:100%; object-fit:cover;">
                        </div>
                        <div class="info">
                            <div class="nickname" style="font-weight:bold;">${diary.nickname}</div>
                            <div class="date" style="font-size:12px; color:#888;">
                                <fmt:parseDate value="${diary.gameDate}" pattern="yyyy-MM-dd" var="pDate" type="date"/>
                                <fmt:formatDate value="${pDate}" pattern="yyyy.MM.dd"/> 직관
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card_item">
                    <div class="play-result_wrap">
                        <div class="play-result_head">
                            <div class="tit">직관한 경기</div>
                            <div class="txt">${diary.stadiumName}</div>
                        </div>
                        <div class="play-result_body">
                            <div class="team_score">
                                <div class="team">
                                    <div class="logo"><img src="/img/logo/logo_${fn:toLowerCase(diary.homeTeamCode)}.svg" alt=""></div>
                                    <div class="name">${diary.homeTeamName}</div>
                                </div>
                                <div class="score">
                                    <div class="num ${diary.scoreHome > diary.scoreAway ? 'win' : ''}">${diary.scoreHome}</div>
                                    <div class="vs">VS</div>
                                    <div class="num ${diary.scoreAway > diary.scoreHome ? 'win' : ''}">${diary.scoreAway}</div>
                                </div>
                                <div class="team">
                                    <div class="logo"><img src="/img/logo/logo_${fn:toLowerCase(diary.awayTeamCode)}.svg" alt=""></div>
                                    <div class="name">${diary.awayTeamName}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card_item">
                    <div class="diary-header-info">
                        <div class="one-line-box">
                            <span class="label">한줄평</span>
                            <div class="text">"${diary.oneLineComment}"</div>
                        </div>

                        <c:if test="${not empty diary.heroName}">
                            <div class="hero-box">
                                <span class="hero-badge">🏆 My Hero</span>
                                <span class="hero-name">${diary.heroName}</span>
                            </div>
                        </c:if>
                    </div>
                    <c:if test="${not empty diary.imageUrl}">
                        <div class="diary-img" style="margin-bottom:16px;">
                            <img src="${diary.imageUrl}" style="width:100%; border-radius:8px; border: 1px solid #eee;">
                        </div>
                    </c:if>
                    <div class="diary-txt" style="white-space:pre-line; line-height:1.5; font-size:15px; color:#333;">${diary.content}</div>
                </div>
            </div>
        </div>

        <div class="bottom-action">
            <button type="button" class="btn btn-primary" onclick="location.href='/member/login'">
                나도 승요일기 쓰러가기
            </button>
        </div>
    </div>
</body>
</html>