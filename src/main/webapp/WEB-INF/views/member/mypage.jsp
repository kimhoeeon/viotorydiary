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

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

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

            <%--<div class="profile-area" style="text-align:center; margin-top:24px; margin-bottom:12px;">
                <div class="img-box" style="width:50px; height:50px; margin:0 auto; border-radius:50%; overflow:hidden; border:1px solid #eee;">
                    <img src="${not empty member.profileImage ? member.profileImage : '/img/ico_user.svg'}"
                         alt="프로필 이미지"
                         onclick="location.href='/member/update/profile'"
                         style="width:100%; height:100%; object-fit:cover; cursor:pointer; display:block;">
                </div>
            </div>--%>

            <div class="app-tit">
                <div class="page-tit">
                    <span id="userName">
                        <a href="javascript:location.href='/member/update/profile'">${member.nickname}</a>
                    </span> 님
                </div>
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
                                <a href="/member/update/password">비밀번호 변경</a>
                            </li>
                        </ul>
                    </div>

                    <div class="my-info_item">
                        <div class="tit">서비스 관리</div>
                        <ul>
                            <li>
                                <a href="/member/update/profile">프로필 설정</a>
                            </li>
                            <li>
                                <a href="/member/team-setting">응원 팀 관리</a>
                            </li>
                            <li>
                                <a href="/member/follow/list">팔로우 관리</a>
                            </li>
                            <li>
                                <a href="/member/alarm/setting">알림 설정</a>
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
                                <a href="javascript:void(0);" onclick="openLogoutPopup()">로그아웃</a>
                            </li>
                            <li>
                                <a href="javascript:void(0);" onclick="openWithdrawPopup()">탈퇴하기</a>
                            </li>
                        </ul>
                    </div>
                </div>

            </div>
        </div>

        <%@ include file="../include/tabbar.jsp" %>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="/js/script.js"></script>
    <script>
        // 로그아웃 팝업
        function openLogoutPopup() {
            showPopup('confirm', '로그아웃 하시겠어요?<br />로그아웃하면 서비스를 이용할 수 없어요.', function() {
                location.href = '/member/logout';
            });
            // 확인 버튼 텍스트를 '로그아웃'으로 바꾸고 싶다면 추가 스크립트 작성 가능
            document.getElementById('popupConfirmBtn').innerText = '로그아웃';
        }

        // 회원탈퇴 팝업
        function openWithdrawPopup() {
            showPopup('confirm', '정말 탈퇴하시겠습니까?<br />모든 데이터가 삭제되며 복구할 수 없습니다.', function() {
                location.href = '/member/withdraw';
            });
            document.getElementById('popupConfirmBtn').innerText = '탈퇴하기';
        }
    </script>
</body>
</html>