package com.viotory.diary.mapper;

import com.viotory.diary.dto.WinYoAnalysisDTO;
import com.viotory.diary.vo.DiaryVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DiaryMapper {

    // 승률 분석용 유효 일기 목록 조회
    List<DiaryVO> selectVerifiedDiaries(Long memberId);

    // 일기 저장
    int insertDiary(DiaryVO diary);

    // 일기 상세 조회
    DiaryVO selectDiaryById(Long diaryId);

    // 중복 작성 방지용 조회
    DiaryVO selectDiaryByMemberAndGame(@Param("memberId") Long memberId, @Param("gameId") Long gameId);

    // 일기 수정
    int updateDiary(DiaryVO diary);

    // [명예의 전당] 승요 랭킹 TOP 10 조회
    List<WinYoAnalysisDTO> selectWinYoRankingTop10();

    List<DiaryVO> selectRecentDiaries(Long memberId);

    List<DiaryVO> selectDiaryList(Long memberId);

    List<DiaryVO> selectFriendDiaryList(Long memberId);

    List<Long> selectVisitedStadiumIds(Long memberId);

    // 일기 상태 변경 (삭제 등)
    int updateDiaryStatus(@Param("diaryId") Long diaryId,
                          @Param("memberId") Long memberId,
                          @Param("status") String status);

}