package com.viotory.diary.controller;

import com.viotory.diary.mapper.GameMapper;
import com.viotory.diary.service.GameDataService;
import com.viotory.diary.vo.GameVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/mng/game")
@RequiredArgsConstructor
public class GameMngController {

    private final GameDataService gameDataService;
    private final GameMapper gameMapper;

    /**
     * 경기 데이터 관리 페이지 (목록 + 동기화 버튼)
     */
    @GetMapping("/syncPage")
    public String syncPage(Model model,
                           @RequestParam(value = "year", required = false) String year,
                           @RequestParam(value = "month", required = false) String month) {

        // 기본값: 현재 날짜
        LocalDate now = LocalDate.now();
        if (year == null) year = String.valueOf(now.getYear());
        if (month == null) month = String.format("%02d", now.getMonthValue());

        // 목록 조회
        String yearMonth = year + "-" + month;
        List<GameVO> games = gameMapper.selectGameListByMonth(yearMonth);

        model.addAttribute("games", games);
        model.addAttribute("curYear", year);
        model.addAttribute("curMonth", month);

        return "mng/game/game_list";
    }

    /**
     * [액션] 월간 데이터 동기화
     */
    @GetMapping("/sync")
    @ResponseBody
    public String manualSync(@RequestParam String year, @RequestParam String month) {
        try {
            gameDataService.syncMonthlyData(year, month);
            return "ok";
        } catch (Exception e) {
            log.error("동기화 실패", e);
            return "fail: " + e.getMessage();
        }
    }

    /**
     * [액션] 연간 데이터 동기화
     */
    @GetMapping("/sync-year")
    @ResponseBody
    public String syncYearlyData(@RequestParam String year) {
        try {
            gameDataService.syncYearlyData(year);
            return "ok";
        } catch (Exception e) {
            log.error("연간 동기화 실패", e);
            return "fail: " + e.getMessage();
        }
    }
}