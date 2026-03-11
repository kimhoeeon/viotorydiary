package com.viotory.diary.service;

import com.viotory.diary.dto.WinYoAnalysisDTO;
import com.viotory.diary.mapper.DiaryMapper;
import com.viotory.diary.mapper.PredictionMapper;
import com.viotory.diary.mapper.WinYoMentionMapper;
import com.viotory.diary.vo.DiaryVO;
import com.viotory.diary.vo.PredictionVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class WinYoService {

    private final DiaryMapper diaryMapper; // 다이어리 목록 조회용
    private final WinYoMentionMapper mentionMapper; // 멘트 조회용
    private final PredictionMapper predictionMapper;

    /**
     * 사용자의 승요력(승률+흐름)을 분석하여 결과를 반환한다.
     * @param memberId 사용자 ID
     */
    public WinYoAnalysisDTO analyzeWinYoPower(Long memberId) {
        // 1. 유효한 일기 조회 (구장 카운팅 및 뱃지용, 트렌드 분석용)
        List<DiaryVO> diaries = diaryMapper.selectVerifiedDiaries(memberId);
        int total = diaries.size();

        // 2. 통계 계산을 위한 승부 예측 결과 조회 (is_correct 기준)
        List<PredictionVO> predictions = predictionMapper.selectPredictionsByMember(memberId);

        int wins = 0;
        int loses = 0;

        for(PredictionVO p : predictions) {
            // 직관 일기를 작성 완료한 경기의 예측만 통계에 포함 (diaries 리스트와 매칭)
            boolean isDiaryCompleted = diaries.stream().anyMatch(d -> d.getGameId().equals(p.getGameId()));

            if(isDiaryCompleted && p.getIsCorrect() != null) {
                String correctVal = String.valueOf(p.getIsCorrect());
                if ("true".equalsIgnoreCase(correctVal) || "1".equals(correctVal)) {
                    wins++;
                } else if ("false".equalsIgnoreCase(correctVal) || "0".equals(correctVal)) {
                    loses++;
                }
            }
        }

        // 구장별 방문 횟수 카운팅
        Map<String, Integer> stadiumCountMap = new HashMap<>();
        for (DiaryVO d : diaries) {
            if (d.getStadiumName() != null) {
                stadiumCountMap.put(d.getStadiumName(), stadiumCountMap.getOrDefault(d.getStadiumName(), 0) + 1);
            }
        }

        String topStadium = "-";
        int maxCount = 0;
        for (Map.Entry<String, Integer> entry : stadiumCountMap.entrySet()) {
            if (entry.getValue() > maxCount) {
                maxCount = entry.getValue();
                topStadium = entry.getKey();
            }
        }

        // 3. 승률 계산 (소수점 유지, 총 경기수는 예측한 경기 수 기준)
        int validPredictionsCount = wins + loses;
        double winRate = (validPredictionsCount > 0) ? ((double) wins / validPredictionsCount) * 100.0 : 0.0;

        // 4. DTO 생성
        WinYoAnalysisDTO analysis = WinYoAnalysisDTO.builder()
                .totalGames(total)
                .winGames(wins)
                .loseGames(loses)
                .drawGames(0) // 무승부 완전 제거
                .winRate(winRate)
                .topStadium(topStadium)
                .build();

        // 5. [규칙 적용] 승률 구간 (A~E)
        String rateCode;
        if (winRate >= 70) rateCode = "A";
        else if (winRate >= 60) rateCode = "B";
        else if (winRate >= 50) rateCode = "C";
        else if (winRate >= 40) rateCode = "D";
        else rateCode = "E";

        analysis.setWinRateGrade(rateCode);
        analysis.setMainMessage(mentionMapper.selectMessage("WIN_RATE", rateCode));

        // 6. [규칙 적용] 직관 횟수
        String countCode;
        if (total >= 10) countCode = "HEAVY";
        else if (total >= 3) countCode = "MID";
        else countCode = "NEW";

        analysis.setCountGrade(countCode);
        analysis.setCountMessage(mentionMapper.selectMessage("ATTENDANCE_COUNT", countCode));

        // 7. [규칙 적용] 최근 흐름 (트렌드는 최근 3경기 예측 결과를 바탕으로 함)
        String trendCode = analyzeTrend(memberId, diaries);
        analysis.setTrendCode(trendCode);
        analysis.setSubMessage(mentionMapper.selectMessage("RECENT_TREND", trendCode));

        return analysis;
    }

    // 최근 3경기 흐름 분석 (예측 적중 여부 기준)
    private String analyzeTrend(Long memberId, List<DiaryVO> diaries) {
        if (diaries.size() < 3) return "WAIT";

        int recentWins = 0;
        int recentLoses = 0;

        // 최신 3경기의 gameId 추출
        for (int i = 0; i < 3; i++) {
            Long gameId = diaries.get(i).getGameId();
            PredictionVO p = predictionMapper.selectPredictionByMemberAndGame(memberId, gameId);

            if (p != null && p.getIsCorrect() != null) {
                String correctVal = String.valueOf(p.getIsCorrect());
                if ("true".equalsIgnoreCase(correctVal) || "1".equals(correctVal)) {
                    recentWins++;
                } else if ("false".equalsIgnoreCase(correctVal) || "0".equals(correctVal)) {
                    recentLoses++;
                }
            }
        }

        if (recentWins >= 2) return "UP";        // 상승세
        else if (recentLoses >= 2) return "DOWN"; // 하락세
        return "KEEP";                            // 유지
    }

    /**
     * [명예의 전당] 승요 랭킹 TOP 10 조회
     */
    public List<WinYoAnalysisDTO> getWinYoRanking() {
        return diaryMapper.selectWinYoRankingTop10();
    }

}