package com.viotory.diary.vo;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class MemberVO {
    private Long memberId;          // PK
    private String email;           // 로그인 ID
    private String password;
    private String nickname;
    private String phoneNumber;     // 본인인증된 번호
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate birthdate;    // 생년월일 (통계용)
    private String gender;          // 'M', 'F', 'U'
    private String myTeamCode;      // 응원팀 코드
    private String myTeamName;      // 화면 표시용 팀 이름 (DB join 결과)
    private LocalDateTime teamChangeDate;
    private String socialProvider;  // 'NONE', 'KAKAO'
    private String socialUid;
    private String role;            // 'USER', 'ADMIN'
    private String status;          // 'ACTIVE', 'INACTIVE' 등
    private String marketingAgree;
    private String gameAlarm;      // 경기 알림 (Y/N)
    private String friendAlarm;    // 친구 알림 (Y/N)
    private String profileImage; // 프로필 이미지 경로
    private LocalDateTime lastLoginAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
