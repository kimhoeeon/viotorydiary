package com.viotory.diary.controller;

import com.viotory.diary.service.GameService;
import com.viotory.diary.vo.GameVO;
import com.viotory.diary.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class MainController {

    private final GameService gameService;

    @GetMapping("/")
    public String mainPage(Model model, HttpSession session) {

        /*
        // 1. 세션에서 로그인 정보 가져오기
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");

        // 2. 내 응원팀 경기 정보 조회 (로그인 했고, 팀 설정이 된 경우)
        if (loginMember != null && !"NONE".equals(loginMember.getMyTeamCode())) {
            GameVO myGame = gameService.getMyTeamGameToday(loginMember.getMyTeamCode());

            if (myGame != null) {
                model.addAttribute("myGame", myGame);

                // (선택사항) 경기 상태에 따른 메시지나 플래그 추가
                if ("LIVE".equals(myGame.getStatus())) {
                    model.addAttribute("liveMessage", "현재 경기 중입니다! 🔥");
                } else if ("FINISHED".equals(myGame.getStatus())) {
                    model.addAttribute("finishMessage", "경기가 종료되었습니다. 일기를 작성해보세요! ✍️");
                }
            }
        }

        // 3. 전체 경기 일정 (타구장 소식)
        List<GameVO> allGames = gameService.getAllGamesToday();
        model.addAttribute("allGames", allGames);

        // 4. 메인 화면으로 이동
        return "main"; // /WEB-INF/views/main.jsp (퍼블리싱 파일 대기)*/

        // 서비스 준비중 페이지로 연결
        return "maintenance";
    }

}