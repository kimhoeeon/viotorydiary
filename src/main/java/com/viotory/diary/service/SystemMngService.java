package com.viotory.diary.service;

import com.viotory.diary.mapper.SystemMngMapper;
import com.viotory.diary.vo.AppVersionVO;
import com.viotory.diary.vo.NoticeVO;
import com.viotory.diary.vo.TermsVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class SystemMngService {

    private final SystemMngMapper systemMngMapper;

    // ==========================================
    // 1. 앱 버전 관리 (App Version)
    // ==========================================

    /**
     * OS별 최신 버전 정보 조회 (사용자 앱 체크용)
     */
    public AppVersionVO getLatestVersion(String osType) {
        return systemMngMapper.selectLatestVersion(osType);
    }

    /**
     * 버전 목록 조회 (관리자용)
     */
    public List<AppVersionVO> getAppVersionList() {
        return systemMngMapper.selectAppVersionList();
    }

    /**
     * 버전 등록
     */
    @Transactional
    public void registerAppVersion(AppVersionVO vo) {
        systemMngMapper.insertAppVersion(vo);
    }

    /**
     * 버전 삭제
     */
    @Transactional
    public void removeAppVersion(Long versionId) {
        systemMngMapper.deleteAppVersion(versionId);
    }


    // ==========================================
    // 2. 공지사항 관리 (Notice)
    // ==========================================
    public List<NoticeVO> getNoticeList() {
        return systemMngMapper.selectNoticeList();
    }

    // 사용자용 공지 목록
    public List<NoticeVO> getActiveNoticeList() {
        return systemMngMapper.selectActiveNoticeList();
    }

    public NoticeVO getNoticeById(Long noticeId) {
        return systemMngMapper.selectNoticeById(noticeId);
    }

    @Transactional
    public void registerNotice(NoticeVO notice) {
        systemMngMapper.insertNotice(notice);
    }

    @Transactional
    public void updateNotice(NoticeVO notice) {
        // [중요] 체크박스 해제 시 null로 들어오므로 'N'으로 변경
        if (notice.getIsTop() == null || notice.getIsTop().isEmpty()) {
            notice.setIsTop("N");
        }
        systemMngMapper.updateNotice(notice);
    }

    @Transactional
    public void deleteNotice(Long noticeId) {
        systemMngMapper.deleteNotice(noticeId);
    }

    @Transactional
    public void increaseNoticeViewCount(Long noticeId) {
        systemMngMapper.updateNoticeViewCount(noticeId);
    }

    // ==========================================
    // 3. 약관 관리 (Terms)
    // ==========================================
    public List<TermsVO> getTermsList() {
        return systemMngMapper.selectTermsList();
    }

    public TermsVO getTermsById(Long termId) {
        return systemMngMapper.selectTermsById(termId);
    }

    public TermsVO getLatestTermsByType(String type) {
        return systemMngMapper.selectLatestTermByType(type);
    }

    @Transactional
    public void registerTerms(TermsVO terms) {
        systemMngMapper.insertTerms(terms);
    }

    @Transactional
    public void updateTerms(TermsVO terms) {
        systemMngMapper.updateTerms(terms);
    }

    @Transactional
    public void deleteTerms(Long termId) {
        systemMngMapper.deleteTerms(termId);
    }
}