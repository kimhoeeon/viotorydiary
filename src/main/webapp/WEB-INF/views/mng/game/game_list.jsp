<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>경기 데이터 관리 | Viotory Admin</title>
    <link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css"/>
    <link href="/css/mngStyle.css" rel="stylesheet">
</head>

<body id="kt_app_body" data-kt-app-layout="dark-sidebar" data-kt-app-header-fixed="true"
      data-kt-app-sidebar-enabled="true" data-kt-app-sidebar-fixed="true" class="app-default">

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
                                  <div class="card-body">
                                      <div class="d-flex align-items-center justify-content-between flex-wrap gap-5">
                                          <form action="/mng/game/syncPage" method="get"
                                                class="d-flex align-items-center">
                                              <select name="year" class="form-select form-select-solid w-125px me-3">
                                                  <c:forEach begin="2023" end="2026" var="y">
                                                      <option value="${y}" ${y eq curYear ? 'selected' : ''}>${y}년</option>
                                                  </c:forEach>
                                              </select>
                                              <select name="month" class="form-select form-select-solid w-100px me-3">
                                                  <c:forEach begin="1" end="12" var="m">
                                                      <fmt:formatNumber var="mm" value="${m}" pattern="00"/>
                                                      <option value="${mm}" ${mm eq curMonth ? 'selected' : ''}>${m}월</option>
                                                  </c:forEach>
                                              </select>
                                              <button type="submit" class="btn btn-secondary">조회</button>
                                          </form>

                                          <div class="d-flex gap-2">
                                              <button onclick="syncData('${curYear}', '${curMonth}', this)"
                                                      class="btn btn-primary">
                                                  <i class="ki-duotone ki-arrows-circle fs-2"><span
                                                          class="path1"></span><span class="path2"></span></i>
                                                  현재 월(${curMonth}월) 동기화
                                              </button>
                                              <button onclick="syncYear('${curYear}')" class="btn btn-success">
                                                  <i class="ki-duotone ki-calendar-tick fs-2"><span
                                                          class="path1"></span><span class="path2"></span><span
                                                          class="path3"></span></i>
                                                  ${curYear} 시즌 전체 동기화
                                              </button>
                                          </div>
                                      </div>
                                  </div>
                              </div>

                              <div class="card">
                                  <div class="card-header border-0 pt-6">
                                      <div class="card-title">
                                          <h3>경기 목록 <span
                                                  class="fs-6 text-gray-400 fw-bold ms-1">(${games.size()}건)</span></h3>
                                      </div>
                                  </div>
                                  <div class="card-body py-4">
                                      <div class="table-responsive">
                                          <table class="table align-middle table-row-dashed fs-6 gy-5">
                                              <thead>
                                              <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                                  <th class="min-w-100px">경기일시</th>
                                                  <th class="min-w-150px text-center">대진</th>
                                                  <th class="min-w-100px text-center">점수</th>
                                                  <th class="min-w-100px">구장</th>
                                                  <th class="min-w-100px">상태</th>
                                                  <th class="min-w-100px text-end">비고</th>
                                              </tr>
                                              </thead>
                                              <tbody class="text-gray-600 fw-semibold">
                                              <c:forEach var="game" items="${games}">
                                                  <tr>
                                                      <td>
                                                          <span class="text-gray-800 fw-bold d-block">${game.gameDate}</span>
                                                          <span class="text-gray-500 fs-7">${game.gameTime}</span>
                                                      </td>
                                                      <td class="text-center">
                                                          <span class="badge badge-light-danger me-1">${game.awayTeamName}</span>
                                                          vs
                                                          <span class="badge badge-light-primary ms-1">${game.homeTeamName}</span>
                                                      </td>
                                                      <td class="text-center fw-bold fs-5">
                                                              ${game.scoreAway} : ${game.scoreHome}
                                                      </td>
                                                      <td>${game.stadiumName}</td>
                                                      <td>
                                                          <c:choose>
                                                              <c:when test="${game.status eq 'FINISHED'}"><span
                                                                      class="badge badge-light-success">종료</span></c:when>
                                                              <c:when test="${game.status eq 'CANCELLED'}"><span
                                                                      class="badge badge-light-danger">취소</span></c:when>
                                                              <c:otherwise><span
                                                                      class="badge badge-light-warning">예정</span></c:otherwise>
                                                          </c:choose>
                                                      </td>
                                                      <td class="text-end text-gray-400 fs-7">
                                                          ID: ${game.gameId}
                                                      </td>
                                                  </tr>
                                              </c:forEach>
                                              <c:if test="${empty games}">
                                                  <tr>
                                                      <td colspan="6" class="text-center py-10">조회된 경기 데이터가 없습니다. 동기화를
                                                          진행해주세요.
                                                      </td>
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
      function syncData(year, month, btnElement) {
          if (!confirm(year + "년 " + month + "월 데이터를 동기화하시겠습니까?")) return;

          const originalText = btnElement.innerHTML;
          btnElement.innerHTML = "처리중...";
          btnElement.disabled = true;

          fetch('/mng/game/sync?year=' + year + '&month=' + month)
              .then(res => res.text())
              .then(msg => {
                  if (msg === 'ok') {
                      alert("동기화가 완료되었습니다.");
                      location.reload();
                  } else {
                      alert("오류: " + msg);
                      btnElement.innerHTML = originalText;
                      btnElement.disabled = false;
                  }
              })
              .catch(err => {
                  alert("서버 통신 오류");
                  btnElement.innerHTML = originalText;
                  btnElement.disabled = false;
              });
      }

      function syncYear(year) {
          if (!confirm(year + "시즌 전체 데이터를 동기화하시겠습니까? (시간이 소요됩니다)")) return;

          fetch('/mng/game/sync-year?year=' + year)
              .then(res => res.text())
              .then(msg => {
                  if (msg === 'ok') {
                      alert("시즌 데이터 동기화 요청이 완료되었습니다.");
                      location.reload();
                  } else {
                      alert("오류: " + msg);
                  }
              });
      }
  </script>
</body>
</html>