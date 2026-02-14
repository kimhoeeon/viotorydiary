package com.viotory.diary.controller;

import com.viotory.diary.dto.StadiumVisitDTO;
import com.viotory.diary.dto.WinYoAnalysisDTO;
import com.viotory.diary.service.DiaryService;
import com.viotory.diary.service.GameService;
import com.viotory.diary.service.WinYoService;
import com.viotory.diary.vo.DiaryVO;
import com.viotory.diary.vo.GameVO;
import com.viotory.diary.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/diary")
public class WinYoController {

    private final WinYoService winYoService;
    private final DiaryService diaryService;
    private final GameService gameService;

    /**
     * 일기 탭 메인 (대시보드)
     * URL: /diary/winyo
     * 기능: 승요력 통계, 내 일기(최신 3개), 친구 일기(최신 3개), 스코어카드
     */
    @GetMapping("/winyo")
    public String winYoMain(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        Long memberId = loginMember.getMemberId();

        // 1. 승요력 통계 (Fire Card)
        WinYoAnalysisDTO winYo = winYoService.analyzeWinYoPower(memberId);
        model.addAttribute("winYo", winYo);

        // 2. 나의 최신 일기 (최대 4개)
        List<DiaryVO> myAllDiaries = diaryService.getMyDiaryList(memberId);
        List<DiaryVO> myDiaries = myAllDiaries.size() > 4 ? myAllDiaries.subList(0, 4) : myAllDiaries;
        model.addAttribute("myDiaries", myDiaries);

        // 3. 친구들의 일기 (최대 4개)
        List<DiaryVO> friendDiaries = diaryService.getFriendDiaryList(memberId);
        model.addAttribute("friendDiaries", friendDiaries);

        // 4. 스코어카드 (구장 방문 현황)
        List<StadiumVisitDTO> stadiumStatus = diaryService.getStadiumVisitStatus(memberId);
        int visitedCount = diaryService.getVisitedStadiumCount(memberId);

        model.addAttribute("stadiumStatus", stadiumStatus);
        model.addAttribute("visitedCount", visitedCount);

        // 오늘 경기 존재 여부 확인 (취소된 경기 제외)
        boolean hasTodayGame = false;
        List<GameVO> todayGames = gameService.getAllGamesToday(memberId);
        if (todayGames != null && !todayGames.isEmpty()) {
            for (GameVO game : todayGames) {
                if (!"CANCELLED".equals(game.getStatus())) {
                    hasTodayGame = true;
                    break;
                }
            }
        }
        model.addAttribute("hasTodayGame", hasTodayGame);

        return "diary/diary_main";
    }
}