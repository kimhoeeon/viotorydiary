package com.viotory.diary.service;

import com.viotory.diary.dto.WinYoAnalysisDTO;
import com.viotory.diary.mapper.DiaryMapper;
import com.viotory.diary.mapper.WinYoMentionMapper;
import com.viotory.diary.vo.DiaryVO;
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

    /**
     * 사용자의 승요력(승률+흐름)을 분석하여 결과를 반환한다.
     * @param memberId 사용자 ID
     */
    public WinYoAnalysisDTO analyzeWinYoPower(Long memberId) {
        // 1. 유효한 일기 조회 (Mapper 수정으로 실제 스코어와 예측 스코어가 모두 포함되어 내려옴)
        List<DiaryVO> diaries = diaryMapper.selectVerifiedDiaries(memberId);
        int total = diaries.size();

        int wins = 0;
        int loses = 0;

        // 구장별 방문 횟수 카운팅용 맵
        Map<String, Integer> stadiumCountMap = new HashMap<>();

        // 2. 통계 계산을 위한 승부 예측 결과 도출 (diaries 테이블 스코어 기준)
        for (DiaryVO d : diaries) {

            // 스코어 예측값과 실제 결과값이 모두 존재할 때만 비교 (무승부는 제외)
            if (d.getPredScoreHome() != null && d.getPredScoreAway() != null) {

                // 내 예측 스코어(Integer)와 실제 스코어(int)가 완전히 일치하면 '승'
                // (== 연산자 사용 시 Integer가 자동으로 int로 언박싱되어 정확한 값 비교가 이루어집니다)
                if (d.getPredScoreHome() == d.getScoreHome() && d.getPredScoreAway() == d.getScoreAway()) {
                    wins++;
                } else {
                    loses++;
                }
            }

            // 구장 카운트
            if (d.getStadiumName() != null) {
                stadiumCountMap.put(d.getStadiumName(), stadiumCountMap.getOrDefault(d.getStadiumName(), 0) + 1);
            }
        }

        // 최다 방문 구장 찾기
        String topStadium = "-";
        int maxCount = 0;
        for (Map.Entry<String, Integer> entry : stadiumCountMap.entrySet()) {
            if (entry.getValue() > maxCount) {
                maxCount = entry.getValue();
                topStadium = entry.getKey();
            }
        }

        // 3. 승률 계산 (소수점 유지, 예측을 남긴 경기 수만 기준)
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
        String trendCode = analyzeTrend(diaries);
        analysis.setTrendCode(trendCode);
        analysis.setSubMessage(mentionMapper.selectMessage("RECENT_TREND", trendCode));

        return analysis;
    }

    // 최근 3경기 흐름 분석 (예측 적중 여부 기준)
    private String analyzeTrend(List<DiaryVO> diaries) {
        if (diaries.size() < 3) return "WAIT";

        int recentWins = 0;
        int recentLoses = 0;

        // 최신 3경기만 확인
        for (int i = 0; i < 3; i++) {
            DiaryVO d = diaries.get(i);

            // 동일하게 null 체크 제거 및 == 비교 적용
            if (d.getPredScoreHome() != null && d.getPredScoreAway() != null) {
                if (d.getPredScoreHome() == d.getScoreHome() && d.getPredScoreAway() == d.getScoreAway()) {
                    recentWins++;
                } else {
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