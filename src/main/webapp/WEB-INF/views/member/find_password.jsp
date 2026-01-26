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
            </div>

            <form class="login-form" action="/member/find-password/reset" method="post" id="resetForm">
                <div class="login-field_wrap">

                    <div class="login-field">
                        <div class="gu">아이디(이메일)</div>
                        <div class="login-inputwrap">
                            <input class="login-input" id="memberId" name="memberId" type="email"
                                   placeholder="아이디(이메일)을 입력해주세요" required value="${param.memberId}">
                        </div>
                    </div>

                    <div class="login-field">
                        <div class="gu">휴대폰 번호</div>
                        <div class="login-inputwrap phone-field">
                            <div class="phone">
                                <input class="login-input" id="phoneNumber" name="phoneNumber" type="tel"
                                       maxlength="11"
                                       oninput="this.value = this.value.replace(/[^0-9]/g, '').slice(0, 11);"
                                       inputmode="numeric" autocomplete="tel" placeholder="휴대폰 번호를 입력해주세요"
                                       required value="${param.phoneNumber}">
                                <button type="button" class="phone-cert wpx-80" id="sendBtn" onclick="sendSms()">
                                    인증하기
                                </button>
                            </div>
                        </div>

                        <div class="auth_number mt-8" id="authBox" style="display:none;">
                            <div class="login-inputwrap">
                                <input class="login-input" id="authCode" name="authCode" type="number"
                                       inputmode="numeric" autocomplete="one-time-code" placeholder="인증번호를 입력해주세요" required>

                                <span class="field-check-icon" id="certCheckIcon" style="display:none;">
                                    <img src="/img/ico_field_check.svg" alt="입력 완료">
                                </span>
                            </div>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="login-message is-show is-error mt-8">
                                ${error}
                            </div>
                        </c:if>

                        <button class="login-btn btn-primary mt-16" type="submit" id="submitBtn">
                            비밀번호 초기화
                        </button>
                    </div>
                </div>

                <div class="login-bottom">
                    <div class="login-options mt-24 center">
                        <p>휴대폰 번호가 변경되었나요?</p>
                        <a class="login-link" href="#" onclick="alert('관리자에게 문의해주세요.'); return false;">관리자 문의</a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script>
        // 1. SMS 인증번호 발송
        function sendSms() {
            const memberId = $('#memberId').val().trim();
            const phone = $('#phoneNumber').val().trim();

            if(!memberId) { alert('아이디(이메일)을 입력해주세요.'); return; }
            if(phone.length < 10) { alert('올바른 휴대폰 번호를 입력해주세요.'); return; }

            $('#sendBtn').prop('disabled', true).text('전송중');

            $.post('/member/send-sms', {
                memberId: memberId,
                phoneNumber: phone,
                type: 'FIND_PW'
            }, function(res) {
                if(res.trim() !== 'fail') {
                    alert('인증번호가 발송되었습니다.');

                    // [수정] 재전송 시 입력칸 초기화
                    $('#authCode').val('');
                    $('#certCheckIcon').hide();

                    $('#authBox').slideDown();
                    $('#sendBtn').text('재전송').prop('disabled', false);
                    $('#authCode').focus();
                } else {
                    alert('일치하는 회원 정보가 없거나 발송에 실패했습니다.');
                    $('#sendBtn').text('인증하기').prop('disabled', false);
                }
            }).fail(function() {
                alert('서버 통신 오류가 발생했습니다.');
                $('#sendBtn').text('인증하기').prop('disabled', false);
            });
        }

        // 2. 인증번호 입력 감지
        $('#authCode').on('input', function() {
            if (this.value.length >= 4) {
                $('#certCheckIcon').show();
            } else {
                $('#certCheckIcon').hide();
            }
        });

        // 3. 폼 제출 검증
        $('#resetForm').on('submit', function(e) {
            if ($('#authBox').css('display') === 'none') {
                e.preventDefault();
                alert('휴대폰 인증을 진행해주세요.');
                return false;
            }
            if ($('#authCode').val().length < 4) {
                e.preventDefault();
                alert('인증번호를 올바르게 입력해주세요.');
                return false;
            }
        });
    </script>
</body>
</html>