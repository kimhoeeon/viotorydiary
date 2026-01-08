package com.viotory.diary.mapper;

import com.viotory.diary.vo.MemberVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MemberMapper {

    // 1. 회원 가입 (Insert)
    int insertMember(MemberVO member);

    // 2. ID(Email) 중복 체크 및 로그인 정보 조회
    MemberVO selectMemberByEmail(String email);

    // 3. 닉네임 중복 체크
    int countByNickname(String nickname);

    // 4. 회원 정보 상세 조회 (PK 기준)
    MemberVO selectMemberById(Long memberId);

    // 5. 로그인 성공 시 최근 접속일 업데이트
    void updateLastLogin(Long memberId);

    // 6. 회원 정보 수정 (닉네임, 연락처, 생년월일, 성별 등)
    int updateMemberInfo(MemberVO member);

    // 7. 비밀번호 변경
    int updatePassword(@Param("memberId") Long memberId, @Param("newPassword") String newPassword);

    // 8. 응원팀 변경 (온보딩 및 설정 변경용) - [복구됨]
    int updateMemberTeam(MemberVO member);

    // 9. 회원 탈퇴 (상태값 변경)
    int withdrawMember(Long memberId);
}