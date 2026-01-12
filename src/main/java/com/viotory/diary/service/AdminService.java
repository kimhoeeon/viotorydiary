package com.viotory.diary.service;

import com.viotory.diary.mapper.AdminMapper;
import com.viotory.diary.util.SHA512;
import com.viotory.diary.vo.AdminVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class AdminService {
    private final AdminMapper adminMapper;
    private final PasswordEncoder passwordEncoder;

    /**
     * 관리자 로그인 처리
     * @param loginId 아이디
     * @param password 비밀번호 (평문)
     * @param clientIp 접속자 IP
     * @return 로그인 성공한 AdminVO 객체
     * @throws Exception 로그인 실패 사유
     */
    @Transactional
    public AdminVO login(String loginId, String password, String clientIp) throws Exception {

        // 임시 코드: 콘솔에 '1234'의 암호화된 값을 출력
        System.out.println("생성된 비밀번호: " + passwordEncoder.encode("1234"));

        // 1. 관리자 정보 조회
        AdminVO admin = adminMapper.selectAdminByLoginId(loginId);

        if (admin == null) {
            log.warn("로그인 실패 - 존재하지 않는 계정: {}", loginId);
            throw new Exception("존재하지 않는 관리자 계정입니다.");
        }

        // 2. 비밀번호 검증 (BCrypt 매칭)
        // DB에 저장된 해시값과 입력받은 평문을 비교
        if (!passwordEncoder.matches(password, admin.getPassword())) {
            log.warn("로그인 실패 - 비밀번호 불일치: {}", loginId);
            throw new Exception("비밀번호가 일치하지 않습니다.");
        }

        // 3. 지정 IP 체크 (allowed_ip 컬럼 확인)
        if (admin.getAllowedIp() != null && !admin.getAllowedIp().isEmpty()) {
            if (!admin.getAllowedIp().equals(clientIp)) {
                log.warn("로그인 차단 - 허용되지 않은 IP 접속 시도. ID: {}, IP: {}, Allowed: {}",
                        loginId, clientIp, admin.getAllowedIp());
                throw new Exception("접속이 허용되지 않은 IP입니다.");
            }
        }

        // 4. 마지막 로그인 시간 업데이트
        adminMapper.updateLastLogin(admin.getAdminId());

        // 5. 보안상 반환 객체에서 비밀번호 제거
        admin.setPassword(null);

        return admin;
    }

    /**
     * 비밀번호 변경
     * @param loginId 로그인 ID
     * @param currentPassword 현재 비밀번호
     * @param newPassword 새 비밀번호
     * @return 성공 시 "ok", 실패 시 에러 메시지
     */
    @Transactional
    public String changePassword(String loginId, String currentPassword, String newPassword) { // [수정] id -> loginId

        // 1. 관리자 정보 조회
        AdminVO admin = adminMapper.selectAdminByLoginId(loginId);
        if (admin == null) {
            return "관리자 정보를 찾을 수 없습니다.";
        }

        // 2. 현재 비밀번호 검증 (BCrypt)
        if (!passwordEncoder.matches(currentPassword, admin.getPassword())) {
            return "현재 비밀번호가 일치하지 않습니다.";
        }

        // 3. 새 비밀번호 암호화 (BCrypt)
        String encryptedPassword = passwordEncoder.encode(newPassword);

        // 4. DB 업데이트
        int result = adminMapper.updatePassword(loginId, encryptedPassword);

        return result > 0 ? "ok" : "비밀번호 변경 실패 (DB 오류)";
    }

}