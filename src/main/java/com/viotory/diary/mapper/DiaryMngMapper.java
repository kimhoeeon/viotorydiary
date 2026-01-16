package com.viotory.diary.mapper;

import com.viotory.diary.vo.Criteria;
import com.viotory.diary.vo.DiaryVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface DiaryMngMapper {

    // 일기 목록 조회 (페이징 + 검색)
    // 검색 조건: 작성자 닉네임, 내용
    List<DiaryVO> selectDiaryList(Criteria cri);

    // 전체 개수 (페이징용)
    int getTotalCount(Criteria cri);

    // 일기 상세 조회
    DiaryVO selectDiaryById(Long diaryId);

    // 일기 삭제 (관리자 권한으로 상태 변경 -> DELETED)
    void deleteDiary(Long diaryId);
}