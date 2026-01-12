<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>회원 상세 | Viotory Admin</title>
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

    <c:if test="${sessionScope.status ne 'logon'}">
        <script>
            alert("로그인해 주세요.");
            location.href = '/mng/index.do';
        </script>
    </c:if>

    <c:if test="${sessionScope.status eq 'logon'}">
        <div class="d-flex flex-column flex-root app-root" id="kt_app_root">
            <div class="app-page flex-column flex-column-fluid" id="kt_app_page">

                <jsp:include page="/WEB-INF/views/mng/include/header.jsp" />

                <div class="app-wrapper flex-column flex-row-fluid" id="kt_app_wrapper">

                    <jsp:include page="/WEB-INF/views/mng/include/sidebar.jsp" />

                    <div class="app-main flex-column flex-row-fluid" id="kt_app_main">
                        <div class="d-flex flex-column flex-column-fluid">
                            <div id="kt_app_content" class="app-content flex-column-fluid">
                                <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                    <div class="card mb-5 mb-xl-10">
                                        <div class="card-header border-0 cursor-pointer">
                                            <div class="card-title m-0">
                                                <h3 class="fw-bold m-0">회원 상세 정보</h3>
                                            </div>
                                        </div>

                                        <div class="card-body p-9">
                                            <div class="row mb-7">
                                                <label class="col-lg-2 fw-semibold text-muted">이메일 (ID)</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">${member.email}</span>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">가입 경로</label>
                                                <div class="col-lg-4">
                                                <span class="fw-bold fs-6 text-gray-800">
                                                    <c:choose>
                                                        <c:when test="${member.socialProvider eq 'NONE'}">일반</c:when>
                                                        <c:otherwise>${member.socialProvider}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                                </div>
                                            </div>

                                            <div class="row mb-7">
                                                <label class="col-lg-2 fw-semibold text-muted">닉네임</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">${member.nickname}</span>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">연락처</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">${member.phoneNumber}</span>
                                                </div>
                                            </div>

                                            <div class="row mb-7">
                                                <label class="col-lg-2 fw-semibold text-muted">생년월일</label>
                                                <div class="col-lg-4">
                                                <span class="fw-bold fs-6 text-gray-800">
                                                    <c:choose>
                                                        <c:when test="${not empty member.birthdate}">${member.birthdate}</c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </span>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">성별</label>
                                                <div class="col-lg-4">
                                                <span class="fw-bold fs-6 text-gray-800">
                                                    <c:choose>
                                                        <c:when test="${member.gender eq 'M'}">남성</c:when>
                                                        <c:when test="${member.gender eq 'F'}">여성</c:when>
                                                        <c:otherwise>미선택</c:otherwise>
                                                    </c:choose>
                                                </span>
                                                </div>
                                            </div>

                                            <hr class="my-6"> <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">응원팀</label>
                                            <div class="col-lg-4">
                                                <c:choose>
                                                    <c:when test="${member.myTeamCode ne 'NONE'}">
                                                        <span class="badge badge-light-primary fw-bold fs-6">${member.myTeamCode}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-light-secondary fs-6">미설정</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <label class="col-lg-2 fw-semibold text-muted">계정 상태</label>
                                            <div class="col-lg-4">
                                                <c:if test="${member.status eq 'ACTIVE'}">
                                                    <span class="badge badge-light-success fw-bold fs-6">활동중</span>
                                                </c:if>
                                                <c:if test="${member.status eq 'WITHDRAWN'}">
                                                    <span class="badge badge-light-danger fw-bold fs-6">탈퇴</span>
                                                </c:if>
                                                <c:if test="${member.status eq 'INACTIVE'}">
                                                    <span class="badge badge-light-warning fw-bold fs-6">휴면</span>
                                                </c:if>
                                            </div>
                                        </div>

                                            <div class="row mb-7">
                                                <label class="col-lg-2 fw-semibold text-muted">가입일시</label>
                                                <div class="col-lg-4">
                                                <span class="fw-bold fs-6 text-gray-800">
                                                    <fmt:parseDate value="${member.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="joinDate" type="both" />
                                                    <fmt:formatDate value="${joinDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                                                </span>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">최근 접속</label>
                                                <div class="col-lg-4">
                                                <span class="fw-bold fs-6 text-gray-800">
                                                    <c:if test="${not empty member.lastLoginAt}">
                                                        <fmt:parseDate value="${member.lastLoginAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="loginDate" type="both" />
                                                        <fmt:formatDate value="${loginDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                                                    </c:if>
                                                    <c:if test="${empty member.lastLoginAt}">-</c:if>
                                                </span>
                                                </div>
                                            </div>

                                        </div>

                                        <div class="card-footer d-flex justify-content-end py-6 px-9">
                                            <a href="/mng/members/list" class="btn btn-light btn-active-light-primary me-2">목록으로</a>

                                            <c:if test="${member.status eq 'ACTIVE'}">
                                                <button type="button" class="btn btn-danger" onclick="confirmDetailWithdraw('${member.memberId}');">강제탈퇴</button>
                                            </c:if>
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
            function confirmDetailWithdraw(memberId) {
                if(confirm("해당 회원을 강제 탈퇴 처리하시겠습니까?\n이 작업은 되돌릴 수 없습니다.")) {

                    // POST 요청 전송
                    $.ajax({
                        url: '/mng/members/withdraw',
                        type: 'POST',
                        data: { memberId: memberId },
                        success: function(response) {
                            if(response === 'ok') {
                                alert("정상적으로 탈퇴 처리되었습니다.");
                                location.reload(); // 상태 반영을 위해 새로고침
                            } else {
                                alert("처리 중 오류가 발생했습니다.\n" + response);
                            }
                        },
                        error: function(xhr, status, error) {
                            alert("서버 통신 오류: " + error);
                        }
                    });
                }
            }
        </script>
    </c:if>
</body>
</html>