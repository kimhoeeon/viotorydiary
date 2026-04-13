package com.viotory.diary.service;

import com.google.firebase.messaging.*;
import com.viotory.diary.dto.CommentDTO;
import com.viotory.diary.exception.AlertException;
import com.viotory.diary.mapper.CommentMapper;
import com.viotory.diary.mapper.DiaryMapper;
import com.viotory.diary.mapper.MemberMapper;
import com.viotory.diary.util.StringUtil;
import com.viotory.diary.vo.AlarmVO;
import com.viotory.diary.vo.DiaryVO;
import com.viotory.diary.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentMapper commentMapper;
    private final DiaryMapper diaryMapper;
    private final MemberMapper memberMapper;
    private final AlarmService alarmService;

    /**
     * 내가 쓴 댓글 목록
     */
    public List<CommentDTO> getMyComments(Long memberId) {
        return commentMapper.selectMyCommentList(memberId);
    }

    /**
     * 댓글 삭제 (작성자 본인 OR 일기 주인)
     */
    @Transactional
    public void deleteComment(Long commentId, Long requestMemberId) throws Exception {
        int deletedCount = commentMapper.deleteComment(commentId, requestMemberId);

        if (deletedCount == 0) {
            throw new AlertException("삭제 권한이 없거나 이미 삭제된 댓글입니다.");
        }
    }

    // 일기별 댓글 조회
    public List<CommentDTO> getCommentsByDiaryId(Long diaryId) {
        return commentMapper.selectCommentListByDiaryId(diaryId);
    }

    // 댓글 작성 시 알림 DB 저장 로직 추가
    @Transactional
    public void writeComment(CommentDTO comment) throws Exception {
        // [금칙어 검사 추가]
        if (StringUtil.containsBannedWord(comment.getContent())) {
            throw new AlertException("댓글에 부적절한 단어가 포함되어 있습니다.");
        }

        // 1. 댓글 저장
        commentMapper.insertComment(comment);

        // 2. 알림 생성 (Firebase 제외, DB에만 저장)
        try {
            DiaryVO diary = diaryMapper.selectDiaryById(comment.getDiaryId());

            // 본인 일기가 아닌 경우에만 알림 생성
            if (diary != null && !diary.getMemberId().equals(comment.getMemberId())) {
                MemberVO commenter = memberMapper.selectMemberById(comment.getMemberId());
                String nickname = (commenter != null) ? commenter.getNickname() : "친구";

                String title = "새로운 댓글";
                String content = nickname + "님이 내 직관일기에 댓글을 남겼습니다.";
                String redirectUrl = "/diary/detail?diaryId=" + diary.getDiaryId();

                alarmService.sendAlarm(diary.getMemberId(), "FRIEND", title, content, redirectUrl);

                // 스마트폰 실제 배너 푸시(FCM) 발송
                MemberVO targetOwner = memberMapper.selectMemberById(diary.getMemberId());
                if (targetOwner != null && "Y".equals(targetOwner.getPushYn())
                        && targetOwner.getFcmToken() != null && !targetOwner.getFcmToken().trim().isEmpty()) {

                    Message fcmMessage = Message.builder()
                            .setToken(targetOwner.getFcmToken())
                            .setNotification(Notification.builder()
                                    .setTitle(title)
                                    .setBody(content)
                                    .build())
                            .putData("link", redirectUrl)
                            // 안드로이드 호환 규격
                            .setAndroidConfig(AndroidConfig.builder()
                                    .setPriority(AndroidConfig.Priority.HIGH)
                                    .setNotification(AndroidNotification.builder()
                                            .setChannelId("default")
                                            .setVisibility(AndroidNotification.Visibility.PUBLIC)
                                            .setSound("default")
                                            .build())
                                    .build())
                            // 아이폰(iOS) 진동/소리 규격
                            .setApnsConfig(ApnsConfig.builder()
                                    .setAps(Aps.builder()
                                            .setSound("default")
                                            .build())
                                    .build())
                            .build();

                    FirebaseMessaging.getInstance().send(fcmMessage);
                    log.info("댓글 푸시 발송 성공 - Target: {}", targetOwner.getMemberId());
                }
            }
        } catch (Exception e) {
            log.error("댓글 알림 발송 중 오류 발생", e);
        }
    }

}