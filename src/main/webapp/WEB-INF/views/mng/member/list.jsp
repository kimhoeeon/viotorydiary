<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>회원 관리 | Viotory Admin</title>
    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>
</head>

<body id="kt_app_body" class="app-default">

    <div class="d-flex flex-column flex-root app-root" id="kt_app_root">
        <div class="app-page flex-column flex-column-fluid" id="kt_app_page">

            <jsp:include page="/WEB-INF/views/mng/include/header.jsp" />

            <div class="app-wrapper flex-column flex-row-fluid" id="kt_app_wrapper">

                <jsp:include page="/WEB-INF/views/mng/include/sidebar.jsp" />

                <div class="app-main flex-column flex-row-fluid" id="kt_app_main">
                    <div class="d-flex flex-column flex-column-fluid">
                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl">

                                <div class="card mb-7">
                                    <div class="card-body">
                                        <form action="/mng/members/list" method="get" class="d-flex align-items-center">
                                            <div class="position-relative w-md-400px me-md-2">
                                                <i class="ki-duotone ki-magnifier fs-3 text-gray-500 position-absolute top-50 translate-middle ms-6">
                                                    <span class="path1"></span><span class="path2"></span>
                                                </i>
                                                <input type="text" class="form-control form-control-solid ps-10" name="keyword" value="${keyword}" placeholder="이메일 또는 닉네임 검색" />
                                            </div>
                                            <button type="submit" class="btn btn-primary">검색</button>
                                        </form>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-header border-0 pt-6">
                                        <div class="card-title">
                                            <h3>회원 목록 <span class="fs-6 text-gray-400 fw-bold ms-1">(${totalCount}명)</span></h3>
                                        </div>
                                    </div>
                                    <div class="card-body py-4">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5" id="kt_table_users">
                                                <thead>
                                                <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                    <th class="min-w-50px">ID</th>
                                                    <th class="min-w-125px">이메일</th>
                                                    <th class="min-w-125px">닉네임</th>
                                                    <th class="min-w-100px">응원팀</th>
                                                    <th class="min-w-100px">상태</th>
                                                    <th class="min-w-125px">가입일</th>
                                                    <th class="text-end min-w-100px">관리</th>
                                                </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                <c:forEach var="member" items="${members}">
                                                    <tr>
                                                        <td>${member.memberId}</td>
                                                        <td>${member.email}</td>
                                                        <td>
                                                            <div class="d-flex flex-column">
                                                                <span>${member.nickname}</span>
                                                                <span class="text-gray-400 fs-9">${member.socialProvider ne 'NONE' ? member.socialProvider : '일반'}</span>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${member.myTeamCode ne 'NONE'}">
                                                                    <span class="badge badge-light-primary fw-bold">${member.myTeamCode}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-light-secondary">미설정</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:if test="${member.status eq 'ACTIVE'}">
                                                                <div class="badge badge-light-success fw-bold">활동중</div>
                                                            </c:if>
                                                            <c:if test="${member.status eq 'WITHDRAWN'}">
                                                                <div class="badge badge-light-danger fw-bold">탈퇴</div>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <fmt:parseDate value="${member.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                                                            <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd" />
                                                        </td>
                                                        <td class="text-end">
                                                            <a href="#" class="btn btn-light btn-active-light-primary btn-sm" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">
                                                                Action
                                                                <i class="ki-duotone ki-down fs-5 m-0"></i>
                                                            </a>
                                                            <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-125px py-4" data-kt-menu="true">
                                                                <div class="menu-item px-3">
                                                                    <a href="#" class="menu-link px-3" onclick="alert('준비중입니다.'); return false;">강제탈퇴</a>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty members}">
                                                    <tr>
                                                        <td colspan="7" class="text-center">데이터가 없습니다.</td>
                                                    </tr>
                                                </c:if>
                                                </tbody>
                                            </table>
                                        </div>

                                        <div class="d-flex justify-content-center mt-5">
                                            <ul class="pagination">
                                                <c:if test="${startPage > 1}">
                                                    <li class="page-item previous">
                                                        <a href="?page=${startPage - 1}&keyword=${keyword}" class="page-link"><i class="previous"></i></a>
                                                    </li>
                                                </c:if>

                                                <c:forEach begin="${startPage}" end="${endPage}" var="p">
                                                    <li class="page-item ${p == currentPage ? 'active' : ''}">
                                                        <a href="?page=${p}&keyword=${keyword}" class="page-link">${p}</a>
                                                    </li>
                                                </c:forEach>

                                                <c:if test="${endPage < totalPages}">
                                                    <li class="page-item next">
                                                        <a href="?page=${endPage + 1}&keyword=${keyword}" class="page-link"><i class="next"></i></a>
                                                    </li>
                                                </c:if>
                                            </ul>
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
    </div>
</body>
</html>