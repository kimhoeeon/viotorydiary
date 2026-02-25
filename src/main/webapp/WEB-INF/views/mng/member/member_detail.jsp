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

    <title>회원 상세 | 승요일기 관리자</title>
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
                                        회원 목록
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">회원 관리</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">회원 목록</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-header border-0 cursor-pointer">
                                        <div class="card-title m-0">
                                            <h3 class="fw-bold m-0">회원 상세 정보</h3>
                                        </div>
                                        <div class="card-toolbar">
                                            <c:if test="${member.status eq 'ACTIVE'}">
                                                <button type="button" class="btn btn-sm btn-light-warning me-2" onclick="changeStatus('SUSPENDED')">
                                                    활동 정지
                                                </button>
                                                <button type="button" class="btn btn-sm btn-light-danger me-2" onclick="changeStatus('WITHDRAWN')">
                                                    강제 탈퇴
                                                </button>
                                                <button type="button" class="btn btn-sm btn-light-primary" onclick="resetPassword()">
                                                    비밀번호 초기화
                                                </button>
                                            </c:if>
                                            <c:if test="${member.status eq 'SUSPENDED'}">
                                                <button type="button" class="btn btn-sm btn-light-success me-2" onclick="changeStatus('ACTIVE')">
                                                    정지 해제
                                                </button>
                                                <button type="button" class="btn btn-sm btn-light-danger me-2" onclick="changeStatus('WITHDRAWN')">
                                                    강제 탈퇴
                                                </button>
                                                <button type="button" class="btn btn-sm btn-light-primary" onclick="resetPassword()">
                                                    비밀번호 초기화
                                                </button>
                                            </c:if>
                                            <c:if test="${member.status eq 'WITHDRAWN'}">
                                                <span class="badge badge-light-danger fs-6">탈퇴 회원</span>
                                            </c:if>
                                        </div>
                                    </div>

                                    <div class="card-body p-9">
                                        <input type="hidden" id="memberId" value="${member.memberId}">

                                        <div class="mb-10">
                                            <h3 class="fw-bolder mb-6 text-gray-900">기본 정보</h3>

                                            <div class="row mb-7 align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">현재 상태</label>
                                                <div class="col-lg-4">
                                                    <c:choose>
                                                        <c:when test="${member.status eq 'ACTIVE'}"><span class="badge badge-light-success fs-7">정상</span></c:when>
                                                        <c:when test="${member.status eq 'SUSPENDED'}"><span class="badge badge-light-warning fs-7">정지</span></c:when>
                                                        <c:when test="${member.status eq 'WITHDRAWN'}"><span class="badge badge-light-danger fs-7">탈퇴</span></c:when>
                                                        <c:otherwise><span class="badge badge-light-secondary fs-7">${member.status}</span></c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">이메일</label>
                                                <div class="col-lg-4 d-flex align-items-center">
                                                    <span class="fw-bold fs-6 text-gray-800">${member.email}</span>
                                                    <c:if test="${not empty member.socialProvider and member.socialProvider ne 'NONE'}">
                                                        <span class="badge fs-9 ms-2" style="background-color: #f8df00; color: #3c1e1e;">${member.socialProvider}</span>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <div class="row mb-7 align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">닉네임</label>
                                                <div class="col-lg-4">
                                                    <div class="d-flex align-items-center">
                                                        <input type="text" id="nickname" class="form-control form-control-sm form-control-solid w-200px me-3" value="${member.nickname}">
                                                        <button type="button" class="btn btn-sm btn-primary text-nowrap" onclick="updateMemberInfo()">수정</button>
                                                    </div>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">연락처</label>
                                                <div class="col-lg-4">
                                                    <div class="d-flex align-items-center">
                                                        <input type="text" id="phoneNumber" class="form-control form-control-sm form-control-solid w-200px me-3" value="${member.phoneNumber}" placeholder="숫자만 입력">
                                                        <button type="button" class="btn btn-sm btn-primary text-nowrap" onclick="updateMemberInfo()">수정</button>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">비밀번호</label>
                                                <div class="col-lg-4">
                                                    <div class="d-flex align-items-center">
                                                        <button type="button" class="btn btn-sm btn-danger text-nowrap me-3" onclick="resetPassword()">비밀번호 초기화</button>
                                                    </div>
                                                    <div class="fs-8 text-muted mt-2">(가입된 연락처로 SMS 임시 비밀번호 발송)</div>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">생년월일</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">${empty member.birthdate ? '-' : member.birthdate}</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="separator separator-dashed my-10"></div>

                                        <div class="mb-10">
                                            <h3 class="fw-bolder mb-6 text-gray-900">승요 정보</h3>

                                            <div class="row mb-7 align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">응원 구단</label>
                                                <div class="col-lg-4">
                                                    <span class="badge badge-light-primary fw-bold fs-6">${empty member.myTeamName ? '미설정' : member.myTeamName}</span>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">최다 방문 구장</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">${empty member.mostVisitedStadium ? '기록 없음' : member.mostVisitedStadium}</span>
                                                </div>
                                            </div>

                                            <div class="row align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">예측 승률</label>
                                                <div class="col-lg-4">
                                                    <c:set var="totalGames" value="${member.winCount + member.loseCount}" />
                                                    <c:set var="winRate" value="0.0" />
                                                    <c:if test="${totalGames > 0}">
                                                        <c:set var="winRate" value="${(member.winCount * 100.0) / totalGames}" />
                                                    </c:if>
                                                    <span class="fw-bolder fs-3 text-primary"><fmt:formatNumber value="${winRate}" pattern="0.0"/>%</span>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">전적</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">${member.winCount}승 ${member.loseCount}패</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="separator separator-dashed my-10"></div>

                                        <div class="mb-10">
                                            <h3 class="fw-bolder mb-6 text-gray-900">이용 정보</h3>

                                            <div class="row mb-7 align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">이번달 직관 횟수</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">${member.monthlyAttendanceCount} 회</span>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">누적 직관 횟수</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">${member.totalAttendanceCount} 회</span>
                                                </div>
                                            </div>

                                            <div class="row align-items-center">
                                                <label class="col-lg-2 fw-semibold text-muted">팔로우 / 팔로워 (맞팔)</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">
                                                        <span class="text-primary">${member.followingCount}</span> / <span class="text-info">${member.followerCount}</span>
                                                        <span class="text-muted fs-7 ms-1">(${member.mutualFollowCount}명)</span>
                                                    </span>
                                                </div>
                                                <label class="col-lg-2 fw-semibold text-muted">가입일시</label>
                                                <div class="col-lg-4">
                                                    <span class="fw-bold fs-6 text-gray-800">
                                                        <c:choose>
                                                            <c:when test="${not empty member.createdAt}">
                                                                <c:set var="cDate" value="${fn:replace(member.createdAt, 'T', ' ')}" />
                                                                <c:choose>
                                                                    <c:when test="${fn:length(cDate) == 16}">${cDate}:00</c:when>
                                                                    <c:otherwise>${fn:substring(cDate, 0, 19)}</c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="card-footer d-flex justify-content-end py-6 px-9">
                                        <a href="/mng/members/list" class="btn btn-light btn-active-light-primary">목록으로</a>
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
    <script>
        function changeStatus(status) {
            let msg = '';
            if (status === 'SUSPENDED') msg = '활동 정지 처리하시겠습니까?';
            else if (status === 'WITHDRAWN') msg = '강제 탈퇴 처리하시겠습니까? (복구 불가)';
            else if (status === 'ACTIVE') msg = '정지를 해제하시겠습니까?';

            if (confirm(msg)) {
                $.post('/mng/members/updateStatus', {
                    memberId: '${member.memberId}',
                    status: status
                }, function (res) {
                    if (res === 'ok') {
                        alert('처리되었습니다.');
                        location.reload();
                    } else {
                        alert('오류가 발생했습니다.');
                    }
                });
            }
        }

        // 관리자: 닉네임, 연락처 수정 기능
        function updateMemberInfo() {
            var memberId = $('#memberId').val();
            var nickname = $('#nickname').val();
            var phoneNumber = $('#phoneNumber').val();

            if(!nickname) { alert('닉네임을 입력해주세요.'); return; }

            if(confirm("회원 정보를 수정하시겠습니까?")) {
                $.ajax({
                    url: '/mng/members/updateInfo',
                    type: 'POST',
                    data: {
                        memberId: memberId,
                        nickname: nickname,
                        phoneNumber: phoneNumber
                    },
                    success: function(res) {
                        if(res === 'ok') {
                            alert("수정되었습니다.");
                        } else {
                            alert("수정 중 오류가 발생했습니다.");
                        }
                    }
                });
            }
        }

        // 관리자: 비밀번호 초기화 및 SMS 발송
        function resetPassword() {
            var memberId = $('#memberId').val();

            if(confirm("해당 회원의 비밀번호를 초기화하시겠습니까?\\n임시 비밀번호가 회원의 연락처로 문자로 발송됩니다.")) {
                $.ajax({
                    url: '/mng/members/resetPassword',
                    type: 'POST',
                    data: { memberId: memberId },
                    success: function(res) {
                        if(res === 'ok') {
                            alert("비밀번호 초기화 완료 및 SMS 문자가 정상 발송되었습니다.");
                        } else if(res === 'no_phone') {
                            alert("등록된 연락처가 없어 SMS를 발송할 수 없습니다.");
                        } else {
                            alert("처리 중 오류가 발생했습니다.");
                        }
                    }
                });
            }
        }
    </script>
</body>
</html>