<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>경기 관리 | 승요일기 관리자</title>
    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/css/mngStyle.css" rel="stylesheet">
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

                                <div class="card mb-7">
                                    <div class="card-body py-4 d-flex justify-content-between align-items-center">
                                        <form action="/mng/game/list" method="get" class="d-flex align-items-center">
                                            <input type="month" class="form-control form-control-solid w-150px me-3"
                                                   name="ym" value="${ym}" onchange="this.form.submit()">
                                        </form>
                                        <div>
                                            <button type="button" class="btn btn-light-primary me-2" onclick="syncData()">
                                                <i class="ki-duotone ki-arrows-circle fs-2"></i> API 동기화
                                            </button>
                                            <button type="button" class="btn btn-primary" onclick="openModal()">
                                                <i class="ki-duotone ki-plus fs-2"></i> 수동 등록
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
                                                    <th class="min-w-100px">날짜/시간</th>
                                                    <th class="min-w-150px text-center">대진 (원정 vs 홈)</th>
                                                    <th class="min-w-100px text-center">점수</th>
                                                    <th class="min-w-100px">구장</th>
                                                    <th class="min-w-100px">상태</th>
                                                    <th class="text-end min-w-100px">관리</th>
                                                </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                <c:forEach var="item" items="${list}">
                                                    <tr>
                                                        <td>
                                                            <div class="text-gray-800 fw-bold">${item.gameDate}</div>
                                                            <div class="text-gray-400 fs-7">${item.gameTime}</div>
                                                        </td>
                                                        <td class="text-center">
                                                            <span class="badge badge-light-danger fs-7 me-1">${item.awayTeamCode}</span>
                                                            <span class="text-gray-500 mx-2">vs</span>
                                                            <span class="badge badge-light-primary fs-7 ms-1">${item.homeTeamCode}</span>
                                                        </td>
                                                        <td class="text-center">
                                                            <span class="fs-5 fw-bold">${item.scoreAway} : ${item.scoreHome}</span>
                                                        </td>
                                                        <td>${item.stadiumId}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${item.status eq 'END'}"><span
                                                                        class="badge badge-light-dark">종료</span></c:when>
                                                                <c:when test="${item.status eq 'CANCEL'}"><span
                                                                        class="badge badge-light-danger">취소</span></c:when>
                                                                <c:when test="${item.status eq 'RAIN'}"><span
                                                                        class="badge badge-light-warning">우천취소</span></c:when>
                                                                <c:otherwise><span
                                                                        class="badge badge-light-success">예정</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-end">
                                                            <button class="btn btn-icon btn-bg-light btn-active-color-primary btn-sm me-1"
                                                                    onclick="editGame('${item.gameId}')">
                                                                <i class="ki-duotone ki-pencil fs-2"><span
                                                                        class="path1"></span><span class="path2"></span></i>
                                                            </button>
                                                            <button class="btn btn-icon btn-bg-light btn-active-color-danger btn-sm"
                                                                    onclick="deleteGame('${item.gameId}')">
                                                                <i class="ki-duotone ki-trash fs-2"><span
                                                                        class="path1"></span><span
                                                                        class="path2"></span><span
                                                                        class="path3"></span><span
                                                                        class="path4"></span><span class="path5"></span></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty list}">
                                                    <tr>
                                                        <td colspan="6" class="text-center py-10">경기 일정이 없습니다.</td>
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

    <div class="modal fade" id="gameModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-650px">
            <div class="modal-content">
                <form id="gameForm" action="/mng/game/save" method="post">
                    <input type="hidden" name="gameId" id="gameId">
                    <div class="modal-header">
                        <h2 class="fw-bold" id="modalTitle">경기 등록</h2>
                        <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal"><i
                                class="ki-duotone ki-cross fs-1"><span class="path1"></span><span class="path2"></span></i>
                        </div>
                    </div>
                    <div class="modal-body py-10 px-lg-17">
                        <div class="row mb-5">
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">경기 날짜</label>
                                <input type="date" class="form-control form-control-solid" name="gameDate" id="gameDate"
                                       required/>
                            </div>
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">경기 시간</label>
                                <input type="time" class="form-control form-control-solid" name="gameTime" id="gameTime"
                                       required/>
                            </div>
                        </div>
                        <div class="row mb-5">
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">원정 팀 (Away)</label>
                                <select class="form-select form-select-solid" name="awayTeamCode" id="awayTeamCode">
                                    <option value="LG">LG</option>
                                    <option value="KT">KT</option>
                                    <option value="SS">SSG</option>
                                    <option value="NC">NC</option>
                                    <option value="OB">두산</option>
                                    <option value="HT">KIA</option>
                                    <option value="LT">롯데</option>
                                    <option value="SS">삼성</option>
                                    <option value="HH">한화</option>
                                    <option value="WO">키움</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">홈 팀 (Home)</label>
                                <select class="form-select form-select-solid" name="homeTeamCode" id="homeTeamCode">
                                    <option value="LG">LG</option>
                                    <option value="KT">KT</option>
                                    <option value="SS">SSG</option>
                                    <option value="NC">NC</option>
                                    <option value="OB">두산</option>
                                    <option value="HT">KIA</option>
                                    <option value="LT">롯데</option>
                                    <option value="SS">삼성</option>
                                    <option value="HH">한화</option>
                                    <option value="WO">키움</option>
                                </select>
                            </div>
                        </div>
                        <div class="row mb-5">
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">원정 점수</label>
                                <input type="number" class="form-control form-control-solid" name="scoreAway" id="scoreAway"
                                       value="0"/>
                            </div>
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">홈 점수</label>
                                <input type="number" class="form-control form-control-solid" name="scoreHome" id="scoreHome"
                                       value="0"/>
                            </div>
                        </div>
                        <div class="row mb-5">
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">상태</label>
                                <select class="form-select form-select-solid" name="status" id="status">
                                    <option value="READY">예정</option>
                                    <option value="LIVE">진행중</option>
                                    <option value="END">종료</option>
                                    <option value="CANCEL">취소</option>
                                    <option value="RAIN">우천취소</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">구장</label>
                                <input type="text" class="form-control form-control-solid" name="stadiumId" id="stadiumId"
                                       placeholder="잠실, 사직..."/>
                            </div>
                        </div>
                        <div class="fv-row">
                            <label class="fs-6 fw-semibold mb-2">비고 (사유 등)</label>
                            <input type="text" class="form-control form-control-solid" name="etcInfo" id="etcInfo"/>
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
        const modal = new bootstrap.Modal(document.getElementById('gameModal'));

        function openModal() {
            document.getElementById('gameForm').reset();
            document.getElementById('gameId').value = '';
            document.getElementById('modalTitle').innerText = '경기 등록';
            modal.show();
        }

        function editGame(id) {
            fetch('/mng/game/get?gameId=' + id)
                .then(res => res.json())
                .then(data => {
                    document.getElementById('gameId').value = data.gameId;
                    document.getElementById('gameDate').value = data.gameDate;
                    document.getElementById('gameTime').value = data.gameTime;
                    document.getElementById('awayTeamCode').value = data.awayTeamCode;
                    document.getElementById('homeTeamCode').value = data.homeTeamCode;

                    // scoreAway, scoreHome 사용
                    document.getElementById('scoreAway').value = data.scoreAway;
                    document.getElementById('scoreHome').value = data.scoreHome;

                    document.getElementById('status').value = data.status;
                    document.getElementById('stadiumId').value = data.stadiumId;
                    document.getElementById('etcInfo').value = data.etcInfo;

                    document.getElementById('modalTitle').innerText = '경기 수정';
                    modal.show();
                });
        }

        function deleteGame(id) {
            if (confirm('삭제하시겠습니까?')) {
                $.post('/mng/game/delete', {gameId: id}, function (res) {
                    if (res === 'ok') location.reload();
                });
            }
        }

        function syncData() {
            alert('동기화 기능은 별도 구현되어 있습니다.');
        }
    </script>
</body>
</html>