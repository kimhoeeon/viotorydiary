package com.viotory.diary.mapper;

import com.viotory.diary.vo.PushLogVO;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface PushMngMapper {
    // 발송 이력 목록 조회
    List<PushLogVO> selectPushLogList();

    // 발송 이력 저장
    void insertPushLog(PushLogVO vo);

    // 전체 회원 수 조회 (발송 대상 수 집계용)
    int countAllMembers();
}