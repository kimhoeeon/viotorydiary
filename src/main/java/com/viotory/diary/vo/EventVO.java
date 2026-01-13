package com.viotory.diary.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class EventVO {
    private Long eventId;
    private String title;
    private String content;
    private String imageUrl;
    private String linkUrl;
    private String startDate; // yyyy-MM-dd
    private String endDate;   // yyyy-MM-dd
    private String status;    // ACTIVE, INACTIVE
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}