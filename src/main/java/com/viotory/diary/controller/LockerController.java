package com.viotory.diary.controller;

import com.viotory.diary.service.LockerService;
import com.viotory.diary.vo.LockerVO;
import com.viotory.diary.vo.MemberVO;
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

    // ==========================================
    // 1. 라커룸 메인 (대시보드)
    // ==========================================

    @GetMapping("/main")
    public String lockerMain(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 1. 야구 200% 즐기기 (이벤트) - 최신 1개
        List<LockerVO> events = lockerService.getPostList("EVENT", 1, 1);
        model.addAttribute("event", events.isEmpty() ? null : events.get(0));

        // 2. 우리 팀 추천 콘텐츠 - 최신 5개
        List<LockerVO> contents = lockerService.getPostList("CONTENT", 1, 5);
        model.addAttribute("contents", contents);

        // 3. 공지 및 설문 - 최신 5개
        List<LockerVO> notices = lockerService.getPostList("NOTICE", 1, 5);
        model.addAttribute("notices", notices);

        return "locker/locker_main";
    }

    // ==========================================
    // 2. 공지사항 (Notice)
    // ==========================================

    // 공지 목록
    @GetMapping("/notice/list")
    public String noticeList(HttpSession session, Model model) {
        if (session.getAttribute("loginMember") == null) return "redirect:/member/login";

        List<LockerVO> list = lockerService.getPostList("NOTICE", 1, 20);
        model.addAttribute("list", list);

        return "locker/notice_list"; // views/locker/notice_list.jsp
    }

    // 공지 상세
    @GetMapping("/notice/detail")
    public String noticeDetail(@RequestParam("postId") Long postId, HttpSession session, Model model) {
        if (session.getAttribute("loginMember") == null) return "redirect:/member/login";

        LockerVO post = lockerService.getPostDetail(postId);
        model.addAttribute("post", post);

        return "locker/notice_detail"; // views/locker/notice_detail.jsp
    }

    // ==========================================
    // 3. 구단 콘텐츠 (Content)
    // ==========================================

    // 콘텐츠 목록
    @GetMapping("/content/list")
    public String contentList(HttpSession session, Model model) {
        if (session.getAttribute("loginMember") == null) return "redirect:/member/login";

        List<LockerVO> list = lockerService.getPostList("CONTENT", 1, 20);
        model.addAttribute("list", list);

        return "locker/content_list"; // views/locker/content_list.jsp
    }

    // 콘텐츠 상세
    @GetMapping("/content/detail")
    public String contentDetail(@RequestParam("postId") Long postId, HttpSession session, Model model) {
        if (session.getAttribute("loginMember") == null) return "redirect:/member/login";

        LockerVO post = lockerService.getPostDetail(postId);
        model.addAttribute("post", post);

        return "locker/content_detail"; // views/locker/content_detail.jsp
    }

}