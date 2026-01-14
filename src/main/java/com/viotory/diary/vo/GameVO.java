package com.viotory.diary.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime; // Import 추가

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameVO {

    private Long gameId;
    private String apiGameId;

    private String gameDate;           // 경기 날짜 (YYYY-MM-DD)
    private String gameTime;           // 경기 시간 (HH:mm:ss)

    private Integer stadiumId;
    private String homeTeamCode;
    private String awayTeamCode;

    private Integer scoreHome;
    private Integer scoreAway;

    private String status;
    private String cancelReason;

    private String mvpPlayer;       // MVP 선수

    // [Audit Fields] - 데이터 관리용
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // ---------------------------------------------------------
    // [화면 표시 & 로직 처리용 필드] (DB 컬럼 아님)
    // ---------------------------------------------------------
    private String homeTeamName;
    private String awayTeamName;
    private String stadiumName;

    private String winningTeam;
    private String myPredictedTeam;
}