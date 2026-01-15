package com.viotory.diary.service;

import com.viotory.diary.mapper.MemberMngMapper;
import com.viotory.diary.vo.Criteria;
import com.viotory.diary.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MemberMngService {

    private final MemberMngMapper memberMngMapper;

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
}