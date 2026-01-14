package com.viotory.diary.mapper;

import com.viotory.diary.vo.AlarmVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface AlarmMapper {
    List<AlarmVO> selectAlarmList(Long memberId);
    int insertAlarm(AlarmVO alarm);
    int updateReadStatus(@Param("alarmId") Long alarmId, @Param("memberId") Long memberId);
    int countUnread(Long memberId);
}