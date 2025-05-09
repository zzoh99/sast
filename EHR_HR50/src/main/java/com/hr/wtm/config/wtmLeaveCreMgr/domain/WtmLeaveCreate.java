package com.hr.wtm.config.wtmLeaveCreMgr.domain;

import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.DateUtil;
import com.hr.wtm.config.wtmLeaveCreMgr.dto.WtmUserLeaveCreDTO;
import com.hr.wtm.config.wtmLeaveCreMgr.dto.WtmUserLeaveDTO;
import com.hr.wtm.config.wtmLeaveCreStd.WtmLeaveCreOption;
import com.hr.wtm.domain.WtmAnnualLeaveCreateType;
import com.hr.wtm.domain.WtmAnnualLeaveCreateTypeU1Y;
import com.hr.wtm.domain.WtmMonthlyLeaveCreateTypeU1Y;
import yjungsan.util.StringUtil;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

public class WtmLeaveCreate {

    private final String NO_MATCHING_ANNUAL_CRE_TYPE = "일치하는 연차생성기준이 없습니다. 정확한 연차생성기준을 입력해주세요.";
    private final String PLEAVE_INPUT_FINANCIAL_DATE = "회계일을 입력해주세요.";

    private final WtmLeaveCreOption wtmLeaveCreOption; // 연차생성옵션
    private List<WtmLeaveCreEmployee> empList; // 대상자 리스트
    private List<WtmUserLeaveCreDTO> annualLeaveLogic; // 연차 생성방법
    private List<WtmUserLeaveCreDTO> annualLeaveWithinOneYearLogic; // 연차 생성방법
    private List<WtmUserLeaveCreDTO> monthlyLeaveWithinOneYearLogic; // 1년 미만 대상자의 월차 생성방법
    private List<WtmUserLeaveDTO> resultList; // 실제반영이력

    public WtmLeaveCreate(WtmLeaveCreOption wtmLeaveCreOption) {
        this.wtmLeaveCreOption = wtmLeaveCreOption;
        this.empList = new ArrayList<>();
        this.annualLeaveLogic = new ArrayList<>();
        this.annualLeaveWithinOneYearLogic = new ArrayList<>();
        this.monthlyLeaveWithinOneYearLogic = new ArrayList<>();
        this.resultList = new ArrayList<>();
    }

    public String getEnterCd() {
        return this.wtmLeaveCreOption.getEnterCd();
    }

    public String getGntCd() {
        return this.wtmLeaveCreOption.getGntCd();
    }

    public String getSearchSeq() {
        return this.wtmLeaveCreOption.getSearchSeq();
    }

    /**
     * 잔여연차 처리방법
     * @return (A: 이월, B: 보상, C: 소멸)
     */
    public String getRewardType() {
        return this.wtmLeaveCreOption.getRewardType();
    }

    /**
     * 입사후 1년 미만 대상자 잔여연차 처리방법
     * @return (A: 이월, B: 보상, C: 소멸)
     */
    public String getRewardTypeU1y() {
        return this.wtmLeaveCreOption.getRewardTypeU1y();
    }

    public String getUnit() {
        return this.wtmLeaveCreOption.getUnit();
    }

    /**
     * 생성 대상자 리스트 조회
     * @return 생성 대상자 리스트
     */
    public List<WtmLeaveCreEmployee> getEmpList() {
        return empList;
    }

    /**
     * 입사 후 1년미만 대상자 월차 계산방법 데이터 조회.
     * @return 연월차 결과 데이터
     */
    public List<WtmUserLeaveCreDTO> getMonthlyLeaveWithinOneYearlogic() {
        return monthlyLeaveWithinOneYearLogic;
    }

    /**
     * 입사 후 1년미만 대상자 2년차 연차 계산방법 데이터 조회.
     * @return 연월차 결과 데이터
     */
    public List<WtmUserLeaveCreDTO> getAnnualLeaveWithinOneYearlogic() {
        return annualLeaveWithinOneYearLogic;
    }

    /**
     * 연차 계산방법 데이터 조회.
     * @return 연월차 결과 데이터
     */
    public List<WtmUserLeaveCreDTO> getAnnualLeaveLogic() {
        return annualLeaveLogic;
    }

