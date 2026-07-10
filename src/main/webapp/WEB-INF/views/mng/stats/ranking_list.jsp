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
    <meta name="robots" content="noindex, nofollow">

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <title>직관 승률 랭킹 | 승요일기 관리자</title>
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
                                        직관 승률 랭킹
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">통계 관리</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">직관 승률 랭킹</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-7">
                                    <div class="card-body py-4">
                                        <h3 class="card-title m-0">🏆 직관 승률 랭킹 (TOP 100)</h3>
                                        <div class="text-muted fs-7 mt-1">회원들의 직관 기록을 바탕으로 집계된 순위입니다. (승리 횟수 우선)</div>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-body py-4">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5">
                                                <thead>
                                                <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                    <th class="w-80px text-center">순위</th>
                                                    <th class="min-w-150px">닉네임</th>
                                                    <th class="min-w-125px text-center">응원 구단</th>
                                                    <th class="min-w-100px text-center">총 직관</th>
                                                    <th class="min-w-80px text-center text-primary">승</th>
                                                    <th class="min-w-80px text-center text-muted">무</th>
                                                    <th class="min-w-80px text-center text-danger">패</th>
                                                    <th class="min-w-100px text-center">승률</th>
                                                    <th class="w-80px text-center">관리</th>
                                                </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                <c:forEach var="item" items="${list}" varStatus="status">

                                                    <tr class="hover-elevate-up">
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${status.count == 1}">
                                                                    <span class="badge badge-circle w-35px h-35px fs-5 text-white shadow-sm" style="background-color: #FFD700;">1</span>
                                                                </c:when>
                                                                <c:when test="${status.count == 2}">
                                                                    <span class="badge badge-circle w-35px h-35px fs-5 text-white shadow-sm" style="background-color: #C0C0C0;">2</span>
                                                                </c:when>
                                                                <c:when test="${status.count == 3}">
                                                                    <span class="badge badge-circle w-35px h-35px fs-5 text-white shadow-sm" style="background-color: #CD7F32;">3</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="fw-bold text-gray-800 fs-5">${status.count}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>

                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <span class="text-gray-800 fw-bold fs-6">${item.nickname}</span>
                                                            </div>
                                                        </td>

                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${empty item.myTeamCode or item.myTeamCode eq 'NONE'}">
                                                                    <span class="badge badge-light-secondary fw-bold">미설정</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="d-flex align-items-center justify-content-center">
                                                                        <div class="symbol symbol-30px symbol-circle me-2 border border-1 border-gray-300">
                                                                            <img src="/img/logo/logo_${fn:toLowerCase(item.myTeamCode)}.svg" class="p-1 object-fit-contain" alt="로고"/>
                                                                        </div>
                                                                        <span class="fw-bold text-gray-800">${item.myTeamName}</span>
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>

                                                        <td class="text-center">
                                                            <span class="fw-bold text-dark fs-5">${item.totalGames}</span><span class="text-muted fs-8 ms-1">회</span>
                                                        </td>

                                                        <td class="text-center fw-bolder text-primary fs-5">${item.winGames}</td>
                                                        <td class="text-center fw-bolder text-muted fs-5">${item.drawGames}</td>
                                                        <td class="text-center fw-bolder text-danger fs-5">${item.loseGames}</td>

                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${not empty item.manualWinRate}">
                                                                    <span class="badge fw-bolder fs-6 px-3 py-2" style="background-color: #E8FFF3; color: #0095E8;">
                                                                        <fmt:formatNumber value="${item.winRate}" pattern="0.0"/>%
                                                                    </span>
                                                                    <div class="fs-9 text-muted mt-1">(수동)</div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-light-primary fw-bolder fs-6 px-3 py-2">
                                                                        <fmt:formatNumber value="${item.winRate}" pattern="0.0"/>%
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>

                                                        <td class="text-center">
                                                            <a href="/mng/members/detail?memberId=${item.memberId}"
                                                               class="btn btn-icon btn-bg-light btn-active-color-primary btn-sm" title="회원 상세조회">
                                                                <i class="ki-duotone ki-magnifier fs-2">
                                                                    <span class="path1"></span>
                                                                    <span class="path2"></span>
                                                                </i>
                                                            </a>
                                                            <button type="button" class="btn btn-icon btn-bg-light btn-active-color-info btn-sm ms-1"
                                                                    title="승요율 수동 입력"
                                                                    onclick="openWinRateModal('${item.memberId}', '${item.email}', '${item.nickname}', '${item.myTeamCode}', '${item.myTeamName}', '${item.winRate}')">
                                                                <i class="ki-duotone ki-pencil fs-2">
                                                                    <span class="path1"></span><span class="path2"></span>
                                                                </i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>

                                                <c:if test="${empty list}">
                                                    <tr>
                                                        <td colspan="9" class="text-center py-10 text-muted">랭킹 데이터가 없습니다.</td>
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

    <!-- 승요율 입력 모달 -->
    <div class="modal fade" id="winRateModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered mw-400px">
            <div class="modal-content rounded-4">
                <div class="modal-header pb-0 border-0 justify-content-end">
                    <div class="btn btn-sm btn-icon btn-active-color-primary" data-bs-dismiss="modal">
                        <i class="ki-duotone ki-cross fs-1"><span class="path1"></span><span class="path2"></span></i>
                    </div>
                </div>
                <div class="modal-body scroll-y px-10 px-lg-15 pt-0 pb-15">
                    <form id="winRateForm" class="form" action="#">
                        <input type="hidden" id="modalMemberId" name="memberId">
                        <div class="mb-13 text-start">
                            <h2 class="mb-3 text-gray-900 fw-bolder">승요율 입력</h2>
                            <div class="separator mt-4 mb-5 border-gray-200"></div>

                            <div class="d-flex align-items-center mb-5">
                                <div class="w-100px text-muted fw-semibold fs-6">아이디</div>
                                <div class="fw-bold text-gray-800 fs-6" id="modalEmail">ssg_victory</div>
                            </div>
                            <div class="d-flex align-items-center mb-5">
                                <div class="w-100px text-muted fw-semibold fs-6">닉네임</div>
                                <div class="fw-bold text-gray-800 fs-6" id="modalNickname">랜더스V</div>
                            </div>
                            <div class="d-flex align-items-center mb-5">
                                <div class="w-100px text-muted fw-semibold fs-6">구단</div>
                                <div class="d-flex align-items-center">
                                    <div class="symbol symbol-20px symbol-circle me-2">
                                        <img id="modalTeamLogo" src="/img/logo/logo_ssg.svg" alt="로고">
                                    </div>
                                    <span class="fw-bold text-gray-800 fs-6" id="modalTeamName">SSG 랜더스</span>
                                </div>
                            </div>

                            <div class="separator mt-5 mb-5 border-gray-200"></div>

                            <div class="d-flex align-items-center">
                                <div class="w-100px text-muted fw-semibold fs-6">승요율</div>
                                <div class="input-group input-group-sm input-group-solid border border-gray-300 rounded" style="width: 150px; background-color: #fff;">
                                    <input type="number" class="form-control form-control-sm text-end pe-2 fs-6 fw-bold text-gray-800 bg-white" id="modalWinRate" min="0" max="100" step="0.1" value="61.1">
                                    <span class="input-group-text bg-light text-gray-600 border-start border-gray-300">%</span>
                                </div>
                            </div>
                        </div>
                        <div class="text-center d-flex justify-content-center gap-3">
                            <button type="button" class="btn btn-light w-50" data-bs-dismiss="modal">취소</button>
                            <button type="button" class="btn w-50 text-white" style="background-color: #0095E8;" onclick="submitWinRate()">
                                <span class="indicator-label fw-bold">저장</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>

    <script>
        // 모달 열기 및 데이터 세팅
        function openWinRateModal(memberId, email, nickname, teamCode, teamName, currentRate) {
            $('#modalMemberId').val(memberId);
            $('#modalEmail').text(email);
            $('#modalNickname').text(nickname);
            $('#modalTeamName').text(teamName);

            // 로고 이미지 처리
            if (teamCode && teamCode !== 'NONE') {
                $('#modalTeamLogo').attr('src', '/img/logo/logo_' + teamCode.toLowerCase() + '.svg').parent().show();
            } else {
                $('#modalTeamLogo').parent().hide();
                $('#modalTeamName').text('미설정');
            }

            // 현재 승요율 세팅
            $('#modalWinRate').val(currentRate);

            $('#winRateModal').modal('show');
        }

        // 승요율 저장 AJAX 통신
        function submitWinRate() {
            const memberId = $('#modalMemberId').val();
            let winRate = $('#modalWinRate').val();

            if(winRate === '' || winRate < 0 || winRate > 100) {
                Swal.fire({
                    text: "0에서 100 사이의 올바른 승요율을 입력해주세요.",
                    icon: "warning",
                    buttonsStyling: false,
                    confirmButtonText: "확인",
                    customClass: { confirmButton: "btn btn-primary" }
                });
                return;
            }

            $.ajax({
                url: '/mng/stats/update-win-rate',
                type: 'POST',
                data: {
                    memberId: memberId,
                    winRate: winRate
                },
                success: function(res) {
                    if (res === 'ok') {
                        Swal.fire({
                            text: "승요율이 저장되었습니다.",
                            icon: "success",
                            buttonsStyling: false,
                            confirmButtonText: "확인",
                            customClass: { confirmButton: "btn btn-primary" }
                        }).then(function() {
                            location.reload();
                        });
                    } else {
                        Swal.fire({
                            text: "저장에 실패했습니다.",
                            icon: "error",
                            buttonsStyling: false,
                            confirmButtonText: "확인",
                            customClass: { confirmButton: "btn btn-danger" }
                        });
                    }
                },
                error: function() {
                    Swal.fire({
                        text: "통신 중 오류가 발생했습니다.",
                        icon: "error",
                        buttonsStyling: false,
                        confirmButtonText: "확인",
                        customClass: { confirmButton: "btn btn-danger" }
                    });
                }
            });
        }
    </script>
</body>
</html>