package com.viotory.diary.mapper;

import com.viotory.diary.vo.GameVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface GameMapper {

    /**
     * 경기 데이터 저장 (API 크롤링 시 사용)
     * api_game_id가 같으면 UPDATE, 없으면 INSERT
     */
    int upsertGame(GameVO game);

    /**
     * [관리자용/검증용] 특정 날짜에 두 팀 간의 경기가 있는지 조회
     * 용도: 수동 등록 시 중복 체크
     */
    GameVO selectGameByDateAndTeams(@Param("gameDate") String gameDate,
                                    @Param("homeTeam") String homeTeam,
                                    @Param("awayTeam") String awayTeam);

    /**
     * [메인화면용] 특정 날짜의 '내 팀' 경기 조회
     * 용도: 로그인 유저의 오늘 경기 정보 (홈/원정 무관하게 조회)
     */
    GameVO selectGameByDateAndTeam(@Param("gameDate") String gameDate,
                                   @Param("teamCode") String teamCode);

    /**
     * [메인화면용] 특정 날짜의 전체 경기 조회
     * 용도: 타구장 소식 및 비로그인 유저용
     */
    List<GameVO> selectGamesByDate(String gameDate);


    GameVO selectTodayGameByTeam(String teamCode);

    GameVO selectTodayGame(String myTeamCode);
}