    /**
     * 연월차 실제 결과 데이터 조회
     * @return 연월차 결과 데이터
     */
    public List<WtmUserLeaveDTO> getResultList() {
        return resultList;
    }

    /**
     * 연차 생성 대상자 설정
     * 대상자의 연차생성시 입사일기준에 따라 연차 생성에 필요한 입사일을 적용
     * @param empList 대상자리스트
     */
    public void setEmpList(List<Map<String, Object>> empList) {

        List<WtmLeaveCreEmployee> newList = new ArrayList<>();
        for (Map<String, Object> emp : empList) {
            String empYmd = ((String) emp.get("empYmd")).replaceAll("[-|.]", "");
            String gempYmd = ((String) emp.get("gempYmd")).replaceAll("[-|.]", "");

            String stdEmpYmd;
            boolean isGroupEmployee = "G".equals(this.wtmLeaveCreOption.getAnnualCreJoinType());
            if (isGroupEmployee) { // 그룹입사일
                stdEmpYmd = !gempYmd.isEmpty() ? gempYmd : empYmd;
            } else {
                stdEmpYmd = !empYmd.isEmpty() ? empYmd : gempYmd;
            }
            Log.Debug(" 사번: " + emp.get("sabun") + ", 연차생성기준에 따른 입사일자: " + stdEmpYmd);

            String enterCd = StringUtil.stringValueOf(emp.get("enterCd"));
            String sabun = StringUtil.stringValueOf(emp.get("sabun"));
            String name = StringUtil.stringValueOf(emp.get("name"));

            WtmLeaveCreEmployee employee = new WtmLeaveCreEmployee(enterCd, sabun, name, stdEmpYmd);

            String leaveId = StringUtil.stringValueOf(emp.get("leaveId"));
            if (!leaveId.isEmpty())
                employee.setLeaveIdWithinOneYear(leaveId);

            newList.add(employee);
        }
        this.empList = newList;
    }

    /**
     * 연차 계산
     * @param stdYmd 기준일자 (YYYYMMDD)
     * @throws Exception
     */
    public void calc(String stdYmd) throws Exception {
        Log.Debug("생성일자 " + stdYmd + " 생성 시작 >> " + System.currentTimeMillis());

        if (this.monthlyLeaveWithinOneYearLogic == null) this.monthlyLeaveWithinOneYearLogic = new ArrayList<>();
        if (this.annualLeaveWithinOneYearLogic == null) this.annualLeaveWithinOneYearLogic = new ArrayList<>();
        if (this.annualLeaveLogic == null) this.annualLeaveLogic = new ArrayList<>();

        for (WtmLeaveCreEmployee target : empList) {
            // 대상자 별 데이터 생성.

            if (target.isInvalidEmployee()) {
                Log.Error(" ## 사번: " + target.getSabun() + " 의 정보가 유효하지 않음. " + target + " ## ");
                continue;
            }
            LocalDate stdDate = DateUtil.getLocalDate(stdYmd);

            if (target.isHiredWithinOneYear(stdDate)) {
                // 입사일로부터 1년 미만 대상자의 월차, 연차 계산.
                addMonthlyLeaveWithinOneYear(target, stdDate);
                addAnnualLeaveWithinOneYear(target, stdDate);
            } else {
                // 입사 1년 이상 대상자의 연차 계산.
                addAnnualLeave(target, stdDate);
            }
        }
    }

