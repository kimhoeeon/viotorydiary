<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>요청사항 & 문의 | 승요일기 관리자</title>
    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/css/mngStyle.css" rel="stylesheet">
</head>
<body id="kt_app_body" class="app-default" data-kt-app-layout="dark-sidebar" data-kt-app-header-fixed="true"
      data-kt-app-sidebar-enabled="true" data-kt-app-sidebar-fixed="true">

    <div class="d-flex flex-column flex-root app-root" id="kt_app_root">
        <div class="app-page flex-column flex-column-fluid" id="kt_app_page">
            <jsp:include page="/WEB-INF/views/mng/include/header.jsp"/>
            <div class="app-wrapper flex-column flex-row-fluid" id="kt_app_wrapper">
                <jsp:include page="/WEB-INF/views/mng/include/sidebar.jsp"/>

                <div class="app-main flex-column flex-row-fluid" id="kt_app_main">
                    <div class="d-flex flex-column flex-column-fluid">
                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-7">
                                    <div class="card-body">
                                        <form id="searchForm" action="/mng/dev/list" method="get"
                                              class="d-flex align-items-center flex-wrap gap-2">
                                            <input type="hidden" name="pageNum" value="1">
                                            <input type="hidden" name="amount" value="${pageMaker.cri.amount}">

                                            <select name="category" class="form-select form-select-solid w-150px">
                                                <option value="">전체 유형</option>
                                                <option value="MAINTENANCE" ${pageMaker.cri.category eq 'MAINTENANCE' ? 'selected' : ''}>
                                                    유지보수
                                                </option>
                                                <option value="BUG" ${pageMaker.cri.category eq 'BUG' ? 'selected' : ''}>
                                                    기능오류
                                                </option>
                                                <option value="INQUIRY" ${pageMaker.cri.category eq 'INQUIRY' ? 'selected' : ''}>
                                                    단순문의
                                                </option>
                                            </select>

                                            <select name="status" class="form-select form-select-solid w-150px">
                                                <option value="">전체 상태</option>
                                                <option value="WAITING" ${pageMaker.cri.status eq 'WAITING' ? 'selected' : ''}>
                                                    처리대기
                                                </option>
                                                <option value="PROCESS" ${pageMaker.cri.status eq 'PROCESS' ? 'selected' : ''}>
                                                    진행중
                                                </option>
                                                <option value="DONE" ${pageMaker.cri.status eq 'DONE' ? 'selected' : ''}>
                                                    완료
                                                </option>
                                                <option value="DISCUSS" ${pageMaker.cri.status eq 'DISCUSS' ? 'selected' : ''}>
                                                    논의필요
                                                </option>
                                                <option value="REJECT" ${pageMaker.cri.status eq 'REJECT' ? 'selected' : ''}>
                                                    처리불가
                                                </option>
                                            </select>

                                            <div class="position-relative w-md-300px">
                                                <i class="ki-duotone ki-magnifier fs-3 text-gray-500 position-absolute top-50 translate-middle ms-6"><span
                                                        class="path1"></span><span class="path2"></span></i>
                                                <input type="text" class="form-control form-control-solid ps-10"
                                                       name="keyword" value="${pageMaker.cri.keyword}" placeholder="제목 검색"/>
                                            </div>

                                            <button type="submit" class="btn btn-primary">검색</button>

                                            <div class="ms-auto">
                                                <c:if test="${sessionScope.admin.role eq 'CLIENT'}">
                                                    <a href="/mng/dev/write" class="btn btn-success"><i
                                                            class="ki-duotone ki-pencil fs-2"></i> 요청하기</a>
                                                </c:if>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-body py-4">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5">
                                                <thead>
                                                <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                    <th class="min-w-50px">No</th>
                                                    <th class="min-w-80px">유형</th>
                                                    <th class="min-w-300px">제목</th>
                                                    <th class="min-w-100px">작성자</th>
                                                    <th class="min-w-100px">등록일</th>
                                                    <th class="min-w-100px">처리예정일</th>
                                                    <th class="min-w-80px">상태</th>
                                                </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                <c:forEach var="item" items="${list}">
                                                    <tr>
                                                        <td>${item.reqId}</td>
                                                        <td>
                                                            <c:if test="${item.urgency eq 'Y'}"><span
                                                                    class="badge badge-danger me-1">긴급</span></c:if>
                                                            <span class="badge badge-light fw-bold">${item.categoryName}</span>
                                                        </td>
                                                        <td>
                                                            <a href="/mng/dev/detail?reqId=${item.reqId}&pageNum=${pageMaker.cri.pageNum}&amount=${pageMaker.cri.amount}&category=${pageMaker.cri.category}&status=${pageMaker.cri.status}&keyword=${pageMaker.cri.keyword}"
                                                               class="text-gray-800 text-hover-primary fw-bold fs-6">
                                                                    ${item.title}
                                                                <c:if test="${item.commentCount > 0}">
                                                                    <span class="text-primary ms-1">[${item.commentCount}]</span>
                                                                </c:if>
                                                            </a>
                                                        </td>
                                                        <td>${item.writerName}</td>
                                                        <td>
                                                            <fmt:parseDate value="${item.createdAt}"
                                                                           pattern="yyyy-MM-dd'T'HH:mm:ss" var="regDate"
                                                                           type="both"/>
                                                            <fmt:formatDate value="${regDate}" pattern="yyyy-MM-dd"/>
                                                        </td>
                                                        <td>
                                                            <c:out value="${item.dueDate}" default="-"/>
                                                        </td>
                                                        <td>
                                                            <span class="badge ${item.statusBadge}">${item.status}</span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty list}">
                                                    <tr>
                                                        <td colspan="7" class="text-center py-10">등록된 요청사항이 없습니다.</td>
                                                    </tr>
                                                </c:if>
                                                </tbody>
                                            </table>
                                        </div>

                                        <div class="d-flex flex-stack flex-wrap pt-10">
                                            <div class="fs-6 fw-semibold text-gray-700"></div>
                                            <ul class="pagination">
                                                <c:if test="${pageMaker.prev}">
                                                    <li class="page-item previous">
                                                        <a href="${pageMaker.startPage - 1}" class="page-link"><i
                                                                class="previous"></i></a>
                                                    </li>
                                                </c:if>

                                                <c:forEach var="num" begin="${pageMaker.startPage}"
                                                           end="${pageMaker.endPage}">
                                                    <li class="page-item ${pageMaker.cri.pageNum == num ? 'active' : ''}">
                                                        <a href="${num}" class="page-link">${num}</a>
                                                    </li>
                                                </c:forEach>

                                                <c:if test="${pageMaker.next}">
                                                    <li class="page-item next">
                                                        <a href="${pageMaker.endPage + 1}" class="page-link"><i
                                                                class="next"></i></a>
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

    <form id="actionForm" action="/mng/dev/list" method="get">
        <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
        <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
        <input type="hidden" name="category" value="${pageMaker.cri.category}">
        <input type="hidden" name="status" value="${pageMaker.cri.status}">
        <input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
    </form>

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script>
        $(document).ready(function () {
            var actionForm = $("#actionForm");

            // 페이지 번호 클릭 이벤트
            $(".page-link").on("click", function (e) {
                e.preventDefault();
                var targetPage = $(this).attr("href");
                actionForm.find("input[name='pageNum']").val(targetPage);
                actionForm.submit();
            });
        });
    </script>
</body>
</html>