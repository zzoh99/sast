package com.hr.wtm.calc.workTime;

import com.github.f4b6a3.tsid.TsidCreator;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.main.filter.TimerFilter;
import com.hr.wtm.calc.dto.*;
import com.hr.wtm.calc.key.WtmCalcGroupKey;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import java.time.DayOfWeek;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.time.temporal.TemporalAdjusters;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 근무/휴게시간 계산 처리 클래스 (계산 및 검증 로직)
 */
@Component
public class WtmCalcWorkTime {

    private final TimerFilter time;
    /* 기초 코드 설정(공통코드-TWTM0511)의 값이 변경되면 해당 값을 수정해주어야 함. */
    private final String WORK_TIME_TYPE_BASE = "SYS01"; // 근무시간유형이 기본근무인 코드(TWTM0511)
    private final String WORK_TIME_TYPE_OT = "SYS02"; // 근무시간유형이 연장근무인 코드
    private final String WORK_TIME_TYPE_BREAK = "SYS03"; // 근무시간유형이 휴게인 코드

    private String baseWorkCd = ""; // 기본근무 코드
    private String otWorkCd = "";   // 연장근무 코드
    private String breakWorkCd = ""; // 휴게시간 코드

    String realTimeCount = "Y"; // 실근로시간기반 집계


    private WtmCalcWorkTime(TimerFilter time) {
        this.time = time;
    }

    public String getBaseWorkCd() {
        return baseWorkCd;
    }

    public void setBaseWorkCd(String baseWorkCd) {
        this.baseWorkCd = baseWorkCd;
    }

    public TimerFilter getTime() {
        return time;
    }

    public String getOtWorkCd() {
        return otWorkCd;
    }

    public void setOtWorkCd(String otWorkCd) {
        this.otWorkCd = otWorkCd;
    }

    public String getBreakWorkCd() {
        return breakWorkCd;
    }

    public void setBreakWorkCd(String breakWorkCd) {
        this.breakWorkCd = breakWorkCd;
    }

    /**
     * 일계획 근무시간 합산
     * @param wtmWrkDtlDTOList 근무상세리스트
     */
    public List<WtmDailyCountDTO> sumWtmDayWorkTime(List<WtmWrkDtlDTO> wtmWrkDtlDTOList) throws Exception {

        List<WtmDailyCountDTO> wtmDailyCountDTOList = new ArrayList<>();
        try {
            DateTimeFormatter fullFormatter = DateTimeFormatter.ofPattern("yyyyMMddHHmm");

            // 근무리스트를 회사코드, 사번, 일자별로 그룹핑
            Map<WtmCalcGroupKey, List<WtmWrkDtlDTO>> wrkDtlGroup = new HashMap<>();
            for (WtmWrkDtlDTO dto : wtmWrkDtlDTOList) {
                WtmCalcGroupKey key = new WtmCalcGroupKey(dto.getEnterCd(), dto.getSabun(), dto.getYmd());
                wrkDtlGroup.computeIfAbsent(key, k -> new ArrayList<>()).add(dto);
            }

            // 그룹별 처리
            for (Map.Entry<WtmCalcGroupKey, List<WtmWrkDtlDTO>> entry : wrkDtlGroup.entrySet()) {
                WtmCalcGroupKey key = entry.getKey();
                List<WtmWrkDtlDTO> list = entry.getValue();

                WtmDailyCountDTO wtmDailyCountDTO = new WtmDailyCountDTO();
                wtmDailyCountDTO.setEnterCd(key.getEnterCd());
                wtmDailyCountDTO.setSabun(key.getSabun());
                wtmDailyCountDTO.setYmd(key.getYmd());

                for (WtmWrkDtlDTO dto : list) {
                    // 기본근무로 집계
                    LocalDateTime workSdateTime = LocalDateTime.parse(dto.getPlanSymd() + dto.getPlanShm(), fullFormatter); // 기본근무 시작시간
                    LocalDateTime workEdateTime = LocalDateTime.parse(dto.getPlanEymd() + dto.getPlanEhm(),fullFormatter); // 기본근무 종료시간

                    // 차감 시간 계산
                    Map<String, Integer> dedResult = calcWrkBreakDedMin(list, workSdateTime, workEdateTime, false);

                    if(dto.getWorkCd().equals(getBaseWorkCd())) { // 기본근무 코드인 경우
                        int basicWorkMm = dto.getPlanMm() - dedResult.get("dedMm");
                        wtmDailyCountDTO.setBasicMm(basicWorkMm);
                    } else if (dto.getWorkCd().equals(getOtWorkCd())) {
                        int otMm = dto.getPlanMm() - dedResult.get("dedMm");
                        wtmDailyCountDTO.setOtMm(otMm);
                    }
                }

                wtmDailyCountDTOList.add(wtmDailyCountDTO);
            }

        }  catch (Exception e) {
            Log.Error(e.toString());
            throw new HrException("일 계획 근무 시간 합산 중 오류가 발생했습니다. 관리자에게 문의하세요.");
        }

        return wtmDailyCountDTOList;
    }

    /**
     * 회사코드, 사번, 일자별 근무일정 시작/종료 시간 계산
     *
     * @param wtmWrkDtlDTOList 근무상세리스트
     * @param wtmGntDtlDTOList 근태상세리스트
     * @return 근무일정 시작/종료시간과 간주근로여부의 값을 Map으로 반환.
     */
    public Map<WtmCalcGroupKey, Map<String, Object>> getWorkStartAndEndTime(List<WtmWrkDtlDTO> wtmWrkDtlDTOList, List<WtmGntDtlDTO> wtmGntDtlDTOList) throws Exception {
        Map<WtmCalcGroupKey, Map<String, Object>> resultGroup = new HashMap<>();
        try {
            DateTimeFormatter fullFormatter = DateTimeFormatter.ofPattern("yyyyMMddHHmm");

            // 근무 상세 내역을 회사코드, 사번, 일자별로 그룹핑
            Map<WtmCalcGroupKey, List<WtmWrkDtlDTO>> wrkDtlGroup = new HashMap<>();
            for (WtmWrkDtlDTO dto : wtmWrkDtlDTOList) {
                WtmCalcGroupKey key = new WtmCalcGroupKey(dto.getEnterCd(), dto.getSabun(), dto.getYmd());
                wrkDtlGroup.computeIfAbsent(key, k -> new ArrayList<>()).add(dto);
            }

            // 근태상세를 회사코드, 사번, 일자별로 그룹핑
            Map<WtmCalcGroupKey, List<WtmGntDtlDTO>> gntDtlGroup = null;
            if (wtmGntDtlDTOList != null) {
                gntDtlGroup = wtmGntDtlDTOList.stream()
                        .collect(Collectors.groupingBy(dto ->
                                new WtmCalcGroupKey(dto.getEnterCd(), dto.getSabun(), dto.getYmd())
                        ));
            }

            // 그룹별 처리
            for (Map.Entry<WtmCalcGroupKey, List<WtmWrkDtlDTO>> entry : wrkDtlGroup.entrySet()) {
                WtmCalcGroupKey key = entry.getKey();
                List<WtmWrkDtlDTO> group = entry.getValue();
                Map<String, Object> result = new HashMap<>();

                // 기본 정보 설정
                result.put("name", group.get(0).getName());

                // 간주근무 처리
                int deemedWorkMm = 0;
                boolean isDeemedWorkGroup = false;
                List<WtmWrkDtlDTO> dayilyWrkDtlList = new ArrayList<>();

                // 일간주근무 체크 및 근무 데이터 조회
                // -> 일간주근로: 간주근무 여부가 Y 이고, 시작/종료시간이 없는 경우
                for (WtmWrkDtlDTO dto : group) {
                    if ("Y".equals(dto.getDeemedYn()) &&   // 간주근무 여부가 Y 이고
                        dto.getPlanShm() == null || dto.getPlanEhm().isEmpty() // 시작/종료시간이 없는 경우
                    ) {
                        // 종일 간주근로인 경우 처리 할 로직.
                        isDeemedWorkGroup = true;
                        deemedWorkMm += dto.getPlanMm();
                    }
                }

                // 종일 간주근로 시간에서 휴가시간을 차감한다.
                if(gntDtlGroup != null && gntDtlGroup.containsKey(key) && deemedWorkMm > 0) {
                    List<WtmGntDtlDTO> gntDtlList = gntDtlGroup.get(key);
                    int dedVacationMm = gntDtlList.stream()
                            .mapToInt(dto -> dto.getMm())
                            .sum();
                    deemedWorkMm -= dedVacationMm;
                }

                for (WtmWrkDtlDTO dto : group) {
                    // 종일 단위 간주근로인 경우, 근무시간유형이 기본근무, 휴게인 데이터 제외 처리
                    if (!(isDeemedWorkGroup && WORK_TIME_TYPE_BASE.equals(dto.getWorkTimeType()) || WORK_TIME_TYPE_BREAK.equals(dto.getWorkTimeType()))) {
                        dayilyWrkDtlList.add(dto);
                    }
                }

                // 근무데이터가 없는 경우, 근무일정 시작/종료일을 NULL 로 설정한다.
                if (dayilyWrkDtlList.isEmpty()) {
                    result.put("workSdateTime", null);
                    result.put("workEdateTime", null);
                    result.put("isDeemedWork", isDeemedWorkGroup);
                    result.put("deemedWorkMm", deemedWorkMm);
                    result.put("baseWorkSdateTime", null);
                    result.put("baseWorkEdateTime", null);
                } else {
                    // 근무시간 계산
                    LocalDateTime workSdateTime = null;
                    LocalDateTime workEdateTime = null;
                    LocalDateTime baseWorkSdateTime = null;
                    LocalDateTime baseWorkEdateTime = null;

                    for (WtmWrkDtlDTO dto : dayilyWrkDtlList) {

                        LocalDateTime startTime = LocalDateTime.parse(dto.getPlanSymd() + dto.getPlanShm(), fullFormatter);
                        LocalDateTime endTime = LocalDateTime.parse(dto.getPlanEymd() + dto.getPlanEhm(), fullFormatter);

                        // 근무일정 시작시간 계산: 근무 시작 시간 중 가장 이른 시간을 근무 일정 시작 시간으로 지정한다.
                        if (workSdateTime == null || startTime.isBefore(workSdateTime)) {
                            workSdateTime = startTime;
                        }

                        // 근무일정 종료시간 계산: 근무 종료 시간 중 가장 늦은 시간을 근무 일정 종료 시간으로 지정한다.
                        if (workEdateTime == null || endTime.isAfter(workEdateTime)) {
                            workEdateTime = endTime;
                        }

                        // 기본 근무 시간 계산
                        if (WORK_TIME_TYPE_BASE.equals(dto.getWorkTimeType())) {
                            // 기본근무 시작 시간 계산: 기본 근무 시작 시간 중 가장 이른 시간을 기본 근무 시작 시간으로 지정한다.
                            if (baseWorkSdateTime == null || startTime.isBefore(baseWorkSdateTime)) {
                                baseWorkSdateTime = startTime;
                            }

                            // 기본근무 종료 시간 계산: 기본 근무 종료 시간 중 가장 늦은 시간을 기본 근무 종료 시간으로 지정한다.
                            if (baseWorkEdateTime == null || endTime.isAfter(baseWorkEdateTime)) {
                                baseWorkEdateTime = endTime;
                            }
                        }
                    }
                    
                    // 계산한 근무일정 시작/종료시간을 반환한다.
                    result.put("workSdateTime", workSdateTime);
                    result.put("workEdateTime", workEdateTime);
                    result.put("isDeemedWork", isDeemedWorkGroup);
                    result.put("deemedWorkMm", deemedWorkMm);
                    result.put("baseWorkSdateTime", baseWorkSdateTime);
                    result.put("baseWorkEdateTime", baseWorkEdateTime);
                }
                resultGroup.put(entry.getKey(), result);
            }
        } catch (Exception e) {
            Log.Error(e.toString());
            throw new HrException("근무일정 시작/종료 시간 계산 작업중 오류가 발생했습니다. 관리자에게 문의하세요.");
        }

        return resultGroup;
    }

