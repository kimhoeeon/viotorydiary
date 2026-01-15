package com.viotory.diary.controller;

import com.viotory.diary.mapper.SystemMngMapper;
import com.viotory.diary.vo.TermsVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/policy")
@RequiredArgsConstructor
public class PolicyController {

    private final SystemMngMapper systemMapper;

    // 이용약관 (SERVICE)
    @GetMapping("/terms")
    public String terms(Model model) {
        TermsVO vo = systemMapper.selectLatestTermByType("SERVICE");
        model.addAttribute("term", vo);
        return "policy/terms";
    }

    // 개인정보처리방침 (PRIVACY)
    @GetMapping("/privacy")
    public String privacy(Model model) {
        TermsVO vo = systemMapper.selectLatestTermByType("PRIVACY");
        model.addAttribute("term", vo);
        return "policy/privacy";
    }

    // 위치정보 이용약관 (LOCATION)
    @GetMapping("/location")
    public String location(Model model) {
        TermsVO vo = systemMapper.selectLatestTermByType("LOCATION");
        model.addAttribute("term", vo);
        return "policy/location";
    }
}