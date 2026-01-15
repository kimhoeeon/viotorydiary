<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>구단 콘텐츠 관리 | Viotory Admin</title>
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

                                <div class="card mb-7">
                                    <div class="card-body py-4">
                                        <div class="d-flex align-items-center justify-content-between">
                                            <h3 class="card-title m-0">🧢 구단별 콘텐츠 목록</h3>
                                            <button type="button" class="btn btn-primary" onclick="openModal()">
                                                <i class="ki-duotone ki-plus fs-2"></i> 콘텐츠 등록
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
                                                    <th class="min-w-50px">순서</th>
                                                    <th class="min-w-100px">구단코드</th>
                                                    <th class="min-w-200px">제목 / 링크</th>
                                                    <th class="min-w-100px">상태</th>
                                                    <th class="min-w-100px">조회수</th>
                                                    <th class="text-end min-w-100px">관리</th>
                                                </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                <c:forEach var="item" items="${contents}">
                                                    <tr>
                                                        <td>${item.sortOrder}</td>
                                                        <td><span class="badge badge-light-primary">${item.teamCode}</span>
                                                        </td>
                                                        <td>
                                                            <span class="text-gray-800 fw-bold d-block mb-1 fs-6">${item.title}</span>
                                                            <a href="${item.contentUrl}" target="_blank"
                                                               class="text-gray-400 fs-7 d-block text-truncate"
                                                               style="max-width: 250px;">${item.contentUrl}</a>
                                                        </td>
                                                        <td>
                                                            <c:if test="${item.status eq 'ACTIVE'}"><span
                                                                    class="badge badge-light-success">노출중</span></c:if>
                                                            <c:if test="${item.status eq 'INACTIVE'}"><span
                                                                    class="badge badge-light-secondary">숨김</span></c:if>
                                                        </td>
                                                        <td>${item.clickCount}</td>
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
                                                                    <a href="/mng/content/teams/detail?contentId=${item.contentId}"
                                                                       class="menu-link px-3">상세정보</a>
                                                                </div>
                                                                <div class="menu-item px-3">
                                                                    <a href="#" class="menu-link px-3 text-danger"
                                                                       onclick="deleteContent('${item.contentId}'); return false;">삭제</a>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty contents}">
                                                    <tr>
                                                        <td colspan="6" class="text-center py-10">등록된 콘텐츠가 없습니다.</td>
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

    <div class="modal fade" id="teamModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-650px">
            <div class="modal-content">
                <form id="teamForm" action="/mng/content/teams/save" method="post">
                    <input type="hidden" name="contentId" id="contentId">
                    <div class="modal-header">
                        <h2 class="fw-bold" id="modalTitle">콘텐츠 등록</h2>
                        <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal"><i
                                class="ki-duotone ki-cross fs-1"><span class="path1"></span><span class="path2"></span></i>
                        </div>
                    </div>
                    <div class="modal-body py-10 px-lg-17">
                        <div class="row mb-7">
                            <div class="col-md-8">
                                <label class="required fs-6 fw-semibold mb-2">구단 코드</label>
                                <select class="form-select form-select-solid" name="teamCode" id="teamCode" required>
                                    <option value="LG">LG 트윈스</option>
                                    <option value="KT">KT 위즈</option>
                                    <option value="SSG">SSG 랜더스</option>
                                    <option value="NC">NC 다이노스</option>
                                    <option value="DOOSAN">두산 베어스</option>
                                    <option value="KIA">KIA 타이거즈</option>
                                    <option value="LOTTE">롯데 자이언츠</option>
                                    <option value="SAMSUNG">삼성 라이온즈</option>
                                    <option value="HANWHA">한화 이글스</option>
                                    <option value="KIWOOM">키움 히어로즈</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="fs-6 fw-semibold mb-2">정렬 순서</label>
                                <input type="number" class="form-control form-control-solid" name="sortOrder" id="sortOrder"
                                       value="0"/>
                            </div>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">제목</label>
                            <input type="text" class="form-control form-control-solid" name="title" id="title" required/>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">콘텐츠 URL (영상/기사)</label>
                            <input type="text" class="form-control form-control-solid" name="contentUrl" id="contentUrl"
                                   required placeholder="https://..."/>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">상태</label>
                            <select class="form-select form-select-solid" name="status" id="status">
                                <option value="ACTIVE">노출 (ACTIVE)</option>
                                <option value="INACTIVE">숨김 (INACTIVE)</option>
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

        function openModal() {
            document.getElementById('teamForm').reset();
            document.getElementById('contentId').value = '';
            document.getElementById('modalTitle').innerText = '콘텐츠 등록';
            modal.show();
        }

        function deleteContent(id) {
            if (confirm('정말 삭제하시겠습니까?')) {
                $.post('/mng/content/teams/delete', {contentId: id}, function (res) {
                    if (res === 'ok') location.reload();
                    else alert('삭제 실패');
                });
            }
        }
    </script>
</body>
</html>