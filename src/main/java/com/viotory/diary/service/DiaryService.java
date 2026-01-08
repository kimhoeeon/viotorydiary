package com.viotory.diary.service;

import com.viotory.diary.mapper.DiaryMapper;
import com.viotory.diary.mapper.GameMapper;
import com.viotory.diary.mapper.MemberMapper;
import com.viotory.diary.vo.DiaryVO;
import com.viotory.diary.vo.GameVO;
import com.viotory.diary.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Slf4j
@Service
@RequiredArgsConstructor
public class DiaryService {

    private final DiaryMapper diaryMapper;
    private final MemberMapper memberMapper; // 회원 정보 조회용
    // GameMapper는 필요하다면 사용 (예: 경기 존재 여부 확인)

    /**
     * 일기 작성
     */
    @Transactional
    public void writeDiary(DiaryVO diary) throws Exception {
        // 1. 회원 정보 조회 (현재 응원팀 확인용)
        MemberVO member = memberMapper.selectMemberById(diary.getMemberId());
        if (member == null) {
            throw new Exception("회원 정보를 찾을 수 없습니다.");
        }

        // 2. 중복 작성 체크
        DiaryVO existDiary = diaryMapper.selectDiaryByMemberAndGame(diary.getMemberId(), diary.getGameId());
        if (existDiary != null) {
            throw new Exception("이미 해당 경기에 대한 일기가 존재합니다.");
        }

        // 3. 스냅샷 데이터 설정 (작성 시점의 응원팀 저장)
        diary.setSnapshotTeamCode(member.getMyTeamCode());

        // 4. 인증 여부 기본값 처리 (직관 인증 로직이 별도로 있다면 거기서 처리)
        if (diary.getIsVerified() == null) {
            diary.setIsVerified(false);
        }
        if (Boolean.TRUE.equals(diary.getIsVerified())) {
            diary.setVerifiedAt(LocalDateTime.now());
        }

        // 5. 저장
        diaryMapper.insertDiary(diary);
        log.info("일기 저장 완료: diaryId={}, memberId={}", diary.getDiaryId(), diary.getMemberId());
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
}