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

    <title>경기 관리 | 승요일기 관리자</title>
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
                                <div class="page-title d-flex flex-column justify-content-center flex-wrap me-3">
                                    <h1 class="page-heading d-flex text-dark fw-bold fs-3 flex-column justify-content-center my-0">
                                        경기 데이터 관리
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">운영 관리</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">경기 데이터 관리</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-7">
                                    <div class="card-body py-4 d-flex justify-content-between align-items-center">
                                        <form action="/mng/game/list" method="get" class="d-flex align-items-center">
                                            <input type="month" class="form-control form-control-solid w-150px me-3"
                                                   name="ym" value="${ym}" onchange="this.form.submit()">
                                        </form>
                                        <div>
                                            <button type="button" class="btn btn-light-success me-2" onclick="syncData('MONTH')">
                                                <i class="ki-duotone ki-calendar-8 fs-2">
                                                    <span class="path1"></span>
                                                    <span class="path2"></span>
                                                    <span class="path3"></span>
                                                    <span class="path4"></span>
                                                    <span class="path5"></span>
                                                    <span class="path6"></span>
                                                </i> 월간 동기화
                                            </button>
                                            <button type="button" class="btn btn-light-primary me-2" onclick="syncData('YEAR')">
                                                <i class="ki-duotone ki-calendar fs-2">
                                                    <span class="path1"></span>
                                                    <span class="path2"></span>
                                                </i> 연간 동기화
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
                                                        <th class="min-w-100px">관리</th>
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
                                                            <td>${item.stadiumName}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${item.status eq 'FINISHED'}">
                                                                        <span class="badge badge-light-dark">종료</span>
                                                                    </c:when>
                                                                    <c:when test="${item.status eq 'CANCELLED'}">
                                                                        <span class="badge badge-light-danger">취소</span>
                                                                    </c:when>
                                                                    <c:when test="${item.status eq 'RAIN'}">
                                                                        <span class="badge badge-light-warning">우천취소</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge badge-light-success">예정</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <button class="btn btn-icon btn-bg-light btn-active-color-primary btn-sm me-1"
                                                                        onclick="editGame('${item.gameId}')">
                                                                    <i class="ki-duotone ki-pencil fs-2">
                                                                        <span class="path1"></span>
                                                                        <span class="path2"></span>
                                                                    </i>
                                                                </button>
                                                                <button class="btn btn-icon btn-bg-light btn-active-color-danger btn-sm"
                                                                        onclick="deleteGame('${item.gameId}')">
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
                <form id="gameForm" method="post">
                    <input type="hidden" name="gameId" id="gameId">
                    <div class="modal-header">
                        <h2 class="fw-bold" id="modalTitle">경기 등록</h2>
                        <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                            <i class="ki-duotone ki-cross fs-1">
                                <span class="path1"></span>
                                <span class="path2"></span>
                            </i>
                        </div>
                    </div>
                    <div class="modal-body py-10 px-lg-17">
                        <div class="row mb-5">
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">경기 날짜</label>
                                <input type="date" class="form-control form-control-solid" name="gameDate" id="gameDate" required/>
                            </div>
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">경기 시간</label>
                                <input type="time" class="form-control form-control-solid" name="gameTime" id="gameTime" required/>
                            </div>
                        </div>
                        <div class="row mb-5">
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">원정 팀 (Away)</label>
                                <select class="form-select form-select-solid" name="awayTeamCode" id="awayTeamCode">
                                    <option value="LG">LG</option>
                                    <option value="KT">KT</option>
                                    <option value="SSG">SSG</option>
                                    <option value="NC">NC</option>
                                    <option value="DOOSAN">두산</option>
                                    <option value="KIA">KIA</option>
                                    <option value="LOTTE">롯데</option>
                                    <option value="SAMSUNG">삼성</option>
                                    <option value="HANWHA">한화</option>
                                    <option value="KIWOOM">키움</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="required fs-6 fw-semibold mb-2">홈 팀 (Home)</label>
                                <select class="form-select form-select-solid" name="homeTeamCode" id="homeTeamCode">
                                    <option value="LG">LG</option>
                                    <option value="KT">KT</option>
                                    <option value="SSG">SSG</option>
                                    <option value="NC">NC</option>
                                    <option value="DOOSAN">두산</option>
                                    <option value="KIA">KIA</option>
                                    <option value="LOTTE">롯데</option>
                                    <option value="SAMSUNG">삼성</option>
                                    <option value="HANWHA">한화</option>
                                    <option value="KIWOOM">키움</option>
                                </select>
                            </div>
                        </div>
                        <div class="row mb-5">
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">원정 점수</label>
                                <input type="number" class="form-control form-control-solid" name="scoreAway" id="scoreAway" value="0"/>
                            </div>
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">홈 점수</label>
                                <input type="number" class="form-control form-control-solid" name="scoreHome" id="scoreHome" value="0"/>
                            </div>
                        </div>
                        <div class="row mb-5">
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">상태</label>
                                <select class="form-select form-select-solid" name="status" id="status">
                                    <option value="SCHEDULED">예정</option>
                                    <option value="LIVE">진행중</option>
                                    <option value="FINISHED">종료</option>
                                    <option value="CANCELLED">취소</option>
                                    <option value="RAIN">우천취소</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="fs-6 fw-semibold mb-2">구장</label>
                                <select class="form-select form-select-solid" name="stadiumId" id="stadiumId">
                                    <option value="">구장 선택</option>
                                    <c:forEach var="stadium" items="${stadiums}">
                                        <option value="${stadium.stadiumId}">${stadium.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="homeStarter" class="form-label">홈 선발투수</label>
                                <input type="text" class="form-control" id="homeStarter" name="homeStarter">
                            </div>
                            <div class="col-md-6">
                                <label for="awayStarter" class="form-label">원정 선발투수</label>
                                <input type="text" class="form-control" id="awayStarter" name="awayStarter">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="cancelReason" class="form-label">취소 사유</label>
                            <input type="text" class="form-control" id="cancelReason" name="cancelReason" placeholder="예: 우천취소, 미세먼지 등">
                        </div>
                        <div class="fv-row">
                            <label class="fs-6 fw-semibold mb-2">비고 (사유 등)</label>
                            <input type="text" class="form-control form-control-solid" name="etcInfo" id="etcInfo"/>
                        </div>
                    </div>
                    <div class="modal-footer flex-center">
                        <button type="button" class="btn btn-light me-3" data-bs-dismiss="modal">취소</button>
                        <button type="button" class="btn btn-primary" onclick="saveGameAction()">저장</button>
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
                    document.getElementById('scoreAway').value = data.scoreAway;
                    document.getElementById('scoreHome').value = data.scoreHome;
                    document.getElementById('status').value = data.status;
                    document.getElementById('stadiumId').value = data.stadiumId;
                    document.getElementById('etcInfo').value = data.etcInfo;

                    document.getElementById('homeStarter').value = data.homeStarter || ''; // null 방지
                    document.getElementById('awayStarter').value = data.awayStarter || '';
                    document.getElementById('cancelReason').value = data.cancelReason || '';

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

        function syncData(type) {
            // 1. 현재 선택된 '년-월' 값 가져오기 (예: 2026-05)
            const ym = document.querySelector('input[name="ym"]').value;

            if (!ym) {
                alert('날짜를 선택해 주세요.');
                return;
            }

            // 2. 연도와 월 추출
            const parts = ym.split('-');
            const year = parts[0];  // 2026
            const month = parts[1]; // 05

            let url = '';
            let confirmMsg = '';
            let postData = {};

            // 3. 타입별 로직 분기
            if (type === 'MONTH') {
                // [월간] 해당 월만 동기화
                url = '/mng/game/syncMonthly'; // (Backend Controller에 해당 매핑 필요)
                confirmMsg = year + '년 ' + month + '월 경기 데이터를 동기화하시겠습니까?\n(해당 월의 데이터만 갱신됩니다)';
                postData = { year: year, month: month };

            } else {
                // [연간] 해당 연도 전체 동기화
                url = '/mng/game/syncYearly';
                confirmMsg = year + '년도 전체 경기 데이터를 API와 동기화하시겠습니까?\n(기존 데이터가 갱신될 수 있습니다)';
                postData = { year: year };
            }

            // 3. 사용자 확인 및 AJAX 요청 전송
            if (confirm(confirmMsg)) {
                // 로딩 표시가 필요하다면 여기에 추가 (예: 버튼 비활성화)

                $.post(url, postData, function (res) {
                    if (res === 'ok') {
                        alert(year + '년도 데이터 동기화가 완료되었습니다.');
                        location.reload(); // 목록 갱신
                    } else {
                        alert('동기화 실패: ' + res);
                    }
                }).fail(function() {
                    alert('서버 통신 중 오류가 발생했습니다.');
                });
            }
        }

        // [추가] 경기 저장 (AJAX)
        function saveGameAction() {
            // 1. 유효성 검사
            const gameDate = $('#gameDate').val();
            const gameTime = $('#gameTime').val();

            if (!gameDate || !gameTime) {
                alert('경기 날짜와 시간을 입력해주세요.');
                return;
            }

            // 2. 폼 데이터 생성
            const form = document.getElementById('gameForm');
            const formData = new FormData(form);

            // 3. AJAX 전송
            $.ajax({
                url: '/mng/game/save',
                type: 'POST',
                data: formData,
                contentType: false, // FormData 사용 시 필수
                processData: false, // FormData 사용 시 필수
                success: function(res) {
                    if (res === 'ok') {
                        // [중요] 1. 팝업(모달) 먼저 닫기
                        // (modal 변수가 상단에 선언되어 있다고 가정. 만약 안된다면 $('#gameModal').modal('hide'); 사용)
                        if (typeof modal !== 'undefined') {
                            modal.hide();
                        } else {
                            // Bootstrap 5 인스턴스 가져오기 안전장치
                            const myModalEl = document.getElementById('gameModal');
                            const myModal = bootstrap.Modal.getInstance(myModalEl);
                            if (myModal) myModal.hide();
                        }

                        // [중요] 2. 커스텀 알림창 띄우고 확인 클릭 시 새로고침
                        alert('저장되었습니다.', function() {
                            location.reload();
                        });
                    } else {
                        alert('저장에 실패했습니다.\n' + res);
                    }
                },
                error: function(err) {
                    console.error(err);
                    alert('서버 통신 중 오류가 발생했습니다.');
                }
            });
        }
    </script>
</body>
</html>