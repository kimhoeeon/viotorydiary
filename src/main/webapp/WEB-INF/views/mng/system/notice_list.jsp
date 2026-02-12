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

    <title>공지사항 관리 | 승요일기 관리자</title>
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
                                        공지사항 관리
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">시스템 관리</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">공지사항 관리</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-7">
                                    <div class="card-body py-4 d-flex justify-content-between align-items-center">
                                        <h3 class="card-title m-0">📢 공지사항 목록</h3>
                                        <button type="button" class="btn btn-primary" onclick="openModal()">
                                            <i class="ki-duotone ki-plus fs-2"></i> 공지 등록
                                        </button>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-body py-4">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5">
                                                <thead>
                                                <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                    <th class="min-w-50px">No</th>
                                                    <th class="min-w-50px">구분</th>
                                                    <th class="min-w-50px">고정</th>
                                                    <th class="min-w-200px">제목</th>
                                                    <th class="min-w-100px">상태</th>
                                                    <th class="min-w-100px">조회수</th>
                                                    <th class="min-w-100px">등록일</th>
                                                    <th class="min-w-70px">관리</th>
                                                </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                <c:forEach var="item" items="${list}">
                                                    <tr>
                                                        <td>${item.noticeId}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${item.category eq 'SURVEY'}"><span class="badge badge-light-info">설문</span></c:when>
                                                                <c:otherwise><span class="badge badge-light-primary">공지</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:if test="${item.isTop eq 'Y'}"><span class="badge badge-light-danger">TOP</span></c:if>
                                                            <c:if test="${item.isTop ne 'Y'}">-</c:if>
                                                        </td>
                                                        <td>
                                                            <a href="#" onclick="openModifyModal(${item.noticeId}); return false;" class="text-gray-800 text-hover-primary fs-5 fw-bold">${item.title}</a>
                                                        </td>
                                                        <td>
                                                            <c:if test="${item.status eq 'ACTIVE'}"><div class="badge badge-light-success">게시중</div></c:if>
                                                            <c:if test="${item.status eq 'HIDDEN'}"><div class="badge badge-light-secondary">숨김</div></c:if>
                                                        </td>
                                                        <td>${item.viewCount}</td>
                                                        <td>
                                                            <fmt:parseDate value="${item.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both"/>
                                                            <fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd"/>
                                                        </td>
                                                        <td>
                                                            <button class="btn btn-sm btn-light-danger" onclick="deleteNotice(${item.noticeId})">삭제</button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
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

    <div class="modal fade" id="noticeModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-900px">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="fw-bold" id="modalTitle">공지사항 등록</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <span class="svg-icon svg-icon-1"><i class="ki-duotone ki-cross fs-1"><span class="path1"></span><span class="path2"></span></i></span>
                    </div>
                </div>

                <form id="noticeForm" action="/mng/system/notices/save" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="noticeId" id="noticeId">

                    <div class="modal-body py-10 px-lg-17">
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">제목</label>
                            <input type="text" class="form-control form-control-solid" name="title" id="title" required />
                        </div>

                        <div class="row mb-7">
                            <div class="col-md-4">
                                <label class="required fs-6 fw-semibold mb-2">구분</label>
                                <select class="form-select form-select-solid" name="category" id="category">
                                    <option value="NOTICE">공지</option>
                                    <option value="SURVEY">설문</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="fs-6 fw-semibold mb-2">상단 고정</label>
                                <select class="form-select form-select-solid" name="isTop" id="isTop">
                                    <option value="N">미설정</option>
                                    <option value="Y">고정 (Top)</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="fs-6 fw-semibold mb-2">상태</label>
                                <select class="form-select form-select-solid" name="status" id="status">
                                    <option value="ACTIVE">게시</option>
                                    <option value="HIDDEN">숨김</option>
                                </select>
                            </div>
                        </div>

                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">썸네일 이미지</label>
                            <input type="file" name="file" class="form-control form-control-solid" accept="image/*"/>
                            <div class="form-text text-muted">리스트에 노출될 이미지를 등록해주세요. (권장: 300x200)</div>
                        </div>

                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">내용</label>
                            <textarea name="content" id="content"></textarea>
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

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>
    <script src="/js/summernote.js"></script>
    <script>
        $(document).ready(function() {
            // [6] Summernote 초기화 (summernote.js의 함수 사용)
            // 만약 initSummernote가 로드되지 않았을 경우를 대비한 안전 장치
            if (typeof initSummernote === 'function') {
                initSummernote('#content', 400); // ID, Height
            } else {
                $('#content').summernote({ height: 400, lang: 'ko-KR' });
            }
        });

        const modal = new bootstrap.Modal(document.getElementById('noticeModal'));

        // 2. 등록 모달 열기
        function openModal() {
            // 폼 리셋
            document.getElementById('noticeForm').reset();
            document.getElementById('noticeId').value = '';
            document.getElementById('modalTitle').innerText = '공지사항 등록';

            // 에디터 초기화
            $('#content').summernote('reset');

            modal.show();
        }

        function deleteNotice(id) {
            if (confirm('삭제하시겠습니까?')) {
                $.post('/mng/system/notices/delete', {noticeId: id}, function (res) {
                    if (res === 'ok') location.reload();
                    else alert('삭제 실패');
                });
            }
        }
    </script>
</body>
</html>