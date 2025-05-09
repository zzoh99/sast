package com.hr.hri.applyApproval.approvalAfterJob;

import com.github.f4b6a3.tsid.TsidCreator;
import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.wtm.calc.key.WtmCalcGroupKey;
import com.hr.wtm.calc.workTime.WtmCalcWorkTimeService;
import com.hr.wtm.count.wtmDailyCount.WtmDailyCountService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service("ApprovalAfterJobService")
public class ApprovalAfterJobService {

    @Inject
    @Named("Dao")
    private Dao dao;

    @Autowired
    private WtmCalcWorkTimeService wtmCalcWorkTimeService;

    @Autowired
    private WtmDailyCountService wtmDailyCountService;

    // 결재후처리 작업
    public int approvalAfterJob(Map<String, Object> paramMap) throws Exception {
        int cnt = 0;
        try {
            String applSeq = (String) paramMap.get("searchApplSeq");
            String applCd = (String) paramMap.get("searchApplCd");
            Map<String, Object> applInfo = (Map<String, Object>)getApprovalMgrResultTHRI103(paramMap);
            String applStatusCd = (String) applInfo.get("applStatusCd");
    
            if(applCd.startsWith("wtm")) { // WTM 관련 신청서 처리
                wtmCalcWorkTimeService.setCode(paramMap.get("ssnEnterCd").toString(), false);
    
                // WTM 근무스케줄 신청인 경우
                Map workClassInfo = dao.getMap("getWtmWorkScheduleAppDetWorkClass", paramMap);
                if(applStatusCd.equals("99") && workClassInfo != null && !workClassInfo.isEmpty()) {
                    // WTM 근무스케줄 신청 완결 후 작업
                    // 1. 기존 근무 스케줄 삭제
                    List<Map<Object, Object>> bfWorkSchList = (List<Map<Object, Object>>) dao.getList("getWtmWorkCalendarBfWorkList", paramMap);
                    if(bfWorkSchList != null && !bfWorkSchList.isEmpty()) {
                        Map deleteParam = new HashMap();
                        deleteParam.put("enterCd", paramMap.get("ssnEnterCd"));
                        deleteParam.put("deleteList", bfWorkSchList);
                        dao.delete("deleteBeforeWorkSch", deleteParam);
                    }
    
                    // 2. 근무 스케줄 입력
                    dao.create("saveWorkDetail", paramMap);
    
                    // 3. 근무 시간 한도 체크
                    // 신청서 마스터 정보 조회
                    paramMap.put("table", "TWTM201");
                    Map<?, ?> applMaster = (Map<?, ?>) getApplDetailData(paramMap).get(0);
    
                    // 신청서 디테일 정보 조회
                    paramMap.put("table", "TWTM202");
                    List<Map<String, Object>> applDetail = (List<Map<String, Object>>) getApplDetailData(paramMap);
    
                    // WtmCalcGroupKey로 그룹화
                    Map<WtmCalcGroupKey, List<Map<String, Object>>> groupedApplDetail = applDetail.stream()
                            .collect(Collectors.groupingBy(item ->
                                    new WtmCalcGroupKey(
                                            (String) item.get("enterCd"),
                                            (String) item.get("sabun")
                                    )
                            ));
    
                    // 근무한도체크를 위한 파라미터 설정
                    List<Map<String, Object>> paramList = new ArrayList<>();
                    groupedApplDetail.forEach((key, items) -> {
                        Map<String, Object> checkLimitParam = new HashMap<>();
                        checkLimitParam.put("enterCd", key.getEnterCd());
                        checkLimitParam.put("sabun", key.getSabun());
                        checkLimitParam.put("sdate", applMaster.get("sdate"));
                        checkLimitParam.put("edate", applMaster.get("edate"));
                        checkLimitParam.put("addWrkList", null);
                        checkLimitParam.put("excWrkList", null);
                        checkLimitParam.put("addGntList", null);
                        checkLimitParam.put("excGntList", null);
    
                        paramList.add(checkLimitParam);
    
                    });
    
                    boolean hoursLimitYn = false;
                    hoursLimitYn = wtmCalcWorkTimeService.checkWorkTimeLimit(paramList, false);
                    if(!hoursLimitYn) {
                        throw new HrException("근무시간 한도 체크에 실패했습니다.");
                    }
                } else if(applCd.equals("wtm201")) { // 휴가신청
                    // WTM 휴가신청 완결 후 작업
                    if(applStatusCd.equals("99")) {
    
                        // 신청서 상세 정보 조회
                        paramMap.put("table", "TWTM301");
                        Map<?, ?> applMaster = (Map<?, ?>) getApplDetailData(paramMap).get(0);
    
                        paramMap.put("table", "TWTM302");
                        List<?> applDetail = getApplDetailData(paramMap);
    
                        /* 신청서 유효여부 값 변경(TWTM302) 작업 START */
                        paramMap.put("enableYn", "Y");
                        dao.update("updateAttendApplEnableYn", paramMap);
                        /* 신청서 유효여부 값 변경(TWTM302) 작업 END */
    
                        for(Object o : applDetail) {
                            Map<String, Object> applDetailMap = (Map<String, Object>) o;
    
                            double totAppDay = 0; // 총적용일수
    
                            // 근태코드 정보 조회
                            Map<String, Object> searchParam = new HashMap<String, Object>();
                            searchParam.put("ssnEnterCd", applMaster.get("enterCd"));
                            searchParam.put("searchGntCd", applMaster.get("gntCd"));
                            Map<String, Object> gunCdInfoMap = (Map<String, Object>) dao.getMap("getGunCdInfoMap", searchParam);
    
                            /* 개인별근태스케쥴(TWTM103) 연동 작업 START */
                            // 취소 신청인 경우 기존 데이터 삭제
                            String reqType = StringUtils.defaultIfEmpty((String) applDetailMap.get("reqType"), "");
                            String gntDtlId = StringUtils.defaultIfEmpty((String) applDetailMap.get("gntDtlId"), "");
    
                            String bfApplSeq = "";
                            if(!applDetailMap.get("bfApplSeq").equals(bfApplSeq) ) {
                                BigDecimal bfApplSeqValue = (BigDecimal) applDetailMap.get("bfApplSeq");
                                bfApplSeq = bfApplSeqValue != null ? bfApplSeqValue.toString() : "";
                            }
    
                            if((!gntDtlId.isEmpty() || !bfApplSeq.isEmpty()) && reqType.equals("D")) {
                                // 개인별근태스케쥴 삭제
                                dao.delete("deleteAttendPlan", applDetailMap);
    
                                // 이전 신청서 유효여부 값 'N' 으로 설정(TWTM301)
                                if(!bfApplSeq.isEmpty()) {
                                    Map<String, Object> updateParam = new HashMap<String, Object>();
                                    updateParam.put("ssnEnterCd", applDetailMap.get("enterCd"));
                                    updateParam.put("enableYn", "N");
                                    updateParam.put("searchApplSeq", bfApplSeq);
                                    updateParam.put("bfSeq", applDetailMap.get("bfSeq"));
                                    dao.update("updateAttendApplEnableYn", updateParam);
                                }
                            }
    
                            // 적용일수, 적용시간 재계산
                            String from = applDetailMap.get("sYmd").toString();
                            String to = applDetailMap.get("eYmd").toString();
    
                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
                            LocalDate sYmd = LocalDate.parse(from, formatter);
                            LocalDate eYmd = LocalDate.parse(to, formatter);
    
                            // from 과 to 사이의 모든 날짜 구하기
                            List<LocalDate> dates = new ArrayList<>();
                            LocalDate currentDate = sYmd;
    
                            while (!currentDate.isAfter(eYmd)) {
                                dates.add(currentDate);
                                currentDate = currentDate.plusDays(1);
                            }
    
                            // TWTM103 테이블에 일자별 근태 내역 INSERT
                            for (LocalDate date : dates) {
                                String newGntDtlId = gntDtlId.isEmpty() ? TsidCreator.getTsid().toString() : gntDtlId;
                                applDetailMap.put("gntDtlId", newGntDtlId);
                                applDetailMap.put("ymd", date.format(formatter));
                                applDetailMap.put("sabun", applMaster.get("sabun"));
                                applDetailMap.put("gntCd", applMaster.get("gntCd"));
    
                                /*
                                    시간차 신청이 아닌경우에만 적용일수, 적용시간 재계산. -> 단축근무자 케이스를 고려하기 위함.
                                    1. 적용일수 계산식 : (일 근무시간 * BASE_CNT / 휴무적용시간) * BASE_CNT
                                    2. 적용시간(분) 계산식 : Min( (일 근무시간 * BASE_CNT), 휴무적용시간) * 60
                                    단, 일 근무시간이 아직 산정되지 않은 경우, 근태코드 관리의 적용일수, 적용시간 값을 사용한다.
    
                                 */
                                String reqUseType = StringUtils.defaultIfEmpty((String) gunCdInfoMap.get("requestUseType"), "");
                                double baseCnt = ((BigDecimal) gunCdInfoMap.getOrDefault("baseCnt", BigDecimal.ZERO)).doubleValue();
                                double stdApplyHour = ((BigDecimal) gunCdInfoMap.getOrDefault("stdApplyHour", BigDecimal.ZERO)).doubleValue();
                                double appDay = 0;
                                double appMm = 0;
    
                                Map<String, Object> workHourMap = (Map<String, Object>) dao.getMap("getWorkHourMap", applDetailMap);
                                double workHour = ((BigDecimal) workHourMap.getOrDefault("workHour", BigDecimal.ZERO)).doubleValue();
                                int holidayCnt = ((BigDecimal) workHourMap.getOrDefault("holidayCnt", BigDecimal.ZERO)).intValue();
                                // 휴무일이 아닐때
                                if(holidayCnt == 0) {
                                    // 시간차 신청이 아닌경우 계산식 적용
                                    if(!reqUseType.equals("H") && !reqUseType.isEmpty()) {
                                        if(workHour > 0) {
                                            // 일근무시간이 있는 경우, 계산식 적용
                                            appDay = (workHour * baseCnt / stdApplyHour) * baseCnt;
                                            appMm = Math.min((workHour * baseCnt), stdApplyHour) * 60;
                                        } else {
                                            // 일 근무시간이 없는 경우, 근태코드 기본 적용일수 사용.
                                            appDay = baseCnt;
                                            appMm = stdApplyHour * 60;
                                        }
                                    } else {
                                        // 시간차의 경우, 신청서상의 적용일수 그대로 가져옴
                                        appDay = ((BigDecimal) applDetailMap.getOrDefault("appDay", BigDecimal.ZERO)).doubleValue();
                                        appMm = stdApplyHour * 60;
                                    }
                                    totAppDay += appDay;
                                    applDetailMap.put("appDay", appDay);
                                    applDetailMap.put("appMm", appMm);
                                    // 신청내용 TWTM103에 저장(삭제신청인 경우 제외)
                                    if(!reqType.equals("D")) {
                                        // 개인별근태스케쥴 저장
                                        cnt += dao.create("saveAttendPlan", applDetailMap);
                                    }
                                }
                            }
                            /* 개인별근태스케쥴(TWTM103) 연동 작업 END */
    
                            /* 발생근태(TWTM511) 연동 작업 START */
                            String vacationYn = StringUtils.defaultIfEmpty((String) gunCdInfoMap.get("vacationYn"), "N"); // 발생근태 차감여부
    
                            // 발생근태 차감여부가 Y인 경우에만 발생근태 연동 작업 수행
                            if(vacationYn.equals("Y")) {
                                String sabun = StringUtils.defaultIfEmpty((String) applDetailMap.get("sabun"), "");
    
                                // 근태 신규 신청인 경우
                                if(reqType.equals("I")) {
                                    // 1. 발생근태에 적용일수 차감 처리
                                    String searchLeaveId = StringUtils.defaultIfEmpty((String) applDetailMap.get("leaveId"), "");
    
                                    // 발생근태(TWTM511) 정보 조회
                                    searchParam.put("searchLeaveId", searchLeaveId);
                                    searchParam.put("searchSabun", sabun);
                                    Map<String, Object> vacationMap = (Map<String, Object>) dao.getMap("getVacationMap", searchParam);
    
                                    // 잔여일수에 적용일수 차감
                                    double restCnt = ((BigDecimal) vacationMap.getOrDefault("restCnt", BigDecimal.ZERO)).doubleValue();
                                    double nextRestCnt = restCnt - totAppDay;
    
                                    String minusAllowYn = StringUtils.defaultIfEmpty((String) gunCdInfoMap.get("minusAllowYn"), "N");
    
                                    // 차감일수가 >= 0 이거나, 마이너스허용여부가 Y인 경우 잔여 근태 일수 차감 작업 수행
                                    if(nextRestCnt >= 0 || minusAllowYn.equals("Y")) {
                                        Map<String, Object> saveParam = new HashMap<String, Object>();
                                        saveParam.put("ssnEnterCd", applDetailMap.get("enterCd"));
                                        saveParam.put("searchSabun", sabun);
                                        saveParam.put("searchLeaveId", searchLeaveId);
                                        saveParam.put("appCnt", -totAppDay);
                                        dao.update("updateVacationCnt", saveParam);
                                    } else {
                                        Log.Debug("[WTM 근태신청]발생 근태 잔여일수가 부족합니다.");
                                        throw new Exception("발생 근태 잔여일수가 부족합니다.");
                                    }
                                } else if (reqType.equals("D")) {
                                    // 삭제 신청인 경우 작업 수행
                                    String searchLeaveId = StringUtils.defaultIfEmpty((String) applDetailMap.get("leaveId"), "");
    
                                    // 차감했던 적용일수 다시 더하기.
                                    Map<String, Object> saveParam = new HashMap<String, Object>();
                                    saveParam.put("ssnEnterCd", applDetailMap.get("enterCd"));
                                    saveParam.put("searchSabun", sabun);
                                    saveParam.put("searchLeaveId", applDetailMap.get("leaveId"));
                                    saveParam.put("appCnt", totAppDay);
                                    dao.update("updateVacationCnt", saveParam);
                                }
                            }
                            /* 발생근태(TWTM511) 연동 작업 END */
                        }
                    }
                } else if (applCd.equals("wtm301")) { // 근무신청
                    // WTM 근무신청 완결 후 작업
                    if(applStatusCd.equals("99")) {
                        String maxSymd = null;
                        String minEymd = null;
    
                        // 신청서 상세 정보 조회
                        paramMap.put("table", "TWTM311");
                        Map<?, ?> applMaster = (Map<?, ?>) getApplDetailData(paramMap).get(0);
    
                        paramMap.put("table", "TWTM312");
                        List<Map<String, Object>> applDetailList = (List<Map<String, Object>>) getApplDetailData(paramMap);
    
                        /* 신청서 유효여부 값 변경(TWTM312) 작업 START */
                        paramMap.put("enableYn", "Y");
                        dao.update("updateWorkApplEnableYn", paramMap);
                        /* 신청서 유효여부 값 변경(TWTM312) 작업 END */
    
                        for(Map<String, Object> applDetailMap : applDetailList) {
                            /* 개인별근무스케쥴(TWTM102) 연동 작업 START */
                            // 취소 신청인 경우 기존 데이터 삭제
                            String reqType = StringUtils.defaultIfEmpty((String) applDetailMap.get("reqType"), "");
                            String wrkDtlId = StringUtils.defaultIfEmpty((String) applDetailMap.get("wrkDtlId"), "");
    
                            String bfApplSeq = "";
                            if(!applDetailMap.get("bfApplSeq").equals(bfApplSeq) ) {
                                BigDecimal bfApplSeqValue = (BigDecimal) applDetailMap.get("bfApplSeq");
                                bfApplSeq = bfApplSeqValue != null ? bfApplSeqValue.toString() : "";
                            }
    
                            String from = applDetailMap.get("sYmd").toString(); // 근무 시작일
                            String to = applDetailMap.get("eYmd").toString(); // 근무 종료일
                            
                            if((!wrkDtlId.isEmpty() || !bfApplSeq.isEmpty()) && reqType.equals("D")) {
                                // 개인별근무스케쥴 삭제
                                dao.delete("deleteWorkPlan", applDetailMap);
    
                                // 이전 신청서 유효여부 값 'N' 으로 설정(TWTM301)
                                if(!bfApplSeq.isEmpty()) {
                                    Map<String, Object> updateParam = new HashMap<String, Object>();
                                    updateParam.put("ssnEnterCd", applDetailMap.get("enterCd"));
                                    updateParam.put("enableYn", "N");
                                    updateParam.put("searchApplSeq", bfApplSeq);
                                    updateParam.put("bfSeq", applDetailMap.get("bfSeq"));
                                    dao.update("updateWorkApplEnableYn", updateParam);
                                }
                            } else {
                                // 적용일수, 적용시간 재계산
                                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
                                LocalDate sYmd = LocalDate.parse(from, formatter);
                                LocalDate eYmd = LocalDate.parse(to, formatter);
    
                                // from 과 to 사이의 모든 날짜 구하기
                                List<LocalDate> dates = new ArrayList<>();
                                LocalDate currentDate = sYmd;
    
                                while (!currentDate.isAfter(eYmd)) {
                                    dates.add(currentDate);
                                    currentDate = currentDate.plusDays(1);
                                }
    
                                // TWTM102 테이블에 일자별 근무 내역 INSERT
                                List<Map<String, Object>> insertList = new ArrayList<>();
                                List<Map<String, Object>> otBreakList = new ArrayList<>();
                                for (LocalDate date : dates) {
                                    Map<String, Object> insertData = new HashMap<>(applDetailMap);
                                    String newWrkDtlId = wrkDtlId.isEmpty() ? TsidCreator.getTsid().toString() : wrkDtlId;
    
                                    insertData.put("wrkDtlId", newWrkDtlId);
                                    insertData.put("ymd", date.format(formatter));
                                    insertData.put("sabun", applMaster.get("sabun"));
                                    insertData.put("workCd", applMaster.get("workCd"));
    
                                    // 시간차 신청인 경우, 시작/종료일자 재계산
                                    if(insertData.containsKey("reqSHm") && insertData.containsKey("reqEHm")) {
                                        // 시작시간이 종료시간보다 더 늦은경우
                                        if(insertData.get("reqSHm").toString().compareTo(insertData.get("reqEHm").toString()) > 0) {
                                            insertData.put("symd", date.format(formatter));
                                            insertData.put("eymd", date.plusDays(1).format(formatter));
                                        } else {
                                            insertData.put("symd", date.format(formatter));
                                            insertData.put("eymd", date.format(formatter));
                                        }
    
                                        // 연장근무 신청인 경우
                                        if(insertData.get("workCd").equals(wtmCalcWorkTimeService.getOtWorkCd())) {
                                            // 연장근무 휴게시간 기준 조회
                                            Map<String, Object> searchParam = new HashMap<>();
                                            searchParam.put("ssnEnterCd", insertData.get("enterCd"));
                                            searchParam.put("date", insertData.get("ymd"));
                                            searchParam.put("sabun", insertData.get("sabun"));
                                            Map<String, Object> otBreakInfo = (Map<String, Object>) dao.getMap("getWtmWorkAppDetOtBreakInfo", searchParam);
                                            int otBreakTimeT = 60 * Integer.parseInt(otBreakInfo.getOrDefault("otBreakTimeT", "0").toString());
                                            int otBreakTimeR = Integer.parseInt(otBreakInfo.getOrDefault("otBreakTimeR", "0").toString());
                                            int requestMm = Integer.parseInt(insertData.getOrDefault("requestMm", "0").toString());
    
                                            // 연장근무 휴게시간 삽입
                                            if (otBreakTimeT > 0 && otBreakTimeR > 0 && requestMm >= otBreakTimeT) {
                                                // 시작 시간
                                                LocalDateTime currentTime = LocalDateTime.parse(insertData.get("symd").toString() + insertData.get("reqSHm").toString(), DateTimeFormatter.ofPattern("yyyyMMddHHmm"));
                                                int remainingMinutes = requestMm;
    
                                                while (remainingMinutes >= otBreakTimeT) {
                                                    // 연장근무 휴게시간 기준 이후 시점 계산
                                                    LocalDateTime breakStartTime = currentTime.plusMinutes(otBreakTimeT);
                                                    // 연장근무 휴게시간 후의 시점 계산
                                                    LocalDateTime breakEndTime = breakStartTime.plusMinutes(otBreakTimeR);
    
                                                    Map<String, Object> breakInfo = new HashMap<>(insertData);
                                                    breakInfo.put("symd", breakStartTime.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
                                                    breakInfo.put("reqSHm", breakStartTime.format(DateTimeFormatter.ofPattern("HHmm")));
                                                    breakInfo.put("eymd", breakEndTime.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
                                                    breakInfo.put("reqEHm", breakEndTime.format(DateTimeFormatter.ofPattern("HHmm")));
                                                    breakInfo.put("requestMm", otBreakTimeR);
                                                    breakInfo.put("workCd", wtmCalcWorkTimeService.getBreakWorkCd()); // 휴게시간
                                                    otBreakList.add(breakInfo);
    
                                                    // 다음 계산을 위해 현재 시간과 남은 시간 업데이트
                                                    currentTime = breakEndTime;
                                                    remainingMinutes -= (otBreakTimeT + otBreakTimeR);
                                                }
                                            }
                                        }
                                    }
                                    insertList.add(insertData);
                                }
    
                                // 연장근무 휴게시간이 있는 경우, insertList에 추가
                                if(!otBreakList.isEmpty()) {
                                    insertList.addAll(otBreakList);
                                }
    
                                if(!insertList.isEmpty()) {
                                    // 개인별근무스케쥴 저장
                                    cnt += dao.create("saveWorkPlan", insertList);
                                }
                            }
    
                            /* 개인별근무스케쥴(TWTM102) 연동 작업 END */
    
                            // 신청서 상세에서 symd와 eymd의 최대, 최소값 구하기.
                            if (maxSymd == null || from.compareTo(maxSymd) > 0) {
                                maxSymd = from;
                            }
                            if (minEymd == null || to.compareTo(minEymd) < 0) {
                                minEymd = to;
                            }
                        }
    
                        /* 근무시간 한도 체크 */
                        // 근무한도체크를 위한 파라미터 설정
                        Map<String, Object> checkLimitParam = new HashMap<>();
                        checkLimitParam.put("enterCd", applMaster.get("enterCd"));
                        checkLimitParam.put("sabun", applMaster.get("sabun"));
                        checkLimitParam.put("sdate", maxSymd);
                        checkLimitParam.put("edate", minEymd);
                        checkLimitParam.put("addWrkList", null);
                        checkLimitParam.put("excWrkList", null);
                        checkLimitParam.put("addGntList", null);
                        checkLimitParam.put("excGntList", null);
    
                        List<Map<String, Object>> paramList = new ArrayList<>();
                        paramList.add(checkLimitParam);
    
                        boolean hoursLimitYn = false;
                        hoursLimitYn = wtmCalcWorkTimeService.checkWorkTimeLimit(paramList, false);
                        if(!hoursLimitYn) {
                            throw new HrException("근무시간 한도 체크에 실패했습니다.");
                        }
                    }
                } else if (applCd.equals("wtm401")) { // 출퇴근변경신청
                    // WTM 출퇴근변경신청 완결 후 작업
                    if(applStatusCd.equals("99")) {
                        // 신청서 상세 정보 조회
                        paramMap.put("table", "TWTM321");
                        Map<?, ?> applMaster = (Map<?, ?>) getApplDetailData(paramMap).get(0);
    
                        paramMap.put("table", "TWTM322");
                        List<Map<String, Object>> applDetailList = (List<Map<String, Object>>) getApplDetailData(paramMap);
    
                        /* 출퇴근타각정보(TWTM110) 연동 작업 START */
    
                        // 신청일자의 출퇴근 타각 정보 모두 삭제
                        Map<String, Object> deleteParam = new HashMap<>();
                        deleteParam.put("enterCd", applMaster.get("enterCd"));
                        deleteParam.put("sabun", applMaster.get("sabun"));
                        deleteParam.put("ymd", applMaster.get("ymd"));
                        dao.delete("deleteInoutTime", deleteParam);
    
                        // 변경 신청한 출퇴근타각정보 입력
                        List<Map<String, Object>> insertList = new ArrayList<>();
                        for(Map<String, Object> applDetailMap : applDetailList) {
                            Map<String, Object> insertData = new HashMap<>();
                            // 삭제한 출퇴근 타각 외에 전부 입력
                            if(!"D".equals(applDetailMap.get("chgType"))) {
                                insertData.put("enterCd", applMaster.get("enterCd"));
                                insertData.put("sabun", applMaster.get("sabun"));
                                insertData.put("ymd", applMaster.get("ymd"));
                                insertData.put("inYmd", applDetailMap.get("afInYmd"));
                                insertData.put("inHm", applDetailMap.get("afInHm"));
                                insertData.put("outYmd", applDetailMap.get("afOutYmd"));
                                insertData.put("outHm", applDetailMap.get("afOutHm"));
                                insertData.put("awayYn", applDetailMap.get("afAwayYn"));
                                insertList.add(insertData);
                            }
                        }
                        if(!insertList.isEmpty()) {
                            cnt += dao.create("saveInoutTime", insertList);
                        }
                        /* 출퇴근타각정보(TWTM110) 연동 작업 END */
    
                        /* 근무시간 한도 체크 */
                        // 근무한도체크를 위한 파라미터 설정
                        Map<String, Object> checkLimitParam = new HashMap<>();
                        checkLimitParam.put("enterCd", applMaster.get("enterCd"));
                        checkLimitParam.put("sabun", applMaster.get("sabun"));
                        checkLimitParam.put("sdate", applMaster.get("ymd"));
                        checkLimitParam.put("edate", applMaster.get("ymd"));
                        checkLimitParam.put("addWrkList", null);
                        checkLimitParam.put("excWrkList", null);
                        checkLimitParam.put("addGntList", null);
                        checkLimitParam.put("excGntList", null);
    
                        List<Map<String, Object>> paramList = new ArrayList<>();
                        paramList.add(checkLimitParam);
    
                        boolean hoursLimitYn = false;
                        hoursLimitYn = wtmCalcWorkTimeService.checkWorkTimeLimit(paramList, false);
                        if(!hoursLimitYn) {
                            throw new HrException("근무시간 한도 체크에 실패했습니다.");
                        }
    
                        /* 일마감 처리 */
                        Map<String, Object> countParam = new HashMap<>();
                        countParam.put("ssnEnterCd", applMaster.get("enterCd"));
                        countParam.put("enterCd", applMaster.get("enterCd"));
                        countParam.put("sabun", applMaster.get("sabun"));
                        countParam.put("sdate", applMaster.get("ymd"));
                        countParam.put("edate", applMaster.get("ymd"));
                        countParam.put("useBatchMode", "N");
                        int countCnt = wtmDailyCountService.prcWtmDailyCount(countParam);
                        if(countCnt == 0) {
                            throw new HrException("저장된 일근무 마감 내역이 없습니다.");
                        } else if (countCnt < 0) {
                            throw new HrException("일근무 마감 작업에 실패했습니다.");
                        }
                    }
                }
            }
        } catch (Exception e) {
            Log.Error(e.toString());
        }
        return cnt;
    }

    /**
     * [공통] 신성서 마스터 조회
     */
    public Map<?, ?> getApprovalMgrResultTHRI103(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return dao.getMap("getApprovalMgrResultTHRI103", paramMap);
    }

    /**
     * [공통] 신청서 상세 정보 조회
     */
    public List<?> getApplDetailData(Map<?,?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>)dao.getList("getApplDetailData", paramMap);
    }


}
