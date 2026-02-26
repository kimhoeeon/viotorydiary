<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes" />

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <title>직관 승률 랭킹 | 승요일기 관리자</title>
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
                                        직관 승률 랭킹
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">통계 관리</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">직관 승률 랭킹</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

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
                                                    <th class="w-80px text-center">순위</th>
                                                    <th class="min-w-150px">닉네임</th>
                                                    <th class="min-w-125px text-center">응원 구단</th>
                                                    <th class="min-w-100px text-center">총 직관</th>
                                                    <th class="min-w-80px text-center text-primary">승</th>
                                                    <th class="min-w-80px text-center text-danger">패</th>
                                                    <th class="min-w-100px text-center">승률</th>
                                                    <th class="w-80px text-end">관리</th>
                                                </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                <c:forEach var="item" items="${list}" varStatus="status">
                                                    <c:set var="validGames" value="${item.winGames + item.loseGames}" />
                                                    <c:set var="calcWinRate" value="0.0" />
                                                    <c:if test="${validGames > 0}">
                                                        <c:set var="calcWinRate" value="${(item.winGames * 100.0) / validGames}" />
                                                    </c:if>

                                                    <tr class="hover-elevate-up">
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${status.count == 1}">
                                                                    <span class="badge badge-circle w-35px h-35px fs-5 text-white shadow-sm" style="background-color: #FFD700;">1</span>
                                                                </c:when>
                                                                <c:when test="${status.count == 2}">
                                                                    <span class="badge badge-circle w-35px h-35px fs-5 text-white shadow-sm" style="background-color: #C0C0C0;">2</span>
                                                                </c:when>
                                                                <c:when test="${status.count == 3}">
                                                                    <span class="badge badge-circle w-35px h-35px fs-5 text-white shadow-sm" style="background-color: #CD7F32;">3</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="fw-bold text-gray-800 fs-5">${status.count}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>

                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <span class="text-gray-800 fw-bold fs-6">${item.nickname}</span>
                                                            </div>
                                                        </td>

                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${empty item.myTeamCode or item.myTeamCode eq 'NONE'}">
                                                                    <span class="badge badge-light-secondary fw-bold">미설정</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="d-flex align-items-center justify-content-center">
                                                                        <div class="symbol symbol-30px symbol-circle me-2 border border-1 border-gray-300">
                                                                            <img src="/img/logo/logo_${fn:toLowerCase(item.myTeamCode)}.svg" class="p-1 object-fit-contain" alt="로고"/>
                                                                        </div>
                                                                        <span class="fw-bold text-gray-800">${item.myTeamName}</span>
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>

                                                        <td class="text-center">
                                                            <span class="fw-bold text-dark fs-5">${item.totalGames}</span><span class="text-muted fs-8 ms-1">회</span>
                                                        </td>

                                                        <td class="text-center fw-bolder text-primary fs-5">${item.winGames}</td>

                                                        <td class="text-center fw-bolder text-danger fs-5">${item.loseGames}</td>

                                                        <td class="text-center">
                                                            <span class="badge badge-light-primary fw-bolder fs-6 px-3 py-2">
                                                                <fmt:formatNumber value="${calcWinRate}" pattern="0.0"/>%
                                                            </span>
                                                        </td>

                                                        <td class="text-end">
                                                            <a href="/mng/members/detail?memberId=${item.memberId}"
                                                               class="btn btn-icon btn-bg-light btn-active-color-primary btn-sm" title="회원 상세조회">
                                                                <i class="ki-duotone ki-magnifier fs-2">
                                                                    <span class="path1"></span>
                                                                    <span class="path2"></span>
                                                                </i> 회원 정보
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>

                                                <c:if test="${empty list}">
                                                    <tr>
                                                        <td colspan="8" class="text-center py-10 text-muted">랭킹 데이터가 없습니다.</td>
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