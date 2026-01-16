package com.viotory.diary.controller;

import com.viotory.diary.service.TeamInfoMngService;
import com.viotory.diary.vo.TeamVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/mng/content/team-info")
@RequiredArgsConstructor
public class TeamInfoMngController {

    private final TeamInfoMngService teamInfoMngService;

    // 목록 페이지
    @GetMapping("/list")
    public String listPage(Model model) {
        model.addAttribute("list", teamInfoMngService.getTeamList());
        return "mng/content/team_info_list"; // JSP 파일명 변경
    }

    // 상세 조회 (AJAX)
    @GetMapping("/get")
    @ResponseBody
    public TeamVO getTeam(@RequestParam("teamCode") String teamCode) {
        return teamInfoMngService.getTeam(teamCode);
    }

    // 수정 처리
    @PostMapping("/save")
    public String saveAction(TeamVO team) {
        teamInfoMngService.updateTeam(team);
        return "redirect:/mng/content/team-info/list";
    }
}