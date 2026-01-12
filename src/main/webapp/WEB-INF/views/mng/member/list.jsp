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

                                    <div class="card mb-7">
                                        <div class="card-body">
                                            <form action="/mng/members/list" method="get" class="d-flex align-items-center">
                                                <div class="w-150px me-3">
                                                    <select name="searchType" class="form-select form-select-solid" data-control="select2" data-hide-search="true">
                                                        <option value="">전체</option>
                                                        <option value="email" ${searchType eq 'email' ? 'selected' : ''}>이메일</option>
                                                        <option value="nickname" ${searchType eq 'nickname' ? 'selected' : ''}>닉네임</option>
                                                    </select>
                                                </div>

                                                <div class="position-relative w-md-400px me-md-2">
                                                    <i class="ki-duotone ki-magnifier fs-3 text-gray-500 position-absolute top-50 translate-middle ms-6">
                                                        <span class="path1"></span><span class="path2"></span>
                                                    </i>
                                                    <input type="text" class="form-control form-control-solid ps-10" name="keyword" value="${keyword}" placeholder="검색어를 입력하세요" />
                                                </div>

                                                <button type="submit" class="btn btn-primary">검색</button>

                                                <c:if test="${not empty keyword}">
                                                    <a href="/mng/members/list" class="btn btn-light ms-2">초기화</a>
                                                </c:if>
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
                                                        <th class="min-w-50px">No</th>
                                                        <th class="min-w-125px">이메일 (ID)</th>
                                                        <th class="min-w-125px">닉네임 / 가입경로</th>
                                                        <th class="min-w-100px">응원팀</th>
                                                        <th class="min-w-100px">상태</th>
                                                        <th class="min-w-125px">가입일</th>
                                                        <th class="min-w-125px">최근 접속</th>
                                                        <th class="text-end min-w-100px">관리</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody class="text-gray-600 fw-semibold">
                                                    <c:forEach var="member" items="${members}">
                                                        <tr>
                                                            <td>${member.memberId}</td>
                                                            <td class="d-flex align-items-center">
                                                                <div class="d-flex flex-column">
                                                                    <a href="#" class="text-gray-800 text-hover-primary mb-1">${member.email}</a>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="d-flex flex-column">
                                                                    <span>${member.nickname}</span>
                                                                    <span class="text-gray-400 fs-9">
                                                                        <c:choose>
                                                                            <c:when test="${member.socialProvider eq 'NONE'}">일반가입</c:when>
                                                                            <c:otherwise>${member.socialProvider}</c:otherwise>
                                                                        </c:choose>
                                                                    </span>
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
                                                                <c:if test="${member.status eq 'INACTIVE'}">
                                                                    <div class="badge badge-light-warning fw-bold">휴면</div>
                                                                </c:if>
                                                            </td>
                                                            <td>
                                                                <fmt:parseDate value="${member.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedJoinDate" type="both" />
                                                                <fmt:formatDate value="${parsedJoinDate}" pattern="yyyy-MM-dd" />
                                                            </td>
                                                            <td>
                                                                <c:if test="${not empty member.lastLoginAt}">
                                                                    <fmt:parseDate value="${member.lastLoginAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedLoginDate" type="both" />
                                                                    <fmt:formatDate value="${parsedLoginDate}" pattern="yyyy-MM-dd HH:mm" />
                                                                </c:if>
                                                                <c:if test="${empty member.lastLoginAt}">
                                                                    <span class="text-gray-400">-</span>
                                                                </c:if>
                                                            </td>
                                                            <td class="text-end">
                                                                <a href="#" class="btn btn-light btn-active-light-primary btn-sm" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">
                                                                    관리
                                                                    <i class="ki-duotone ki-down fs-5 m-0"></i>
                                                                </a>
                                                                <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-125px py-4" data-kt-menu="true">
                                                                    <div class="menu-item px-3">
                                                                        <a href="<c:url value="/mng/members/detail?memberId=${member.memberId}"/>" class="menu-link px-3">상세정보</a>
                                                                    </div>
                                                                    <div class="menu-item px-3">
                                                                        <a href="#" class="menu-link px-3 text-danger" onclick="confirmWithdraw('${member.memberId}', '${member.nickname}'); return false;">강제탈퇴</a>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>

                                                    <c:if test="${empty members}">
                                                        <tr>
                                                            <td colspan="8" class="text-center py-10 text-gray-500">
                                                                검색 결과가 없습니다.
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <div class="d-flex justify-content-center mt-5">
                                                <ul class="pagination">
                                                    <c:if test="${startPage > 1}">
                                                        <li class="page-item previous">
                                                            <a href="?page=${startPage - 1}&searchType=${searchType}&keyword=${keyword}" class="page-link">
                                                                <i class="previous"></i>
                                                            </a>
                                                        </li>
                                                    </c:if>

                                                    <c:forEach begin="${startPage}" end="${endPage}" var="p">
                                                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                                                            <a href="?page=${p}&searchType=${searchType}&keyword=${keyword}" class="page-link">${p}</a>
                                                        </li>
                                                    </c:forEach>

                                                    <c:if test="${endPage < totalPages}">
                                                        <li class="page-item next">
                                                            <a href="?page=${endPage + 1}&searchType=${searchType}&keyword=${keyword}" class="page-link">
                                                                <i class="next"></i>
                                                            </a>
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
        </div>

        <script src="/assets/plugins/global/plugins.bundle.js"></script>
        <script src="/assets/js/scripts.bundle.js"></script>

        <script>
            // 강제 탈퇴 확인 (목록에서 바로 처리)
            function confirmWithdraw(memberId, nickname) {
                if(confirm("정말 [" + nickname + "] 회원을 강제 탈퇴 처리하시겠습니까?\n이 작업은 되돌릴 수 없습니다.")) {
                    $.ajax({
                        url: '/mng/members/withdraw',
                        type: 'POST',
                        data: { memberId: memberId },
                        success: function(response) {
                            if(response === 'ok') {
                                alert("탈퇴 처리되었습니다.");
                                location.reload();
                            } else {
                                alert("오류: " + response);
                            }
                        },
                        error: function(err) {
                            alert("서버 통신 실패");
                        }
                    });
                }
            }
        </script>
    </c:if>
</body>
</html>