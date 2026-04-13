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
                // 발급받은 실제 Firebase 키 파일명으로 매핑 (src/main/resources 하위)
                ClassPathResource resource = new ClassPathResource("myseungyo-firebase-adminsdk-fbsvc-c5a1173f10.json");

                FirebaseOptions options = FirebaseOptions.builder()
                        .setCredentials(GoogleCredentials.fromStream(resource.getInputStream()))
                        .build();
                FirebaseApp.initializeApp(options);
                log.info("🔥 Firebase Admin SDK Initialized Successfully");
            }
        } catch (IOException e) {
            log.error("❌ Firebase Init Failed: 키 파일 위치 및 이름을 확인해주세요. 에러 = {}", e.getMessage());
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
            alarm.setCategory("SYSTEM");
            alarm.setTitle(vo.getTitle());
            alarm.setContent(vo.getContent());
            alarm.setRedirectUrl(linkUrl);
            alarmMapper.insertAlarm(alarm);
        }

        // 3. 기기 푸시(FCM) 발송 로직 (추후 Key 발급 시 즉시 동작)
        List<String> tokens = pushMngMapper.selectTargetFcmTokens(vo.getTargetType(), vo.getTargetTeam());
        int successCount = 0;
        int failureCount = 0;
        String pushStatus = "SUCCESS";

        if (tokens != null && !tokens.isEmpty()) {
            // [핵심 방어 로직] 서버에 JSON 키 파일이 없어서 Firebase가 초기화되지 않았을 때 404/500 에러로 뻗는 것을 원천 차단
            if (FirebaseApp.getApps().isEmpty()) {
                log.error("❌ FCM 발송 실패: Firebase가 초기화되지 않았습니다. (키 파일 서버 업로드 누락 확인)");
                pushStatus = "FAIL(NO_KEY)";
            } else {
                List<List<String>> batches = partition(tokens, 500);

                for (List<String> batchTokens : batches) {
                    try {
                        MulticastMessage message = MulticastMessage.builder()
                                // 1. 공통 알림 내용 (iOS/Android 공통 배너 텍스트)
                                .setNotification(Notification.builder()
                                        .setTitle(vo.getTitle())
                                        .setBody(vo.getContent())
                                        .build())
                                // 2. 딥링크 데이터 (Appify 규격에 맞춘 화면 이동 URL)
                                .putData("link", linkUrl)

                                // 3. 안드로이드(Android) 전용 설정 (Appify 필수 규격)
                                .setAndroidConfig(AndroidConfig.builder()
                                        .setPriority(AndroidConfig.Priority.HIGH)
                                        .setNotification(AndroidNotification.builder()
                                                .setChannelId("default")
                                                .setVisibility(AndroidNotification.Visibility.PUBLIC)
                                                .build())
                                        .build())

                                // 4. 아이폰(iOS) 전용 설정 (진동/소리 강제 활성화)
                                .setApnsConfig(ApnsConfig.builder()
                                        .setAps(Aps.builder()
                                                .setSound("default") // 아이폰에서 무음으로 오지 않도록 설정
                                                .build())
                                        .build())

                                .addAllTokens(batchTokens)
                                .build();

                        BatchResponse response = FirebaseMessaging.getInstance().sendEachForMulticast(message);
                        successCount += response.getSuccessCount();
                        failureCount += response.getFailureCount();

                    } catch (Exception e) {
                        // 좁은 예외가 아닌 Exception 전체를 잡아 어떤 경우에도 웹사이트가 뻗지 않도록 처리
                        log.error("FCM Send Error: ", e);
                        pushStatus = "FAIL(ERROR)";
                    }
                }
            }
        }

        log.info(">>>> [ALARM/PUSH END] DB 알림: {}건, FCM Success: {}, Fail: {}", targetMemberIds.size(), successCount, failureCount);

        // 4. 발송 로그 저장
        vo.setSendCount(targetMemberIds.size());
        vo.setStatus(pushStatus);
        pushMngMapper.insertPushLog(vo);
    }

    // 리스트를 지정된 사이즈(500건)로 분할하는 유틸 메서드
    private <T> List<List<T>> partition(List<T> list, int size) {
        List<List<T>> partitions = new ArrayList<>();
        for (int i = 0; i < list.size(); i += size) {
            partitions.add(new ArrayList<>(list.subList(i, Math.min(i + size, list.size()))));
        }
        return partitions;
    }

}