    /**
     * 입사 1년 미만자의 월차를 계산하여 logicList 에 추가
     * @param employee 대상자정보
     * @param stdDate 기준일자
     * @throws Exception
     */
    public void addMonthlyLeaveWithinOneYear(WtmLeaveCreEmployee employee, LocalDate stdDate) throws Exception {

        if (WtmMonthlyLeaveCreateTypeU1Y.ONE_DAY_BY_MONTH.equals(this.wtmLeaveCreOption.getMonthlyCreTypeU1y())) {

            WtmMonthlyLeaveWithinOneYearA typeA = new WtmMonthlyLeaveWithinOneYearA(employee.getEmpDate(), stdDate);
            if (typeA.isTarget()) {
                WtmUserLeaveCreDTO creDTO = new WtmUserLeaveCreDTO(employee, this.wtmLeaveCreOption, stdDate);
                if (this.wtmLeaveCreOption.isStartAtEmpYmdU1y()) {
                    if (employee.getLeaveIdWithinOneYear().isEmpty()) {
                        // 대상자의 1년 미만 월차ID가 없다면 새로 생성된 ID를 매핑.
                        employee.setLeaveIdWithinOneYear(creDTO.getLeaveId());
                    } else {
                        // 대상자의 1년 미만 월차ID가 이미 존재할 경우
                        creDTO.setLeaveId(employee.getLeaveIdWithinOneYear());

                        // 이미 동일한 월차ID를 가지고 있는 항목을 삭제 후 새로운 월차 정보로 설정
                        monthlyLeaveWithinOneYearLogic.stream()
                                .filter(dto -> employee.getLeaveIdWithinOneYear().equals(dto.getLeaveId()))
                                .collect(Collectors.toList())
                                .forEach(dto -> monthlyLeaveWithinOneYearLogic.remove(dto));
                    }
                    // 1년 미만자의 월차 생성 시 사용시작일을 입사일과 동일하게 가져가는 조건일 경우 미리 생성된 연차ID와 동일하게 설정
                    typeA.setStartAtEmpYmd(this.wtmLeaveCreOption.isStartAtEmpYmdU1y());
                }
                creDTO.setGntSYmd(typeA.getGntSYmd());
                creDTO.setGntEYmd(typeA.getGntEYmd());
                creDTO.setUseSYmd(typeA.getUseSYmd());
                creDTO.setUseEYmd(typeA.getUseEYmd());
                creDTO.setMonthlyU1yCnt(typeA.getMonthlyWithinOneYearCnt());
                monthlyLeaveWithinOneYearLogic.add(creDTO);
            }
        } else if (WtmMonthlyLeaveCreateTypeU1Y.ELEVEN_DAYS_AT_JOIN.equals(this.wtmLeaveCreOption.getMonthlyCreTypeU1y())) {
            // 입사 시 11일 선 부여.

            WtmMonthlyLeaveWithinOneYearB typeB = new WtmMonthlyLeaveWithinOneYearB(employee.getEmpDate(), stdDate);
            if (typeB.isTarget()) {
                WtmUserLeaveCreDTO creDTO = new WtmUserLeaveCreDTO(employee, this.wtmLeaveCreOption, stdDate);
                creDTO.setGntSYmd(typeB.getGntSYmd());
                creDTO.setGntEYmd(typeB.getGntEYmd());
                creDTO.setUseSYmd(typeB.getUseSYmd());
                creDTO.setUseEYmd(typeB.getUseEYmd());
                creDTO.setMonthlyU1yCnt(typeB.getMonthlyWithinOneYearCnt());
                monthlyLeaveWithinOneYearLogic.add(creDTO);
            }
        } else if (WtmMonthlyLeaveCreateTypeU1Y.DIVIDED_DAYS.equals(this.wtmLeaveCreOption.getMonthlyCreTypeU1y())) {

            if (this.wtmLeaveCreOption.isEmptyFinDate())
                throw new HrException(PLEAVE_INPUT_FINANCIAL_DATE);

            // 입사일 이후 첫 번째 회계일자
            LocalDate finDate = employee.getFirstFinDateAfterEmpDate(this.wtmLeaveCreOption.getFinDateMonth(), this.wtmLeaveCreOption.getFinDateDay());

            // 입사일일 때 지급하는 케이스
            WtmMonthlyLeaveWithinOneYearC1 typeC1 = new WtmMonthlyLeaveWithinOneYearC1(employee.getEmpDate(), stdDate, finDate);
            if (typeC1.isTarget()) {
                WtmUserLeaveCreDTO creDTO = new WtmUserLeaveCreDTO(employee, this.wtmLeaveCreOption, stdDate);
                creDTO.setGntSYmd(typeC1.getGntSYmd());
                creDTO.setGntEYmd(typeC1.getGntEYmd());
                creDTO.setUseSYmd(typeC1.getUseSYmd());
                creDTO.setUseEYmd(typeC1.getUseEYmd());
                creDTO.setMonthlyU1yCnt(typeC1.getMonthlyWithinOneYearCnt());
                monthlyLeaveWithinOneYearLogic.add(creDTO);
            }

            // 첫 번째 회계일일 경우 지급 케이스
            WtmMonthlyLeaveWithinOneYearC2 typeC2 = new WtmMonthlyLeaveWithinOneYearC2(employee.getEmpDate(), stdDate, finDate);
            if (typeC2.isTarget()) {
                WtmUserLeaveCreDTO creDTO = new WtmUserLeaveCreDTO(employee, this.wtmLeaveCreOption, stdDate);
                creDTO.setGntSYmd(typeC2.getGntSYmd());
                creDTO.setGntEYmd(typeC2.getGntEYmd());
                creDTO.setUseSYmd(typeC2.getUseSYmd());
                creDTO.setUseEYmd(typeC2.getUseEYmd());
                creDTO.setMonthlyU1yCnt(typeC2.getMonthlyWithinOneYearCnt());
                monthlyLeaveWithinOneYearLogic.add(creDTO);
            }
        } else {
            throw new HrException(this.NO_MATCHING_ANNUAL_CRE_TYPE);
        }
    }

