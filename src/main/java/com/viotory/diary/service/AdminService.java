package com.viotory.diary.service;

import com.viotory.diary.mapper.AdminMapper;
import com.viotory.diary.util.SHA512;
import com.viotory.diary.vo.AdminVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class AdminService {
    private final AdminMapper adminMapper;
    private final SHA512 sha512;

    /**
     * 관리자 로그인 처리
     * @param loginId 아이디
     * @param password 비밀번호 (평문)
     * @param clientIp 접속자 IP (개별 IP 제한 체크용)
     * @return 로그인 성공한 AdminVO 객체
     * @throws Exception 로그인 실패 사유
     */
    @Transactional
    public AdminVO login(String loginId, String password, String clientIp) throws Exception {
        // 1. 관리자 정보 조회
        AdminVO admin = adminMapper.selectAdminByLoginId(loginId);
        if (admin == null) {
            log.warn("로그인 실패 - 존재하지 않는 계정: {}", loginId);
            throw new Exception("존재하지 않는 관리자 계정입니다.");
        }

        // 2. 비밀번호 검증 (SHA512 암호화 비교)
        // 기존 코드의 SHA512 유틸리티 활용
        String encryptedPassword = sha512.hash(password);
        if (!admin.getPassword().equals(encryptedPassword)) {
            log.warn("로그인 실패 - 비밀번호 불일치: {}", loginId);
            throw new Exception("비밀번호가 일치하지 않습니다.");
        }

        // 3. 지정 IP 체크 (allowed_ip 컬럼 확인)
        // DDL: `allowed_ip` varchar(50) DEFAULT NULL COMMENT '지정 IP (NULL이면 전역 설정 따름)'
        // 로직: allowedIp 값이 설정되어 있다면 해당 IP로만 접속 가능
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
}