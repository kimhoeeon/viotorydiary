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

    <title>알림 설정 | 승요일기</title>
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
                <div class="page-tit">알림 관리</div>
            </div>

            <div class="stack mt-24">
                <div class="my-alarm">

                    <div class="my-alarm-item">
                        <div class="tit">마케팅 알림</div>
                        <label class="toggle">
                            <input type="checkbox" class="toggle_input" id="toggleMarketing"
                                   onchange="updateAlarm('marketing', this)"
                            ${member.marketingAgree == 'Y' ? 'checked' : ''}>
                            <span class="toggle_track">
                                <span class="toggle_thumb"></span>
                            </span>
                        </label>
                    </div>

                    <div class="my-alarm-item">
                        <div class="tit">경기 알림</div>
                        <label class="toggle">
                            <input type="checkbox" class="toggle_input" id="toggleGame"
                                   onchange="updateAlarm('game', this)"
                            ${member.gameAlarm == 'Y' ? 'checked' : ''}>
                            <span class="toggle_track">
                                <span class="toggle_thumb"></span>
                            </span>
                        </label>
                    </div>

                    <div class="my-alarm-item b-0">
                        <div class="tit">친구 알림</div>
                        <label class="toggle">
                            <input type="checkbox" class="toggle_input" id="toggleFriend"
                                   onchange="updateAlarm('friend', this)"
                            ${member.friendAlarm == 'Y' ? 'checked' : ''}>
                            <span class="toggle_track">
                                <span class="toggle_thumb"></span>
                            </span>
                        </label>
                    </div>

                    <div class="pre mt-24">알림을 비활성화할 경우 경기 알림, 친구 요청 등 서비스 이용에 필요한 안내를 받지 못할 수 있습니다.</div>
                </div>

            </div>
        </div>
    </div>

    <%@ include file="../include/popup.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/script.js"></script>

    <script>
        function updateAlarm(type, element) {
            const isChecked = element.checked;
            const value = isChecked ? 'Y' : 'N';

            // AJAX 통신
            $.post('/member/alarm/update', { type: type, value: value }, function(res) {
                if(res === 'ok') {
                    console.log(type + ' 알림 변경 성공: ' + value);
                } else {
                    alert('설정 변경에 실패했습니다. 다시 시도해주세요.');
                    // 실패 시 UI 원상복구
                    element.checked = !isChecked;
                }
            }).fail(function() {
                alert('서버 통신 오류가 발생했습니다.');
                element.checked = !isChecked;
            });
        }
    </script>
</body>
</html>