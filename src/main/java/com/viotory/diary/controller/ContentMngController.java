package com.viotory.diary.controller;

import com.viotory.diary.mapper.ContentMngMapper;
import com.viotory.diary.vo.EventVO;
import com.viotory.diary.vo.TeamContentVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/mng/content")
@RequiredArgsConstructor
public class ContentMngController {

    private final ContentMngMapper contentMapper;

    // --- 이벤트 관리 ---
    @GetMapping("/events")
    public String eventList(Model model) {
        List<EventVO> events = contentMapper.selectEventList();
        model.addAttribute("events", events);
        return "mng/content/event_list"; // 퍼블리싱 파일 매핑 예정
    }

    @PostMapping("/events/save")
    public String eventSave(EventVO event) {
        if (event.getEventId() == null) {
            contentMapper.insertEvent(event);
        } else {
            contentMapper.updateEvent(event);
        }
        return "redirect:/mng/content/events";
    }

    // --- 팀 콘텐츠 관리 ---
    @GetMapping("/teams")
    public String teamContentList(Model model) {
        List<TeamContentVO> contents = contentMapper.selectTeamContentList();
        model.addAttribute("contents", contents);
        return "mng/content/team_list"; // 퍼블리싱 파일 매핑 예정
    }

    @PostMapping("/teams/save")
    public String teamContentSave(TeamContentVO content) {
        if (content.getContentId() == null) {
            contentMapper.insertTeamContent(content);
        } else {
            contentMapper.updateTeamContent(content);
        }
        return "redirect:/mng/content/teams";
    }
}