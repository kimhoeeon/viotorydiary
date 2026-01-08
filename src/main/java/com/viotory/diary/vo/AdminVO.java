package com.viotory.diary.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AdminVO {
    private Long adminId;           // PK
    private String loginId;         // 관리자 ID
    private String password;        // 암호화된 비밀번호
    private String name;            // 관리자 이름
    private String role;            // 'SUPER', 'MANAGER'
    private String allowedIp;       // 지정 IP (NULL이면 전역 설정 따름)
    private LocalDateTime lastLoginAt;
    private LocalDateTime createdAt;
}