<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="kt_app_header" class="app-header">
    <div class="app-container container-fluid d-flex align-items-stretch justify-content-between">

        <div class="d-flex align-items-center flex-grow-1 flex-lg-grow-0">
            <a href="/mng/main.do" class="d-lg-none">
                <img alt="Logo" src="/assets/media/logos/default-small.svg" class="h-30px" />
            </a>
            <span class="fw-bold fs-3 ms-2 ms-lg-0 d-none d-md-block">Viotory Admin</span>
        </div>

        <div class="app-navbar flex-shrink-0">

            <div class="app-navbar-item ms-1 ms-md-3" id="kt_header_user_menu_toggle">

                <div class="cursor-pointer symbol symbol-30px symbol-md-40px"
                     data-kt-menu-trigger="{default: 'click', lg: 'hover'}"
                     data-kt-menu-attach="parent"
                     data-kt-menu-placement="bottom-end">
                    <div class="symbol-label fs-2 fw-semibold bg-primary text-white">
                        <c:out value="${sessionScope.admin.name.substring(0,1)}" default="A"/>
                    </div>
                </div>

                <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-800 menu-state-bg menu-state-color fw-semibold py-4 fs-6 w-275px" data-kt-menu="true">

                    <div class="menu-item px-3">
                        <div class="menu-content d-flex align-items-center px-3">
                            <div class="symbol symbol-50px me-5">
                                <div class="symbol-label fs-2 fw-semibold bg-primary text-white">
                                    <c:out value="${sessionScope.admin.name.substring(0,1)}" default="A"/>
                                </div>
                            </div>
                            <div class="d-flex flex-column">
                                <div class="fw-bold d-flex align-items-center fs-5">
                                    ${sessionScope.admin.name}
                                    <span class="badge badge-light-success fw-bold fs-8 px-2 py-1 ms-2">${sessionScope.admin.role}</span>
                                </div>
                                <span class="fw-semibold text-muted text-hover-primary fs-7">
                                    ${sessionScope.admin.loginId}
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="separator my-2"></div>

                    <div class="menu-item px-5">
                        <a href="#" onclick="openPasswordChangeModal(); return false;" class="menu-link px-5">
                            비밀번호 변경
                        </a>
                    </div>

                    <div class="separator my-2"></div>

                    <div class="menu-item px-5">
                        <a href="/mng/logout.do" class="menu-link px-5">
                            로그아웃
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modal_password_change" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered mw-650px">
        <div class="modal-content">
            <div class="modal-header" id="modal_password_change_header">
                <h2 class="fw-bold">비밀번호 변경</h2>
                <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                    <i class="ki-duotone ki-cross fs-1"><span class="path1"></span><span class="path2"></span></i>
                </div>
            </div>

            <div class="modal-body scroll-y mx-5 mx-xl-15 my-7">
                <form id="form_password_change" class="form" action="#">
                    <div class="d-flex flex-column mb-7 fv-row">
                        <label class="d-flex align-items-center fs-6 fw-semibold form-label mb-2">
                            <span class="required">현재 비밀번호</span>
                        </label>
                        <input type="password" class="form-control form-control-solid" name="currentPassword" />
                    </div>
                    <div class="d-flex flex-column mb-7 fv-row">
                        <label class="required fs-6 fw-semibold form-label mb-2">새 비밀번호</label>
                        <input type="password" class="form-control form-control-solid" name="newPassword" />
                    </div>
                    <div class="d-flex flex-column mb-7 fv-row">
                        <label class="required fs-6 fw-semibold form-label mb-2">새 비밀번호 확인</label>
                        <input type="password" class="form-control form-control-solid" name="confirmPassword" />
                    </div>
                    <div class="text-center pt-15">
                        <button type="reset" class="btn btn-light me-3" data-bs-dismiss="modal">취소</button>
                        <button type="button" class="btn btn-primary" onclick="submitPasswordChange()">
                            <span class="indicator-label">변경하기</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function openPasswordChangeModal() {
        $('#form_password_change')[0].reset();
        $('#modal_password_change').modal('show');
    }

    function submitPasswordChange() {
        const form = $('#form_password_change');
        const currentPw = form.find('input[name="currentPassword"]').val();
        const newPw = form.find('input[name="newPassword"]').val();
        const confirmPw = form.find('input[name="confirmPassword"]').val();

        if(!currentPw || !newPw || !confirmPw) {
            alert("모든 필드를 입력해 주세요.");
            return;
        }
        if(newPw !== confirmPw) {
            alert("새 비밀번호가 일치하지 않습니다.");
            return;
        }

        $.ajax({
            url: '/mng/profile/change-password',
            type: 'POST',
            data: { currentPassword: currentPw, newPassword: newPw },
            success: function(response) {
                if(response === 'ok') {
                    alert("비밀번호가 변경되었습니다. 다시 로그인해 주세요.");
                    location.href = '/mng/logout.do';
                } else {
                    alert(response);
                }
            },
            error: function(err) {
                alert("서버 오류가 발생했습니다.");
            }
        });
    }
</script>