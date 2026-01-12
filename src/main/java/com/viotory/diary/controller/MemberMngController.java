package com.viotory.diary.controller;

import com.viotory.diary.service.MemberService;
import com.viotory.diary.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/mng/members")
@RequiredArgsConstructor
public class MemberMngController {

    private final MemberService memberService;

    /**
     * 관리자 - 회원 목록 조회 (페이징 + 검색)
     * @param page 현재 페이지 번호 (기본값 1)
     * @param searchType 검색 조건 (email, nickname)
     * @param keyword 검색어
     */
    @GetMapping("/list")
    public String listPage(Model model,
                           @RequestParam(value = "page", defaultValue = "1") int page,
                           @RequestParam(value = "searchType", required = false) String searchType,
                           @RequestParam(value = "keyword", required = false) String keyword) {

        // 1. 페이징 설정 (한 페이지당 10명씩)
        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        // 2. 전체 회원 수 조회 (검색 조건 포함)
        int totalCount = memberService.countMembers(searchType, keyword);

        // 3. 회원 목록 조회 (검색 조건 + 페이징 적용)
        List<MemberVO> members = memberService.getMemberList(offset, pageSize, searchType, keyword);

        // 4. 페이징 계산 (화면 하단 숫자 버튼용)
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        // 시작 페이지 (1, 11, 21...)
        int startPage = ((page - 1) / 10) * 10 + 1;
        // 끝 페이지 (10, 20, 30... 또는 마지막 페이지)
        int endPage = Math.min(startPage + 9, totalPages);

        // 5. 화면(JSP)으로 데이터 전달
        model.addAttribute("members", members);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("totalCount", totalCount);

        // 검색 조건 유지
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);

        return "mng/member/list"; // /WEB-INF/views/mng/member/list.jsp
    }

    /**
     * 회원 상세 정보 조회
     */
    @GetMapping("/detail")
    public String detailPage(@RequestParam("memberId") Long memberId, Model model) {

        // 서비스에서 회원 정보 조회 (기존 메서드 활용)
        MemberVO member = memberService.getMemberInfo(memberId);

        if(member == null) {
            // 존재하지 않는 회원이면 목록으로 리다이렉트 (또는 에러 페이지)
            return "redirect:/mng/members/list";
        }

        model.addAttribute("member", member);
        return "mng/member/detail";
    }

    /**
     * 회원 강제 탈퇴 처리 (AJAX)
     */
    @PostMapping("/withdraw")
    @ResponseBody
    public String withdrawAction(@RequestParam("memberId") Long memberId) {
        try {
            memberService.forceWithdrawMember(memberId);
            return "ok";
        } catch (Exception e) {
            log.error("강제 탈퇴 처리 중 오류", e);
            return "fail: " + e.getMessage();
        }
    }

}