package com.viotory.diary.mapper;

import com.viotory.diary.vo.GameVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface GameMapper {

    // 경기 데이터 저장 (없으면 입력, 있으면 업데이트)
    int upsertGame(GameVO game);

    // 특정 날짜의 경기 조회 (중복 크롤링 방지 확인용)
    GameVO selectGameByDateAndTeams(@Param("gameDate") String gameDate,
                                    @Param("homeTeam") String homeTeam,
                                    @Param("awayTeam") String awayTeam);

}