package com.viotory.diary.controller;

import com.viotory.diary.service.MemberMngService;
import com.viotory.diary.vo.Criteria;
import com.viotory.diary.vo.MemberVO;
import com.viotory.diary.vo.PageDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping("/mng/members")
@RequiredArgsConstructor
public class MemberMngController {

    private final MemberMngService memberMngService;

    // 목록 페이지 (페이징 + 검색)
    @GetMapping("/list")
    public String listPage(Model model, Criteria cri) {

        // 1. 목록 데이터 조회
        List<MemberVO> list = memberMngService.getMemberList(cri);

        // 2. 전체 데이터 개수 조회 (페이징 계산용)
        int total = memberMngService.getTotal(cri);

        model.addAttribute("list", list);
        model.addAttribute("pageMaker", new PageDTO(cri, total)); // 페이징 정보 전달

        return "mng/member/member_list";
    }

    // 상세 페이지 (기존 유지)
    @GetMapping("/detail")
    public String detailPage(@RequestParam("memberId") Long memberId,
                             @ModelAttribute("cri") Criteria cri, // 목록으로 돌아갈 때 정보 유지를 위해 받음
                             Model model) {
        MemberVO member = memberMngService.getMember(memberId);
        if (member == null) return "redirect:/mng/members/list";

        model.addAttribute("member", member);
        return "mng/member/member_detail";
    }

    // 상태 변경 (기존 유지)
    @PostMapping("/updateStatus")
    @ResponseBody
    public String updateStatus(@RequestParam("memberId") Long memberId,
                               @RequestParam("status") String status) {
        try {
            memberMngService.updateStatus(memberId, status);
            return "ok";
        } catch (Exception e) {
            return "fail";
        }
    }

    // 비밀번호 초기화 (AJAX)
    @PostMapping("/resetPassword")
    @ResponseBody
    public String resetPassword(@RequestParam("memberId") Long memberId) {
        try {
            return memberMngService.resetPassword(memberId);
        } catch (Exception e) {
            return "fail";
        }
    }

    // 회원 목록 엑셀 다운로드
    @GetMapping("/excel")
    public void downloadExcel(HttpServletResponse response) throws Exception {
        memberMngService.downloadExcel(response);
    }

}