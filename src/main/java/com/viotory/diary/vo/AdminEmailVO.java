package com.viotory.diary.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AdminEmailVO {
    private Long emailId;
    private Long adminId;
    private String emailAddress;
    private String receiveTypes; // ALL, BUG, MAINTENANCE 등
    private String isMain;       // Y, N
    private LocalDateTime createdAt;
}