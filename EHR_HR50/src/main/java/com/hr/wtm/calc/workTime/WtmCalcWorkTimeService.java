package com.hr.wtm.calc.workTime;

import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.wtm.calc.dto.*;
import com.hr.wtm.calc.key.WtmCalcGroupKey;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service("WtmCalcWorkTimeService")
public class WtmCalcWorkTimeService {

    @Inject
    @Named("Dao")
    private Dao dao;

    @Autowired
    private WtmCalcWorkTime wtmCalcWorkTime;

    public void setCode(String ssnEnterCd, boolean isBatch) throws Exception {

        if(getBaseWorkCd() == null || getBaseWorkCd().equals("")
            || getOtWorkCd() == null || getOtWorkCd().equals("")
            || getBreakWorkCd() == null || getBreakWorkCd().equals("")) {
            // 기본근무 코드와 휴게시간 코드정보 세팅
            Map paramMap = new HashMap<>();
            paramMap.put("ssnEnterCd", ssnEnterCd);

            Map baseCodeInfo = null;
            if(isBatch) {
                baseCodeInfo = dao.getMapBatchMode("getWtmWorkCalendarBaseCd", paramMap);
            } else {
                baseCodeInfo = dao.getMap("getWtmWorkCalendarBaseCd", paramMap);
            }

            wtmCalcWorkTime.setBaseWorkCd(baseCodeInfo.get("stdWorkCd").toString());
            wtmCalcWorkTime.setOtWorkCd(baseCodeInfo.get("stdOtCd").toString());
            wtmCalcWorkTime.setBreakWorkCd(baseCodeInfo.get("stdBreakCd").toString());
        }
    }

