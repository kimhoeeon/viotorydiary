<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>이벤트 상세 | 승요일기 관리자</title>
    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/css/mngStyle.css" rel="stylesheet">
</head>
<body id="kt_app_body" data-kt-app-layout="dark-sidebar" data-kt-app-header-fixed="true"
      data-kt-app-sidebar-enabled="true" data-kt-app-sidebar-fixed="true" class="app-default">

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
                                        <div class="card-title m-0"><h3 class="fw-bold m-0">이벤트 상세</h3></div>
                                    </div>
                                    <div class="card-body p-9">
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">제목</label>
                                            <div class="col-lg-10"><span
                                                    class="fw-bold fs-6 text-gray-800">${event.title}</span></div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">기간</label>
                                            <div class="col-lg-4"><span
                                                    class="fw-bold fs-6 text-gray-800">${event.startDate} ~ ${event.endDate}</span>
                                            </div>
                                            <label class="col-lg-2 fw-semibold text-muted">상태</label>
                                            <div class="col-lg-4">
                                                <c:if test="${event.status eq 'ACTIVE'}"><span
                                                        class="badge badge-light-success">진행중</span></c:if>
                                                <c:if test="${event.status eq 'INACTIVE'}"><span
                                                        class="badge badge-light-secondary">종료</span></c:if>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">이미지/링크</label>
                                            <div class="col-lg-10">
                                                <div class="d-flex flex-column">
                                                    <span class="text-gray-600 fs-7 mb-1">IMG: ${event.imageUrl}</span>
                                                    <span class="text-gray-600 fs-7">LINK: <a href="${event.linkUrl}"
                                                                                              target="_blank">${event.linkUrl}</a></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">내용</label>
                                            <div class="col-lg-10">
                                                <div class="p-4 bg-light rounded text-gray-800 fs-6"
                                                     style="white-space: pre-wrap;">${event.content}</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-footer d-flex justify-content-end py-6 px-9">
                                        <a href="/mng/content/events" class="btn btn-light btn-active-light-primary me-2">목록으로</a>
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

    <div class="modal fade" id="eventModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-650px">
            <div class="modal-content">
                <form id="eventForm" action="/mng/content/events/save" method="post">
                    <input type="hidden" name="eventId" value="${event.eventId}">
                    <div class="modal-header">
                        <h2 class="fw-bold">이벤트 수정</h2>
                        <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal"><i
                                class="ki-duotone ki-cross fs-1"><span class="path1"></span><span class="path2"></span></i>
                        </div>
                    </div>
                    <div class="modal-body py-10 px-lg-17">
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">제목</label>
                            <input type="text" class="form-control form-control-solid" name="title" value="${event.title}"
                                   required/>
                        </div>
                        <div class="row mb-7">
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">시작일</label>
                                <input type="date" class="form-control form-control-solid" name="startDate"
                                       value="${event.startDate}" required/>
                            </div>
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">종료일</label>
                                <input type="date" class="form-control form-control-solid" name="endDate"
                                       value="${event.endDate}" required/>
                            </div>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">이미지 URL</label>
                            <input type="text" class="form-control form-control-solid" name="imageUrl"
                                   value="${event.imageUrl}"/>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">링크 URL</label>
                            <input type="text" class="form-control form-control-solid" name="linkUrl"
                                   value="${event.linkUrl}"/>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">상태</label>
                            <select class="form-select form-select-solid" name="status">
                                <option value="ACTIVE" ${event.status eq 'ACTIVE' ? 'selected' : ''}>진행중</option>
                                <option value="INACTIVE" ${event.status eq 'INACTIVE' ? 'selected' : ''}>종료</option>
                            </select>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">내용</label>
                            <textarea class="form-control form-control-solid" name="content"
                                      rows="3">${event.content}</textarea>
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
        const modal = new bootstrap.Modal(document.getElementById('eventModal'));

        function openEditModal() {
            modal.show();
        }
    </script>
</body>
</html>