    /**
     * 출퇴근 타각시간을 바탕으로 근무일정 시작/종료시간을 조정한다.
     *
     * @param workStartAndEndTime 근무일정 시작/종료시간
     * @param targetList          대상자 목록
     * @param workClassInfo       근무유형 정보
     * @param wtmWrkDtlDTOList    근무 상세 데이터
     * @param wtmGntDtlDTOList    근태 상세 데이터
     * @param holidayList         공휴일 데이터
     * @param shiftHoliday        교대조 휴일,휴무일 데이터
     * @param isCountYn           마감 작업 여부
     * @return 보정한 인정 출퇴근 타각시간
     * @throws Exception
     */
    public void adjustWorkStartAndEndTime(
               Map<WtmCalcGroupKey, Map<String, Object>> workStartAndEndTime,
               List<Map<String, Object>> targetList,
               Map<String, Map<String, Object>> workClassInfo,
               List<WtmWrkDtlDTO> wtmWrkDtlDTOList,
               List<WtmGntDtlDTO> wtmGntDtlDTOList,
               List<Map<String, Object>> holidayList,
               Map<WtmCalcGroupKey, String> shiftHoliday,
               boolean isCountYn ) throws Exception {
        try {
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HHmm");
            DateTimeFormatter fullFormatter = DateTimeFormatter.ofPattern("yyyyMMddHHmm");

            for (Map<String, Object> target : targetList) {
                String enterCd = target.get("enterCd").toString();
                String sabun = target.get("sabun").toString();
                String targetYmd = target.get("ymd").toString();
                String inYmd = target.get("inYmd").toString();
                String inHm = target.get("inHm").toString();
                String outYmd = target.get("outYmd").toString();
                String outHm = target.get("outHm").toString();
                String workClassCd = target.get("workClassCd").toString();

                Map<String, Object> workClassInfoMap = workClassInfo.get(workClassCd);

                // 근무상세를 회사코드, 사번, 일자별로 그룹핑
                Map<WtmCalcGroupKey, List<WtmWrkDtlDTO>> wrkDtlGroup = null;
                if (wtmWrkDtlDTOList != null) {
                    wrkDtlGroup = wtmWrkDtlDTOList.stream()
                            .collect(Collectors.groupingBy(dto ->
                                    new WtmCalcGroupKey(dto.getEnterCd(), dto.getSabun(), dto.getYmd())
                            ));
                }

                // 근태상세를 회사코드, 사번, 일자별로 그룹핑
                Map<WtmCalcGroupKey, List<WtmGntDtlDTO>> gntDtlGroup = null;
                if (wtmGntDtlDTOList != null) {
                    gntDtlGroup = wtmGntDtlDTOList.stream()
                            .collect(Collectors.groupingBy(dto ->
                                    new WtmCalcGroupKey(dto.getEnterCd(), dto.getSabun(), dto.getYmd())
                            ));
                }

                // 그룹핑 키 생성 (회사코드, 사번, 일자)
                WtmCalcGroupKey key = new WtmCalcGroupKey(enterCd, sabun, targetYmd);

                /* 근무 요일 정보 설정 (휴일 or 주휴일 or 근무일) */
                String workDay = "W"; // 기본 근무일
                String holiday = "H"; // 공휴일, 주휴일
                String nPayHoliday = "NH"; // 휴무일
                String dayType = workDay; // 기본은 근무일로 설정

                String bpCd = target.get("bpCd").toString();

                // 1. 근무일이 공휴일인지 확인
                boolean isHoliday = false;
                if(holidayList != null && !holidayList.isEmpty()) {
                    isHoliday = holidayList.stream()
                            .anyMatch(map -> {
                                return enterCd.equals(map.get("enterCd"))
                                        && bpCd.equals(map.get("bpCd"))
                                        && (targetYmd.equals(map.get("ymd")) || targetYmd.equals(map.get("rpYmd")));
                            });
                }

                if(isHoliday) {
                    dayType = holiday;
                } else {
                    // 2. 근무유형 설정 상 주휴요일 or 근무요일인지 체크
                    // 근무일의 요일 조회
                    String dayStr = convertToDayOfWeekStr(LocalDate.parse(targetYmd, dateFormatter).getDayOfWeek());

                    if(workClassInfoMap.get("workTypeCd").equals("D")) {
                        // 2. 교대조 근무인 경우, 개인별 교대조 휴무일/휴일 정보를 확인한다.
                        dayType = shiftHoliday.getOrDefault(key, workDay); // 휴무일 or 휴일 정보가 있으면 해당 정보를 그렇지 않다면 기본근무로 설정
                    } else {
                        // 3. 교대조 근무가 아닌 경우 근무유형 설정 상 주휴요일 or 근무요일인지 체크
                        // 근무일의 요일이 근무유형 설정의 근무요일에 속하는지 확인
                        String workDayStr = workClassInfoMap.get("workDay").toString();
                        boolean isWorkDay = workDayStr.contains(",")
                                ? Arrays.asList(workDayStr.split(",")).contains(dayStr)
                                : dayStr.equals(workDayStr);

                        if(isWorkDay) {
                            dayType = workDay;
                        } else {
                            // 근무일의 요일이 근무유형 설정의 주휴일에 속하는지 확인
                            String workRestDayStr = workClassInfoMap.get("weekRestDay").toString();
                            boolean isWorkRestDay = workRestDayStr.contains(",")
                                    ? Arrays.asList(workRestDayStr.split(",")).contains(dayStr)
                                    : dayStr.equals(workRestDayStr);
                            if(isWorkRestDay) {
                                dayType = holiday;
                            } else {
                                // 근무일에도 속하지 않고, 주휴일에도 속하지 않는다면 휴무일로 간주한다.
                                dayType = nPayHoliday;
                            }
                        }
                    }
                }
                /* 근무 요일 정보 설정 종료 */

                // 해당 일자의 근무 모두 가져오기
                List<WtmWrkDtlDTO> targetWrkDtlList = new ArrayList<>();
                if(!wrkDtlGroup.isEmpty() && wrkDtlGroup.containsKey(key)) {
                    targetWrkDtlList = wrkDtlGroup.get(key);
                }

                /* 출퇴근설정) 간주시간 시작 -> 기본근무 미 설정시 간주시간 삽입 */
                String baseWorkSymd = "", baseWorkShm = "", baseWorkEymd = "", baseWorkEhm = "";
                boolean baseWorkPlanYn = !dayType.equals(workDay); // 근무일이 아닌경우 true, 근무일인경우 false 로 초기 설정

                // 기본근무 설정 여부 확인
                if(!baseWorkPlanYn && !targetWrkDtlList.isEmpty()) {
                    baseWorkPlanYn = targetWrkDtlList.stream()
                            .anyMatch(map -> getBaseWorkCd().equals(map.getWorkCd()));
                }

                if(!baseWorkPlanYn) { // 근무일에 기본근무 설정을 하지 않은 경우
                    String deemedTimeF = workClassInfoMap.get("deemedTimeF").toString(); // 간주 시작시간
                    String deemedTimeT = workClassInfoMap.get("deemedTimeT").toString(); // 간주 종료시간
                    String workTimeF = workClassInfoMap.get("workTimeF").toString(); // 출근시간
                    String workTimeT = workClassInfoMap.get("workTimeT").toString(); // 퇴근시간

                    // 간주 시간이 존재하거나 기본근무유형인 경우
                    if((!"".equals(deemedTimeF) && !"".equals(deemedTimeT)) || "R".equals(workClassInfoMap.get("workTypeCd"))){
                        if(!"".equals(deemedTimeF) && !"".equals(deemedTimeT)) {
                            baseWorkSymd = targetYmd;
                            baseWorkShm = deemedTimeF;
                            baseWorkEymd = targetYmd;
                            baseWorkEhm = deemedTimeT;
                        } else if("R".equals(workClassInfoMap.get("workTypeCd")) && !"".equals(workTimeF) && !"".equals(workTimeT)) {
                            // 근무제가 기본근무인 경우, 기본근무 계획이 등록되어있지 않으면 근무유형 상세의 출퇴근시간으로 근무계획을 생성한다.
                            baseWorkSymd = targetYmd;
                            baseWorkShm = workTimeF;
                            baseWorkEymd = targetYmd;
                            baseWorkEhm = workTimeT;
                        }

                        // 근무계획 생성
                        Map<String, String> autoCreMap = new HashMap<>();
                        autoCreMap.put("enterCd", enterCd);
                        autoCreMap.put("ymd", targetYmd);
                        autoCreMap.put("sabun", sabun);
                        autoCreMap.put("workCd", getBaseWorkCd());
                        autoCreMap.put("symd", baseWorkSymd);
                        autoCreMap.put("shm", baseWorkShm);
                        autoCreMap.put("eymd", baseWorkEymd);
                        autoCreMap.put("ehm", baseWorkEhm);
                        autoCreMap.put("addWorkTimeYn", "Y");
                        autoCreMap.put("workTimeType", WORK_TIME_TYPE_BASE);
                        List<WtmWrkDtlDTO> autoCreWtmWrkList = getAutoCreWtmWrkList(autoCreMap, workClassInfoMap);

                        if (wtmWrkDtlDTOList == null) {
                            wtmWrkDtlDTOList = new ArrayList<WtmWrkDtlDTO>();
                        }
                        targetWrkDtlList.addAll(autoCreWtmWrkList);
                        wtmWrkDtlDTOList.addAll(autoCreWtmWrkList);

                        // 작업 대상에 있는지 확인 후, 없으면 작업대상에 추가
                        LocalDateTime in = LocalDateTime.parse(baseWorkSymd+baseWorkShm, fullFormatter);
                        LocalDateTime out = LocalDateTime.parse(baseWorkEymd+baseWorkEhm, fullFormatter);
                        if (workStartAndEndTime != null && !workStartAndEndTime.containsKey(key)) {
                            Map<String, Object> psnlData = new HashMap<>();
                            psnlData.put("workSdateTime", in);
                            psnlData.put("workEdateTime", out);
                            psnlData.put("isDeemedWork", false);
                            psnlData.put("deemedWorkMm", 0);
                            psnlData.put("baseWorkSdateTime", in);
                            psnlData.put("baseWorkEdateTime", out);

                            workStartAndEndTime.put(key, psnlData);
                        } else if (workStartAndEndTime != null && workStartAndEndTime.containsKey(key)){
                            Map<String, Object> psnlData = workStartAndEndTime.get(key);
                            if(psnlData.get("workSdateTime") != null){
                                LocalDateTime oldIn = (LocalDateTime) psnlData.get("workSdateTime");
                                psnlData.put("workSdateTime", in.isBefore(oldIn) ? in : oldIn);
                            } else {
                                psnlData.put("workSdateTime", in);
                            }

                            if(psnlData.get("workEdateTime") != null){
                                LocalDateTime oldOut = (LocalDateTime) psnlData.get("workEdateTime");
                                psnlData.put("workEdateTime", oldOut.isBefore(out) ? out : oldOut);
                            } else {
                                psnlData.put("workEdateTime", out);
                            }

                            psnlData.put("baseWorkSdateTime", in);
                            psnlData.put("baseWorkEdateTime", out);
                        }

                        baseWorkPlanYn= true;
                    }
                }
                /* 출퇴근설정) 간주시간 종료 */

                /* 출퇴근설정) 근무계획미등록여부 시작 */
                String noWorkPlanYn = workClassInfoMap.get("noWorkPlanYn").toString();
                if("Y".equals(noWorkPlanYn) && !baseWorkPlanYn && !"".equals(inYmd) && !"".equals(inHm) && !"".equals(outYmd) && !"".equals(outHm)){
                    baseWorkSymd = inYmd;
                    baseWorkShm = inHm;
                    baseWorkEymd = outYmd;
                    baseWorkEhm = outHm;

                    // 근무계획 생성
                    Map<String, String> autoCreMap = new HashMap<>();
                    autoCreMap.put("enterCd", enterCd);
                    autoCreMap.put("ymd", targetYmd);
                    autoCreMap.put("sabun", sabun);
                    autoCreMap.put("workCd", getBaseWorkCd());
                    autoCreMap.put("symd", baseWorkSymd);
                    autoCreMap.put("shm", baseWorkShm);
                    autoCreMap.put("eymd", baseWorkEymd);
                    autoCreMap.put("ehm", baseWorkEhm);
                    autoCreMap.put("addWorkTimeYn", "Y");
                    autoCreMap.put("workTimeType", WORK_TIME_TYPE_BASE);
                    List<WtmWrkDtlDTO> autoCreWtmWrkList = getAutoCreWtmWrkList(autoCreMap, workClassInfoMap);

                    // 생성한 기본근무계획의 근무 시간을 근무시간기준 일 기본근무시간 한도 이내로 조정한다.
                    int dayWkLmtMm = Integer.parseInt(StringUtils.defaultIfEmpty(workClassInfoMap.get("dayWkLmt").toString(), "-1")) * 60; // 일 기본근무시간 한도
                    
                    // 생성한 근무계획리스트 중 휴게시간 리스트만 추출
                    List<WtmWrkDtlDTO> breakTimeList = autoCreWtmWrkList.stream()
                        .filter(wrkDtl -> WORK_TIME_TYPE_BREAK.equals(wrkDtl.getWorkTimeType()))
                        .collect(Collectors.toList());

                    // 휴게시간 리스트를 시작시간(planSymd + planShm) 순으로 정렬
                    breakTimeList.sort((a, b) -> (a.getPlanSymd() + a.getPlanShm()).compareTo(b.getPlanSymd() + b.getPlanShm()));

                    // 출근 타각시각을 시작시간으로 두고, 휴게시간 리스트를 순회하면서 시간차를 계산
                    LocalDateTime currentTime = LocalDateTime.parse(inYmd + inHm, fullFormatter);
                    LocalDateTime endTime = currentTime;

                    if(breakTimeList != null && !breakTimeList.isEmpty()){
                        for (WtmWrkDtlDTO breakTime : breakTimeList) {
                            LocalDateTime breakStart = LocalDateTime.parse(breakTime.getPlanSymd() + breakTime.getPlanShm(), fullFormatter);

                            // 현재 시간부터 휴게 시작시간까지의 근무시간 계산
                            if (currentTime.isBefore(breakStart)) {
                                int workMinutes = (int) Duration.between(currentTime, breakStart).toMinutes();
                                dayWkLmtMm -= workMinutes;

                                // 만약 이 구간에서 일 기본근무시간 한도를 초과하면
                                if (dayWkLmtMm < 0) {
                                    // 한도가 되는 시점을 계산
                                    endTime = currentTime.plusMinutes(workMinutes + dayWkLmtMm);
                                    break;
                                }

                                // 다음 구간 계산을 위해 현재 시간을 휴게 종료시간으로 업데이트
                                currentTime = LocalDateTime.parse(breakTime.getPlanEymd() + breakTime.getPlanEhm(), fullFormatter);
                                endTime = currentTime;
                            }
                        }
                    } else {
                        // 휴게시간 리스트가 없는 경우(=>출퇴근시간 전체가 근무시간인 경우), 타각시간 + 기본근무시간을 종료시간으로 계산한다.
                        endTime = currentTime.plusMinutes(dayWkLmtMm);
                    }

                    // 계산한 종료시간이 타각 종료시간과 다른 경우, 기본근무종료시간 재계산 및 기본근무계획 재생성
                    LocalDateTime originalEndTime = LocalDateTime.parse(outYmd + outHm, fullFormatter);
                    if (!endTime.equals(originalEndTime)) {
                        baseWorkEymd = endTime.format(dateFormatter);
                        baseWorkEhm = endTime.format(timeFormatter);
                        autoCreMap.put("eymd", baseWorkEymd);
                        autoCreMap.put("ehm", baseWorkEhm);
                        autoCreWtmWrkList = getAutoCreWtmWrkList(autoCreMap, workClassInfoMap);
                    }

                    if (wtmWrkDtlDTOList == null) {
                        wtmWrkDtlDTOList = new ArrayList<WtmWrkDtlDTO>();
                    }
                    targetWrkDtlList.addAll(autoCreWtmWrkList);
                    wtmWrkDtlDTOList.addAll(autoCreWtmWrkList);

                    // 작업 대상에 있는지 확인 후, 없으면 작업대상에 추가
                    LocalDateTime in = LocalDateTime.parse(baseWorkSymd+baseWorkShm, fullFormatter);
                    LocalDateTime out = LocalDateTime.parse(baseWorkEymd+baseWorkEhm, fullFormatter);
                    if (workStartAndEndTime != null && !workStartAndEndTime.containsKey(key)) {
                        Map<String, Object> psnlData = new HashMap<>();
                        psnlData.put("workSdateTime", in);
                        psnlData.put("workEdateTime", out);
                        psnlData.put("isDeemedWork", false);
                        psnlData.put("deemedWorkMm", 0);
                        psnlData.put("baseWorkSdateTime", in);
                        psnlData.put("baseWorkEdateTime", out);

                        workStartAndEndTime.put(key, psnlData);
                    } else{
                        Map<String, Object> psnlData = workStartAndEndTime.get(key);
                        if(psnlData.get("workSdateTime") != null){
                            LocalDateTime oldIn = (LocalDateTime) psnlData.get("workSdateTime");
                            psnlData.put("workSdateTime", in.isBefore(oldIn) ? in : oldIn);
                        } else {
                            psnlData.put("workSdateTime", in);
                        }

                        if(psnlData.get("workEdateTime") != null){
                            LocalDateTime oldOut = (LocalDateTime) psnlData.get("workEdateTime");
                            psnlData.put("workEdateTime", oldOut.isBefore(out) ? out : oldOut);
                        } else {
                            psnlData.put("workEdateTime", out);
                        }

                        psnlData.put("baseWorkSdateTime", in);
                        psnlData.put("baseWorkEdateTime", out);
                    }
                }
                /* 출퇴근설정) 근무계획미등록여부 종료 */

                // 근무시간 계획 시작,종료시간 가져오기
                Map<String, Object> timeMap = null;
                String workTimeSymdHm = "", workTimeEymdHm = "";
                if(workStartAndEndTime != null && !workStartAndEndTime.isEmpty() && workStartAndEndTime.containsKey(key)){
                    timeMap = workStartAndEndTime.get(key);

                    if (timeMap != null && timeMap.get("workSdateTime") != null) {
                        LocalDateTime workSdateTime = (LocalDateTime) timeMap.get("workSdateTime");
                        workTimeSymdHm = workSdateTime.format(fullFormatter);
                    }

                    if (timeMap != null && timeMap.get("workEdateTime") != null) {
                        LocalDateTime workEdateTime = (LocalDateTime) timeMap.get("workEdateTime");
                        workTimeEymdHm = workEdateTime.format(fullFormatter);
                    }

                    if (timeMap != null && timeMap.get("baseWorkSdateTime") != null) {
                        LocalDateTime baseWorkSdateTime = (LocalDateTime) timeMap.get("baseWorkSdateTime");
                        String baseWorkTimeSymdHm = baseWorkSdateTime.format(fullFormatter);

                        if ((baseWorkSymd + baseWorkShm).isEmpty() || (baseWorkTimeSymdHm).compareTo(baseWorkSymd + baseWorkShm) < 0) {
                            baseWorkSymd = baseWorkSdateTime.format(dateFormatter);
                            baseWorkShm = baseWorkSdateTime.format(timeFormatter);
                        }
                    }

                    if (timeMap != null && timeMap.get("baseWorkEdateTime") != null) {
                        LocalDateTime baseWorkEdateTime = (LocalDateTime) timeMap.get("baseWorkEdateTime");
                        String baseWorkTimeEymdHm = baseWorkEdateTime.format(fullFormatter);

                        if ((baseWorkEymd + baseWorkEhm).isEmpty() || (baseWorkTimeEymdHm).compareTo(baseWorkEymd + baseWorkEhm) < 0) {
                            baseWorkEymd = baseWorkEdateTime.format(dateFormatter);
                            baseWorkEhm = baseWorkEdateTime.format(timeFormatter);
                        }
                    }

                    // 근무시간외 기본정보 세팅
                    timeMap.put("workClassCd", workClassCd);
                    timeMap.put("bpCd", bpCd);
                    timeMap.put("dayType", dayType);
                }

                // 근태 내역을 적용해 기본근무 시작/종료 시간 재계산
                if(gntDtlGroup.containsKey(key)) {
                    List<WtmGntDtlDTO> gntDtlList = gntDtlGroup.get(key);

                    if(!baseWorkSymd.isEmpty() && !baseWorkShm.isEmpty() && !baseWorkEymd.isEmpty() && !baseWorkEhm.isEmpty()) {
                        LocalDateTime baseWorkSdateTime = LocalDateTime.parse(baseWorkSymd+baseWorkShm, fullFormatter);
                        LocalDateTime baseWorkEdateTime = LocalDateTime.parse(baseWorkEymd+baseWorkEhm, fullFormatter);

                        // 근태 시작, 종료시간 설정
                        setVacationTime(gntDtlList, baseWorkSdateTime, baseWorkEdateTime);

                        // 근태 내역을 시작일시 순으로 정렬
                        gntDtlList.sort(Comparator.<WtmGntDtlDTO, String>comparing(dto -> dto.getEnterCd())
                                .thenComparing(dto -> dto.getSabun())
                                .thenComparing(dto -> dto.getYmd())
                                .thenComparing(dto -> dto.getSymd())
                                .thenComparing(dto -> dto.getShm()));

                        for (WtmGntDtlDTO gntDtl : gntDtlList) {
                            LocalDateTime vacationStart = null;
                            LocalDateTime vacationEnd = null;

                            if(!gntDtl.getSymd().isEmpty() && !gntDtl.getShm().isEmpty() && !gntDtl.getEymd().isEmpty() && !gntDtl.getEhm().isEmpty()) {
                                vacationStart = LocalDateTime.parse(gntDtl.getSymd()+gntDtl.getShm(), fullFormatter);
                                vacationEnd = LocalDateTime.parse(gntDtl.getEymd()+gntDtl.getEhm(), fullFormatter);

                                // 기본근무 시작, 종료시간 시간 가공
                                if(vacationStart.isEqual(baseWorkSdateTime)) {
                                    // 근태시작시간이 기본근무시작시간과 일치하는 경우, 기본근무시작시간을 근태 종료시간으로 설정한다.
                                    baseWorkSdateTime = vacationEnd;
                                } else if(vacationEnd.isEqual(baseWorkEdateTime)) {
                                    // 근태종료시간이 기본근무종료시간과 일치하는 경우, 기본근무종료시간을 근태시작시간으로 설정한다.
                                    baseWorkEdateTime = vacationStart;
                                }

                                // 근무시작, 종료시간 가공
                                if(!workTimeSymdHm.isEmpty() && !workTimeEymdHm.isEmpty()) {
                                    LocalDateTime workSdateTime = LocalDateTime.parse(workTimeSymdHm, fullFormatter);
                                    LocalDateTime workEdateTime = LocalDateTime.parse(workTimeEymdHm, fullFormatter);
                                    if(vacationStart.isEqual(workSdateTime)) {
                                        // 근태시작시간이 근무시작시간과 일치하는 경우, 근무시작시간을 근태 종료시간으로 설정한다.
                                        workSdateTime = vacationEnd;
                                    } else if(vacationEnd.isEqual(workEdateTime)) {
                                        // 근태종료시간이 근무종료시간과 일치하는 경우, 근무종료시간을 근태시작시간으로 설정한다.
                                        workEdateTime = vacationStart;
                                    }
                                    workTimeSymdHm = workSdateTime.format(fullFormatter);
                                    workTimeEymdHm = workEdateTime.format(fullFormatter);
                                }
                            }
                        }
                        baseWorkSymd = baseWorkSdateTime.format(dateFormatter);
                        baseWorkShm = baseWorkSdateTime.format(timeFormatter);
                        baseWorkEymd = baseWorkEdateTime.format(dateFormatter);
                        baseWorkEhm = baseWorkEdateTime.format(timeFormatter);
                    }
                }

                /* 출퇴근설정) 출퇴근 자동처리 시작 */
                if(isCountYn){
                    // 출근 자동처리
                    String autoWorkStartYn = workClassInfoMap.get("autoWorkStartYn").toString();
                    if("".equals(inYmd) && "".equals(inHm) && "Y".equals(autoWorkStartYn)) {
                        inYmd = baseWorkSymd;
                        inHm = baseWorkShm;
                    }

                    // 퇴근 자동 처리
                    String autoWorkEndYn = workClassInfoMap.get("autoWorkEndYn").toString();
                    if("".equals(outYmd) && "".equals(outHm) && "Y".equals(autoWorkEndYn)) {
                        outYmd = baseWorkEymd;
                        outHm = baseWorkEhm;
                    }
                } else {
                    // 근무시간 한도 체크의 경우 출퇴근 타각 기록이 없으면(미래) 출퇴근 자동 처리하여 근무시간 한도 체크
                    // 출근 자동 처리
                    if ("".equals(inYmd) && "".equals(inHm) && !workTimeSymdHm.isEmpty()) {
                        LocalDateTime workSdateTime = LocalDateTime.parse(workTimeSymdHm, fullFormatter);
                        inYmd = workSdateTime.format(dateFormatter);
                        inHm = workSdateTime.format(timeFormatter);
                    }

                    // 퇴근 자동 처리
                    if ("".equals(outYmd) && "".equals(outHm) && !workTimeEymdHm.isEmpty()) {
                        LocalDateTime workEdateTime = LocalDateTime.parse(workTimeEymdHm, fullFormatter);
                        outYmd = workEdateTime.format(dateFormatter);
                        outHm = workEdateTime.format(timeFormatter);
                    }
                }
                /* 출퇴근설정) 출퇴근 자동처리 종료 */

                // 인정 출/퇴근 시간 계산 -> 근무 계획과 출 퇴근 시간 데이터가 있는 경우에만 처리
                if(!workTimeSymdHm.isEmpty() && !workTimeEymdHm.isEmpty()){
                    LocalDateTime adjWorkSdateTime = LocalDateTime.parse(workTimeSymdHm, fullFormatter);
                    LocalDateTime adjWorkEdateTime = LocalDateTime.parse(workTimeEymdHm, fullFormatter);

                    LocalDateTime adjBaseWorkSdateTime = null;
                    LocalDateTime adjBaseWorkEdateTime = null;
                    if(!baseWorkSymd.isEmpty() && !baseWorkShm.isEmpty() && !baseWorkEymd.isEmpty() && !baseWorkEhm.isEmpty()) {
                        adjBaseWorkSdateTime = LocalDateTime.parse(baseWorkSymd+baseWorkShm, fullFormatter);
                        adjBaseWorkEdateTime = LocalDateTime.parse(baseWorkEymd+baseWorkEhm, fullFormatter);
                    }

                    if(!(inYmd+inHm).isEmpty() && !(outYmd+outHm).isEmpty()) {
                        // 출,퇴근 시간이 있는 경우, 인정 출/퇴근 시간 계산 및 인정 근무 시간 계산
                        LocalDateTime in = LocalDateTime.parse(inYmd+inHm, fullFormatter);
                        LocalDateTime out = LocalDateTime.parse(outYmd+outHm, fullFormatter);

                        // 인정 출근 시간
                        LocalDateTime workTimeStart = adjWorkSdateTime.isBefore(in) ? in : adjWorkSdateTime;

                        // 인정 퇴근 시간
                        LocalDateTime workTimeEnd = adjWorkEdateTime.isBefore(out) ? adjWorkEdateTime : out;

                        /* 출퇴근설정) 계획시간 외 연장생성 시작 */
                        // 기존에 자동 등록된 연장근무정보가 있는지 확인하고, 있다면 해당 정보를 삭제한다.
                        List<WtmWrkDtlDTO> autoWrkList = targetWrkDtlList.stream()
                                .filter(dto -> "Y".equals(dto.getAutoCreYn()) && getOtWorkCd().equals(dto.getWorkCd()))
                                .collect(Collectors.toList());

                        targetWrkDtlList.removeAll(autoWrkList);
                        wtmWrkDtlDTOList.removeAll(autoWrkList);

                        String autoOtTimeYn = workClassInfoMap.get("autoOtTimeYn").toString();
                        if("Y".equals(autoOtTimeYn) && out.isAfter(workTimeEnd)) {

                            // 연장근무 근무계획 생성
                            Map<String, String> autoCreMap = new HashMap<>();
                            autoCreMap.put("enterCd", enterCd);
                            autoCreMap.put("ymd", targetYmd);
                            autoCreMap.put("sabun", sabun);
                            autoCreMap.put("workCd", getOtWorkCd());
                            autoCreMap.put("symd", workTimeEnd.format(dateFormatter));
                            autoCreMap.put("shm", workTimeEnd.format(timeFormatter));
                            autoCreMap.put("eymd", outYmd);
                            autoCreMap.put("ehm", outHm);
                            autoCreMap.put("addWorkTimeYn", "Y");
                            autoCreMap.put("workTimeType", WORK_TIME_TYPE_OT);
                            List<WtmWrkDtlDTO> autoCreWtmWrkList = getAutoCreWtmWrkList(autoCreMap, workClassInfoMap);
                            targetWrkDtlList.addAll(autoCreWtmWrkList);
                            wtmWrkDtlDTOList.addAll(autoCreWtmWrkList);

                            workTimeEnd = out;
                        }
                        /* 출퇴근설정) 계획시간 외 연장생성 종료 */

                        /* 출퇴근설정) 출퇴근 가능 시간 범위 시작 */
                        int workEnableRange = 0;
                        if(!workClassInfoMap.get("workEnableRangeNum").equals("")) {
                            workEnableRange = Integer.parseInt(workClassInfoMap.get("workEnableRangeNum").toString());
                            // 실제 출근 시간에서 출근 가능 시간 범위를 차감한 시간으로 인정 출/퇴근 시간 재산정
                            if(in.isAfter(adjWorkSdateTime) && (!in.minusMinutes(workEnableRange).isAfter(adjWorkSdateTime))) {
                                workTimeStart = adjWorkSdateTime;
                            }

                            if(out.isBefore(adjWorkEdateTime) && (!out.plusMinutes(workEnableRange).isBefore(adjWorkEdateTime))) {
                                workTimeEnd = adjWorkEdateTime;
                            }
                        }
                        /* 출퇴근설정) 출퇴근 가능 시간 범위 종료 */

                        /* 출퇴근설정) 사전 출근 여부 시작 */
                        // 근무계획시간 이전 출근인지 확인
                        String workBeginPreYn = workClassInfoMap.get("workBeginPreYn").toString();
                        if("Y".equals(workBeginPreYn)) {
                            workTimeStart = in.isBefore(adjWorkSdateTime) ? in : workTimeStart;

                            // 근무 계획시간 이전 출근이라면, 사전 출근 시간을 연장근무를 생성한다.
                            if(in.isBefore(adjWorkSdateTime)) {
                                // 출근시간~기본근무시작시간 사이에 연장근무 근무계획 생성
                                Map<String, String> autoCreMap = new HashMap<>();
                                autoCreMap.put("enterCd", enterCd);
                                autoCreMap.put("ymd", targetYmd);
                                autoCreMap.put("sabun", sabun);
                                autoCreMap.put("workCd", getOtWorkCd());
                                autoCreMap.put("symd", inYmd);
                                autoCreMap.put("shm", inHm);
                                autoCreMap.put("eymd", adjWorkSdateTime.format(dateFormatter));
                                autoCreMap.put("ehm", adjWorkSdateTime.format(timeFormatter));
                                autoCreMap.put("addWorkTimeYn", "Y");
                                autoCreMap.put("workTimeType", WORK_TIME_TYPE_OT);
                                List<WtmWrkDtlDTO> autoCreWtmWrkList = getAutoCreWtmWrkList(autoCreMap, workClassInfoMap);
                                targetWrkDtlList.addAll(autoCreWtmWrkList);
                                wtmWrkDtlDTOList.addAll(autoCreWtmWrkList);
                            }

                        }
                        /* 출퇴근설정) 사전 출근 여부 종료 */

                        adjWorkSdateTime = workTimeStart;
                        adjWorkEdateTime = workTimeEnd;

                        // 근무 시작시간과 종료시간이 일치하는 경우(=일단위 휴가 사용시 or 오전+오후 반차 붙여서 사용하는등..)
                        if(adjWorkSdateTime.equals(adjWorkEdateTime)) {
                            // 인정근무 시작/종료시간을 빈 값으로 설정한다.
                            adjWorkSdateTime = null;
                            adjWorkEdateTime = null;
                        }

                    } else {
                        // 출퇴근 시간이 없는 경우, 인정 출퇴근 시간 null 값으로 설정
                        adjWorkSdateTime = null;
                        adjWorkEdateTime = null;
                        adjBaseWorkSdateTime = null;
                        adjBaseWorkEdateTime = null;
                    }

                    timeMap.put("workSdateTime", adjWorkSdateTime);
                    timeMap.put("workEdateTime", adjWorkEdateTime);
                    timeMap.put("baseWorkSdateTime", adjBaseWorkSdateTime);
                    timeMap.put("baseWorkEdateTime", adjBaseWorkEdateTime);

                }
            }
        } catch (Exception e) {
            Log.Error(e.toString());
            throw new HrException("근무일정 시작/종료시간을 조정 작업중 오류가 발생했습니다. 관리자에게 문의하세요.");
        }
    }

