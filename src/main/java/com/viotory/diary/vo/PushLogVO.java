package com.viotory.diary.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class PushLogVO {
    private Long pushId;
    private String title;
    private String content;
    private String linkUrl;
    private String targetUser; // ALL
    private Integer sendCount;
    private String status;     // SUCCESS
    private LocalDateTime createdAt;
}