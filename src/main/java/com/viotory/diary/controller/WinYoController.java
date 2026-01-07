package com.viotory.diary.controller;

import com.viotory.diary.dto.WinYoAnalysisDTO;
import com.viotory.diary.service.WinYoService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/diary")
public class WinYoController {

    private final WinYoService winYoService;

    /**
     * 승요력 분석 페이지 이동
     * URL: /diary/winyo
     */
    @GetMapping("/winyo")
    public String winYoPage(Model model, HttpSession session) {
        // 1. 로그인한 사용자 ID 가져오기
        // (세션 연동 전이므로 테스트용으로 1번 고정, 추후 session.getAttribute("member") 등으로 교체)
        Long memberId = 1L;

        log.info("승요력 분석 요청 - memberId: {}", memberId);

        // 2. 서비스 호출 (핵심 로직 실행)
        WinYoAnalysisDTO result = winYoService.analyzeWinYoPower(memberId);

        // 3. JSP로 데이터 전달
        model.addAttribute("winyo", result);

        // 4. 화면 이동 (WEB-INF/views/diary/winyo.jsp)
        return "diary/winyo";
    }
}