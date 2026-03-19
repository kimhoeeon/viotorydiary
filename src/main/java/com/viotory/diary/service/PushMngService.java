package com.viotory.diary.service;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.*;
import com.viotory.diary.mapper.AlarmMapper;
import com.viotory.diary.mapper.PushMngMapper;
import com.viotory.diary.vo.AlarmVO;
import com.viotory.diary.vo.PushLogVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class PushMngService {

    private final PushMngMapper pushMngMapper;
    private final AlarmMapper alarmMapper;

    /**
     * Firebase 초기화 (서버 시작 시 1회 실행)
     * resources/firebase-service-account.json 파일이 필요합니다.
     */
    @PostConstruct
    public void init() {
        try {
            if (FirebaseApp.getApps().isEmpty()) {
                // TODO: 적용예정
                // 프로젝트 설정 > 서비스 계정 에서 다운로드 받은 비공개 키 파일
                ClassPathResource resource = new ClassPathResource("firebase-service-account.json");

                FirebaseOptions options = FirebaseOptions.builder()
                        .setCredentials(GoogleCredentials.fromStream(resource.getInputStream()))
                        .build();
                FirebaseApp.initializeApp(options);
                log.info("🔥 Firebase Admin SDK Initialized Successfully");
            }
        } catch (IOException e) {
            log.error("❌ Firebase Init Failed: {}", e.getMessage());
        }
    }

    public List<PushLogVO> getPushLogList() {
        return pushMngMapper.selectPushLogList();
    }

    /**
     * 푸시 발송 및 결과 저장
     */
    @Transactional
    public void sendPush(PushLogVO vo) {
        if ("TEAM".equals(vo.getTargetType())) {
            vo.setTargetUser(vo.getTargetTeam() + " 팬");
        } else if ("INACTIVE".equals(vo.getTargetType())) {
            vo.setTargetUser("7일 이상 미접속자");
        } else {
            vo.setTargetUser("전체 회원");
        }

        // 1. 타겟 유저(ID) 조회
        List<Long> targetMemberIds = pushMngMapper.selectTargetMemberIds(vo.getTargetType(), vo.getTargetTeam());

        if (targetMemberIds == null || targetMemberIds.isEmpty()) {
            log.warn("발송 가능한 대상이 없습니다. Target: {}", vo.getTargetUser());
            vo.setSendCount(0);
            vo.setStatus("NO_TARGET");
            pushMngMapper.insertPushLog(vo);
            return;
        }

        log.info(">>>> [ALARM/PUSH START] Title: {}, Target Count: {}", vo.getTitle(), targetMemberIds.size());

        String linkUrl = (vo.getLinkUrl() != null && !vo.getLinkUrl().isEmpty()) ? vo.getLinkUrl() : "/";

        // 2. 웹사이트 DB(알림 리스트)에 저장
        for (Long memberId : targetMemberIds) {
            AlarmVO alarm = new AlarmVO();
            alarm.setMemberId(memberId);
            alarm.setCategory("SYSTEM"); // VO 변수명 맞춤
            alarm.setTitle(vo.getTitle()); // 방금 추가한 Title
            alarm.setContent(vo.getContent());
            alarm.setRedirectUrl(linkUrl); // VO 변수명 맞춤
            alarmMapper.insertAlarm(alarm);
        }

        // 3. 기기 푸시(FCM) 발송 로직 (추후 Key 발급 시 즉시 동작)
        List<String> tokens = pushMngMapper.selectTargetFcmTokens(vo.getTargetType(), vo.getTargetTeam());
        int successCount = 0;
        int failureCount = 0;

        if (tokens != null && !tokens.isEmpty()) {
            List<List<String>> batches = partition(tokens, 500);

            for (List<String> batchTokens : batches) {
                try {
                    MulticastMessage message = MulticastMessage.builder()
                            .setNotification(Notification.builder()
                                    .setTitle(vo.getTitle())
                                    .setBody(vo.getContent())
                                    .build())
                            .putData("link", linkUrl)
                            .putData("click_action", "FLUTTER_NOTIFICATION_CLICK")
                            .addAllTokens(batchTokens)
                            .build();

                    BatchResponse response = FirebaseMessaging.getInstance().sendEachForMulticast(message);
                    successCount += response.getSuccessCount();
                    failureCount += response.getFailureCount();

                } catch (FirebaseMessagingException e) {
                    log.error("FCM Send Error: ", e);
                }
            }
        }

        log.info(">>>> [ALARM/PUSH END] DB 알림: {}건, FCM Success: {}, Fail: {}", targetMemberIds.size(), successCount, failureCount);

        // 4. 발송 로그 저장
        vo.setSendCount(targetMemberIds.size());
        vo.setStatus("SUCCESS");
        pushMngMapper.insertPushLog(vo);
    }

    private <T> List<List<T>> partition(List<T> list, int size) {
        List<List<T>> partitions = new ArrayList<>();
        for (int i = 0; i < list.size(); i += size) {
            partitions.add(new ArrayList<>(list.subList(i, Math.min(i + size, list.size()))));
        }
        return partitions;
    }

}