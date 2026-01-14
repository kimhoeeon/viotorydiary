<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="center-popup-backdrop" id="commonPopup" style="display: none;">
    <div class="center-popup">
        <div class="center-popup_body">
            <div class="center-popup_title" id="commonPopupTitle">
            </div>
        </div>

        <div class="center-popup_footer" id="popupFooterConfirm">
            <button type="button" class="btn btn-gray color-b" onclick="closePopup()">
                닫기
            </button>
            <button type="button" class="btn btn-primary" id="popupConfirmBtn">
                확인
            </button>
        </div>

        <div class="one_btn" id="popupFooterAlert" style="display:none;">
            <button type="button" class="btn btn-primary st2" onclick="closePopup()">
                확인
            </button>
        </div>
    </div>
</div>

<script>
    // 팝업 열기 함수
    // type: 'confirm' (취소/확인) or 'alert' (확인만)
    // text: 팝업 내용 (HTML 태그 포함 가능)
    // confirmCallback: 확인 버튼 클릭 시 실행할 함수
    function showPopup(type, text, confirmCallback) {
        const popup = document.getElementById('commonPopup');
        const title = document.getElementById('commonPopupTitle');
        const footerConfirm = document.getElementById('popupFooterConfirm');
        const footerAlert = document.getElementById('popupFooterAlert');
        const confirmBtn = document.getElementById('popupConfirmBtn');

        // 텍스트 설정
        title.innerHTML = text;

        // 버튼 타입 설정
        if (type === 'confirm') {
            footerConfirm.style.display = 'flex';
            footerAlert.style.display = 'none';

            // 확인 버튼 이벤트 연결
            confirmBtn.onclick = function () {
                if (confirmCallback) confirmCallback();
                closePopup();
            };
        } else {
            footerConfirm.style.display = 'none';
            footerAlert.style.display = 'block';
        }

        popup.style.display = 'block';
    }

    function closePopup() {
        document.getElementById('commonPopup').style.display = 'none';
    }
</script>