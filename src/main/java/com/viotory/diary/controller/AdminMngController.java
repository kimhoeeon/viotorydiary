package com.viotory.diary.controller;

import com.viotory.diary.config.MaintenanceInterceptor;
import com.viotory.diary.service.AdminMngService;
import com.viotory.diary.vo.AdminVO;
import com.viotory.diary.vo.Criteria;
import com.viotory.diary.vo.PageDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

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

    /**
     * 점검 모드 ON/OFF 제어 API
     * URL: /mng/system/admin/maintenance/toggle
     */
    @PostMapping("/maintenance/toggle")
    @ResponseBody
    public Map<String, Object> toggleMaintenance(@RequestParam("mode") boolean mode,
                                                 @RequestParam(value="message", required=false) String message) {

        // Static 변수 값 변경 (즉시 전역 적용됨)
        MaintenanceInterceptor.isMaintenanceMode = mode;
        if (message != null && !message.isEmpty()) {
            MaintenanceInterceptor.maintenanceMessage = message;
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("isMaintenanceMode", MaintenanceInterceptor.isMaintenanceMode);
        return result;
    }

}