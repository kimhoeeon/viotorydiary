package com.viotory.diary.dto;

import lombok.Data;
import java.util.List;

@Data
public class MenuItem {
    private String title;       // 메뉴명
    private String url;         // 이동 경로
    private String icon;        // 아이콘 클래스 (예: ki-user)
    private boolean active;     // 현재 활성화 여부
    private List<MenuItem> children; // 하위 메뉴
}