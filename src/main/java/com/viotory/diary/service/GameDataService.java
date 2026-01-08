package com.viotory.diary.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.viotory.diary.dto.ApiBaseballDTO;
import com.viotory.diary.mapper.GameMapper;
import com.viotory.diary.vo.GameVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Lazy;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

@Slf4j
@Service
@RequiredArgsConstructor
public class GameDataService {

    private final GameMapper gameMapper;

    private final ObjectMapper objectMapper;

    private final RestTemplate restTemplate = new RestTemplate(); // 재사용을 위해 필드로 선언

    /**
     * [핵심 수정] 내부 호출(Self-Invocation) 문제를 해결하기 위해 자기 자신을 주입받습니다.
     * @Lazy를 붙여 순환 참조 오류를 방지합니다.
     */
    @Autowired
    @Lazy
    private GameDataService self;

    /**
     * [스케줄러용] 일일 자동 동기화
     */
    @Transactional
    public void syncDailyData() {
        LocalDate today = LocalDate.now();
        String from = today.minusDays(1).toString();
        String to = today.plusDays(1).toString();
        executeSync(from, to);
    }

    /**
     * [관리자용] 특정 기간 데이터 수동 동기화
     */
    @Transactional
    public void syncManualData(String fromDate, String toDate) {
        executeSync(fromDate, toDate);
    }

    /**
     * 특정 연도 전체 데이터 일괄 동기화 (초기 데이터 적재용)
     * 보통 KBO는 3월(시범경기/개막)부터 11월(포스트시즌)까지 진행됩니다.
     */
    public void syncYearlyData(String year) {
        log.info(">>>>>>>>>> [연간 데이터 일괄 수집 시작] {}년도 <<<<<<<<<<", year);

        // 3월부터 11월까지 반복문 실행
        for (int m = 3; m <= 11; m++) {
            String month = String.format("%02d", m);
            log.info(">>> {}년 {}월 데이터 수집 중...", year, month);

            // 기존에 만든 월별 수집 로직 호출
            self.syncMonthlyData(year, month);

            // 월간 이동 시 서버 부하 및 차단 방지를 위해 약간의 휴식 (1초)
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }

        log.info(">>>>>>>>>> [연간 데이터 일괄 수집 완료] {}년도 <<<<<<<<<<", year);
    }

    /**
     * [관리자용] 특정 월 전체 수집 기능
     */
    @Transactional
    public void syncMonthlyData(String year, String month) {
        try {
            YearMonth yearMonth = YearMonth.of(Integer.parseInt(year), Integer.parseInt(month));
            String from = yearMonth.atDay(1).toString();
            String to = yearMonth.atEndOfMonth().toString();
            executeSync(from, to);
        } catch (Exception e) {
            log.error(">>> 월별 수집 파라미터 에러 ({}년 {}월): {}", year, month, e.getMessage());
        }
    }

