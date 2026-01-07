package com.viotory.diary.mapper;

import com.viotory.diary.vo.DiaryVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface DiaryMapper {

    // 승률 분석용 유효 일기 목록 조회
    List<DiaryVO> selectVerifiedDiaries(Long memberId);

}