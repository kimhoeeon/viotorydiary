package com.viotory.diary.service;

import com.viotory.diary.dto.StadiumVisitDTO;
import com.viotory.diary.mapper.DiaryMapper;
import com.viotory.diary.mapper.GameMapper;
import com.viotory.diary.mapper.MemberMapper;
import com.viotory.diary.vo.DiaryVO;
import com.viotory.diary.vo.GameVO;
import com.viotory.diary.vo.MemberVO;
import com.viotory.diary.vo.StadiumVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class DiaryService {

    private final DiaryMapper diaryMapper;
    private final GameMapper gameMapper;

    /**
     * 일기 작성
     */
    @Transactional
    public Long writeDiary(DiaryVO diary) throws Exception {
        // 1. 필수값 체크
        if (diary.getGameId() == null) throw new Exception("경기를 선택해주세요.");
        /*if (diary.getOneLineComment() == null || diary.getOneLineComment().isEmpty()) {
            throw new Exception("한줄평을 입력해주세요.");
        }*/

        // 1-1. 중복 작성 체크
        DiaryVO existingDiary = diaryMapper.selectDiaryByMemberAndGame(diary.getMemberId(), diary.getGameId());
        if (existingDiary != null) {
            throw new Exception("이미 이 경기에 대한 일기를 작성하셨습니다.");
        }

        // [추가] 직관 인증 시, 인증 시간 저장
        if (diary.isVerified()) {
            diary.setVerifiedAt(LocalDateTime.now());
        }
        
        // 2. 작성 당시 응원팀 스냅샷 저장
        // (Controller에서 세션의 팀코드를 넣어주겠지만, 한번 더 체크)
        if (diary.getSnapshotTeamCode() == null) {
            throw new Exception("응원팀 정보가 없습니다.");
        }

        // 3. 저장
        diaryMapper.insertDiary(diary);

        return diary.getDiaryId();
    }

    /**
     * 일기 수정
     */
    @Transactional
    public void modifyDiary(DiaryVO diary) throws Exception {
        int result = diaryMapper.updateDiary(diary);
        if (result == 0) {
            throw new Exception("일기 수정에 실패했습니다. (본인 일기가 아니거나 존재하지 않음)");
        }
    }

    /**
     * 일기 상세 조회
     */
    public DiaryVO getDiary(Long diaryId) {
        return diaryMapper.selectDiaryById(diaryId);
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
            // visitedIds에 현재 구장 ID가 포함되어 있는지 확인
            boolean isVisited = visitedIds.contains(Long.valueOf(stadium.getStadiumId()));

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
            throw new Exception("삭제 권한이 없거나 이미 삭제된 일기입니다.");
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

}