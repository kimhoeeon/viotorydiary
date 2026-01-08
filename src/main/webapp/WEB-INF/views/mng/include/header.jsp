<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="kt_app_header" class="app-header">
    <div class="app-container container-fluid d-flex align-items-stretch justify-content-between">
        <div class="d-flex align-items-center flex-grow-1 flex-lg-grow-0">
            <a href="/mng/main.do" class="d-flex align-items-center text-dark text-decoration-none">
                <span class="fw-bold fs-3">Viotory Admin</span>
            </a>
        </div>
        <div class="app-navbar flex-shrink-0">
            <div class="app-navbar-item">
                <span class="text-gray-600 fw-bold me-3">${sessionScope.adminName}님 환영합니다.</span>
                <a href="/mng/logout.do" class="btn btn-sm btn-light-danger">로그아웃</a>
            </div>
        </div>
    </div>
</div>