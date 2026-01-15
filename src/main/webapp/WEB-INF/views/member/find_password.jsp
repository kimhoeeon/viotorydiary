<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
    <link rel="icon" href="/img/favicon.png" />
    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">
    <title>비밀번호 찾기 | 승요일기</title>
</head>
<body class="page-login">
    <header class="app-header">
        <button class="app-header_btn app-header_back" type="button" onclick="history.back()">
            <img src="/img/ico_back_arrow.svg" alt="뒤로가기">
        </button>
    </header>

    <div class="page-login_wrap">
        <div class="login-card">
            <div class="login">
                <div class="tit">비밀번호가 기억나지 않나요?</div>
                <div class="login-txt">
                    <h1 class="login_title">가입 시 사용한 정보를 입력해 주세요</h1>
                </div>
            </div>

            <form class="login-form gap-50" id="resetPwForm" action="/member/find-password/reset" method="post">
                <div class="login-field_wrap">
                    <div class="login-field">
                        <div class="login-inputwrap">
                            <input class="login-input" id="userName" name="userName" type="text" placeholder="이름을 입력해주세요" required/>

                            <div class="phone mt-16">
                                <input class="login-input pr-8" id="number" name="phoneNumber" type="tel" placeholder="휴대폰 번호를 입력해주세요 (- 없이)" required/>
                                <button type="button" class="phone-cert wpx-80" id="sendBtn" onclick="sendSms()">
                                    인증하기
                                </button>
                            </div>

                            <div class="auth_number mt-8" id="authBox" style="display:none;">
                                <input class="login-input" id="number_cert" name="authCode" type="number" placeholder="인증번호를 입력해주세요" required/>
                                <span class="field-check-icon" id="certCheckIcon">
                                        <img src="/img/ico_field_check.svg" alt="입력 완료">
                                    </span>
                            </div>

                            <c:if test="${not empty error}">
                                <div class="login-message is-show is-error" style="margin-top: 10px;">${error}</div>
                            </c:if>

                            <button class="login-btn btn-primary mt-16" type="submit" id="password_reset">
                                비밀번호 초기화
                            </button>
                        </div>
                    </div>
                </div>
                <div class="login-bottom">
                    <div class="login-options mt-24 center">
                        <p>휴대폰 번호가 변경되었나요?</p>
                        <a class="login-link" href="#">관리자 문의</a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script>
        // SMS 발송 요청
        function sendSms() {
            const phone = $('#number').val();
            if(phone.length < 10) { alert('올바른 휴대폰 번호를 입력해주세요.'); return; }

            $.post('/member/send-sms', { phoneNumber: phone }, function(res) {
                if(res === 'ok') {
                    alert('인증번호가 발송되었습니다.');
                    $('#authBox').show();
                    $('#sendBtn').text('재전송');
                } else {
                    alert('발송 실패: ' + res);
                }
            }).fail(function() {
                alert('서버 통신 오류가 발생했습니다.');
            });
        }

        // 인증번호 입력 감지 (UI 효과)
        $('#number_cert').on('input', function() {
            if(this.value.length >= 4) {
                $('#certCheckIcon').addClass('is-show');
            } else {
                $('#certCheckIcon').removeClass('is-show');
            }
        });
    </script>
</body>
</html>