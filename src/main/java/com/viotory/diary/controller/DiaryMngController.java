package com.viotory.diary.controller;

import com.viotory.diary.service.DiaryMngService;
import com.viotory.diary.vo.Criteria;
import com.viotory.diary.vo.DiaryVO;
import com.viotory.diary.vo.PageDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/mng/diary")
@RequiredArgsConstructor
public class DiaryMngController {

    private final DiaryMngService diaryMngService;

    // 목록 (검색 + 페이징)
    @GetMapping("/list")
    public String listPage(Model model, Criteria cri) {
        List<DiaryVO> list = diaryMngService.getDiaryList(cri);
        int total = diaryMngService.getTotal(cri);

        model.addAttribute("list", list);
        model.addAttribute("pageMaker", new PageDTO(cri, total));

        return "mng/diary/diary_list";
    }

    // 상세
    @GetMapping("/detail")
    public String detailPage(@RequestParam("diaryId") Long diaryId,
                             @ModelAttribute("cri") Criteria cri,
                             Model model) {
        DiaryVO diary = diaryMngService.getDiary(diaryId);
        if (diary == null) return "redirect:/mng/diary/list";

        model.addAttribute("diary", diary);
        return "mng/diary/diary_detail";
    }

    // 삭제 (AJAX)
    @PostMapping("/delete")
    @ResponseBody
    public String deleteAction(@RequestParam("diaryId") Long diaryId) {
        try {
            diaryMngService.deleteDiary(diaryId);
            return "ok";
        } catch (Exception e) {
            return "fail";
        }
    }
}