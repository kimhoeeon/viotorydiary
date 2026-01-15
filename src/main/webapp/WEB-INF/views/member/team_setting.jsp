<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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

    <title>응원팀 설정 | 승요일기</title>

    <style>
        /* 선택된 팀 스타일 (퍼블리싱 css에 없다면 추가 필요) */
        .team_info-btn.active {
            border: 2px solid #FF4D4D; /* 포인트 컬러 예시 */
            border-radius: 50%;
            background-color: rgba(255, 77, 77, 0.05);
        }
    </style>
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

            <form id="teamForm" action="/member/team-setting" method="post">
                <input type="hidden" name="teamCode" id="teamCode" value="${sessionScope.loginMember.myTeamCode}">

                <div class="team_select">
                    <ul class="team-list">
                        <li>
                            <button type="button" class="team_info-btn" data-code="LG">
                                <div class="lg team"></div>
                                <span class="blind">LG 트윈스</span>
                            </button>
                        </li>
                        <li>
                            <button type="button" class="team_info-btn" data-code="KT">
                                <div class="kt team"></div>
                                <span class="blind">KT 위즈</span>
                            </button>
                        </li>
                        <li>
                            <button type="button" class="team_info-btn" data-code="SSG">
                                <div class="ssg team"></div>
                                <span class="blind">SSG 랜더스</span>
                            </button>
                        </li>
                        <li>
                            <button type="button" class="team_info-btn" data-code="NC">
                                <div class="nc team"></div>
                                <span class="blind">NC 다이노스</span>
                            </button>
                        </li>
                        <li>
                            <button type="button" class="team_info-btn" data-code="DOOSAN">
                                <div class="doosan team"></div>
                                <span class="blind">두산 베어스</span>
                            </button>
                        </li>
                        <li>
                            <button type="button" class="team_info-btn" data-code="KIA">
                                <div class="kia team"></div>
                                <span class="blind">KIA 타이거즈</span>
                            </button>
                        </li>
                        <li>
                            <button type="button" class="team_info-btn" data-code="LOTTE">
                                <div class="lotte team"></div>
                                <span class="blind">롯데 자이언츠</span>
                            </button>
                        </li>
                        <li>
                            <button type="button" class="team_info-btn" data-code="SAMSUNG">
                                <div class="samsung team"></div>
                                <span class="blind">삼성 라이온즈</span>
                            </button>
                        </li>
                        <li>
                            <button type="button" class="team_info-btn" data-code="HANWHA">
                                <div class="hanwha team"></div>
                                <span class="blind">한화 이글스</span>
                            </button>
                        </li>
                        <li>
                            <button type="button" class="team_info-btn" data-code="KIWOOM">
                                <div class="kiwoom team"></div>
                                <span class="blind">키움 히어로즈</span>
                            </button>
                        </li>
                    </ul>
                </div>
            </form>

            <div class="one-time">
                <img src="/img/ico_not_mark_blue.svg" alt="주의 아이콘">응원 팀은 월 1회 변경 가능해요
            </div>

            <c:if test="${not empty error}">
                <script>
                    window.addEventListener('load', function() {
                        showPopup('alert', '${error}');
                    });
                </script>
            </c:if>
        </div>
    </div>

    <div class="bottom-action bottom-main">
        <button type="button" class="btn btn-primary" id="btnNext" disabled onclick="trySubmitTeam()">
            변경하기
        </button>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const teamButtons = document.querySelectorAll('.team_info-btn');
            const teamInput = document.getElementById('teamCode');
            const submitBtn = document.getElementById('btnNext');
            const currentTeamCode = teamInput.value; // 현재 설정된 팀 코드

            // 1. 초기 로드 시 현재 팀 선택 상태 표시
            if (currentTeamCode && currentTeamCode !== 'NONE') {
                teamButtons.forEach(btn => {
                    if (btn.dataset.code === currentTeamCode) {
                        btn.classList.add('active');
                    }
                });
                // 현재 팀이 선택되어 있어도 변경 버튼은 비활성 (변경 사항이 없으므로)
                // 만약 바로 활성화하고 싶다면 아래 주석 해제
                // submitBtn.disabled = false;
            }

            // 2. 팀 선택 클릭 이벤트
            teamButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    // 모든 버튼 active 제거
                    teamButtons.forEach(b => b.classList.remove('active'));

                    // 현재 버튼 active 추가
                    this.classList.add('active');

                    // 히든 인풋 값 업데이트
                    const selectedCode = this.dataset.code;
                    teamInput.value = selectedCode;

                    // 변경 사항이 생겼으므로 버튼 활성화
                    // (기존 팀과 같아도 활성화할지, 다를 때만 할지 정책에 따름. 여기선 무조건 활성화)
                    submitBtn.disabled = false;
                });
            });
        });

        function trySubmitTeam() {
            const teamCode = document.getElementById('teamCode').value;
            if (!teamCode) return;

            // 변경 확인 팝업
            showPopup('confirm', '응원 팀을 변경하시겠어요?<br />응원 팀 변경은 월 1회만 가능해요.', function() {
                document.getElementById('teamForm').submit();
            });
            document.getElementById('popupConfirmBtn').innerText = '변경하기';
        }
    </script>
</body>
</html>