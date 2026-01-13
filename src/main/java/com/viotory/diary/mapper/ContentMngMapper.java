package com.viotory.diary.mapper;

import com.viotory.diary.vo.EventVO;
import com.viotory.diary.vo.TeamContentVO;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface ContentMngMapper {
    // 이벤트 관리
    List<EventVO> selectEventList();
    EventVO selectEventById(Long eventId);
    void insertEvent(EventVO event);
    void updateEvent(EventVO event);
    void deleteEvent(Long eventId);

    // 팀 콘텐츠 관리
    List<TeamContentVO> selectTeamContentList();
    TeamContentVO selectTeamContentById(Long contentId);
    void insertTeamContent(TeamContentVO content);
    void updateTeamContent(TeamContentVO content);
    void deleteTeamContent(Long contentId);
}