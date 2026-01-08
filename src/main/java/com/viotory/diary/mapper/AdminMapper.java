package com.viotory.diary.mapper;

import com.viotory.diary.vo.AdminVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AdminMapper {

    // ID로 관리자 정보 조회
    AdminVO selectAdminByLoginId(String loginId);

    // 로그인 성공 시 마지막 접속일 업데이트
    void updateLastLogin(Long adminId);
}