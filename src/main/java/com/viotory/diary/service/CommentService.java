package com.viotory.diary.service;

import com.viotory.diary.dto.CommentDTO;
import com.viotory.diary.mapper.CommentMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentMapper commentMapper;

    /**
     * 내가 쓴 댓글 목록
     */
    public List<CommentDTO> getMyComments(Long memberId) {
        return commentMapper.selectMyCommentList(memberId);
    }

    /**
     * 댓글 삭제 (작성자 본인 OR 일기 주인)
     */
    @Transactional
    public void deleteComment(Long commentId, Long requestMemberId) throws Exception {
        int deletedCount = commentMapper.deleteComment(commentId, requestMemberId);

        if (deletedCount == 0) {
            throw new Exception("삭제 권한이 없거나 이미 삭제된 댓글입니다.");
        }
    }
}