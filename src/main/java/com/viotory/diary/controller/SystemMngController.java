package com.viotory.diary.controller;

import com.viotory.diary.mapper.SystemMngMapper;
import com.viotory.diary.service.SystemMngService;
import com.viotory.diary.vo.AppVersionVO;
import com.viotory.diary.vo.NoticeVO;
import com.viotory.diary.vo.TermsVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/mng/system")
@RequiredArgsConstructor
public class SystemMngController {

    private final SystemMngService systemMngService;

    // ==========================================
    // 1. 공지사항 관리
    // ==========================================
    @GetMapping("/notices")
    public String noticeList(Model model) {
        List<NoticeVO> list = systemMngService.getNoticeList();
        model.addAttribute("list", list);
        return "mng/system/notice_list";
    }

    @GetMapping("/notices/detail")
    public String noticeDetail(@RequestParam("noticeId") Long noticeId, Model model) {
        NoticeVO notice = systemMngService.getNoticeById(noticeId);
        if (notice == null) return "redirect:/mng/system/notices";
        model.addAttribute("notice", notice);
        return "mng/system/notice_detail";
    }

    @PostMapping("/notices/save")
    public String noticeSave(NoticeVO notice) {
        if (notice.getNoticeId() == null) {
            systemMngService.registerNotice(notice);
        } else {
            systemMngService.updateNotice(notice);
        }
        return "redirect:/mng/system/notices";
    }

    @PostMapping("/notices/delete")
    @ResponseBody
    public String noticeDelete(@RequestParam("noticeId") Long noticeId) {
        try {
            systemMngService.deleteNotice(noticeId);
            return "ok";
        } catch (Exception e) {
            return "fail";
        }
    }

    // ==========================================
    // 2. 앱 버전 관리
    // ==========================================
    @GetMapping("/versions")
    public String versionList(Model model) {
        List<AppVersionVO> list = systemMngService.getAppVersionList();
        model.addAttribute("list", list);
        return "mng/system/version_list";
    }

    @PostMapping("/versions/save")
    public String versionSave(AppVersionVO vo) {
        systemMngService.registerAppVersion(vo);
        return "redirect:/mng/system/versions";
    }

    @PostMapping("/versions/delete")
    @ResponseBody
    public String versionDelete(@RequestParam("versionId") Long versionId) {
        try {
            systemMngService.removeAppVersion(versionId);
            return "ok";
        } catch (Exception e) {
            return "fail";
        }
    }

    // 목록 페이지
    @GetMapping("/terms")
    public String termsList(Model model) {
        model.addAttribute("list", systemMngService.getTermsList());
        return "mng/system/terms_list";
    }

    // [요청하신] 상세 페이지
    @GetMapping("/terms/detail")
    public String termsDetail(@RequestParam("termId") Long termId, Model model) {
        TermsVO term = systemMngService.getTermsById(termId);
        if(term == null) return "redirect:/mng/system/terms";

        model.addAttribute("term", term);
        return "mng/system/terms_detail";
    }

    // 저장 (등록/수정)
    @PostMapping("/terms/save")
    public String termsSave(TermsVO vo) {
        if(vo.getTermId() == null) systemMngService.registerTerms(vo);
        else systemMngService.updateTerms(vo);
        return "redirect:/mng/system/terms";
    }

    // 삭제
    @PostMapping("/terms/delete")
    @ResponseBody
    public String termsDelete(@RequestParam("termId") Long termId) {
        try {
            systemMngService.deleteTerms(termId);
            return "ok";
        } catch(Exception e) { return "fail"; }
    }

}