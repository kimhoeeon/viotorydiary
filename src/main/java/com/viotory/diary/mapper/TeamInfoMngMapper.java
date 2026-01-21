package com.viotory.diary.mapper;

import com.viotory.diary.vo.Criteria;
import com.viotory.diary.vo.TeamVO;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface TeamInfoMngMapper {

    // 목록 조회
    List<TeamVO> getTeamList();

    // 상세 조회
    TeamVO selectTeamByCode(String teamCode);

    // 정보 수정
    void updateTeam(TeamVO team);

    List<TeamVO> selectTeamList(Criteria cri);
}