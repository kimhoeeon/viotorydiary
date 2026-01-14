package com.viotory.diary.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class LockerVO {
    private Long postId;
    private Long memberId;
    private String category;    // TALK, MEETUP, MARKET
    private String title;
    private String content;
    private String imageUrl;
    private int viewCount;
    private int commentCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // [화면 표시용 JOIN 데이터]
    private String nickname;        // 작성자 닉네임
    private String teamCode;        // 작성자 응원팀
    private String memberImage;     // 작성자 프로필 사진 (필요 시)

    // [화면용 유틸]
    private String timeAgo;         // "1시간 전", "방금 전" 등 표시용
}