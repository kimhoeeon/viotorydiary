package com.viotory.diary.service;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.*;
import com.viotory.diary.mapper.PushMngMapper;
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

    /**
     * Firebase 초기화 (서버 시작 시 1회 실행)
     * resources/firebase-service-account.json 파일이 필요합니다.
     */
    @PostConstruct
    public void init() {
        try {
            if (FirebaseApp.getApps().isEmpty()) {
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
        // 1. 발송 대상 토큰 조회 (전체 회원 중 토큰이 있는 사용자)
        // Mapper에 selectAllFcmTokens 메서드를 추가해야 합니다.
        List<String> tokens = pushMngMapper.selectAllFcmTokens();

        if (tokens == null || tokens.isEmpty()) {
            log.warn("발송 가능한 FCM 토큰이 없습니다.");
            vo.setSendCount(0);
            vo.setStatus("NO_TARGET");
            pushMngMapper.insertPushLog(vo);
            return;
        }

        log.info(">>>> [PUSH START] Title: {}, Target Count: {}", vo.getTitle(), tokens.size());

        // 2. FCM 발송 (최대 500개씩 끊어서 전송 - Firebase 권장사항)
        int successCount = 0;
        int failureCount = 0;

        // 링크 URL 처리 (없으면 메인으로)
        String linkUrl = (vo.getLinkUrl() != null && !vo.getLinkUrl().isEmpty())
                ? vo.getLinkUrl() : "/";

        List<List<String>> batches = partition(tokens, 500);

        for (List<String> batchTokens : batches) {
            try {
                MulticastMessage message = MulticastMessage.builder()
                        .setNotification(Notification.builder()
                                .setTitle(vo.getTitle())
                                .setBody(vo.getContent())
                                .build())
                        // [핵심] Appify 앱이 이 data를 읽어 페이지를 이동시킵니다.
                        .putData("link", linkUrl)
                        .putData("click_action", "FLUTTER_NOTIFICATION_CLICK") // 안드로이드 호환성용
                        .addAllTokens(batchTokens)
                        .build();

                BatchResponse response = FirebaseMessaging.getInstance().sendEachForMulticast(message);
                successCount += response.getSuccessCount();
                failureCount += response.getFailureCount();

            } catch (FirebaseMessagingException e) {
                log.error("FCM Send Error: ", e);
            }
        }

        log.info(">>>> [PUSH END] Success: {}, Fail: {}", successCount, failureCount);

        // 3. 발송 이력 저장
        vo.setSendCount(successCount);
        vo.setStatus("SUCCESS"); // 부분 성공도 성공으로 간주
        pushMngMapper.insertPushLog(vo);
    }

    // 리스트 분할 유틸 메서드
    private <T> List<List<T>> partition(List<T> list, int size) {
        List<List<T>> parts = new ArrayList<>();
        final int N = list.size();
        for (int i = 0; i < N; i += size) {
            parts.add(new ArrayList<>(list.subList(i, Math.min(N, i + size))));
        }
        return parts;
    }
}