    /**
     * 사원별 근무한도 체크 로직 수행
     * @param paramList 근무한도체크를 위한 파라미터
     *                  * key                               * value
     *                  enterCd                             회사코드
     *                  sabun                               사번
     *                  sdate                               근무한도체크 시작일
     *                  edate                               근무한도체크 종료일
     *                  List<WtmWrkDtlDTO> addWrkList       근무상세(TWTM102) 데이터 외에 추가할 근무 리스트
     *                  List<WtmWrkDtlDTO> excWrkList       근무상세(TWTM102) 데이터에서 제외할 근무 리스트
     *                  List<WtmGntDtlDTO> addGntList       근태상세(TWTM103) 데이터에서 추가할 근태 리스트
     *                  List<WtmGntDtlDTO> excGntList       근태상세(TWTM103) 데이터에서 제외할 근태 리스트
     * @param isBatch 배치모드 사용 여부
     * @return 근무한도 충족 여부
     */
    public boolean checkWorkTimeLimit(List<Map<String, Object>> paramList, boolean isBatch) throws Exception {
        boolean result = true;

        try {
            if(paramList.isEmpty()) return true;

            // 사원별로 근무한도 체크 한다.
            for (Map<String, Object> param : paramList) {
                /* 1. 근무한도 체크 시작, 종료 기간에 속하는 근무유형 코드를 조회한다. */
                List<Map<String, Object>> workClassInfoList = null;
                if(isBatch) {
                    workClassInfoList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmCalcWorkTimeWorkClassList", param);
                } else {
                    workClassInfoList = (List<Map<String, Object>>) dao.getList("getWtmCalcWorkTimeWorkClassList", param);
                }

                if(workClassInfoList != null && !workClassInfoList.isEmpty()) {
                    String sdate = param.get("sdate").toString(); // 근무한도체크 시작일
                    String edate = param.get("edate").toString(); // 근무한도체크 종료일

                    // 근무 한도 체크 기간 범위 내에서 근무유형이 쪼개지는 경우, 근무유형에 맞춰서 근무한도 체크
                    for(Map<String, Object> workClassInfoMap : workClassInfoList) {
                        String workClassSdate = workClassInfoMap.get("sdate").toString(); // 근무유형 시작일자
                        String psnlEdate = workClassInfoMap.get("psnlEdate").toString(); // 근무유형 종료일자
                        String psnlSdate = workClassInfoMap.get("psnlSdate").toString(); // 개인별 근무유형 시작일자
                        String workClassEdate = workClassInfoMap.get("edate").toString(); // 개인별 근무유형 종료일자

                        /* 2. 근무시간 한도 체크 할 단위 기간 재설정 */
                        // 신청시작일, 근무유형시작일, 개인별근무유형시작일 중 가장 큰 값을 sdate로 설정
                        List<String> sdates = Arrays.asList(sdate, workClassSdate, psnlSdate);
                        String chkSdate = Collections.max(sdates);

                        // 신청종료일, 근무유형종료일, 개인별근무유형종료일 중 가장 작은 값을 edate로 설정
                        List<String> edates = Arrays.asList(edate, workClassEdate, psnlEdate);
                        String chkEdate = Collections.min(edates);

                        /* 3.근무시간 한도 체크 할 단위 기간 조회 */
                        Map<String, Object> unitRangeParamMap = new HashMap<>();
                        unitRangeParamMap.put("enterCd", param.get("enterCd"));
                        unitRangeParamMap.put("chkSdate", chkSdate); // 체크 한도 시작일
                        unitRangeParamMap.put("chkEdate", chkEdate); // 체크 한도 종료일
                        unitRangeParamMap.put("workClassSdate", workClassSdate); // 근무유형 시작일
                        unitRangeParamMap.put("workClassEdate", workClassEdate); // 근무유형 종료일
                        unitRangeParamMap.put("psnlSdate", psnlSdate); // 개인근무유형 시작일
                        unitRangeParamMap.put("psnlEdate", psnlEdate); // 개인근무유형 종료일
                        unitRangeParamMap.put("workClassCd", workClassInfoMap.get("workClassCd"));
                        unitRangeParamMap.put("sabun", param.get("sabun"));
                        Map<Object, Object> unitMap = wtmCalcWorkTime.getWorkTimeUnitRange(unitRangeParamMap, workClassInfoMap);

                        /* 4. 단위기간내 근무내역 전체에 추가/제외할 근무내역을 적용. */
                        Map<String, Object> wrkDtlSearchMap = new HashMap<>();
                        wrkDtlSearchMap.put("enterCd", param.get("enterCd"));
                        wrkDtlSearchMap.put("sdate", unitMap.get("unitSdate"));
                        wrkDtlSearchMap.put("edate", unitMap.get("unitEdate"));
                        wrkDtlSearchMap.put("sabun", param.get("sabun"));

                        // 단위 기간 전체의 근무 상세 내역
                        List<Map<String, Object>> wrkDtlList = null;
                        if(isBatch) {
                            wrkDtlList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmCalcWorkTimeDailyCountWrkDtlList", wrkDtlSearchMap);
                        } else {
                            wrkDtlList = (List<Map<String, Object>>) dao.getList("getWtmCalcWorkTimeDailyCountWrkDtlList", wrkDtlSearchMap);
                        }

                        // workDetailList의 각 항목을 WtmWrkDtlDTO로 변환
                        List<WtmWrkDtlDTO> wtmWrkDtlDTOList = new ArrayList<WtmWrkDtlDTO>();
                        if(wrkDtlList != null && !wrkDtlList.isEmpty()) {
                            wtmWrkDtlDTOList = wrkDtlList.stream()
                                    .map(data -> {
                                        WtmWrkDtlDTO wtmWrkDtlDTO = new WtmWrkDtlDTO();
                                        wtmWrkDtlDTO.setEnterCd(data.get("enterCd").toString());
                                        wtmWrkDtlDTO.setWrkDtlId(data.get("wrkDtlId").toString());
                                        wtmWrkDtlDTO.setYmd(data.get("ymd").toString());
                                        wtmWrkDtlDTO.setSabun(data.get("sabun").toString());
                                        wtmWrkDtlDTO.setWorkCd(data.get("workCd").toString());
                                        wtmWrkDtlDTO.setPlanSymd(data.get("planSymd").toString());
                                        wtmWrkDtlDTO.setPlanShm(data.get("planShm").toString());
                                        wtmWrkDtlDTO.setPlanEymd(data.get("planEymd").toString());
                                        wtmWrkDtlDTO.setPlanEhm(data.get("planEhm").toString());
                                        wtmWrkDtlDTO.setPlanMm(Integer.parseInt(data.get("planMm").toString()));
                                        wtmWrkDtlDTO.setRealSymd(data.get("realSymd").toString());
                                        wtmWrkDtlDTO.setRealShm(data.get("realShm").toString());
                                        wtmWrkDtlDTO.setRealEymd(data.get("realEymd").toString());
                                        wtmWrkDtlDTO.setRealEhm(data.get("realEhm").toString());
                                        wtmWrkDtlDTO.setRealMm(Integer.parseInt(data.get("realMm").toString()));
                                        wtmWrkDtlDTO.setAutoCreYn(data.get("autoCreYn").toString());
                                        wtmWrkDtlDTO.setAddWorkTimeYn(data.get("addWorkTimeYn").toString());
                                        wtmWrkDtlDTO.setWorkTimeType(data.get("workTimeType").toString());
                                        wtmWrkDtlDTO.setDeemedYn(data.get("deemedYn").toString());
                                        return wtmWrkDtlDTO;
                                    })
                                    .collect(Collectors.toList());
                        }

                        // 전체 근무 상세내역에서 addWrkList 추가 (단, 단위 기간에 속하는 내용만 추가한다.)
                        List<WtmWrkDtlDTO> addWrkList = param.containsKey("addWrkList") ? (List<WtmWrkDtlDTO>) param.get("addWrkList") : null;
                        if(addWrkList != null && !addWrkList.isEmpty()) {
                            // 단위기간 조회
                            LocalDate unitStartdate =  LocalDate.parse(unitMap.get("unitSdate").toString(), DateTimeFormatter.ofPattern("yyyyMMdd"));
                            LocalDate unitEnddate =  LocalDate.parse(unitMap.get("unitEdate").toString(), DateTimeFormatter.ofPattern("yyyyMMdd"));

                            // 단위기간내의 데이터만 추출
                            List<WtmWrkDtlDTO> filteredAddWrkList = addWrkList.stream()
                                    .filter(dto -> {
                                        LocalDate wrkDate = LocalDate.parse(dto.getYmd(), DateTimeFormatter.ofPattern("yyyyMMdd"));
                                        return (wrkDate.isEqual(unitStartdate) || wrkDate.isAfter(unitStartdate)) && (wrkDate.isEqual(unitEnddate) || wrkDate.isBefore(unitEnddate));
                                    })
                                    .collect(Collectors.toList());

                            wtmWrkDtlDTOList.addAll(filteredAddWrkList);
                        }

                        // 전체 근무 상세내역에서 excWrkList 와 일치하는 근무 내역을 제외
                        List<WtmWrkDtlDTO> excWrkList = param.containsKey("excWrkList") ? (List<WtmWrkDtlDTO>) param.get("excWrkList") : null;
                        if(excWrkList != null && !excWrkList.isEmpty()) {
                            wtmWrkDtlDTOList = wtmWrkDtlDTOList.stream()
                                    .filter(dto -> excWrkList.stream()
                                            .noneMatch(excDto ->
                                                    excDto.getEnterCd().equals(dto.getEnterCd()) &&
                                                            excDto.getWrkDtlId().equals(dto.getWrkDtlId()) &&
                                                            excDto.getYmd().equals(dto.getYmd()) &&
                                                            excDto.getSabun().equals(dto.getSabun()) &&
                                                            excDto.getWorkCd().equals(dto.getWorkCd())
                                            ))
                                    .collect(Collectors.toList());
                        }

                        /* 5. 단위기간내 근태내역 전체에 추가/제외할 근태내역을 적용. */
                        // 단위 기간 전체의 근태 상세 내역
                        List<Map<String, Object>> gntDtlList = null;
                        if(isBatch) {
                            gntDtlList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmCalcWorkTimeDailyCountGntDtlList", wrkDtlSearchMap);
                        } else {
                            gntDtlList = (List<Map<String, Object>>) dao.getList("getWtmCalcWorkTimeDailyCountGntDtlList", wrkDtlSearchMap);
                        }

                        // 근태 상세 조회 결과를 WtmGntDtlDTO 으로 변환
                        List<WtmGntDtlDTO> wtmGntDtlDTOList = new ArrayList<>();
                        if(gntDtlList != null && !gntDtlList.isEmpty()) {
                            wtmGntDtlDTOList = gntDtlList.stream()
                                    .map(data -> {
                                        WtmGntDtlDTO wtmGntDtlDTO = new WtmGntDtlDTO();
                                        wtmGntDtlDTO.setEnterCd(data.get("enterCd").toString());
                                        wtmGntDtlDTO.setGntDtlId(data.get("gntDtlId").toString());
                                        wtmGntDtlDTO.setYmd(data.get("ymd").toString());
                                        wtmGntDtlDTO.setSabun(data.get("sabun").toString());
                                        wtmGntDtlDTO.setGntCd(data.get("gntCd").toString());
                                        wtmGntDtlDTO.setSymd(data.get("symd").toString());
                                        wtmGntDtlDTO.setShm(data.get("shm").toString());
                                        wtmGntDtlDTO.setEymd(data.get("eymd").toString());
                                        wtmGntDtlDTO.setEhm(data.get("ehm").toString());
                                        wtmGntDtlDTO.setMm(Integer.parseInt(data.get("mm").toString()));
                                        wtmGntDtlDTO.setRequestUseType(data.get("requestUseType").toString());
                                        return wtmGntDtlDTO;
                                    })
                                    .collect(Collectors.toList());
                        }

                        // 전체 근태 상세내역에서 addGntList 추가
                        List<WtmGntDtlDTO> addGntList = param.containsKey("addGntList") ? (List<WtmGntDtlDTO>) param.get("addGntList") : null;
                        if(addGntList != null && !addGntList.isEmpty()) {
                            wtmGntDtlDTOList.addAll(addGntList);
                        }

                        // 전체 근태 상세내역에서 excWrkList 와 일치하는 근무 내역을 제외
                        List<WtmGntDtlDTO> excGntList = param.containsKey("excGntList") ? (List<WtmGntDtlDTO>) param.get("excGntList") : null;
                        if(excGntList != null && !excGntList.isEmpty()) {
                            wtmGntDtlDTOList = wtmGntDtlDTOList.stream()
                                    .filter(dto -> excGntList.stream()
                                            .noneMatch(excDto ->
                                                    excDto.getEnterCd().equals(dto.getEnterCd()) &&
                                                            excDto.getGntDtlId().equals(dto.getGntDtlId()) &&
                                                            excDto.getYmd().equals(dto.getYmd()) &&
                                                            excDto.getSabun().equals(dto.getSabun()) &&
                                                            excDto.getGntCd().equals(dto.getGntCd())
                                            ))
                                    .collect(Collectors.toList());
                        }

                        /* 6. 단위기간내 근무 마스터를 조회. */
                        Map<String, Object> workMasterSearchMap = new HashMap<>();
                        workMasterSearchMap.put("enterCd", param.get("enterCd"));
                        workMasterSearchMap.put("sdate", unitMap.get("unitSdate"));
                        workMasterSearchMap.put("edate", unitMap.get("unitEdate"));
                        workMasterSearchMap.put("sabun", param.get("sabun"));
                        workMasterSearchMap.put("workClassCd", workClassInfoMap.get("workClassCd"));
                        List<Map<String, Object>> wtmWorkMaster = null;
                        if(isBatch) {
                            wtmWorkMaster = (List<Map<String, Object>>) dao.getListBatchMode("getWtmCalcWorkTimeDailyCountTargetList", workMasterSearchMap);
                        } else {
                            wtmWorkMaster = (List<Map<String, Object>>) dao.getList("getWtmCalcWorkTimeDailyCountTargetList", workMasterSearchMap);
                        }

                        /* 7. 대상자 출퇴근 타각 조회 */
                        List<Map<String, Object>> inOutList = null;
                        if(isBatch) {
                            inOutList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmCalcWorkTimeDailyCountInOutList", workMasterSearchMap);
                        } else {
                            inOutList = (List<Map<String, Object>>) dao.getList("getWtmCalcWorkTimeDailyCountInOutList", workMasterSearchMap);
                        }

                        // 출퇴근 타각 리스트에서 excInOutList 와 일치하는 근무 내역을 제외
                        List<Map<?,?>> excInOutList = param.containsKey("excInOutList") ? (List<Map<?,?>>) param.get("excInOutList") : null;
                        if(excInOutList != null && !excInOutList.isEmpty()) {
                            inOutList = inOutList.stream()
                                    .filter(map -> excInOutList.stream()
                                            .noneMatch(excMap ->
                                                    excMap.get("enterCd").equals(map.get("enterCd")) &&
                                                    excMap.get("sabun").equals(map.get("sabun")) &&
                                                    excMap.get("ymd").equals(map.get("ymd")) &&
                                                    excMap.get("inYmd").equals(map.get("inYmd")) &&
                                                    excMap.get("inHm").equals(map.get("inHm")) &&
                                                    excMap.get("outYmd").equals(map.get("outYmd")) &&
                                                    excMap.get("outHm").equals(map.get("outHm"))
                                            ))
                                    .collect(Collectors.toList());
                        }

                        // 출퇴근 타각 리스트에 addInOutList 추가
                        List<Map<String, Object>> addInOutList = param.containsKey("addInOutList") ? (List<Map<String, Object>>) param.get("addInOutList") : null;
                        if(addInOutList != null && !addInOutList.isEmpty()) {
                            inOutList.addAll(addInOutList);
                        }

                        /* 8. 공휴일 정보 조회 */
                        List<Map<String, Object>> holidayList = null;
                        if(isBatch) {
                            holidayList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmCalcWorkTimeDailyCountHolidayList", workMasterSearchMap);
                        } else {
                            holidayList = (List<Map<String, Object>>) dao.getList("getWtmCalcWorkTimeDailyCountHolidayList", workMasterSearchMap);
                        }

                        /* 9. 근무조 휴일,휴무일 정보 조회 */
                        List<Map<String, Object>> shiftHolidayList = null;
                        Map<WtmCalcGroupKey, String> shiftHoliday = new HashMap<>();
                        if(workClassInfoMap.get("workTypeCd").equals("D")) {
                            if (isBatch) {
                                shiftHolidayList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmCalcWorkTimeDailyCountShiftHolList", workMasterSearchMap);
                            } else {
                                shiftHolidayList = (List<Map<String, Object>>) dao.getList("getWtmCalcWorkTimeDailyCountShiftHolList", workMasterSearchMap);
                            }
                            // 근무조 정보를 회사코드, 사번, 일자별로 그룹핑
                            shiftHoliday = shiftHolidayList.stream()
                                    .collect(Collectors.toMap(
                                            map -> new WtmCalcGroupKey(
                                                    // 회사코드, 사번, 일자별로 그룹핑
                                                    map.get("enterCd").toString(),
                                                    map.get("sabun").toString(),
                                                    map.get("ymd").toString()
                                            ),
                                            map -> map.get("workDayType").toString()  // value로 workDayType 값 사용
                                    ));
                        }

                        // 근무유형 정보를 그룹핑 (key: 근무유형코드, value: 근무유형정보)
                        Map<String, Map<String, Object>> workClassInfo = new HashMap<>();
                        workClassInfo.put(workClassInfoMap.get("workClassCd").toString(), workClassInfoMap);

                        /* 10. 개인별 일별 총 근무시간을 계산. */
                        Map<String, Object> countMap = new HashMap<>();
                        countMap = wtmCalcWorkTime.countDailyWorkTime(wtmWorkMaster, inOutList, wtmWrkDtlDTOList, wtmGntDtlDTOList, holidayList, workClassInfo, shiftHoliday, false);
                        if(countMap != null && !countMap.isEmpty()) {

                            List<WtmDailyCountDTO> wtmDailyCountDTOList = (List<WtmDailyCountDTO>) countMap.get("workSummary");

                            // 휴일 포함 여부가 아닌경우, 기본근무일만 대상으로 한다.
                            if("N".equals(workClassInfoMap.get("holInclYn"))) {
                                wtmDailyCountDTOList = wtmDailyCountDTOList.stream().filter(dto -> "W".equals(dto.getDayType())).collect(Collectors.toList());
                            }

                            /* 11. 근무시간 한도 체크 */
                            result = wtmCalcWorkTime.checkDayLimit(wtmDailyCountDTOList, workClassInfoMap)        // 일 근무한도 체크
                                    && wtmCalcWorkTime.checkWeekLimit(wtmDailyCountDTOList, workClassInfoMap)     // 주 근무한도 체크
                                    && wtmCalcWorkTime.checkAvgWeekLimit(wtmDailyCountDTOList, workClassInfoMap); // 주 평균 근무한도 체크
                        }
                    }
                }
            }
        } catch (Exception e) {
            Log.Error(e.toString());
            throw new HrException("근무한도 체크 중 오류가 발생했습니다. 관리자에게 문의하세요.");
        }
        return result;
    }

