package com.viotory.diary.controller;

import com.viotory.diary.dto.WinYoAnalysisDTO;
import com.viotory.diary.service.DiaryService;
import com.viotory.diary.service.WinYoService;
import com.viotory.diary.vo.DiaryVO;
import com.viotory.diary.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/diary")
public class WinYoController {

    private final WinYoService winYoService; // 분석용
    private final DiaryService diaryService; // CRUD용

    /**
     * 승요력 분석 페이지 이동
     * URL: /diary/winyo
     */
    @GetMapping("/winyo")
    public String winYoPage(Model model, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        WinYoAnalysisDTO result = winYoService.analyzeWinYoPower(loginMember.getMemberId());
        model.addAttribute("winyo", result);
        return "diary/winyo";
    }

    // --- 일기 작성 화면 ---
    @GetMapping("/write")
    public String writePage(@RequestParam("gameId") Long gameId, Model model, HttpSession session) {
        // 로그인 체크
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 화면에 필요한 gameId 전달 (나중에 GameService에서 경기 상세 정보도 조회해서 넘겨야 함)
        model.addAttribute("gameId", gameId);

        return "diary/write"; // 퍼블리싱 후 jsp 생성
    }

    // --- 일기 저장 처리 ---
    @PostMapping("/write")
    public String writeAction(DiaryVO diary, HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        diary.setMemberId(loginMember.getMemberId());

        try {
            diaryService.writeDiary(diary);
            // 저장 후 목록이나 상세 페이지로 이동
            return "redirect:/diary/winyo";
        } catch (Exception e) {
            log.error("일기 작성 실패", e);
            model.addAttribute("error", e.getMessage());
            model.addAttribute("gameId", diary.getGameId()); // 다시 작성 화면으로 돌아갈 때 필요
            return "diary/write";
        }
    }


}