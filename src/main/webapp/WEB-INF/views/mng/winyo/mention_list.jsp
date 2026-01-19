<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>승요 멘트 관리 | 승요일기 관리자</title>
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
                                  <div class="card-body">
                                      <div class="d-flex align-items-center justify-content-between">
                                          <div class="d-flex align-items-center">
                                              <a href="/mng/winyo/mentions"
                                                 class="btn btn-sm btn-light me-2 ${empty category ? 'active btn-primary' : ''}">전체</a>
                                              <a href="/mng/winyo/mentions?category=WIN_RATE"
                                                 class="btn btn-sm btn-light me-2 ${category eq 'WIN_RATE' ? 'active btn-primary' : ''}">승률</a>
                                              <a href="/mng/winyo/mentions?category=ATTENDANCE_COUNT"
                                                 class="btn btn-sm btn-light me-2 ${category eq 'ATTENDANCE_COUNT' ? 'active btn-primary' : ''}">직관수</a>
                                              <a href="/mng/winyo/mentions?category=RECENT_TREND"
                                                 class="btn btn-sm btn-light me-2 ${category eq 'RECENT_TREND' ? 'active btn-primary' : ''}">최근흐름</a>
                                          </div>
                                          <button type="button" class="btn btn-primary" onclick="openModal()">
                                              <i class="ki-duotone ki-plus fs-2"></i> 멘트 등록
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
                                                  <th class="min-w-100px">카테고리</th>
                                                  <th class="min-w-100px">조건코드</th>
                                                  <th class="min-w-50px">우선순위</th>
                                                  <th class="min-w-150px">설명</th>
                                                  <th class="min-w-300px">멘트 내용</th>
                                                  <th class="text-end min-w-100px">관리</th>
                                              </tr>
                                              </thead>
                                              <tbody class="text-gray-600 fw-semibold">
                                              <c:forEach var="item" items="${list}">
                                                  <tr>
                                                      <td><span
                                                              class="badge badge-light-primary fw-bold">${item.category}</span>
                                                      </td>
                                                      <td>${item.conditionCode}</td>
                                                      <td><span
                                                              class="badge badge-light-warning fw-bold">${item.priority}</span>
                                                      </td>
                                                      <td class="text-gray-500">${item.description}</td>
                                                      <td class="text-gray-800 text-truncate"
                                                          style="max-width: 300px;">${item.message}</td>
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
                                                                  <a href="/mng/winyo/mention/detail?mentionId=${item.mentionId}"
                                                                     class="menu-link px-3">상세정보</a>
                                                              </div>
                                                              <div class="menu-item px-3">
                                                                  <a href="#" class="menu-link px-3 text-danger"
                                                                     onclick="deleteMention('${item.mentionId}'); return false;">삭제</a>
                                                              </div>
                                                          </div>
                                                      </td>
                                                  </tr>
                                              </c:forEach>
                                              <c:if test="${empty list}">
                                                  <tr>
                                                      <td colspan="6" class="text-center py-10">데이터가 없습니다.</td>
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

  <div class="modal fade" id="mentionModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered mw-650px">
          <div class="modal-content">
              <form id="mentionForm" action="/mng/winyo/mention/save" method="post">
                  <input type="hidden" name="mentionId" id="mentionId">
                  <div class="modal-header">
                      <h2 class="fw-bold" id="modalTitle">멘트 등록</h2>
                      <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal"><i
                              class="ki-duotone ki-cross fs-1"><span class="path1"></span><span class="path2"></span></i>
                      </div>
                  </div>
                  <div class="modal-body py-10 px-lg-17">
                      <div class="fv-row mb-7">
                          <label class="required fs-6 fw-semibold mb-2">카테고리</label>
                          <select class="form-select form-select-solid" name="category" id="category" required>
                              <option value="WIN_RATE">승률</option>
                              <option value="ATTENDANCE_COUNT">직관수</option>
                              <option value="RECENT_TREND">최근흐름</option>
                          </select>
                      </div>
                      <div class="row mb-7">
                          <div class="col-md-8">
                              <label class="required fs-6 fw-semibold mb-2">조건 코드</label>
                              <input type="text" class="form-control form-control-solid" name="conditionCode"
                                     id="conditionCode" required placeholder="예: 80_UP"/>
                          </div>
                          <div class="col-md-4">
                              <label class="required fs-6 fw-semibold mb-2">우선순위</label>
                              <input type="number" class="form-control form-control-solid" name="priority" id="priority"
                                     value="0"/>
                          </div>
                      </div>
                      <div class="fv-row mb-7">
                          <label class="fs-6 fw-semibold mb-2">설명</label>
                          <input type="text" class="form-control form-control-solid" name="description" id="description"/>
                      </div>
                      <div class="fv-row mb-7">
                          <label class="required fs-6 fw-semibold mb-2">멘트 내용</label>
                          <textarea class="form-control form-control-solid" name="message" id="message" rows="3"
                                    required></textarea>
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

      function openModal() {
          document.getElementById('mentionForm').reset();
          document.getElementById('mentionId').value = '';
          document.getElementById('modalTitle').innerText = '멘트 등록';
          modal.show();
      }

      function deleteMention(id) {
          if (confirm('정말 삭제하시겠습니까?')) {
              $.post('/mng/winyo/mention/delete', {mentionId: id}, function (res) {
                  if (res === 'ok') location.reload();
                  else alert('삭제 실패');
              });
          }
      }
  </script>
</body>
</html>