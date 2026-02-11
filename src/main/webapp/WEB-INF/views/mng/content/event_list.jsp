<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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

    <title>이벤트 관리 | 승요일기 관리자</title>
    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/css/mngStyle.css" rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
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
                                        이벤트 관리
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
                                        <li class="breadcrumb-item text-dark">이벤트 관리</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-7">
                                    <div class="card-body py-4">
                                        <div class="d-flex align-items-center justify-content-between">
                                            <h3 class="card-title m-0">🎉 이벤트 목록</h3>
                                            <button type="button" class="btn btn-primary" onclick="openModal()">
                                                <i class="ki-duotone ki-plus fs-2"></i> 이벤트 등록
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-body py-4">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5">
                                                <thead>
                                                <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                    <th class="min-w-50px">No</th>
                                                    <th class="min-w-200px">제목</th>
                                                    <th class="min-w-150px">기간</th>
                                                    <th class="min-w-100px">상태</th>
                                                    <th class="min-w-100px">등록일</th>
                                                    <th class="text-end min-w-100px">관리</th>
                                                </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                <c:forEach var="item" items="${events}">
                                                    <tr>
                                                        <td>${item.eventId}</td>
                                                        <td>
                                                            <span class="text-gray-800 fw-bold d-block mb-1 fs-6">${item.title}</span>
                                                            <span class="text-gray-400 fs-7 d-block text-truncate"
                                                                  style="max-width: 200px;">${item.linkUrl}</span>
                                                        </td>
                                                        <td>${item.startDate} ~ ${item.endDate}</td>
                                                        <td>
                                                            <c:if test="${item.status eq 'ACTIVE'}"><span
                                                                    class="badge badge-light-success">진행중</span></c:if>
                                                            <c:if test="${item.status eq 'INACTIVE'}"><span
                                                                    class="badge badge-light-secondary">종료</span></c:if>
                                                        </td>
                                                        <td>
                                                            <fmt:parseDate value="${item.createdAt}"
                                                                           pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate"
                                                                           type="both"/>
                                                            <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd"/>
                                                        </td>
                                                        <td class="text-end">
                                                            <a href="#"
                                                               class="btn btn-light btn-active-light-primary btn-sm"
                                                               data-kt-menu-trigger="click"
                                                               data-kt-menu-placement="bottom-end">
                                                                관리 <i class="ki-duotone ki-down fs-5 m-0"></i>
                                                            </a>
                                                            <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-125px py-4"
                                                                 data-kt-menu="true">
                                                                <div class="menu-item px-3">
                                                                    <a href="/mng/content/events/detail?eventId=${item.eventId}"
                                                                       class="menu-link px-3">상세정보</a>
                                                                </div>
                                                                <div class="menu-item px-3">
                                                                    <a href="#" class="menu-link px-3 text-danger"
                                                                       onclick="deleteEvent('${item.eventId}'); return false;">삭제</a>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty events}">
                                                    <tr>
                                                        <td colspan="6" class="text-center py-10">등록된 이벤트가 없습니다.</td>
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

    <div class="modal fade" id="eventModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-800px">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="fw-bold" id="modalTitle">이벤트 등록</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <span class="svg-icon svg-icon-1"><i class="bi bi-x-lg"></i></span>
                    </div>
                </div>

                <form id="eventForm" action="/mng/content/events/save" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="eventId" id="eventId">

                    <div class="modal-body py-10 px-lg-17">
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">제목</label>
                            <input type="text" class="form-control form-control-solid" name="title" id="title" required />
                        </div>

                        <div class="row mb-7">
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">시작일</label>
                                <input type="date" class="form-control form-control-solid" name="startDate" id="startDate" required />
                            </div>
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">종료일</label>
                                <input type="date" class="form-control form-control-solid" name="endDate" id="endDate" required />
                            </div>
                        </div>

                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">대표 썸네일 이미지</label>
                            <input type="file" name="thumbnailFile" class="form-control form-control-solid" accept="image/*"/>
                            <div class="form-text text-muted">목록에 노출될 대표 이미지를 등록해주세요. (미등록 시 기존 이미지 유지)</div>
                        </div>

                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">내용</label>
                            <textarea name="content" id="content"></textarea>
                        </div>

                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">상태</label>
                            <select name="status" id="status" class="form-select form-select-solid">
                                <option value="ACTIVE">진행중 (ACTIVE)</option>
                                <option value="INACTIVE">종료 (INACTIVE)</option>
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
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>
    <script src="/js/summernote.js"></script>
    <script>
        // 1. Summernote 초기화
        $(document).ready(function() {
            initSummernote('#content', 500);
        });

        const modalEl = document.getElementById('eventModal');
        const modal = new bootstrap.Modal(modalEl);

        // 2. 등록 모달 열기
        function openModal() {
            document.getElementById('eventForm').reset();
            document.getElementById('eventId').value = '';
            document.getElementById('modalTitle').innerText = '이벤트 등록';

            // 에디터 초기화
            $('#content').summernote('reset');

            modal.show();
        }

        // 3. 수정 모달 열기 (데이터 바인딩)
        function openModifyModal(id) {
            $.get('/mng/content/events/get?eventId=' + id, function(data) {
                document.getElementById('eventId').value = data.eventId;
                document.getElementById('title').value = data.title;
                document.getElementById('startDate').value = data.startDate;
                document.getElementById('endDate').value = data.endDate;
                document.getElementById('status').value = data.status;

                // [중요] Summernote 내용 삽입
                $('#content').summernote('code', data.content);

                document.getElementById('modalTitle').innerText = '이벤트 수정';
                modal.show();
            });
        }

        function deleteEvent(id) {
            if (confirm('정말 삭제하시겠습니까?')) {
                $.post('/mng/content/events/delete', {eventId: id}, function (res) {
                    if (res === 'ok') location.reload();
                    else alert('삭제 실패');
                });
            }
        }
    </script>
</body>
</html>