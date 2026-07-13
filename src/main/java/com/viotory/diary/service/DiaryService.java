package com.viotory.diary.service;

import com.viotory.diary.dto.StadiumVisitDTO;
import com.viotory.diary.dto.WinYoAnalysisDTO;
import com.viotory.diary.exception.AlertException;
import com.viotory.diary.mapper.DiaryMapper;
import com.viotory.diary.mapper.GameMapper;
import com.viotory.diary.mapper.MemberMapper;
import com.viotory.diary.mapper.PredictionMapper;
import com.viotory.diary.util.StringUtil;
import com.viotory.diary.vo.DiaryVO;
import com.viotory.diary.vo.GameVO;
import com.viotory.diary.vo.MemberVO;
import com.viotory.diary.vo.StadiumVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class DiaryService {

    private final DiaryMapper diaryMapper;
    private final GameMapper gameMapper;
    private final PredictionMapper predictionMapper;

    /**
     * 일기 작성
     */
    @Transactional
    public Long writeDiary(DiaryVO diary) throws Exception {
        // [금칙어 검사 추가]
        if (StringUtil.containsBannedWord(diary.getHeroName()) ||
                StringUtil.containsBannedWord(diary.getOneLineComment()) ||
                StringUtil.containsBannedWord(diary.getContent())) {
            throw new AlertException("내용에 부적절한 단어가 포함되어 있습니다.");
        }

        // 1. 필수값 체크
        if (diary.getGameId() == null) throw new AlertException("경기를 선택해주세요.");

        // 1-1. 중복 작성 체크 (동일 경기)
        DiaryVO existingDiary = diaryMapper.selectDiaryByMemberAndGame(diary.getMemberId(), diary.getGameId());
        if (existingDiary != null) {
            throw new AlertException("이미 이 경기에 대한 일기를 작성하셨습니다.");
        }

        // 일기 저장 직전, attendance 테이블을 뒤져서 인증 이력이 있으면 자동으로 맵핑
        int isAttended = diaryMapper.checkAttendance(diary.getMemberId(), diary.getGameId());
        if (isAttended > 0) {
            diary.setVerified(true);
            diary.setVerifiedAt(LocalDateTime.now()); // 또는 DB의 verified_at 가져오기
        } else {
            diary.setVerified(false);
        }

        if (diary.getSnapshotTeamCode() == null) {
            throw new AlertException("응원팀 정보가 없습니다.");
        }

        // 3. 저장
        diaryMapper.insertDiary(diary);

        // 일기 작성 시 입력한 스코어를 predictions 테이블에 자동 연동
        syncPredictionByScore(diary);

        return diary.getDiaryId();
    }

    /**
     * 일기 수정
     */
    @Transactional
    public void modifyDiary(DiaryVO diary) throws Exception {
        // [금칙어 검사 추가]
        if (StringUtil.containsBannedWord(diary.getHeroName()) ||
                StringUtil.containsBannedWord(diary.getOneLineComment()) ||
                StringUtil.containsBannedWord(diary.getContent())) {
            throw new AlertException("내용에 부적절한 단어가 포함되어 있습니다.");
        }

        int result = diaryMapper.updateDiary(diary);
        if (result == 0) {
            throw new AlertException("일기 수정에 실패했습니다. (본인 일기가 아니거나 존재하지 않음)");
        }

        // 일기 수정 시 스코어가 변경되었을 수 있으므로 연동 업데이트
        syncPredictionByScore(diary);
    }

    // 스코어 기반 승부 예측 동기화 메서드
    private void syncPredictionByScore(DiaryVO diary) {
        // 스코어 예측을 입력한 경우에만 실행
        if (diary.getPredScoreHome() != null && diary.getPredScoreAway() != null) {

            // 경기 정보 조회 (홈/어웨이 팀 코드를 알아내기 위함)
            GameVO game = gameMapper.selectGameById(diary.getGameId());

            if (game != null) {
                // 정책 1: 경기 종료/취소 상태면 승률 미반영
                if ("FINISHED".equals(game.getStatus()) || "CANCELLED".equals(game.getStatus())) {
                    return;
                }

                // 정책 2: 경기 시작 후 1시간을 초과했다면 승률(예측 데이터) 반영 안함
                try {
                    String timeStr = game.getGameTime();
                    if (timeStr != null && timeStr.length() == 5) timeStr += ":00";
                    String dateTimeStr = game.getGameDate() + " " + timeStr;
                    LocalDateTime gameStart = LocalDateTime.parse(dateTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

                    if (LocalDateTime.now().isAfter(gameStart.minusHours(1))) {
                        return; // 경기 시작 1시간 전이 지났으면 승률 데이터 반영 안함
                    }
                } catch (Exception e) {
                    log.error("승부 예측 연동 중 경기 시작시간 파싱 오류", e);
                }

                // 정책 3: 직관 위치 인증 시에만 승률 반영
                boolean isVerified = false;
                // 최초 작성 혹은 화면에서 넘어온 인증 데이터 확인
                if (diary.getVerifiedAt() != null || diary.isVerified()) {
                    isVerified = true;
                } else if (diary.getDiaryId() != null) {
                    // 수정을 통해 진입한 경우 기존 DB 일기의 인증 여부 체크
                    DiaryVO org = diaryMapper.selectDiaryById(diary.getDiaryId());
                    if (org != null && org.getVerifiedAt() != null) {
                        isVerified = true;
                    }
                }

                if (!isVerified) {
                    return; // 직관 인증되지 않았으면 승률 미반영 (저장 안함)
                }

                // --- 검문소(정책 1,2,3) 모두 통과! 이제 팀 코드 도출 후 저장 ---
                String predictedTeam = null;

                // 스코어 비교를 통해 승리 예상 팀 도출
                if (diary.getPredScoreHome() > diary.getPredScoreAway()) {
                    predictedTeam = game.getHomeTeamCode();
                } else if (diary.getPredScoreAway() > diary.getPredScoreHome()) {
                    predictedTeam = game.getAwayTeamCode();
                }

                // 승패가 갈렸을 경우에만 predictions 테이블에 등록 (무승부는 처리 제외)
                if (predictedTeam != null) {
                    predictionMapper.savePrediction(diary.getMemberId(), diary.getGameId(), predictedTeam);
                }
            }
        }
    }

    /**
     * 일기 상세 조회 (동행인 및 태그된 친구 리스트 매핑 로직 누락분 복구)
     */
    @Transactional(readOnly = true)
    public DiaryVO getDiary(Long diaryId) {
        DiaryVO diary = diaryMapper.selectDiaryById(diaryId);

        if (diary != null) {
            // [태그된 친구 로직] 문자열로 저장된 ID(ex: "10, 15, 23")를 파싱하여 MemberVO 객체 리스트로 매핑
            String taggedStrs = diary.getTaggedMembers();
            if (taggedStrs != null && !taggedStrs.trim().isEmpty()) {
                String[] idsArray = taggedStrs.split(",");
                List<Long> idsList = new ArrayList<>();
                for (String idStr : idsArray) {
                    try {
                        idsList.add(Long.parseLong(idStr.trim()));
                    } catch (NumberFormatException e) {
                        log.error("태그된 친구 ID 파싱 오류 - ID: {}", idStr);
                    }
                }

                // 파싱된 ID가 존재하면 DB에서 멤버 정보를 조회하여 세팅
                if (!idsList.isEmpty()) {
                    List<MemberVO> taggedFriends = diaryMapper.selectTaggedMembers(idsList);
                    diary.setTaggedMemberList(taggedFriends);
                }
            }
        }
        return diary;
    }

    // 조회수 증가 처리
    @Transactional
    public void increaseViewCount(Long diaryId) {
        diaryMapper.updateViewCount(diaryId);
    }

    @Transactional(readOnly = true)
    public List<DiaryVO> getRecentDiaries(Long memberId) {
        return diaryMapper.selectRecentDiaries(memberId);
    }

    @Transactional(readOnly = true)
    public List<DiaryVO> getMyDiaryList(Long memberId) {
        return diaryMapper.selectDiaryList(memberId);
    }

    // 친구 일기 조회
    @Transactional(readOnly = true)
    public List<DiaryVO> getFriendDiaryList(Long memberId) {
        return diaryMapper.selectFriendDiaryList(memberId);
    }

    // 방문 구장 현황 (총 9개 구장 기준 방문 여부 boolean 리스트 반환)
    @Transactional(readOnly = true)
    public List<StadiumVisitDTO> getStadiumVisitStatus(Long memberId) {
        // 1. 내가 방문한(인증된) 구장 ID 목록 조회
        List<Long> visitedIds = diaryMapper.selectVisitedStadiumIds(memberId);

        // 2. 전체 구장 목록 조회 (DB에서 가져옴)
        List<StadiumVO> allStadiums = gameMapper.selectAllStadiums();

        List<StadiumVisitDTO> statusList = new ArrayList<>();

        // 3. 전체 구장을 순회하며 방문 여부 체크 및 DTO 생성
        for (StadiumVO stadium : allStadiums) {
            boolean isVisited = false;

            if (visitedIds != null) {
                for (Object vId : visitedIds) {
                    if (vId != null && String.valueOf(vId).equals(String.valueOf(stadium.getStadiumId()))) {
                        isVisited = true;
                        break;
                    }
                }
            }

            statusList.add(new StadiumVisitDTO(
                    stadium.getStadiumId(),
                    stadium.getName(),
                    isVisited
            ));
        }

        return statusList;
    }

    // 방문한 구장 개수
    @Transactional(readOnly = true)
    public int getVisitedStadiumCount(Long memberId) {
        return diaryMapper.selectVisitedStadiumIds(memberId).size();
    }

    /**
     * 일기 삭제 (Soft Delete)
     */
    @Transactional
    public void deleteDiary(Long diaryId, Long memberId) throws Exception {
        // 상태를 'DELETED'로 변경
        int result = diaryMapper.updateDiaryStatus(diaryId, memberId, "DELETED");

        if (result == 0) {
            throw new AlertException("삭제 권한이 없거나 이미 삭제된 일기입니다.");
        }

        log.info("일기 삭제 완료: diaryId={}, memberId={}", diaryId, memberId);
    }

    // 친구 일기 전체 조회
    @Transactional(readOnly = true)
    public List<DiaryVO> getAllFriendDiaries(Long memberId) {
        return diaryMapper.selectAllFriendDiaries(memberId);
    }

    // 공유 링크 생성 (UUID 발급)
    @Transactional
    public String generateShareLink(Long diaryId) {
        DiaryVO diary = diaryMapper.selectDiaryById(diaryId);
        if (diary == null) throw new IllegalArgumentException("일기가 존재하지 않습니다.");

        // 이미 UUID가 있다면 기존 값 반환
        if (diary.getShareUuid() != null && !diary.getShareUuid().isEmpty()) {
            return diary.getShareUuid();
        }

        // 없으면 새로 생성 후 저장
        String uuid = UUID.randomUUID().toString().replace("-", ""); // 깔끔하게 하이픈 제거
        diaryMapper.updateShareUuid(diaryId, uuid);
        return uuid;
    }

    // 공유 일기 조회 (UUID 기반)
    @Transactional(readOnly = true)
    public DiaryVO getSharedDiary(String uuid) {
        return diaryMapper.selectDiaryByUuid(uuid);
    }

    @Transactional(readOnly = true)
    public int countTotalDiaries() {
        return diaryMapper.countTotalDiaries();
    }

    @Transactional(readOnly = true)
    public int countTodayDiaries() {
        return diaryMapper.countTodayDiaries();
    }

    // 피드 목록 조회 (탭 분기)
    @Transactional(readOnly = true)
    public List<DiaryVO> getFeedDiaries(Long memberId, String tab) {
        if ("follower".equals(tab)) {
            // 나를 팔로우하는 사람들의 일기
            return diaryMapper.selectFollowerDiaries(memberId);
        } else if ("all".equals(tab)) {
            // 전체 탭: 기존 '전체 공개 일기' -> '나와 관계된(팔로워+팔로잉) 사람의 일기'로 변경
            return diaryMapper.selectRelatedDiaries(memberId);
        } else {
            // 기본(following): 내가 팔로잉하는 사람들의 일기
            return diaryMapper.selectAllFriendDiaries(memberId);
        }
    }

    // 특정 멤버의 공개 일기 조회
    @Transactional(readOnly = true)
    public List<DiaryVO> getMemberPublicDiaries(Long targetMemberId) {
        return diaryMapper.selectMemberPublicDiaries(targetMemberId);
    }

    // 특정 경기와 멤버의 직관일기 단건 조회 (작성 여부 체크용)
    @Transactional(readOnly = true)
    public DiaryVO getDiaryByMemberAndGame(Long memberId, Long gameId) {
        return diaryMapper.selectDiaryByMemberAndGame(memberId, gameId);
    }

    //화면 진입 단계에서 하루 1개 제한 체크
    @Transactional(readOnly = true)
    public int countDiaryByDate(Long memberId, String gameDate) {
        return diaryMapper.countDiaryByDate(memberId, gameDate);
    }

    /**
     * 메인 화면용 친구/인기 일기 노출 로직 (PPT 요구사항 반영)
     * - 친구(팔로우/팔로워)가 0명이면 인기 게시물 노출 (부족하면 랜덤 채움)
     * - 친구가 1명이라도 있으면 기존 방식대로 친구들의 일기 노출
     */
    public List<DiaryVO> getRecommendedFriendDiaries(Long memberId) {
        // 1. 친구(팔로우+팔로워) 수 확인
        int friendCount = diaryMapper.countFollowAndFollower(memberId);

        if (friendCount == 0) {
            // [Case A] 친구가 없는 경우: 인기 게시물 우선 조회 (최대 4개)
            List<DiaryVO> recommendedList = new ArrayList<>(diaryMapper.selectPopularDiaries(4));

            // 인기 게시물이 4개 미만이면, 부족한 개수만큼 랜덤 게시물로 채움
            if (recommendedList.size() < 4) {
                int remain = 4 - recommendedList.size();
                recommendedList.addAll(diaryMapper.selectRandomPublicDiaries(remain));
            }
            return recommendedList;

        } else {
            // [Case B] 친구가 있는 경우: 기존 로직(친구가 쓴 일기) 그대로 호출
            return diaryMapper.selectFriendDiaryList(memberId);
        }
    }

    /**
     * 내 승요력 랭킹 조회 (필터 추가)
     */
    @Transactional(readOnly = true)
    public WinYoAnalysisDTO getMyWinYoRanking(Long memberId, String season, String teamCode) {
        return diaryMapper.selectMyWinYoRanking(memberId, season, teamCode);
    }

    /**
     * 전체 승요력 TOP 100 랭킹 조회 (필터 추가)
     */
    @Transactional(readOnly = true)
    public List<WinYoAnalysisDTO> getWinYoRankingTop100(String season, String teamCode) {
        return diaryMapper.selectWinYoRankingTop100(season, teamCode);
    }

    @Transactional(readOnly = true)
    public int getFriendCount(Long memberId) {
        return diaryMapper.countFollowAndFollower(memberId);
    }

    /**
     * 인기 게시물 조회 (HOT 직관 일기)
     * 관리자가 명시적으로 설정한 인기글을 우선으로 가져오고, 4개가 안 될 경우 일반 전체공개글 중 무작위로 부족분을 채웁니다.
     */
    @Transactional(readOnly = true)
    public List<DiaryVO> getPopularDiaries() {
        // 1. 관리자 지정 인기 게시물 (최대 4개)
        List<DiaryVO> popularList = diaryMapper.selectPopularDiaries(4);

        // 2. 4개가 부족할 경우 무작위로 부족분 채우기
        if (popularList.size() < 4) {
            int needed = 4 - popularList.size();
            List<DiaryVO> randomList = diaryMapper.selectRandomPublicDiaries(needed);
            popularList.addAll(randomList);
        }
        return popularList;
    }

    /**
     * 달력: 특정 날짜 및 팀 필터링 기반 일기 목록 조회 (페이징 포함)
     */
    @Transactional(readOnly = true)
    public List<DiaryVO> getDiariesByDate(String date, String teamCode, int page, int limit) {
        int offset = (page - 1) * limit;
        return diaryMapper.selectDiariesByDateAndTeam(date, teamCode, limit, offset);
    }

    /**
     * 오버로딩: 페이지 파라미터가 없을 경우 기본 1페이지로 조회
     */
    @Transactional(readOnly = true)
    public List<DiaryVO> getDiariesByDate(String date, String teamCode) {
        return getDiariesByDate(date, teamCode, 1, 5); // 기본값 5개
    }

    /**
     * 달력: 특정 월(YYYY-MM)에 일기가 작성된 날짜 리스트 조회 (달력 도트 표시용)
     */
    @Transactional(readOnly = true)
    public List<String> getDiaryDatesByMonth(String month) {
        return diaryMapper.selectDiaryDatesByMonth(month);
    }

    @Transactional(readOnly = true)
    public List<MemberVO> getMyFriendsForTag(Long memberId) {
        return diaryMapper.selectMyFriendsForTag(memberId);
    }

    /**
     * 사용자의 총 완료 일기 수 조회 (앱 리뷰 팝업 조건용)
     */
    @Transactional(readOnly = true)
    public int getMyDiaryCount(Long memberId) {
        return diaryMapper.countMyDiaries(memberId);
    }

    // 직관 인증 내역을 독립 테이블에 저장
    @Transactional
    public void saveAttendance(Long memberId, Long gameId) {
        diaryMapper.insertAttendance(memberId, gameId);
    }

    /**
     * 특정 유저의 특정 경기 직관 인증 여부 확인
     */
    @Transactional(readOnly = true)
    public boolean checkAttendance(Long memberId, Long gameId) {
        return diaryMapper.checkAttendance(memberId, gameId) > 0;
    }
}