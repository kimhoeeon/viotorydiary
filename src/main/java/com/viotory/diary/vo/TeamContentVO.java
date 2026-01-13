package com.viotory.diary.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class TeamContentVO {
    private Long contentId;
    private String teamCode;
    private String title;
    private String contentUrl;
    private Integer sortOrder;
    private Integer clickCount;
    private String status; // ACTIVE, INACTIVE
    private LocalDateTime createdAt;
}