<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
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

    <title>회원 상세 | 승요일기 관리자</title>
    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/css/mngStyle.css" rel="stylesheet">
</head>
<body id="kt_app_body"
      data-kt-app-layout="dark-sidebar"
      data-kt-app-header-fixed="true"
      data-kt-app-sidebar-enabled="true"
      data-kt-app-sidebar-fixed="true"
      data-kt-app-sidebar-hoverable="true"
      data-kt-app-sidebar-push-header="true"
      data-kt-app-sidebar-push-toolbar="true"
      data-kt-app-sidebar-push-footer="true"
      data-kt-app-toolbar-enabled="true"
      class="app-default">

    <div class="d-flex flex-column flex-root app-root" id="kt_app_root">
        <div class="app-page flex-column flex-column-fluid" id="kt_app_page">
            <jsp:include page="/WEB-INF/views/mng/include/header.jsp"/>
            <div class="app-wrapper flex-column flex-row-fluid" id="kt_app_wrapper">
                <jsp:include page="/WEB-INF/views/mng/include/sidebar.jsp"/>

                <div class="app-main flex-column flex-row-fluid" id="kt_app_main">
                    <div class="d-flex flex-column flex-column-fluid">

                        <div id="kt_app_toolbar" class="app-toolbar pt-6 pb-2 pt-lg-10 pb-lg-2">
                            <div id="kt_app_toolbar_container" class="app-container container-xxl d-flex flex-stack">
                                <div class="page-title d-flex flex-column justify-content-center flex-wrap me-3">
                                    <h1 class="page-heading d-flex text-dark fw-bold fs-3 flex-column justify-content-center my-0">
                                        회원 목록
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">회원 관리</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">회원 목록</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-header border-0 cursor-pointer">
                                        <div class="card-title m-0">
                                            <h3 class="fw-bold m-0">회원 상세 정보</h3>
                                        </div>
                                        <div class="card-toolbar">
                                            <c:if test="${member.status eq 'ACTIVE'}">
                                                <button type="button" class="btn btn-sm btn-light-warning me-2"
                                                        onclick="changeStatus('SUSPENDED')">활동 정지
                                                </button>
                                                <button type="button" class="btn btn-sm btn-light-danger"
                                                        onclick="changeStatus('WITHDRAWN')">강제 탈퇴
                                                </button>
                                                <button type="button" class="btn btn-sm btn-light-primary me-2" onclick="resetPassword()">
                                                    비밀번호 초기화
                                                </button>
                                            </c:if>
                                            <c:if test="${member.status eq 'SUSPENDED'}">
                                                <button type="button" class="btn btn-sm btn-light-success me-2"
                                                        onclick="changeStatus('ACTIVE')">정지 해제
                                                </button>
                                                <button type="button" class="btn btn-sm btn-light-danger"
                                                        onclick="changeStatus('WITHDRAWN')">강제 탈퇴
                                                </button>
                                                <button type="button" class="btn btn-sm btn-light-primary me-2" onclick="resetPassword()">
                                                    비밀번호 초기화
                                                </button>
                                            </c:if>
                                            <c:if test="${member.status eq 'WITHDRAWN'}">
                                                <span class="badge badge-light-danger fs-6">탈퇴 회원</span>
                                            </c:if>
                                        </div>
                                    </div>

                                    <div class="card-body p-9">
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">닉네임</label>
                                            <div class="col-lg-4"><span
                                                    class="fw-bold fs-6 text-gray-800">${member.nickname}</span></div>
                                            <label class="col-lg-2 fw-semibold text-muted">이메일</label>
                                            <div class="col-lg-4"><span
                                                    class="fw-bold fs-6 text-gray-800">${member.email}</span></div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">응원 구단</label>
                                            <div class="col-lg-4"><span
                                                    class="badge badge-light-primary fw-bold">${member.myTeamCode}</span></div>
                                            <label class="col-lg-2 fw-semibold text-muted">현재 상태</label>
                                            <div class="col-lg-4">
                                                <c:choose>
                                                    <c:when test="${member.status eq 'ACTIVE'}"><span
                                                            class="text-success fw-bold">정상</span></c:when>
                                                    <c:when test="${member.status eq 'SUSPENDED'}"><span
                                                            class="text-warning fw-bold">정지</span></c:when>
                                                    <c:when test="${member.status eq 'WITHDRAWN'}"><span
                                                            class="text-danger fw-bold">탈퇴</span></c:when>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">가입일시</label>
                                            <div class="col-lg-4">
                                                <span class="fw-bold fs-6 text-gray-800">
                                                    <fmt:parseDate value="${member.createdAt}"
                                                                   pattern="yyyy-MM-dd'T'HH:mm:ss" var="joinDate"
                                                                   type="both"/>
                                                    <fmt:formatDate value="${joinDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-footer d-flex justify-content-end py-6 px-9">
                                        <a href="/mng/members/list" class="btn btn-light btn-active-light-primary">목록으로</a>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script>
        function changeStatus(status) {
            let msg = '';
            if (status === 'SUSPENDED') msg = '활동 정지 처리하시겠습니까?';
            else if (status === 'WITHDRAWN') msg = '강제 탈퇴 처리하시겠습니까? (복구 불가)';
            else if (status === 'ACTIVE') msg = '정지를 해제하시겠습니까?';

            if (confirm(msg)) {
                $.post('/mng/members/updateStatus', {
                    memberId: '${member.memberId}',
                    status: status
                }, function (res) {
                    if (res === 'ok') {
                        alert('처리되었습니다.');
                        location.reload();
                    } else {
                        alert('오류가 발생했습니다.');
                    }
                });
            }
        }

        function resetPassword() {
            if (confirm('비밀번호를 초기화하고 회원에게 SMS를 발송하시겠습니까?')) {
                $.post('/mng/members/resetPassword', {
                    memberId: '${member.memberId}'
                }, function (res) {
                    if (res === 'ok') alert('임시 비밀번호가 발송되었습니다.');
                    else if (res === 'no_phone') alert('등록된 연락처가 없습니다.');
                    else alert('오류가 발생했습니다.');
                });
            }
        }
    </script>
</body>
</html>