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

    <title>프로필 수정 | 승요일기</title>
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
                <div class="page-tit">프로필 수정</div>
            </div>

            <form id="profileForm" action="/member/update/profile" method="post" enctype="multipart/form-data">
                <div class="stack mt-24">

                    <div class="profile-img-area" style="text-align:center; margin-bottom:30px;">
                        <div class="img-box" style="position:relative; width:100px; height:100px; margin:0 auto; border-radius:50%; overflow:hidden; background:#f5f5f5;">
                            <img id="previewImg"
                                 src="${not empty member.profileImage ? member.profileImage : '/img/ico_user.svg'}"
                                 alt="프로필 이미지"
                                 style="width:100%; height:100%; object-fit:cover;">
                        </div>

                        <input type="file" id="profileFile" name="file" accept="image/*" style="display:none;" onchange="previewImage(this)">
                        <button type="button" class="btn btn-xs btn-secondary mt-12" onclick="document.getElementById('profileFile').click()">
                            사진 변경
                        </button>
                    </div>

                    <div class="profile_info">
                        <div class="profile-info_item">
                            <div class="gu">현재 닉네임 : <span class="nickname">${member.nickname}</span></div>
                            <div class="nae">
                                <div class="input">
                                    <input type="text" id="newNickname" name="nickname"
                                           value="${member.nickname}" <%-- 기존 값 넣어주기 --%>
                                           placeholder="변경할 닉네임을 입력해 주세요." autocomplete="off">
                                </div>
                            </div>
                        </div>
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
        const input = document.getElementById('newNickname');
        const clearBtn = document.getElementById('clearBtn');
        const submitBtn = document.getElementById('submitBtn');
        const validMsg = document.getElementById('validMsg');
        const serverMsg = document.getElementById('serverMsg');

        // 닉네임 정규식 (한글, 영문 대소문자 2~6자리)
        // 주의: 자음/모음만 있는 경우 등 상세 제어가 필요하면 정규식 수정 필요
        const nickRegex = /^[가-힣a-zA-Z]{2,6}$/;

        input.addEventListener('input', function() {
            // 1. 입력값 있으면 삭제 버튼 표시
            if (this.value.length > 0) {
                clearBtn.style.display = 'block';
            } else {
                clearBtn.style.display = 'none';
            }

            // 서버 에러 메시지 숨김
            if(serverMsg) serverMsg.style.display = 'none';

            // 2. 유효성 검사
            if (nickRegex.test(this.value)) {
                validMsg.style.display = 'none';
                submitBtn.disabled = false;
            } else {
                if (this.value.length > 0) {
                    validMsg.innerText = '2~6자리의 한글 또는 영문만 가능합니다.';
                    validMsg.className = 'login-message is-show is-error';
                    validMsg.style.display = 'block';
                } else {
                    validMsg.style.display = 'none';
                }
                submitBtn.disabled = true;
            }
        });

        // 삭제 버튼 클릭 시 초기화
        clearBtn.addEventListener('click', function() {
            input.value = '';
            this.style.display = 'none';
            validMsg.style.display = 'none';
            submitBtn.disabled = true;
            input.focus();
        });

        function submitForm() {
            // 최종 제출 전 한 번 더 검사 (현재 닉네임과 동일한지 등 체크 가능)
            document.getElementById('profileForm').submit();
        }

        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('previewImg').src = e.target.result;
                };
                reader.readAsDataURL(input.files[0]);

                // 사진을 바꾸면 [변경 완료] 버튼 활성화 로직도 필요하면 추가
                document.getElementById('submitBtn').disabled = false;
            }
        }
    </script>
</body>
</html>