<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <title>닉네임 입력 | 승요일기</title>
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
                    <h1 class="login_title">닉네임을 입력해 주세요</h1>
                </div>
            </div>

            <div class="login-form gap-50">
                <div class="login-field_wrap gap-16">
                    <div class="login-field">
                        <div class="login-inputwrap">
                            <div class="auth_number mt-8">
                                <input class="login-input" id="nickname" name="nickname" type="text" autocomplete="nickname" placeholder="닉네임 (2~6자 한글 또는 영문)" required>

                                <div class="login-message" id="loginMessage" role="status" aria-live="polite"></div>

                                <span class="field-field-icon" id="certFailIcon" style="display:none;">
                                        <img src="/img/ico_field_fail.svg" alt="실패">
                                    </span>
                            </div>
                        </div>
                        <ul class="word">
                            <li>* 만 14세 이상 가입 가능합니다.</li>
                        </ul>
                    </div>
                </div>
                <div class="login-bottom">
                    <div class="login-actions">
                        <button class="join-btn btn-primary" id="termsNext" onclick="submitJoin()">
                            가입 완료
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>

    <script>
        /* * [비정상 접근 차단]
         */
        $(document).ready(function() {
            if (!sessionStorage.getItem('join_email')) {
                alert('잘못된 접근입니다.\n처음부터 다시 시도해주세요.', function() {
                    location.replace('/member/join');
                });
            }

            // 입력 시 에러 초기화 리스너 추가
            $('#nickname').on('input', function() {
                $('#loginMessage').removeClass('is-show is-error').text('');
                $('#certFailIcon').hide();
            });
        });

        /* * [가입 완료 처리]
         */
        function submitJoin() {
            // 1. 닉네임 입력 체크
            const nickname = $('#nickname').val().trim();
            const errorMsg = $('#loginMessage'); // 변경된 ID
            const failIcon = $('#certFailIcon'); // 변경된 ID

            // 닉네임 정규식 검사 (한글, 영문 대소문자 2~6자리)
            const nickRegex = /^[가-힣a-zA-Z]{2,6}$/;

            if (!nickname) {
                errorMsg.text('닉네임을 입력해주세요.').addClass('is-show is-error');
                failIcon.show();
                return;
            }

            if (!nickRegex.test(nickname)) {
                errorMsg.text('2~6자리의 한글 또는 영문만 가능합니다.').addClass('is-show is-error');
                failIcon.show();
                return;
            } else {
                errorMsg.removeClass('is-show is-error').text('');
                failIcon.hide();
            }

            // 전송할 데이터 준비 (세션 스토리지)
            const rawBirth = sessionStorage.getItem('join_birth') || '';
            const data = {
                email: sessionStorage.getItem('join_email'),
                password: sessionStorage.getItem('join_pw'),
                phoneNumber: sessionStorage.getItem('join_phone'),
                birthdate: rawBirth.replace(/\./g, '-'),
                nickname: nickname,
                gender: 'U',
                marketingAgree: sessionStorage.getItem('join_marketing') || 'N'
            };

            // 데이터 누락 확인
            if (!data.email || !data.password || !data.phoneNumber) {
                alert('필수 정보가 누락되었습니다.\n처음부터 다시 시도해주세요.', function() {
                    location.replace('/member/join');
                });
                return;
            }

            // 4. 중복 클릭 방지
            let isSubmitting = true;
            $('#termsNext').prop('disabled', true).text('처리중...');

            // 5. 서버 전송
            $.post('/member/join', data, function(res) {
                if (res === 'ok') {
                    // 성공 시
                    sessionStorage.clear();
                    location.replace('/member/join/complete?name=' + encodeURIComponent(data.nickname));
                } else {
                    // 실패 시
                    alert(res);
                    isSubmitting = false;
                    $('#termsNext').prop('disabled', false).text('가입 완료');
                }
            }).fail(function() {
                // 통신 오류 시
                alert('서버 통신 중 오류가 발생했습니다.');
                isSubmitting = false;
                $('#termsNext').prop('disabled', false).text('가입 완료');
            });
        }
    </script>
</body>
</html>