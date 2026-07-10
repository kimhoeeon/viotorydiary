package com.viotory.diary.controller;

import com.viotory.diary.service.StatsMngService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Controller
@RequestMapping("/mng/stats")
@RequiredArgsConstructor
public class StatsMngController {

    private final StatsMngService statsMngService;

    // 직관 랭킹 페이지
    @GetMapping("/ranking")
    public String rankingList(
            @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
            @RequestParam(value = "amount", defaultValue = "10") int amount,
            @RequestParam(value = "sortCol", defaultValue = "winRate") String sortCol,
            @RequestParam(value = "sortDir", defaultValue = "DESC") String sortDir,
            Model model) {

        Map<String, Object> result = statsMngService.getRankingList(pageNum, amount, sortCol, sortDir);

        model.addAttribute("list", result.get("list"));
        model.addAttribute("page", result.get("page"));
        model.addAttribute("sortCol", sortCol);
        model.addAttribute("sortDir", sortDir);
        model.addAttribute("amount", amount);

        return "mng/stats/ranking_list";
    }

    // 관리자 승요율 수동 입력/수정
    @PostMapping("/update-win-rate")
    @ResponseBody
    public String updateManualWinRate(@RequestParam("memberId") Long memberId,
                                      @RequestParam("winRate") Double winRate) {
        try {
            statsMngService.updateManualWinRate(memberId, winRate);
            return "ok";
        } catch (Exception e) {
            return "fail";
        }
    }
}