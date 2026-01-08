package com.viotory.diary.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AdminVO {
    private Long adminId;           // admin_id (PK)
    private String loginId;         // login_id (관리자 ID, UK)
    private String password;        // password (암호화된 비밀번호)
    private String name;            // name (관리자 이름)
    private String role;            // role (ENUM: 'SUPER', 'MANAGER')
    private String allowedIp;       // allowed_ip (지정 IP, NULL이면 전역 설정 따름)
    private LocalDateTime lastLoginAt; // last_login_at (마지막 로그인 일시)
    private LocalDateTime createdAt;   // created_at (생성 일시)
}