package com.viotory.diary.service;

import com.viotory.diary.mapper.LockerMapper;
import com.viotory.diary.vo.LockerVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class LockerService {

    private final LockerMapper lockerMapper;

    // 목록 조회
    public List<LockerVO> getPostList(String category) {
        List<LockerVO> list = lockerMapper.selectPostList(category);
        // 시간 포맷팅 (ex: "방금 전", "1시간 전")
        for (LockerVO vo : list) {
            vo.setTimeAgo(formatTimeAgo(vo.getCreatedAt()));
        }
        return list;
    }

    // 게시글 작성
    @Transactional
    public Long writePost(LockerVO lockerVO) {
        lockerMapper.insertPost(lockerVO);
        return lockerVO.getPostId();
    }

    // 상세 조회 (조회수 증가 포함)
    @Transactional
    public LockerVO getPostDetail(Long postId) {
        lockerMapper.updateViewCount(postId);
        return lockerMapper.selectPostById(postId);
    }

    // [유틸] 시간 계산 (간단 구현)
    private String formatTimeAgo(LocalDateTime dateTime) {
        if (dateTime == null) return "";
        Duration duration = Duration.between(dateTime, LocalDateTime.now());
        long seconds = duration.getSeconds();

        if (seconds < 60) return "방금 전";
        if (seconds < 3600) return (seconds / 60) + "분 전";
        if (seconds < 86400) return (seconds / 3600) + "시간 전";
        return (seconds / 86400) + "일 전";
    }
}