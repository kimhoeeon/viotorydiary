package com.viotory.diary.service;

import com.viotory.diary.mapper.GameMapper;
import com.viotory.diary.mapper.PredictionMapper;
import com.viotory.diary.vo.GameVO;
import com.viotory.diary.vo.PredictionVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class PlayService {

    private final GameMapper gameMapper;
    private final PredictionMapper predictionMapper;
    private final AlarmService alarmService;

    // 특정 날짜의 경기 목록 (나의 예측 정보 포함)
    public List<GameVO> getGameListWithPrediction(Long memberId, String date) {
        List<GameVO> games = gameMapper.selectGamesByDate(date);

        // 각 경기별로 내가 예측한 팀이 있는지 확인해서 세팅 (간단한 로직)
        for (GameVO game : games) {
            PredictionVO pred = predictionMapper.selectMyPredictionByGameId(memberId, game.getGameId());
            if (pred != null) {
                game.setMyPredictedTeam(pred.getPredictedTeam());
            }
        }
        return games;
    }

    // 예측 제출
    @Transactional
    public void submitPrediction(Long memberId, Long gameId, String teamCode) {
        // 경기 시작 시간 체크 로직 등은 여기서 추가 가능
        predictionMapper.savePrediction(memberId, gameId, teamCode);
    }

    // 예측 히스토리
    public List<PredictionVO> getPredictionHistory(Long memberId) {
        return predictionMapper.selectMyPredictionHistory(memberId);
    }

    // 적중률 통계
    public Map<String, Object> getPredictionStats(Long memberId) {
        return predictionMapper.selectPredictionStats(memberId);
    }

    /**
     * 경기 종료 후 예측 결과 처리 및 알림 발송
     * 1. 해당 경기의 모든 사용자 예측을 조회
     * 2. 승리팀과 비교하여 정답 여부(isCorrect) 업데이트
     * 3. 정답자에게 축하 알림 발송
     */
    @Transactional
    public void processPredictionResult(GameVO game) {
        // 결과가 없거나 취소된 경기라면 처리하지 않음
        if (game.getWinningTeam() == null || "CANCELLED".equals(game.getStatus())) {
            return;
        }

        Long gameId = game.getGameId();
        String winningTeam = game.getWinningTeam();

        // 1. 이 경기에 예측을 제출한 모든 내역 조회
        List<PredictionVO> predictions = predictionMapper.selectPredictionsByGameId(gameId);

        int correctCount = 0;

        for (PredictionVO pred : predictions) {
            boolean isCorrect = winningTeam.equals(pred.getPredictedTeam());

            // 2. 결과 업데이트 (적중/실패 여부는 매번 최신화 - 경기 결과 정정 대비)
            predictionMapper.updatePredictionResult(pred.getPredictionId(), isCorrect);

            // 3. [알림 발송]
            // 조건: 적중함(isCorrect) AND 아직 알림을 안 보냄(!isAlarmSent)
            // (Boolean 타입이므로 null 체크 또는 Boolean.TRUE.equals 사용 권장)
            if (isCorrect && !Boolean.TRUE.equals(pred.getIsAlarmSent())) {

                String content = "[적중] " + game.getHomeTeamName() + " vs " + game.getAwayTeamName() + " 승부예측 성공! 승요력이 상승했습니다.";

                // 알림 발송
                alarmService.sendAlarm(pred.getMemberId(), "GAME", content, "/play");

                // [중요] 발송 완료 체크 (DB 업데이트)
                predictionMapper.updateAlarmSent(pred.getPredictionId());

                correctCount++;
            }
        }

        log.info("경기 예측 결과 처리 완료: gameId={}, 총 예측={}, 신규 정답 알림={}", gameId, predictions.size(), correctCount);
    }

}