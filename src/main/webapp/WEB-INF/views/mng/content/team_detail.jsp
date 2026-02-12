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
                                            <label class="col-lg-2 fw-semibold text-muted">콘텐츠 URL</label>
                                            <div class="col-lg-10">
                                                <a href="${content.contentUrl}" target="_blank" class="text-primary">${content.contentUrl}</a>
                                            </div>
                                        </div>

                                        <div class="separator my-10"></div>
                                        <h3 class="fw-bold mb-5">📊 콘텐츠 통계</h3>
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="card card-bordered h-100">
                                                    <div class="card-header"><div class="card-title">성별 클릭수</div></div>
                                                    <div class="card-body d-flex justify-content-center">
                                                        <canvas id="genderChart" style="max-height: 200px;"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="card card-bordered h-100">
                                                    <div class="card-header"><div class="card-title">연령대별 클릭수</div></div>
                                                    <div class="card-body d-flex justify-content-center">
                                                        <canvas id="ageChart" style="max-height: 200px;"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="card card-bordered h-100">
                                                    <div class="card-header"><div class="card-title">기간별 클릭 추이</div></div>
                                                    <div class="card-body d-flex justify-content-center">
                                                        <canvas id="dailyChart" style="max-height: 200px;"></canvas>
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
                <form action="/mng/content/teams/save" method="post" enctype="multipart/form-data">
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
                            <label class="fs-6 fw-semibold mb-2">썸네일 이미지</label>
                            <input type="file" name="file" class="form-control form-control-solid" accept="image/jpeg, image/png, image/jpg"/>
                            <c:if test="${not empty content.imageUrl}">
                                <div class="mt-2">현재 이미지: <a href="${content.imageUrl}" target="_blank">보기</a></div>
                            </c:if>
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">콘텐츠 URL</label>
                            <input type="text" class="form-control form-control-solid" name="contentUrl" value="${content.contentUrl}" />
                        </div>
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold mb-2">내용</label>
                            <textarea name="content" id="summernote_edit">${content.content}</textarea>
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
        const modifyModal = new bootstrap.Modal(document.getElementById('modifyModal'));

        $(document).ready(function() {
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

        // --- 통계 차트 스크립트 ---
        function initCharts() {
            // 서버에서 전달받은 JSON 데이터 (Controller에서 statsJson으로 전달)
            const stats = ${statsJson}; // gender:[], age:[], daily:[]

            // 1. 성별 차트 (Doughnut)
            const genderCtx = document.getElementById('genderChart').getContext('2d');
            const genderLabels = stats.gender.map(d => d.gender === 'M' ? '남성' : (d.gender === 'F' ? '여성' : '미상'));
            const genderData = stats.gender.map(d => d.cnt);

            new Chart(genderCtx, {
                type: 'doughnut',
                data: {
                    labels: genderLabels,
                    datasets: [{
                        data: genderData,
                        backgroundColor: ['#36A2EB', '#FF6384', '#FFCE56']
                    }]
                }
            });

            // 2. 연령대별 차트 (Bar)
            const ageCtx = document.getElementById('ageChart').getContext('2d');
            const ageLabels = stats.age.map(d => d.age_group + '대');
            const ageData = stats.age.map(d => d.cnt);

            new Chart(ageCtx, {
                type: 'bar',
                data: {
                    labels: ageLabels,
                    datasets: [{
                        label: '클릭 수',
                        data: ageData,
                        backgroundColor: '#4BC0C0'
                    }]
                }
            });

            // 3. 일별 차트 (Line)
            const dailyCtx = document.getElementById('dailyChart').getContext('2d');
            const dailyLabels = stats.daily.map(d => d.clickDate);
            const dailyData = stats.daily.map(d => d.cnt);

            new Chart(dailyCtx, {
                type: 'line',
                data: {
                    labels: dailyLabels,
                    datasets: [{
                        label: '일별 클릭',
                        data: dailyData,
                        borderColor: '#9966FF',
                        fill: false
                    }]
                }
            });
        }
    </script>
</body>
</html>