package com.viotory.diary.scheduler;

import com.viotory.diary.service.GameDataService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class GameScheduleTask {

    private final GameDataService gameDataService;

    /**
     * [ 네이버 ]
     * [정기 동기화] 매일 새벽 2시
     * - 전날 경기 결과 확정 (혹시 취소된 경기나 늦게 끝난 경기 업데이트)
     * - 오늘 예정된 경기 목록 생성
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
     * [ 네이버 ]
     * [라이브 업데이트] 매일 13시 ~ 23시 (1분 간격)
     * - 실시간 점수, 경기 취소 여부, 경기 종료 처리
     * - 월요일은 보통 경기가 없으므로 체크하여 스킵 (포스트시즌 등 예외 제외)
     */
    @Scheduled(cron = "0 0/1 13-23 * * *")
    public void runLiveSync() {
        // 1. 월요일 체크 (KBO는 보통 월요일 경기가 없음, 필요 시 주석 해제)
        /*
        DayOfWeek dayOfWeek = LocalDate.now().getDayOfWeek();
        if (dayOfWeek == DayOfWeek.MONDAY) {
            // 월요일이라도 혹시 경기가 잡혀있을 수 있으니(우천취소분 등),
            // DB에서 오늘자 경기가 있는지 조회해보고 없으면 리턴하는 로직을 추가하면 더 좋습니다.
            // 여기서는 일단 패스
        }
        */

        log.debug(">>> [라이브 스케줄러] 실시간 데이터 체크");
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