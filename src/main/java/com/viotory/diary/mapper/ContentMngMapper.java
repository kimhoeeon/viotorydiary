package com.viotory.diary.mapper;

import com.viotory.diary.vo.EventVO;
import com.viotory.diary.vo.TeamContentVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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
    // 목록 조회
    List<TeamContentVO> selectTeamContentList();

    // 상세 조회
    TeamContentVO selectTeamContentById(Long contentId);

    // 등록, 수정, 삭제
    void insertTeamContent(TeamContentVO vo);
    void updateTeamContent(TeamContentVO vo);
    void deleteTeamContent(Long contentId);

    // [기능] 클릭 수 증가 & 랜덤 노출
    void increaseClickCount(@Param("contentId") Long contentId);
    TeamContentVO selectRandomActiveContent(@Param("teamCode") String teamCode);
}