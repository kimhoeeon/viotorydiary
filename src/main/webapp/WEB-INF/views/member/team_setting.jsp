<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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

    <title>팀 설정 | 승요일기</title>

    <style>
        /* 동적 이미지 스타일링 (퍼블리싱 .team 클래스 크기에 맞춤) */
        .team-logo-box {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        /* 로고 이미지가 버튼 안에 꽉 차면서 비율 유지 */
        .team-logo-box img {
            width: 48px; /* base.css .team 사이즈 참조 */
            height: 48px;
            object-fit: contain;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
</head>

<body>
    <div class="app">

        <header class="app-header">
            <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
                <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
            </button>
        </header>

        <div class="app-main column">

            <div class="app-tit">
                <div class="page-tit">응원 팀을 선택해 주세요</div>
            </div>

            <ul class="comment">
                <li>응원팀을 바꾸면, 기존 직관일기는 그대로 남지만,</li>
                <li>승률/전적등 통계는 초기화돼요.</li>
            </ul>

            <div class="stack mt-24">
                <form id="teamForm" action="/member/team-setting" method="post">
                    <input type="hidden" name="teamCode" id="teamCode" value="${loginMember.myTeamCode}">

                    <div class="team_info">
                        <c:forEach var="item" items="${teamList}">
                            <button type="button" class="team_info-btn" data-code="${item.teamCode}">
                                <div class="team-logo-box">
                                    <c:choose>
                                        <c:when test="${not empty item.logoImageUrl}">
                                            <img src="${item.logoImageUrl}" alt="${item.nameKr}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="/img/logo/default.svg" alt="${item.nameKr}">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </button>
                        </c:forEach>
                    </div>
                </form>
            </div>

            <div class="one-time">
                <img src="/img/ico_not_mark_blue.svg" alt="주의 아이콘">응원 팀은 월 1회 변경 가능해요
            </div>
        </div>
    </div>

    <div class="bottom-action bottom-main">
        <button type="button" class="btn btn-primary" id="btnNext" onclick="trySubmitTeam()" disabled>
            <c:choose>
                <c:when test="${empty loginMember.myTeamCode or loginMember.myTeamCode eq 'NONE'}">
                    설정하기
                </c:when>
                <c:otherwise>
                    변경하기
                </c:otherwise>
            </c:choose>
        </button>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const teamButtons = document.querySelectorAll('.team_info-btn');
            const teamInput = document.getElementById('teamCode');
            const submitBtn = document.getElementById('btnNext');
            const currentTeamCode = "${loginMember.myTeamCode}";

            // 1. 초기 상태 설정 (이미 선택된 팀이 있다면 활성화)
            if (currentTeamCode && currentTeamCode !== 'NONE') {
                teamButtons.forEach(btn => {
                    if (btn.dataset.code === currentTeamCode) {
                        btn.classList.add('is-select'); // HTML 클래스명 반영
                        submitBtn.disabled = false;
                    }
                });
            }

            // 2. 버튼 클릭 이벤트
            teamButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    // 모든 버튼 선택 해제
                    teamButtons.forEach(b => b.classList.remove('is-select'));

                    // 현재 버튼 선택
                    this.classList.add('is-select');

                    // 값 할당
                    teamInput.value = this.dataset.code;

                    // 버튼 활성화
                    submitBtn.disabled = false;
                });
            });
        });

        function trySubmitTeam() {
            const teamCode = document.getElementById('teamCode').value;
            if (!teamCode) {
                alert('팀을 선택해주세요.');
                return;
            }

            const currentCode = "${loginMember.myTeamCode}";

            // 팀 변경 시 확인 팝업 (최초 설정이 아니고, 팀이 변경된 경우)
            if (currentCode && currentCode !== 'NONE' && currentCode !== teamCode) {
                 showPopup('confirm', '응원 팀을 변경하시겠어요?<br/>응원 팀 변경은 월 1회만 가능해요.', function() {
                    document.getElementById('teamForm').submit();
                });
            } else {
                // 바로 변경/설정
                document.getElementById('teamForm').submit();
            }
        }
    </script>
</body>
</html>