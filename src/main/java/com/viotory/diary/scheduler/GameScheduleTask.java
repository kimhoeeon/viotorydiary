package com.viotory.diary.scheduler;

import com.viotory.diary.mapper.MemberMapper;
import com.viotory.diary.service.AlarmService;
import com.viotory.diary.service.GameDataService;
import com.viotory.diary.service.GameService;
import com.viotory.diary.service.PlayService;
import com.viotory.diary.vo.AlarmVO;
import com.viotory.diary.vo.GameVO;
import com.viotory.diary.vo.MemberVO;
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
    private final MemberMapper memberMapper;

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
     * [통합 라이브 스케줄러] 매일 08시 ~ 익일 02시 59분 (1분 간격)
     * - 실시간 점수 확인
     * - 경기 상태 변경(LIVE, FINISHED, CANCELLED) 감지 시 1회 알림 발송 및 DB 변경
     * - 경기 종료 및 취소 시 승부예측 정산 (1회 보장)
     * - 아침 일찍 우천취소 및 자정 넘어가는 연장전 완벽 대응
     */
    @Scheduled(cron = "0 0/1 8-23,0-2 * * *")
    public void runLiveSync() {
        log.debug(">>> [라이브 스케줄러] 실시간 경기 정보 확인 중...");

        // 오늘 경기 전체가 아닌, "어제/오늘 중 아직 안 끝난 경기"만 타겟팅
        List<GameVO> targetGames = gameService.getOngoingGames();

        // 안 끝난 경기가 없으면 (월요일 등) 즉시 종료되어 불필요한 API 호출(비용) 완벽 차단!
        if (targetGames.isEmpty()) return;

        for (GameVO game : targetGames) {
            try {

                if ("FINISHED".equals(game.getStatus()) || "CANCELLED".equals(game.getStatus())) {
                    continue;
                }

                // API 서버 차단(429 Too Many Requests) 방지를 위해 1초 대기
                Thread.sleep(1000);

                // 1. API를 통해 최신 점수 및 상태 정보 업데이트
                GameVO updatedGame = gameDataService.updateLiveGame(game.getApiGameId());

                if (updatedGame != null) {
                    // 상태가 변경되는 찰나의 순간을 감지 (중복 실행 방지)
                    if (!game.getStatus().equals(updatedGame.getStatus())) {
                        log.info(">>> [상태 변경 감지] {} vs {}, 상태 : {} -> {}",
                                updatedGame.getHomeTeamName(), updatedGame.getAwayTeamName(), game.getStatus(), updatedGame.getStatus());

                        // 2. 사용자에게 상태 변경 알림 발송 (시작/종료/취소)
                        createGameStatusAlarm(updatedGame, updatedGame.getStatus());

                        // 3. DB에 확실하게 변경된 상태 저장
                        gameDataService.updateGameStatus(updatedGame);

                        // 4. 경기가 종료되거나 취소되었을 때 승부예측 결과 정산 로직 실행
                        if ("FINISHED".equals(updatedGame.getStatus()) || "CANCELLED".equals(updatedGame.getStatus())) {
                            playService.processPredictionResult(updatedGame);
                        }
                    }
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                log.error(">>> [라이브 스케줄러] 루프 대기 중 인터럽트 발생");
            } catch (Exception e) {
                log.error(">>> [라이브 스케줄러] 경기({}) 업데이트 실패: {}", game.getGameId(), e.getMessage());
            }
        }
    }

    // 경기 알림 DB 생성 메서드
    private void createGameStatusAlarm(GameVO game, String newStatus) {
        try {
            String message = "";
            if ("LIVE".equals(newStatus)) {
                message = game.getHomeTeamName() + " vs " + game.getAwayTeamName() + " 경기가 시작되었습니다!";
            } else if ("FINISHED".equals(newStatus)) {
                message = game.getHomeTeamName() + " vs " + game.getAwayTeamName() + " 경기가 종료되었습니다.";
            } else if ("CANCELLED".equals(newStatus)) {
                message = game.getHomeTeamName() + " vs " + game.getAwayTeamName() + " 경기가 취소되었습니다.";
            }

            if (message.isEmpty()) return;

            // 해당 경기를 치르는 홈/원정팀을 응원팀으로 설정하고 game_alarm='Y'인 회원 조회
            List<MemberVO> targetMembers = memberMapper.selectMembersForGameAlarm(game.getHomeTeamCode(), game.getAwayTeamCode());

            for (MemberVO member : targetMembers) {
                // 기존에 구현된 AlarmService의 sendAlarm 메서드 사용 (VO 직접 생성 X)
                alarmService.sendAlarm(member.getMemberId(), "GAME", message, "/main");
            }
        } catch (Exception e) {
            log.error("경기 상태 변경 알림 DB 저장 실패", e);
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