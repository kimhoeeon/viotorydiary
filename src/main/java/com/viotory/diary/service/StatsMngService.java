package com.viotory.diary.service;

import com.viotory.diary.mapper.StatsMngMapper;
import com.viotory.diary.vo.UserStatsVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class StatsMngService {
    private final StatsMngMapper statsMapper;

    public Map<String, Object> getRankingList(int pageNum, int amount, String sortCol, String sortDir) {
        int offset = (pageNum - 1) * amount;
        List<UserStatsVO> list = statsMapper.selectWinRateRanking(sortCol, sortDir, amount, offset);
        int total = statsMapper.getTotalRankingCount();

        for (int i = 0; i < list.size(); i++) {
            UserStatsVO vo = list.get(i);
            // 정렬된 순서에 맞춰 전체 등수 부여 (첫 페이지 1위부터)
            vo.setRanking(offset + i + 1);

            if (vo.getManualWinRate() != null) {
                vo.setWinRate(vo.getManualWinRate());
            } else {
                if (vo.getTotalGames() > 0) {
                    double rate = (double) vo.getWinGames() / vo.getTotalGames() * 100.0;
                    vo.setWinRate(Math.round(rate * 10) / 10.0);
                } else {
                    vo.setWinRate(0.0);
                }
            }
        }

        // 하단 페이징 블록 계산 (10개씩 노출)
        int endPage = (int) (Math.ceil(pageNum / 10.0)) * 10;
        int startPage = endPage - 9;
        int realEnd = (int) (Math.ceil((total * 1.0) / amount));
        if (realEnd < endPage) endPage = realEnd;
        boolean prev = startPage > 1;
        boolean next = endPage < realEnd;

        Map<String, Object> pageMap = new HashMap<>();
        pageMap.put("pageNum", pageNum);
        pageMap.put("amount", amount);
        pageMap.put("startPage", startPage);
        pageMap.put("endPage", endPage);
        pageMap.put("prev", prev);
        pageMap.put("next", next);
        pageMap.put("total", total);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("page", pageMap);

        return result;
    }

    // [추가] 수동 승률 업데이트
    @Transactional
    public void updateManualWinRate(Long memberId, Double winRate) {
        statsMapper.updateManualWinRate(memberId, winRate);
    }

    // 대시보드 통계 조회용
    public int getDau() {
        return statsMapper.selectDau();
    }

    public int getMau() {
        return statsMapper.selectMau();
    }

    public double getTotalAvgWinRate() {
        return statsMapper.selectTotalAvgWinRate();
    }

    public double getAvgMonthlyDiaries(int mau) {
        if (mau == 0) return 0.0;
        return statsMapper.selectAvgMonthlyDiaries(mau);
    }

    public List<Map<String, Object>> getWeeklyAccessStats() {
        return statsMapper.selectWeeklyAccessStats();
    }

    // 회원 상태별 통계 반환
    public Map<String, Object> getMemberStatusStats() {
        return statsMapper.selectMemberStatusStats();
    }

    // 일기 상태별 통계 반환
    public Map<String, Object> getDiaryStatusStats() {
        return statsMapper.selectDiaryStatusStats();
    }

}