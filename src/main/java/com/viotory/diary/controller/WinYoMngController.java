package com.viotory.diary.controller;

import com.viotory.diary.service.WinYoMngService;
import com.viotory.diary.vo.WinYoMentionVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/mng/winyo")
@RequiredArgsConstructor
public class WinYoMngController {

    private final WinYoMngService winYoMngService;

    // 목록 페이지
    @GetMapping("/mentions")
    public String listPage(@RequestParam(value = "category", required = false) String category,
                           Model model) {
        List<WinYoMentionVO> list = winYoMngService.getMentionList(category);
        model.addAttribute("list", list);
        model.addAttribute("category", category);
        return "mng/winyo/mention_list";
    }

    // 상세 페이지 이동
    @GetMapping("/mention/detail")
    public String detailPage(@RequestParam("mentionId") Long mentionId, Model model) {
        WinYoMentionVO mention = winYoMngService.getMention(mentionId);
        if (mention == null) return "redirect:/mng/winyo/mentions";

        model.addAttribute("mention", mention);
        return "mng/winyo/mention_detail";
    }

    // 등록 및 수정 처리
    @PostMapping("/mention/save")
    public String saveAction(WinYoMentionVO vo) {
        winYoMngService.saveMention(vo);
        return "redirect:/mng/winyo/mentions";
    }

    // 삭제 처리 (AJAX)
    @PostMapping("/mention/delete")
    @ResponseBody
    public String deleteAction(@RequestParam("mentionId") Long mentionId) {
        try {
            winYoMngService.deleteMention(mentionId);
            return "ok";
        } catch (Exception e) {
            log.error("멘트 삭제 실패", e);
            return "fail";
        }
    }

    // 상세 조회 (수정 팝업용 AJAX)
    @GetMapping("/mention/get")
    @ResponseBody
    public WinYoMentionVO getMention(@RequestParam("mentionId") Long mentionId) {
        return winYoMngService.getMention(mentionId);
    }
}