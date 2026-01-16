package com.viotory.diary.service;

import com.viotory.diary.mapper.TeamInfoMngMapper;
import com.viotory.diary.vo.TeamVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TeamInfoMngService {

    private final TeamInfoMngMapper teamInfoMngMapper;

    public List<TeamVO> getTeamList() {
        return teamInfoMngMapper.selectTeamList();
    }

    public TeamVO getTeam(String teamCode) {
        return teamInfoMngMapper.selectTeamByCode(teamCode);
    }

    @Transactional
    public void updateTeam(TeamVO team) {
        teamInfoMngMapper.updateTeam(team);
    }
}