    /**
     * 일근무시간 리스트를 그룹핑하여 주별 실 근무시간을 구한다.
     *
     * @param wtmDailyCountDTOList 일별 실 근무시간 리스트
     * @param weekBeginDay 주 시작일
     * @return 주별 실 근무시간 리스트
     */
    public List<WtmWeeklyCountDTO> sumWtmWeekWorkTime(List<WtmDailyCountDTO> wtmDailyCountDTOList, DayOfWeek weekBeginDay) {
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");

        return wtmDailyCountDTOList.stream()
                .collect(Collectors.groupingBy(
                        dayDto -> {
                            LocalDate ymd = LocalDate.parse(dayDto.getYmd(), dateFormatter);
                            LocalDate weekStart = ymd.with(TemporalAdjusters.previousOrSame(weekBeginDay)); // 해당 주의 시작요일 구하기

                            // 그룹화 키 생성 (회사코드, 사번, 주 시작일)
                            return new WtmCalcGroupKey(
                                dayDto.getEnterCd(),
                                dayDto.getSabun(),
                                weekStart.format(dateFormatter)
                            );
                        },
                        Collectors.collectingAndThen(
                                Collectors.reducing(
                                        null,
                                        dto -> {
                                            // 주 시작일과 종료일 계산
                                            LocalDate ymd = LocalDate.parse(dto.getYmd(), dateFormatter);
                                            LocalDate weekStart = ymd.with(TemporalAdjusters.previousOrSame(weekBeginDay));
                                            LocalDate weekEnd = weekStart.plusDays(6);

                                            WtmWeeklyCountDTO weekDto = new WtmWeeklyCountDTO();
                                            weekDto.setEnterCd(dto.getEnterCd());
                                            weekDto.setSabun(dto.getSabun());
                                            weekDto.setWeekSymd(weekStart.format(dateFormatter));
                                            weekDto.setWeekEymd(weekEnd.format(dateFormatter));
                                            weekDto.setBasicMm(dto.getBasicMm());
                                            weekDto.setOtMm(dto.getOtMm());
                                            weekDto.setLtnMm(dto.getLtnMm());
                                            weekDto.setVacationMm(dto.getVacationMm());
                                            return weekDto;
                                        },
                                        (acc, curr) -> {
                                            if (acc == null) return curr;  // 첫 번째 요소 처리

                                            acc.setBasicMm(acc.getBasicMm() + curr.getBasicMm());
                                            acc.setOtMm(acc.getOtMm() + curr.getOtMm());
                                            acc.setLtnMm(acc.getLtnMm() + curr.getLtnMm());
                                            acc.setVacationMm(acc.getVacationMm() + curr.getVacationMm());
                                            return acc;
                                        }
                                ),
                                result -> result
                        )
                ))
                .values()
                .stream()
                .sorted(Comparator.comparing(WtmWeeklyCountDTO::getSabun).thenComparing(WtmWeeklyCountDTO::getWeekSymd)) // 사번, 주시작일 기준으로 정렬
                .collect(Collectors.toList());
    }

    /**
     * 주 실 근무시간 리스트를 그룹핑하여 주 평균 실 근무시간을 구한다.
     * @param wtmWeeklyCountDTOList 일별 실 근무시간 리스트
     * @param weekCount 단위기간내 주차
     * @return 주 평균 실 근무시간 리스트
     */
    public List<WtmWeeklyCountDTO> avgWtmWeekWorkTime(List<WtmWeeklyCountDTO> wtmWeeklyCountDTOList, double weekCount) {

        return wtmWeeklyCountDTOList.stream()
                .collect(Collectors.groupingBy(
                        dto -> {
                            // 그룹화 키 생성 (회사코드, 사번)
                            return new WtmCalcGroupKey(
                                    dto.getEnterCd(),
                                    dto.getSabun()
                            );
                        },
                        Collectors.collectingAndThen(
                                Collectors.reducing(
                                        null,
                                        dto -> {
                                            WtmWeeklyCountDTO weekDto = new WtmWeeklyCountDTO();
                                            weekDto.setEnterCd(dto.getEnterCd());
                                            weekDto.setSabun(dto.getSabun());
                                            weekDto.setBasicMm(dto.getBasicMm());
                                            weekDto.setOtMm(dto.getOtMm());
                                            weekDto.setLtnMm(dto.getLtnMm());
                                            weekDto.setVacationMm(dto.getVacationMm());
                                            weekDto.setWeekCount(weekCount);
                                            return weekDto;
                                        },
                                        (acc, curr) -> {
                                            if (acc == null) return curr;  // 첫 번째 요소 처리

                                            acc.setBasicMm(acc.getBasicMm() + curr.getBasicMm());
                                            acc.setOtMm(acc.getOtMm() + curr.getOtMm());
                                            acc.setLtnMm(acc.getLtnMm() + curr.getLtnMm());
                                            acc.setVacationMm(acc.getVacationMm() + curr.getVacationMm());
                                            return acc;
                                        }
                                ),
                                result -> result
                        )
                ))
                .values()
                .stream()
                .collect(Collectors.toList());
    }

