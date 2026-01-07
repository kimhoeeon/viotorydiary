package com.viotory.diary.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class DiaryVO {
    private Long diaryId;           // PK
    private Long memberId;
    private Long gameId;
    private String snapshotTeamCode; // 작성 당시 응원팀

    // 경기 전 (예측)
    private Integer predScoreHome;
    private Integer predScoreAway;
    private String predHero;

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
