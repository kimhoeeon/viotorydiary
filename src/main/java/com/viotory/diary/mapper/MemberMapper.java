package com.viotory.diary.mapper;

import com.viotory.diary.vo.MemberVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberMapper {

    // 1. 회원 가입 (Insert)
    int insertMember(MemberVO member);

    // 2. ID 중복 체크 / 로그인 정보 조회
    MemberVO selectMemberByEmail(String email);

    // 3. 닉네임 중복 체크
    int countByNickname(String nickname);

    // 4. 회원 정보 상세 조회
    MemberVO selectMemberById(Long memberId);

    // 5. 로그인 성공 시 접속일 업데이트
    void updateLastLogin(Long memberId);

}