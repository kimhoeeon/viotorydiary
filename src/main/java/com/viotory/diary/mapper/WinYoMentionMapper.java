package com.viotory.diary.mapper;

import com.viotory.diary.vo.DiaryVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface WinYoMentionMapper {

    // 2. 조건 코드에 맞는 멘트 조회
    // category: WIN_RATE, ATTENDANCE_COUNT, RECENT_TREND
    String selectMessage(@Param("category") String category, @Param("code") String code);
}