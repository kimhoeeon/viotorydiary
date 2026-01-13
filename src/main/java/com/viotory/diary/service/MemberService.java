package com.viotory.diary.service;

import com.viotory.diary.dto.SmsDTO;
import com.viotory.diary.mapper.MemberMapper;
import com.viotory.diary.util.SHA512;
import com.viotory.diary.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.Period;
import java.util.List;
import java.util.UUID;
import java.util.regex.Pattern;

@Slf4j
@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberMapper memberMapper;
    private final SHA512 sha512;
    private final SmsService smsService; // 문자 발송을 위해 주입

    /**
     * 회원 가입 처리
     */
    @Transactional
    public void registerMember(MemberVO member) throws Exception {
        // 1. 만 14세 미만 가입 불가 체크
        if (member.getBirthdate() != null) {
            int age = Period.between(member.getBirthdate(), LocalDate.now()).getYears();
            if (age < 14) {
                throw new Exception("만 14세 미만은 가입할 수 없습니다.");
            }
        }

        // 2. 비밀번호 복잡도 체크 (8~14자, 영문/숫자/특수문자 중 2종 이상)
        if (!isValidPassword(member.getPassword())) {
            throw new Exception("비밀번호는 8~14자이며, 영문/숫자/특수문자 중 2개 이상을 포함해야 합니다.");
        }

        // 3. 중복 체크
        if (memberMapper.selectMemberByEmail(member.getEmail()) != null) {
            throw new Exception("이미 가입된 이메일입니다.");
        }
        if (memberMapper.countByNickname(member.getNickname()) > 0) {
            throw new Exception("이미 사용 중인 닉네임입니다.");
        }

        // 3. 비밀번호 암호화
        if (member.getPassword() != null && !member.getPassword().isEmpty()) {
            String encryptedPassword = sha512.hash(member.getPassword());
            member.setPassword(encryptedPassword);
        }

        // 5. 기본값 설정 (DDL 및 스토리보드 반영)
        if (member.getMyTeamCode() == null || member.getMyTeamCode().isEmpty()) {
            member.setMyTeamCode("NONE"); // 팀 선택 전
        }
        member.setSocialProvider("NONE");
        member.setRole("USER");
        member.setStatus("ACTIVE");

        // 성별이 없으면 기본값 U 설정
        if (member.getGender() == null || member.getGender().isEmpty()) {
            member.setGender("U");
        }

        // 6. DB 저장
        memberMapper.insertMember(member);
        log.info("회원가입 완료: {}", member.getEmail());
    }

    /**
     * 로그인 처리 (단순 예시)
     */
    public MemberVO login(String email, String password) throws Exception {
        // 1. 회원 조회
        MemberVO member = memberMapper.selectMemberByEmail(email);
        if (member == null) {
            throw new Exception("아이디 또는 비밀번호가 틀렸습니다."); // 보안상 "아이디 또는 비밀번호가 틀렸습니다" 권장
        }

        if ("WITHDRAWN".equals(member.getStatus())) {
            throw new Exception("탈퇴한 회원입니다.");
        }

        // 2. 비밀번호 비교 (입력받은 비밀번호를 암호화하여 DB 값과 비교)
        String encryptedInputPassword = sha512.hash(password);
        if (!member.getPassword().equals(encryptedInputPassword)) {
            throw new Exception("비밀번호가 일치하지 않습니다.");
        }

        // 3. 마지막 로그인 시간 갱신
        memberMapper.updateLastLogin(member.getMemberId());

        // 비밀번호 정보 제거 후 반환
        member.setPassword(null);

        return member;
    }

    /**
     * 회원 최신 정보 조회 (마이페이지용)
     */
    public MemberVO getMemberInfo(Long memberId) {
        return memberMapper.selectMemberById(memberId);
    }

    /**
     * 회원 정보 수정 (닉네임, 연락처 등)
     */
    @Transactional
    public void updateMemberInfo(MemberVO member) throws Exception {
        // 1. 닉네임 중복 체크 (기존 닉네임과 다를 경우에만 수행)
        MemberVO currentMember = memberMapper.selectMemberById(member.getMemberId());
        if (currentMember == null) {
            throw new Exception("회원 정보를 찾을 수 없습니다.");
        }

        if (!currentMember.getNickname().equals(member.getNickname())) {
            if (memberMapper.countByNickname(member.getNickname()) > 0) {
                throw new Exception("이미 사용 중인 닉네임입니다.");
            }
        }

        // 2. 정보 수정 실행
        memberMapper.updateMemberInfo(member);
        log.info("회원정보 수정 완료: memberId={}", member.getMemberId());
    }

    /**
     * 비밀번호 변경
     */
    @Transactional
    public void changePassword(Long memberId, String currentPassword, String newPassword) throws Exception {
        // 1. 현재 회원 정보 조회
        MemberVO member = memberMapper.selectMemberById(memberId);
        if (member == null) {
            throw new Exception("회원 정보가 없습니다.");
        }

        // 2. 현재 비밀번호 검증
        String encryptedCurrent = sha512.hash(currentPassword);
        if (!member.getPassword().equals(encryptedCurrent)) {
            throw new Exception("현재 비밀번호가 일치하지 않습니다.");
        }

        // 3. 새 비밀번호 유효성 검사 (8~14자, 영문/숫자/특수문자 중 2가지 이상)
        if (!isValidPassword(newPassword)) {
            throw new Exception("비밀번호는 8~14자이며, 영문/숫자/특수문자 중 2개 이상을 포함해야 합니다.");
        }

        // 4. 새 비밀번호 암호화 및 저장
        String encryptedNew = sha512.hash(newPassword);
        memberMapper.updatePassword(memberId, encryptedNew);
        log.info("비밀번호 변경 완료: memberId={}", memberId);
    }

    /**
     * 응원팀 설정/변경
     */
    @Transactional
    public void updateTeam(Long memberId, String teamCode) throws Exception {
        // 1. 회원 검증
        MemberVO member = memberMapper.selectMemberById(memberId); // 기존에 있던 selectMemberById 사용
        if (member == null) {
            throw new Exception("회원 정보를 찾을 수 없습니다.");
        }

        // 2. 팀 코드 유효성 검사 (예시: KBO 10개 구단 코드)
        // 실제로는 Enum이나 DB 공통코드 테이블로 관리하는 것이 좋습니다.
        // 여기서는 간단히 null 체크만 진행하거나, 필요한 경우 화이트리스트 검사를 추가하세요.
        if (teamCode == null || teamCode.isEmpty()) {
            throw new Exception("팀을 선택해주세요.");
        }

        // 3. 업데이트 수행
        member.setMyTeamCode(teamCode);
        memberMapper.updateMemberTeam(member);

        log.info("팀 변경 완료: memberId={}, teamCode={}", memberId, teamCode);
    }

    // 비밀번호 규칙 검증 로직
    private boolean isValidPassword(String password) {
        if (password == null || password.length() < 8 || password.length() > 14) {
            return false;
        }
        int typeCount = 0;
        if (Pattern.compile("[a-zA-Z]").matcher(password).find()) typeCount++; // 영문
        if (Pattern.compile("[0-9]").matcher(password).find()) typeCount++;    // 숫자
        if (Pattern.compile("[!@#$%^&*?_~]").matcher(password).find()) typeCount++; // 특수문자
        return typeCount >= 2;
    }

    // --- [New] 관리자용 메서드 ---

    /**
     * [관리자] 회원 목록 조회 (페이징 + 검색)
     */
    public List<MemberVO> getMemberList(int offset, int limit, String searchType, String keyword) {
        return memberMapper.selectMemberList(offset, limit, searchType, keyword);
    }

    /**
     * [관리자] 회원 수 카운트 (페이징용)
     */
    public int countMembers(String searchType, String keyword) {
        return memberMapper.countMemberList(searchType, keyword);
    }

    /**
     * [관리자] 회원 강제 탈퇴 처리
     * 상태를 'WITHDRAWN'으로 변경합니다.
     */
    @Transactional
    public void forceWithdrawMember(Long memberId) throws Exception {
        // 1. 존재 여부 확인
        MemberVO member = memberMapper.selectMemberById(memberId);
        if (member == null) {
            throw new Exception("존재하지 않는 회원입니다.");
        }

        // 2. 이미 탈퇴한 회원인지 확인
        if ("WITHDRAWN".equals(member.getStatus())) {
            throw new Exception("이미 탈퇴 처리된 회원입니다.");
        }

        // 3. 탈퇴 처리
        memberMapper.withdrawMember(memberId);
        log.info("관리자에 의한 강제 탈퇴 처리 완료: memberId={}", memberId);
    }

    /**
     * 아이디 찾기
     * @param birthdate 생년월일 (YYYY-MM-DD)
     * @param phoneNumber 휴대폰 번호 (하이픈 포함 가능)
     * @return MemberVO (email, nickname 포함) 또는 null
     */
    public MemberVO findId(String birthdate, String phoneNumber) {
        // 하이픈 제거 (DB에는 숫자만 저장되어 있다고 가정)
        String cleanPhone = phoneNumber.replaceAll("-", "");
        return memberMapper.findMemberByBirthAndPhone(birthdate, cleanPhone);
    }

    /**
     * 비밀번호 초기화 및 임시 비밀번호 발송
     * 1. 회원 정보 확인
     * 2. 임시 비밀번호 생성 및 암호화 업데이트
     * 3. SMS 발송
     */
    @Transactional
    public boolean resetAndSendPassword(String userName, String phoneNumber) throws Exception {
        // 1. 회원 조회 (이름 + 전화번호)
        // MemberMapper에 해당 메소드 추가 필요
        MemberVO member = memberMapper.findMemberByNameAndPhone(userName, phoneNumber);

        if (member == null) {
            return false;
        }

        // 2. 임시 비밀번호 생성 (UUID 앞 8자리 사용)
        String tempPw = UUID.randomUUID().toString().substring(0, 8);

        // 3. 비밀번호 암호화 (기존 sha512 빈 사용)
        String encryptedPassword = sha512.hash(tempPw);

        // 4. DB 업데이트 (기존에 존재하는 updatePassword 메소드 재사용)
        // 기존 Mapper의 파라미터명은 newPassword 입니다.
        memberMapper.updatePassword(member.getMemberId(), encryptedPassword);

        // 5. SMS 발송
        String message = "[승요일기] 고객님의 임시 비밀번호는 [" + tempPw + "] 입니다. 로그인 후 변경해주세요.";

        // SmsService에 sendOne 같은 간편 메소드가 있다면 사용하고, 없다면 DTO 빌드
        SmsDTO smsDTO = SmsDTO.builder()
                .receiver(phoneNumber)
                // 발신번호는 SmsService 내부 상수를 쓰거나 설정파일에서 가져옴
                .sender("01012345678") // 실제 운영시 등록된 발신번호 필수
                .message(message)
                .testmode_yn("N")
                .build();

        smsService.smsSend(smsDTO);

        log.info("비밀번호 초기화 및 발송 완료: memberId={}", member.getMemberId());
        return true;
    }

}