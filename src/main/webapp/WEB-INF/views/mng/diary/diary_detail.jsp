<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
    <meta name="format-detection" content="telephone=no,email=no,address=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes" />

    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="manifest" href="/site.webmanifest" />

    <title>일기 상세 | 승요일기 관리자</title>
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
                                        전체 일기 목록
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">일기 관리</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">전체 일기 목록</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-header border-0 cursor-pointer">
                                        <div class="card-title m-0"><h3 class="fw-bold m-0">일기 상세 정보</h3></div>
                                        <div class="card-toolbar">
                                            <c:if test="${diary.status eq 'COMPLETED'}">
                                                <button type="button" class="btn btn-sm btn-light-danger"
                                                        onclick="deleteDiary()">관리자 삭제
                                                </button>
                                            </c:if>
                                            <c:if test="${diary.status eq 'DELETED'}">
                                                <span class="badge badge-light-danger fs-6">삭제된 일기</span>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="card-body p-9">
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">작성자</label>
                                            <div class="col-lg-4">
                                                <span class="fw-bold fs-6 text-gray-800">${diary.memberName} (${diary.memberEmail})</span>
                                            </div>
                                            <label class="col-lg-2 fw-semibold text-muted">작성일</label>
                                            <div class="col-lg-4">
                                                <span class="fw-bold fs-6 text-gray-800">
                                                    <fmt:parseDate value="${diary.createdAt}"
                                                                   pattern="yyyy-MM-dd'T'HH:mm:ss" var="regDate"
                                                                   type="both"/>
                                                    <fmt:formatDate value="${regDate}" pattern="yyyy-MM-dd HH:mm"/>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">관람 경기</label>
                                            <div class="col-lg-10">
                                                <c:if test="${not empty diary.gameDate}">
                                                    <div class="d-flex align-items-center bg-light p-3 rounded">
                                                        <span class="badge badge-primary me-2">GAME</span>
                                                        <span class="fw-bold text-gray-800 me-3">${diary.gameDate} ${diary.gameTime}</span>
                                                        <span class="text-gray-600">${diary.stadiumName} | ${diary.awayTeamName} vs ${diary.homeTeamName}</span>
                                                    </div>
                                                </c:if>
                                                <c:if test="${empty diary.gameDate}"><span
                                                        class="text-gray-400">경기 정보 없음</span></c:if>
                                            </div>
                                        </div>
                                        <div class="row mb-7">
                                            <label class="col-lg-2 fw-semibold text-muted">내용</label>
                                            <div class="col-lg-10">
                                                <div class="p-5 border rounded bg-white text-gray-800 fs-6"
                                                     style="white-space: pre-wrap; min-height: 200px;">${diary.content}</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-footer d-flex justify-content-end py-6 px-9">
                                        <a href="/mng/diary/list" class="btn btn-light btn-active-light-primary">목록으로</a>
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
        function deleteDiary() {
            if (confirm('이 일기를 관리자 권한으로 삭제하시겠습니까?\n삭제 후에는 사용자에게 노출되지 않습니다.')) {
                $.post('/mng/diary/delete', {diaryId: '${diary.diaryId}'}, function (res) {
                    if (res === 'ok') {
                        alert('삭제 처리되었습니다.');
                        location.reload();
                    } else {
                        alert('오류가 발생했습니다.');
                    }
                });
            }
        }
    </script>
</body>
</html>