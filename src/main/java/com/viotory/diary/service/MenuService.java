package com.viotory.diary.service;

import com.viotory.diary.dto.MenuItem;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class MenuService {

    /**
     * 관리자 페이지용 메뉴 목록 생성
     */
    public List<MenuItem> getAdminMenuItems() {
        List<MenuItem> menus = new ArrayList<>();

        // 1. 대시보드
        // ki-element-11: path 4개
        menus.add(new MenuItem("대시보드", "/mng/main.do", "ki-element-11", 4));

        // 2. 운영 관리 (그룹)
        // ki-gear: path 2개
        List<MenuItem> subOps = new ArrayList<>();

        // 하위 메뉴는 아이콘을 사용하지 않고 bullet 점을 사용하므로 icon값은 비워도 됨 (JSP에서 bullet 처리)
        subOps.add(new MenuItem("경기 데이터 동기화", "/mng/game/syncPage", "", 0));
        subOps.add(new MenuItem("승요 멘트 관리", "/mng/winyo/mentions", "", 0));

        // 그룹 메뉴 생성 (자식 포함)
        menus.add(new MenuItem("운영 관리", "#", "ki-gear", 2, subOps));

        // 3. 회원 관리 (그룹)
        // ki-user: path 2개
        List<MenuItem> subMem = new ArrayList<>();
        subMem.add(new MenuItem("회원 목록", "/mng/members/list", "", 0));

        menus.add(new MenuItem("회원 관리", "#", "ki-user", 2, subMem));

        // 4. 콘텐츠 관리 (그룹)
        // ki-folder: 아이콘 예시
        List<MenuItem> subContent = new ArrayList<>();
        subContent.add(new MenuItem("이벤트 관리", "/mng/content/events", "", 0));
        subContent.add(new MenuItem("구단 콘텐츠 관리", "/mng/content/teams", "", 0));

        menus.add(new MenuItem("콘텐츠 관리", "#", "ki-folder", 2, subContent));

        // 5. 시스템 관리 (그룹)
        // ki-setting-2: 아이콘 예시
        List<MenuItem> subSys = new ArrayList<>();
        subSys.add(new MenuItem("공지사항 관리", "/mng/system/notices", "", 0));
        subSys.add(new MenuItem("앱 버전 관리", "/mng/system/versions", "", 0));

        menus.add(new MenuItem("시스템 관리", "#", "ki-setting-2", 2, subSys));

        return menus;
    }
}