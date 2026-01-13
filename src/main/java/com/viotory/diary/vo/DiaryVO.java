package com.viotory.diary.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class DiaryVO {
    private Long diaryId;           // PK
    private Long memberId;
    private Long gameId;
    private String snapshotTeamCode; // 작성 당시 응원팀

    // [누락된 필드 추가: 메인 화면 및 목록 표시용]
    private String gameDate;      // 경기 날짜 (JOIN 결과)
    private String homeTeamCode;  // 홈팀 코드 (JOIN 결과)
    private String awayTeamCode;  // 원정팀 코드 (JOIN 결과)

    // [추가] 경기장 이름 (승요력 분석용)
    private String stadiumName;

    // (선택사항) 쿼리에서 조회하지만 VO에 없던 점수 필드도 필요하다면 추가
    // private Integer scoreHome;
    // private Integer scoreAway;

    // 경기 전 (예측)
    private Integer predScoreHome;
    private Integer predScoreAway;
    private String predHero;

    // [신규] 오늘의 히어로 (사용자 직접 입력)
    private String heroName;

    // 직관 인증
    private Boolean isVerified;
    private LocalDateTime verifiedAt;

    // 경기 후 (일기)
    private String content;
    private String oneLineComment;
    private Integer rating;

    // 상태 및 관리
    private String status;          // 'PRE_SAVED', 'COMPLETED'...
    private String isPublic;        // 'PUBLIC', 'PRIVATE'...
    private Long version;           // 낙관적 락

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private String gameResult; // 쿼리에서 계산된 결과: "WIN", "LOSE", "DRAW"
}