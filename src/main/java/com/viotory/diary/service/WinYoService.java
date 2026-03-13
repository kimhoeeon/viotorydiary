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
        // 1. 유효한 직관 일기 조회
        List<DiaryVO> diaries = diaryMapper.selectVerifiedDiaries(memberId);
        int total = diaries.size();

        int wins = 0;
        int loses = 0;
        int draws = 0;

        // 구장별 방문 횟수 카운팅용 맵
        Map<String, Integer> stadiumCountMap = new HashMap<>();

        // 2. 통계 계산 (단순 재미용 스코어 예측이 아닌 '내 응원팀 실제 경기 승패' 기준!)
        for (DiaryVO d : diaries) {

            if ("WIN".equals(d.getGameResult())) {
                wins++;
            } else if ("LOSE".equals(d.getGameResult())) {
                loses++;
            } else if ("DRAW".equals(d.getGameResult())) {
                draws++;
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

        // 3. 승률 계산 (소수점 유지, 야구 승률 규정에 따라 무승부는 제외한 validGames 기준)
        int validGames = wins + loses;
        double winRate = (validGames > 0) ? ((double) wins / validGames) * 100.0 : 0.0;

        // 4. DTO 생성
        WinYoAnalysisDTO analysis = WinYoAnalysisDTO.builder()
                .totalGames(total)
                .winGames(wins)
                .loseGames(loses)
                .drawGames(draws)
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

        // 7. [규칙 적용] 최근 흐름 (트렌드 역시 내 응원팀 실제 승패 기준)
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

        for (int i = 0; i < 3; i++) {
            DiaryVO d = diaries.get(i);
            if ("WIN".equals(d.getGameResult())) {
                recentWins++;
            } else if ("LOSE".equals(d.getGameResult())) {
                recentLoses++;
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