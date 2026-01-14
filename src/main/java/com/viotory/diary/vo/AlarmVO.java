package com.viotory.diary.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AlarmVO {
    private Long alarmId;
    private Long memberId;
    private String category;    // GAME, NEWS, EVENT, FRIEND
    private String content;
    private String redirectUrl;
    private boolean isRead;
    private LocalDateTime createdAt;

    // 화면 표시용 (날짜 포맷 등)
    private String displayTime;
}