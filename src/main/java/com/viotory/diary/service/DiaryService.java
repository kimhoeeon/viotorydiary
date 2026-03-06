package com.viotory.diary.service;

import com.viotory.diary.dto.StadiumVisitDTO;
import com.viotory.diary.exception.AlertException;
import com.viotory.diary.mapper.DiaryMapper;
import com.viotory.diary.mapper.GameMapper;
import com.viotory.diary.mapper.MemberMapper;
import com.viotory.diary.mapper.PredictionMapper;
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
        // 1. 필수값 체크
        if (diary.getGameId() == null) throw new AlertException("경기를 선택해주세요.");

        // 1-1. 중복 작성 체크 (동일 경기)
        DiaryVO existingDiary = diaryMapper.selectDiaryByMemberAndGame(diary.getMemberId(), diary.getGameId());
        if (existingDiary != null) {
            throw new AlertException("이미 이 경기에 대한 일기를 작성하셨습니다.");
        }

        // 1-2. 하루 최대 1개 작성 제한 체크
        // 방금 선택한 경기의 날짜 정보를 가져옵니다.
        GameVO targetGame = gameMapper.selectGameById(diary.getGameId());
        if (targetGame != null && targetGame.getGameDate() != null) {
            int dailyCount = diaryMapper.countDiaryByDate(diary.getMemberId(), targetGame.getGameDate());
            if (dailyCount >= 1) { // 1개 이상이면 차단
                throw new AlertException("직관 일기는 하루에 1개 경기만 작성할 수 있어요!");
            }
        }

        // 직관 인증 시, 인증 시간 저장
        if (diary.isVerified()) {
            diary.setVerifiedAt(LocalDateTime.now());
        }
        
        // 2. 작성 당시 응원팀 스냅샷 저장
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

                    if (LocalDateTime.now().isAfter(gameStart.plusHours(1))) {
                        return; // 시작 후 1시간 초과 시 튕겨냄
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
     * 일기 상세 조회
     */
    public DiaryVO getDiary(Long diaryId) {
        return diaryMapper.selectDiaryById(diaryId);
    }

    // 조회수 증가 처리
    @Transactional
    public void increaseViewCount(Long diaryId) {
        diaryMapper.updateViewCount(diaryId);
    }

    public List<DiaryVO> getRecentDiaries(Long memberId) {
        return diaryMapper.selectRecentDiaries(memberId);
    }

    public List<DiaryVO> getMyDiaryList(Long memberId) {
        return diaryMapper.selectDiaryList(memberId);
    }

    // 친구 일기 조회
    public List<DiaryVO> getFriendDiaryList(Long memberId) {
        return diaryMapper.selectFriendDiaryList(memberId);
    }

    // 방문 구장 현황 (총 9개 구장 기준 방문 여부 boolean 리스트 반환)
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
    public DiaryVO getSharedDiary(String uuid) {
        return diaryMapper.selectDiaryByUuid(uuid);
    }

    public int countTotalDiaries() {
        return diaryMapper.countTotalDiaries();
    }

    public int countTodayDiaries() {
        return diaryMapper.countTodayDiaries();
    }

    // 피드 목록 조회 (탭 분기)
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
    public List<DiaryVO> getMemberPublicDiaries(Long targetMemberId) {
        return diaryMapper.selectMemberPublicDiaries(targetMemberId);
    }

    // 특정 경기와 멤버의 직관일기 단건 조회 (작성 여부 체크용)
    public DiaryVO getDiaryByMemberAndGame(Long memberId, Long gameId) {
        return diaryMapper.selectDiaryByMemberAndGame(memberId, gameId);
    }

    //화면 진입 단계에서 하루 1개 제한 체크
    public int countDiaryByDate(Long memberId, String gameDate) {
        return diaryMapper.countDiaryByDate(memberId, gameDate);
    }

}