    /**
     * (회계일 기준 연차 지급일 경우) 입사 1년 미만자의 1년차 개근 연차를 계산하여 logicList 에 추가
     * @param employee 대상자
     * @param stdDate 기준일자
     * @throws Exception Exception
     */
    public void addAnnualLeaveWithinOneYear(WtmLeaveCreEmployee employee, LocalDate stdDate) throws Exception {

        // 회계일 기준이 아닐 경우 지급할 필요가 없다.
        if (!WtmAnnualLeaveCreateType.FINANCIAL_DATE.equals(this.wtmLeaveCreOption.getAnnualCreType()))
            return;

        if (this.wtmLeaveCreOption.isEmptyFinDate())
            throw new HrException(PLEAVE_INPUT_FINANCIAL_DATE);

        // 입사일 이후 첫 번째 회계일자
        LocalDate finDate = employee.getFirstFinDateAfterEmpDate(this.wtmLeaveCreOption.getFinDateMonth(), this.wtmLeaveCreOption.getFinDateDay());

        // 입사후 1년 미만 대상자 1년 개근시 연차 부여기준(A: 첫 회계일에 근무시간 대비 연차 부여, B: 첫 회계일에 15일 부여, C: 입사일에 첫 회계일까지 근무기간 대비 연차 선부여)
        if (WtmAnnualLeaveCreateTypeU1Y.CALCED_DAYS_AT_FIN_DATE.equals(this.wtmLeaveCreOption.getAnnualCreTypeU1y())) {
            WtmAnnualLeaveWithinOneYearA typeA = new WtmAnnualLeaveWithinOneYearA(employee.getEmpDate(), stdDate, finDate);
            if (typeA.isTarget()) {
                typeA.setTotDaysType(this.wtmLeaveCreOption.getTotDaysType());
                typeA.setUpbaseU1y(this.wtmLeaveCreOption.getUpbaseU1y());
                typeA.setUnitU1y(this.wtmLeaveCreOption.getUnitU1y());

                WtmUserLeaveCreDTO creDTO = new WtmUserLeaveCreDTO(employee, this.wtmLeaveCreOption, stdDate);
                creDTO.setGntSYmd(typeA.getGntSYmd());
                creDTO.setGntEYmd(typeA.getGntEYmd());
                creDTO.setUseSYmd(typeA.getUseSYmd());
                creDTO.setUseEYmd(typeA.getUseEYmd());
                creDTO.setAnnualU1yCnt(typeA.getAnnualWithinOneYearCnt());
                annualLeaveWithinOneYearLogic.add(creDTO);
            }
        } else if (WtmAnnualLeaveCreateTypeU1Y.FIFTEEN_DAYS_AT_FIN_DATE.equals(this.wtmLeaveCreOption.getAnnualCreTypeU1y())) {
            WtmAnnualLeaveWithinOneYearB typeB = new WtmAnnualLeaveWithinOneYearB(employee.getEmpDate(), stdDate, finDate);
            if (typeB.isTarget()) {

                WtmUserLeaveCreDTO creDTO = new WtmUserLeaveCreDTO(employee, this.wtmLeaveCreOption, stdDate);
                creDTO.setGntSYmd(typeB.getGntSYmd());
                creDTO.setGntEYmd(typeB.getGntEYmd());
                creDTO.setUseSYmd(typeB.getUseSYmd());
                creDTO.setUseEYmd(typeB.getUseEYmd());
                creDTO.setAnnualU1yCnt(typeB.getAnnualWithinOneYearCnt());
                annualLeaveWithinOneYearLogic.add(creDTO);
            }
        } else if (WtmAnnualLeaveCreateTypeU1Y.GET_LEAVE_DAYS_AT_JOIN.equals(this.wtmLeaveCreOption.getAnnualCreTypeU1y())) {
            WtmAnnualLeaveWithinOneYearC typeC = new WtmAnnualLeaveWithinOneYearC(employee.getEmpDate(), stdDate, finDate);
            if (typeC.isTarget()) {
                typeC.setUpbaseU1y(this.wtmLeaveCreOption.getUpbaseU1y());
                typeC.setUnitU1y(this.wtmLeaveCreOption.getUnitU1y());

                WtmUserLeaveCreDTO creDTO = new WtmUserLeaveCreDTO(employee, this.wtmLeaveCreOption, stdDate);
                creDTO.setGntSYmd(typeC.getGntSYmd());
                creDTO.setGntEYmd(typeC.getGntEYmd());
                creDTO.setUseSYmd(typeC.getUseSYmd());
                creDTO.setUseEYmd(typeC.getUseEYmd());
                creDTO.setAnnualU1yCnt(typeC.getAnnualWithinOneYearCnt());
                annualLeaveWithinOneYearLogic.add(creDTO);
            }
        } else {
            throw new HrException(this.NO_MATCHING_ANNUAL_CRE_TYPE);
        }
    }

