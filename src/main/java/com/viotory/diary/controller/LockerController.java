package com.viotory.diary.controller;

import com.viotory.diary.service.ContentMngService;
import com.viotory.diary.service.LockerService;
import com.viotory.diary.service.SystemMngService;
import com.viotory.diary.vo.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/locker")
@RequiredArgsConstructor
public class LockerController {

    private final LockerService lockerService;
    private final ContentMngService contentMngService; // 이벤트/구단콘텐츠
    private final SystemMngService systemMngService; // 공지사항

    // ==========================================
    // 1. 라커룸 메인 (대시보드)
    // ==========================================

    @GetMapping("/main")
    public String lockerMain(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 1. 이벤트 리스트
        List<EventVO> events = contentMngService.getActiveEventList();
        model.addAttribute("events", events);

        // 2. 공지사항 리스트
        List<NoticeVO> notices = systemMngService.getActiveNoticeList();
        if (notices.size() > 4) {
            notices = notices.subList(0, 4); // 0번째부터 4개만 잘라내기
        }
        model.addAttribute("notices", notices);

        // 3. 일반 콘텐츠 (기존 로직 유지, 예: 최신순 20개)
        String myTeam = loginMember.getMyTeamCode();
        List<TeamContentVO> contents = contentMngService.getActiveTeamContentList(myTeam);
        model.addAttribute("contents", contents);

        /* 만약 유저 게시글(locker_posts)을 보여주는 것이라면 아래 코드를 사용:
           List<LockerVO> contents = lockerService.getPostList("TALK", 1, 5);
           model.addAttribute("contents", contents);
        */

        return "locker/locker_main";
    }

    // ==========================================
    // 2. 공지사항 (Notice)
    // ==========================================

    // 공지 목록
    @GetMapping("/notice/list")
    public String noticeList(HttpSession session, Model model) {
        if (session.getAttribute("loginMember") == null) return "redirect:/member/login";

        List<NoticeVO> list = systemMngService.getActiveNoticeList();
        model.addAttribute("list", list);

        return "locker/notice_list"; // views/locker/notice_list.jsp
    }

    // 공지 상세
    @GetMapping("/notice/detail")
    public String noticeDetail(@RequestParam("noticeId") Long noticeId, HttpSession session, Model model) {
        if (session.getAttribute("loginMember") == null) return "redirect:/member/login";

        NoticeVO notice = systemMngService.getNoticeById(noticeId);
        model.addAttribute("post", notice);

        return "locker/notice_detail"; // views/locker/notice_detail.jsp
    }

    // ==========================================
    // 3. 구단 콘텐츠 (Content)
    // ==========================================

    // 콘텐츠 목록
    @GetMapping("/content/list")
    public String contentList(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 필요 시 사용자 팀 코드를 파라미터로 넘길 수 있음
        List<TeamContentVO> list = contentMngService.getActiveTeamContentList(loginMember.getMyTeamCode());
        model.addAttribute("list", list);

        return "locker/content_list"; // views/locker/content_list.jsp
    }

    // 콘텐츠 상세
    @GetMapping("/content/detail")
    public String contentDetail(@RequestParam("contentId") Long contentId, HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 콘텐츠를 클릭했으므로 로그 기록 및 조회수 증가 처리
        contentMngService.logContentClick(contentId, loginMember);

        TeamContentVO content = contentMngService.getTeamContent(contentId);
        model.addAttribute("post", content);
        return "locker/content_detail";
    }

    // ==========================================
    // 4. 이벤트 (event)
    // ==========================================

    // 이벤트 상세 페이지
    @GetMapping("/event/detail")
    public String eventDetail(@RequestParam("eventId") Long eventId, HttpSession session, Model model) {
        if (session.getAttribute("loginMember") == null) return "redirect:/member/login";

        EventVO event = contentMngService.getEvent(eventId);
        model.addAttribute("post", event);

        return "locker/event_detail";
    }


}