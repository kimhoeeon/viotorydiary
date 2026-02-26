<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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

    <title>승요 멘트 관리 | 승요일기 관리자</title>
    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/css/mngStyle.css" rel="stylesheet">
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
                            <div class="page-title d-flex flex-column justify-content-center flex-wrap me-3 my-0 mb-4">
                                <h1 class="page-heading d-flex text-dark fw-bold fs-3 flex-column justify-content-center my-0">
                                    승요 멘트 관리
                                </h1>
                                <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                                    <li class="breadcrumb-item text-muted">
                                        <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                    </li>
                                    <li class="breadcrumb-item">
                                        <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                    </li>
                                    <li class="breadcrumb-item text-muted">승요 관리</li>
                                    <li class="breadcrumb-item">
                                        <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                    </li>
                                    <li class="breadcrumb-item text-dark">승요 멘트 관리</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div id="kt_app_content" class="app-content flex-column-fluid">
                        <div id="kt_app_content_container" class="app-container container-xxl">

                            <div class="notice d-flex bg-light-primary rounded border-primary border border-dashed mb-9 p-6">
                                <i class="ki-duotone ki-information-5 fs-2tx text-primary me-4">
                                    <span class="path1"></span><span class="path2"></span><span class="path3"></span>
                                </i>
                                <div class="d-flex flex-stack flex-grow-1">
                                    <div class="fw-semibold">
                                        <h4 class="text-gray-900 fw-bold">승요력 멘트 설정 가이드</h4>
                                        <div class="fs-6 text-gray-700 mb-4">
                                            사용자의 승요력(직관 성적)에 따라 노출되는 멘트를 관리하는 페이지입니다.
                                        </div>
                                        <div class="row g-5">
                                            <div class="col-md-4">
                                                <div class="d-flex align-items-center mb-2">
                                                    <span class="badge badge-light-success me-2">승률 (WIN_RATE)</span>
                                                </div>
                                                <ul class="text-gray-600 fs-7 ps-5 m-0">
                                                    <li><strong>A</strong> : 승률 80% 이상</li>
                                                    <li><strong>B</strong> : 승률 60% 이상</li>
                                                    <li><strong>C</strong> : 승률 40% 이상</li>
                                                    <li><strong>D</strong> : 승률 40% 미만</li>
                                                    <li><strong>E</strong> : 데이터 부족</li>
                                                </ul>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="d-flex align-items-center mb-2">
                                                    <span class="badge badge-light-warning me-2">직관 수 (ATTENDANCE)</span>
                                                </div>
                                                <ul class="text-gray-600 fs-7 ps-5 m-0">
                                                    <li><strong>HEAVY</strong> : 20경기 이상</li>
                                                    <li><strong>MID</strong> : 5~19경기</li>
                                                    <li><strong>NEW</strong> : 5경기 미만</li>
                                                </ul>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="d-flex align-items-center mb-2">
                                                    <span class="badge badge-light-info me-2">최근 흐름 (TREND)</span>
                                                </div>
                                                <ul class="text-gray-600 fs-7 ps-5 m-0">
                                                    <li><strong>UP</strong> : 상승세</li>
                                                    <li><strong>DOWN</strong> : 하락세</li>
                                                    <li><strong>MAINTAIN</strong> : 유지</li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="mt-4 border-top border-primary pt-4">
                                            <span class="badge badge-light-danger me-2">TIP</span>
                                            <span class="text-gray-700 fs-7">
                                                <strong>노출 순위(Priority)</strong>란? 숫자가 작을수록(1) 상위 등급으로 인식되어 우선 노출됩니다.
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card mb-7">
                                <div class="card-body py-4 d-flex justify-content-between align-items-center flex-wrap">
                                    <div class="d-flex align-items-center gap-2 gap-lg-3 my-1">
                                        <div class="w-150px">
                                            <select class="form-select form-select-solid" data-control="select2" data-hide-search="true" data-placeholder="카테고리 전체">
                                                <option value="all">전체 보기</option>
                                                <option value="WIN_RATE">승률 기반</option>
                                                <option value="ATTENDANCE_COUNT">직관 횟수</option>
                                                <option value="RECENT_TREND">최근 흐름</option>
                                            </select>
                                        </div>
                                        <div class="position-relative w-250px">
                                            <i class="ki-duotone ki-magnifier fs-3 position-absolute top-50 translate-middle-y ms-4">
                                                <span class="path1"></span><span class="path2"></span>
                                            </i>
                                            <input type="text" class="form-control form-control-solid ps-12" placeholder="멘트 검색" />
                                        </div>
                                    </div>

                                    <div class="my-1">
                                        <button type="button" class="btn btn-primary" onclick="openModal()">
                                            <i class="ki-duotone ki-plus fs-2">
                                                <span class="path1"></span><span class="path2"></span>
                                            </i> 멘트 등록
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="card card-flush">
                                <div class="card-body">
                                    <table class="table align-middle table-row-dashed fs-6 gy-5" id="kt_ecommerce_category_table">
                                        <thead>
                                        <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                            <th class="min-w-100px text-center">분석 기준 (Category)</th>
                                            <th class="min-w-100px text-center">등급/상태 (Code)</th>
                                            <th class="min-w-50px text-center">노출순위</th>
                                            <th class="min-w-300px">멘트 내용</th>
                                            <th class="min-w-150px">관리자 설명</th>
                                            <th class="min-w-100px text-center">관리</th>
                                        </tr>
                                        </thead>
                                        <tbody class="text-gray-600 fw-semibold">
                                        <c:forEach var="item" items="${list}">
                                            <tr>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${item.category eq 'WIN_RATE'}">
                                                            <span class="badge badge-light-success fw-bold">승률 기반</span>
                                                        </c:when>
                                                        <c:when test="${item.category eq 'ATTENDANCE_COUNT'}">
                                                            <span class="badge badge-light-warning fw-bold">직관 횟수</span>
                                                        </c:when>
                                                        <c:when test="${item.category eq 'RECENT_TREND'}">
                                                            <span class="badge badge-light-info fw-bold">최근 흐름</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-light fw-bold">${item.category}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <span class="fw-bold text-gray-800">${item.conditionCode}</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="badge badge-secondary fs-7 fw-bold">${item.priority}</span>
                                                </td>
                                                <td class="text-gray-800 text-truncate" style="max-width: 300px;">
                                                    ${item.message}
                                                </td>
                                                <td class="text-gray-500 fs-7">
                                                    <c:choose>
                                                        <c:when test="${not empty item.description}">
                                                            ${item.description}
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <a href="#" class="btn btn-light btn-active-light-primary btn-sm"
                                                       data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">
                                                        관리
                                                        <i class="ki-duotone ki-down fs-5 m-0">
                                                            <span class="path1"></span>
                                                            <span class="path2"></span>
                                                        </i>
                                                    </a>
                                                    <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-125px py-4"
                                                         data-kt-menu="true">
                                                        <div class="menu-item px-3">
                                                            <a href="javascript:;" class="menu-link px-3"
                                                               onclick="editMention('${item.mentionId}', '${item.category}', '${item.conditionCode}', '${item.priority}', '${item.message}', '${item.description}')">
                                                                수정
                                                            </a>
                                                        </div>
                                                        <div class="menu-item px-3">
                                                            <a href="javascript:;" class="menu-link px-3"
                                                               onclick="deleteMention('${item.mentionId}')">
                                                                삭제
                                                            </a>
                                                        </div>
                                                    </div>
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

