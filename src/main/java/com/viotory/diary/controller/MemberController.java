package com.viotory.diary.controller;

import com.viotory.diary.dto.CommentDTO;
import com.viotory.diary.dto.FollowDTO;
import com.viotory.diary.service.CommentService;
import com.viotory.diary.service.MemberService;
import com.viotory.diary.service.SmsService;
import com.viotory.diary.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Slf4j
@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;
    private final SmsService smsService;
    private final CommentService commentService;

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
    public String loginAction(MemberVO member, HttpServletRequest request, Model model) {
        try {
            MemberVO loginMember = memberService.login(member.getEmail(), member.getPassword());

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
    public String joinAction(MemberVO member, Model model) {
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
    // 비밀번호 변경 페이지 이동
    @GetMapping("/update/password")
    public String updatePasswordPage(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/member/login";
        }
        return "member/password_change"; // views/member/password_change.jsp
    }

    // 비밀번호 변경 처리
    @PostMapping("/update/password")
    public String updatePasswordAction(@RequestParam("currentPassword") String currentPassword,
                                       @RequestParam("newPassword") String newPassword,
                                       HttpSession session,
                                       Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        try {
            // 비밀번호 변경 서비스 호출
            memberService.changePassword(loginMember.getMemberId(), currentPassword, newPassword);

            // 변경 성공 시 로그아웃 처리 후 로그인 페이지로 이동 (보안 정책)
            session.invalidate();
            return "redirect:/member/login?msg=pwChanged";

            // 또는 마이페이지로 이동하려면:
            // return "redirect:/member/mypage?status=pw_success";
        } catch (Exception e) {
            // 실패 시 다시 변경 페이지로 이동하며 에러 메시지 전달
            model.addAttribute("error", e.getMessage());
            return "member/password_change";
        }
    }

    // 아이디 찾기 입력 페이지
    @GetMapping("/find-id")
    public String findIdPage() {
        return "member/find_id";
    }

    // 아이디 찾기 결과 처리
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

    // 비밀번호 찾기 입력 페이지
    @GetMapping("/find-password")
    public String findPasswordPage() {
        return "member/find_password";
    }

    // 비밀번호 초기화 및 임시 비밀번호 발송
    @PostMapping("/find-password/reset")
    public String resetPassword(@RequestParam("userName") String userName,
                                @RequestParam("phoneNumber") String phoneNumber,
                                @RequestParam("authCode") String authCode,
                                Model model) {

        // 1. SMS 인증번호 검증
        String cleanNumber = phoneNumber.replaceAll("-", "");
        boolean isVerified = smsService.verifyCode(cleanNumber, authCode);

        if (!isVerified) {
            model.addAttribute("error", "인증번호가 일치하지 않거나 만료되었습니다.");
            return "member/find_password";
        }

        // 2. 회원 확인 및 임시 비밀번호 발송
        try {
            boolean success = memberService.resetAndSendPassword(userName, cleanNumber);
            if (success) {
                model.addAttribute("name", userName);
                return "member/find_password_result";
            } else {
                model.addAttribute("error", "입력하신 정보와 일치하는 회원이 없습니다.");
                return "member/find_password";
            }
        } catch (Exception e) {
            log.error("비밀번호 초기화 중 오류", e);
            model.addAttribute("error", "오류가 발생했습니다. 다시 시도해주세요.");
            return "member/find_password";
        }
    }

    // ==========================================
    // 5. 팀 선택 (온보딩 & 마이페이지)
    // ==========================================

    // 팀 선택 페이지 이동
    @GetMapping("/team-setting")
    public String teamSettingPage(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/member/login";
        }
        return "member/team_setting";
    }

    // 팀 선택 저장 처리
    @PostMapping("/team-setting")
    public String teamSettingAction(@RequestParam("teamCode") String teamCode,
                                    HttpSession session,
                                    Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/member/login";
        }

        try {
            // 1. DB 업데이트 (Service 호출)
            memberService.updateTeam(loginMember.getMemberId(), teamCode);

            // 2. 세션 정보 갱신 (중요: 세션을 업데이트해야 화면에 즉시 반영됨)
            loginMember.setMyTeamCode(teamCode);
            session.setAttribute("loginMember", loginMember);

            // 3. 페이지 이동
            // (1) 최초 가입 후 온보딩인 경우 -> 메인으로
            // (2) 마이페이지에서 변경한 경우 -> 마이페이지로
            // 구분하기 복잡하다면, 마이페이지로 보내는 것이 무난합니다.
            return "redirect:/member/mypage";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "member/team_setting";
        }
    }

    // 프로필 수정(닉네임 변경) 페이지 이동
    @GetMapping("/update/profile")
    public String updateProfilePage(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/member/login";
        }
        // 최신 정보 조회하여 전달
        MemberVO memberInfo = memberService.getMemberInfo(loginMember.getMemberId());
        model.addAttribute("member", memberInfo);

        return "member/profile_update"; // views/member/profile_update.jsp
    }

    // 프로필 수정 처리
    @PostMapping("/update/profile")
    public String updateProfileAction(@RequestParam("nickname") String nickname,
                                      @RequestParam(value = "file", required = false) MultipartFile file, // 파일 추가
                                      HttpSession session,
                                      Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        try {
            // 1. 이미지 파일 업로드 처리
            String profileImagePath = null;
            if (file != null && !file.isEmpty()) {
                String savedName = saveFile(file);
                profileImagePath = "/uploads/" + savedName;
            }

            // 2. 서비스 호출 (닉네임 + 이미지 업데이트)
            // (MemberService에 updateProfile 메소드를 새로 만들거나, 기존 updateMemberInfo 활용)
            MemberVO updateVO = new MemberVO();
            updateVO.setMemberId(loginMember.getMemberId());
            updateVO.setNickname(nickname);
            updateVO.setProfileImage(profileImagePath);

            memberService.updateMemberInfo(updateVO); // Mapper 쿼리가 수정되었으므로 이것만 호출하면 됨

            // 3. 세션 정보 최신화
            loginMember.setNickname(nickname);
            if (profileImagePath != null) {
                loginMember.setProfileImage(profileImagePath);
            }
            session.setAttribute("loginMember", loginMember);

            return "redirect:/member/mypage";

        } catch (Exception e) {
            log.error("프로필 수정 실패", e);
            model.addAttribute("error", "프로필 수정 중 오류가 발생했습니다.");

            // 기존 정보 복구하여 화면 유지
            MemberVO memberInfo = memberService.getMemberInfo(loginMember.getMemberId());
            model.addAttribute("member", memberInfo);
            return "member/profile_update";
        }
    }

    // [파일 저장 메소드] (LockerController와 동일 로직)
    private String saveFile(MultipartFile file) throws Exception {
        String uploadDir = Paths.get(System.getProperty("user.home"), "viotory", "upload").toString();
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        String savedName = UUID.randomUUID() + "_" + file.getOriginalFilename();
        file.transferTo(new File(dir, savedName));
        return savedName;
    }

    // ==========================================
    // 6. 알림 설정
    // ==========================================

    // 알림 설정 페이지 이동
    @GetMapping("/alarm/setting")
    public String alarmSettingPage(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/member/login";
        }

        // 최신 정보 조회 (설정값 동기화)
        MemberVO member = memberService.getMemberInfo(loginMember.getMemberId());
        model.addAttribute("member", member);

        return "member/alarm_setting";
    }

    // 알림 설정 변경 (AJAX)
    @PostMapping("/alarm/update")
    @ResponseBody
    public String updateAlarmAction(@RequestParam("type") String type,
                                    @RequestParam("value") String value, // 'Y' or 'N'
                                    HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "fail:not_login";

        try {
            memberService.updateAlarm(loginMember.getMemberId(), type, value);

            // 세션 정보도 갱신 (선택사항)
            if("marketing".equals(type)) loginMember.setMarketingAgree(value);
            else if("game".equals(type)) loginMember.setGameAlarm(value);
            else if("friend".equals(type)) loginMember.setFriendAlarm(value);
            session.setAttribute("loginMember", loginMember);

            return "ok";
        } catch (Exception e) {
            log.error("알림 설정 변경 오류", e);
            return "fail";
        }
    }

    // 팔로우/팔로잉 목록 페이지
    @GetMapping("/follow/list")
    public String followListPage(@RequestParam(value = "type", defaultValue = "following") String type,
                                 @RequestParam(value = "memberId", required = false) Long memberId,
                                 HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // memberId 파라미터가 없으면 내 목록 조회
        Long targetId = (memberId != null) ? memberId : loginMember.getMemberId();

        List<com.viotory.diary.dto.FollowDTO> list;
        if ("follower".equals(type)) {
            // 팔로워 목록 조회 (맞팔 확인을 위해 내 ID도 전달)
            list = memberService.getFollowerList(targetId, loginMember.getMemberId());
        } else {
            // 팔로잉 목록 조회
            list = memberService.getFollowingList(targetId);
        }

        model.addAttribute("list", list);
        model.addAttribute("type", type);
        model.addAttribute("targetId", targetId);

        // 상단 타이틀용 (내 목록인지 남의 목록인지 확인)
        boolean isMyList = targetId.equals(loginMember.getMemberId());
        model.addAttribute("isMyList", isMyList);

        return "member/follow_list";
    }

    // [신규 API] 팔로우 토글
    @PostMapping("/follow/toggle")
    @ResponseBody
    public String toggleFollow(@RequestParam("targetId") Long targetId, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "fail:login";

        if (loginMember.getMemberId().equals(targetId)) {
            return "fail:self"; // 자기 자신 팔로우 불가
        }

        boolean result = memberService.toggleFollow(loginMember.getMemberId(), targetId);
        return result ? "followed" : "unfollowed";
    }

    // ==========================================
    // 8. 댓글 관리
    // ==========================================

    // 댓글 관리 페이지 이동 (내가 쓴 댓글 리스트)
    @GetMapping("/review/list")
    public String reviewListPage(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        List<CommentDTO> list = commentService.getMyComments(loginMember.getMemberId());
        model.addAttribute("list", list);

        return "member/review_list";
    }

    // 댓글 삭제 처리
    @PostMapping("/review/delete")
    @ResponseBody
    public String deleteReview(@RequestParam("commentId") Long commentId, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "fail:login";

        try {
            // 서비스에서 '댓글 작성자' 또는 '일기 주인'인지 확인하고 삭제함
            commentService.deleteComment(commentId, loginMember.getMemberId());
            return "ok";
        } catch (Exception e) {
            return "fail";
        }
    }

    // 회원 탈퇴 처리
    @GetMapping("/withdraw")
    public String withdrawAction(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        try {
            memberService.withdraw(loginMember.getMemberId());
            session.invalidate(); // 세션 만료
            return "redirect:/member/login?msg=withdrawn";
        } catch (Exception e) {
            // 탈퇴 실패 시 마이페이지로 돌아감 (에러 메시지는 alert 등으로 처리 필요)
            return "redirect:/member/mypage";
        }
    }
    
}