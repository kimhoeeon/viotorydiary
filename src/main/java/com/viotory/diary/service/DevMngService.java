package com.viotory.diary.service;

import com.viotory.diary.dto.MailRequestDTO;
import com.viotory.diary.mapper.DevMngMapper;
import com.viotory.diary.vo.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class DevMngService {

    private final DevMngMapper devMapper;
    private final DirectSendService directSendService; // 이메일 발송 서비스

    // 목록 조회
    public List<DevRequestVO> getRequestList(Criteria cri) {
        return devMapper.selectRequestList(cri);
    }

    public int getRequestTotal(Criteria cri) {
        return devMapper.getTotalRequestCount(cri);
    }

    // 상세 조회 (파일, 댓글 포함)
    public DevRequestVO getRequest(Long reqId) {
        DevRequestVO vo = devMapper.selectRequestById(reqId);
        if (vo != null) {
            vo.setFileList(devMapper.selectFileList("REQ", reqId));
        }
        return vo;
    }

    // 댓글 목록
    public List<DevCommentVO> getCommentList(Long reqId) {
        List<DevCommentVO> list = devMapper.selectCommentList(reqId);
        // 각 댓글별 파일 조회 (N+1 문제 가능성 있으나 댓글 수가 적으므로 단순 구현)
        for (DevCommentVO co : list) {
            co.setFileList(devMapper.selectFileList("COM", co.getCommentId()));
        }
        return list;
    }

    /**
     * 요청글 등록 및 알림 발송
     */
    @Transactional
    public void registerRequest(DevRequestVO vo) {
        // 1. DB 저장
        devMapper.insertRequest(vo);

        // 2. 파일 저장
        if (vo.getFileList() != null) {
            for (DevFileVO file : vo.getFileList()) {
                file.setTargetType("REQ");
                file.setTargetId(vo.getReqId());
                devMapper.insertFile(file);
            }
        }

        // 3. 이메일 알림 (작성자가 발주사인 경우 -> 관리자에게)
        // (관리자가 자가 등록하는 경우는 알림 제외할 수도 있음, 여기선 항상 발송)
        sendEmailToAdmins(vo, "NEW_REQ");
    }

    /**
     * 상태 변경 및 알림
     */
    @Transactional
    public void updateStatus(DevRequestVO vo) {
        devMapper.updateRequestStatus(vo);

        // 완료(DONE) 처리 시 발주사에게 알림
        if ("DONE".equals(vo.getStatus())) {
            // 원본 글 정보 조회를 위해 재조회
            DevRequestVO origin = devMapper.selectRequestById(vo.getReqId());
            sendEmailToWriter(origin, "REQ_DONE");
        }
    }

    /**
     * 댓글 등록 및 알림
     */
    @Transactional
    public void registerComment(DevCommentVO vo) {
        devMapper.insertComment(vo);

        // 파일 저장
        if (vo.getFileList() != null) {
            for (DevFileVO file : vo.getFileList()) {
                file.setTargetType("COM");
                file.setTargetId(vo.getCommentId());
                devMapper.insertFile(file);
            }
        }

        // 알림 발송 로직
        // 원본 글 정보 필요
        DevRequestVO req = devMapper.selectRequestById(vo.getReqId());

        // 작성자 역할 확인 (여기선 'role'을 파라미터나 세션에서 받아왔다고 가정하거나 DB조회 필요)
        // 편의상 writerRole이 'CLIENT'면 관리자에게, 'ADMIN'이면 발주사에게 보냄
        if ("CLIENT".equals(vo.getWriterRole())) {
            sendEmailToAdmins(req, "NEW_COMMENT");
        } else {
            sendEmailToWriter(req, "NEW_COMMENT_ADMIN");
        }
    }

    // --- Private Helper Methods for Email ---

    // 관리자들에게 메일 발송
    private void sendEmailToAdmins(DevRequestVO vo, String type) {
        try {
            // 1. 수신자 조회 (카테고리 매칭)
            List<String> emails = devMapper.selectAdminEmailsByCategory(vo.getCategory());
            if (emails == null || emails.isEmpty()) return;

            // 2. 메일 제목/내용 구성
            String subject = "";
            StringBuilder body = new StringBuilder();

            if ("NEW_REQ".equals(type)) {
                String urgentTag = "Y".equals(vo.getUrgency()) ? "[긴급] " : "";
                subject = urgentTag + "[" + vo.getCategoryName() + "] 새로운 요청사항이 등록되었습니다.";
                body.append("제목: ").append(vo.getTitle()).append("\n\n");
                body.append("내용 확인하기: URL_TO_ADMIN_PAGE/mng/dev/detail?reqId=").append(vo.getReqId());
            } else if ("NEW_COMMENT".equals(type)) {
                subject = "[댓글알림] 요청사항에 새로운 댓글이 달렸습니다.";
                body.append("원글 제목: ").append(vo.getTitle()).append("\n\n");
                body.append("확인하기: URL_TO_ADMIN_PAGE/mng/dev/detail?reqId=").append(vo.getReqId());
            }

            // 3. 발송 요청
            MailRequestDTO mailDto = new MailRequestDTO();
            mailDto.setSubject(subject);
            mailDto.setBody(body.toString());

            List<MailRequestDTO.Receiver> receivers = new ArrayList<>();
            for (String email : emails) {
                receivers.add(new MailRequestDTO.Receiver("관리자", email));
            }
            mailDto.setReceiver(receivers);

            // 첨부파일 정보가 있다면 DTO에 추가 (DirectSendService에서 텍스트로 변환됨)
            if (vo.getFileList() != null) {
                mailDto.setFileUrl(vo.getFileList());
            }

            directSendService.processMailSend(mailDto);

        } catch (Exception e) {
            log.error("메일 발송 실패", e);
        }
    }

    // 작성자(발주사)에게 메일 발송
    private void sendEmailToWriter(DevRequestVO vo, String type) {
        try {
            List<String> emails = devMapper.selectWriterEmails(vo.getAdminId());
            if (emails == null || emails.isEmpty()) return;

            String subject = "";
            StringBuilder body = new StringBuilder();

            if ("REQ_DONE".equals(type)) {
                subject = "[처리완료] 요청하신 사항이 완료되었습니다.";
                body.append("제목: ").append(vo.getTitle()).append("\n");
                body.append("처리 결과 및 내용을 확인해주세요.");
            } else if ("NEW_COMMENT_ADMIN".equals(type)) {
                subject = "[답변알림] 관리자 코멘트가 등록되었습니다.";
                body.append("원글 제목: ").append(vo.getTitle());
            }

            MailRequestDTO mailDto = new MailRequestDTO();
            mailDto.setSubject(subject);
            mailDto.setBody(body.toString());

            List<MailRequestDTO.Receiver> receivers = new ArrayList<>();
            for (String email : emails) {
                receivers.add(new MailRequestDTO.Receiver("발주사", email));
            }
            mailDto.setReceiver(receivers);

            directSendService.processMailSend(mailDto);

        } catch (Exception e) {
            log.error("메일 발송 실패", e);
        }
    }

    /**
     * 요청글 수정 (파일 삭제 로직 추가)
     */
    @Transactional
    public void updateRequest(DevRequestVO vo) {
        // 1. 기본 정보 업데이트
        devMapper.updateRequest(vo);

        // 2. 파일 삭제 요청 처리
        deleteFiles(vo.getDeleteFileIds());

        // 3. 신규 파일 추가
        if (vo.getFileList() != null && !vo.getFileList().isEmpty()) {
            for (DevFileVO file : vo.getFileList()) {
                file.setTargetType("REQ");
                file.setTargetId(vo.getReqId());
                devMapper.insertFile(file);
            }
        }
    }

    /**
     * 댓글 수정 (내용 변경 + 파일 추가/삭제)
     */
    @Transactional
    public void updateComment(DevCommentVO vo) {
        // 1. 내용 업데이트
        devMapper.updateComment(vo);

        // 2. 파일 삭제
        deleteFiles(vo.getDeleteFileIds());

        // 3. 신규 파일 추가
        if (vo.getFileList() != null && !vo.getFileList().isEmpty()) {
            for (DevFileVO file : vo.getFileList()) {
                file.setTargetType("COM");
                file.setTargetId(vo.getCommentId());
                devMapper.insertFile(file);
            }
        }
    }

    /**
     * 댓글 삭제 (Soft Delete)
     */
    @Transactional
    public void deleteComment(Long commentId) {
        devMapper.deleteComment(commentId);
    }

    // --- 파일 삭제 공통 메소드 ---
    private void deleteFiles(List<Long> deleteFileIds) {
        if (deleteFileIds != null && !deleteFileIds.isEmpty()) {
            for (Long fileId : deleteFileIds) {
                // 실제 파일 삭제 로직이 필요하다면 여기서 조회 후 File.delete() 수행
                // 현재는 DB 데이터만 삭제
                devMapper.deleteFile(fileId);
            }
        }
    }

}