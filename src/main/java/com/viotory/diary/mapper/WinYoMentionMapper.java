package com.viotory.diary.mapper;

import com.viotory.diary.vo.WinYoMentionVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface WinYoMentionMapper {

    // [서비스용] 멘트 조회 (우선순위 반영)
    String selectMessage(@Param("category") String category, @Param("code") String code);

    // [관리자용] 목록 조회
    List<WinYoMentionVO> selectMentionList(@Param("category") String category);

    // [관리자용] 단건 조회
    WinYoMentionVO selectMentionById(Long mentionId);

    // [관리자용] 등록
    void insertMention(WinYoMentionVO vo);

    // [관리자용] 수정
    void updateMention(WinYoMentionVO vo);

    // [관리자용] 삭제
    void deleteMention(Long mentionId);

}