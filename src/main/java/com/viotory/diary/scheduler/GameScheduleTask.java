package com.viotory.diary.scheduler;

import com.viotory.diary.service.GameDataService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Slf4j
@Component
@RequiredArgsConstructor
public class GameScheduleTask {

    private final GameDataService gameDataService;

    /**
     * [네이버 동기화 스케줄러] 매일 새벽 2시 실행
     * 전날 결과 확정 및 오늘 일정 업데이트
     */
    @Scheduled(cron = "0 0 2 * * *")
    public void runDailySync() {
        log.info("### [스케줄러] 정기 경기 데이터 동기화 태스크 시작");
        try {
            gameDataService.syncDailyData();
            log.info("### [스케줄러] 정기 경기 데이터 동기화 태스크 종료");
        } catch (Exception e) {
            log.error("### [스케줄러] 태스크 수행 중 치명적 오류: {}", e.getMessage());
        }
    }

    /**
     * [2. 실시간 경기 업데이트]
     * 평일 저녁이나 주말 낮 등 경기가 활발한 시간대에 집중적으로 작동합니다.
     * 여기서는 매일 오후 1시(13시)부터 밤 11시(23시)까지 매 1분마다 실행되도록 설정했습니다.
     */
    @Scheduled(cron = "0 0/1 13-23 * * *")
    public void runLiveSync() {
        // 불필요한 API 호출을 줄이기 위해 현재가 월요일(보통 경기 없음)인지 등의 체크를 추가할 수도 있습니다.
        log.info(">>> [라이브 스케줄러] 실시간 점수 및 상태 체크 중...");
        gameDataService.syncDailyData();
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