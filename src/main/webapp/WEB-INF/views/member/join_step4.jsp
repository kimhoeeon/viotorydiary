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

    <title>생년월일 입력 | 승요일기</title>

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
                    <h1 class="login_title">생년월일을 입력해 주세요</h1>
                </div>
            </div>

            <div class="login-form gap-50">
                <div class="login-field_wrap">
                    <div class="dob-wrap">
                        <div class="dob-picker" id="picker">
                            <div class="dob-picker_value" id="dobValue" style="color: #999;">YYYY.MM.DD</div>
                        </div>
                        <input type="hidden" id="birthdateInput">
                    </div>
                    <ul class="word">
                        <li>* 만 14세 이상 가입 가능합니다.</li>
                    </ul>
                </div>
                <div class="login-bottom">
                    <button class="join-btn btn-primary" id="nextBtn" disabled onclick="goNext()">
                        다음
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="dob-wrap_pop" id="dobPopup">
        <div class="dob-pop-dim"></div>
        <div class="dob-pop-inner">
            <div class="dob-pop-picker">
                <div class="dob-pop-wheel" data-type="year"></div>
                <div class="dob-pop-wheel" data-type="month"></div>
                <div class="dob-pop-wheel" data-type="day"></div>
            </div>
            <div class="dob-pop-footer">
                <button type="button" class="btn-cancel" id="pickerCancel">취소</button>
                <button type="button" class="btn-apply" id="pickerApply">적용</button>
            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>
    <script src="/js/date-picker.js"></script>
    <script src="/js/app_interface.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const applyBtn = document.getElementById('pickerApply');
            const cancelBtn = document.getElementById('pickerCancel');
            const popup = document.getElementById('dobPopup');
            const dobValueDiv = document.getElementById('dobValue');
            const hiddenInput = document.getElementById('birthdateInput');
            const nextBtn = document.getElementById('nextBtn');

            // 1. [적용] 버튼 클릭 시 선택된 날짜 처리
            if (applyBtn) {
                applyBtn.addEventListener('click', () => {
                    // date-picker.js에서 선택된 값 추출 (클래스 기반)
                    const year = document.querySelector('.dob-pop-wheel[data-type="year"] .is-selected')?.dataset.value;
                    const month = document.querySelector('.dob-pop-wheel[data-type="month"] .is-selected')?.dataset.value;
                    const day = document.querySelector('.dob-pop-wheel[data-type="day"] .is-selected')?.dataset.value;

                    if (year && month && day) {
                        // 화면 표시용 (예: 2000.01.01)
                        const fullDateStr = year + '.' + month.padStart(2, '0') + '.' + day.padStart(2, '0');
                        dobValueDiv.textContent = fullDateStr;
                        dobValueDiv.style.color = '#000'; // 입력 완료 색상

                        // 저장용 값 설정 (YYYY-MM-DD)
                        hiddenInput.value = year + '-' + month.padStart(2, '0') + '-' + day.padStart(2, '0');

                        // '다음' 버튼 활성화
                        nextBtn.disabled = false;

                        // 팝업 닫기
                        popup.classList.remove('is-open');
                    }
                });
            }

            // 2. [취소] 및 딤 영역 클릭 시 닫기
            if (cancelBtn) {
                cancelBtn.addEventListener('click', () => popup.classList.remove('is-open'));
            }

            // 3. 기존 저장된 값이 있다면 불러오기 (뒤로가기 시 데이터 유지)
            const savedBirth = sessionStorage.getItem('join_birth');
            if (savedBirth) {
                hiddenInput.value = savedBirth;
                dobValueDiv.textContent = savedBirth.replace(/-/g, '.'); // 2000-01-01 -> 2000.01.01
                dobValueDiv.style.color = '#000';
                nextBtn.disabled = false;
            }
        });

        // 다음 단계 이동 함수
        function goNext() {
            const birthValue = document.getElementById('birthdateInput').value;
            if (!birthValue) {
                alert('생년월일을 선택해주세요.');
                return;
            }
            // 세션 스토리지에 저장 후 이동
            sessionStorage.setItem('join_birth', birthValue);
            location.href = '/member/join/step5';
        }
    </script>
</body>
</html>