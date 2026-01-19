<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%--
  IntelliJ Variable Definitions
  (이 주석은 실제 실행 시 무시되며, IDE 에러 표시를 없애기 위한 용도입니다)
--%>
<%--@elvariable id="sysDbStatus" type="java.lang.Boolean"--%>
<%--@elvariable id="sysMemoryUsed" type="java.lang.Long"--%>
<%--@elvariable id="sysMemoryTotal" type="java.lang.Long"--%>
<%--@elvariable id="sysMemoryUsage" type="java.lang.Integer"--%>
<%--@elvariable id="sysDiskUsed" type="java.lang.Long"--%>
<%--@elvariable id="sysDiskTotal" type="java.lang.Long"--%>
<%--@elvariable id="sysDiskUsage" type="java.lang.Integer"--%>
<%--@elvariable id="sysOsName" type="java.lang.String"--%>
<%--@elvariable id="sysJavaVer" type="java.lang.String"--%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>관리자 메인 | 승요일기 관리자</title>
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
                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <c:if test="${sessionScope.admin.role eq 'SUPER'}">
                                    <div class="card mb-8 bg-light-warning border-warning border-dashed">
                                        <div class="card-body py-5 d-flex align-items-center justify-content-between">
                                            <div class="d-flex align-items-center">
                                                <i class="ki-duotone ki-security-user fs-1 text-warning me-4">
                                                    <span class="path1"></span>
                                                    <span class="path2"></span>
                                                </i>
                                                <div class="d-flex flex-column">
                                                    <h3 class="fs-4 fw-bold mb-1 text-gray-900">관리자 계정 관리 (Super Admin)</h3>
                                                    <span class="fs-7 fw-semibold text-gray-600">운영자 및 발주사 계정 생성, IP 및 권한을 설정할 수 있습니다.</span>
                                                </div>
                                            </div>
                                            <div>
                                                <a href="/mng/system/admin/list" class="btn btn-sm btn-warning fw-bold">
                                                    <i class="ki-duotone ki-setting-2 fs-2 me-1">
                                                        <span class="path1"></span>
                                                        <span class="path2"></span>
                                                    </i> 계정 관리
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <div class="row g-5 g-xl-10 mb-5 mb-xl-10">

                                    <div class="col-xl-8">
                                        <div class="card card-flush h-xl-100">
                                            <div class="card-header pt-7">
                                                <h3 class="card-title align-items-start flex-column">
                                                    <span class="card-label fw-bold text-gray-900">일별 접속 통계</span>
                                                    <span class="text-gray-400 mt-1 fw-semibold fs-6">최근 7일간의 접속자 추이</span>
                                                </h3>
                                            </div>
                                            <div class="card-body pt-5">
                                                <div id="kt_charts_widget_1_chart" class="min-h-auto ps-4 pe-6 mb-3"
                                                     style="height: 350px"></div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-xl-4">
                                        <div class="card h-xl-100">
                                            <div class="card-header border-0 pt-5">
                                                <h3 class="card-title align-items-start flex-column">
                                                    <span class="card-label fw-bold text-gray-900">System Status</span>
                                                    <span class="text-muted mt-1 fw-semibold fs-7">서버 리소스 모니터링</span>
                                                </h3>
                                                <div class="card-toolbar">
                                                    <button class="btn btn-sm btn-icon btn-color-primary btn-active-light-primary"
                                                            onclick="location.reload()" title="새로고침">
                                                        <i class="ki-duotone ki-arrows-circle fs-2"><span
                                                                class="path1"></span><span class="path2"></span></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="card-body pt-5">

                                                <div class="d-flex align-items-center mb-8">
                                                    <div class="symbol symbol-50px me-5">
                                                        <span class="symbol-label bg-light-success">
                                                            <i class="ki-duotone ki-data fs-2x text-success"><span
                                                                    class="path1"></span><span class="path2"></span><span
                                                                    class="path3"></span></i>
                                                        </span>
                                                    </div>
                                                    <div class="d-flex flex-column">
                                                        <span class="text-gray-800 fw-bold fs-6">Database</span>
                                                        <span class="text-muted fw-semibold fs-7">MySQL Connection</span>
                                                    </div>
                                                    <div class="ms-auto">
                                                        <c:choose>
                                                            <c:when test="${sysDbStatus}">
                                                                <span class="badge badge-light-success fw-bold fs-7">Normal</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-light-danger fw-bold fs-7">Error</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                                <div class="mb-6">
                                                    <div class="d-flex flex-stack mb-2">
                                                        <span class="text-gray-800 fw-bold fs-6">Memory (JVM)</span>
                                                        <span class="text-gray-500 fw-bold fs-7">${sysMemoryUsage}%</span>
                                                    </div>
                                                    <div class="progress h-6px w-100 bg-light-primary rounded">
                                                        <div class="progress-bar bg-primary rounded" role="progressbar"
                                                             style="width: ${sysMemoryUsage}%"
                                                             aria-valuenow="${sysMemoryUsage}" aria-valuemin="0"
                                                             aria-valuemax="100"></div>
                                                    </div>
                                                    <div class="text-gray-400 fs-8 mt-1 text-end">${sysMemoryUsed}MB
                                                        / ${sysMemoryTotal}MB
                                                    </div>
                                                </div>

                                                <div class="mb-6">
                                                    <div class="d-flex flex-stack mb-2">
                                                        <span class="text-gray-800 fw-bold fs-6">Disk Space</span>
                                                        <span class="text-gray-500 fw-bold fs-7">${sysDiskUsage}%</span>
                                                    </div>
                                                    <div class="progress h-6px w-100 bg-light-warning rounded">
                                                        <div class="progress-bar bg-warning rounded" role="progressbar"
                                                             style="width: ${sysDiskUsage}%" aria-valuenow="${sysDiskUsage}"
                                                             aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                    <div class="text-gray-400 fs-8 mt-1 text-end">${sysDiskUsed}GB
                                                        / ${sysDiskTotal}GB
                                                    </div>
                                                </div>

                                                <div class="separator my-4"></div>

                                                <div class="d-flex flex-stack fs-7 text-gray-500">
                                                    <span>OS: ${sysOsName}</span>
                                                    <span>Java: ${sysJavaVer}</span>
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
        </div>
    </div>
    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
</body>
</html>