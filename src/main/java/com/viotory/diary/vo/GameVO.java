package com.viotory.diary.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameVO {

    private Integer gameId;            // 내부 관리용 PK (Auto Increment)

    /* API 연동 관련 추가 필드 */
    private String apiGameId;      // API-Baseball에서 제공하는 고유 fixture ID

    private String gameDate;        // 경기 날짜 (YYYY-MM-DD)
    private String gameTime;        // 경기 시간 (HH:mm:ss)

    private Integer stadiumId;      // 구장 ID (기본값 또는 매핑값)

    private String homeTeamCode;    // 홈팀 코드 (LG, KT, SSG 등)
    private String awayTeamCode;    // 원정팀 코드 (KIA, DOOSAN 등)

    // 점수는 경기가 시작되기 전에는 null일 수 있으므로 Integer 권장
    private Integer scoreHome;      // 홈팀 최종 점수
    private Integer scoreAway;      // 원정팀 최종 점수

    /* 경기 상태 (우리 시스템 정의)
       - SCHEDULED: 경기 시작 전
       - LIVE: 경기 진행 중
       - FINISHED: 경기 종료
       - CANCELLED: 우천 취소 등 경기 취소
    */
    private String status;          // 경기 상태 코드

    private String cancelReason; // 취소 사유
    private String mvpPlayer;    // 수훈 선수
    
    private String createdAt;       // 데이터 생성일
    private String updatedAt;       // 데이터 수정일

    /* MyBatis 결과 매핑을 위한 추가 필드 (DB 테이블에는 없음)
       Join 등을 통해 팀 이름을 가져올 때 사용합니다.
    */
    private String homeTeamName;
    private String awayTeamName;
}