    /**
     * 입사 1년 이후 대상자의 연차를 계산하여 logicList 에 추가
     * @param employee 대상자
     * @param stdDate 기준일자
     * @throws Exception Exception
     */
    public void addAnnualLeave(WtmLeaveCreEmployee employee, LocalDate stdDate) throws Exception {

        // 연차생성기준(A: 입사일, B: 회계일, C: 입사월)
        if (WtmAnnualLeaveCreateType.EMPLOYEE_DATE.equals(this.wtmLeaveCreOption.getAnnualCreType())) {
            // 입사일 기준 연차 생성

            WtmAnnualLeaveA typeA = new WtmAnnualLeaveA(employee.getEmpDate(), stdDate);
            if (typeA.isTarget()) {

                WtmUserLeaveCreDTO creDTO = new WtmUserLeaveCreDTO(employee, this.wtmLeaveCreOption, stdDate);
                creDTO.setGntSYmd(typeA.getGntSYmd());
                creDTO.setGntEYmd(typeA.getGntEYmd());
                creDTO.setUseSYmd(typeA.getUseSYmd());
                creDTO.setUseEYmd(typeA.getUseEYmd());

                if (!"Y".equals(this.wtmLeaveCreOption.getNoCheckWorkRateYn())) {
                    // TODO: 출근율 80% 미만 로직 추가해야함.
                } else {
                    creDTO.setCreAnnualCnt(typeA.getCreAnnualCnt());
                    // 최대 지급 가능 연차 개수 고려하여 가산연차 지급
                    creDTO.setAddAnnualCnt(typeA.getAddAnnualCnt());
                }

                annualLeaveLogic.add(creDTO);
            }

        } else if (WtmAnnualLeaveCreateType.FINANCIAL_DATE.equals(this.wtmLeaveCreOption.getAnnualCreType())) {
            // 회계일 기준 연차 생성

            if (this.wtmLeaveCreOption.isEmptyFinDate())
                throw new HrException(PLEAVE_INPUT_FINANCIAL_DATE);

            // 기준년도의 회계일자
            LocalDate stdFinDate = stdDate.withMonth(Integer.parseInt(this.wtmLeaveCreOption.getFinDateMonth())).withDayOfMonth(Integer.parseInt(this.wtmLeaveCreOption.getFinDateDay()));

            WtmAnnualLeaveB typeB = new WtmAnnualLeaveB(employee.getEmpDate(), stdDate, stdFinDate);
            if (typeB.isTarget()) {

                WtmUserLeaveCreDTO creDTO = new WtmUserLeaveCreDTO(employee, this.wtmLeaveCreOption, stdDate);
                creDTO.setGntSYmd(typeB.getGntSYmd());
                creDTO.setGntEYmd(typeB.getGntEYmd());
                creDTO.setUseSYmd(typeB.getUseSYmd());
                creDTO.setUseEYmd(typeB.getUseEYmd());

                if (!"Y".equals(this.wtmLeaveCreOption.getNoCheckWorkRateYn())) {
                    // TODO: 출근율 80% 미만 로직 추가해야함.
                } else {
                    creDTO.setCreAnnualCnt(typeB.getCreAnnualCnt());

                    // 입사년차에 따른 휴가수 계산
                    double workCnt = employee.getWorkCnt(stdFinDate, this.wtmLeaveCreOption.getUpbase(), this.wtmLeaveCreOption.getUnit(), this.wtmLeaveCreOption.getTotDaysType());
                    typeB.setWorkCnt(workCnt);
                    creDTO.setAddAnnualCnt(typeB.getAddAnnualCnt());
                }

                annualLeaveLogic.add(creDTO);
            }

        } else if (WtmAnnualLeaveCreateType.EMPLOYEE_MONTH.equals(this.wtmLeaveCreOption.getAnnualCreType())) {
            // 입사월 기준 연차 생성

            WtmAnnualLeaveC typeC = new WtmAnnualLeaveC(employee.getEmpDate(), stdDate);
            if (typeC.isTarget()) {

                WtmUserLeaveCreDTO creDTO = new WtmUserLeaveCreDTO(employee, this.wtmLeaveCreOption, stdDate);
                creDTO.setGntSYmd(typeC.getGntSYmd());
                creDTO.setGntEYmd(typeC.getGntEYmd());
                creDTO.setUseSYmd(typeC.getUseSYmd());
                creDTO.setUseEYmd(typeC.getUseEYmd());

                if (!"Y".equals(this.wtmLeaveCreOption.getNoCheckWorkRateYn())) {
                    // TODO: 출근율 80% 미만 로직 추가해야함.
                } else {
                    creDTO.setCreAnnualCnt(typeC.getCreAnnualCnt());
                    // 최대 지급 가능 연차 개수 고려하여 가산연차 지급
                    creDTO.setAddAnnualCnt(typeC.getAddAnnualCnt());
                }

                annualLeaveLogic.add(creDTO);
            }

        } else {
            throw new HrException(this.NO_MATCHING_ANNUAL_CRE_TYPE);
        }
    }

