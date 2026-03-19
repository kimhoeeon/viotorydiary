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
    public String mentionList(Model model) {
        List<WinYoMentionVO> list = winYoMngService.getMentionList();
        model.addAttribute("list", list);
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

    @PostMapping("/mention/update")
    @ResponseBody
    public String updateMentionAction(@ModelAttribute WinYoMentionVO mention) {
        try {
            winYoMngService.modifyMention(mention);
            return "ok";
        } catch (Exception e) {
            log.error("멘트 수정 중 오류", e);
            return "fail";
        }
    }
}