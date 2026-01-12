<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>관리자 메인 | Viotory Admin</title>
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

    <c:if test="${sessionScope.status ne 'logon'}">
        <script>
            alert("로그인해 주세요.");
            location.href = '/mng/index.do';
        </script>
    </c:if>

    <c:if test="${sessionScope.status eq 'logon'}">
        <div class="d-flex flex-column flex-root app-root" id="kt_app_root">
            <div class="app-page flex-column flex-column-fluid" id="kt_app_page">

                <jsp:include page="/WEB-INF/views/mng/include/header.jsp" />

                <div class="app-wrapper flex-column flex-row-fluid" id="kt_app_wrapper">

                    <jsp:include page="/WEB-INF/views/mng/include/sidebar.jsp" />

                    <div class="app-main flex-column flex-row-fluid" id="kt_app_main">
                        <div class="d-flex flex-column flex-column-fluid">

                            <div id="kt_app_content" class="app-content flex-column-fluid">
                                <div id="kt_app_content_container" class="app-container container-xxl pt-10">

                                    <div class="card shadow-sm mb-5 mb-xl-10">
                                        <div class="card-header">
                                            <div class="card-title">
                                                <h3>⚾ 경기 데이터 수동 동기화</h3>
                                            </div>
                                        </div>

                                        <div class="card-body">
                                            <p class="text-muted mb-5">네이버 스포츠 API를 통해 경기 일정과 결과를 수동으로 가져옵니다.</p>

                                            <div class="d-flex gap-2">
                                                <button onclick="syncData('2025', '03', this)" class="btn btn-primary">2025년 3월 동기화</button>
                                                <button onclick="syncData('2025', '04', this)" class="btn btn-primary">4월</button>
                                                <button onclick="syncData('2025', '05', this)" class="btn btn-primary">5월</button>
                                                <div class="vr"></div>
                                                <button onclick="syncYear('2025')" class="btn btn-success">2025 시즌 전체 동기화</button>
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
            function syncData(year, month, btnElement) {
                if(!confirm(year + "년 " + month + "월 데이터를 동기화하시겠습니까?")) return;

                const originalText = btnElement ? btnElement.innerText : "";
                if(btnElement) {
                    btnElement.innerText = "처리중...";
                    btnElement.disabled = true;
                }

                fetch('/mng/game/sync?year=' + year + '&month=' + month)
                    .then(res => res.text())
                    .then(msg => {
                        alert(msg);
                        if(btnElement) {
                            btnElement.innerText = originalText;
                            btnElement.disabled = false;
                        }
                    })
                    .catch(err => {
                        alert("오류 발생: " + err);
                        if(btnElement) {
                            btnElement.innerText = originalText;
                            btnElement.disabled = false;
                        }
                    });
            }

            function syncYear(year) {
                if(!confirm(year + "년도 전체 데이터를 동기화하시겠습니까? (시간이 걸릴 수 있습니다)")) return;

                fetch('/mng/game/sync-year?year=' + year)
                    .then(res => res.text())
                    .then(msg => alert(msg))
                    .catch(err => alert("오류 발생: " + err));
            }
        </script>
    </c:if>
</body>
</html>