    /**
     * 특정 년도 내에 발생할 모든 연차 계산
     * @param stdYear 기준년도
     * @throws Exception Exception
     */
    public void calcByYear(String stdYear) throws Exception {
        Log.Debug(" ## 생성년도: " + stdYear + " 휴가 생성 시작 ## ");

        if (this.monthlyLeaveWithinOneYearLogic == null) this.monthlyLeaveWithinOneYearLogic = new ArrayList<>();
        if (this.annualLeaveWithinOneYearLogic == null) this.annualLeaveWithinOneYearLogic = new ArrayList<>();
        if (this.annualLeaveLogic == null) this.annualLeaveLogic = new ArrayList<>();

        LocalDate startDate = DateUtil.getLocalDate(stdYear + "0101");
        LocalDate endDate = DateUtil.getLocalDate(stdYear + "1231");

        long daysBetween = ChronoUnit.DAYS.between(startDate, endDate);

        for (long i = 0 ; i < daysBetween ; i++) {
            LocalDate stdDate = startDate.plusDays(i);
            calc(DateUtil.convertLocalDateToString(stdDate));
        }

/*
        for (WtmLeaveCreEmployee target : empList) {
            // 대상자 별 데이터 생성.

            if (target.isInvalidEmployee()) {
                Log.Error(" ## 사번: " + target.getSabun() + " 의 정보가 유효하지 않음. " + target + " ## ");
                continue;
            }
            LocalDate empDate = DateUtil.getLocalDate(empYmd);

            // 1년미만 연월차 자동생성 처리, 자동생성이 아닌 경우 수동으로 생성한다.
            if ("Y".equals(this.wtmLeaveCreOption.getAutoCreU1yYn())) {
                // 입사일로부터 1년 미만 대상자의 월차, 연차 계산.
                // 일사일로부터 1년 후 -1일 계산
                LocalDate afterEmpDateOneYear = empDate.plusYears(1).minusDays(1);

                // 기준년도와 비교하여 1년 미만 입사자 여부를 파악
                // (입사일 + 1년 -1일)의 년도 >= 기준년도인 경우에 1년미만입사자로 취급
                boolean isWithinOneYear = afterEmpDateOneYear.getYear() >= Integer.parseInt(stdYear);
                if(isWithinOneYear) {
                    logicList.addAll(getMonthlyHolidayListOfUnder1Year(target, stdYear));
                    logicList.addAll(getAnnualHolidayListOfUnder1Year(target, stdYear));
                }
            }

            // 입사 1년 이상 대상자의 연차 계산. 대상자마다 년에 1회씩.
            LocalDate stdDate;
            if (WtmAnnualLeaveCreateType.EMPLOYEE_DATE.equals(this.wtmLeaveCreOption.getAnnualCreType())) {
                // 입사일
                stdDate = LocalDate.of(Integer.parseInt(stdYear), empDate.getMonthValue(), empDate.getDayOfMonth());
            } else if (WtmAnnualLeaveCreateType.FINANCIAL_DATE.equals(this.wtmLeaveCreOption.getAnnualCreType())) {
                // 회계일
                stdDate = LocalDate.of(Integer.parseInt(stdYear), Integer.parseInt(this.wtmLeaveCreOption.getFinDateMonth()), Integer.parseInt(this.wtmLeaveCreOption.getFinDateDay()));
            } else if (WtmAnnualLeaveCreateType.EMPLOYEE_MONTH.equals(this.wtmLeaveCreOption.getAnnualCreType())) {
                // 입사월
                stdDate = LocalDate.of(Integer.parseInt(stdYear), empDate.getMonthValue(), 1);
            } else {
                continue;
            }

            // 입사 1년 이상 대상자의 연차 계산.
            if(stdDate.isAfter(empDate.plusYears(1).minusDays(1))) {
                WtmUserLeaveCreDTO dto = getAnnualLeave(target, stdDate);
                if (dto != null) {
                    logicList.add(dto);
                }
            }
        }
*/
        Log.DebugEnd();
    }

