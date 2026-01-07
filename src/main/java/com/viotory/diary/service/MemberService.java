package com.viotory.diary.service;

import com.viotory.diary.mapper.MemberMapper;
import com.viotory.diary.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberMapper memberMapper;

    /**
     * 회원 가입 처리
     */
    @Transactional
    public void registerMember(MemberVO member) throws Exception {
        // 1. 이메일 중복 체크
        if (memberMapper.selectMemberByEmail(member.getEmail()) != null) {
            throw new Exception("이미 존재하는 이메일입니다.");
        }

        // 2. 닉네임 중복 체크
        if (memberMapper.countByNickname(member.getNickname()) > 0) {
            throw new Exception("이미 존재하는 닉네임입니다.");
        }

        // 3. (TODO) 비밀번호 암호화 로직 필요 (Spring Security 도입 시 적용)
        // member.setPassword(passwordEncoder.encode(member.getPassword()));

        // 4. DB 저장
        memberMapper.insertMember(member);
        log.info("회원가입 완료: {}", member.getEmail());
    }

    /**
     * 로그인 처리 (단순 예시)
     */
    public MemberVO login(String email, String password) throws Exception {
        MemberVO member = memberMapper.selectMemberByEmail(email);

        if (member == null) {
            throw new Exception("존재하지 않는 회원입니다.");
        }

        // (TODO) 암호화된 비밀번호 비교 로직으로 변경 필요
        if (!member.getPassword().equals(password)) {
            throw new Exception("비밀번호가 일치하지 않습니다.");
        }

        // 마지막 로그인 시간 갱신
        memberMapper.updateLastLogin(member.getMemberId());

        return member;
    }
}