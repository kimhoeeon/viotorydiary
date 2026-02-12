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

    <title>요청사항 상세 | 승요일기 관리자</title>
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
                                        요청사항 & 문의
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">개발사</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">요청사항 & 문의</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-5">
                                    <div class="card-header">
                                        <div class="card-title d-flex align-items-center">
                                            <c:if test="${vo.urgency eq 'Y'}">
                                                <span class="badge badge-danger me-2">긴급</span>
                                            </c:if>
                                            <span class="badge badge-light-primary me-2">${vo.categoryName}</span>
                                            <h3 class="fw-bold m-0">${vo.title}</h3>
                                        </div>
                                        <div class="card-toolbar">
                                            <c:if test="${sessionScope.admin.role eq 'ADMIN' or sessionScope.admin.adminId eq vo.adminId}">
                                                <a href="/mng/dev/write?reqId=${vo.reqId}" class="btn btn-sm btn-light me-2">수정</a>
                                            </c:if>

                                            <c:if test="${sessionScope.admin.role ne 'CLIENT'}">
                                                <div class="d-flex align-items-center gap-2">
                                                    <input type="date" id="dueDate" class="form-control form-control-sm w-150px" value="${vo.dueDate}">
                                                    <select id="statusSelect" class="form-select form-select-sm w-120px">
                                                        <option value="WAITING" ${vo.status eq 'WAITING' ? 'selected' : ''}>
                                                            처리대기
                                                        </option>
                                                        <option value="PROCESS" ${vo.status eq 'PROCESS' ? 'selected' : ''}>
                                                            진행중
                                                        </option>
                                                        <option value="DONE" ${vo.status eq 'DONE' ? 'selected' : ''}>
                                                            완료
                                                        </option>
                                                        <option value="DISCUSS" ${vo.status eq 'DISCUSS' ? 'selected' : ''}>
                                                            논의필요
                                                        </option>
                                                        <option value="REJECT" ${vo.status eq 'REJECT' ? 'selected' : ''}>
                                                            처리불가
                                                        </option>
                                                    </select>
                                                    <button class="btn btn-sm btn-light-primary" onclick="updateStatus()">
                                                        저장
                                                    </button>
                                                </div>
                                            </c:if>
                                            <c:if test="${sessionScope.admin.role eq 'CLIENT'}">
                                                <span class="badge ${vo.statusBadge} fs-6">${vo.status}</span>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-5 border-bottom pb-5">
                                            <div class="d-flex justify-content-between mb-3 text-muted fs-7">
                                                <span>작성자: ${vo.writerName}</span>
                                                <span>작성일: <fmt:parseDate value="${vo.createdAt}"
                                                                          pattern="yyyy-MM-dd'T'HH:mm:ss" var="regDate"
                                                                          type="both"/><fmt:formatDate value="${regDate}"
                                                                                                       pattern="yyyy-MM-dd HH:mm"/></span>
                                            </div>
                                            <div class="fs-6 text-gray-800 min-h-100px p-3 border rounded bg-light">
                                                <c:out value="${vo.content}" escapeXml="false"/>
                                            </div>
                                        </div>

                                        <c:if test="${not empty vo.fileList}">
                                            <div class="mb-5">
                                                <h5 class="fw-bold mb-3">첨부파일</h5>
                                                <c:forEach var="file" items="${vo.fileList}">
                                                    <div class="d-flex align-items-center mb-2">
                                                        <i class="ki-duotone ki-file fs-2 me-2">
                                                            <span class="path1"></span>
                                                            <span class="path2"></span>
                                                        </i>
                                                        <a href="${file.saveFileName}" download="${file.orgFileName}" class="text-hover-primary">
                                                            ${file.orgFileName}
                                                        </a>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-header">
                                        <div class="card-title"><h4>댓글 (${comments.size()})</h4></div>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-10">
                                            <c:forEach var="co" items="${comments}">
                                                <c:set var="bgClass"
                                                       value="${co.writerRole eq 'CLIENT' ? 'bg-light-warning border-warning border-dashed' : 'bg-light-primary border-primary border-dashed'}"/>
                                                <c:set var="badgeClass"
                                                       value="${co.writerRole eq 'CLIENT' ? 'badge-warning' : 'badge-primary'}"/>
                                                <c:set var="roleName" value="${co.writerRole eq 'CLIENT' ? '발주사' : '관리자'}"/>

                                                <div class="mb-5 p-4 rounded border ${bgClass} ${not empty co.parentId ? 'ms-10' : ''}">

                                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                                        <div class="d-flex align-items-center">
                                                            <span class="badge ${badgeClass} me-2">${roleName}</span>
                                                            <span class="fw-bold text-gray-800 me-2">${co.writerName}</span>
                                                            <span class="text-muted fs-8">
                                                                <fmt:parseDate value="${co.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="coDate" type="both"/>
                                                                <fmt:formatDate value="${coDate}" pattern="yyyy-MM-dd HH:mm"/>
                                                            </span>
                                                        </div>

                                                        <div class="d-flex gap-2">
                                                            <c:if test="${sessionScope.admin.adminId eq co.adminId}">
                                                                <button type="button"
                                                                        class="btn btn-icon btn-sm btn-active-light-primary w-20px h-20px"
                                                                        onclick="openEditModal('${co.commentId}', '${co.content}')">
                                                                    <i class="ki-duotone ki-pencil fs-6">
                                                                        <span class="path1"></span>
                                                                        <span class="path2"></span>
                                                                    </i>
                                                                </button>
                                                                <button type="button"
                                                                        class="btn btn-icon btn-sm btn-active-light-danger w-20px h-20px"
                                                                        onclick="deleteComment('${co.commentId}')">
                                                                    <i class="ki-duotone ki-trash fs-6">
                                                                        <span class="path1"></span>
                                                                        <span class="path2"></span>
                                                                        <span class="path3"></span>
                                                                        <span class="path4"></span>
                                                                        <span class="path5"></span>
                                                                    </i>
                                                                </button>
                                                            </c:if>

                                                            <c:if test="${empty co.parentId}">
                                                                <button class="btn btn-sm btn-light btn-active-light-dark py-1 px-2 fs-8" onclick="toggleReply('${co.commentId}')">
                                                                    답글
                                                                </button>
                                                            </c:if>
                                                        </div>
                                                    </div>

                                                    <div class="text-gray-800 fs-6 mb-2 fw-semibold" style="white-space: pre-wrap;">${co.content}</div>

                                                    <c:if test="${not empty co.fileList}">
                                                        <div class="d-flex flex-wrap gap-2 mt-2">
                                                            <c:forEach var="cf" items="${co.fileList}">
                                                                <div class="d-flex align-items-center bg-white rounded px-2 py-1 border shadow-sm">
                                                                    <i class="ki-duotone ki-file fs-5 me-1 text-gray-500">
                                                                        <span class="path1"></span>
                                                                        <span class="path2"></span>
                                                                    </i>
                                                                    <a href="${cf.saveFileName}" download="${cf.orgFileName}"
                                                                       class="text-gray-700 text-hover-primary fs-8 fw-bold">${cf.orgFileName}</a>

                                                                    <input type="hidden" class="comment-file-data"
                                                                           data-comment-id="${co.commentId}"
                                                                           data-file-id="${cf.fileId}"
                                                                           data-file-name="${cf.orgFileName}">
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </c:if>

                                                    <div id="replyForm_${co.commentId}" class="d-none mt-3 bg-white p-3 rounded border">
                                                        <form action="/mng/dev/comment/save" method="post" enctype="multipart/form-data">
                                                            <input type="hidden" name="reqId" value="${vo.reqId}">
                                                            <input type="hidden" name="parentId" value="${co.commentId}">
                                                            <textarea name="content" class="form-control mb-2" rows="2" placeholder="답글을 입력하세요" required></textarea>
                                                            <div class="d-flex justify-content-between align-items-center">
                                                                <input type="file" name="coFiles" class="form-control form-control-sm w-50" multiple>
                                                                <button type="submit" class="btn btn-sm btn-dark">
                                                                    등록
                                                                </button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>

                                        <div class="border-top pt-5">
                                            <form action="/mng/dev/comment/save" method="post" enctype="multipart/form-data">
                                                <input type="hidden" name="reqId" value="${vo.reqId}">
                                                <div class="mb-3">
                                                    <label class="form-label fw-bold">댓글 작성</label>
                                                    <textarea name="content" class="form-control" rows="3" placeholder="내용을 입력하세요" required></textarea>
                                                </div>
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <input type="file" name="coFiles" class="form-control w-50" multiple>
                                                    <button type="submit" class="btn btn-primary">댓글 등록</button>
                                                </div>
                                            </form>
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

    <div class="modal fade" id="commentEditModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-600px">
            <div class="modal-content">
                <form action="/mng/dev/comment/update" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="reqId" value="${vo.reqId}">
                    <input type="hidden" name="commentId" id="editCommentId">

                    <div class="modal-header">
                        <h3 class="fw-bold">댓글 수정</h3>
                        <div class="btn btn-icon btn-sm btn-active-light-primary ms-2" data-bs-dismiss="modal">
                            <i class="ki-duotone ki-cross fs-1">
                                <span class="path1"></span>
                                <span class="path2"></span>
                            </i>
                        </div>
                    </div>

                    <div class="modal-body py-5">
                        <div class="mb-3">
                            <label class="form-label">내용</label>
                            <textarea name="content" id="editCommentContent" class="form-control" rows="4" required></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">기존 파일</label>
                            <div id="editFileContainer" class="d-flex flex-column gap-2 border rounded p-3 bg-light">
                                <span class="text-muted fs-8">첨부된 파일이 없습니다.</span>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">파일 추가</label>
                            <input type="file" name="coFiles" class="form-control" multiple>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
                        <button type="submit" class="btn btn-primary">수정 저장</button>
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
        const editModal = new bootstrap.Modal(document.getElementById('commentEditModal'));

        function updateStatus() {
            var status = $("#statusSelect").val();
            var date = $("#dueDate").val();

            if (confirm('상태 및 처리예정일을 변경하시겠습니까?')) {
                $.post('/mng/dev/status', {
                    reqId: '${vo.reqId}',
                    status: status,
                    dueDate: date
                }, function (res) {
                    if (res === 'ok') {
                        alert('변경되었습니다.');
                        location.reload();
                    } else {
                        alert('오류가 발생했습니다.');
                    }
                });
            }
        }

        function toggleReply(id) {
            $("#replyForm_" + id).toggleClass("d-none");
        }

        // 댓글 삭제
        function deleteComment(id) {
            if (confirm('정말 삭제하시겠습니까?')) {
                $.post('/mng/dev/comment/delete', {commentId: id}, function (res) {
                    if (res === 'ok') location.reload();
                    else alert('삭제 실패');
                });
            }
        }

        // 댓글 수정 모달 열기
        function openEditModal(commentId, content) {
            $("#editCommentId").val(commentId);
            $("#editCommentContent").val(content); // 내용 채우기

            // 기존 파일 정보 찾기 (DOM에서 데이터 추출)
            var fileContainer = $("#editFileContainer");
            fileContainer.empty();

            var files = $(".comment-file-data[data-comment-id='" + commentId + "']");

            if (files.length > 0) {
                files.each(function() {
                    var fileId = $(this).data("file-id");
                    var fileName = $(this).data("file-name");

                    // ★ 여기가 핵심 수정 부분입니다 (\ 추가) ★
                    var html = `
                    <div class="form-check form-check-custom form-check-sm">
                        <input class="form-check-input" type="checkbox" name="deleteFileIds" value="\${fileId}" id="cf_\${fileId}"/>
                        <label class="form-check-label text-gray-800" for="cf_\${fileId}">
                            \${fileName} <span class="text-danger fs-8 fw-bold ms-2">(체크 시 삭제)</span>
                        </label>
                    </div>`;
                    fileContainer.append(html);
                });
            } else {
                fileContainer.append('<span class="text-muted fs-8">첨부된 파일이 없습니다.</span>');
            }

            editModal.show();
        }
    </script>
</body>
</html>