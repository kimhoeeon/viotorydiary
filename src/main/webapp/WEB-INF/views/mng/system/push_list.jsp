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
    
    <title>푸시 알림 관리 | 승요일기 관리자</title>
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
                                        푸시 알림 발송
                                    </h1>

                                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
                                        <li class="breadcrumb-item text-muted">
                                            <a href="/mng/main.do" class="text-muted text-hover-primary">Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-muted">시스템 관리</li>
                                        <li class="breadcrumb-item">
                                            <span class="bullet bg-gray-400 w-5px h-2px"></span>
                                        </li>
                                        <li class="breadcrumb-item text-dark">푸시 알림 발송</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div id="kt_app_content" class="app-content flex-column-fluid">
                            <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                <div class="card mb-7">
                                    <div class="card-header">
                                        <div class="card-title"><h3 class="fw-bold m-0">🔔 전체 푸시 알림 발송</h3></div>
                                    </div>
                                    <div class="card-body">
                                        <form id="pushForm" action="/mng/system/push/send" method="post">
                                            <div class="row mb-5">
                                                <div class="col-md-12">
                                                    <label class="required fs-6 fw-semibold mb-2">알림 제목</label>
                                                    <input type="text" class="form-control form-control-solid" name="title"
                                                           placeholder="예: [긴급] 오늘 경기 우천 취소 안내" required/>
                                                </div>
                                            </div>
                                            <div class="row mb-5">
                                                <div class="col-md-12">
                                                    <label class="required fs-6 fw-semibold mb-2">알림 내용</label>
                                                    <textarea class="form-control form-control-solid" name="content"
                                                              rows="3" placeholder="내용을 입력하세요." required></textarea>
                                                </div>
                                            </div>
                                            <div class="row mb-5">
                                                <div class="col-md-12">
                                                    <label class="fs-6 fw-semibold mb-2">이동 링크 (Deep Link)</label>
                                                    <input type="text" class="form-control form-control-solid"
                                                           name="linkUrl" placeholder="예: /mng/event/detail?id=5 (선택사항)"/>
                                                </div>
                                            </div>
                                            <div class="d-flex justify-content-end">
                                                <button type="submit" class="btn btn-primary"
                                                        onclick="return confirmSend()">
                                                    <i class="ki-duotone ki-send fs-2">
                                                        <span class="path1"></span>
                                                        <span class="path2"></span>
                                                    </i> 발송하기
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-header">
                                        <div class="card-title"><h3 class="fw-bold m-0">발송 이력</h3></div>
                                    </div>
                                    <div class="card-body py-4">
                                        <div class="table-responsive">
                                            <table class="table align-middle table-row-dashed fs-6 gy-5">
                                                <thead>
                                                <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                    <th class="min-w-50px">No</th>
                                                    <th class="min-w-150px">제목</th>
                                                    <th class="min-w-250px">내용</th>
                                                    <th class="min-w-100px">링크</th>
                                                    <th class="min-w-50px">대상</th>
                                                    <th class="min-w-50px">인원</th>
                                                    <th class="min-w-100px">발송일시</th>
                                                    <th class="min-w-50px">상태</th>
                                                </tr>
                                                </thead>
                                                <tbody class="text-gray-600 fw-semibold">
                                                <c:forEach var="item" items="${list}">
                                                    <tr>
                                                        <td>${item.pushId}</td>
                                                        <td class="text-gray-800 fw-bold">${item.title}</td>
                                                        <td>${item.content}</td>
                                                        <td>
                                                            <c:if test="${not empty item.linkUrl}"><span
                                                                    class="badge badge-light">${item.linkUrl}</span></c:if>
                                                            <c:if test="${empty item.linkUrl}">-</c:if>
                                                        </td>
                                                        <td><span class="badge badge-light-primary">전체</span></td>
                                                        <td>${item.sendCount}명</td>
                                                        <td>
                                                            <fmt:parseDate value="${item.createdAt}"
                                                                           pattern="yyyy-MM-dd'T'HH:mm:ss" var="sendDate"
                                                                           type="both"/>
                                                            <fmt:formatDate value="${sendDate}" pattern="yyyy-MM-dd HH:mm"/>
                                                        </td>
                                                        <td><span class="badge badge-light-success">${item.status}</span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty list}">
                                                    <tr>
                                                        <td colspan="8" class="text-center py-10">발송 이력이 없습니다.</td>
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

    <script src="/assets/plugins/global/plugins.bundle.js"></script>
    <script src="/assets/js/scripts.bundle.js"></script>
    <script>
        function confirmSend() {
            return confirm("전체 회원에게 푸시 알림을 발송하시겠습니까?\n발송 후에는 취소할 수 없습니다.");
        }
    </script>
</body>
</html>