    /**
     * 교대조 스케줄 리스트를 근무 상세 리스트로 치환
     * @param wtmWrkSchDTOList 교대조스케줄리스트
     * @return 근무 상세 리스트
     */
    public List<WtmWrkDtlDTO> convertToWtmWrkDtlDTOList(List<WtmWrkSchDTO> wtmWrkSchDTOList) {

        List<WtmWrkDtlDTO> wtmWrkDtlDTOList = new ArrayList<>();

        for(WtmWrkSchDTO wtmWrkSchDTO : wtmWrkSchDTOList) {
            // 시스템 코드(주휴일, 휴무일)는 근무 상세 리스트 치환 대상에서 제외한다.
            if("Y".equals(wtmWrkSchDTO.getSystemCdYn())) {
                continue;
            }

            String planEymd;
            int workTimeF = Integer.parseInt(wtmWrkSchDTO.getWorkTimeF());
            int workTimeT = Integer.parseInt(wtmWrkSchDTO.getWorkTimeT());
            // 근무 시작시간이 근무 종료시간보다 큰 경우 종료일은 다음날이 된다.
            if (workTimeF > workTimeT) {
                LocalDate date = LocalDate.parse(wtmWrkSchDTO.getYmd(), DateTimeFormatter.ofPattern("yyyyMMdd"));
                planEymd = date.plusDays(1).format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            } else {
                planEymd = wtmWrkSchDTO.getYmd();
            }

            // 근무시간 row 추가
            wtmWrkDtlDTOList.add(new WtmWrkDtlDTO(
                    wtmWrkSchDTO.getEnterCd(),
                    wtmWrkSchDTO.getWrkDtlId(),
                    wtmWrkSchDTO.getYmd(),
                    wtmWrkSchDTO.getSabun(),
                    wtmWrkSchDTO.getName(),
                    baseWorkCd,
                    wtmWrkSchDTO.getYmd(),
                    wtmWrkSchDTO.getWorkTimeF(),
                    planEymd,
                    wtmWrkSchDTO.getWorkTimeT(),
                    calcMinutes(workTimeF, workTimeT),
                    baseWorkCd,
                    "Y",
                    WORK_TIME_TYPE_BASE, // 근무시간종류: 기본,
                    "NA"
            ));

            // 휴게시간 처리
            if (wtmWrkSchDTO.getBreakTimes() != null && !wtmWrkSchDTO.getBreakTimes().isEmpty()) {
                Arrays.stream(wtmWrkSchDTO.getBreakTimes().split(",")).forEach(breaks -> {
                    String[] times = breaks.split("-");

                    int breakShm = Integer.parseInt(times[0]);
                    int breakEhm = Integer.parseInt(times[1]);
                    String ymd = wtmWrkSchDTO.getYmd();
                    String breakSymd;
                    String breakEymd;

                    // 휴게 시작시간이 휴게 종료시간보다 큰 경우 휴게시작일은 근무시작일, 휴게종료일은 근무종료일이 된다.
                    if (breakShm > breakEhm) {
                        breakSymd = ymd;
                        breakEymd = planEymd;
                    } else if (workTimeF > breakShm){
                        // 근무 시작 시간이 휴게 시작 시간보다 큰 경우, 휴게 시작/종료일은 근무종료일이 된다.
                        breakSymd = planEymd;
                        breakEymd = planEymd;
                    } else {
                        // 그 외의 경우에는 근무시작일이 휴게 시작/종료일이 된다.
                        breakSymd = ymd;
                        breakEymd = ymd;
                    }

                    wtmWrkDtlDTOList.add(new WtmWrkDtlDTO(
                            wtmWrkSchDTO.getEnterCd(),
                            wtmWrkSchDTO.getWrkDtlId(),
                            wtmWrkSchDTO.getYmd(),
                            wtmWrkSchDTO.getSabun(),
                            wtmWrkSchDTO.getName(),
                            breakWorkCd,
                            breakSymd,
                            times[0],
                            breakEymd,
                            times[1],
                            calcMinutes(breakShm, breakEhm),
                            breakWorkCd,
                            "N",
                            WORK_TIME_TYPE_BREAK, // 근무시간종류: 휴게
                            "NA"
                    ));
                });
            }
        }

        return wtmWrkDtlDTOList;
    }

    /**
     * 일근무시간 한도 초과여부 계산
     * @param wtmDailyCountDTOList 일별 근무 집계 리스트
     * @param workClassInfo 근무유형정보
     * @return 일근무시간 한도 초과여부
     * @throws Exception 한도 초과 대상자 알림용 Exception
     */
    public boolean checkDayLimit(List<WtmDailyCountDTO> wtmDailyCountDTOList, Map<String, Object> workClassInfo) throws Exception {
        int dayWkLmt = 0;
        int dayOtLmt = 0;
        boolean dayLimitUseYn = true; // 일 근무시간 한도 초과 계산 사용여부

        if(!workClassInfo.isEmpty()) {
            // 일 기본근무시간 한도와 일 연장근무시간한도가 입력되지 않는 경우 dayLimitUseYn 값 false 설정
            dayWkLmt = Integer.parseInt(StringUtils.defaultIfEmpty(workClassInfo.get("dayWkLmt").toString(), "-1"));
            dayOtLmt = Integer.parseInt(StringUtils.defaultIfEmpty(workClassInfo.get("dayOtLmt").toString(), "-1"));

            if(dayWkLmt < 0 || dayOtLmt < 0) dayLimitUseYn = false; // 일기본근무시간한도와 일연장근무시간한도가 모두 입력되지 않은 경우 한도 계산 수행하지 않음.
        }

        if(dayLimitUseYn) {
            int dayWkLmtMm = dayWkLmt * 60;
            int dayOtLmtMm = dayOtLmt * 60;
            DateTimeFormatter dateFormatter1 = DateTimeFormatter.ofPattern("yyyyMMdd");
            DateTimeFormatter dateFormatter2 = DateTimeFormatter.ofPattern("yyyy.MM.dd");

            for(WtmDailyCountDTO wtmDailyCount : wtmDailyCountDTOList) {
                int basicMm = wtmDailyCount.getBasicMm();
                if("N".equals(realTimeCount)) {basicMm += wtmDailyCount.getVacationMm();} // 실근로 기반이 아닌경우 휴게시간을 포함한다.

                int otMm = wtmDailyCount.getOtMm();

                // 일 기본근무시간 한도를 초과한 시간은 연장근로로 취급한다.
                if(basicMm > dayWkLmtMm) {
                    otMm += basicMm - dayWkLmtMm;
                    basicMm = dayWkLmtMm;
                }

                // 총 근무시간 한도를 초과하는 경우
                if(basicMm + otMm > dayWkLmtMm + dayOtLmtMm) {
                    LocalDate date = LocalDate.parse(wtmDailyCount.getYmd(), dateFormatter1);
                    StringBuilder errMsg = new StringBuilder();
                    errMsg.append("[일 근무시간 한도 초과]\n")
                            .append(date.format(dateFormatter2))
                            .append("일 근무시간 한도를 초과하였습니다.\n")
                            .append("오류사번: ")
                            .append(wtmDailyCount.getSabun())
                            .append(String.format(" (계획: %.1f시간 / 한도: %d시간)\n",
                                    (double)(basicMm + otMm) / 60, dayWkLmt + dayOtLmt));
                    throw new HrException(errMsg.toString());
                }

                if(otMm > dayOtLmtMm) {
                    LocalDate date = LocalDate.parse(wtmDailyCount.getYmd(), dateFormatter1);
                    StringBuilder errMsg = new StringBuilder();
                    errMsg.append("[일 연장 근무시간 한도 초과]\n")
                            .append(date.format(dateFormatter2))
                            .append("일 연장 근무시간 한도를 초과하였습니다.\n")
                            .append("오류사번: ")
                            .append(wtmDailyCount.getSabun())
                            .append(String.format(" (계획: %.1f시간 / 한도: %d시간)\n",
                                    (double) otMm / 60,  dayOtLmt));
                    throw new HrException(errMsg.toString());
                }
            }
        }

        return true;
    }

    /**
     * 주 근무시간 한도 초과여부 계산
     * @param wtmDailyCountDTOList 일별 근무 집계 리스트
     * @param workClassInfo 근무유형정보
     * @return 주 근무시간 한도 초과여부
     * @throws Exception 한도 초과 대상자 알림용 Exception
     */
    public boolean checkWeekLimit(List<WtmDailyCountDTO> wtmDailyCountDTOList, Map<String, Object> workClassInfo) throws Exception {
        int weekWkLmt = 0;
        int weekOtLmt = 0;
        boolean weekLimitUseYn = true;
        String weekBeginDay = "MON"; // DEFAULT 요일: 월요일

        if(!workClassInfo.isEmpty()) {
            // 주 기본근무시간 한도와 주 연장근무시간한도가 입력되지 않는 경우 weekLimitUseYn 값 false 설정
            weekWkLmt = Integer.parseInt(StringUtils.defaultIfEmpty(workClassInfo.get("weekWkLmt").toString(), "-1"));
            weekOtLmt = Integer.parseInt(StringUtils.defaultIfEmpty(workClassInfo.get("weekOtLmt").toString(), "-1"));

            // 주 시작요일 계산
            weekBeginDay = getWeekBeginDay(workClassInfo, wtmDailyCountDTOList);

            if(weekWkLmt < 0 || weekOtLmt < 0) weekLimitUseYn = false; // 주기본근무시간한도와 주연장근무시간한도가 모두 입력되지 않은 경우 한도 계산 수행하지 않음.
        }

        if(weekLimitUseYn) {
            int weekWkLmtMm = weekWkLmt * 60;
            int weekOtLmtMm = weekOtLmt * 60;

            DateTimeFormatter dateFormatter1 = DateTimeFormatter.ofPattern("yyyyMMdd");
            DateTimeFormatter dateFormatter2 = DateTimeFormatter.ofPattern("yyyy.MM.dd");

            // 개인별 주별 근무,휴게시간 계산
            List<WtmWeeklyCountDTO> wtmWeeklyCountDTOList = sumWtmWeekWorkTime(wtmDailyCountDTOList, convertToDayOfWeek(weekBeginDay));

            // 주 근무시간 한도를 초과하는 케이스가 있는지 확인
            for(WtmWeeklyCountDTO wtmWeeklyCount : wtmWeeklyCountDTOList) {
                int basicMm = wtmWeeklyCount.getBasicMm();

                // 실근로 기반이 아닌경우 휴게시간을 포함한다.
                if("N".equals(realTimeCount)) {
                    basicMm += wtmWeeklyCount.getVacationMm();
                }

                int otMm = wtmWeeklyCount.getOtMm();

                // 주 기본근무시간 한도를 초과한 시간은 연장근로로 취급한다.
                if(basicMm > weekWkLmtMm) {
                    otMm += basicMm - weekWkLmtMm;
                    basicMm = weekWkLmtMm;
                }

                // 총 근무시간 한도를 초과하는 경우
                if(basicMm + otMm > weekWkLmtMm + weekOtLmtMm) {
                    LocalDate weekStart = LocalDate.parse(wtmWeeklyCount.getWeekSymd(), dateFormatter1);
                    LocalDate weekEnd = LocalDate.parse(wtmWeeklyCount.getWeekEymd(), dateFormatter1);
                    StringBuilder errMsg = new StringBuilder();
                    errMsg.append("[주 근무시간 한도 초과]\n")
                            .append(weekStart.format(dateFormatter2)).append("-")
                            .append(weekEnd.format(dateFormatter2))
                            .append("주 근무시간 한도를 초과하였습니다.\n")
                            .append("오류사번: ")
                            .append(wtmWeeklyCount.getSabun())
                            .append(String.format(" (계획: %.1f시간 / 한도: %d시간)\n",
                                    (double)(basicMm + otMm) / 60, weekWkLmt + weekOtLmt));
                    throw new HrException(errMsg.toString());
                }

                if(otMm > weekOtLmtMm) {
                    LocalDate weekStart = LocalDate.parse(wtmWeeklyCount.getWeekSymd(), dateFormatter1);
                    LocalDate weekEnd = LocalDate.parse(wtmWeeklyCount.getWeekEymd(), dateFormatter1);
                    StringBuilder errMsg = new StringBuilder();
                    errMsg.append("[주 연장 근무시간 한도 초과]\n")
                            .append(weekStart.format(dateFormatter2)).append("-")
                            .append(weekEnd.format(dateFormatter2))
                            .append("주 연장 근무시간 한도를 초과하였습니다.\n")
                            .append("오류사번: ")
                            .append(wtmWeeklyCount.getSabun())
                            .append(String.format(" (계획: %.1f시간 / 한도: %d시간)\n",
                                    (double) otMm / 60,  weekOtLmt));
                    throw new HrException(errMsg.toString());
                }
            }


        }

        return true;
    }

    /**
     * 주 평균 근무시간 한도 초과여부 계산
     * @param wtmDailyCountDTOList 일별 근무시간 리스트
     * @param workClassInfo 근무유형정보
     * @return 주 평균 근무시간 한도 초과여부
     * @throws Exception 한도 초과 대상자 알림용 Exception
     */
    public boolean checkAvgWeekLimit(List<WtmDailyCountDTO> wtmDailyCountDTOList, Map<String, Object> workClassInfo) throws Exception {
        int avgWeekWkLmt = 0;
        int avgWeekOtLmt = 0;
        boolean avgWeekLimitUseYn = true;
        String weekBeginDay = "MON";

        if(!workClassInfo.isEmpty()) {
            // 주 평균기본근무시간 한도와 주 평균연장근무시간한도가 입력되지 않는 경우 weekLimitUseYn 값 false 설정
            avgWeekWkLmt = Integer.parseInt(StringUtils.defaultIfEmpty(workClassInfo.get("avgWeekWkLmt").toString(), "-1"));
            avgWeekOtLmt = Integer.parseInt(StringUtils.defaultIfEmpty(workClassInfo.get("avgWeekOtLmt").toString(), "-1"));

            // 주 시작요일 계산
            weekBeginDay = getWeekBeginDay(workClassInfo, wtmDailyCountDTOList);

            if(avgWeekWkLmt < 0 || avgWeekOtLmt < 0) avgWeekLimitUseYn = false; // 주평균기본근무시간한도와 주평균연장근무시간한도가 모두 입력되지 않은 경우 한도 계산 수행하지 않음.
        }

        if(avgWeekLimitUseYn) {
            int avgWeekWkLmtMm = avgWeekWkLmt * 60;
            int avgWeekOtLmtMm = avgWeekOtLmt * 60;

            DateTimeFormatter dateFormatter1 = DateTimeFormatter.ofPattern("yyyyMMdd");
            DateTimeFormatter dateFormatter2 = DateTimeFormatter.ofPattern("yyyy.MM.dd");

            // 개인별 주별 근무,휴게시간 계산
            List<WtmWeeklyCountDTO> wtmWeeklyCountDTOList = sumWtmWeekWorkTime(wtmDailyCountDTOList, convertToDayOfWeek(weekBeginDay));

            // 단위기간 내 주차 조회
            String minYmd = wtmDailyCountDTOList.stream()
                    .map(dto -> dto.getYmd())
                    .min((ymd1, ymd2) -> ymd1.compareTo(ymd2))
                    .orElse(null);

            String maxYmd = wtmDailyCountDTOList.stream()
                    .map(dto -> dto.getYmd())
                    .max((ymd1, ymd2) -> ymd1.compareTo(ymd2))
                    .orElse(null);

            double weekCount = 0; // 주차 계산
            if (minYmd != null && maxYmd != null) {
                weekCount = ChronoUnit.DAYS.between(LocalDate.parse(minYmd, dateFormatter1), LocalDate.parse(maxYmd, dateFormatter1)) / 7.0;
            }

            // 개인별 주 평균 총 근무시간 계산
            List<WtmWeeklyCountDTO> wtmAvgWeekCalcTimeDTOList = avgWtmWeekWorkTime(wtmWeeklyCountDTOList, weekCount);

            // 주 근무시간 한도를 초과하는 케이스가 있는지 확인
            for(WtmWeeklyCountDTO wtmWeeklyCount : wtmAvgWeekCalcTimeDTOList) {
                double avgBasicMm = 0;
                if("N".equals(realTimeCount)) {
                    avgBasicMm += wtmWeeklyCount.getVacationMm(); // 실근로 기반이 아닌경우 휴게시간을 포함한다.
                }
                avgBasicMm += wtmWeeklyCount.getBasicMm();
                avgBasicMm = avgBasicMm / wtmWeeklyCount.getWeekCount();

                double avgOtMm = wtmWeeklyCount.getOtMm() / wtmWeeklyCount.getWeekCount();

                // 주 평균 기본근무시간 한도를 초과한 시간은 연장근로로 취급한다.
                if(avgBasicMm > avgWeekWkLmtMm) {
                    avgOtMm += avgBasicMm - avgWeekWkLmtMm;
                    avgBasicMm = avgWeekWkLmtMm;
                }

                // 주 평균 총 근무시간 한도를 초과하는 경우
                if(avgBasicMm + avgOtMm > avgWeekWkLmtMm + avgWeekOtLmtMm) {
                    StringBuilder errMsg = new StringBuilder();
                    errMsg.append("[주 평균 근무 시간 한도 초과]\n")
                            .append("주 평균 근무 시간 한도를 초과하였습니다.\n")
                            .append("오류사번: ")
                            .append(wtmWeeklyCount.getSabun())
                            .append(String.format(" (계획: %.1f시간 / 한도: %d시간)\n",
                                    (avgBasicMm + avgOtMm) / 60, avgWeekWkLmt + avgWeekOtLmt));
                    throw new HrException(errMsg.toString());
                }

                // 주평균 연장근무 한도를 초과하는 경우
                if(avgOtMm > avgWeekOtLmtMm) {
                    StringBuilder errMsg = new StringBuilder();
                    errMsg.append("[주 근무시간 한도 초과]\n")
                            .append("주 근무시간 한도를 초과하였습니다.\n")
                            .append("오류사번: ")
                            .append(wtmWeeklyCount.getSabun())
                            .append(String.format(" (계획: %.1f시간 / 한도: %d시간)\n",
                                    avgOtMm / 60,  avgWeekOtLmt));
                    throw new HrException(errMsg.toString());
                }
            }
        }

        return true;
    }

