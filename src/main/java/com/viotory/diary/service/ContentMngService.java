package com.viotory.diary.service;

import com.viotory.diary.mapper.ContentMngMapper;
import com.viotory.diary.vo.EventVO;
import com.viotory.diary.vo.TeamContentVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ContentMngService {

    private final ContentMngMapper contentMapper;

    // ==========================================
    // 1. 이벤트 관리 (기존 Controller 로직 이동)
    // ==========================================
    public List<EventVO> getEventList() {
        return contentMapper.selectEventList();
    }

    public EventVO getEvent(Long eventId) {
        return contentMapper.selectEventById(eventId);
    }

    @Transactional
    public void insertEvent(EventVO vo) {
        contentMapper.insertEvent(vo);
    }

    @Transactional
    public void updateEvent(EventVO vo) {
        contentMapper.updateEvent(vo);
    }

    @Transactional
    public void deleteEvent(Long eventId) {
        contentMapper.deleteEvent(eventId);
    }

    // ==========================================
    // 2. 구단 콘텐츠 관리 (신규 기능)
    // ==========================================
    public List<TeamContentVO> getTeamContentList() {
        return contentMapper.selectTeamContentList();
    }

    public TeamContentVO getTeamContent(Long contentId) {
        return contentMapper.selectTeamContentById(contentId);
    }

    @Transactional
    public void insertTeamContent(TeamContentVO vo) {
        contentMapper.insertTeamContent(vo);
    }

    @Transactional
    public void updateTeamContent(TeamContentVO vo) {
        contentMapper.updateTeamContent(vo);
    }

    @Transactional
    public void deleteTeamContent(Long contentId) {
        contentMapper.deleteTeamContent(contentId);
    }

    // --- [사용자용] 메인 화면 노출 및 집계 ---

    /**
     * 랜덤 콘텐츠 1개 조회
     * @param teamCode 사용자 응원팀 (없으면 'ALL')
     */
    public TeamContentVO getRandomTeamContent(String teamCode) {
        if (teamCode == null || "NONE".equals(teamCode) || "".equals(teamCode)) {
            teamCode = "ALL";
        }
        return contentMapper.selectRandomActiveContent(teamCode);
    }

    @Transactional
    public void increaseClickCount(Long contentId) {
        contentMapper.increaseClickCount(contentId);
    }
}