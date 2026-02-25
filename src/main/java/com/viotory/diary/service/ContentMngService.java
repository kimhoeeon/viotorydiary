package com.viotory.diary.service;

import com.viotory.diary.mapper.ContentMngMapper;
import com.viotory.diary.util.FileUtil;
import com.viotory.diary.vo.ContentClickLogVO;
import com.viotory.diary.vo.EventVO;
import com.viotory.diary.vo.MemberVO;
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
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
            vo.setSortOrder(contentMngMapper.selectMaxSortOrder() + 1); // 순서 채번
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
        stats.put("age", contentMngMapper.selectAgeStats(contentId));
        stats.put("daily", contentMngMapper.selectDailyStats(contentId));
        return stats;
    }

    // OG 태그 이미지 추출
    public String extractOgImage(String urlString) {
        if (urlString == null || urlString.isEmpty()) return null;

        try {
            // 1-1. 유튜브 썸네일 우선 처리 (고화질)
            String youtubePattern = "(?<=watch\\?v=|/videos/|embed\\/|youtu.be\\/|\\/v\\/|\\/e\\/|watch\\?v%3D|watch\\?feature=player_embedded&v=|%2Fvideos%2F|embed%2F|youtu.be%2F|%2Fv%2F)[^#\\&\\?\\n]*";
            Pattern compiledPattern = Pattern.compile(youtubePattern);
            Matcher matcher = compiledPattern.matcher(urlString);
            if (matcher.find()) {
                return "https://img.youtube.com/vi/" + matcher.group() + "/mqdefault.jpg";
            }

            // 1-2. 일반 사이트 (Instagram 등) OG 태그 파싱
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setConnectTimeout(5000); // 5초 타임아웃
            conn.setRequestProperty("User-Agent", "Mozilla/5.0"); // 봇 차단 방지

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            String inputLine;
            String ogImage = null;

            while ((inputLine = in.readLine()) != null) {
                // <meta property="og:image" content="..."> 찾기
                if (inputLine.contains("og:image")) {
                    int contentIndex = inputLine.indexOf("content=");
                    if (contentIndex > -1) {
                        // 따옴표 처리 (" 또는 ')
                        char quote = inputLine.charAt(contentIndex + 8);
                        int endQuoteIndex = inputLine.indexOf(quote, contentIndex + 9);
                        if (endQuoteIndex > -1) {
                            ogImage = inputLine.substring(contentIndex + 9, endQuoteIndex);
                            break; // 찾았으면 종료
                        }
                    }
                }
            }
            in.close();
            return ogImage;

        } catch (Exception e) {
            log.warn("썸네일 추출 실패: {}", e.getMessage());
            return null; // 실패 시 null 반환 (기본 이미지 사용 등 처리)
        }
    }

    // --- [사용자용] 메인 화면 노출 및 집계 ---

    /**
     * 랜덤 콘텐츠 1개 조회
     */
    public TeamContentVO getRandomTeamContent(String teamCode) {
        if (teamCode == null || "NONE".equals(teamCode) || teamCode.isEmpty()) {
            teamCode = "ALL";
        }
        return contentMngMapper.selectRandomActiveContent(teamCode);
    }

    @Transactional
    public void increaseClickCount(Long contentId) {
        contentMngMapper.increaseClickCount(contentId);
    }

    // ⭐️ [추가] 사용자 콘텐츠 클릭 시 로그 기록 + 조회수 증가 처리
    @Transactional
    public void logContentClick(Long contentId, MemberVO member) {
        // 1. 조회수 1 증가
        contentMngMapper.increaseClickCount(contentId);

        // 2. 로그 정보 세팅
        ContentClickLogVO logVO = new ContentClickLogVO();
        logVO.setContentId(contentId);

        if (member != null) {
            logVO.setMemberId(member.getMemberId());
            logVO.setGender(member.getGender());

            // 생년월일(YYYY-MM-DD)을 기반으로 연령대(10대, 20대..) 계산
            String ageGroup = "알수없음";
            if (member.getBirthdate() != null) {
                String birthStr = String.valueOf(member.getBirthdate());
                if (birthStr.length() >= 4) {
                    try {
                        int birthYear = Integer.parseInt(birthStr.substring(0, 4));
                        int currentYear = LocalDate.now().getYear();
                        int age = currentYear - birthYear;
                        int group = (age / 10) * 10;
                        ageGroup = group + "대";
                    } catch (Exception e) {
                        log.warn("연령대 계산 실패", e);
                    }
                }
            }
            logVO.setAgeGroup(ageGroup);
        } else {
            // 비회원일 경우
            logVO.setGender("U");
            logVO.setAgeGroup("알수없음");
        }

        // 3. 로그 DB INSERT
        contentMngMapper.insertClickLog(logVO);
    }

}