    public String getWeekBeginDay(Map<String, Object> workClassInfo, List<WtmDailyCountDTO> wtmDailyCountDTOList) throws Exception {
        String result = "MON"; // default 요일

        if (workClassInfo != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");

            String weekBeginDay = workClassInfo.get("weekBeginDay").toString();
            String workTypeCd = workClassInfo.get("workTypeCd").toString();
            String intervalBeginType = workClassInfo.get("intervalBeginType").toString();
            String applUnit = workClassInfo.get("applUnit").toString();

            /* 근무제종류에 따라 주 시작요일이 달라진다.
             *   - 기본근무, 시차출퇴근, 교대조: 주 시작 요일(TWTM021.WEEK_BEGIN_DAY)
             *   - 탄력근무제: 단위기간이 주 단위인 경우, 단위기간시작기준이 주 시작 요일이 된다. (TWTM021.INTERVAL_BEGIN_TYPE)
             *               단위기간이 월 단위인 경우, 단위기간시작 월의 1일의 요일이 주 시작요일이 된다.
             *   - 선택근무제: 단위기간이 주 단위인 경우, 단위기간시작기준이 주 시작 요일이 된다. (TWTM021.INTERVAL_BEGIN_TYPE)
             *               단위기간이 월 단위인 경우, 주 시작 요일(TWTM021.WEEK_BEGIN_DAY)
             */
            if ("R".equals(workTypeCd) || "B".equals(workTypeCd) || "D".equals(workTypeCd) || ("A".equals(workTypeCd) && "M".equals(applUnit))) { // 기본근무 or 시차출퇴근 or 교대조 or 선택근무제 월단위 신청
                if(!weekBeginDay.isEmpty())
                    result = weekBeginDay;
            } else if (("C".equals(workTypeCd) || "A".equals(workTypeCd)) && "W".equals(applUnit)) { // 탄력근무제, 선택근무제이고, 주 단위 신청인 경우
                // 단위기간시작기준이 주 시작 요일이 된다.
                if(!intervalBeginType.isEmpty())
                    result = intervalBeginType;
            } else if ("C".equals(workTypeCd) && "M".equals(applUnit)) { // 탄력근무제 월 단위 신청인 경우
                // 가장 작은 ymd 의 값을 가져온다. 가장 작은 ymd 값을 포함하는 단위기간의 시작일을 구하기 위함.
                String minYmd = wtmDailyCountDTOList.stream()
                        .map(dto -> dto.getYmd())
                        .min((ymd1, ymd2) -> ymd1.compareTo(ymd2))
                        .orElse(null);

                Map<String, Object> paramMap = new HashMap<>();
                paramMap.put("chkSdate", minYmd);
                paramMap.put("chkEdate", minYmd);

                // minYmd 를 포함하는 단위기간의 시작일 조회
                Map unitDate = getWorkTimeUnitRange(paramMap, workClassInfo);
                String unitSdate = unitDate.get("unitSdate").toString();

                // 단위기간 시작일의 요일이 주 시작 요일이 된다.
                LocalDate date = LocalDate.parse(unitSdate, formatter);
                result = date.format(DateTimeFormatter.ofPattern("E", Locale.ENGLISH)).toUpperCase();
            }
        }
        return result;
    }

    public Map<Object, Object> getWorkTimeUnitRange(Map<String, Object> paramMap, Map<String, Object> workClassInfo) throws Exception {
        Map<Object, Object> resultMap = new HashMap<>();
        resultMap.put("unitSdate", "");
        resultMap.put("unitEdate", "");
        resultMap.put("weekCount", 0);

        /* 1. 근무유형, 근무제종류 가져오기 */
        String workClassCd = null; // 근무유형코드
        String workTypeCd = null; // 근무제종류
        String weekBeginDay = null; // 주시작요일
        String intervalBeginType = null; // 단위기간시작기준
        String applUnit = null; // 신청단위
        String applMinUnit = null; // 신청단위

        if (workClassInfo != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");

            workTypeCd = workClassInfo.get("workTypeCd").toString();
            weekBeginDay = workClassInfo.get("weekBeginDay").toString();
            intervalBeginType = workClassInfo.get("intervalBeginType").toString();
            applUnit = workClassInfo.get("applUnit").toString();
            applMinUnit = workClassInfo.get("applMinUnit").toString();

            String chkSdate = paramMap.get("chkSdate").toString().replaceAll("-", "");
            String chkEdate = paramMap.get("chkEdate").toString().replaceAll("-", "");

            LocalDate unitSdate = LocalDate.parse(chkSdate, formatter);
            LocalDate unitEdate = LocalDate.parse(chkEdate, formatter);

            /* 2. 근무제종류에 따라 단위기간 시작,종료일 조회
             *   - 기본근무, 시차출퇴근, 교대조: 주 시작 요일을 기준으로 단위기간 산정
             *   - 탄력근무제: 단위기간시작기준으로 단위기간 산정
             *   - 선택근무제: 단위기간이 주 단위인 경우, 단위기간시작기준으로 단위기간 산정
             *               단위기간이 월 단위인 경우, 주 시작 요일을 기준으로 단위기간 산정
             */
            if ("R".equals(workTypeCd) || "B".equals(workTypeCd) || "D".equals(workTypeCd)) { // 기본근무 or 시차출퇴근 or 교대조
                // 주 시작, 종료요일
                DayOfWeek weekStartDay = convertToDayOfWeek(weekBeginDay);
                DayOfWeek weekEndDay = getWeekEndDay(weekBeginDay);

                // 신청기간을 포함하는 단위기간 시작요일 ~ 종료요일의 날짜를 계산한다.
                LocalDate startDate = LocalDate.parse(chkSdate, formatter);
                LocalDate endDate = LocalDate.parse(chkEdate, formatter);

                unitSdate = startDate.minusDays(
                        (startDate.getDayOfWeek().getValue() - weekStartDay.getValue() + 7) % 7
                );

                unitEdate = endDate.plusDays(
                        (weekEndDay.getValue() - endDate.getDayOfWeek().getValue() + 7) % 7
                );
            } else if ("C".equals(workTypeCd)) { // 탄력근무제
                if("W".equals(applUnit)) {
                    // 단위기간이 주 단위인 경우 단위기간시작기준으로 설정한 요일과 단위기간 최소기준에 속하는 단위기간 시작요일 ~ 종료요일의 날짜를 계산한다.
                    int unit = Integer.parseInt(applMinUnit); // 근무유형 단위기간 최소기준

                    // 시작일과 목표일 파싱
                    LocalDate workClassSdate = LocalDate.parse(workClassInfo.get("sdate").toString(), formatter); // 근무유형의 시작일
                    LocalDate targetSdate = LocalDate.parse(chkSdate, formatter); // 신청 시작일
                    LocalDate targetEdate = LocalDate.parse(chkEdate, formatter); // 신청 종료일

                    // 첫 번째 해당 요일 찾기
                    DayOfWeek weekStartDay = convertToDayOfWeek(intervalBeginType);
                    LocalDate firstDate = workClassSdate.with(TemporalAdjusters.nextOrSame(weekStartDay));

                    // 목표 날짜가 속한 구간 찾기
                    unitSdate = firstDate;
                    while (unitSdate.isBefore(targetSdate)) {
                        LocalDate nextDate = unitSdate.plusWeeks(unit);
                        if (targetSdate.isBefore(nextDate)) {
                            break;
                        }
                        unitSdate = nextDate;
                    }

                    unitEdate = unitSdate.plusWeeks(unit).minusDays(1);
                    while (unitEdate.isBefore(targetEdate)) {
                        LocalDate nextDate = unitEdate.plusWeeks(unit);
                        if (targetEdate.isBefore(nextDate)) {
                            break;
                        }
                        unitEdate = nextDate;
                    }
                } else if ("M".equals(applUnit)) {
                    // 단위기간이 월 단위인 경우 단위기간시작기준일로 시작/종료일로 설정한다.
                    int unit = Integer.parseInt(applMinUnit); // 근무유형 단위기간 최소기준

                    // 시작일과 목표일 파싱
                    LocalDate workClassSdate = LocalDate.parse(workClassInfo.get("sdate").toString(), formatter); // 근무유형의 시작일
                    LocalDate targetSdate = LocalDate.parse(chkSdate, formatter); // 신청 시작일
                    LocalDate targetEdate = LocalDate.parse(chkEdate, formatter); // 신청 종료일

                    // 첫 번째 해당일자 찾기
                    int monthStartDay = Integer.parseInt(intervalBeginType);
                    LocalDate firstDate = workClassSdate.withDayOfMonth(monthStartDay);

                    // 목표 날짜가 속한 구간 찾기
                    unitSdate = firstDate;
                    while (unitSdate.isBefore(targetSdate)) {
                        LocalDate nextDate = unitSdate.plusMonths(unit);
                        if (targetSdate.isBefore(nextDate)) {
                            break;
                        }
                        unitSdate = nextDate;
                    }

                    unitEdate = unitSdate.plusMonths(unit).minusDays(1);
                    while (unitEdate.isBefore(targetEdate)) {
                        LocalDate nextDate = unitEdate.plusMonths(unit);
                        if (targetEdate.isBefore(nextDate)) {
                            break;
                        }
                        unitEdate = nextDate;
                    }
                }
            } else if ("A".equals(workTypeCd)) {
                // 선택근무제
                if("W".equals(applUnit)) {
                    // 단위기간이 주 단위인 경우 단위기간시작기준으로 설정한 요일과 단위기간 최소기준에 속하는 단위기간 시작요일 ~ 종료요일의 날짜를 계산한다.
                    int unit = Integer.parseInt(applMinUnit); // 근무유형 단위기간 최소기준

                    // 시작일과 목표일 파싱
                    LocalDate workClassSdate = LocalDate.parse(workClassInfo.get("sdate").toString(), formatter); // 근무유형의 시작일
                    LocalDate targetSdate = LocalDate.parse(chkSdate, formatter); // 신청 시작일
                    LocalDate targetEdate = LocalDate.parse(chkEdate, formatter); // 신청 종료일

                    // 첫 번째 해당 요일 찾기
                    DayOfWeek weekStartDay = convertToDayOfWeek(intervalBeginType);
                    LocalDate firstDate = workClassSdate.with(TemporalAdjusters.nextOrSame(weekStartDay));

                    // 목표 날짜가 속한 구간 찾기
                    unitSdate = firstDate;
                    while (unitSdate.isBefore(targetSdate)) {
                        LocalDate nextDate = unitSdate.plusWeeks(unit);
                        if (targetSdate.isBefore(nextDate)) {
                            break;
                        }
                        unitSdate = nextDate;
                    }

                    unitEdate = unitSdate.plusWeeks(unit).minusDays(1);
                    while (unitEdate.isBefore(targetEdate)) {
                        LocalDate nextDate = unitEdate.plusWeeks(unit);
                        if (targetEdate.isBefore(nextDate)) {
                            break;
                        }
                        unitEdate = nextDate;
                    }
                } else if ("M".equals(applUnit)) {
                    // 단위기간이 월 단위인 경우 단위기간시작기준일로 시작/종료일로 설정한다.
                    int unit = Integer.parseInt(applMinUnit); // 근무유형 단위기간 최소기준

                    // 시작일과 목표일 파싱
                    LocalDate workClassSdate = LocalDate.parse(workClassInfo.get("sdate").toString(), formatter); // 근무유형의 시작일
                    LocalDate targetSdate = LocalDate.parse(chkSdate, formatter); // 신청 시작일
                    LocalDate targetEdate = LocalDate.parse(chkEdate, formatter); // 신청 종료일

                    // 첫 번째 해당일자 찾기
                    int monthStartDay = Integer.parseInt(intervalBeginType);
                    LocalDate firstDate = workClassSdate.withDayOfMonth(monthStartDay);

                    // 목표 날짜가 속한 구간 찾기
                    unitSdate = firstDate;
                    while (unitSdate.isBefore(targetSdate)) {
                        LocalDate nextDate = unitSdate.plusMonths(unit);
                        if (targetSdate.isBefore(nextDate)) {
                            break;
                        }
                        unitSdate = nextDate;
                    }

                    unitEdate = unitSdate.plusMonths(unit).minusDays(1);
                    while (unitEdate.isBefore(targetEdate)) {
                        LocalDate nextDate = unitEdate.plusMonths(unit);
                        if (targetEdate.isBefore(nextDate)) {
                            break;
                        }
                        unitEdate = nextDate;
                    }

                    // 단위기간 시작, 종료일을 포함하는 주 시작, 종료요일을 최종 단위기간으로 설정한다.
                    DayOfWeek weekStartDay = convertToDayOfWeek(weekBeginDay);
                    DayOfWeek weekEndDay = getWeekEndDay(weekBeginDay);

                    unitSdate = unitSdate.minusDays(
                            (unitSdate.getDayOfWeek().getValue() - weekStartDay.getValue() + 7) % 7
                    );

                    unitEdate = unitEdate.plusDays(
                            (weekEndDay.getValue() - unitEdate.getDayOfWeek().getValue() + 7) % 7
                    );
                }
            }

            // 단위기간 시작일, 근무유형 시작일, 개인별 근무유형 시작일 중 가장 큰 값을 단위기간 시작일로 설정한다
            String unitSdateStr = unitSdate.format(formatter);
            if(paramMap.containsKey("workClassSdate") && paramMap.containsKey("psnlSdate")) {
                List<String> sdates = Arrays.asList(unitSdateStr, paramMap.get("workClassSdate").toString(), paramMap.get("psnlSdate").toString());
                unitSdateStr = Collections.max(sdates);
            }

            // 단위기간 종료일, 근무유형 종료일, 개인별 근무유형 종료일 중 가장 작은 값을 단위기간 시작일로 설정한다
            String unitEdateStr = unitEdate.format(formatter);
            if(paramMap.containsKey("workClassEdate") && paramMap.containsKey("psnlEdate")) {
                List<String> edates = Arrays.asList(unitEdateStr, paramMap.get("workClassEdate").toString(), paramMap.get("psnlEdate").toString());
                unitEdateStr = Collections.min(edates);
            }

            double weekCount = ChronoUnit.DAYS.between(unitSdate, unitEdate) / 7.0; // 주차 계산
            resultMap.put("unitSdate", unitSdateStr);
            resultMap.put("unitEdate", unitEdateStr);
            resultMap.put("weekCount", weekCount);
        }

        return resultMap;
    }

