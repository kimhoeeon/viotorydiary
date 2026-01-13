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

    <link rel="icon" href="/img/favicon.png" />
    <link rel="shortcut icon" href="/img/favicon.png" />
    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">

    <title>마이페이지 | 승요일기</title>
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
                <div class="page-tit"><span id="userName">${member.nickname}</span> 님</div>
            </div>

            <div class="stack mt-24">

                <div class="my-info">

                    <div class="my-info_item">
                        <div class="tit">계정</div>
                        <ul>
                            <li>
                                <div class="gu">가입 수단</div>
                                <div class="nae">
                                    <c:choose>
                                        <c:when test="${empty member.socialProvider or member.socialProvider eq 'NONE'}">이메일</c:when>
                                        <c:otherwise>${member.socialProvider}</c:otherwise>
                                    </c:choose>
                                </div>
                            </li>
                            <li>
                                <div class="gu">아이디</div>
                                <div class="nae">${member.email}</div>
                            </li>
                            <li>
                                <a href="/member/update/password">
                                    비밀번호 변경
                                    <img src="/img/ico_next_arrow.svg" alt="이동" class="ml-auto">
                                </a>
                            </li>
                        </ul>
                    </div>

                    <div class="my-info_item">
                        <div class="tit">서비스 관리</div>
                        <ul>
                            <li>
                                <a href="/member/update/profile">
                                    프로필 설정
                                </a>
                            </li>
                            <li>
                                <a href="/member/team-setting">
                                    응원 팀 관리
                                    <span class="val" style="float: right; color: #999; font-size: 14px; margin-right: 24px;">
                                        ${not empty member.myTeamName ? member.myTeamName : ''}
                                    </span>
                                </a>
                            </li>
                            <li>
                                <a href="/member/follow/list">팔로우 관리</a>
                            </li>
                            <li>
                                <a href="/alarm/setting">알림 설정</a>
                            </li>
                            <li>
                                <a href="/member/review/list">댓글 관리</a>
                            </li>
                        </ul>
                    </div>

                    <div class="my-info_item">
                        <div class="tit">이용 안내</div>
                        <ul>
                            <li>
                                <a href="/policy/privacy">개인정보처리방침</a>
                            </li>
                            <li>
                                <a href="/policy/terms">이용약관</a>
                            </li>
                            <li>
                                <a href="/policy/location">위치정보 이용약관</a>
                            </li>
                        </ul>
                    </div>

                    <div class="my-info_item">
                        <div class="tit">기타</div>
                        <ul>
                            <li>
                                <a href="/member/logout" onclick="return confirm('로그아웃 하시겠습니까?');">로그아웃</a>
                            </li>
                            <li>
                                <a href="#" onclick="withdraw(); return false;">탈퇴하기</a>
                            </li>
                        </ul>
                    </div>
                </div>

            </div>
        </div>

        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <script src="/js/script.js"></script>
    <script>
        function withdraw() {
            if(confirm('정말 탈퇴하시겠습니까?\n탈퇴 시 모든 데이터가 삭제되며 복구할 수 없습니다.')) {
                alert('탈퇴 기능은 현재 준비 중입니다.');
                // location.href = '/member/withdraw';
            }
        }
    </script>
</body>
</html>