    /**
     * 사원별 일근무집계
     * @param paramMap 근무집계를 위한 파라미터
     *                  * key                               * value
     *                  enterCd                             회사코드
     *                  bpCd                                사업장코드
     *                  sabun                               사번
     *                  sdate                               근무집계 시작일
     *                  edate                               근무집계 종료일
     * @param isBatch 배치모드 사용 여부
     * @return
     */
    public Map<String, Object> countDailyWorkTime(Map<String, Object> paramMap, boolean isBatch) throws Exception{

        int result = -1;

        /* 1. 일 마감 할 대상자 목록 조회 */
        List<Map<String, Object>> targetList = null;
        if(isBatch) {
            targetList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmCalcWorkTimeDailyCountTargetList", paramMap);
        } else {
            targetList = (List<Map<String, Object>>) dao.getList("getWtmCalcWorkTimeDailyCountTargetList", paramMap);
        }

        /* 2. 일 마감 할 대상자 출퇴근 타각 조회 */
        List<Map<String, Object>> inOutList = null;
        if(isBatch) {
            inOutList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmCalcWorkTimeDailyCountInOutList", paramMap);
        } else {
            inOutList = (List<Map<String, Object>>) dao.getList("getWtmCalcWorkTimeDailyCountInOutList", paramMap);
        }

        /* 3. 일 마감 대상 일자 전체 근무 상세 조회*/
        List<Map<String, Object>> wrkDtlList = null;
        if(isBatch) {
            wrkDtlList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmCalcWorkTimeDailyCountWrkDtlList", paramMap);
        } else {
            wrkDtlList = (List<Map<String, Object>>) dao.getList("getWtmCalcWorkTimeDailyCountWrkDtlList", paramMap);
        }

        /* 4. 일 마감 대상 일자 전체 근태 상세 조회*/
        List<Map<String, Object>> gntDtlList = null;
        if(isBatch) {
            gntDtlList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmCalcWorkTimeDailyCountGntDtlList", paramMap);
        } else {
            gntDtlList = (List<Map<String, Object>>) dao.getList("getWtmCalcWorkTimeDailyCountGntDtlList", paramMap);
        }

        /* 5. 공휴일 정보 조회 */
        List<Map<String, Object>> holidayList = null;
        if(isBatch) {
            holidayList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmCalcWorkTimeDailyCountHolidayList", paramMap);
        } else {
            holidayList = (List<Map<String, Object>>) dao.getList("getWtmCalcWorkTimeDailyCountHolidayList", paramMap);
        }

        /* 6. 근무유형 정보 조회 */
        List<Map<String, Object>> workClassInfoList = null;
        if(isBatch) {
            workClassInfoList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmCalcWorkTimeDailyCountWorkClassList", paramMap);
        } else {
            workClassInfoList = (List<Map<String, Object>>) dao.getList("getWtmCalcWorkTimeDailyCountWorkClassList", paramMap);
        }
        // 근무유형 정보를 그룹핑 (key: 근무유형코드, value: 근무유형정보)
        Map<String, Map<String, Object>> workClassInfo = new HashMap<>();
        for (Map<String, Object> data : workClassInfoList) {
            workClassInfo.put(data.get("workClassCd").toString(), data);
        }

        /* 7. 근무조 휴일,휴무일 정보 조회 */
        List<Map<String, Object>> shiftHolidayList = null;
        if(isBatch) {
            shiftHolidayList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmCalcWorkTimeDailyCountShiftHolList", paramMap);
        } else {
            shiftHolidayList = (List<Map<String, Object>>) dao.getList("getWtmCalcWorkTimeDailyCountShiftHolList", paramMap);
        }
        // 근무조 정보를 회사코드, 사번, 일자별로 그룹핑
        Map<WtmCalcGroupKey, String> shiftHoliday = shiftHolidayList.stream()
                .collect(Collectors.toMap(
                        map -> new WtmCalcGroupKey(
                                // 회사코드, 사번, 일자별로 그룹핑
                                map.get("enterCd").toString(),
                                map.get("sabun").toString(),
                                map.get("ymd").toString()
                        ),
                        map -> map.get("workDayType").toString()  // value로 workDayType 값 사용
                ));

        // wrkDtlList 를 wtmWrkDtlDTOList로 변환
        List<WtmWrkDtlDTO> wtmWrkDtlDTOList = new ArrayList<WtmWrkDtlDTO>();
        if(wrkDtlList != null && !wrkDtlList.isEmpty()) {
            wtmWrkDtlDTOList = wrkDtlList.stream()
                    .map(data -> {
                        WtmWrkDtlDTO wtmWrkDtlDTO = new WtmWrkDtlDTO();
                        wtmWrkDtlDTO.setEnterCd(data.get("enterCd").toString());
                        wtmWrkDtlDTO.setWrkDtlId(data.get("wrkDtlId").toString());
                        wtmWrkDtlDTO.setYmd(data.get("ymd").toString());
                        wtmWrkDtlDTO.setSabun(data.get("sabun").toString());
                        wtmWrkDtlDTO.setWorkCd(data.get("workCd").toString());
                        wtmWrkDtlDTO.setPlanSymd(data.get("planSymd").toString());
                        wtmWrkDtlDTO.setPlanShm(data.get("planShm").toString());
                        wtmWrkDtlDTO.setPlanEymd(data.get("planEymd").toString());
                        wtmWrkDtlDTO.setPlanEhm(data.get("planEhm").toString());
                        wtmWrkDtlDTO.setPlanMm(Integer.parseInt(data.get("planMm").toString()));
                        wtmWrkDtlDTO.setAutoCreYn(data.get("autoCreYn").toString());
                        wtmWrkDtlDTO.setAddWorkTimeYn(data.get("addWorkTimeYn").toString());
                        wtmWrkDtlDTO.setWorkTimeType(data.get("workTimeType").toString());
                        wtmWrkDtlDTO.setDeemedYn(data.get("deemedYn").toString());
                        return wtmWrkDtlDTO;
                    })
                    .collect(Collectors.toList());
        }

        // 근태 상세 조회 결과를 WtmGntDtlDTO 으로 변환
        List<WtmGntDtlDTO> wtmGntDtlDTOList = new ArrayList<>();
        if(gntDtlList != null && !gntDtlList.isEmpty()) {
            wtmGntDtlDTOList = gntDtlList.stream()
                    .map(data -> {
                        WtmGntDtlDTO wtmGntDtlDTO = new WtmGntDtlDTO();
                        wtmGntDtlDTO.setEnterCd(data.get("enterCd").toString());
                        wtmGntDtlDTO.setGntDtlId(data.get("gntDtlId").toString());
                        wtmGntDtlDTO.setYmd(data.get("ymd").toString());
                        wtmGntDtlDTO.setSabun(data.get("sabun").toString());
                        wtmGntDtlDTO.setGntCd(data.get("gntCd").toString());
                        wtmGntDtlDTO.setSymd(data.get("symd").toString());
                        wtmGntDtlDTO.setShm(data.get("shm").toString());
                        wtmGntDtlDTO.setEymd(data.get("eymd").toString());
                        wtmGntDtlDTO.setEhm(data.get("ehm").toString());
                        wtmGntDtlDTO.setMm(Integer.parseInt(data.get("mm").toString()));
                        wtmGntDtlDTO.setRequestUseType(data.get("requestUseType").toString());
                        return wtmGntDtlDTO;
                    })
                    .collect(Collectors.toList());
        }

        // 일 실 근무시간 계산, 일근무집계자료 리턴
        return wtmCalcWorkTime.countDailyWorkTime(targetList, inOutList, wtmWrkDtlDTOList, wtmGntDtlDTOList, holidayList, workClassInfo, shiftHoliday, true);
    }