    /**
     * 일근무집계 처리
     * @param targetList        집계 대상자 목록
     * @param inOutList         출퇴근 타각 데이터
     * @param wtmWrkDtlDTOList  근무상세데이터
     * @param wtmGntDtlDTOList  근태상세데이터
     * @param holidayList       공휴일 데이터
     * @param workClassInfo     근무유형 데이터 (key: 근무유형, value: 근무유형정보)
     * @param shiftHoliday      교대조 휴일,휴무일 데이터(key: 회사코드, 사번, 근무일의 복합키, value: 휴일,휴무일 구분)
     * @param isCountYn         마감작업여부
     * @return 일근무 집계 데이터
     */
    public Map<String, Object> countDailyWorkTime(
                                                  List<Map<String, Object>> targetList,
                                                  List<Map<String, Object>> inOutList,
                                                  List<WtmWrkDtlDTO> wtmWrkDtlDTOList,
                                                  List<WtmGntDtlDTO> wtmGntDtlDTOList,
                                                  List<Map<String, Object>> holidayList,
                                                  Map<String, Map<String, Object>> workClassInfo,
                                                  Map<WtmCalcGroupKey, String> shiftHoliday,
                                                  boolean isCountYn) throws Exception {
        // 1. 자동 생성 row 삭제 후 작업
        // => 집계 단계에서 재생성 및 근무유형 설정이 변경되었을 가능성이 있기 때문에 항상 삭제 처리하도록 한다.
        List<WtmWrkDtlDTO> delWtmWrkDtlDTOList = new ArrayList<>(); // 삭제 할 row의 리스트
        if(wtmWrkDtlDTOList != null && !wtmWrkDtlDTOList.isEmpty()) {
            for (WtmWrkDtlDTO dto : wtmWrkDtlDTOList) {
                if ("Y".equals(dto.getAutoCreYn())) { // 자동 생성 row인 경우
                    delWtmWrkDtlDTOList.add(dto);
                }
            }
            wtmWrkDtlDTOList.removeAll(delWtmWrkDtlDTOList);
        }

        // 2. 근무일정 시작/종료시간을 구한다
        Map<WtmCalcGroupKey, Map<String, Object>> workStartAndEndTime = new HashMap<>();
        if(wtmWrkDtlDTOList != null && !wtmWrkDtlDTOList.isEmpty()) {
            workStartAndEndTime = getWorkStartAndEndTime(wtmWrkDtlDTOList, wtmGntDtlDTOList);
        }

        // 3. 출퇴근 시간을 바탕으로 근무일정 시작/종료 시간을 재계산한다.
        if(targetList != null && !targetList.isEmpty()) {
            adjustWorkStartAndEndTime(workStartAndEndTime, targetList, workClassInfo, wtmWrkDtlDTOList, wtmGntDtlDTOList, holidayList, shiftHoliday, isCountYn);
        }

        // 4. 이석시간이 존재하는 경우, 휴게시간으로 근무 상세에 추가
        setAwayTime(inOutList, wtmWrkDtlDTOList);

        // 5. 출퇴근 시간을 바탕으로 근무 인정 시작/종료 시간을 계산한다.
        List<WtmWrkDtlDTO> realWorkList = calcRealWorkTime(workStartAndEndTime, wtmWrkDtlDTOList);

        // 6. 생성된 근무 인정 시작/종료시간을 바탕으로 일근무 집계자료(TWTM101)를 생성한다.
        List<WtmDailyCountDTO> wtmDailyCountDTOList = makeDailyCountData(workStartAndEndTime, realWorkList, wtmGntDtlDTOList);

        // 7. 대상자는 존재하나 workSummary 값이 없는 경우, 집계 자료를 초기화 한다.
        // 집계자료가 없는 경우라도 0으로 데이터 입력을 위해 해당 부분 추가
        if(targetList != null && !targetList.isEmpty()) {
            // targetList의 enterCd, sabun, ymd 별 키생성
            Set<WtmCalcGroupKey> targetKeys = targetList.stream()
                    .map(map -> new WtmCalcGroupKey(
                            (String)map.get("enterCd"),
                            (String)map.get("sabun"),
                            (String)map.get("ymd"),
                            null,
                            (String)map.get("workClassCd")))
                    .collect(Collectors.toSet());

            // wtmDailyCountDTOList의 키생성 (
            Set<WtmCalcGroupKey> existingKeys = wtmDailyCountDTOList.stream()
                    .map(dto -> new WtmCalcGroupKey(
                            dto.getEnterCd(),
                            dto.getSabun(),
                            dto.getYmd(),
                            null,
                            dto.getWorkClassCd()))
                    .collect(Collectors.toSet());

            // 누락된 키들에 대해 새로운 DTO 생성
            targetKeys.stream()
                    .filter(key -> !existingKeys.contains(key))
                    .forEach(key -> {
                        WtmDailyCountDTO newDto = createEmptyDailyCountDTO(
                                key.getEnterCd(),
                                key.getSabun(),
                                key.getYmd(),
                                key.getWorkClassCd());
                        wtmDailyCountDTOList.add(newDto);
                    });
        }

        // 일 마감 자료를 map 에 담아서 리턴
        Map<String, Object> result = new HashMap<>();
        result.put("realWorkList", realWorkList);
        result.put("delWorkList", delWtmWrkDtlDTOList);
        result.put("workSummary", wtmDailyCountDTOList);

        return result;

        /*
         * 탄근제..
         * 1. 일연장근무시간: 일 기본근무한도를 넘는 것은 다 연장근무로 취급
         * 2. 주연장근무시간: 특정주 기본근무한도를 넘는 것은 다 연장근무로 취급 -> 근데 이걸 일자로...?
         * 3. 주평균연장근무시간: (평균총근무시간 - 평균 기본근무한도를) * 일자/7 ->
         * */
    }

    /**
     * 출퇴근 시간을 바탕으로 근무 인정 시작/종료 시간을 계산
     * @param workStartAndEndTime 출퇴근 시간데이터
     * @param wtmWrkDtlDTOList 근무 상세 데이터
     * @return 근무 인정 시작/종료 시간
     */
    public List<WtmWrkDtlDTO> calcRealWorkTime(Map<WtmCalcGroupKey, Map<String, Object>> workStartAndEndTime, List<WtmWrkDtlDTO> wtmWrkDtlDTOList) throws Exception {
        List<WtmWrkDtlDTO> realWorkList = new ArrayList<>();

        try {
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HHmm");
            DateTimeFormatter fullFormatter = DateTimeFormatter.ofPattern("yyyyMMddHHmm");

            // 근무리스트를 회사코드, 사번, 일자별로 그룹핑
            Map<WtmCalcGroupKey, List<WtmWrkDtlDTO>> wrkDtlGroup = new HashMap<>();
            for (WtmWrkDtlDTO dto : wtmWrkDtlDTOList) {
                WtmCalcGroupKey key = new WtmCalcGroupKey(dto.getEnterCd(), dto.getSabun(), dto.getYmd());
                wrkDtlGroup.computeIfAbsent(key, k -> new ArrayList<>()).add(dto);
            }

            for (Map.Entry<WtmCalcGroupKey, Map<String, Object>> entry : workStartAndEndTime.entrySet()) {
                WtmCalcGroupKey key = entry.getKey();
                Map<String, Object> map = entry.getValue();

                // 회사코드, 사번, 근무일자가 일치하는 데이터만 추출
                List<WtmWrkDtlDTO> targetWrkDtlList = new ArrayList<>();
                if(wrkDtlGroup.containsKey(key)) {
                    targetWrkDtlList = wrkDtlGroup.get(key);
                }
                for (WtmWrkDtlDTO targetWrkDtl : targetWrkDtlList) {

                    if("Y".equals(targetWrkDtl.getDeemedYn())) { // 간주근로인경우
                        // 간주근로 계획시간 그대로 인정시간으로 설정
                        targetWrkDtl.setRealSymd(targetWrkDtl.getPlanSymd());
                        targetWrkDtl.setRealShm(targetWrkDtl.getPlanShm());
                        targetWrkDtl.setRealEymd(targetWrkDtl.getPlanEymd());
                        targetWrkDtl.setRealEhm(targetWrkDtl.getPlanEhm());
                        if(map.get("isDeemedWork") != null && (boolean) map.get("isDeemedWork")) {
                            // 일단위 간주근로 일때,
                            targetWrkDtl.setRealMm((int) map.get("deemedWorkMm"));
                        } else {
                            targetWrkDtl.setRealMm(targetWrkDtl.getPlanMm());
                        }

                    } else {
                        // 인정 출.퇴근 시간이 있는 경우
                        Object workSdateTimeObj = map.get("workSdateTime");
                        Object workEdateTimeObj = map.get("workEdateTime");

                        if (workSdateTimeObj != null && workEdateTimeObj != null &&
                                !workSdateTimeObj.toString().isEmpty() && !workEdateTimeObj.toString().isEmpty()) {

                            LocalDateTime workSdateTime = (LocalDateTime) map.get("workSdateTime");
                            LocalDateTime workEdateTime = (LocalDateTime) map.get("workEdateTime");

                            // 근무 계획 시작, 종료일자
                            LocalDateTime planStartTime = LocalDateTime.parse(targetWrkDtl.getPlanSymd() + targetWrkDtl.getPlanShm(), fullFormatter);
                            LocalDateTime planEndTime = LocalDateTime.parse(targetWrkDtl.getPlanEymd() + targetWrkDtl.getPlanEhm(), fullFormatter);

                            // 적용 시작 시간 계산
                            LocalDateTime realStartTime;
                            if (planStartTime.isBefore(workSdateTime)) {
                                realStartTime = workSdateTime;
                            } else {
                                realStartTime = planStartTime;
                            }
                            targetWrkDtl.setRealSymd(realStartTime.format(dateFormatter));
                            targetWrkDtl.setRealShm(realStartTime.format(timeFormatter));

                            // 적용 종료 시간 계산
                            LocalDateTime realEndTime;
                            if (planEndTime.isAfter(workEdateTime)) {
                                realEndTime = workEdateTime;
                            } else {
                                realEndTime = planEndTime;
                            }
                            targetWrkDtl.setRealEymd(realEndTime.format(dateFormatter));
                            targetWrkDtl.setRealEhm(realEndTime.format(timeFormatter));

                            // 실제 근무 시간 재 계산 (분 단위)
                            int realWorkMinutes = 0;
                            if (realStartTime.isBefore(realEndTime)) {
                                realWorkMinutes = (int) Duration.between(realStartTime, realEndTime).toMinutes();
                            }
                            targetWrkDtl.setRealMm(realWorkMinutes);
                        } else {
                            // 출,퇴근 시간이 없는 경우 인정 시간 0으로 설정
                            targetWrkDtl.setRealSymd("");
                            targetWrkDtl.setRealShm("");
                            targetWrkDtl.setRealEymd("");
                            targetWrkDtl.setRealEhm("");
                            targetWrkDtl.setRealMm(0);
                        }
                    }
                    realWorkList.add(targetWrkDtl);
                }
            }
        } catch (Exception e) {
            Log.Error(e.toString());
            throw new HrException("인정 근무 시간 계산 작업중 오류가 발생했습니다. 관리자에게 문의하세요.");
        }

        return realWorkList;
    }

    public void setAwayTime(List<Map<String, Object>> inOutList, List<WtmWrkDtlDTO> wtmWrkDtlDTOList) {
        Map<WtmCalcGroupKey, List<WtmWrkDtlDTO>> autoCreWtmBreakList = new HashMap<>();
        DateTimeFormatter fullFormatter = DateTimeFormatter.ofPattern("yyyyMMddHHmm");

        // 출퇴근 리스트 회사코드, 사번, 일자별 그룹핑
        Map<WtmCalcGroupKey, List<Map<String, Object>>> inOutGroup = new HashMap<>();
        for (Map<String, Object> inOut : inOutList) {
            WtmCalcGroupKey key = new WtmCalcGroupKey(inOut.get("enterCd").toString(), inOut.get("sabun").toString(), inOut.get("ymd").toString());

            String inYmd = (String) inOut.get("inYmd");
            String inHm = (String) inOut.get("inHm");
            String outYmd = (String) inOut.get("outYmd");
            String outHm = (String) inOut.get("outHm");

            // 1. 이석여부가 Y 인 항목 휴게시간 데이터 생성
            if("Y".equals(inOut.get("awayYn")) && !inYmd.isEmpty() && !inHm.isEmpty() && !outYmd.isEmpty() && !outHm.isEmpty()) {

                LocalDateTime in = LocalDateTime.parse(inYmd+inHm, fullFormatter);
                LocalDateTime out = LocalDateTime.parse(outYmd+outHm, fullFormatter);
                int breakMm =  (int) Duration.between(in, out).toMinutes();

                WtmWrkDtlDTO autoCreBreak = new WtmWrkDtlDTO();
                autoCreBreak.setEnterCd(key.getEnterCd());
                autoCreBreak.setWrkDtlId(TsidCreator.getTsid().toString());
                autoCreBreak.setYmd(key.getYmd());
                autoCreBreak.setSabun(key.getSabun());
                autoCreBreak.setWorkCd(getBreakWorkCd());
                autoCreBreak.setPlanSymd(inYmd);
                autoCreBreak.setPlanShm(inHm);
                autoCreBreak.setPlanEymd(outYmd);
                autoCreBreak.setPlanEhm(outHm);
                autoCreBreak.setPlanMm(breakMm);
                autoCreBreak.setAutoCreYn("Y");
                autoCreBreak.setAddWorkTimeYn("N");
                autoCreBreak.setNewDataYn("Y");
                autoCreBreak.setWorkTimeType(WORK_TIME_TYPE_BREAK); // 휴게시간
                autoCreWtmBreakList.computeIfAbsent(key, k -> new ArrayList<>()).add(autoCreBreak);
            } else {
                inOutGroup.computeIfAbsent(key, k -> new ArrayList<>()).add(inOut);
            }
        }

        // 근무상세 회사코드, 사번, 일자별 그룹핑
        Map<WtmCalcGroupKey, List<WtmWrkDtlDTO>> wrkDtlGroup = new HashMap<>();
        for (WtmWrkDtlDTO dto : wtmWrkDtlDTOList) {
            WtmCalcGroupKey key = new WtmCalcGroupKey(dto.getEnterCd(), dto.getSabun(), dto.getYmd());
            wrkDtlGroup.computeIfAbsent(key, k -> new ArrayList<>()).add(dto);
        }

        for (Map.Entry<WtmCalcGroupKey, List<Map<String, Object>>> entry : inOutGroup.entrySet()) {
            WtmCalcGroupKey key = entry.getKey();

            // 순번 1에서 생성한 휴게리스트 가져오기
            List<WtmWrkDtlDTO> autoCreWtmBreakDatas = new ArrayList<>();
            if(autoCreWtmBreakList.containsKey(key)) {
                autoCreWtmBreakDatas = autoCreWtmBreakList.get(key);
            }

            List<Map<String, Object>> inoutDatas = entry.getValue();

            // 출근시간 오름차순으로 정렬
            inoutDatas.sort((m1, m2) -> {
                String inYmd1 = (String) m1.get("inYmd");
                String inYmd2 = (String) m2.get("inYmd");
                String inHm1 = (String) m1.get("inHm");
                String inHm2 = (String) m2.get("inHm");

                return inYmd1.equals(inYmd2) ? inHm1.compareTo(inHm2) : inYmd1.compareTo(inYmd2);
            });

            for (int i = 0; i < inoutDatas.size() - 1; i++) {
                Map<String, Object> current = inoutDatas.get(i);
                Map<String, Object> next = inoutDatas.get(i + 1);

                // 현재 행의 퇴근 시간
                String currentOutYmd = (String) current.get("outYmd");
                String currentOutHm = (String) current.get("outHm");

                // 다음 행의 출근 시간
                String nextInYmd = (String) next.get("inYmd");
                String nextInHm = (String) next.get("inHm");

                // 시간 비교
                String currentOutTime = currentOutYmd + currentOutHm;
                String nextInTime = nextInYmd + nextInHm;

                // 현재행의 퇴근 시간과 다음 행의 출근시간 사이에 갭이 존재한다면, 그 갭만큼 휴게시간으로 부여한다.
                if (!currentOutTime.equals(nextInTime)) {

                    // 휴게 정보 생성
                    LocalDateTime in = LocalDateTime.parse(currentOutYmd+currentOutHm, fullFormatter);
                    LocalDateTime out = LocalDateTime.parse(nextInYmd+nextInHm, fullFormatter);
                    int breakMm =  (int) Duration.between(in, out).toMinutes();

                    WtmWrkDtlDTO autoCreBreak = new WtmWrkDtlDTO();
                    autoCreBreak.setEnterCd(key.getEnterCd());
                    autoCreBreak.setWrkDtlId(TsidCreator.getTsid().toString());
                    autoCreBreak.setYmd(key.getYmd());
                    autoCreBreak.setSabun(key.getSabun());
                    autoCreBreak.setWorkCd(getBreakWorkCd());
                    autoCreBreak.setPlanSymd(currentOutYmd);
                    autoCreBreak.setPlanShm(currentOutHm);
                    autoCreBreak.setPlanEymd(nextInYmd);
                    autoCreBreak.setPlanEhm(nextInHm);
                    autoCreBreak.setPlanMm(breakMm);
                    autoCreBreak.setAutoCreYn("Y");
                    autoCreBreak.setAddWorkTimeYn("N");
                    autoCreBreak.setNewDataYn("Y");
                    autoCreBreak.setWorkTimeType(WORK_TIME_TYPE_BREAK); // 휴게시간

                    autoCreWtmBreakDatas.add(autoCreBreak);
                }
            }

            List<WtmWrkDtlDTO> wrkDtlList = new ArrayList<>();
            if(wrkDtlGroup.containsKey(key)) {
                wrkDtlList = wrkDtlGroup.get(key);
            }

            // 일치하는 데이터가 없는 경우, 휴게 정보 입력
            if(!wrkDtlList.isEmpty()) {
                // 근무 상세 데이터중 자동생성 휴게시간과 일치하는 데이터가 없는 경우, 휴게시간 데이터 추가
                for (WtmWrkDtlDTO breakDtl : autoCreWtmBreakDatas) {
                    boolean exists = false;

                    for (WtmWrkDtlDTO wrkDtl : wrkDtlList) {
                        if( breakDtl.getWorkCd().equals(wrkDtl.getWorkCd()) &&
                            breakDtl.getPlanSymd().equals(wrkDtl.getPlanSymd()) &&
                            breakDtl.getPlanShm().equals(wrkDtl.getPlanShm()) &&
                            breakDtl.getPlanEymd().equals(wrkDtl.getPlanEymd()) &&
                            breakDtl.getPlanEhm().equals(wrkDtl.getPlanEhm())) {
                            exists = true;
                            break;
                        }
                    }

                    if (!exists) {
                        wtmWrkDtlDTOList.add(breakDtl);
                    }
                }
            } else {
                wtmWrkDtlDTOList.addAll(autoCreWtmBreakDatas);
            }
        }
    }

