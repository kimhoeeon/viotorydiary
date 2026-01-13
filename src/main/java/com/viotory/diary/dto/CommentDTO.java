package com.viotory.diary.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class CommentDTO {
    private Long commentId;
    private Long diaryId;
    private Long memberId;      // 댓글 작성자
    private String content;
    private LocalDateTime createdAt;

    // 리스트 표시용 (JOIN 데이터)
    private String diaryTeamCode; // 일기 당시 응원팀 (또는 현재 팀)
    private String diaryTitle;    // 일기 한줄평(제목)
    private String nickname;      // 댓글 작성자 닉네임 (필요 시)
}