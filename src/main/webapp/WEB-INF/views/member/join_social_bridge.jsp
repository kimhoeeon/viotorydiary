<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>로그인 처리 중...</title>
</head>
<body>
<script>
    // 기존 가입 데이터 초기화
    sessionStorage.clear();

    // 카카오 정보를 세션 스토리지에 저장 (회원가입 단계에서 사용)
    sessionStorage.setItem('join_email', '${kakaoInfo.email}');
    sessionStorage.setItem('join_nickname', '${kakaoInfo.nickname}');
    sessionStorage.setItem('join_provider', '${kakaoInfo.socialProvider}');
    sessionStorage.setItem('join_social_uid', '${kakaoInfo.socialUid}');

    // 회원가입 첫 단계(약관 동의)로 이동
    location.replace('/member/join/step1');
</script>
</body>
</html>