package com.viotory.diary.controller;

import com.viotory.diary.dto.MenuItem;
import com.viotory.diary.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.List;

@ControllerAdvice
public class GlobalController {

    @Autowired
    private MenuService menuService;

    @ModelAttribute("menuItems")
    public List<MenuItem> menuItems() {
        return menuService.getMenuList();
    }

}
