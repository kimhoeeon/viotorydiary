package com.viotory.diary.controller;

import com.viotory.diary.service.PlayService;
import com.viotory.diary.vo.GameVO;
import com.viotory.diary.vo.MemberVO;
import com.viotory.diary.vo.PredictionVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/play")
@RequiredArgsConstructor
public class PlayController {

    private final PlayService playService;

    // 경기 메인 페이지 (캘린더 + 오늘 경기)
    @GetMapping("")
    public String playMain(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 1. 오늘 날짜 구하기
        String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        // 2. 오늘의 경기 목록 (예측 정보 포함)
        List<GameVO> todayGames = playService.getGameListWithPrediction(loginMember.getMemberId(), today);

        // 3. 예측 히스토리 및 통계
        List<PredictionVO> history = playService.getPredictionHistory(loginMember.getMemberId());
        Map<String, Object> stats = playService.getPredictionStats(loginMember.getMemberId());

        model.addAttribute("today", today);
        model.addAttribute("todayGames", todayGames);
        model.addAttribute("history", history);
        model.addAttribute("stats", stats);

        return "play/play"; // views/play/play.jsp
    }

    // [AJAX] 날짜별 경기 목록 조회
    @GetMapping("/games")
    @ResponseBody
    public List<GameVO> getGamesByDate(@RequestParam("date") String date, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        return playService.getGameListWithPrediction(loginMember.getMemberId(), date);
    }

    // [AJAX] 승부 예측 제출
    @PostMapping("/predict")
    @ResponseBody
    public String predict(@RequestParam("gameId") Long gameId,
                          @RequestParam("teamCode") String teamCode,
                          HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "fail:login";

        try {
            playService.submitPrediction(loginMember.getMemberId(), gameId, teamCode);
            return "ok";
        } catch (Exception e) {
            return "fail";
        }
    }
}