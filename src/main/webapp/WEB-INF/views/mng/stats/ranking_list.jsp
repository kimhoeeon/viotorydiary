<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>직관 승률 랭킹 | 승요일기 관리자</title>
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
                                    <div class="card-body py-4">
                                        <h3 class="card-title m-0">🏆 직관 승률 랭킹 (TOP 100)</h3>
                                        <div class="text-muted fs-7 mt-1">회원들의 직관 기록을 바탕으로 집계된 순위입니다. (승리 횟수 우선)</div>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-body py-4">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5">
                                                <thead>
                                                <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                    <th class="min-w-50px">순위</th>
                                                    <th class="min-w-150px">회원정보</th>
                                                    <th class="min-w-100px">응원구단</th>
                                                    <th class="min-w-100px text-center">총 직관</th>
                                                    <th class="min-w-100px text-center text-primary">승리</th>
                                                    <th class="min-w-100px text-center text-danger">패배</th>
                                                    <th class="min-w-100px text-center">승률</th>
                                                    <th class="text-end min-w-100px">관리</th>
                                                </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                <c:forEach var="item" items="${list}">
                                                    <tr>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${item.ranking <= 3}">
                                                                    <span class="badge badge-circle badge-warning w-30px h-30px fs-6 text-white">${item.ranking}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="ms-3 fw-bold">${item.ranking}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <div class="d-flex flex-column">
                                                                    <a href="/mng/members/detail?memberId=${item.memberId}"
                                                                       class="text-gray-800 text-hover-primary mb-1">${item.nickname}</a>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td><span
                                                                class="badge badge-light fw-bold">${item.myTeamName}</span>
                                                        </td>
                                                        <td class="text-center fw-bold">${item.totalGames}</td>
                                                        <td class="text-center fw-bold text-primary">${item.winGames}</td>
                                                        <td class="text-center fw-bold text-danger">${item.loseGames}</td>
                                                        <td class="text-center">
                                                            <span class="badge badge-light-primary fw-bold fs-7">${item.winRate}%</span>
                                                        </td>
                                                        <td class="text-end">
                                                            <a href="/mng/members/detail?memberId=${item.memberId}"
                                                               class="btn btn-icon btn-bg-light btn-active-color-primary btn-sm">
                                                                <i class="ki-duotone ki-magnifier fs-2"><span
                                                                        class="path1"></span><span class="path2"></span></i>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty list}">
                                                    <tr>
                                                        <td colspan="8" class="text-center py-10">데이터가 없습니다.</td>
                                                    </tr>
                                                </c:if>
                                                </tbody>
                                            </table>
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
</body>
</html>