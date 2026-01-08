package com.viotory.diary.service;

import com.viotory.diary.mapper.AdminMapper;
import com.viotory.diary.util.SHA512;
import com.viotory.diary.vo.AdminVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class AdminService {
    private final AdminMapper adminMapper;
    private final SHA512 sha512;

    /**
     * 관리자 로그인 처리
     * @param loginId 아이디
     * @param password 비밀번호
     * @param clientIp 접속자 IP (개별 IP 제한 체크용)
     */
    public AdminVO login(String loginId, String password, String clientIp) throws Exception {
        // 1. 관리자 조회
        AdminVO admin = adminMapper.selectAdminByLoginId(loginId);
        if (admin == null) {
            throw new Exception("존재하지 않는 관리자 계정입니다.");
        }

        // 2. 비밀번호 검증 (SHA512 암호화 비교)
        String encryptedPassword = sha512.hash(password);
        if (!admin.getPassword().equals(encryptedPassword)) {
            log.warn("관리자 비밀번호 불일치: {}", loginId);
            throw new Exception("비밀번호가 일치하지 않습니다.");
        }

        // 3. 지정 IP 체크 (allowed_ip가 설정된 경우에만 검사)
        // DDL 코멘트: "NULL이면 전역 설정 따름" -> 여기선 Pass (전역은 Interceptor에서 이미 통과됨)
        if (admin.getAllowedIp() != null && !admin.getAllowedIp().isEmpty()) {
            if (!admin.getAllowedIp().equals(clientIp)) {
                log.warn("관리자 지정 IP 불일치 접속 시도. ID: {}, IP: {}", loginId, clientIp);
                throw new Exception("접속이 허용되지 않은 IP입니다.");
            }
        }

        // 4. 마지막 로그인 시간 업데이트
        adminMapper.updateLastLogin(admin.getAdminId());

        // 5. 보안상 비밀번호 제거 후 반환
        admin.setPassword(null);

        return admin;
    }
}