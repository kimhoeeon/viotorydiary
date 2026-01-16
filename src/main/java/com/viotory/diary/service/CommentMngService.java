package com.viotory.diary.service;

import com.viotory.diary.dto.CommentDTO;
import com.viotory.diary.mapper.CommentMngMapper;
import com.viotory.diary.vo.Criteria;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CommentMngService {

    private final CommentMngMapper commentMngMapper;

    public List<CommentDTO> getCommentList(Criteria cri) {
        return commentMngMapper.selectCommentList(cri);
    }

    public int getTotal(Criteria cri) {
        return commentMngMapper.getTotalCount(cri);
    }

    @Transactional
    public void deleteComment(Long commentId) {
        commentMngMapper.deleteComment(commentId);
    }
}