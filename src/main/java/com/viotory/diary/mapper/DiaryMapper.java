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

    // 직관 횟수, 승리 횟수, 승률 집계 랭킹 10
    List<WinYoAnalysisDTO> selectWinYoRankingTop10();

    // 일기 저장
    int insertDiary(DiaryVO diary);

    // 일기 상세 조회
    DiaryVO selectDiaryById(Long diaryId);

    // 특정 경기에 대한 내 일기 조회 (중복 작성 방지용)
    DiaryVO selectDiaryByMemberAndGame(@Param("memberId") Long memberId, @Param("gameId") Long gameId);

    // 일기 수정
    int updateDiary(DiaryVO diary);

}