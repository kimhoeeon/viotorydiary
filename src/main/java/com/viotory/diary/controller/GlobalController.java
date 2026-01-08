package com.viotory.diary.controller;

import com.viotory.diary.dto.MenuItem;
import com.viotory.diary.service.MenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.List;

// assignableTypes를 지정하여 'AdminController'에서만 이 메뉴가 동작하도록 제한 (권장)
// 만약 모든 페이지에 다 띄울거라면 (assignableTypes = ...) 부분 삭제
@ControllerAdvice(assignableTypes = {AdminController.class})
@RequiredArgsConstructor
public class GlobalController {

    private final MenuService menuService;

    // 모든 관리자 페이지 요청 시 자동으로 "menuItems"가 모델에 담깁니다.
    @ModelAttribute("menuItems")
    public List<MenuItem> menuItems() {
        return menuService.getAdminMenuItems(); // 메서드명 수정 (getMenuList -> getAdminMenuItems)
    }

}