    /**
     * 근무 인정 시작/종료 시간을 바탕으로 일집계 데이터 생성
     *
     * @param workStartAndEndTime 대상자 정보
     * @param wtmWrkDtlDTOList    인정 근무 시간을 포함한 근무 상세 데이터
     * @param wtmGntDtlDTOList    일 근태 상세 데이터
     * @return 일 집계 데이터
     */
    public List<WtmDailyCountDTO> makeDailyCountData(Map<WtmCalcGroupKey, Map<String, Object>> workStartAndEndTime, List<WtmWrkDtlDTO> wtmWrkDtlDTOList, List<WtmGntDtlDTO> wtmGntDtlDTOList) throws Exception {
        List<WtmDailyCountDTO> wtmDailyCountDTOList = new ArrayList<>();

        try {
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HHmm");
            DateTimeFormatter fullFormatter = DateTimeFormatter.ofPattern("yyyyMMddHHmm");


            Map<WtmCalcGroupKey, List<WtmWrkDtlDTO>> wtmWrkDtlWorkTypeGroup = new HashMap<>();
            Map<WtmCalcGroupKey, List<WtmWrkDtlDTO>> wtmWrkBreakDtlGroup = new HashMap<>();

            // 근무 상세 그룹핑
            for (WtmWrkDtlDTO dto : wtmWrkDtlDTOList) {
                // 인정 근무시간이 존재하는 경우에만 집계 처리
                if (dto.getRealMm() <= 0) {
                    continue;
                }

                WtmCalcGroupKey key = new WtmCalcGroupKey(dto.getEnterCd(), dto.getSabun(), dto.getYmd());
                if(dto.getAddWorkTimeYn().equals("Y")) {
                    // 인정 시간이 존재하는 근무 상세를 회사코드, 사번, 일자, 근무시간유형별로 그룹핑
                    wtmWrkDtlWorkTypeGroup.computeIfAbsent(key, k -> new ArrayList<>()).add(dto);
                } else {
                    // 인정 시간이 존재하는 근무 상세중 차감시간만 회사코드, 사번, 일자로 그룹핑
                    wtmWrkBreakDtlGroup.computeIfAbsent(key, k -> new ArrayList<>()).add(dto);
                }
            }

            // 근태 상세 그룹핑
            Map<WtmCalcGroupKey, List<WtmGntDtlDTO>> wtmGntDtlGroup = new HashMap<>();
            for (WtmGntDtlDTO dto : wtmGntDtlDTOList) {
                WtmCalcGroupKey key = new WtmCalcGroupKey(dto.getEnterCd(), dto.getSabun(), dto.getYmd());
                wtmGntDtlGroup.computeIfAbsent(key, k -> new ArrayList<>()).add(dto);
            }

            // 집계 대상자, 일자별 처리
            for (Map.Entry<WtmCalcGroupKey, Map<String, Object>> entry : workStartAndEndTime.entrySet()) {
                WtmCalcGroupKey key = entry.getKey();
                Map<String, Object> psnlDate = entry.getValue();

                /* 1. 휴게 등 제외시간을 차감한 일 근무시간을 계산 */
                // 집계 대상자, 일자별 근무시간 추가할 근무 상세 정보 전체 가져오기.
                List<WtmWrkDtlDTO> psnlDailyWrkDtlList = new ArrayList<>();
                if(wtmWrkDtlWorkTypeGroup.containsKey(key)) psnlDailyWrkDtlList = wtmWrkDtlWorkTypeGroup.get(key);

                // 집계 대상자의 일자별 차감시간 정보 가져오기
                List<WtmWrkDtlDTO> wtmWrkBreakDtlList = new ArrayList<>();
                if(wtmWrkBreakDtlGroup.containsKey(key))
                    wtmWrkBreakDtlList = wtmWrkBreakDtlGroup.get(key);

                // 일단위 간주근로 시간 조회
                int deemedWorkMm = 0;
                deemedWorkMm = (int) psnlDate.get("deemedWorkMm");

                // 인정 근무 시작, 종료시간이 없는 데이터 제외
                psnlDailyWrkDtlList.removeIf(a -> {
                    String realSymdHm = a.getRealSymd() + a.getRealShm();
                    String realEymdHm = a.getRealEymd() + a.getRealEhm();
                    return (a.getRealSymd() == null || a.getRealShm() == null || realSymdHm.length() != 12) &&
                           (a.getRealEymd() == null || a.getRealEhm() == null || realEymdHm.length() != 12);
                });
                // 인정 근무 시작 시간 기준으로 정렬
                psnlDailyWrkDtlList.sort(Comparator.comparing(a -> (a.getRealSymd() + a.getRealShm())));

                int basicMm = deemedWorkMm;
                int ltnMm = 0;
                int otMm = 0;
                for (int i = 0; i < psnlDailyWrkDtlList.size(); i++) {
                    WtmWrkDtlDTO curWrkDtl = psnlDailyWrkDtlList.get(i);
                    int workMm = 0;
                    int nightMm = 0;

                    // 기본근무, 연장근무, 간주근로인경우에만 집계
                    if(curWrkDtl.getWorkTimeType().equals(WORK_TIME_TYPE_BASE) || curWrkDtl.getWorkTimeType().equals(WORK_TIME_TYPE_OT) || "Y".equals(curWrkDtl.getDeemedYn())) {

                        LocalDateTime currentStart = LocalDateTime.parse(curWrkDtl.getRealSymd()+curWrkDtl.getRealShm(),fullFormatter);
                        LocalDateTime currentEnd = LocalDateTime.parse(curWrkDtl.getRealEymd()+curWrkDtl.getRealEhm(),fullFormatter);

                        workMm += curWrkDtl.getRealMm(); // 근무시간 계산
                        nightMm += calcNightMm(currentStart, currentEnd); // 심야시간 계산

                        // 차감시간 계산
                        if(wtmWrkBreakDtlList != null && !wtmWrkBreakDtlList.isEmpty()) {
                            Map<String, Integer> dedResult = calcWrkBreakDedMin(wtmWrkBreakDtlGroup.get(key), currentStart, currentEnd, true);
                            // 대상 시간 차감
                            workMm -= dedResult.get("dedMm");
                            // 야간 시간 차감
                            nightMm -= dedResult.get("nightDedMm");
                        }

                        // 다른 근무 상세 데이터와 시간 범위가 중복되는지 체크
                        for (int j = i + 1; j < psnlDailyWrkDtlList.size(); j++) {
                            WtmWrkDtlDTO nextWrkDtl = psnlDailyWrkDtlList.get(j);

                            LocalDateTime nextStart = LocalDateTime.parse(nextWrkDtl.getRealSymd()+nextWrkDtl.getRealShm(),fullFormatter);
                            LocalDateTime nextEnd = LocalDateTime.parse(nextWrkDtl.getRealEymd()+nextWrkDtl.getRealEhm(),fullFormatter);

                            // 중복 시간 계산
                            if (nextStart.isBefore(currentEnd)) {
                                // 시작, 종료 시간이 겹치는 구간 계산
                                LocalDateTime overlapStart = nextStart.isAfter(currentStart) ? nextStart : currentStart;
                                LocalDateTime overlapEnd = nextEnd.isBefore(currentEnd) ? nextEnd : currentEnd;

                                // 중복 시간은 차감한다.
                                int overlapMinutes = (int) Duration.between(overlapStart, overlapEnd).toMinutes();
                                workMm -= overlapMinutes;
                                nightMm -= calcNightMm(overlapStart, overlapEnd);
                            }
                        }

                        if(curWrkDtl.getWorkTimeType().equals(WORK_TIME_TYPE_BASE) || "Y".equals(curWrkDtl.getDeemedYn())) {
                            // 기본근무이거나 간주근로인 경우 기본근무시간으로 계산
                            basicMm += workMm;
                        } else if(curWrkDtl.getWorkTimeType().equals(WORK_TIME_TYPE_OT)) {
                            otMm += workMm;
                        }
                        ltnMm += nightMm;
                    }
                }

                /* 2. 일 휴가시간 계산 */
                // 집계 대상자의 일자별 휴가 정보 가져오기
                List<WtmGntDtlDTO> psnlDailyGntDtlList = new ArrayList<>();
                if(wtmGntDtlGroup.containsKey(key))
                    psnlDailyGntDtlList = wtmGntDtlGroup.get(key);

                int vacationMm = 0;
                for(WtmGntDtlDTO dto : psnlDailyGntDtlList) {
                    vacationMm += dto.getMm(); // 적용 휴가시간 집계
                }

                // 대상자 집계 자료 삽입
                WtmDailyCountDTO wtmDailyCountDTO = new WtmDailyCountDTO();
                wtmDailyCountDTO.setEnterCd(key.getEnterCd());
                wtmDailyCountDTO.setSabun(key.getSabun());
                wtmDailyCountDTO.setYmd(key.getYmd());
                wtmDailyCountDTO.setWorkClassCd(psnlDate.get("workClassCd").toString());
                wtmDailyCountDTO.setDayType(psnlDate.get("dayType").toString());
                wtmDailyCountDTO.setBasicMm(basicMm);
                wtmDailyCountDTO.setOtMm(otMm);
                wtmDailyCountDTO.setLtnMm(ltnMm);
                wtmDailyCountDTO.setVacationMm(vacationMm);

                LocalDateTime in = null;
                if(psnlDate.get("workSdateTime") != null) {
                    in = (LocalDateTime) psnlDate.get("workSdateTime"); // 인정출근시간

                    wtmDailyCountDTO.setInYmd(in.format(dateFormatter));
                    wtmDailyCountDTO.setInHm(in.format(timeFormatter));
                }

                LocalDateTime out = null;
                if(psnlDate.get("workEdateTime") != null) {
                    out = (LocalDateTime) psnlDate.get("workEdateTime"); // 인정퇴근시간

                    wtmDailyCountDTO.setOutYmd(out.format(dateFormatter));
                    wtmDailyCountDTO.setOutHm(out.format(timeFormatter));
                }

                // 지각여부 확인
                String lateYn = "N";
                if(psnlDate.get("baseWorkSdateTime") != null && in != null) {
                    LocalDateTime baseStart = (LocalDateTime) psnlDate.get("baseWorkSdateTime"); // 기본근무시작시간

                    if(in.isAfter(baseStart))
                        lateYn = "Y";
                }
                wtmDailyCountDTO.setLateYn(lateYn);

                // 조퇴여부 확인
                String leaveEarlyYn = "N";
                if(psnlDate.get("baseWorkEdateTime") != null && out != null) {
                    LocalDateTime baseEnd = (LocalDateTime) psnlDate.get("baseWorkEdateTime"); // 기본근무종료시간

                    if(out.isBefore(baseEnd))
                        leaveEarlyYn = "Y";
                }
                wtmDailyCountDTO.setLeaveEarlyYn(leaveEarlyYn);

                // 결근여부 확인
                String absenceYn = "N";
                // 출근 시간과 인정 기본근무시간이 없고, 기본근무 시작/종료시간과 휴게 시작 종료시간이 일치하지 않는경우 결근처리
                if(in == null && basicMm == 0 && psnlDate.get("baseWorkSdateTime") != null && psnlDate.get("baseWorkEdateTime") != null) {
                    LocalDateTime baseStart = (LocalDateTime) psnlDate.get("baseWorkSdateTime"); // 기본근무시작시간
                    LocalDateTime baseEnd = (LocalDateTime) psnlDate.get("baseWorkSdateTime"); // 기본근무시작시간

                    if(!baseStart.equals(baseEnd))
                        absenceYn = "Y";
                }
                wtmDailyCountDTO.setAbsenceYn(absenceYn);

                wtmDailyCountDTOList.add(wtmDailyCountDTO);
            }
        } catch (Exception e) {
            Log.Error(e.toString());
            throw new HrException("일 집계 데이터 생성 작업중 오류가 발생했습니다. 관리자에게 문의하세요.");
        }

        return wtmDailyCountDTOList;
    }

    /**
     * 근무디테일에서 근무 차감시간 계산하기 (휴게시간 등 addWorkTimeYn 이 'N'인 항목)
     *
     * @param wrkDtlList    근무디테일 리스트
     * @param workSdateTime 근무일정 시작 시간
     * @param workEdateTime 근무일정 종료 시간
     * @param useReal       인정근무 사용여부
     * @return 근무차감시간(key : dedMm), 야간근무차감시간(key: nightDedMm)
     */
    private Map<String, Integer> calcWrkBreakDedMin(List<WtmWrkDtlDTO> wrkDtlList,
                                                    LocalDateTime workSdateTime,
                                                    LocalDateTime workEdateTime,
                                                    boolean useReal){
        Map<String, Integer> result = new HashMap<>();
        int dedMm = 0;
        int nightDedMm = 0;

        DateTimeFormatter fullFormatter = DateTimeFormatter.ofPattern("yyyyMMddHHmm");
        for (WtmWrkDtlDTO wrkDtl : wrkDtlList) {
            if ("N".equals(wrkDtl.getAddWorkTimeYn())) {
                LocalDateTime from = null, to = null;
                if(useReal) {
                    from = LocalDateTime.parse(wrkDtl.getRealSymd() + wrkDtl.getRealShm(), fullFormatter); // 차감시간 시작시간
                    to = LocalDateTime.parse(wrkDtl.getRealEymd() + wrkDtl.getRealEhm(),fullFormatter); // 차감시간 종료시간
                } else {
                    from = LocalDateTime.parse(wrkDtl.getPlanSymd() + wrkDtl.getPlanShm(), fullFormatter); // 차감시간 시작시간
                    to = LocalDateTime.parse(wrkDtl.getPlanEymd() + wrkDtl.getPlanEhm(),fullFormatter); // 차감시간 종료시간
                }

                if (!from.isBefore(workEdateTime)) continue;

                // 계산 시작 시간 보정
                LocalDateTime calFrom = from.isBefore(workSdateTime) ? workSdateTime : from;
                if (calFrom.isAfter(to)) continue;

                // 계산 종료 시간 보정
                LocalDateTime calTo = to.isAfter(workEdateTime) ? workEdateTime : to;

                // 전체 차감시간 계산
                dedMm += (int) Duration.between(calFrom, calTo).toMinutes();

                // 야간 차감 시간 계산
                nightDedMm += calcNightMm(calFrom, calTo);
            }
        }

        result.put("dedMm", dedMm);
        result.put("nightDedMm", nightDedMm);

        return result;
    }

    /**
     * 근태디테일에 시작, 종료시간 설정
     * @param gntDtlList 근태디테일 리스트
     * @param baseWorkSdateTime 기본근무시작시간
     * @param baseWorkEdateTime 기본근무종료시간
     */
    private void setVacationTime(List<WtmGntDtlDTO> gntDtlList, LocalDateTime baseWorkSdateTime, LocalDateTime baseWorkEdateTime) {
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HHmm");

        for (WtmGntDtlDTO gntDtl : gntDtlList) {
            LocalDateTime vacationStart = null;
            LocalDateTime vacationEnd = null;

            // 휴가 시작, 종료시간 계산
            switch (gntDtl.getRequestUseType()) {
                // 종일단위 휴가인 경우
                // 휴가시작시간: 기본근무시작시간, 휴가종료시간: 기본근무종료시간
                case "D":
                    vacationStart = baseWorkSdateTime;
                    vacationEnd = baseWorkEdateTime;
                    break;
                // 오후반차, 오후반반차2 인 경우
                // 휴가종료시간: 기본근무종료시간, 휴가시작시간: 기본근무종료시간 - 적용시간(분)
                case "PM":
                case "HPM2":
                    vacationEnd = baseWorkEdateTime;
                    vacationStart = baseWorkEdateTime.minusMinutes(gntDtl.getMm());
                    break;
                // 오전반차, 오전반반차1 인 경우
                // 휴가시작시간: 기본근무시작시간, 휴가종료시간: 기본근무시작시간 - 적용시간(분)
                case "AM":
                case "HAM1":
                    vacationStart = baseWorkSdateTime;
                    vacationEnd = baseWorkSdateTime.plusMinutes(gntDtl.getMm());
                    break;
                // 오후반반차1 인 경우
                // 휴가종료시간: 기본근무종료시간 - 적용시간(분), 휴가시작시간: 휴가종료시간 - 적용시간(분)
                case "HPM1":
                    vacationEnd = baseWorkEdateTime.minusMinutes(gntDtl.getMm());
                    vacationStart = vacationEnd.minusMinutes(gntDtl.getMm());
                    break;
                // 오전반반차2 인 경우
                // 휴가시작시간: 기본근무시작시간 + 적용시간(분), 휴가종료시간: 휴가시작시간 + 적용시간(분)
                case "HAM2":
                    vacationStart = baseWorkSdateTime.plusMinutes(gntDtl.getMm());
                    vacationEnd = vacationStart.plusMinutes(gntDtl.getMm());
                    break;
            }

            if(vacationStart != null && vacationEnd != null) {
                gntDtl.setSymd(vacationStart.format(dateFormatter));
                gntDtl.setShm(vacationStart.format(timeFormatter));
                gntDtl.setEymd(vacationEnd.format(dateFormatter));
                gntDtl.setEhm(vacationEnd.format(timeFormatter));
            }

        }
    }

