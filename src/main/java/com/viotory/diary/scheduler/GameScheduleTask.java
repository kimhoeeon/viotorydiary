package com.viotory.diary.scheduler;

import com.viotory.diary.service.AlarmService;
import com.viotory.diary.service.GameDataService;
import com.viotory.diary.service.GameService;
import com.viotory.diary.service.PlayService;
import com.viotory.diary.vo.GameVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class GameScheduleTask {

    private final GameDataService gameDataService;
    private final GameService gameService; // DB 조회용
    private final PlayService playService; // 승부예측 처리용
    private final AlarmService alarmService; // 알림 서비스 주입

    /**
     * [ 네이버/API ]
     * [정기 동기화] 매일 새벽 2시
     * - 전날 경기 결과 확정 및 오늘 일정 생성
     */
    @Scheduled(cron = "0 0 2 * * *")
    public void runDailySync() {
        log.info("### [스케줄러] 정기 경기 데이터 동기화 시작 (새벽 2시)");
        try {
            gameDataService.syncDailyData();
            log.info("### [스케줄러] 정기 경기 데이터 동기화 완료");
        } catch (Exception e) {
            log.error("### [스케줄러] 에러 발생: {}", e.getMessage());
        }
    }

    /**
     * [라이브 업데이트] 매일 13시 ~ 23시 (1분 간격)
     * - 실시간 점수 업데이트
     * - 경기 종료(FINISHED) 감지 시 승부예측 결과 처리 및 알림 발송
     */
    @Scheduled(cron = "0 0/1 13-23 * * *")
    public void runLiveSync() {
        log.debug(">>> [라이브 스케줄러] 실시간 경기 정보 확인 중...");

        // 1. 오늘 경기 목록 조회
        List<GameVO> todayGames = gameService.getAllGamesToday();
        if (todayGames.isEmpty()) return;

        for (GameVO game : todayGames) {
            // try-catch를 반복문 안으로 이동 (개별 경기 에러 격리)
            try {
                // 종료(FINISHED)되었거나 취소(CANCELLED)된 경기는 업데이트 건너뛰기
                if ("FINISHED".equals(game.getStatus()) || "CANCELLED".equals(game.getStatus())) {
                    // (선택) 종료된 경기도 알림 누락 방지 차원에서 호출 가능
                    playService.processPredictionResult(game);
                    continue;
                }

                // 2. 업데이트 수행
                GameVO updatedGame = gameDataService.updateLiveGame(game.getApiGameId());

                if (updatedGame != null) {
                    // 3. (종료 OR 취소 시 결과 처리 시도) 감지 시 승부예측 처리
                    if ("FINISHED".equals(updatedGame.getStatus()) || "CANCELLED".equals(updatedGame.getStatus())) {
                        log.info(">>> [경기종료 감지] {} vs {}, 결과 처리 시도 : ({} -> {})",
                                updatedGame.getHomeTeamName(), updatedGame.getAwayTeamName(), game.getStatus(), updatedGame.getStatus());

                        playService.processPredictionResult(updatedGame);
                    }
                }
            } catch (Exception e) {
                // 특정 경기 업데이트 실패 시 로그만 남기고 다음 경기로 진행
                log.error(">>> [라이브 스케줄러] 경기({}) 업데이트 실패: {}", game.getGameId(), e.getMessage());
            }
        }
    }

    /**
     * [알림 정리] 매일 새벽 4시
     * - 7일이 지난 오래된 알림 데이터 삭제
     */
    @Scheduled(cron = "0 0 4 * * *")
    public void runAlarmCleanup() {
        log.info("### [스케줄러] 오래된 알림 삭제 시작 (새벽 4시)");
        try {
            alarmService.deleteExpiredAlarms();
            log.info("### [스케줄러] 오래된 알림 삭제 완료");
        } catch (Exception e) {
            log.error("### [스케줄러] 알림 삭제 중 에러 발생: {}", e.getMessage());
        }
    }

    /*// 1. 매일 새벽 2시에 '오늘' 예정된 경기 일정을 가져옴 (초기화)
    @Scheduled(cron = "0 0 2 * * *")
    public void scheduleDailyUpdate() {
        log.info("[Batch] 새벽 정기 업데이트 시작");
        gameDataService.fetchFromRapid(LocalDate.now());
    }

    // 2. 경기 시간대(18시~23시)에 10분마다 라이브 스코어 갱신
    // (하루 100회 제한을 고려하여 10분 간격 설정)
    @Scheduled(cron = "0 0/10 18-23 * * *")
    public void scheduleLiveScoreUpdate() {
        log.info("[Batch] 라이브 스코어 업데이트 시작");
        gameDataService.fetchFromRapid(LocalDate.now());
    }*/

}