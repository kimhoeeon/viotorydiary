package com.viotory.diary.service;

import com.viotory.diary.dto.WinYoAnalysisDTO;
import com.viotory.diary.mapper.DiaryMapper;
import com.viotory.diary.mapper.WinYoMentionMapper;
import com.viotory.diary.vo.DiaryVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

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
        // 1. DiaryMapper를 통해 유효한 일기 조회 (승패 결과 포함)
        List<DiaryVO> diaries = diaryMapper.selectVerifiedDiaries(memberId);

        int total = diaries.size();
        int wins = 0;
        int loses = 0;
        int draws = 0;

        // 2. 승/패/무 카운트
        for (DiaryVO d : diaries) {
            if ("WIN".equals(d.getGameResult())) wins++;
            else if ("LOSE".equals(d.getGameResult())) loses++;
            else draws++;
        }

        // 3. 승률 계산
        double winRate = (total > 0) ? ((double) wins / total) * 100.0 : 0.0;

        // 4. 등급 및 멘트 매핑을 위한 DTO 생성
        WinYoAnalysisDTO analysis = WinYoAnalysisDTO.builder()
                .totalGames(total)
                .winGames(wins)
                .loseGames(loses)
                .drawGames(draws)
                .winRate(winRate)
                .build();

        // 5. [규칙 적용] 승률 구간 (A~E)
        String rateCode;
        if (winRate >= 70) rateCode = "A";
        else if (winRate >= 60) rateCode = "B";
        else if (winRate >= 50) rateCode = "C";
        else if (winRate >= 40) rateCode = "D";
        else rateCode = "E";

        analysis.setWinRateGrade(rateCode);
        // WinYoMentionMapper 사용
        analysis.setMainMessage(mentionMapper.selectMentionByCode("WIN_RATE", rateCode));

        // 6. [규칙 적용] 직관 횟수 (New, Mid, Heavy)
        String countCode;
        if (total >= 10) countCode = "HEAVY";
        else if (total >= 3) countCode = "MID";
        else countCode = "NEW";

        analysis.setCountGrade(countCode);
        analysis.setCountMessage(mentionMapper.selectMentionByCode("ATTENDANCE_COUNT", countCode));

        // 7. [규칙 적용] 최근 흐름
        String trendCode = analyzeTrend(diaries);
        analysis.setTrendCode(trendCode);
        analysis.setSubMessage(mentionMapper.selectMentionByCode("RECENT_TREND", trendCode));

        return analysis;
    }

    // 최근 3경기 흐름 분석 헬퍼
    private String analyzeTrend(List<DiaryVO> diaries) {
        if (diaries.size() < 3) return "WAIT"; // 3경기 미만은 대기 상태

        int recentWins = 0;
        int recentLoses = 0;

        // 최신 3경기만 확인
        for (int i = 0; i < 3; i++) {
            String res = diaries.get(i).getGameResult();
            if ("WIN".equals(res)) recentWins++;
            else if ("LOSE".equals(res)) recentLoses++;
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