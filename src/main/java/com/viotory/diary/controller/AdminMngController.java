package com.viotory.diary.controller;

import com.viotory.diary.service.AdminMngService;
import com.viotory.diary.vo.AdminVO;
import com.viotory.diary.vo.Criteria;
import com.viotory.diary.vo.PageDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/mng/system/admin")
@RequiredArgsConstructor
public class AdminMngController {

    private final AdminMngService adminMngService;

    @GetMapping("/list")
    public String list(Model model, @ModelAttribute("cri") Criteria cri) {
        int total = adminMngService.getAdminCount(cri);
        model.addAttribute("list", adminMngService.getAdminList(cri));
        model.addAttribute("pageMaker", new PageDTO(cri, total));
        return "mng/system/admin_list";
    }

    @GetMapping("/form")
    public String form(@RequestParam(value = "id", required = false) Long adminId, Model model) {
        if (adminId != null) {
            model.addAttribute("vo", adminMngService.getAdmin(adminId));
        }
        return "mng/system/admin_form";
    }

    @PostMapping("/save")
    public String save(AdminVO vo) {
        adminMngService.saveAdmin(vo);
        return "redirect:/mng/system/admin/list";
    }

    @PostMapping("/delete")
    @ResponseBody
    public String delete(@RequestParam("adminId") Long adminId) {
        try {
            adminMngService.deleteAdmin(adminId);
            return "ok";
        } catch (Exception e) {
            return "fail";
        }
    }

    @GetMapping("/checkId")
    @ResponseBody
    public boolean checkId(@RequestParam("loginId") String loginId) {
        return adminMngService.isIdDuplicate(loginId);
    }
}