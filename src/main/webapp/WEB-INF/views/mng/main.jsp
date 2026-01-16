<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>관리자 메인 | Viotory Admin</title>
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
                                                <span class="svg-icon svg-icon-2x svg-icon-warning me-4">
                                                    <i class="ki-duotone ki-security-user fs-1">
                                                        <span class="path1"></span>
                                                        <span class="path2"></span>
                                                    </i>
                                                </span>
                                                <div class="d-flex flex-column">
                                                    <h3 class="fs-4 fw-bold mb-1 text-gray-900">관리자 계정 관리 (Super Admin Only)</h3>
                                                    <span class="fs-7 fw-semibold text-gray-600">운영자 및 발주사 계정 생성, IP 및 권한을 설정할 수 있습니다.</span>
                                                </div>
                                            </div>
                                            <div>
                                                <a href="/mng/system/admin/list" class="btn btn-sm btn-warning fw-bold">
                                                    <i class="ki-duotone ki-setting-2 fs-2 me-1">
                                                        <span class="path1"></span>
                                                        <span class="path2"></span>
                                                    </i> 계정 관리 바로가기
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <div class="row g-5 g-xl-10 mb-5 mb-xl-10">

                                    <div class="col-md-6 col-lg-6 col-xl-6 col-xxl-3 mb-md-5 mb-xl-10">
                                        <div class="card card-flush h-md-50 mb-5 mb-xl-10">
                                            <div class="card-header pt-5">
                                                <div class="card-title d-flex flex-column">
                                                    <span class="fs-2hx fw-bold text-dark me-2 lh-1 ls-n2">${totalMembers}</span>
                                                    <span class="text-gray-400 pt-1 fw-semibold fs-6">전체 회원 수</span>
                                                </div>
                                            </div>
                                            <div class="card-body pt-2 pb-4 d-flex align-items-center">
                                                <div class="d-flex flex-center me-5 pt-2">
                                                    <div id="kt_card_widget_17_chart"
                                                         style="min-width: 70px; min-height: 70px" data-kt-size="70"
                                                         data-kt-line="11">
                                                        <i class="ki-duotone ki-people fs-2tx text-primary"><span
                                                                class="path1"></span><span class="path2"></span><span
                                                                class="path3"></span><span class="path4"></span><span
                                                                class="path5"></span></i>
                                                    </div>
                                                </div>
                                                <div class="d-flex flex-column content-justify-center w-100">
                                                    <div class="d-flex fs-6 fw-semibold align-items-center">
                                                        <div class="bullet w-8px h-3px rounded-2 bg-success me-3"></div>
                                                        <div class="text-gray-500 flex-grow-1 me-4">오늘 가입</div>
                                                        <div class="fw-bolder text-gray-700 text-xxl-end">
                                                            +${todayMembers}</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6 col-lg-6 col-xl-6 col-xxl-3 mb-md-5 mb-xl-10">
                                        <div class="card card-flush h-md-50 mb-5 mb-xl-10">
                                            <div class="card-header pt-5">
                                                <div class="card-title d-flex flex-column">
                                                    <span class="fs-2hx fw-bold text-dark me-2 lh-1 ls-n2">${totalDiaries}</span>
                                                    <span class="text-gray-400 pt-1 fw-semibold fs-6">누적 일기 수</span>
                                                </div>
                                            </div>
                                            <div class="card-body pt-2 pb-4 d-flex align-items-center">
                                                <div class="d-flex flex-center me-5 pt-2">
                                                    <i class="ki-duotone ki-book-open fs-2tx text-success"><span
                                                            class="path1"></span><span class="path2"></span><span
                                                            class="path3"></span><span class="path4"></span></i>
                                                </div>
                                                <div class="d-flex flex-column content-justify-center w-100">
                                                    <div class="d-flex fs-6 fw-semibold align-items-center">
                                                        <div class="bullet w-8px h-3px rounded-2 bg-danger me-3"></div>
                                                        <div class="text-gray-500 flex-grow-1 me-4">오늘 작성</div>
                                                        <div class="fw-bolder text-gray-700 text-xxl-end">
                                                            +${todayDiaries}</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6 col-lg-6 col-xl-6 col-xxl-3 mb-md-5 mb-xl-10">
                                        <div class="card card-flush h-md-50 mb-5 mb-xl-10">
                                            <div class="card-header pt-5">
                                                <div class="card-title d-flex flex-column">
                                                    <span class="fs-2hx fw-bold text-dark me-2 lh-1 ls-n2">${todayGames}</span>
                                                    <span class="text-gray-400 pt-1 fw-semibold fs-6">오늘 예정 경기</span>
                                                </div>
                                            </div>
                                            <div class="card-body pt-2 pb-4 d-flex align-items-center">
                                                <div class="d-flex flex-center me-5 pt-2">
                                                    <i class="ki-duotone ki-calendar-tick fs-2tx text-warning"><span
                                                            class="path1"></span><span class="path2"></span><span
                                                            class="path3"></span></i>
                                                </div>
                                                <div class="d-flex flex-column content-justify-center w-100">
                                                    <div class="d-flex fs-6 fw-semibold align-items-center">
                                                        <div class="text-gray-500 flex-grow-1 me-4">데이터 관리 바로가기</div>
                                                        <a href="/mng/game/syncPage"
                                                           class="btn btn-sm btn-light-primary fw-bold">이동</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6 col-lg-6 col-xl-6 col-xxl-3 mb-md-5 mb-xl-10">
                                        <div class="card card-flush h-md-50 mb-5 mb-xl-10">
                                            <div class="card-header pt-5">
                                                <div class="card-title d-flex flex-column">
                                                    <span class="fs-2hx fw-bold text-dark me-2 lh-1 ls-n2">SYSTEM</span>
                                                    <span class="text-gray-400 pt-1 fw-semibold fs-6">상태</span>
                                                </div>
                                            </div>
                                            <div class="card-body pt-2 pb-4 d-flex align-items-center">
                                                <div class="d-flex flex-column content-justify-center w-100">
                                                    <div class="d-flex fs-6 fw-semibold align-items-center mb-3">
                                                        <div class="bullet w-8px h-3px rounded-2 bg-success me-3"></div>
                                                        <div class="text-gray-500 flex-grow-1 me-4">DB 상태</div>
                                                        <div class="fw-bolder text-success text-xxl-end">정상</div>
                                                    </div>
                                                    <div class="d-flex fs-6 fw-semibold align-items-center">
                                                        <div class="bullet w-8px h-3px rounded-2 bg-primary me-3"></div>
                                                        <div class="text-gray-500 flex-grow-1 me-4">관리자</div>
                                                        <div class="fw-bolder text-gray-700 text-xxl-end">${sessionScope.adminName}</div>
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
    </div>
    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
</c:if>
</body>
</html>