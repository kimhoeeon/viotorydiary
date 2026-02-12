package com.viotory.diary.service;

import com.viotory.diary.mapper.ContentMngMapper;
import com.viotory.diary.util.FileUtil;
import com.viotory.diary.vo.EventVO;
import com.viotory.diary.vo.TeamContentVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class ContentMngService {

    private final ContentMngMapper contentMngMapper;

    // ==========================================
    // 1. 이벤트 관리 (기존 Controller 로직 이동)
    // ==========================================
    public List<EventVO> getEventList() {
        return contentMngMapper.selectEventList();
    }

    // 사용자용 이벤트 목록
    public List<EventVO> getActiveEventList() {
        return contentMngMapper.selectActiveEventList();
    }

    public EventVO getEvent(Long eventId) {
        return contentMngMapper.selectEventById(eventId);
    }

    @Transactional
    public void insertEvent(EventVO vo) {
        contentMngMapper.insertEvent(vo);
    }

    @Transactional
    public void updateEvent(EventVO vo) {
        contentMngMapper.updateEvent(vo);
    }

    @Transactional
    public void deleteEvent(Long eventId) {
        contentMngMapper.deleteEvent(eventId);
    }

    // ==========================================
    // 2. 구단 콘텐츠 관리
    // ==========================================

    // 목록 조회 (필터 추가)
    public List<TeamContentVO> getTeamContentList(String teamCode) {
        return contentMngMapper.selectTeamContentList(teamCode);
    }

    // 사용자용 구단 콘텐츠 목록
    public List<TeamContentVO> getActiveTeamContentList(String teamCode) {
        return contentMngMapper.selectActiveTeamContentList(teamCode);
    }

    // 상세 조회
    public TeamContentVO getTeamContent(Long contentId) {
        return contentMngMapper.selectTeamContentById(contentId);
    }

    // 등록/수정 (OG 태그 추출 로직 포함)
    @Transactional
    public void saveTeamContent(TeamContentVO vo, MultipartFile file) {
        // 1. 파일 업로드 처리
        if (file != null && !file.isEmpty()) {
            try {
                String savedUrl = FileUtil.uploadFile(file, "content");
                vo.setImageUrl(savedUrl);
            } catch (Exception e) {
                log.error("파일 업로드 실패", e);
            }
        }
        // 2. 파일이 없고 URL만 있는 경우 -> OG 태그 추출 시도
        else if ((vo.getImageUrl() == null || vo.getImageUrl().isEmpty())
                && vo.getContentUrl() != null && vo.getContentUrl().startsWith("http")) {
            String ogImage = extractOgImage(vo.getContentUrl());
            if (ogImage != null) {
                vo.setImageUrl(ogImage);
            }
        }

        if (vo.getContentId() == null) {
            contentMngMapper.insertTeamContent(vo);
        } else {
            contentMngMapper.updateTeamContent(vo);
        }
    }

    @Transactional
    public void deleteTeamContent(Long contentId) {
        contentMngMapper.deleteTeamContent(contentId);
    }

    // 순서 변경
    @Transactional
    public void changeSortOrder(Long contentId, String direction) {
        // 1. 현재 항목 조회
        TeamContentVO current = contentMngMapper.selectTeamContentById(contentId);
        if (current == null) return;

        // 2. 맞교환 대상 조회 (같은 팀 내에서, 위/아래 인접한 항목)
        TeamContentVO target = contentMngMapper.selectTargetContentForSwap(
                current.getTeamCode(),
                current.getSortOrder(),
                direction
        );

        // 3. 대상이 존재하면 순서(sortOrder) 값을 서로 교체 (Swap)
        if (target != null) {
            int currentOrder = current.getSortOrder();
            int targetOrder = target.getSortOrder();

            contentMngMapper.updateSortOrder(current.getContentId(), targetOrder);
            contentMngMapper.updateSortOrder(target.getContentId(), currentOrder);
        }
    }

    // 통계 조회
    public Map<String, Object> getStats(Long contentId) {
        Map<String, Object> stats = new HashMap<>();
        stats.put("gender", contentMngMapper.selectGenderStats(contentId));
        stats.put("age", contentMngMapper.selectAgeStats(contentId));
        stats.put("daily", contentMngMapper.selectDailyStats(contentId));
        return stats;
    }

    // [Private] OG 태그 이미지 추출
    private String extractOgImage(String urlString) {
        try {
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setConnectTimeout(3000);
            conn.setRequestProperty("User-Agent", "Mozilla/5.0");

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                if (inputLine.contains("og:image")) {
                    int start = inputLine.indexOf("content=\"") + 9;
                    int end = inputLine.indexOf("\"", start);
                    if (start > 9 && end > start) {
                        return inputLine.substring(start, end);
                    }
                }
            }
            in.close();
        } catch (Exception e) {
            log.warn("OG 태그 추출 실패: {}", e.getMessage());
        }
        return null; // 추출 실패 시 null
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
        return contentMngMapper.selectRandomActiveContent(teamCode);
    }

    @Transactional
    public void increaseClickCount(Long contentId) {
        contentMngMapper.increaseClickCount(contentId);
    }
}