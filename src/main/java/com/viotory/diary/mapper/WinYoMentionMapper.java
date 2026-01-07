package com.viotory.diary.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface WinYoMentionMapper {

    // 멘트 조회
    String selectMessage(@Param("category") String category,
                         @Param("conditionCode") String conditionCode);

}