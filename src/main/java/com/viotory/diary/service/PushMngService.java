package com.viotory.diary.service;

import com.viotory.diary.mapper.PushMngMapper;
import com.viotory.diary.vo.PushLogVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class PushMngService {

    private final PushMngMapper pushMngMapper;

    public List<PushLogVO> getPushLogList() {
        return pushMngMapper.selectPushLogList();
    }

    /**
     * 푸시 발송 처리 (현재는 DB 기록 및 Mock 처리)
     */
    @Transactional
    public void sendPush(PushLogVO vo) {
        // 1. 발송 대상 수 계산 (전체 회원)
        int totalMembers = pushMngMapper.countAllMembers();
        vo.setSendCount(totalMembers);

        // 2. 실제 FCM 발송 로직 (추후 구현 예정)
        log.info(">>>> [PUSH SEND] Title: {}, Count: {}", vo.getTitle(), totalMembers);

        // 3. 발송 이력 저장
        pushMngMapper.insertPushLog(vo);
    }
}