<div class="modal fade" tabindex="-1" id="mentionModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="modalTitle">멘트 등록</h3>
                <div class="btn btn-icon btn-sm btn-active-light-primary ms-2" data-bs-dismiss="modal" aria-label="Close">
                    <i class="ki-duotone ki-cross fs-1"><span class="path1"></span><span class="path2"></span></i>
                </div>
            </div>
            <form id="mentionForm" action="/mng/winyo/mention/save" method="post">
                <input type="hidden" name="mentionId" id="mentionId">
                <div class="modal-body">
                    <div class="fv-row mb-7">
                        <label class="required fs-6 fw-semibold mb-2">분석 기준 (Category)</label>
                        <select class="form-select form-select-solid" name="category" id="category">
                            <option value="WIN_RATE">승률 기반 (WIN_RATE)</option>
                            <option value="ATTENDANCE_COUNT">직관 횟수 (ATTENDANCE_COUNT)</option>
                            <option value="RECENT_TREND">최근 흐름 (RECENT_TREND)</option>
                        </select>
                        <div class="form-text text-muted">어떤 데이터를 기준으로 멘트를 보여줄지 선택합니다.</div>
                    </div>

                    <div class="fv-row mb-7">
                        <label class="required fs-6 fw-semibold mb-2">등급/상태 코드 (Condition Code)</label>
                        <input type="text" class="form-control form-control-solid" name="conditionCode"
                               id="conditionCode" placeholder="예: A, NEW, UP" required/>
                        <div class="form-text text-muted">
                            승률(A~E), 횟수(NEW/MID/HEAVY), 흐름(UP/DOWN/MAINTAIN/LACK_DATA) 코드를 입력하세요.
                        </div>
                    </div>

                    <div class="fv-row mb-7">
                        <label class="required fs-6 fw-semibold mb-2">노출 순위 (Priority)</label>
                        <input type="number" class="form-control form-control-solid" name="priority" id="priority"
                               value="1" required/>
                        <div class="form-text text-muted">
                            해당 조건(등급)의 서열입니다. 숫자가 작을수록(1) 상위 등급으로 인식되어 우선 노출됩니다.
                        </div>
                    </div>

                    <div class="fv-row mb-7">
                        <label class="required fs-6 fw-semibold mb-2">노출 멘트</label>
                        <textarea class="form-control form-control-solid" name="message" id="message" rows="3"
                                  placeholder="사용자에게 보여질 응원 문구를 입력하세요." required></textarea>
                    </div>

                    <div class="fv-row mb-7">
                        <label class="fs-6 fw-semibold mb-2">관리자용 설명</label>
                        <input type="text" class="form-control form-control-solid" name="description"
                               id="description" placeholder="예: 승률 80% 이상 유저에게 노출"/>
                        <div class="form-text text-muted">화면에는 노출되지 않고 관리자 참고용으로 사용됩니다.</div>
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

    function editMention(id, category, code, priority, message, description) {
        document.getElementById('mentionId').value = id;
        document.getElementById('category').value = category;
        document.getElementById('conditionCode').value = code;
        document.getElementById('priority').value = priority;
        document.getElementById('message').value = message;
        document.getElementById('description').value = (description === 'null' || description === '') ? '' : description;

        document.getElementById('modalTitle').innerText = '멘트 수정';
        modal.show();
    }
</script>
</body>
</html>