    /**
     * 근무계획 자동생성
     * @param paramMap      기본 파라미터
     * @param workClassInfo 근무유형 정보
     * @return 생성한 근무 상세 리스트(휴게시간 포함)
     */
    private List<WtmWrkDtlDTO> getAutoCreWtmWrkList(Map<String, String> paramMap, Map<String, Object> workClassInfo) throws Exception{
        List<WtmWrkDtlDTO> autoCreWtmWrkDtlList = new ArrayList<>();

        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HHmm");
        DateTimeFormatter fullFormatter = DateTimeFormatter.ofPattern("yyyyMMddHHmm");

        try{
            String enterCd = paramMap.get("enterCd");
            String ymd = paramMap.get("ymd");
            String sabun = paramMap.get("sabun");
            String workCd = paramMap.get("workCd");
            String symd = paramMap.get("symd");
            String shm = paramMap.get("shm");
            String eymd = paramMap.get("eymd");
            String ehm = paramMap.get("ehm");
            String addWorkTimeYn = paramMap.get("addWorkTimeYn");
            String workTimeType = paramMap.get("workTimeType");
            LocalDateTime in = LocalDateTime.parse(symd+shm, fullFormatter);
            LocalDateTime out = LocalDateTime.parse(eymd+ehm, fullFormatter);
            int baseWorkMm =  (int) Duration.between(in, out).toMinutes();

            // 근무 정보 추가
            WtmWrkDtlDTO autoCreWtmWrkDtl = new WtmWrkDtlDTO();
            autoCreWtmWrkDtl.setEnterCd(enterCd);
            autoCreWtmWrkDtl.setWrkDtlId(TsidCreator.getTsid().toString());
            autoCreWtmWrkDtl.setYmd(ymd);
            autoCreWtmWrkDtl.setSabun(sabun);
            autoCreWtmWrkDtl.setWorkCd(workCd);
            autoCreWtmWrkDtl.setPlanSymd(symd);
            autoCreWtmWrkDtl.setPlanShm(shm);
            autoCreWtmWrkDtl.setPlanEymd(eymd);
            autoCreWtmWrkDtl.setPlanEhm(ehm);
            autoCreWtmWrkDtl.setPlanMm(baseWorkMm);
            autoCreWtmWrkDtl.setAutoCreYn("Y");
            autoCreWtmWrkDtl.setAddWorkTimeYn(addWorkTimeYn);
            autoCreWtmWrkDtl.setNewDataYn("Y");
            autoCreWtmWrkDtl.setWorkTimeType(workTimeType);
            autoCreWtmWrkDtlList.add(autoCreWtmWrkDtl);

            // 휴게시간 추가 (일 기본 휴게시간 타입이 임직원 자율인 경우, 휴게시간 입력 안함)
            String breakTimeType = workClassInfo.get("breakTimeType").toString();
            if(workCd.equals(getBaseWorkCd()) && breakTimeType.equals("A")) {
                // 지정휴게
                String breakTimeDet = workClassInfo.get("breakTimeDet").toString();

                // ',' 단위로 값 자르기
                if(breakTimeDet != null && !breakTimeDet.trim().isEmpty()) {
                    String[] datas = breakTimeDet.split(",");
                    for (String data : datas) {
                        String[] times = data.trim().split("-");
                        if (times.length == 2) {
                            String startTime = times[0].trim();
                            String endTime = times[1].trim();

                            LocalDateTime breakStrTime = LocalDateTime.parse(ymd+startTime, fullFormatter);
                            LocalDateTime breakEndTime = LocalDateTime.parse(ymd+endTime, fullFormatter);
                            int breakMm =  (int) Duration.between(breakStrTime, breakEndTime).toMinutes();

                            WtmWrkDtlDTO autoCreBreak = new WtmWrkDtlDTO();
                            autoCreBreak.setEnterCd(enterCd);
                            autoCreBreak.setWrkDtlId(TsidCreator.getTsid().toString());
                            autoCreBreak.setYmd(ymd);
                            autoCreBreak.setSabun(sabun);
                            autoCreBreak.setWorkCd(getBreakWorkCd());
                            autoCreBreak.setPlanSymd(ymd);
                            autoCreBreak.setPlanShm(startTime);
                            autoCreBreak.setPlanEymd(ymd);
                            autoCreBreak.setPlanEhm(endTime);
                            autoCreBreak.setPlanMm(breakMm);
                            autoCreBreak.setAutoCreYn("Y");
                            autoCreBreak.setAddWorkTimeYn("N");
                            autoCreBreak.setNewDataYn("Y");
                            autoCreBreak.setWorkTimeType(WORK_TIME_TYPE_BREAK); // 휴게시간
                            autoCreWtmWrkDtlList.add(autoCreBreak);
                        }
                    }
                }
            } else if(workCd.equals(getOtWorkCd()) || (workCd.equals(getBaseWorkCd()) && breakTimeType.equals("B"))) {
                // 근무시간 기준
                int breakTimeT = 0;
                int breakTimeR = 0;

                if(workCd.equals(getBaseWorkCd())) { // 기본근무 휴게시간
                    breakTimeT = 60 * Integer.parseInt(StringUtils.defaultIfEmpty(String.valueOf(workClassInfo.get("breakTimeT")), "0"));
                    breakTimeR = Integer.parseInt(StringUtils.defaultIfEmpty(String.valueOf(workClassInfo.get("breakTimeR")), "0"));
                } else if (workCd.equals(getOtWorkCd())) { // 연장근무 휴게시간
                    breakTimeT = 60 * Integer.parseInt(StringUtils.defaultIfEmpty(String.valueOf(workClassInfo.get("otBreakTimeT")), "0"));
                    breakTimeR = Integer.parseInt(StringUtils.defaultIfEmpty(String.valueOf(workClassInfo.get("otBreakTimeR")), "0"));
                }

                // 휴게시간 삽입
                if (breakTimeT > 0 && breakTimeR > 0 && baseWorkMm >= breakTimeT) {
                    // 시작 시간
                    LocalDateTime currentTime = in;
                    int remainingMinutes = baseWorkMm;

                    while (remainingMinutes >= breakTimeT) {
                        // 휴게시간 기준 이후 시점 계산
                        LocalDateTime breakStartTime = currentTime.plusMinutes(breakTimeT);
                        // 휴게시간 후의 시점 계산
                        LocalDateTime breakEndTime = breakStartTime.plusMinutes(breakTimeR);

                        WtmWrkDtlDTO autoCreBreak = new WtmWrkDtlDTO();
                        autoCreBreak.setEnterCd(enterCd);
                        autoCreBreak.setWrkDtlId(TsidCreator.getTsid().toString());
                        autoCreBreak.setYmd(ymd);
                        autoCreBreak.setSabun(sabun);
                        autoCreBreak.setWorkCd(getBreakWorkCd());
                        autoCreBreak.setPlanSymd(breakStartTime.format(dateFormatter));
                        autoCreBreak.setPlanShm(breakStartTime.format(timeFormatter));
                        autoCreBreak.setPlanEymd(breakEndTime.format(dateFormatter));
                        autoCreBreak.setPlanEhm(breakEndTime.format(timeFormatter));
                        autoCreBreak.setPlanMm(breakTimeR);
                        autoCreBreak.setAutoCreYn("Y");
                        autoCreBreak.setAddWorkTimeYn("N");
                        autoCreBreak.setNewDataYn("Y");
                        autoCreBreak.setWorkTimeType(WORK_TIME_TYPE_BREAK); // 휴게시간
                        autoCreWtmWrkDtlList.add(autoCreBreak);

                        // 다음 계산을 위해 현재 시간과 남은 시간 업데이트
                        currentTime = breakEndTime;
                        remainingMinutes -= (breakTimeT + breakTimeR);
                    }
                }

            }

        } catch (Exception e) {
            Log.Error(e.toString());
            throw new HrException("근무 자동 생성시 오류가 발생했습니다. 관리자에게 문의하세요.");
        }

        return autoCreWtmWrkDtlList;
    }


    /**
     * 근태디테일에서 휴가 차감시간 계산하기
     * @param gntDtlList 근태디테일 리스트
     * @param baseWorkSdateTime 기본근무시작시간
     * @param baseWorkEdateTime 기본근무종료시간
     * @param workSdateTime 근무일정시작시간
     * @param workEdateTime 근무일정종료시간
     * @return 총 휴가 차감시간
     */
    private int calcVacationDedMin(List<WtmGntDtlDTO> gntDtlList,
                                   LocalDateTime baseWorkSdateTime, LocalDateTime baseWorkEdateTime,
                                   LocalDateTime workSdateTime, LocalDateTime workEdateTime) {

        DateTimeFormatter fullFormatter = DateTimeFormatter.ofPattern("yyyyMMddHHmm");
        int totalDeductMinutes = 0;
        // 휴가 목록만큼 수행한다.
        for (WtmGntDtlDTO gntDtl : gntDtlList) {
            LocalDateTime vacationStart = null;
            LocalDateTime vacationEnd = null;

            if(!gntDtl.getSymd().isEmpty() && !gntDtl.getShm().isEmpty() && !gntDtl.getEymd().isEmpty() && !gntDtl.getEhm().isEmpty()) {
                vacationStart = LocalDateTime.parse(gntDtl.getSymd()+gntDtl.getShm(), fullFormatter);
                vacationEnd = LocalDateTime.parse(gntDtl.getEymd()+gntDtl.getEhm(), fullFormatter);
            } else {
                // 휴가 시작, 종료시간 계산
                switch (gntDtl.getRequestUseType()) {
                    // 종일단위 휴가인 경우
                    // 휴가시작시간: 기본근무시작시간, 휴가종료시간: 기본근무종료시간
                    case "D":
                        vacationStart = baseWorkSdateTime;
                        vacationEnd = baseWorkEdateTime;
                        break;
                    // 오후반차, 오후반반차2 인 경우
                    // 휴가종료시간: 기본근무종료시간, 휴가시작시간: 기본근무종료시간 - 적용시간(분)
                    case "PM":
                    case "HPM2":
                        vacationEnd = baseWorkEdateTime;
                        vacationStart = baseWorkEdateTime.minusMinutes(gntDtl.getMm());
                        break;
                    // 오전반차, 오전반반차1 인 경우
                    // 휴가시작시간: 기본근무시작시간, 휴가종료시간: 기본근무시작시간 - 적용시간(분)
                    case "AM":
                    case "HAM1":
                        vacationStart = baseWorkSdateTime;
                        vacationEnd = baseWorkSdateTime.plusMinutes(gntDtl.getMm());
                        break;
                    // 오후반반차1 인 경우
                    // 휴가종료시간: 기본근무종료시간 - 적용시간(분), 휴가시작시간: 휴가종료시간 - 적용시간(분)
                    case "HPM1":
                        vacationEnd = baseWorkEdateTime.minusMinutes(gntDtl.getMm());
                        vacationStart = vacationEnd.minusMinutes(gntDtl.getMm());
                        break;
                    // 오전반반차2 인 경우
                    // 휴가시작시간: 기본근무시작시간 + 적용시간(분), 휴가종료시간: 휴가시작시간 + 적용시간(분)
                    case "HAM2":
                        vacationStart = baseWorkSdateTime.plusMinutes(gntDtl.getMm());
                        vacationEnd = vacationStart.plusMinutes(gntDtl.getMm());
                        break;
                }
            }


            if (vacationStart != null && vacationEnd != null) {
                // 실제 근무시간과 겹치는 시간 계산
                LocalDateTime calFrom = vacationStart.isBefore(workSdateTime) ? workSdateTime : vacationStart;
                if (!calFrom.isAfter(vacationEnd)) {
                    LocalDateTime calTo = vacationEnd.isAfter(workEdateTime) ? workEdateTime : vacationEnd;
                    totalDeductMinutes += Duration.between(calFrom, calTo).toMinutes();
                }
            }
        }
        return totalDeductMinutes;
    }


    /**
     * 시작일시와 종료일시 사이의 심야 시간 게산
     * @param start 시작일시
     * @param end   종료일시
     * @return 심야시간
     */
    public int calcNightMm(LocalDateTime start, LocalDateTime end) {
        int nightMm = 0;
        LocalDateTime current = start;

        while (current.isBefore(end)) {
            // 오늘 날짜의 야간 시작/종료 시간 설정
            LocalDateTime nightStart = current.withHour(22).withMinute(0);
            LocalDateTime nightEnd = current.plusDays(1).withHour(6).withMinute(0);

            // 이전 날의 야간 종료시간도 체크
            LocalDateTime prevNightEnd = current.withHour(6).withMinute(0);

            // 현재 시간이 이전 날의 야간시간에 포함되는지 체크 (00:00-06:00)
            if (current.isBefore(prevNightEnd)) {
                LocalDateTime segmentEnd = end.isBefore(prevNightEnd) ? end : prevNightEnd;
                nightMm += (int) Duration.between(current, segmentEnd).toMinutes();
                current = segmentEnd;
                continue;
            }

            // 오늘 날짜의 야간시간에 포함되는지 체크 (22:00-24:00)
            if (!current.isBefore(nightStart)) {
                LocalDateTime segmentEnd = end.isBefore(nightEnd) ? end : nightEnd;
                nightMm += (int) Duration.between(current, segmentEnd).toMinutes();
                current = segmentEnd;
                continue;
            }

            current = nightStart;
        }

        return nightMm;
    }

    /**
     * HHMM 포맷인 두 시각 사이의 시간 계산 함수
     * @param timeF 시작시간
     * @param timeT 종료시간
     * @return 시간차(분단위)
     */
    public int calcMinutes(int timeF, int timeT) {
        int workMinutes = 0;

        // HHMM 포맷에서 시간과 분을 분리
        int startHour = timeF / 100;
        int startMin = timeF % 100;
        int endHour = timeT / 100;
        int endMin = timeT % 100;

        // 분 단위로 변환
        int startMinutes = (startHour * 60) + startMin;
        int endMinutes = (endHour * 60) + endMin;

        // 근무시간 계산 (분 단위)
        if(startMinutes > endMinutes) {
            // 시작시간이 종료시간보다 큰 경우 (다음날까지)
            workMinutes = (24 * 60) - startMinutes + endMinutes;
        } else {
            workMinutes = endMinutes - startMinutes;
        }

        return workMinutes;
    }

    public DayOfWeek convertToDayOfWeek(String weekBeginDay) {
        switch (weekBeginDay.toUpperCase()) {
            case "MON": return DayOfWeek.MONDAY;
            case "TUE": return DayOfWeek.TUESDAY;
            case "WED": return DayOfWeek.WEDNESDAY;
            case "THU": return DayOfWeek.THURSDAY;
            case "FRI": return DayOfWeek.FRIDAY;
            case "SAT": return DayOfWeek.SATURDAY;
            case "SUN": return DayOfWeek.SUNDAY;
            default:
                throw new IllegalArgumentException("Invalid day format: " + weekBeginDay);
        }
    }

    public String convertToDayOfWeekStr(DayOfWeek day) {
        switch (day) {
            case MONDAY:    return "MON";
            case TUESDAY:   return "TUE";
            case WEDNESDAY: return "WED";
            case THURSDAY:  return "THU";
            case FRIDAY:    return "FRI";
            case SATURDAY:  return "SAT";
            case SUNDAY:    return "SUN";
            default:        return "";
        }
    }

    public DayOfWeek getWeekEndDay(String weekBeginDay) {
        DayOfWeek beginDay = convertToDayOfWeek(weekBeginDay);
        return beginDay.minus(1);
    }

    /**
     * 모든 값이 null로 초기화된 WtmDailyCountDTO를 생성하는 메소드
     */
    private WtmDailyCountDTO createEmptyDailyCountDTO(String entercd, String sabun, String ymd, String workClassCd) {
        WtmDailyCountDTO dto = new WtmDailyCountDTO();
        dto.setEnterCd(entercd);
        dto.setSabun(sabun);
        dto.setYmd(ymd);
        dto.setWorkClassCd(workClassCd);
        return dto;
    }
}
