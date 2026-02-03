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

    <title>콘텐츠 상세 | 승요일기 관리자</title>
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
                                        구단 콘텐츠 관리
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">콘텐츠 관리</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">구단 콘텐츠 관리</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-header border-0 cursor-pointer">
                                        <div class="card-title m-0"><h3 class="fw-bold m-0">구단 콘텐츠 상세</h3></div>
                                    </div>
                                    <div class="card-body p-9">
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">이미지</label>
                                            <div class="col-lg-10">
                                                <c:if test="${not empty content.imageUrl}">
                                                    <img src="/upload/${content.imageUrl}" class="rounded w-150px h-150px" style="object-fit:cover; border:1px solid #eee;" />
                                                </c:if>
                                                <c:if test="${empty content.imageUrl}">
                                                    <span class="text-gray-400">등록된 이미지가 없습니다.</span>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">구단</label>
                                            <div class="col-lg-4">
                                                <span class="badge badge-light-primary fw-bold fs-6">${content.teamCode}</span>
                                            </div>
                                            <label class="col-lg-2 fw-semibold text-muted">정렬 순서</label>
                                            <div class="col-lg-4">
                                                <span class="fw-bold fs-6 text-gray-800">${content.sortOrder}</span>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">제목</label>
                                            <div class="col-lg-10">
                                                <span class="fw-bold fs-6 text-gray-800">${content.title}</span>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">URL</label>
                                            <div class="col-lg-10">
                                                <a href="${content.contentUrl}" target="_blank" class="text-primary fw-semibold fs-6">${content.contentUrl}</a>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">상태</label>
                                            <div class="col-lg-4">
                                                <c:if test="${content.status eq 'ACTIVE'}">
                                                    <span class="badge badge-light-success">노출</span>
                                                </c:if>
                                                <c:if test="${content.status eq 'INACTIVE'}">
                                                    <span class="badge badge-light-secondary">숨김</span>
                                                </c:if>
                                            </div>
                                            <label class="col-lg-2 fw-semibold text-muted">조회수</label>
                                            <div class="col-lg-4">
                                                <span class="fw-bold fs-6 text-gray-800">${content.clickCount}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-footer d-flex justify-content-end py-6 px-9">
                                        <a href="/mng/content/teams" class="btn btn-light btn-active-light-primary me-2">목록으로</a>
                                        <button type="button" class="btn btn-primary" onclick="openEditModal()">수정하기
                                        </button>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="teamModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-650px">
            <div class="modal-content">
                <form id="teamForm" action="/mng/content/teams/save" method="post">
                    <input type="hidden" name="contentId" value="${content.contentId}">
                    <div class="modal-header">
                        <h2 class="fw-bold">콘텐츠 수정</h2>
                        <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                            <i class="ki-duotone ki-cross fs-1">
                                <span class="path1"></span>
                                <span class="path2"></span>
                            </i>
                        </div>
                    </div>
                    <div class="modal-body py-10 px-lg-17">
                        <div class="row mb-7">
                            <div class="col-md-8">
                                <label class="required fs-6 fw-semibold mb-2">구단 코드</label>
                                <select class="form-select form-select-solid" name="teamCode">
                                    <option value="LG" ${content.teamCode eq 'LG' ? 'selected' : ''}>LG 트윈스</option>
                                    <option value="KT" ${content.teamCode eq 'KT' ? 'selected' : ''}>KT 위즈</option>
                                    <option value="SSG" ${content.teamCode eq 'SSG' ? 'selected' : ''}>SSG 랜더스</option>
                                    <option value="NC" ${content.teamCode eq 'NC' ? 'selected' : ''}>NC 다이노스</option>
                                    <option value="DOOSAN" ${content.teamCode eq 'DOOSAN' ? 'selected' : ''}>두산 베어스</option>
                                    <option value="KIA" ${content.teamCode eq 'KIA' ? 'selected' : ''}>KIA 타이거즈</option>
                                    <option value="LOTTE" ${content.teamCode eq 'LOTTE' ? 'selected' : ''}>롯데 자이언츠</option>
                                    <option value="SAMSUNG" ${content.teamCode eq 'SAMSUNG' ? 'selected' : ''}>삼성 라이온즈</option>
                                    <option value="HANWHA" ${content.teamCode eq 'HANWHA' ? 'selected' : ''}>한화 이글스</option>
                                    <option value="KIWOOM" ${content.teamCode eq 'KIWOOM' ? 'selected' : ''}>키움 히어로즈</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="fs-6 fw-semibold mb-2">정렬 순서</label>
                                <input type="number" class="form-control form-control-solid" name="sortOrder" value="${content.sortOrder}"/>
                            </div>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">제목</label>
                            <input type="text" class="form-control form-control-solid" name="title" value="${content.title}" required/>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">이미지 변경</label>
                            <input type="file" class="form-control form-control-solid" name="file" accept="image/*"/>
                            <div class="form-text">변경 시에만 선택하세요. (10MB 이하)</div>
                            <c:if test="${not empty content.imageUrl}">
                                <div class="mt-2">
                                    <span class="badge badge-light-info">현재 파일: ${content.imageUrl}</span>
                                </div>
                            </c:if>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">콘텐츠 URL</label>
                            <input type="text" class="form-control form-control-solid" name="contentUrl" value="${content.contentUrl}" required/>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">상태</label>
                            <select class="form-select form-select-solid" name="status">
                                <option value="ACTIVE" ${content.status eq 'ACTIVE' ? 'selected' : ''}>노출</option>
                                <option value="INACTIVE" ${content.status eq 'INACTIVE' ? 'selected' : ''}>숨김</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer flex-center">
                        <button type="button" class="btn btn-light me-3" data-bs-dismiss="modal">취소</button>
                        <button type="submit" class="btn btn-primary">저장</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script>
        const modal = new bootstrap.Modal(document.getElementById('teamModal'));
        function openEditModal() {
            modal.show();
        }
    </script>
</body>
</html>