    public String getBaseWorkCd() {
        return wtmCalcWorkTime.getBaseWorkCd();
    }

    public String getOtWorkCd() {
        return wtmCalcWorkTime.getOtWorkCd();
    }

    public String getBreakWorkCd() {
        return wtmCalcWorkTime.getBreakWorkCd();
    }

    public List<WtmDailyCountDTO> sumWtmDayWorkTime (List<WtmWrkDtlDTO> wtmWrkDtlDTOList) throws Exception {
        return wtmCalcWorkTime.sumWtmDayWorkTime(wtmWrkDtlDTOList);
    }

    public List<WtmWrkDtlDTO> convertToWtmWrkDtlDTOList(List<WtmWrkSchDTO> wtmWrkSchDTOList) {
        return wtmCalcWorkTime.convertToWtmWrkDtlDTOList(wtmWrkSchDTOList);
    }

    public int calcMinutes(int timeF, int timeT) {
        return wtmCalcWorkTime.calcMinutes(timeF, timeT);
    }

    public DayOfWeek convertToDayOfWeek(String weekBeginDay) {
        return wtmCalcWorkTime.convertToDayOfWeek(weekBeginDay);
    }

    public String convertToDayOfWeekStr(DayOfWeek day) {
        return wtmCalcWorkTime.convertToDayOfWeekStr(day);
    }
}
