package com.viotory.diary.service;

import com.viotory.diary.mapper.StatsMngMapper;
import com.viotory.diary.vo.UserStatsVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class StatsMngService {
    private final StatsMngMapper statsMapper;

    public List<UserStatsVO> getRankingList() {
        List<UserStatsVO> list = statsMapper.selectWinRateRanking();

        // 승률 계산 (Java단에서 처리) 및 수동 승률 덮어쓰기
        for (int i = 0; i < list.size(); i++) {
            UserStatsVO vo = list.get(i);
            vo.setRanking(i + 1);

            // [추가] 관리자가 수동으로 입력한 승률이 있다면 우선 적용
            if (vo.getManualWinRate() != null) {
                vo.setWinRate(vo.getManualWinRate());
            } else {
                if (vo.getTotalGames() > 0) {
                    double rate = (double) vo.getWinGames() / vo.getTotalGames() * 100.0;
                    vo.setWinRate(Math.round(rate * 10) / 10.0); // 소수점 첫째자리 반올림
                } else {
                    vo.setWinRate(0.0);
                }
            }
        }
        return list;
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