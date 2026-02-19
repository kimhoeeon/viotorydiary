package com.viotory.diary.controller;

import com.viotory.diary.dto.CommentDTO;
import com.viotory.diary.service.CommentService;
import com.viotory.diary.service.MemberService;
import com.viotory.diary.service.SmsService;
import com.viotory.diary.service.TeamInfoMngService;
import com.viotory.diary.util.FileUtil;
import com.viotory.diary.vo.Criteria;
import com.viotory.diary.vo.MemberVO;
import com.viotory.diary.vo.TeamVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;
    private final SmsService smsService;
    private final CommentService commentService;
    private final TeamInfoMngService teamInfoMngService;

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
    @ResponseBody
    public Map<String, Object> loginAction(MemberVO member,
                                           @RequestParam(value = "remember", required = false) String remember,
                                           HttpServletRequest request,
                                           HttpServletResponse response) {

        Map<String, Object> result = new HashMap<>();

        try {
            // 로그인 서비스 호출
            MemberVO loginMember = memberService.login(member.getEmail(), member.getPassword());

            // 세션에 회원 정보 저장
            HttpSession session = request.getSession();
            session.setAttribute("loginMember", loginMember);

            // 자동 로그인 처리 (쿠키 설정)
            if ("on".equals(remember) || "true".equals(remember)) {
                // 30일간 유지되는 쿠키 생성 (보안을 위해 추후 암호화된 토큰 사용 권장)
                Cookie cookie = new Cookie("remember_me", loginMember.getEmail());
                cookie.setMaxAge(60 * 60 * 24 * 30); // 30일 (초 단위)
                cookie.setPath("/"); // 모든 경로에서 유효
                response.addCookie(cookie);
            } else {
                // 체크 해제 시 기존 쿠키 삭제
                Cookie cookie = new Cookie("remember_me", null);
                cookie.setMaxAge(0);
                cookie.setPath("/");
                response.addCookie(cookie);
            }

            // 성공 응답 및 리다이렉트 주소 설정
            result.put("status", "ok");
            if ("NONE".equals(loginMember.getMyTeamCode())) {
                result.put("redirect", "/member/team-setting");
            } else {
                result.put("redirect", "/main");
            }

        } catch (Exception e) {
            log.warn("로그인 실패: {}", e.getMessage());
            // 실패 응답
            result.put("status", "fail");
            result.put("message", e.getMessage());
        }

        return result;
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // 로그아웃 시 자동 로그인 쿠키 삭제
        javax.servlet.http.Cookie cookie = new javax.servlet.http.Cookie("remember_me", null);
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);

        return "redirect:/member/login";
    }

    // [카카오 로그인 콜백]
    @GetMapping("/kakao/callback")
    public String kakaoCallback(@RequestParam String code, HttpSession session, Model model) {
        try {
            //log.info("카카오 인증 코드 수신: {}", code);

            // 1. 서비스 호출
            MemberVO member = memberService.processKakaoLogin(code);

            // [핵심 변경] 2. 신규 회원(memberId 없음) -> 회원가입 단계로 이동
            if (member.getMemberId() == null) {
                model.addAttribute("kakaoInfo", member);
                return "member/join_social_bridge"; // 정보를 세션스토리지에 담는 중간 페이지
            }

            // 3. 기존 회원 -> 로그인 처리
            session.setAttribute("loginMember", member);
            memberService.updateLastLogin(member.getMemberId());

            // 4. 팀 설정 여부에 따른 이동
            if (member.getMyTeamCode() == null || "NONE".equals(member.getMyTeamCode())) {
                return "redirect:/member/team-setting";
            }
            return "redirect:/main";

        } catch (Exception e) {
            log.error("카카오 로그인 실패", e);
            model.addAttribute("message", "카카오 로그인에 실패했습니다.");
            return "member/login";
        }
    }

    // ==========================================
    // 2. 회원가입 (단계별 Wizard)
    // ==========================================

    // 단계별 페이지 매핑
    @GetMapping("/join")
    public String joinMain() { return "redirect:/member/join/step1"; }

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

    @GetMapping("/join/complete")
    public String joinComplete(@RequestParam(value = "name", required = false) String name, Model model) {
        model.addAttribute("nickname", name); // 완료 페이지에 표시할 이름
        return "member/join_complete";
    }

    /**
     * 이메일 중복 체크
     */
    @PostMapping("/check/email")
    @ResponseBody
    public String checkEmail(@RequestParam("email") String email) {
        MemberVO existing = memberService.getMemberByEmail(email);
        return (existing == null) ? "ok" : "fail";
    }

    /**
     * 닉네임 중복 체크 (실제 DB 조회)
     */
    @PostMapping("/check/nickname")
    @ResponseBody
    public String checkNickname(@RequestParam("nickname") String nickname) {
        // MemberService에 닉네임 체크 메서드가 없다면 추가 필요
        // 예: memberService.countByNickname(nickname)
        try {
            int count = memberService.countByNickname(nickname);
            return (count == 0) ? "ok" : "fail";
        } catch (Exception e) {
            log.error("닉네임 체크 중 오류", e);
            return "error";
        }
    }

    @PostMapping("/join")
    @ResponseBody
    public String joinAction(MemberVO member, BindingResult result) {
        // 1. 데이터 바인딩 에러(400 Bad Request 원인) 체크
        if (result.hasErrors()) {
            StringBuilder sb = new StringBuilder();
            result.getAllErrors().forEach(error -> {
                sb.append(error.getDefaultMessage()).append("\n");
            });
            return "입력 정보가 올바르지 않습니다.\n" + sb.toString();
        }

        try {

            // 필수 데이터 서버 측 2차 검증 (Validation)
            if(member.getEmail() == null || member.getPassword() == null || member.getNickname() == null) {
                return "fail:missing_data";
            }

            memberService.registerMember(member);
            return "ok"; // 성공 시 "ok" 문자열 반환 (AJAX에서 확인)
        } catch (Exception e) {
            log.error("회원가입 실패", e);
            return "가입 처리에 실패했습니다: " + e.getMessage();
        }
    }

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
    @ResponseBody
    public String updatePasswordAction(@RequestParam("currentPassword") String currentPassword,
                                       @RequestParam("newPassword") String newPassword,
                                       HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "로그인이 필요한 서비스입니다.";
        }

        try {
            // 비밀번호 변경 서비스 호출
            memberService.changePassword(loginMember.getMemberId(), currentPassword, newPassword);

            session.invalidate();

            return "ok";

        } catch (Exception e) {
            // Service에서 비밀번호가 틀렸을 때 예외(Exception)를 던진다면 여기서 잡힘
            e.printStackTrace();

            // 예외 메시지(예: "기존 비밀번호가 일치하지 않습니다.")를 그대로 화면에 전달
            // 만약 Service가 구체적인 메시지를 주지 않는다면 "기존 비밀번호가 일치하지 않습니다."로 하드코딩해도 됩니다.
            return e.getMessage();
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
    public String resetPassword(@RequestParam("memberId") String memberId,
                                @RequestParam("phoneNumber") String phoneNumber,
                                @RequestParam("authCode") String authCode,
                                Model model) {

        // [추가] 0. 카카오 소셜 로그인 회원 여부 확인
        // memberId는 이메일 형식이므로 이메일로 조회
        MemberVO member = memberService.getMemberByEmail(memberId);

        if (member != null && "KAKAO".equals(member.getSocialProvider())) {
            // 카카오 계정이면 플래그를 담아 View로 리턴 (JSP에서 스크립트 처리)
            model.addAttribute("isKakao", true);
            return "member/find_password";
        }

        // 1. SMS 인증번호 검증
        String cleanNumber = phoneNumber.replaceAll("-", "");
        boolean isVerified = smsService.verifyCode(cleanNumber, authCode);

        if (!isVerified) {
            model.addAttribute("error", "인증번호가 일치하지 않거나 만료되었습니다.");
            return "member/find_password";
        }

        // 2. 회원 확인 및 임시 비밀번호 발송
        try {
            boolean success = memberService.resetAndSendPassword(memberId, cleanNumber);
            if (success) {
                model.addAttribute("name", memberId);
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

        // 팀 목록 조회하여 모델에 추가 (10개 구단 모두 조회)
        Criteria cri = new Criteria();
        cri.setAmount(20); // 10개 구단 충분히 조회되도록 설정
        List<TeamVO> teamList = teamInfoMngService.selectTeamList(cri);
        model.addAttribute("teamList", teamList);
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
            // 에러 시 다시 목록 불러와서 페이지 이동
            Criteria cri = new Criteria();
            cri.setAmount(20);
            List<TeamVO> teamList = teamInfoMngService.selectTeamList(cri);
            model.addAttribute("teamList", teamList);
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
    @ResponseBody
    public String updateProfileAction(@RequestParam("nickname") String nickname,
                                      @RequestParam(value = "file", required = false) MultipartFile file, // 파일 추가
                                      HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "로그인이 필요한 서비스입니다.";

        try {
            // 1. 이미지 파일 업로드 처리
            String profileImagePath = null;
            if (file != null && !file.isEmpty()) {
                profileImagePath = FileUtil.uploadFile(file, "member");
            }

            // 2. 서비스 호출 (닉네임 + 이미지 업데이트)
            MemberVO updateVO = new MemberVO();
            updateVO.setMemberId(loginMember.getMemberId());
            updateVO.setNickname(nickname);
            if (profileImagePath != null) {
                updateVO.setProfileImage(profileImagePath);
            }

            memberService.updateMemberInfo(updateVO); // Mapper 쿼리가 수정되었으므로 이것만 호출하면 됨

            // 3. 세션 정보 최신화
            loginMember.setNickname(nickname);
            if (profileImagePath != null) {
                loginMember.setProfileImage(profileImagePath);
            }
            session.setAttribute("loginMember", loginMember);

            return "ok";

        } catch (Exception e) {
            log.error("프로필 수정 실패", e);
            return "프로필 수정 중 오류가 발생했습니다."; // 실패 시 에러 메시지 반환
        }
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

        // [중요] 2. Null 체크 및 대문자 변환 (방어 로직)
        if (type == null || type.trim().isEmpty()) {
            return "fail:invalid_type";
        }

        try {

            // 대소문자 통일을 위해 대문자로 변환 (PUSH, GAME, FRIEND, MARKETING)
            String upperType = type.toUpperCase();

            // 1. DB 업데이트 (Service 호출)
            memberService.updateAlarm(loginMember.getMemberId(), type, value);

            // 세션 정보도 갱신 (선택사항)
            switch (upperType) {
                case "PUSH": loginMember.setPushYn(value); break;
                case "GAME": loginMember.setGameAlarm(value); break;
                case "FRIEND": loginMember.setFriendAlarm(value); break;
                case "MARKETING": loginMember.setMarketingAgree(value); break;
            }
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

    // 사용자 검색 페이지
    @GetMapping("/search")
    public String searchPage() {
        return "member/search";
    }

    // 검색 수행 (결과 조회)
    @GetMapping("/search/result")
    public String searchResult(@RequestParam("keyword") String keyword,
                               HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        List<MemberVO> result = memberService.searchMembers(keyword, loginMember.getMemberId());
        model.addAttribute("list", result);
        model.addAttribute("keyword", keyword);

        return "member/search"; // 같은 페이지에 결과 뿌리기
    }

    /**
     * [App] 푸시 토큰 갱신 API
     * 앱 실행 시 또는 토큰 갱신 시 호출됨
     */
    @PostMapping("/updateToken")
    @ResponseBody
    public String updateToken(@RequestParam("token") String token, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "fail:not_login"; // 로그인 안 된 상태면 패스
        }

        try {
            log.info("푸시 토큰 갱신 요청: memberId={}, token={}", loginMember.getMemberId(), token);
            memberService.updatePushToken(loginMember.getMemberId(), token);
            return "ok";
        } catch (Exception e) {
            log.error("푸시 토큰 갱신 실패", e);
            return "fail";
        }
    }

    // ==========================================
    // 9. [Appify] 기기 정보 수집 API
    // ==========================================
    @PostMapping("/device/update")
    @ResponseBody
    public String updateDeviceInfo(@RequestParam Map<String, String> params, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");

        // 비로그인 상태라도 앱 실행 로그 목적으로 남길 수도 있지만,
        // 여기서는 회원 정보에 업데이트하므로 로그인 체크를 합니다.
        if (loginMember == null) {
            return "fail:not_login";
        }

        try {
            // Service 호출 (Map 파라미터 그대로 전달)
            memberService.updateDeviceInfo(loginMember.getMemberId(), params);
            return "ok";
        } catch (Exception e) {
            log.error("기기 정보 업데이트 실패", e);
            return "fail";
        }
    }
    
}