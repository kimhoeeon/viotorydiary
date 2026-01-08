package com.viotory.diary.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class WinYoAnalysisDTO {
    // 1. 기본 통계
    private int totalGames;         // 총 직관 수 (승률 산정 대상)
    private int winGames;           // 승리 수
    private int loseGames;          // 패배 수
    private int drawGames;          // 무승부 수

    // 2. 계산된 승률 (소수점 1자리까지, 예: 58.5)
    private double winRate;

    // 3. 분석 결과 코드
    private String winRateGrade;    // A, B, C, D, E
    private String countGrade;      // NEW, MID, HEAVY
    private String trendCode;       // UP, MAINTAIN, DOWN

    // 4. 노출용 멘트 (DB winyo_mentions 조회 결과)
    private String mainMessage;     // 승률 멘트 (WIN_RATE)
    private String subMessage;      // 흐름 멘트 (RECENT_TREND)
    private String countMessage;    // [추가] 횟수 멘트 (ATTENDANCE_COUNT)

    // 5. 랭킹 정보 (선택 사항)
    private String nickname;        // 랭킹 조회 시 사용
}