    /**
     * 공통 실행 로직: 기간을 입력받아 네이버 API와 통신 후 DB 저장
     */
    private void executeSync(String fromDate, String toDate) {
        AtomicInteger successCount = new AtomicInteger(0);
        try {
            URI uri = UriComponentsBuilder.fromHttpUrl("https://api-gw.sports.naver.com/schedule/games")
                    .queryParam("fields", "basic,schedule,baseball,manualRelayUrl")
                    .queryParam("upperCategoryId", "kbaseball")
                    .queryParam("categoryId", "kbo")
                    .queryParam("fromDate", fromDate)
                    .queryParam("toDate", toDate)
                    .queryParam("size", "100")
                    .build()
                    .toUri();

            HttpHeaders headers = new HttpHeaders();
            headers.set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36");
            headers.set("Referer", "https://m.sports.naver.com/kbaseball/index");
            HttpEntity<String> entity = new HttpEntity<>(headers);

            ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);

            if (response.getBody() != null) {
                JsonNode root = objectMapper.readTree(response.getBody());
                JsonNode gamesNode = root.path("result").path("games");

                if (gamesNode.isArray()) {
                    for (JsonNode g : gamesNode) {
                        if (saveNaverGame(g)) {
                            successCount.incrementAndGet();
                        }
                    }
                }
            }
            log.info(">>> 경기 데이터 동기화 완료 (기간: {} ~ {}, 처리: {}건)", fromDate, toDate, successCount.get());
        } catch (Exception e) {
            log.error(">>> 데이터 동기화 중 에러 발생: {}", e.getMessage());
        }
    }

    /**
     * 개별 경기를 상세 정보까지 포함하여 저장
     */
    private boolean saveNaverGame(JsonNode g) {
        try {
            String apiGameId = g.path("gameId").asText(null);
            String homeName = g.path("homeTeamName").asText("");
            String awayName = g.path("awayTeamName").asText("");

            String homeCode = mapNaverTeamName(homeName);
            String awayCode = mapNaverTeamName(awayName);

            if (homeCode == null || awayCode == null) return false;

            String gameDateTime = g.path("gameDateTime").asText(""); // "2025-04-01T18:30:00"
            String gameDate = g.path("gameDate").asText(); // "2025-04-01"
            String gameTime = (gameDateTime.length() >= 19) ? gameDateTime.substring(11, 19) : "18:30:00";

            int homeScore = g.path("homeTeamScore").asInt(0);
            int awayScore = g.path("awayTeamScore").asInt(0);

            String statusCode = g.path("statusCode").asText("BEFORE"); // BEFORE, STARTED, RESULT, FINISHED
            boolean isCancel = g.path("cancel").asBoolean(false);

            String status = "SCHEDULED";
            String mvpName = null;

            // 2. 상태 코드 일관성: RESULT도 종료된 경기로 처리
            if (isCancel) {
                status = "CANCELLED";
            } else if ("RESULT".equals(statusCode) || "FINISHED".equals(statusCode)) {
                status = "FINISHED";
                // 경기 종료 시 MVP 조회 (상세 API 호출)
                mvpName = getMvpFromDetail(apiGameId);
                if (mvpName == null) {
                    mvpName = g.path("winPitcherName").asText(null); // 승리투수로 대체
                }
            } else if ("STARTED".equals(statusCode) || "ONGOING".equals(statusCode)) {
                status = "LIVE";
                mvpName = "경기 중";
                log.info(">>> [실시간 업데이트] {} {}:{} {} (상태: {})", homeCode, homeScore, awayScore, awayCode, statusCode);
            }

            // 구장 ID 매핑 (홈팀 기준)
            int stadiumId = mapStadiumId(homeCode);

            GameVO game = GameVO.builder()
                    .apiGameId(apiGameId)
                    .gameDate(gameDate)
                    .gameTime(gameTime)
                    .homeTeamCode(homeCode)
                    .awayTeamCode(awayCode)
                    .scoreHome(homeScore)
                    .scoreAway(awayScore)
                    .status(status)
                    .cancelReason(isCancel ? g.path("statusInfo").asText() : null)
                    .mvpPlayer(mvpName)
                    .stadiumId(stadiumId)
                    .build();

            gameMapper.upsertGame(game);
            return true;
        } catch (Exception e) {
            log.error(">>> 경기 저장 실패 (JSON: {}): {}", g.toString(), e.getMessage());
            return false;
        }
    }

    private String getMvpFromDetail(String gameId) {
        try {
            String detailUrl = "https://api-gw.sports.naver.com/game/kbaseball/" + gameId;
            HttpHeaders headers = new HttpHeaders();
            headers.set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36");
            headers.set("Referer", "https://m.sports.naver.com/kbaseball/game/" + gameId);
            HttpEntity<String> entity = new HttpEntity<>(headers);

            ResponseEntity<String> response = restTemplate.exchange(detailUrl, HttpMethod.GET, entity, String.class);
            if (response.getBody() != null) {
                JsonNode root = objectMapper.readTree(response.getBody());
                return root.path("result").path("todayMvp").path("name").asText(null);
            }
        } catch (Exception e) {
            // 상세 정보 호출 실패는 로그만 남기고 무시 (크리티컬하지 않음)
            log.debug("MVP 조회 실패: {}", gameId);
        }
        return null;
    }

    /**
     * 네이버 팀 명칭을 시스템 팀 코드로 매핑
     */
    private String mapNaverTeamName(String name) {
        if (name == null) return null;
        if (name.contains("LG")) return "LG";
        if (name.contains("KT")) return "KT";
        if (name.contains("SSG")) return "SSG";
        if (name.contains("NC")) return "NC";
        if (name.contains("두산")) return "DOOSAN";
        if (name.contains("KIA")) return "KIA";
        if (name.contains("롯데")) return "LOTTE";
        if (name.contains("삼성")) return "SAMSUNG";
        if (name.contains("한화")) return "HANWHA";
        if (name.contains("키움")) return "KIWOOM";
        return null;
    }

    // 홈팀 코드로 구장 ID 매핑 (DB의 stadiums 테이블 ID와 일치시켜야 함)
    // 임시로 하드코딩된 ID를 리턴합니다. 추후 DB 조회로 변경 가능.
    private int mapStadiumId(String homeTeamCode) {
        switch (homeTeamCode) {
            case "LG": case "DOOSAN": return 1; // 잠실
            case "KIWOOM": return 2; // 고척
            case "SSG": return 3; // 문학
            case "KT": return 4; // 수원
            case "HANWHA": return 5; // 대전
            case "SAMSUNG": return 6; // 대구
            case "KIA": return 7; // 광주
            case "LOTTE": return 8; // 사직
            case "NC": return 9; // 창원
            default: return 1; // 기본값
        }
    }


    /*****************************************************************************************
     * ***************************************************************************************
     * ***************************************************************************************
     * Rapid API
     * ***************************************************************************************
     * ***************************************************************************************
     * ***************************************************************************************/

    @Value("${api.sports.url}")
    private String apiUrl;

    @Value("${api.sports.key}")
    private String apiKey;

    @Value("${api.sports.host}")
    private String apiHost;

    private static final int KBO_LEAGUE_ID = 293; // API-Baseball의 KBO 리그 ID
    private static final String SEASON = "2025";  // 대상 시즌

    /**
     * 특정 날짜의 경기 데이터를 가져와 DB에 저장/업데이트함
     * @param date 조회할 날짜
     */
    @Transactional
    public void fetchFromRapid(LocalDate date) {
        String dateStr = date.format(DateTimeFormatter.ISO_DATE); // "YYYY-MM-DD"
        log.info(">>> KBO 경기 데이터 업데이트 시작 (날짜: {})", dateStr);

        // 1. API 요청 헤더 설정 (RapidAPI 인증 정보)
        HttpHeaders headers = new HttpHeaders();
        headers.set("x-rapidapi-key", apiKey);
        headers.set("x-rapidapi-host", apiHost);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        // 2. API URL 조립
        String url = String.format("%s?league=%d&season=%s&date=%s&timezone=Asia/Seoul",
                apiUrl, KBO_LEAGUE_ID, SEASON, dateStr);

        try {
            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<ApiBaseballDTO> response = restTemplate.exchange(
                    url, HttpMethod.GET, entity, ApiBaseballDTO.class);

            if (response.getBody() != null && response.getBody().getResponse() != null) {
                List<ApiBaseballDTO.ResponseData> games = response.getBody().getResponse();
                log.info(">>> API 응답 수신 성공: {} 건의 경기 발견", games.size());

                for (ApiBaseballDTO.ResponseData data : games) {
                    processGameData(data);
                }
            } else {
                log.warn(">>> 해당 날짜에 데이터가 없거나 API 응답이 비어있습니다.");
            }
        } catch (Exception e) {
            log.error(">>> API 호출 또는 데이터 처리 중 오류 발생", e);
        }
    }

    /**
     * API 개별 경기 데이터를 GameVO로 변환하여 Upsert 실행
     */
    private void processGameData(ApiBaseballDTO.ResponseData data) {
        try {
            // 1. 팀 이름 매핑 (API 명칭 -> 우리 시스템 코드)
            String homeCode = mapRapidTeamName(data.getTeams().getHome().getName());
            String awayCode = mapRapidTeamName(data.getTeams().getAway().getName());

            if (homeCode == null || awayCode == null) {
                log.warn(">>> 미등록 팀 발견으로 스킵: {} vs {}",
                        data.getTeams().getHome().getName(), data.getTeams().getAway().getName());
                return;
            }

            // 2. 경기 상태 및 시간 파싱
            // API 일시 형식: "2025-05-05T18:30:00+09:00"
            String fullDate = data.getFixture().getDate();
            String gameDate = fullDate.substring(0, 10);
            String gameTime = fullDate.substring(11, 19);

            // 3. GameVO 빌더를 사용하여 객체 생성 (수정된 필드 반영)
            GameVO game = GameVO.builder()
                    .apiGameId(String.valueOf(data.getFixture().getId()))  // API 고유 ID 저장
                    .gameDate(gameDate)
                    .gameTime(gameTime)
                    .stadiumId(1) // 우선 기본값 처리 (추후 구장 매핑 로직 추가 가능)
                    .homeTeamCode(homeCode)
                    .awayTeamCode(awayCode)
                    .scoreHome(data.getScores().getHome().getTotal() != null ? data.getScores().getHome().getTotal() : 0)
                    .scoreAway(data.getScores().getAway().getTotal() != null ? data.getScores().getAway().getTotal() : 0)
                    .status(convertStatus(data.getStatus().getShortStatus()))
                    .build();

            // 4. DB 저장 (이미 존재하면 업데이트)
            gameMapper.upsertGame(game);
            log.info(">>> 경기 데이터 저장 완료: {} ({} {}:{})",
                    gameDate, homeCode, game.getScoreHome(), game.getScoreAway());

        } catch (Exception e) {
            log.error(">>> 개별 경기 데이터 처리 중 오류 발생", e);
        }
    }

    /**
     * API 상태 코드를 우리 시스템 상태 코드로 변환
     */
    private String convertStatus(String apiStatus) {
        switch (apiStatus) {
            case "FT": return "FINISHED";  // 종료
            case "NS": return "SCHEDULED"; // 예정
            case "LIVE": case "1IN": case "9IN": return "LIVE"; // 진행중
            case "CANC": case "PST": return "CANCELLED"; // 취소/연기
            default: return "SCHEDULED";
        }
    }

    /**
     * API 팀 명칭을 우리 시스템 코드로 매핑
     */
    private String mapRapidTeamName(String apiTeamName) {
        if (apiTeamName.contains("LG")) return "LG";
        if (apiTeamName.contains("KT") || apiTeamName.contains("Wiz")) return "KT";
        if (apiTeamName.contains("SSG") || apiTeamName.contains("Landers")) return "SSG";
        if (apiTeamName.contains("NC")) return "NC";
        if (apiTeamName.contains("Doosan")) return "DOOSAN";
        if (apiTeamName.contains("KIA")) return "KIA";
        if (apiTeamName.contains("Lotte")) return "LOTTE";
        if (apiTeamName.contains("Samsung")) return "SAMSUNG";
        if (apiTeamName.contains("Hanwha")) return "HANWHA";
        if (apiTeamName.contains("Kiwoom")) return "KIWOOM";
        return null;
    }

}