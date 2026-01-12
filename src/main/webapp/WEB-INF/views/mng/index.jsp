<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>ViotoryDiary Admin</title>
    <link href="/css/reset.css" rel="stylesheet">
    <link href="/css/mngStyle.css" rel="stylesheet">
</head>
<body>
    <div id="main_container">
        <div id="login">
            <form id="login_form" action="/mng/login" method="post">
                <div>
                    <p class="brand-logo" style="text-align:center; font-size:24px; font-weight:bold; color:#333;">
                        VIOTORY DIARY<br>
                        <span id="logo_txt" style="font-size:16px; font-weight:normal;">[ 관리자 시스템 ]</span>
                    </p>

                    <c:if test="${not empty error}">
                        <p style="color:red; text-align:center; margin-bottom:20px;">${error}</p>
                    </c:if>

                    <p class="mb20 mt30">
                        <input type="text" name="adminId" id="adminId" class="inp" placeholder="아이디" required>
                    </p>
                    <p class="mb40">
                        <input type="password" name="adminPw" id="adminPw" class="inp" placeholder="비밀번호" required>
                    </p>
                </div>
                <p class="mt30 mb40">
                    <button type="submit" class="btn-login">로그인</button>
                </p>
            </form>
        </div>
    </div>
</body>
</html>