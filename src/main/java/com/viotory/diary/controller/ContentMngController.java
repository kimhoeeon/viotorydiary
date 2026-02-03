package com.viotory.diary.controller;

import com.viotory.diary.mapper.ContentMngMapper;
import com.viotory.diary.service.ContentMngService;
import com.viotory.diary.vo.EventVO;
import com.viotory.diary.vo.TeamContentVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.List;
import java.util.UUID;

@Slf4j
@Controller
@RequestMapping("/mng/content")
@RequiredArgsConstructor
public class ContentMngController {

    private final ContentMngService contentService;

    // [설정] 파일 저장 경로 (DevMngController와 동일하게 설정 권장)
    private final String UPLOAD_DIR = "/usr/local/tomcat/webapps/upload/";

    // ==========================================
    // 1. 이벤트 관리
    // ==========================================

    // 목록 페이지
    @GetMapping("/events")
    public String eventList(Model model) {
        List<EventVO> events = contentService.getEventList();
        model.addAttribute("events", events);
        return "mng/content/event_list";
    }

    // 이벤트 상세 페이지
    @GetMapping("/events/detail")
    public String eventDetail(@RequestParam("eventId") Long eventId, Model model) {
        if (eventId != null) {
            EventVO event = contentService.getEvent(eventId);
            model.addAttribute("event", event);
        }
        return "mng/content/event_detail";
    }

    // 등록 및 수정 처리
    @PostMapping("/events/save")
    public String eventSave(EventVO event) {
        // (이벤트 파일 업로드는 기존 코드 참고해서 추가 필요)
        if (event.getEventId() == null) {
            contentService.insertEvent(event);
        } else {
            contentService.updateEvent(event);
        }
        return "redirect:/mng/content/events";
    }

    // 삭제 처리 (AJAX)
    @PostMapping("/events/delete")
    @ResponseBody
    public String eventDelete(@RequestParam("eventId") Long eventId) {
        try {
            contentService.deleteEvent(eventId);
            return "ok";
        } catch (Exception e) {
            log.error("이벤트 삭제 실패", e);
            return "fail";
        }
    }

    // 단건 조회 (수정 팝업용 AJAX)
    @GetMapping("/events/get")
    @ResponseBody
    public EventVO getEvent(@RequestParam("eventId") Long eventId) {
        return contentService.getEvent(eventId);
    }

    // ==========================================
    // 2. 구단 콘텐츠 관리
    // ==========================================

    // 목록 페이지
    @GetMapping("/teams")
    public String teamContentList(Model model) {
        List<TeamContentVO> contents = contentService.getTeamContentList();
        model.addAttribute("contents", contents);
        return "mng/content/team_list";
    }

    // 구단 콘텐츠 상세 페이지
    @GetMapping("/teams/detail")
    public String teamContentForm(@RequestParam(value="contentId", required=false) Long contentId, Model model) {
        if (contentId != null) {
            TeamContentVO content = contentService.getTeamContent(contentId);
            model.addAttribute("content", content);
        }
        return "mng/content/team_detail";
    }
    
    // 등록 및 수정 처리
    @PostMapping("/teams/save")
    public String teamContentSave(TeamContentVO content,
                                  @RequestParam(value = "file", required = false) MultipartFile file) {
        if (file != null && !file.isEmpty()) {
            String savedName = uploadFile(file);
            if (savedName != null) {
                content.setImageUrl(savedName);
            }
        }

        if (content.getContentId() == null) {
            contentService.insertTeamContent(content);
        } else {
            contentService.updateTeamContent(content);
        }
        return "redirect:/mng/content/teams";
    }

    // 삭제 처리 (AJAX)
    @PostMapping("/teams/delete")
    @ResponseBody
    public String teamContentDelete(@RequestParam("contentId") Long contentId) {
        try {
            contentService.deleteTeamContent(contentId);
            return "ok";
        } catch (Exception e) {
            log.error("팀 콘텐츠 삭제 실패", e);
            return "fail";
        }
    }

    // 단건 조회 (수정 팝업용 AJAX)
    @GetMapping("/teams/get")
    @ResponseBody
    public TeamContentVO getTeamContent(@RequestParam("contentId") Long contentId) {
        return contentService.getTeamContent(contentId);
    }

    // --- 유틸리티: 단일 파일 업로드 ---
    private String uploadFile(MultipartFile file) {
        if (file == null || file.isEmpty()) return null;

        File dir = new File(UPLOAD_DIR);
        if (!dir.exists()) dir.mkdirs();

        String orgName = file.getOriginalFilename();
        String ext = "";
        if (orgName != null && orgName.contains(".")) {
            ext = orgName.substring(orgName.lastIndexOf("."));
        }
        String saveName = UUID.randomUUID().toString() + ext;

        try {
            file.transferTo(new File(UPLOAD_DIR + saveName));
            return saveName;
        } catch (Exception e) {
            log.error("팀 콘텐츠 이미지 업로드 실패", e);
            return null;
        }
    }

}