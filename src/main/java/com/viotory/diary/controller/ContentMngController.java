package com.viotory.diary.controller;

import com.viotory.diary.service.ContentMngService;
import com.viotory.diary.util.FileUtil;
import com.viotory.diary.vo.EventVO;
import com.viotory.diary.vo.TeamContentVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/mng/content")
@RequiredArgsConstructor
public class ContentMngController {

    private final ContentMngService contentService;

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
    public String eventSave(EventVO event,
                            @RequestParam(value = "thumbnailFile", required = false) MultipartFile thumbnailFile) {

        // 1. 썸네일 이미지 파일 업로드 처리
        if (thumbnailFile != null && !thumbnailFile.isEmpty()) {
            try {
                // 'event' 폴더에 저장 -> /upload/event/UUID_파일명.jpg 반환
                String savedUrl = FileUtil.uploadFile(thumbnailFile, "event");
                event.setImageUrl(savedUrl);
            } catch (Exception e) {
                log.error("이벤트 썸네일 업로드 실패", e);
            }
        }

        // 2. 링크 URL은 사용하지 않으므로 null 처리 (필요시 로직 제거)
        event.setLinkUrl(null);

        // 3. DB 저장
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
            try {
                String savedUrl = FileUtil.uploadFile(file, "content");
                content.setImageUrl(savedUrl);
            } catch (Exception e) {
                log.error("파일 업로드 실패", e);
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

}