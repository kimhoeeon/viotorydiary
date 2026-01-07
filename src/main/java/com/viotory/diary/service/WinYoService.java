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
        // 1. 사용자의 '유효한' 직관 기록 전체 조회 (승률 계산 대상만)
        // 조건: 직관인증(verified)=true AND 경기취소(status!=INVALID)
        List<DiaryVO> diaries = diaryMapper.selectVerifiedDiaries(memberId);

        int total = diaries.size();
        int win = 0;
        int lose = 0;
        int draw = 0;

        // 2. 승/패 카운팅 (실제 경기 결과 비교 로직은 DB 쿼리에서 처리하거나 여기서 계산)
        // 여기서는 DiaryVO에 gameResult(WIN/LOSE/DRAW)가 있다고 가정하거나 Join된 값을 씀
        for (DiaryVO diary : diaries) {
            // TODO: GameVO의 scoreHome, scoreAway와 myTeamCode를 비교하여 승패 판별 로직 필요
            // 임시 로직: DB에서 가져온 result status 사용
            if ("WIN".equals(diary.getGameResult())) win++;
            else if ("LOSE".equals(diary.getGameResult())) lose++;
            else draw++;
        }

        // 3. 승률 계산: (승리 경기 수 / 전체 경기 수) * 100
        double winRate = (total == 0) ? 0.0 : ((double) win / total) * 100;

        // 4. 등급 산정 (A~E)
        String winRateGrade;
        if (winRate >= 70) winRateGrade = "A";
        else if (winRate >= 60) winRateGrade = "B";
        else if (winRate >= 50) winRateGrade = "C";
        else if (winRate >= 40) winRateGrade = "D";
        else winRateGrade = "E";

        // 5. 직관 횟수 등급 (NEW/MID/HEAVY)
        String countGrade;
        if (total >= 10) countGrade = "HEAVY";
        else if (total >= 3) countGrade = "MID";
        else countGrade = "NEW";

        // 6. 최근 3경기 흐름 분석 (UP/DOWN/MAINTAIN)
        String trendCode = analyzeTrend(diaries);

        // 7. 멘트 조회 (DB에서 가져오기)
        String mainMsg = mentionMapper.selectMessage("WIN_RATE", winRateGrade);
        String subMsg = mentionMapper.selectMessage("RECENT_TREND", trendCode);

        // 8. 결과 반환
        return WinYoAnalysisDTO.builder()
                .totalGames(total)
                .winGames(win)
                .loseGames(lose)
                .winRate(winRate)
                .winRateGrade(winRateGrade)
                .countGrade(countGrade)
                .trendCode(trendCode)
                .mainMessage(mainMsg)
                .subMessage(subMsg)
                .build();
    }

    // 최근 3경기 흐름 분석 헬퍼 메소드
    private String analyzeTrend(List<DiaryVO> diaries) {
        if (diaries.size() < 3) return "LACK_DATA"; // 데이터 부족

        // 최신순으로 정렬되어 있다고 가정 (0:최신, 1:전, 2:전전)
        int recentWinCount = 0;
        int recentLoseCount = 0;

        for (int i = 0; i < 3; i++) {
            String result = diaries.get(i).getGameResult();
            if ("WIN".equals(result)) recentWinCount++;
            else if ("LOSE".equals(result)) recentLoseCount++;
        }

        if (recentWinCount >= 2) return "UP";
        if (recentLoseCount >= 2) return "DOWN";
        return "MAINTAIN";
    }
}