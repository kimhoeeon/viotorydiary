<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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
                                                        <th class="min-w-50px text-center">순서</th>
                                                        <th class="min-w-70px text-center">상태</th>
                                                        <th class="min-w-70px">구단</th>
                                                        <th class="min-w-200px">제목</th>
                                                        <th class="min-w-70px text-center">클릭수</th>
                                                        <th class="min-w-100px text-center">등록일</th>
                                                        <th class="min-w-70px text-center">관리</th>
                                                    </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                    <c:forEach var="item" items="${list}" varStatus="status">
                                                        <tr>
                                                            <td class="text-center">
                                                                <div class="d-flex flex-column align-items-center justify-content-center">
                                                                    <button type="button" class="btn btn-icon btn-sm btn-light-primary mb-1 h-20px w-20px" onclick="changeOrder(${item.contentId}, 'UP')">
                                                                        <i class="ki-duotone ki-arrow-up fs-3">
                                                                            <span class="path1"></span>
                                                                            <span class="path2"></span>
                                                                        </i>
                                                                    </button>
                                                                    <span class="fs-8 fw-bold">${item.sortOrder}</span>
                                                                    <button type="button" class="btn btn-icon btn-sm btn-light-primary mt-1 h-20px w-20px" onclick="changeOrder(${item.contentId}, 'DOWN')">
                                                                        <i class="ki-duotone ki-arrow-down fs-3">
                                                                            <span class="path1"></span>
                                                                            <span class="path2"></span>
                                                                        </i>
                                                                    </button>
                                                                </div>
                                                            </td>
                                                            <td class="text-center">
                                                                <c:if test="${item.status eq 'ACTIVE'}"><span class="badge badge-light-success">활성</span></c:if>
                                                                <c:if test="${item.status eq 'INACTIVE'}"><span class="badge badge-light-secondary">비활성</span></c:if>
                                                            </td>
                                                            <td><span class="badge badge-light fw-bold">${item.teamCode}</span></td>
                                                            <td>
                                                                ${item.title}
                                                            </td>
                                                            <td class="text-center">${item.clickCount}</td>
                                                            <td class="text-center">
                                                                <c:choose>
                                                                    <c:when test="${not empty item.createdAt}">
                                                                        <%-- LocalDateTime의 'T'를 공백으로 치환 --%>
                                                                        <c:set var="cDate" value="${fn:replace(item.createdAt, 'T', ' ')}" />
                                                                        <%-- 초 단위까지만 깔끔하게 자르기 (yyyy-MM-dd HH:mm:ss) --%>
                                                                        <c:choose>
                                                                            <c:when test="${fn:length(cDate) > 19}">
                                                                                ${fn:substring(cDate, 0, 19)}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                ${cDate}
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:when>
                                                                    <c:otherwise>-</c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="text-center">
                                                                <a href="/mng/content/teams/detail?contentId=${item.contentId}"
                                                                   class="btn btn-icon btn-bg-light btn-active-color-primary btn-sm me-1" title="수정">
                                                                    <i class="ki-duotone ki-pencil fs-2">
                                                                        <span class="path1"></span>
                                                                        <span class="path2"></span>
                                                                    </i>
                                                                </a>
                                                                <button type="button"
                                                                        onclick="deleteContent('${item.contentId}')"
                                                                        class="btn btn-icon btn-bg-light btn-active-color-danger btn-sm"
                                                                        title="삭제">
                                                                    <i class="ki-duotone ki-trash fs-2">
                                                                        <span class="path1"></span>
                                                                        <span class="path2"></span>
                                                                        <span class="path3"></span>
                                                                        <span class="path4"></span>
                                                                        <span class="path5"></span>
                                                                    </i>
                                                                </button>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                    <c:if test="${empty list}">
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
                        <i class="ki-duotone ki-cross fs-1"><span class="path1"></span><span class="path2"></span></i>
                    </div>
                </div>
                <form id="teamForm" method="post" enctype="multipart/form-data">
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
                            <label class="fs-6 fw-bold mb-2">썸네일 미리보기</label>
                            <div class="d-flex justify-content-center align-items-center bg-light rounded position-relative"
                                 style="min-height: 200px; border: 1px dashed #ccc; overflow: hidden;">

                                <img id="previewImg" src="/assets/media/svg/files/blank-image.svg"
                                     style="max-width: 100%; max-height: 250px; object-fit: contain;" alt="미리보기" />

                                <div id="previewLoader" class="position-absolute w-100 h-100 justify-content-center align-items-center bg-white bg-opacity-75" style="display: none;">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-text text-muted">
                                jpg, png, jpeg 파일만 등록 가능합니다.<br>
                                파일 등록시, 콘텐츠 URL의 썸네일보다 우선 적용됩니다.
                            </div>
                            <input type="hidden" id="hiddenImageUrl" name="imageUrl" />
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">썸네일 이미지</label>
                            <input type="file" class="form-control form-control-solid" name="file" id="fileInput" accept="image/jpeg, image/png, image/jpg"/>
                            <div class="form-text text-muted">
                                jpg, png, jpeg 파일만 등록 가능합니다.<br>
                                파일 등록시, 콘텐츠 URL의 썸네일보다 우선 적용됩니다.
                            </div>
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
                        <button type="button" class="btn btn-primary" onclick="saveContent()">저장</button>
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

        // 전역 변수로 마지막 URL 저장 (중복 호출 방지)
        let lastExtractedUrl = '';

        $(document).ready(function() {
            // 1. 파일 선택 시 미리보기 (로컬 파일)
            $('#fileInput').on('change', function(e) {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        $('#previewImg').attr('src', e.target.result);
                        $('#hiddenImageUrl').val(''); // 파일이 우선이므로 추출 URL 제거

                        // 파일 로드 완료 시 로딩바 숨김 및 이미지 투명도 원복
                        $('#previewLoader').removeClass('d-flex').hide();
                        $('#previewImg').css('opacity', 1);
                    }
                    reader.readAsDataURL(file);
                }
            });

            // 2. 링크 URL 입력 시 썸네일 추출 (포커스 아웃 or 붙여넣기 시)
            $('#contentUrl').on('blur paste', function() {
                setTimeout(() => {
                    const url = $('#contentUrl').val();
                    const fileVal = $('#fileInput').val();

                    // 파일이 없고, URL이 있고, URL이 변경되었을 때만 수행
                    if (!fileVal && url && url.length > 10 && url !== lastExtractedUrl) {
                        extractMeta(url);
                    }
                }, 100);
            });

            if(typeof initSummernote === 'function') {
                initSummernote('#content', 400);
            } else {
                $('#content').summernote({ height: 400, lang: 'ko-KR' });
            }
        });

        function extractMeta(url) {
            // 로딩 시작
            $('#previewLoader').addClass('d-flex').show(); // 스피너 노출
            $('#previewImg').css('opacity', 0.3); // 이미지 흐리게

            $.get('/mng/content/teams/meta', { url: url }, function(res) {
                if (res) {
                    $('#previewImg').attr('src', res);
                    $('#hiddenImageUrl').val(res);
                    lastExtractedUrl = url; // 마지막 URL 갱신
                }
            }).always(function() {
                // 로딩 종료 (성공/실패 무관)
                $('#previewLoader').removeClass('d-flex').hide();
                $('#previewImg').css('opacity', 1);
            });
        }

        const modal = new bootstrap.Modal(document.getElementById('teamModal'));

        // 모달 열기 함수 (초기화 로직 포함)
        function openModal(contentId) {
            // 초기화
            document.getElementById('teamForm').reset();
            $('#previewImg').attr('src', '/assets/media/svg/files/blank-image.svg');
            $('#hiddenImageUrl').val('');
            $('#contentId').val('');
            $('#content').summernote('reset');

            lastExtractedUrl = '';
            $('#previewLoader').removeClass('d-flex').hide();
            $('#previewImg').css('opacity', 1);

            if (contentId) {
                // 수정 모드: 상세 정보 조회
                $.get('/mng/content/teams/detail', { contentId: contentId }, function(data) {
                    $('#contentId').val(data.contentId);
                    $('#linkUrl').val(data.linkUrl);
                    $('#teamCode').val(data.teamCode);
                    $('#title').val(data.title);
                    $('#content').summernote('code', data.content);

                    // 기존 썸네일 세팅
                    if(data.imageUrl) {
                        $('#previewImg').attr('src', data.imageUrl);
                        $('#hiddenImageUrl').val(data.imageUrl);
                    }

                    // 팝업 열자마자 불필요한 재추출 방지를 위해 현재 URL 저장
                    if(data.linkUrl) {
                        lastExtractedUrl = data.linkUrl;
                    }

                    $('#modalTitle').text('콘텐츠 수정');
                    if(modal) modal.show();
                });
            } else {
                // 등록 모드
                $('#modalTitle').text('콘텐츠 등록');
                if(modal) modal.show();
            }
        }

        function changeOrder(id, direction) {
            $.post('/mng/content/teams/reorder', {contentId: id, direction: direction}, function(res) {
                if(res === 'ok') location.reload();
                else alert('순서 변경 실패');
            });
        }

        /**
         * 콘텐츠 등록 (AJAX)
         */
        function saveContent() {
            // 1. 유효성 검사
            /* 필요한 경우 추가 (예: 제목 입력 여부 확인) */
            /*
            if (!$('input[name="title"]').val()) {
                alert('제목을 입력해주세요.');
                return;
            }
            */

            // 2. 썸머노트 내용 동기화 (필요 시)
            $('#content').val($('#content').summernote('code'));

            // 3. 폼 데이터 생성
            const form = document.getElementById('teamForm');
            const formData = new FormData(form);

            // 4. AJAX 전송
            $.ajax({
                url: '/mng/content/teams/save',
                type: 'POST',
                data: formData,
                contentType: false, // 파일 업로드 시 필수
                processData: false, // 파일 업로드 시 필수
                success: function(res) {
                    if (res === 'ok') {

                        // 팝업(모달) 먼저 닫기
                        if (modal) {
                            modal.hide();
                        }

                        // 커스텀 alert 호출 (script.js에 오버라이딩 된 alert 사용)
                        alert('콘텐츠가 등록되었습니다.', function() {
                            location.reload(); // 확인 클릭 시 새로고침
                        });
                    } else {
                        alert('등록에 실패했습니다.');
                    }
                },
                error: function() {
                    alert('서버 통신 중 오류가 발생했습니다.');
                }
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