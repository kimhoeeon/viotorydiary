<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>요청하기 | 승요일기 관리자</title>
    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/css/mngStyle.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
</head>
<body id="kt_app_body" class="app-default" data-kt-app-layout="dark-sidebar" data-kt-app-header-fixed="true"
      data-kt-app-sidebar-enabled="true" data-kt-app-sidebar-fixed="true">

    <div class="d-flex flex-column flex-root app-root" id="kt_app_root">
        <div class="app-page flex-column flex-column-fluid" id="kt_app_page">
            <jsp:include page="/WEB-INF/views/mng/include/header.jsp"/>
            <div class="app-wrapper flex-column flex-row-fluid" id="kt_app_wrapper">
                <jsp:include page="/WEB-INF/views/mng/include/sidebar.jsp"/>

                <div class="app-main flex-column flex-row-fluid" id="kt_app_main">
                    <div class="d-flex flex-column flex-column-fluid">
                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card">
                                    <div class="card-header">
                                        <div class="card-title">
                                            <h3>${empty vo.reqId ? '✏️ 요청사항 등록' : '📝 요청사항 수정'}</h3>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <form action="/mng/dev/save" method="post" enctype="multipart/form-data">
                                            <input type="hidden" name="reqId" value="${vo.reqId}">

                                            <div class="row mb-5">
                                                <div class="col-md-3">
                                                    <label class="required form-label">유형</label>
                                                    <select name="category" class="form-select" required>
                                                        <option value="MAINTENANCE" ${vo.category eq 'MAINTENANCE' ? 'selected' : ''}>유지보수</option>
                                                        <option value="INQUIRY" ${vo.category eq 'INQUIRY' ? 'selected' : ''}>단순문의</option>
                                                        <option value="BUG" ${vo.category eq 'BUG' ? 'selected' : ''}>기능오류</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-3">
                                                    <label class="form-label">긴급 여부</label>
                                                    <div class="form-check form-switch mt-3">
                                                        <input class="form-check-input" type="checkbox" value="Y" name="urgency" id="urgency" ${vo.urgency eq 'Y' ? 'checked' : ''}/>
                                                        <label class="form-check-label fw-bold text-danger" for="urgency">긴급 요청</label>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="mb-5">
                                                <label class="required form-label">제목</label>
                                                <input type="text" name="title" class="form-control" value="${vo.title}" required/>
                                            </div>

                                            <div class="mb-5">
                                                <label class="form-label">내용</label>
                                                <textarea id="summernote" name="content" required>${vo.content}</textarea>
                                            </div>

                                            <c:if test="${not empty vo.fileList}">
                                                <div class="mb-5">
                                                    <label class="form-label">기존 파일 (삭제할 파일 선택)</label>
                                                    <div class="d-flex flex-column gap-2 border rounded p-3 bg-light">
                                                        <c:forEach var="file" items="${vo.fileList}">
                                                            <div class="form-check form-check-custom form-check-sm">
                                                                <input class="form-check-input" type="checkbox" name="deleteFileIds" value="${file.fileId}" id="file_${file.fileId}"/>
                                                                <label class="form-check-label text-gray-800" for="file_${file.fileId}">
                                                                    <i class="ki-duotone ki-file fs-5 me-1"><span class="path1"></span><span class="path2"></span></i>
                                                                        ${file.orgFileName} <span class="text-danger fs-8">(삭제 선택)</span>
                                                                </label>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </c:if>

                                            <div class="mb-5">
                                                <label class="form-label">첨부파일 추가</label>
                                                <input type="file" name="files" class="form-control" multiple/>
                                                <div class="form-text">새로운 파일을 추가하려면 선택하세요.</div>
                                            </div>

                                            <div class="text-end">
                                                <a href="/mng/dev/list" class="btn btn-light me-2">취소</a>
                                                <button type="submit" class="btn btn-primary">${empty vo.reqId ? '등록하기' : '수정하기'}</button>
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

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
    <script>
        $(document).ready(function () {
            $('#summernote').summernote({
                placeholder: '요청사항을 상세히 입력해주세요. 이미지도 첨부 가능합니다.',
                tabsize: 2,
                height: 300,
                toolbar: [
                    ['style', ['style']],
                    ['font', ['bold', 'underline', 'clear', 'color']], // 폰트색, 스타일
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['table', ['table']],
                    ['insert', ['link', 'picture', 'video']],
                    ['view', ['fullscreen', 'codeview', 'help']]
                ]
            });
        });
    </script>
</body>
</html>