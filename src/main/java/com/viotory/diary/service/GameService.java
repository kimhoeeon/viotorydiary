package com.viotory.diary.service;

import com.viotory.diary.mapper.GameMapper;
import com.viotory.diary.vo.GameVO;
import com.viotory.diary.vo.StadiumVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class GameService {

    private final GameMapper gameMapper;

    /**
     * 오늘 내 응원팀의 경기 정보 조회
     */
    public GameVO getMyTeamGameToday(String teamCode) {
        if (teamCode == null || "NONE".equals(teamCode)) {
            return null;
        }
        String today = LocalDate.now().toString(); // "yyyy-MM-dd"
        return gameMapper.selectGameByDateAndTeam(today, teamCode);
    }

    /**
     * 오늘 전체 경기 목록 조회 (타구장 소식용)
     */
    public List<GameVO> getAllGamesToday() {
        String today = LocalDate.now().toString();
        return gameMapper.selectGamesByDate(today);
    }

    public GameVO getTodayGame(String myTeamCode) {
        return gameMapper.selectTodayGame(myTeamCode);
    }

    /**
     * 경기 ID로 상세 정보 조회 (일기 작성 화면용)
     */
    public GameVO getGameById(Long gameId) {
        return gameMapper.selectGameById(gameId);
    }

    // 구장 정보 조회
    public StadiumVO getStadium(Integer stadiumId) {
        return gameMapper.selectStadiumById(stadiumId);
    }

    public int countTodayGames() {
        return gameMapper.countTodayGames();
    }

}