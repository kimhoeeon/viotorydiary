package com.viotory.diary.controller;

import com.viotory.diary.service.GameDataService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/admin/game")
@RequiredArgsConstructor
public class AdminController {

    private final GameDataService gameDataService;

    // 수동 업데이트 API
    // 사용법: /admin/game/update-rapid?date=2025-05-05
    /*@GetMapping("/update-rapid")
    public String updateFromRapid(@RequestParam(required = false) String date) {
        LocalDate targetDate = (date != null)
                ? LocalDate.parse(date, DateTimeFormatter.ISO_DATE)
                : LocalDate.now();

        gameDataService.fetchFromRapid(targetDate);
        return targetDate + " 경기 데이터 업데이트 요청 완료!";
    }*/

    /**
     * 관리자가 직접 특정 년/월 데이터를 업데이트 하는 API
     * 예: /admin/game/sync?year=2025&month=05
     */
    @GetMapping("/sync")
    @ResponseBody
    public String manualSync(@RequestParam String year, @RequestParam String month) {
        gameDataService.syncMonthlyData(year, month);
        return "데이터 동기화 요청이 처리되었습니다. 서버 로그를 확인하세요.";
    }

    /**
     * 특정 연도 전체(3월~11월) 데이터 동기화
     * 예: /admin/game/sync-year?year=2025
     */
    @GetMapping("/sync-year")
    @ResponseBody
    public String syncYearlyData(@RequestParam String year) {
        // 비동기로 실행하고 싶다면 Thread를 사용하거나 @Async를 사용해야 하지만,
        // 우선은 로그를 확인하며 기다리는 방식으로 구현합니다.
        gameDataService.syncYearlyData(year);
        return year + "년도 야구 시즌 데이터 수집이 완료되었습니다. 서버 로그를 확인하세요.";
    }

    // 기존 월별 동기화 API
    @GetMapping("/sync-month")
    @ResponseBody
    public String syncMonthlyData(@RequestParam String year, @RequestParam String month) {
        gameDataService.syncMonthlyData(year, month);
        return year + "년 " + month + "월 데이터 수집 완료.";
    }

}