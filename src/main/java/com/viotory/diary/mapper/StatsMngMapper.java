package com.viotory.diary.mapper;

import com.viotory.diary.vo.UserStatsVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface StatsMngMapper {
    // 승률 랭킹 조회 (직관 수 많은 순 or 승률 높은 순)
    List<UserStatsVO> selectWinRateRanking();

    // [추가] 수동 승률 업데이트 쿼리
    void updateManualWinRate(@Param("memberId") Long memberId, @Param("winRate") Double winRate);

    int selectDau();

    int selectMau();

    double selectTotalAvgWinRate();

    double selectAvgMonthlyDiaries(int mau);

    List<Map<String, Object>> selectWeeklyAccessStats();

    Map<String, Object> selectMemberStatusStats();

    Map<String, Object> selectDiaryStatusStats();
}