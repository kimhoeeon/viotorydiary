package com.viotory.diary.controller;

import com.viotory.diary.service.MemberService;
import com.viotory.diary.service.SmsService;
import com.viotory.diary.util.StringUtil;
import com.viotory.diary.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.time.LocalDate;

@Slf4j
@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;
    private final SmsService smsService;

    // ==========================================
    // 1. 로그인 & 로그아웃
    // ==========================================

    @GetMapping("/login")
    public String loginPage() {
        return "member/login";
    }

    /**
     * 로그인 처리
     * MemberVO를 사용하여 파라미터를 받고, 세션에 저장
     */
    @PostMapping("/login")
    public String loginAction(@RequestParam("email") String email,
                              @RequestParam("password") String password,
                              HttpServletRequest request,
                              Model model) {
        try {
            MemberVO loginMember = memberService.login(email, password);

            // 세션에 회원 정보 저장
            HttpSession session = request.getSession();
            session.setAttribute("loginMember", loginMember);

            // 팀 설정이 안 되어있다면(NONE) 설정 페이지로 리다이렉트 (스토리보드 정책)
            if ("NONE".equals(loginMember.getMyTeamCode())) {
                return "redirect:/member/team-setting";
            }

            return "redirect:/main"; // 메인 페이지로
        } catch (Exception e) {
            log.warn("로그인 실패: {}", e.getMessage());
            model.addAttribute("error", e.getMessage());
            return "member/login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/member/login";
    }

    // ==========================================
    // 2. 회원가입 (단계별 Wizard)
    // ==========================================

    @GetMapping("/join")
    public String joinPage() {
        return "member/join";
    }

    // 단계별 페이지 매핑
    @GetMapping("/join")
    public String joinMain() { return "member/join"; }

    @GetMapping("/join/step1")
    public String joinStep1() { return "member/join_step1"; }

    @GetMapping("/join/step2")
    public String joinStep2() { return "member/join_step2"; }

    @GetMapping("/join/step3")
    public String joinStep3() { return "member/join_step3"; }

    @GetMapping("/join/step4")
    public String joinStep4() { return "member/join_step4"; }

    @GetMapping("/join/step5")
    public String joinStep5() { return "member/join_step5"; }

    @GetMapping("/join/step6")
    public String joinStep6() { return "member/join_step6"; }

    @PostMapping("/join")
    public String joinAction(
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            @RequestParam("nickname") String nickname,
            @RequestParam("phoneNumber") String phoneNumber,
            @RequestParam("birthdate") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate birthdate,
            @RequestParam(value = "gender", required = false, defaultValue = "U") String gender,
            @RequestParam(value = "marketingAgree", defaultValue = "N") String marketingAgree,
            Model model) {

        MemberVO member = new MemberVO();
        member.setEmail(email);
        member.setPassword(password);
        member.setNickname(nickname);
        member.setPhoneNumber(phoneNumber);
        member.setBirthdate(birthdate);
        member.setGender(gender);
        member.setMarketingAgree(marketingAgree);

        try {
            memberService.registerMember(member);
            return "member/join_complete"; // 가입 성공 페이지
        } catch (Exception e) {
            // 실패 시 에러 메시지를 담아 다시 가입 페이지로
            model.addAttribute("error", e.getMessage());
            model.addAttribute("member", member); // 입력했던 정보 유지용
            return "member/join";
        }
    }

    @GetMapping("/join/complete")
    public String joinComplete() { return "member/join_complete"; }

    // ==========================================
    // 3. SMS 본인인증
    // ==========================================

    @PostMapping("/send-sms")
    @ResponseBody
    public String sendSms(@RequestParam("phoneNumber") String phoneNumber) {
        try {
            String cleanNumber = phoneNumber.replaceAll("-", "");
            return smsService.sendVerificationCode(cleanNumber);
        } catch (Exception e) {
            log.error("SMS 발송 오류", e);
            return "fail: " + e.getMessage();
        }
    }

    @PostMapping("/verify-sms")
    @ResponseBody
    public String verifySms(@RequestParam("phoneNumber") String phoneNumber,
                            @RequestParam("authCode") String authCode) {
        String cleanNumber = phoneNumber.replaceAll("-", "");
        boolean isVerified = smsService.verifyCode(cleanNumber, authCode);
        return isVerified ? "ok" : "fail";
    }

    @GetMapping("/sms/fail")
    public String smsFail() {
        return "member/sms_fail";
    }

    // ==========================================
    // 4. 마이페이지 & 계정 찾기
    // ==========================================

    @GetMapping("/mypage")
    public String myPage(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        MemberVO loginMember = (session != null) ? (MemberVO) session.getAttribute("loginMember") : null;

        if (loginMember == null) {
            return "redirect:/member/login";
        }

        // 세션 정보보다 DB 최신 정보를 가져오는 것이 안전함
        // (다른 곳에서 포인트나 상태가 변했을 수 있으므로)
        MemberVO memberInfo = memberService.getMemberInfo(loginMember.getMemberId());
        model.addAttribute("member", memberInfo);

        return "member/mypage"; // /WEB-INF/views/member/mypage.jsp
    }

    // --- 회원 정보 수정 처리 ---

    @PostMapping("/update")
    public String updateInfoAction(MemberVO member, HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 세션의 PK를 강제로 주입 (보안: 본인 정보만 수정 가능하도록)
        member.setMemberId(loginMember.getMemberId());

        try {
            memberService.updateMemberInfo(member);

            // 세션 정보도 최신화 (닉네임 등이 변경되었으므로)
            loginMember.setNickname(member.getNickname());
            loginMember.setPhoneNumber(member.getPhoneNumber());
            loginMember.setGender(member.getGender());
            loginMember.setBirthdate(member.getBirthdate());
            session.setAttribute("loginMember", loginMember);

            return "redirect:/member/mypage?status=success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            // 에러 발생 시 입력했던 정보를 유지하기 위해 member 객체 전달
            model.addAttribute("member", member);
            return "member/mypage";
        }
    }

    // --- 비밀번호 변경 처리 ---
    @PostMapping("/change-password")
    public String changePasswordAction(@RequestParam("currentPassword") String currentPassword,
                                       @RequestParam("newPassword") String newPassword,
                                       HttpSession session,
                                       Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        try {
            memberService.changePassword(loginMember.getMemberId(), currentPassword, newPassword);
            return "redirect:/member/mypage?status=pw_success";
        } catch (Exception e) {
            model.addAttribute("pwError", e.getMessage());
            model.addAttribute("tab", "password");
            // 에러 시에도 정보 표시를 위해 다시 조회
            MemberVO memberInfo = memberService.getMemberInfo(loginMember.getMemberId());
            model.addAttribute("member", memberInfo);
            return "member/mypage";
        }
    }

    // 아이디 찾기 입력 페이지
    @GetMapping("/find-id")
    public String findIdPage() {
        return "member/find_id";
    }

    // [신규] 아이디 찾기 결과 처리
    @PostMapping("/find-id/result")
    public String findIdResult(@RequestParam("birthdate") String birthdate,
                               @RequestParam("phoneNumber") String phoneNumber,
                               Model model) {
        // 생년월일과 전화번호로 회원 조회
        MemberVO member = memberService.findId(birthdate, phoneNumber);

        if (member != null) {
            // 조회 성공 시 정보 전달
            model.addAttribute("foundEmail", member.getEmail());
            model.addAttribute("nickname", member.getNickname());
        }
        // 조회 실패 시 foundEmail이 null이므로 JSP에서 분기 처리됨

        return "member/find_id_result";
    }

    // 비밀번호 찾기 (추후 구현 예정)
    @GetMapping("/find-password")
    public String findPasswordPage() {
        return "member/password_find"; // 퍼블리싱 파일명 기준 매핑
    }



    // --- 팀 선택 (온보딩) ---

    // 1. 팀 선택 화면 이동
    @GetMapping("/team-setting")
    public String teamSettingPage(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        MemberVO loginMember = (session != null) ? (MemberVO) session.getAttribute("loginMember") : null;

        // 로그인이 안 되어 있다면 로그인 페이지로
        if (loginMember == null) {
            return "redirect:/member/login";
        }

        // 이미 팀을 선택한 회원이 접근했다면 메인으로 보낼지, 수정 페이지로 쓸지 결정
        // 여기서는 수정 페이지로도 쓴다고 가정하고 그대로 둡니다.

        // (선택사항) 화면에 뿌려줄 팀 목록 데이터가 필요하다면 model에 담습니다.
        // model.addAttribute("teamList", teamService.getTeamList());

        return "member/team_setting"; // /WEB-INF/views/member/team_setting.jsp
    }

    // 2. 팀 선택 저장 처리 (POST)
    @PostMapping("/team-setting")
    public String teamSettingAction(@RequestParam("teamCode") String teamCode,
                                    HttpServletRequest request,
                                    Model model) {
        HttpSession session = request.getSession(false);
        MemberVO loginMember = (session != null) ? (MemberVO) session.getAttribute("loginMember") : null;

        if (loginMember == null) {
            return "redirect:/member/login";
        }

        try {
            // 서비스 호출
            memberService.updateTeam(loginMember.getMemberId(), teamCode);

            // 세션 정보 갱신 (선택한 팀 코드를 세션에도 반영해줘야 바로 적용됨)
            loginMember.setMyTeamCode(teamCode);
            session.setAttribute("loginMember", loginMember);

            return "redirect:/"; // 설정 완료 후 메인으로

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "member/team_setting";
        }
    }

}