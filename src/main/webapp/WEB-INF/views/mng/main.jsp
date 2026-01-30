<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
<%--@elvariable id="sysActiveThreads" type="java.lang.Integer"--%>
<%--@elvariable id="sysCpuCores" type="java.lang.Integer"--%>
<%--@elvariable id="sysOsName" type="java.lang.String"--%>
<%--@elvariable id="sysJavaVer" type="java.lang.String"--%>
<%--@elvariable id="todayGameList" type="java.util.List<com.viotory.diary.vo.GameVO>"--%>

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

                                        <div class="card card-flush mb-5 mb-xl-10" style="min-height: 180px;">

                                            <div class="card-header pt-5">
                                                <h3 class="card-title align-items-center">
                                                    <span class="card-label fw-bold text-gray-900 fs-3">Today's Match</span>
                                                    <span class="text-gray-400 mt-1 fw-semibold fs-7">
                                                        <span class="badge badge-light-primary fw-bold px-2 py-1 me-1">
                                                            ${empty todayGameList ? 0 : todayGameList.size()} Games
                                                        </span>
                                                    </span>
                                                </h3>

                                                <div class="card-toolbar">
                                                    <c:if test="${not empty todayGameList and todayGameList.size() > 1}">
                                                        <div class="d-flex align-items-center">
                                                            <button class="btn btn-icon btn-sm btn-light-primary me-2" type="button" id="btn-prev-game">
                                                                <i class="ki-duotone ki-arrow-left fs-2">
                                                                    <span class="path1"></span>
                                                                    <span class="path2"></span>
                                                                </i>
                                                            </button>
                                                            <button class="btn btn-icon btn-sm btn-light-primary" type="button" id="btn-next-game">
                                                                <i class="ki-duotone ki-arrow-right fs-2">
                                                                    <span class="path1"></span>
                                                                    <span class="path2"></span>
                                                                </i>
                                                            </button>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <div class="card-body d-flex flex-column justify-content-center align-items-center">
                                                <c:choose>
                                                    <c:when test="${empty todayGameList}">
                                                        <div class="d-flex flex-column align-items-center mb-5">
                                                            <i class="ki-duotone ki-calendar-remove fs-1 text-gray-300 mb-2">
                                                                <span class="path1"></span>
                                                                <span class="path2"></span>
                                                                <span class="path3"></span>
                                                                <span class="path4"></span>
                                                                <span class="path5"></span>
                                                                <span class="path6"></span>
                                                            </i>
                                                            <span class="fs-5 fw-bold text-gray-400">금일 경기 일정이 없습니다</span>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div id="kt_game_carousel" class="carousel slide w-100" data-bs-ride="carousel" data-bs-interval="4000">
                                                            <div class="carousel-inner">
                                                                <c:forEach var="game" items="${todayGameList}" varStatus="status">
                                                                    <div class="carousel-item ${status.first ? 'active' : ''}">
                                                                        <div class="d-flex flex-column align-items-center justify-content-center">

                                                                            <div class="mb-3 d-flex align-items-center">
                                                                                <span class="badge badge-outline badge-dark fw-bold me-2">
                                                                                    <c:out value="${game.gameTime}"/>
                                                                                </span>
                                                                                <span class="badge badge-light text-muted fs-7 me-2">${game.stadiumName}</span>
                                                                                <c:choose>
                                                                                    <c:when test="${game.status eq 'LIVE'}">
                                                                                        <span class="badge badge-danger animation-blink">LIVE</span>
                                                                                    </c:when>
                                                                                    <c:when test="${game.status eq 'FINISHED'}">
                                                                                        <span class="badge badge-secondary">종료</span>
                                                                                    </c:when>
                                                                                    <c:when test="${game.status eq 'CANCELLED'}">
                                                                                        <span class="badge badge-warning">취소</span>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span class="badge badge-success">예정</span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>

                                                                            <div class="d-flex align-items-center justify-content-center w-100 px-5">
                                                                                <div class="d-flex align-items-center justify-content-end" style="width: 40%;">
                                                                                    <span class="fs-2x fw-bolder text-gray-800 me-3 text-truncate">${game.homeTeamName}</span>
                                                                                </div>
                                                                                <div class="d-flex flex-column align-items-center justify-content-center mx-3" style="width: 20%; min-width: 100px;">
                                                                                    <c:choose>
                                                                                        <c:when test="${game.status eq 'LIVE' or game.status eq 'FINISHED'}">
                                                                                            <div class="d-flex align-items-center justify-content-center">
                                                                                                <span class="fs-1 fw-bolder text-primary">${game.scoreHome}</span>
                                                                                                <span class="fs-3 text-gray-400 mx-2">:</span>
                                                                                                <span class="fs-1 fw-bolder text-primary">${game.scoreAway}</span>
                                                                                            </div>
                                                                                        </c:when>
                                                                                        <c:when test="${game.status eq 'CANCELLED'}">
                                                                                            <span class="fs-4 fw-bold text-gray-400">CANCELED</span>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <span class="fs-1 fw-bold text-gray-300">VS</span>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </div>
                                                                                <div class="d-flex align-items-center justify-content-start" style="width: 40%;">
                                                                                    <span class="fs-2x fw-bolder text-gray-800 ms-3 text-truncate">${game.awayTeamName}</span>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </div>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="row g-5 g-xl-10 mb-5 mb-xl-0">
                                            <div class="col-md-6">
                                                <div class="card card-flush mb-5 mb-xl-10" style="min-height: 150px; justify-content: center;">
                                                    <div class="card-header pt-5 pb-5">
                                                        <div class="card-title d-flex flex-column">
                                                            <div class="d-flex align-items-center">
                                                                <span class="fs-2hx fw-bold text-gray-900 me-2 lh-1 ls-n2">
                                                                    <fmt:formatNumber value="${totalMembers}" pattern="#,###"/>
                                                                </span>
                                                                <span class="badge badge-light-primary fs-base ms-2">
                                                                    <i class="ki-duotone ki-user fs-5 text-primary ms-n1">
                                                                        <span class="path1"></span>
                                                                        <span class="path2"></span>
                                                                    </i> Total
                                                                </span>
                                                            </div>
                                                            <span class="text-gray-500 pt-1 fw-semibold fs-6">전체 회원 수</span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="card card-flush mb-5 mb-xl-0" style="min-height: 150px; justify-content: center;">
                                                    <div class="card-header pt-5 pb-5">
                                                        <div class="card-title d-flex flex-column">
                                                            <div class="d-flex align-items-center">
                                                                <span class="fs-2hx fw-bold text-gray-900 me-2 lh-1 ls-n2">
                                                                    <fmt:formatNumber value="${todayMembers}" pattern="#,###"/>
                                                                </span>
                                                                <span class="badge badge-light-success fs-base ms-2">
                                                                    <i class="ki-duotone ki-arrow-up fs-5 text-success ms-n1">
                                                                        <span class="path1"></span>
                                                                        <span class="path2"></span>
                                                                    </i> New
                                                                </span>
                                                            </div>
                                                            <span class="text-gray-500 pt-1 fw-semibold fs-6">금일 가입자</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="card card-flush mb-5 mb-xl-10" style="min-height: 150px; justify-content: center;">
                                                    <div class="card-header pt-5 pb-5">
                                                        <div class="card-title d-flex flex-column">
                                                            <div class="d-flex align-items-center">
                                                                <span class="fs-2hx fw-bold text-gray-900 me-2 lh-1 ls-n2">
                                                                    <fmt:formatNumber value="${totalDiaries}" pattern="#,###"/>
                                                                </span>
                                                                <span class="badge badge-light-info fs-base ms-2">
                                                                    <i class="ki-duotone ki-note-2 fs-5 text-info ms-n1">
                                                                        <span class="path1"></span>
                                                                        <span class="path2"></span>
                                                                    </i> Total
                                                                </span>
                                                            </div>
                                                            <span class="text-gray-500 pt-1 fw-semibold fs-6">누적 일기 수</span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="card card-flush mb-5 mb-xl-0" style="min-height: 150px; justify-content: center;">
                                                    <div class="card-header pt-5 pb-5">
                                                        <div class="card-title d-flex flex-column">
                                                            <div class="d-flex align-items-center">
                                                                <span class="fs-2hx fw-bold text-gray-900 me-2 lh-1 ls-n2">
                                                                    <fmt:formatNumber value="${todayDiaries}" pattern="#,###"/>
                                                                </span>
                                                                <span class="badge badge-light-danger fs-base ms-2">
                                                                    <i class="ki-duotone ki-pencil fs-5 text-danger ms-n1">
                                                                        <span class="path1"></span>
                                                                        <span class="path2"></span>
                                                                    </i> Today
                                                                </span>
                                                            </div>
                                                            <span class="text-gray-500 pt-1 fw-semibold fs-6">금일 작성 일기</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-xl-4">
                                        <div class="card h-100">
                                            <div class="card-header border-0 pt-5">
                                                <h3 class="card-title align-items-start flex-column">
                                                    <span class="card-label fw-bold text-gray-900">System Status</span>
                                                    <span class="text-muted mt-1 fw-semibold fs-7">서버 리소스 모니터링</span>
                                                </h3>
                                                <div class="card-toolbar">
                                                    <button class="btn btn-sm btn-icon btn-color-primary btn-active-light-primary" onclick="location.reload()" title="새로고침">
                                                        <i class="ki-duotone ki-arrows-circle fs-2">
                                                            <span class="path1"></span>
                                                            <span class="path2"></span>
                                                        </i>
                                                    </button>
                                                </div>
                                            </div>

                                            <div class="card-body pt-5">
                                                <div class="d-flex align-items-center bg-light-primary rounded p-4 mb-7">
                                                    <span class="svg-icon svg-icon-1 svg-icon-primary me-4">
                                                        <i class="ki-duotone ki-time fs-2x text-primary">
                                                            <span class="path1"></span>
                                                            <span class="path2"></span>
                                                        </i>
                                                    </span>
                                                    <div class="d-flex flex-column flex-grow-1 me-2">
                                                        <span class="fw-bold text-gray-800 fs-6 mb-1">Server Time</span>
                                                        <jsp:useBean id="now" class="java.util.Date"/>
                                                        <span class="text-muted fw-semibold fs-7">
                                                            <fmt:formatDate value="${now}" pattern="yyyy-MM-dd (E)"/>
                                                        </span>
                                                    </div>
                                                    <span class="fw-bolder text-primary fs-2">
                                                        <fmt:formatDate value="${now}" pattern="HH:mm"/>
                                                    </span>
                                                </div>

                                                <div class="d-flex align-items-center mb-8">
                                                    <div class="symbol symbol-50px me-5">
                                                        <span class="symbol-label bg-light-success">
                                                            <i class="ki-duotone ki-cloud fs-2x text-success"></i>
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

                                                <div class="d-flex flex-stack mb-8">
                                                    <div class="d-flex align-items-center me-5">
                                                        <div class="symbol symbol-50px me-5">
                                                            <span class="symbol-label bg-light-warning">
                                                                <i class="ki-duotone ki-abstract-26 fs-2x text-warning">
                                                                    <span class="path1"></span>
                                                                    <span class="path2"></span>
                                                                </i>
                                                            </span>
                                                        </div>
                                                        <div class="d-flex flex-column">
                                                            <span class="text-gray-800 fw-bold fs-6">Threads</span>
                                                            <span class="text-muted fw-semibold fs-7">${sysActiveThreads} EA</span>
                                                        </div>
                                                    </div>
                                                    <div class="d-flex align-items-center">
                                                        <div class="d-flex flex-column text-end">
                                                            <span class="text-gray-800 fw-bold fs-6">CPU Cores</span>
                                                            <span class="text-muted fw-semibold fs-7">${sysCpuCores} Core</span>
                                                        </div>
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
                                                    <div class="text-gray-400 fs-8 mt-1 text-end">
                                                        ${sysMemoryUsed}MB / ${sysMemoryTotal}MB
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
                                                    <div class="text-gray-400 fs-8 mt-1 text-end">
                                                        ${sysDiskUsed}GB / ${sysDiskTotal}GB
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

                                <div class="row g-5 g-xl-10 mb-5 mb-xl-10">
                                    <div class="col-xl-12">
                                        <div class="card card-flush h-xl-100">
                                            <div class="card-header pt-7">
                                                <h3 class="card-title align-items-start flex-column">
                                                    <span class="card-label fw-bold text-gray-900">주간 접속 통계</span>
                                                    <span class="text-gray-400 mt-1 fw-semibold fs-6">최근 7일간의 방문자 추이</span>
                                                </h3>
                                            </div>
                                            <div class="card-body pt-5">
                                                <div id="kt_charts_widget_1_chart" class="min-h-auto ps-4 pe-6 mb-3" style="height: 350px"></div>
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

    <script>
        // [1] 경기 일정 Carousel 버튼 바인딩
        $(document).ready(function () {
            var carouselEl = document.querySelector('#kt_game_carousel');
            if (carouselEl) {
                var carousel = new bootstrap.Carousel(carouselEl);

                $('#btn-prev-game').on('click', function () {
                    carousel.prev();
                });

                $('#btn-next-game').on('click', function () {
                    carousel.next();
                });
            }
        });

        // [2] 차트 초기화 스크립트
        var KTChartsWidget1 = function () {
            var chart = {
                self: null,
                rendered: false
            };

            var initChart = function (chart) {
                var element = document.getElementById("kt_charts_widget_1_chart");

                if (!element) {
                    return;
                }

                var height = parseInt(KTUtil.css(element, 'height'));
                var labelColor = KTUtil.getCssVariableValue('--bs-gray-500');
                var borderColor = KTUtil.getCssVariableValue('--bs-gray-200');
                var baseColor = KTUtil.getCssVariableValue('--bs-primary');
                var secondaryColor = KTUtil.getCssVariableValue('--bs-gray-300');

                var options = {
                    series: [{
                        name: '방문자 수',
                        data: [30, 40, 45, 50, 49, 60, 70]
                    }],
                    chart: {
                        fontFamily: 'inherit',
                        type: 'area',
                        height: height,
                        toolbar: {
                            show: false
                        }
                    },
                    plotOptions: {
                        bar: {
                            horizontal: false,
                            columnWidth: '30%',
                            borderRadius: 5
                        }
                    },
                    legend: {
                        show: false
                    },
                    dataLabels: {
                        enabled: false
                    },
                    stroke: {
                        curve: 'smooth',
                        show: true,
                        width: 3,
                        colors: [baseColor]
                    },
                    xaxis: {
                        categories: ['월', '화', '수', '목', '금', '토', '일'],
                        axisBorder: {
                            show: false,
                        },
                        axisTicks: {
                            show: false
                        },
                        labels: {
                            style: {
                                colors: labelColor,
                                fontSize: '12px'
                            }
                        }
                    },
                    yaxis: {
                        labels: {
                            style: {
                                colors: labelColor,
                                fontSize: '12px'
                            }
                        }
                    },
                    fill: {
                        type: 'gradient',
                        gradient: {
                            shadeIntensity: 1,
                            opacityFrom: 0.7,
                            opacityTo: 0.9,
                            stops: [0, 90, 100]
                        }
                    },
                    colors: [baseColor],
                    grid: {
                        borderColor: borderColor,
                        strokeDashArray: 4,
                        yaxis: {
                            lines: {
                                show: true
                            }
                        }
                    }
                };

                chart.self = new ApexCharts(element, options);
                chart.self.render();
                chart.rendered = true;
            }

            return {
                init: function () {
                    initChart(chart);

                    KTThemeMode.on("kt.thememode.change", function () {
                        if (chart.rendered) {
                            chart.self.destroy();
                        }
                        initChart(chart);
                    });
                }
            }
        }();

        if (typeof KTChartsWidget1 !== 'undefined') {
            KTChartsWidget1.init();
        }
    </script>
</body>
</html>