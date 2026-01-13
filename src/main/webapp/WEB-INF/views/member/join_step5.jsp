<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
    <link rel="stylesheet" href="/css/reset.css">
    <link rel="stylesheet" href="/css/font.css">
    <link rel="stylesheet" href="/css/base.css">
    <link rel="stylesheet" href="/css/style.css">
    <title>휴대폰 인증 | 승요일기</title>
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
                <img src="/img/ico_check.svg" alt="체크이미지">
                <div class="login-txt">
                    <h1 class="login_title">휴대폰 번호를 입력해 주세요</h1>
                </div>
            </div>

            <div class="login-form gap-50">
                <div class="login-field_wrap gap-16">
                    <div class="login-field">
                        <div class="login-inputwrap">
                            <div class="phone">
                                <input class="login-input pr-8" id="number" type="tel" placeholder="휴대폰 번호를 입력해주세요 (- 제외)" required>
                                <button class="phone-cert wpx-80" id="sendBtn" onclick="sendSms()">
                                    인증하기
                                </button>
                            </div>
                            <div class="auth_number mt-8" id="authBox" style="display:none;">
                                <input class="login-input" id="number_cert" type="number" placeholder="인증번호를 입력해주세요" required>

                                <span class="field-check-icon" id="certCheckIcon">
                                        <img src="/img/ico_field_check.svg" alt="입력 완료">
                                    </span>
                                <span class="field-field-icon" id="certFailIcon">
                                        <img src="/img/ico_field_fail.svg" alt="실패">
                                    </span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="login-bottom">
                    <div class="login-actions">
                        <button class="join-btn btn-primary" id="termsNext" disabled onclick="verifySms()">
                            다음
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script>
        function sendSms() {
            const phone = $('#number').val();
            if(phone.length < 10) { alert('올바른 번호를 입력해주세요.'); return; }

            $.post('/member/send-sms', { phoneNumber: phone }, function(res) {
                if(res === 'ok') {
                    alert('인증번호가 발송되었습니다.');
                    $('#authBox').show();
                    $('#sendBtn').text('재전송');
                } else {
                    alert('발송 실패: ' + res);
                }
            });
        }

        function verifySms() {
            const phone = $('#number').val();
            const code = $('#number_cert').val();

            $.post('/member/verify-sms', { phoneNumber: phone, authCode: code }, function(res) {
                if(res === 'ok') {
                    sessionStorage.setItem('join_phone', phone);
                    location.href = '/member/join/step6';
                } else {
                    alert('인증번호가 일치하지 않습니다.');
                    $('#certFailIcon').addClass('is-show');
                }
            });
        }

        // 인증번호 입력 시 다음 버튼 활성화 (script.js와 별개로 동작)
        $('#number_cert').on('input', function() {
            if(this.value.length >= 4) $('#termsNext').prop('disabled', false);
            else $('#termsNext').prop('disabled', true);
        });
    </script>
</body>
</html>