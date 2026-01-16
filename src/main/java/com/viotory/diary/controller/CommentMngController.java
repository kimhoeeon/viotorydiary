package com.viotory.diary.controller;

import com.viotory.diary.dto.CommentDTO;
import com.viotory.diary.service.CommentMngService;
import com.viotory.diary.vo.Criteria;
import com.viotory.diary.vo.PageDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/mng/comment")
@RequiredArgsConstructor
public class CommentMngController {

    private final CommentMngService commentMngService;

    // 목록 페이지
    @GetMapping("/list")
    public String listPage(Model model, Criteria cri) {
        List<CommentDTO> list = commentMngService.getCommentList(cri);
        int total = commentMngService.getTotal(cri);

        model.addAttribute("list", list);
        model.addAttribute("pageMaker", new PageDTO(cri, total));

        return "mng/diary/comment_list"; // 뷰 파일 위치
    }

    // 삭제 처리 (AJAX)
    @PostMapping("/delete")
    @ResponseBody
    public String deleteAction(@RequestParam("commentId") Long commentId) {
        try {
            commentMngService.deleteComment(commentId);
            return "ok";
        } catch (Exception e) {
            return "fail";
        }
    }
}