    /**
     * 모든 계산 로직을 조회한다.
     * @return list of logic
     */
    public List<WtmUserLeaveCreDTO> getLogicList() {
        List<WtmUserLeaveCreDTO> list = new ArrayList<>();
        list.addAll(monthlyLeaveWithinOneYearLogic);
        list.addAll(annualLeaveWithinOneYearLogic);
        list.addAll(annualLeaveLogic);
        return list;
    }

    /**
     * 계산 로직을 바탕으로 실제 연차 데이터를 생성한다.
     */
    public void createUserLeaves() {

        if (this.resultList == null)
            resultList = new ArrayList<>();

        this.monthlyLeaveWithinOneYearLogic.forEach(creDTO -> {
            WtmUserLeaveDTO dto = new WtmUserLeaveDTO();
            dto.convertFromCreDTO(creDTO);
            resultList.add(dto);
        });

        this.annualLeaveWithinOneYearLogic.forEach(creDTO -> {
            WtmUserLeaveDTO dto = new WtmUserLeaveDTO();
            dto.convertFromCreDTO(creDTO);
            resultList.add(dto);
        });

        this.annualLeaveLogic.forEach(creDTO -> {
            WtmUserLeaveDTO dto = new WtmUserLeaveDTO();
            dto.convertFromCreDTO(creDTO);
            resultList.add(dto);
        });
    }
}
