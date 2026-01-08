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
        MenuItem dashboard = new MenuItem();
        dashboard.setTitle("대시보드");
        dashboard.setUrl("/mng/main.do");
        dashboard.setIcon("ki-element-11"); // 케인아이콘 클래스명 (JSP 템플릿 참조)
        dashboard.setActive(true);
        menus.add(dashboard);

        // 2. 운영 관리 (그룹)
        MenuItem operation = new MenuItem();
        operation.setTitle("운영 관리");
        operation.setIcon("ki-gear");

        List<MenuItem> subOps = new ArrayList<>();

        // 2-1. 경기 데이터 관리
        MenuItem gameMng = new MenuItem();
        gameMng.setTitle("경기 데이터 동기화");
        gameMng.setUrl("/mng/game/syncPage"); // 별도 페이지가 있다면 연결, 없으면 메인으로
        subOps.add(gameMng);

        // 2-2. 승요 멘트 관리 (준비중)
        MenuItem mentionMng = new MenuItem();
        mentionMng.setTitle("승요 멘트 관리");
        mentionMng.setUrl("#");
        subOps.add(mentionMng);

        operation.setChildren(subOps);
        menus.add(operation);

        // 3. 회원 관리 (그룹)
        MenuItem memberGroup = new MenuItem();
        memberGroup.setTitle("회원 관리");
        memberGroup.setIcon("ki-user");

        List<MenuItem> subMem = new ArrayList<>();
        MenuItem memberList = new MenuItem();
        memberList.setTitle("회원 목록");
        memberList.setUrl("#");
        subMem.add(memberList);

        memberGroup.setChildren(subMem);
        menus.add(memberGroup);

        return menus;
    }
}