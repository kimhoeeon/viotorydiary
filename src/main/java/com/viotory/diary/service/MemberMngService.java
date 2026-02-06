package com.viotory.diary.service;

import com.viotory.diary.dto.SmsDTO;
import com.viotory.diary.mapper.MemberMngMapper;
import com.viotory.diary.util.StringUtil;
import com.viotory.diary.vo.Criteria;
import com.viotory.diary.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MemberMngService {

    private final MemberMngMapper memberMngMapper;
    private final PasswordEncoder passwordEncoder; // SecurityConfig에서 주입
    private final SmsService smsService; // SMS 발송 서비스

    public List<MemberVO> getMemberList(Criteria cri) {
        return memberMngMapper.selectMemberListWithPaging(cri);
    }

    public int getTotal(Criteria cri) {
        return memberMngMapper.getTotalCount(cri);
    }

    public MemberVO getMember(Long memberId) {
        return memberMngMapper.selectMemberById(memberId);
    }

    @Transactional
    public void updateStatus(Long memberId, String status) {
        memberMngMapper.updateMemberStatus(memberId, status);
    }

    @Transactional
    public String resetPassword(Long memberId) {
        MemberVO member = memberMngMapper.selectMemberById(memberId);
        if (member == null) return "not_found";

        // 1. 임시 비밀번호 생성 (8자리 랜덤)
        String tempPw = StringUtil.getRandomString(8); // StringUtil 활용

        // 2. 비밀번호 암호화 및 DB 업데이트
        String encPw = passwordEncoder.encode(tempPw);
        member.setPassword(encPw);
        memberMngMapper.updatePassword(member);

        // 3. SMS 발송
        if (member.getPhoneNumber() != null) {
            String msg = "[승요일기] 임시 비밀번호는 [" + tempPw + "] 입니다. 로그인 후 변경해주세요.";
            SmsDTO smsDTO = SmsDTO.builder()
                    .receiver(member.getPhoneNumber())
                    .sender("07080953937") // 실제 운영시 등록된 발신번호 필수
                    .message(msg)
                    .testmode_yn("N")
                    .build();

            smsService.smsSend(smsDTO);
            return "ok";
        } else {
            return "no_phone";
        }
    }

}