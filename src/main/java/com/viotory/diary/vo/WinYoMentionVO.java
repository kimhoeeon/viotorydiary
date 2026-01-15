package com.viotory.diary.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class WinYoMentionVO {
    private Long mentionId;
    private String category;      // WIN_RATE, ATTENDANCE_COUNT, RECENT_TREND
    private String conditionCode; // 예: 80_UP, 5_GAMES
    private String message;       // 사용자 노출 멘트
    private Integer priority;     // 우선순위 (높을수록 먼저 노출)
    private String description;   // 관리자용 설명
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}