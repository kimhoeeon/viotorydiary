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

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <title>멘트 상세 | 승요일기 관리자</title>
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

                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-header border-0 cursor-pointer">
                                        <div class="card-title m-0"><h3 class="fw-bold m-0">승요 멘트 상세</h3></div>
                                    </div>
                                    <div class="card-body p-9">
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">카테고리</label>
                                            <div class="col-lg-4"><span
                                                    class="badge badge-light-primary fw-bold fs-6">${mention.category}</span>
                                            </div>
                                            <label class="col-lg-2 fw-semibold text-muted">조건 코드</label>
                                            <div class="col-lg-4"><span
                                                    class="fw-bold fs-6 text-gray-800">${mention.conditionCode}</span></div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">우선순위</label>
                                            <div class="col-lg-4"><span
                                                    class="badge badge-light-warning fw-bold">${mention.priority}</span>
                                            </div>
                                            <label class="col-lg-2 fw-semibold text-muted">설명</label>
                                            <div class="col-lg-4"><span
                                                    class="fw-bold fs-6 text-gray-800">${mention.description}</span></div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">멘트 내용</label>
                                            <div class="col-lg-10">
                                                <div class="p-4 bg-light rounded text-gray-800 fs-6"
                                                     style="white-space: pre-wrap;">${mention.message}</div>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">최종 수정일</label>
                                            <div class="col-lg-4">
                                                <span class="fw-bold fs-6 text-gray-800">
                                                    <fmt:parseDate value="${mention.updatedAt}"
                                                                   pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate"
                                                                   type="both"/>
                                                    <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-footer d-flex justify-content-end py-6 px-9">
                                        <a href="/mng/winyo/mentions" class="btn btn-light btn-active-light-primary me-2">목록으로</a>
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

    <div class="modal fade" id="mentionModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-650px">
            <div class="modal-content">
                <form id="mentionForm" action="/mng/winyo/mention/save" method="post">
                    <input type="hidden" name="mentionId" value="${mention.mentionId}">
                    <div class="modal-header">
                        <h2 class="fw-bold">멘트 수정</h2>
                        <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal"><i
                                class="ki-duotone ki-cross fs-1"><span class="path1"></span><span class="path2"></span></i>
                        </div>
                    </div>
                    <div class="modal-body py-10 px-lg-17">
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">카테고리</label>
                            <select class="form-select form-select-solid" name="category">
                                <option value="WIN_RATE" ${mention.category eq 'WIN_RATE' ? 'selected' : ''}>승률</option>
                                <option value="ATTENDANCE_COUNT" ${mention.category eq 'ATTENDANCE_COUNT' ? 'selected' : ''}>
                                    직관수
                                </option>
                                <option value="RECENT_TREND" ${mention.category eq 'RECENT_TREND' ? 'selected' : ''}>최근흐름
                                </option>
                            </select>
                        </div>
                        <div class="row mb-7">
                            <div class="col-md-8">
                                <label class="required fs-6 fw-semibold mb-2">조건 코드</label>
                                <input type="text" class="form-control form-control-solid" name="conditionCode"
                                       value="${mention.conditionCode}"/>
                            </div>
                            <div class="col-md-4">
                                <label class="required fs-6 fw-semibold mb-2">우선순위</label>
                                <input type="number" class="form-control form-control-solid" name="priority"
                                       value="${mention.priority}"/>
                            </div>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">설명</label>
                            <input type="text" class="form-control form-control-solid" name="description"
                                   value="${mention.description}"/>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">멘트 내용</label>
                            <textarea class="form-control form-control-solid" name="message"
                                      rows="3">${mention.message}</textarea>
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
        const modal = new bootstrap.Modal(document.getElementById('mentionModal'));

        function openEditModal() {
            modal.show();
        }
    </script>
</body>
</html>