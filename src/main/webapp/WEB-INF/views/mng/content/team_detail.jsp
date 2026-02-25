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

    <title>콘텐츠 상세 | 승요일기 관리자</title>
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

                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-header border-0 cursor-pointer">
                                        <div class="card-title m-0"><h3 class="fw-bold m-0">구단 콘텐츠 상세</h3></div>
                                    </div>
                                    <div class="card-body p-9">
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">제목</label>
                                            <div class="col-lg-10"><span class="fw-bold fs-6 text-gray-800">${content.title}</span></div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">구단</label>
                                            <div class="col-lg-10"><span class="badge badge-light fw-bold">${content.teamCode}</span></div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">상태</label>
                                            <div class="col-lg-10">
                                                <span class="badge badge-light-${content.status eq 'ACTIVE' ? 'success' : 'secondary'}">${content.status}</span>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <div class="col-lg-2 fw-semibold text-muted">썸네일 미리보기</div>
                                            <div class="col-lg-10">
                                                <div class="d-flex flex-center bg-light rounded overflow-hidden"
                                                     style="height: 250px; border: 1px dashed #ccc;">
                                                    <img src="${not empty content.imageUrl ? content.imageUrl : '/assets/media/svg/files/blank-image.svg'}"
                                                         alt="썸네일" class="mw-100 mh-100 object-fit-contain"
                                                         onclick="window.open(this.src)" style="cursor: pointer;">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">콘텐츠 URL</label>
                                            <div class="col-lg-10">
                                                <a href="${content.contentUrl}" target="_blank" class="text-primary">${content.contentUrl}</a>
                                            </div>
                                        </div>

                                        <div class="separator my-10"></div>
                                        <h3 class="fw-bold mb-5">📊 콘텐츠 반응 분석</h3>
                                        <div class="row g-5 g-xl-8">
                                            <div class="col-xl-6">
                                                <div class="card card-bordered h-100">
                                                    <div class="card-header border-0 pt-5">
                                                        <h3 class="card-title align-items-start flex-column">
                                                            <span class="card-label fw-bold text-dark">연령대별 클릭수</span>
                                                            <span class="text-muted mt-1 fw-semibold fs-7">어떤 연령층이 가장 많이 봤을까요?</span>
                                                        </h3>
                                                    </div>
                                                    <div class="card-body pt-0">
                                                        <canvas id="ageChart" style="max-height: 300px;"></canvas>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-xl-6">
                                                <div class="card card-bordered h-100">
                                                    <div class="card-header border-0 pt-5">
                                                        <h3 class="card-title align-items-start flex-column">
                                                            <span class="card-label fw-bold text-dark">최근 30일 클릭 추이</span>
                                                            <span class="text-muted mt-1 fw-semibold fs-7">일별 조회수 변화 그래프</span>
                                                        </h3>
                                                    </div>
                                                    <div class="card-body pt-0">
                                                        <canvas id="dailyChart" style="max-height: 300px;"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-footer d-flex justify-content-end py-6 px-9">
                                        <a href="/mng/content/teams" class="btn btn-light me-2">목록으로</a>
                                        <button type="button" class="btn btn-primary" onclick="openEditModal()">수정하기</button>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modifyModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-900px">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="fw-bold">콘텐츠 수정</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <i class="ki-duotone ki-cross fs-1"><span class="path1"></span><span class="path2"></span></i>
                    </div>
                </div>
                <form id="modifyForm" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="contentId" value="${content.contentId}">

                    <div class="modal-body py-10 px-lg-17">
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">상태</label>
                            <div class="d-flex align-items-center mt-3">
                                <div class="form-check form-check-custom form-check-solid me-5">
                                    <input class="form-check-input" type="radio" value="ACTIVE" name="status" ${content.status eq 'ACTIVE' ? 'checked' : ''}/>
                                    <label class="form-check-label">활성</label>
                                </div>
                                <div class="form-check form-check-custom form-check-solid">
                                    <input class="form-check-input" type="radio" value="INACTIVE" name="status" ${content.status eq 'INACTIVE' ? 'checked' : ''}/>
                                    <label class="form-check-label">비활성</label>
                                </div>
                            </div>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">구단 선택</label>
                            <select class="form-select form-select-solid" name="teamCode">
                                <option value="KIA" ${content.teamCode eq 'KIA' ? 'selected' : ''}>KIA</option>
                                <option value="SAMSUNG" ${content.teamCode eq 'SAMSUNG' ? 'selected' : ''}>삼성</option>
                                <option value="LG" ${content.teamCode eq 'LG' ? 'selected' : ''}>LG</option>
                                <option value="DOOSAN" ${content.teamCode eq 'DOOSAN' ? 'selected' : ''}>두산</option>
                                <option value="KT" ${content.teamCode eq 'KT' ? 'selected' : ''}>KT</option>
                                <option value="SSG" ${content.teamCode eq 'SSG' ? 'selected' : ''}>SSG</option>
                                <option value="LOTTE" ${content.teamCode eq 'LOTTE' ? 'selected' : ''}>롯데</option>
                                <option value="HANWHA" ${content.teamCode eq 'HANWHA' ? 'selected' : ''}>한화</option>
                                <option value="NC" ${content.teamCode eq 'NC' ? 'selected' : ''}>NC</option>
                                <option value="KIWOOM" ${content.teamCode eq 'KIWOOM' ? 'selected' : ''}>키움</option>
                            </select>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="required fs-6 fw-semibold mb-2">제목</label>
                            <input type="text" class="form-control form-control-solid" name="title" value="${content.title}" required />
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-bold mb-2">썸네일 미리보기</label>
                            <div class="d-flex justify-content-center align-items-center bg-light rounded position-relative"
                                 style="min-height: 200px; border: 1px dashed #ccc; overflow: hidden;">

                                <img id="detailPreviewImg"
                                     src="${not empty content.imageUrl ? content.imageUrl : '/assets/media/svg/files/blank-image.svg'}"
                                     style="max-width: 100%; max-height: 400px; object-fit: contain;" />

                                <div id="detailLoader" class="position-absolute w-100 h-100 justify-content-center align-items-center bg-white bg-opacity-75" style="display: none;">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                </div>
                            </div>
                            <input type="hidden" id="detailHiddenImageUrl" name="imageUrl" value="${content.imageUrl}" />
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-bold mb-2">이미지 변경</label>
                            <input type="file" class="form-control form-control-solid" name="file" id="detailFileInput" accept="image/jpeg, image/png, image/jpg"/>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">콘텐츠 URL</label>
                            <input type="text" class="form-control form-control-solid" name="contentUrl" id="detailContentUrl" value="${content.contentUrl}" />
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">내용</label>
                            <textarea name="content" id="summernote_edit">${content.content}</textarea>
                        </div>
                    </div>
                    <div class="modal-footer flex-center">
                        <button type="button" class="btn btn-light me-3" data-bs-dismiss="modal">취소</button>
                        <button type="button" class="btn btn-primary" onclick="updateContent()">저장</button>
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
        const modifyModal = new bootstrap.Modal(document.getElementById('modifyModal'));

        $(document).ready(function() {

            let lastDetailUrl = "${content.contentUrl}"; // 초기값 설정

            // 1. 파일 변경 시 미리보기
            $('input[name="file"]').on('change', function(e) {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        $('#detailPreviewImg').attr('src', e.target.result);
                        $('#detailHiddenImageUrl').val(''); // 파일이 우선이므로 추출 URL 제거

                        // 파일 로드 완료 시 로딩바 숨김 및 이미지 투명도 원복
                        $('#detailLoader').removeClass('d-flex').hide();
                        $('#detailPreviewImg').css('opacity', 1);
                    }
                    reader.readAsDataURL(file);
                }
            });

            // [상세페이지] 링크 변경 시 (파일 없을 때만 추출)
            $('#detailContentUrl').on('blur paste', function() {
                setTimeout(() => {
                    const url = $(this).val();
                    const fileInput = $('input[name="file"]').val();

                    // 파일이 없고, URL이 유효하며, 변경되었을 때만 실행
                    if (!fileInput && url && url.length > 10 && url !== lastDetailUrl) {

                        // 로딩 표시
                        $('#detailLoader').addClass('d-flex').show();
                        $('#detailPreviewImg').css('opacity', 0.5);

                        $.get('/mng/content/teams/meta', { url: url }, function(res) {
                            if (res) {
                                $('#detailPreviewImg').attr('src', res);
                                $('#detailHiddenImageUrl').val(res);
                                lastDetailUrl = url;
                            }
                        }).always(function() {
                            $('#detailLoader').removeClass('d-flex').hide();
                            $('#detailPreviewImg').css('opacity', 1);
                        });
                    }
                }, 100);
            });

            if(typeof initSummernote === 'function') {
                initSummernote('#summernote_edit', 400);
            } else {
                $('#summernote_edit').summernote({ height: 400, lang: 'ko-KR' });
            }

            // 차트 초기화
            initCharts();
        });

        function openEditModal() {
            modifyModal.show();
        }

        /**
         * 콘텐츠 수정 (AJAX)
         */
        function updateContent() {
            // 폼 데이터 생성
            const form = document.getElementById('modifyForm');
            const formData = new FormData(form);

            // AJAX 전송
            $.ajax({
                url: '/mng/content/teams/save',
                type: 'POST',
                data: formData,
                contentType: false,
                processData: false,
                success: function(res) {
                    if (res === 'ok') {
                        // [수정 1] 팝업 닫기 (안전한 탐색 로직)
                        // 1순위: 전역변수 modal 확인
                        if (typeof modal !== 'undefined') {
                            modal.hide();
                        }
                        // 2순위: 폼을 감싸는 모달 요소 찾기 (Bootstrap 5)
                        else {
                            const modalEl = form.closest('.modal');
                            if (modalEl) {
                                const modalInstance = bootstrap.Modal.getInstance(modalEl);
                                if (modalInstance) modalInstance.hide();
                            }
                        }

                        // [수정 2] 알림창 확인 후 새로고침
                        // 커스텀 alert 호출
                        alert('콘텐츠가 수정되었습니다.', function() {
                            location.reload(); // 확인 클릭 시 새로고침
                        });
                    } else {
                        alert('수정에 실패했습니다.');
                    }
                },
                error: function() {
                    alert('서버 통신 중 오류가 발생했습니다.');
                }
            });
        }

        // --- 통계 차트 스크립트 ---
        function initCharts() {
            // 서버에서 전달받은 JSON 데이터
            const stats = ${statsJson};
            // stats 구조: { age: [{ageGroup:'20대', cnt:10}, ...], daily: [{clickDate:'2024-02-01', cnt:5}, ...] }

            // 1. 연령대별 차트 (Bar Chart)
            const ageCtx = document.getElementById('ageChart').getContext('2d');
            const ageLabels = stats.age ? stats.age.map(d => d.ageGroup) : [];
            const ageData = stats.age ? stats.age.map(d => d.cnt) : [];

            new Chart(ageCtx, {
                type: 'bar',
                data: {
                    labels: ageLabels,
                    datasets: [{
                        label: '클릭 수',
                        data: ageData,
                        backgroundColor: 'rgba(54, 162, 235, 0.6)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1,
                        borderRadius: 5
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: { beginAtZero: true, ticks: { stepSize: 1 } }
                    }
                }
            });

            // 2. 일별 추이 차트 (Line Chart)
            const dailyCtx = document.getElementById('dailyChart').getContext('2d');
            const dailyLabels = stats.daily ? stats.daily.map(d => d.clickDate.substring(5)) : []; // MM-dd만 표시
            const dailyData = stats.daily ? stats.daily.map(d => d.cnt) : [];

            new Chart(dailyCtx, {
                type: 'line',
                data: {
                    labels: dailyLabels,
                    datasets: [{
                        label: '일별 조회수',
                        data: dailyData,
                        borderColor: '#50cd89', // 초록색 계열
                        backgroundColor: 'rgba(80, 205, 137, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        tension: 0.3 // 부드러운 곡선
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: { beginAtZero: true, ticks: { stepSize: 1 } }
                    },
                    plugins: {
                        legend: { display: false } // 범례 숨김 (심플하게)
                    }
                }
            });
        }
    </script>
</body>
</html>