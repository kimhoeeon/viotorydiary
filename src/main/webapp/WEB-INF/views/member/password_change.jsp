<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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

    <title>비밀번호 변경 | 승요일기</title>
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
                <div class="page-tit">비밀번호 변경</div>
            </div>

            <form id="pwChangeForm" action="/member/update/password" method="post">
                <div class="stack mt-24">

                    <div class="password_info">
                        <div class="password-info_item">
                            <div class="gu">기존 비밀번호</div>
                            <div class="nae">
                                <div class="input">
                                    <input type="password" name="currentPassword" id="currentPassword" placeholder="기존 비밀번호를 입력해 주세요." required>
                                </div>
                            </div>
                        </div>

                        <div class="password-info_item mt-24">
                            <div class="gu">변경할 비밀번호</div>
                            <div class="nae">
                                <div class="input">
                                    <input type="password" name="newPassword" id="newPassword" placeholder="변경할 비밀번호를 입력해 주세요." required>
                                </div>
                            </div>
                            <div class="nae">
                                <div class="input">
                                    <input type="password" id="confirmPassword" placeholder="변경할 비밀번호를 한번 더 입력해 주세요." required>
                                </div>
                                <div class="input-msg is-error" id="pwMatchMsg" style="display:none; margin-top:5px; font-size:12px;">
                                    비밀번호가 일치하지 않습니다.
                                </div>
                            </div>
                        </div>

                        <ul class="pre">
                            <li>* 영문 대/소문자, 숫자, 특수문자 중 2종 이상 포함하여 8~14자리 이내</li>
                            <li>* 비밀번호를 변경하면, 로그인된 모든 디바이스에서 자동으로 로그아웃돼요</li>
                        </ul>

                        <c:if test="${not empty error}">
                            <div class="login-message is-show is-error" style="margin-top: 20px; text-align: center;">${error}</div>
                        </c:if>
                    </div>

                </div>
            </form>
        </div>
    </div>

    <div class="bottom-action bottom-main">
        <button type="button" class="btn btn-primary" id="submitBtn" disabled onclick="submitForm()">변경 완료</button>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="/js/script.js"></script>
    <script>
        const currentPw = document.getElementById('currentPassword');
        const newPw = document.getElementById('newPassword');
        const confirmPw = document.getElementById('confirmPassword');
        const submitBtn = document.getElementById('submitBtn');
        const pwMatchMsg = document.getElementById('pwMatchMsg');

        // 입력 감지하여 버튼 활성화 및 유효성 검사
        [currentPw, newPw, confirmPw].forEach(el => {
            el.addEventListener('input', validateForm);
        });

        function validateForm() {
            const isCurrentFilled = currentPw.value.length > 0;
            const isNewFilled = newPw.value.length > 0;
            const isConfirmFilled = confirmPw.value.length > 0;

            // 비밀번호 일치 여부 확인
            if (isNewFilled && isConfirmFilled) {
                if (newPw.value !== confirmPw.value) {
                    pwMatchMsg.style.display = 'block';
                    submitBtn.disabled = true;
                    return;
                } else {
                    pwMatchMsg.style.display = 'none';
                }
            }

            // 모든 필드가 채워지고 일치하면 버튼 활성화
            if (isCurrentFilled && isNewFilled && isConfirmFilled && (newPw.value === confirmPw.value)) {
                submitBtn.disabled = false;
            } else {
                submitBtn.disabled = true;
            }
        }

        function submitForm() {
            // 정규식 검사 (영문, 숫자, 특수문자 중 2종 이상, 8~14자)
            const pw = newPw.value;
            const regExp = /^(?!((?:[A-Za-z]+)|(?:[~!@#$%^&*()_+=]+)|(?:[0-9]+))$)[A-Za-z\d~!@#$%^&*()_+=]{8,14}$/;

            if (!regExp.test(pw)) {
                alert('비밀번호는 8~14자이며, 영문/숫자/특수문자 중 2개 이상을 포함해야 합니다.');
                return;
            }

            document.getElementById('pwChangeForm').submit();
        }
    </script>
</body>
</html>