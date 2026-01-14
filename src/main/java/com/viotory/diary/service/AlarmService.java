package com.viotory.diary.service;

import com.viotory.diary.mapper.AlarmMapper;
import com.viotory.diary.vo.AlarmVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AlarmService {

    private final AlarmMapper alarmMapper;

    // 목록 조회
    public List<AlarmVO> getMyAlarms(Long memberId) {
        return alarmMapper.selectAlarmList(memberId);
    }

    // 알림 발송 (다른 서비스에서 호출 가능)
    @Transactional
    public void sendAlarm(Long memberId, String category, String content, String url) {
        AlarmVO alarm = new AlarmVO();
        alarm.setMemberId(memberId);
        alarm.setCategory(category);
        alarm.setContent(content);
        alarm.setRedirectUrl(url);
        alarmMapper.insertAlarm(alarm);
    }

    // 읽음 처리
    @Transactional
    public void readAlarm(Long alarmId, Long memberId) {
        alarmMapper.updateReadStatus(alarmId, memberId);
    }

    // 안 읽은 알림 수
    public int getUnreadCount(Long memberId) {
        return alarmMapper.countUnread(memberId);
    }
}