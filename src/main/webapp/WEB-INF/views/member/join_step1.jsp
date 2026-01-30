<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
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

    <title>약관 동의 | 승요일기</title>

    <script src="https://cdn.jsdelivr.net/npm/@nolraunsoft/appify-sdk@latest/dist/appify-sdk.min.js"></script>
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
                    <h1 class="login_title">서비스 이용을 위한 동의 안내</h1>
                    <p class="login_desc">서비스 이용에 꼭 필요한 사항입니다.<br />정책 및 약관을 클릭해 모든 내용을 확인해 주세요.</p>
                </div>
            </div>

            <div class="login-form gap-50">
                <div class="agree-field_wrap">
                    <div class="agree-field">
                        <div class="terms-all">
                            <label class="terms-check">
                                <input type="checkbox" id="agreeAll">
                                <span class="terms-check_label">모두 동의합니다</span>
                                <span class="terms-check_box" aria-hidden="true"></span>
                            </label>
                        </div>
                        <ul class="terms-list">
                            <li class="terms-item">
                                <label class="terms-check">
                                    <input type="checkbox" class="agree-item" data-required="true" id="agreeService">
                                    <span class="terms-check_label">[필수] 서비스 이용약관 동의</span>
                                    <span class="terms-check_box" aria-hidden="true"></span>
                                </label>
                            </li>
                            <li class="terms-item">
                                <label class="terms-check">
                                    <input type="checkbox" class="agree-item" data-required="true" id="agreePrivacy">
                                    <span class="terms-check_label">[필수] 개인정보 처리방침 동의</span>
                                    <span class="terms-check_box" aria-hidden="true"></span>
                                </label>
                            </li>
                            <li class="terms-item">
                                <label class="terms-check">
                                    <input type="checkbox" class="agree-item" data-required="false" id="agreeMarketing">
                                    <span class="terms-check_label">[선택] 혜택 알림·마케팅 수신 동의</span>
                                    <span class="terms-check_box" aria-hidden="true"></span>
                                </label>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="login-bottom">
                    <div class="login-actions">
                        <button class="join-btn btn-primary" id="termsNext" disabled onclick="goNext()">
                            다음
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        function goNext() {
            // 필수 약관은 버튼이 활성화되었다면 이미 체크된 것임
            // 선택 약관 체크 여부 확인
            const isMarketingAgreed = document.getElementById('agreeMarketing').checked;

            // 데이터 저장
            sessionStorage.setItem('join_agree', 'Y');
            sessionStorage.setItem('join_marketing', isMarketingAgreed ? 'Y' : 'N'); // [추가]

            location.href = '/member/join/step2';
        }
    </script>
</body>
</html>