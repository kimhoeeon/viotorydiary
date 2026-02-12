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

    <title>구단 콘텐츠 관리 | 승요일기 관리자</title>
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

                                <div class="card card-flush">

                                    <div class="card-header align-items-center py-5 gap-2 gap-md-5">
                                        <div class="card-title">
                                            <div class="d-flex align-items-center position-relative my-1">
                                                <form id="searchForm" action="/mng/content/teams" method="get">
                                                    <select name="teamCode" class="form-select form-select-solid w-200px" onchange="this.form.submit()">
                                                        <option value="ALL">전체 구단</option>
                                                        <option value="KIA" ${paramTeamCode eq 'KIA' ? 'selected' : ''}>KIA</option>
                                                        <option value="SAMSUNG" ${paramTeamCode eq 'SAMSUNG' ? 'selected' : ''}>삼성</option>
                                                        <option value="LG" ${paramTeamCode eq 'LG' ? 'selected' : ''}>LG</option>
                                                        <option value="DOOSAN" ${paramTeamCode eq 'DOOSAN' ? 'selected' : ''}>두산</option>
                                                        <option value="KT" ${paramTeamCode eq 'KT' ? 'selected' : ''}>KT</option>
                                                        <option value="SSG" ${paramTeamCode eq 'SSG' ? 'selected' : ''}>SSG</option>
                                                        <option value="LOTTE" ${paramTeamCode eq 'LOTTE' ? 'selected' : ''}>롯데</option>
                                                        <option value="HANWHA" ${paramTeamCode eq 'HANWHA' ? 'selected' : ''}>한화</option>
                                                        <option value="NC" ${paramTeamCode eq 'NC' ? 'selected' : ''}>NC</option>
                                                        <option value="KIWOOM" ${paramTeamCode eq 'KIWOOM' ? 'selected' : ''}>키움</option>
                                                    </select>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card-body py-4">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5">
                                                <thead>
                                                    <tr class="text-start text-gray-400 fw-bold fs-7 text-uppercase gs-0">
                                                        <th class="min-w-50px">순서</th>
                                                        <th class="min-w-70px">상태</th>
                                                        <th class="min-w-70px">구단</th>
                                                        <th class="min-w-200px">제목</th>
                                                        <th class="min-w-70px">클릭수</th>
                                                        <th class="min-w-100px">등록일</th>
                                                        <th class="min-w-70px">관리</th>
                                                    </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                    <c:forEach var="item" items="${list}" varStatus="status">
                                                        <tr>
                                                            <td>
                                                                <div class="d-flex flex-column align-items-center">
                                                                    <button type="button" class="btn btn-icon btn-sm btn-light-primary mb-1 h-20px w-20px" onclick="changeOrder(${item.contentId}, 'UP')">
                                                                        <i class="bi bi-caret-up-fill"></i>
                                                                    </button>
                                                                    <span class="fs-8 fw-bold">${item.sortOrder}</span>
                                                                    <button type="button" class="btn btn-icon btn-sm btn-light-primary mt-1 h-20px w-20px" onclick="changeOrder(${item.contentId}, 'DOWN')">
                                                                        <i class="bi bi-caret-down-fill"></i>
                                                                    </button>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <c:if test="${item.status eq 'ACTIVE'}"><span class="badge badge-light-success">활성</span></c:if>
                                                                <c:if test="${item.status eq 'INACTIVE'}"><span class="badge badge-light-secondary">비활성</span></c:if>
                                                            </td>
                                                            <td><span class="badge badge-light fw-bold">${item.teamCode}</span></td>
                                                            <td>
                                                                <a href="/mng/content/teams/detail?contentId=${item.contentId}" class="text-gray-800 text-hover-primary fs-5 fw-bold">${item.title}</a>
                                                            </td>
                                                            <td>${item.clickCount}</td>
                                                            <td>${item.createdAt.toString().substring(0,10)}</td>
                                                            <td>
                                                                <button class="btn btn-sm btn-light-danger" onclick="deleteContent(${item.contentId})">삭제</button>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                    <c:if test="${empty contents}">
                                                        <tr>
                                                            <td colspan="7" class="text-center py-10">등록된 콘텐츠가 없습니다.</td>
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
        <div class="modal-dialog modal-dialog-centered mw-900px">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="fw-bold" id="modalTitle">콘텐츠 등록</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <i class="bi bi-x-lg fs-1"></i>
                    </div>
                </div>
                <form id="teamForm" action="/mng/content/teams/save" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="contentId" id="contentId">
                    <div class="modal-body py-10 px-lg-17">
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">상태</label>
                            <div class="d-flex align-items-center mt-3">
                                <div class="form-check form-check-custom form-check-solid me-5">
                                    <input class="form-check-input" type="radio" value="ACTIVE" name="status" id="st_active" checked/>
                                    <label class="form-check-label" for="st_active">활성</label>
                                </div>
                                <div class="form-check form-check-custom form-check-solid">
                                    <input class="form-check-input" type="radio" value="INACTIVE" name="status" id="st_inactive"/>
                                    <label class="form-check-label" for="st_inactive">비활성</label>
                                </div>
                            </div>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">구단 선택</label>
                            <select class="form-select form-select-solid" name="teamCode" id="teamCode">
                                <option value="KIA">KIA</option>
                                <option value="SAMSUNG">삼성</option>
                                <option value="LG">LG</option>
                                <option value="DOOSAN">두산</option>
                                <option value="KT">KT</option>
                                <option value="SSG">SSG</option>
                                <option value="LOTTE">롯데</option>
                                <option value="HANWHA">한화</option>
                                <option value="NC">NC</option>
                                <option value="KIWOOM">키움</option>
                            </select>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">제목</label>
                            <input type="text" class="form-control form-control-solid" name="title" id="title" required />
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">썸네일 이미지</label>
                            <input type="file" name="file" class="form-control form-control-solid" accept="image/jpeg, image/png, image/jpg"/>
                            <div class="form-text text-muted">jpg, png, jpeg 파일만 등록 가능합니다.</div>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">콘텐츠 URL</label>
                            <input type="text" class="form-control form-control-solid" name="contentUrl" id="contentUrl" placeholder="https://..." />
                            <div class="form-text text-muted">"https://"로 시작하는 URL을 입력해주세요. 썸네일 미등록 시 URL에서 자동 추출을 시도합니다.</div>
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
        const modal = new bootstrap.Modal(document.getElementById('teamModal'));

        $(document).ready(function() {
            if(typeof initSummernote === 'function') {
                initSummernote('#content', 400);
            } else {
                $('#content').summernote({ height: 400, lang: 'ko-KR' });
            }
        });

        function openModal() {
            document.getElementById('teamForm').reset();
            document.getElementById('contentId').value = '';
            $('#content').summernote('reset');
            modal.show();
        }

        function changeOrder(id, direction) {
            $.post('/mng/content/teams/reorder', {contentId: id, direction: direction}, function(res) {
                if(res === 'ok') location.reload();
                else alert('순서 변경 실패');
            });
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