package com.viotory.diary.controller;

import com.viotory.diary.mapper.GameMapper;
import com.viotory.diary.service.GameDataService;
import com.viotory.diary.service.GameMngService;
import com.viotory.diary.vo.GameVO;
import com.viotory.diary.vo.StadiumVO;
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
    private final GameMngService gameMngService;
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

        List<StadiumVO> stadiums = gameMngService.getStadiumList();
        model.addAttribute("stadiums", stadiums);

        model.addAttribute("games", games);
        model.addAttribute("curYear", year);
        model.addAttribute("curMonth", month);

        return "mng/game/game_list";
    }

    /**
     * [액션] 월간 데이터 동기화
     */
    @PostMapping("/syncMonthly") // ★ 수정: POST 요청 처리
    @ResponseBody
    public String manualSync(@RequestParam("year") String year,
                             @RequestParam("month") String month) {
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
    @PostMapping("/syncYearly") // ★ 수정: POST 요청 처리
    @ResponseBody
    public String syncYearlyData(@RequestParam("year") String year) {
        try {
            gameDataService.syncYearlyData(year);
            return "ok";
        } catch (Exception e) {
            log.error("연간 동기화 실패", e);
            return "fail: " + e.getMessage();
        }
    }

    // 경기 관리 목록 (동기화 페이지 겸용)
    // 목록 페이지
    @GetMapping("/list")
    public String gameList(Model model, @RequestParam(value = "ym", required = false) String ym) {
        if (ym == null) {
            ym = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
        }

        List<GameVO> list = gameMngService.getGameList(ym);

        // [추가] 구장 목록 조회 및 모델 추가
        List<StadiumVO> stadiums = gameMngService.getStadiumList();
        model.addAttribute("stadiums", stadiums);

        model.addAttribute("list", list);
        model.addAttribute("ym", ym);

        return "mng/game/game_list";
    }

    // 상세 조회 (AJAX)
    @GetMapping("/get")
    @ResponseBody
    public GameVO getGame(@RequestParam("gameId") Long gameId) {
        return gameMngService.getGame(gameId);
    }

    // 저장
    @PostMapping("/save")
    @ResponseBody
    public String saveGame(GameVO game) {
        try {
            gameMngService.saveGame(game);
            return "ok"; // 성공 시 ok 반환
        } catch (Exception e) {
            log.error("경기 저장 실패", e);
            return "fail: " + e.getMessage(); // 실패 시 메시지 반환
        }
    }

    // 삭제
    @PostMapping("/delete")
    @ResponseBody
    public String deleteGame(@RequestParam("gameId") Long gameId) {
        try {
            gameMngService.deleteGame(gameId);
            return "ok";
        } catch (Exception e) {
            return "fail";
        }
    }

}