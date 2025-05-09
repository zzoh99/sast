package com.hr.wtm.config.wtmLeaveCreStd;

import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.DateUtil;
import com.hr.wtm.config.wtmLeaveCreMgr.domain.WtmLeaveCreEmployee;
import com.hr.wtm.domain.WtmAnnualLeaveCreateType;
import com.hr.wtm.domain.WtmAnnualLeaveCreateTypeU1Y;
import com.hr.wtm.domain.WtmMonthlyLeaveCreateTypeU1Y;
import com.hr.wtm.domain.WtmUtils;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

public class WtmLeaveCreSimulation {

    // 연차 시뮬레이션 시 연차유급휴가 생성 대상 년수
    private final int ANNUAL_LEAVE_CRE_YEAR_CNT = 24;

    // 최대 지급 가능 연차 개수
    private final int MAX_ANNUAL_LEAVE_CNT = 25;

    private String empYmd; // 입사일자
    private final WtmLeaveCreOption wtmLeaveCreOption;
    private List<WtmLeaveCreSimulationDTO> result;

    public WtmLeaveCreSimulation(WtmLeaveCreOption wtmLeaveCreOption) {
        this.wtmLeaveCreOption = wtmLeaveCreOption;
        this.result = new ArrayList<>();
    }

    public String getGntCd() {
        return this.wtmLeaveCreOption.getGntCd();
    }

    public String getUnit() {
        return this.wtmLeaveCreOption.getUnit();
    }

    /**
     * 계산된 연월차 결과 데이터 조회
     * @return 연월차 결과 데이터
     */
    public List<WtmLeaveCreSimulationDTO> getResult() {
        return result;
    }

    /**
     * 년도 별 데이터 조회. 시뮬레이션에서 화면 렌더링을 위해 아래와 같이 3개로 분할하여 조회하도록 함.<br>
     * <2024년도 입사자의 결과 예시><br>
     * {<br>
     * &nbsp;&nbsp;&nbsp;&nbsp;"2024":&nbsp;[],<br>
     * &nbsp;&nbsp;&nbsp;&nbsp;"2025":&nbsp;[],<br>
     * &nbsp;&nbsp;&nbsp;&nbsp;"others":&nbsp;[]<br>
     * }<br>
     * @return 연월차 시뮬레이션 결과 데이터
     */
    public Map<String, List<WtmLeaveCreSimulationDTO>> getResultByYear() {
        Map<String, List<WtmLeaveCreSimulationDTO>> map = new HashMap<>();
        int year = DateUtil.getLocalDate(this.empYmd).getYear();
        map.put(String.valueOf(year), this.result.stream().filter(dto -> year == DateUtil.getLocalDate(dto.getYmd()).getYear()).collect(Collectors.toList())); // 첫 번째 년도
        map.put(String.valueOf(year+1), this.result.stream().filter(dto -> year+1 == DateUtil.getLocalDate(dto.getYmd()).getYear()).collect(Collectors.toList())); // 두 번째 년도
        map.put("others", this.result.stream().filter(dto -> year != DateUtil.getLocalDate(dto.getYmd()).getYear() && year+1 != DateUtil.getLocalDate(dto.getYmd()).getYear()).collect(Collectors.toList())); // 그 이후
        return map;
    }

    /**
     * 입사일 설정
     * @param empYmd 입사일자
     */
    public void setEmpYmd(String empYmd) {
        try {
            DateUtil.getLocalDate(empYmd.replaceAll("-", ""));
            this.empYmd = empYmd.replaceAll("-", "");
        } catch(DateTimeParseException e) {
            Log.Error("정확한 입사일자를 입력해주세요. [입력값: " + this.empYmd + "]");
            this.empYmd = null;
        }
    }

    /**
     * 연차 시뮬레이션 계산
     * @param empYmd 입사일자(yyyyMMdd)
     * @throws Exception
     */
    public void calc(String empYmd) throws Exception {
        this.setEmpYmd(empYmd);
        calc();
    }

    /**
     * 연차 시뮬레이션 계산
     * @throws Exception
     */
    public void calc() throws Exception {
        Log.DebugStart();

        if (this.result == null) this.result = new ArrayList<>();
        if (this.empYmd == null || this.empYmd.isEmpty()) {
            throw new HrException("입사일자를 입력해주세요.");
        }

        LocalDate empDate = DateUtil.getLocalDate(this.empYmd);
        // 입사일로부터 1년 미만 대상자의 월차, 연차 계산.
        this.result.addAll(getMonthlyLeavesWithinOneYear(empDate));
        this.result.addAll(getAnnualLeavesWithinOneYear(empDate));
        // 입사 1년 이상 대상자의 연차 계산.
        this.result.addAll(getAnnualLeaves(empDate));

        // 일자별 sort
        Comparator<WtmLeaveCreSimulationDTO> comparator = (o1, o2) -> {
            LocalDate o1Date = DateUtil.getLocalDate(o1.getYmd());
            LocalDate o2Date = DateUtil.getLocalDate(o2.getYmd());
            if (o1Date.isAfter(o2Date)) return 1;
            else if (o1Date.isBefore(o2Date)) return -1;
            else return 0;
        };
        this.result.sort(comparator);

        Log.DebugEnd();
    }

    /**
     * 입사 1년 미만자의 월차 리스트 조회
     * @param empDate 입사일자
     * @return 계산된 1년 미만 대상자의 월차 데이터
     * @throws Exception
     */
    public List<WtmLeaveCreSimulationDTO> getMonthlyLeavesWithinOneYear(LocalDate empDate) throws Exception {
        Log.DebugStart();

        List<WtmLeaveCreSimulationDTO> list = new ArrayList<>();

        if (WtmMonthlyLeaveCreateTypeU1Y.ONE_DAY_BY_MONTH.equals(this.wtmLeaveCreOption.getMonthlyCreTypeU1y())) {
            // 매월 개근에 따라 1일 부여.

            for (int i = 0 ; i <= 11 ; i++) {
                WtmLeaveCreSimulationDTO dto = new WtmLeaveCreSimulationDTO();
                dto.setYmd(empDate.plusMonths(i));
                dto.setAnnualLeave("-");
                if (i == 0) {
                    dto.setTerm("입사일");
                    dto.setMonthlyLeave("-");
                    dto.setReasonText("");
                    dto.setReasonPeriod("");
                } else {
                    dto.setTerm((i+1) + "개월차");
                    dto.setMonthlyLeave("1");
                    dto.setReasonText("1개월개근");
                    dto.setReasonPeriod(DateUtil.convertLocalDateToString(empDate.plusMonths(i-1), "yyyy.MM.dd") + " ~ " + DateUtil.convertLocalDateToString(empDate.plusMonths(i).minusDays(1), "yyyy.MM.dd"));
                }
                list.add(dto);
            }

        } else if (WtmMonthlyLeaveCreateTypeU1Y.ELEVEN_DAYS_AT_JOIN.equals(this.wtmLeaveCreOption.getMonthlyCreTypeU1y())) {
            // 입사 시 11일 선 부여.

            WtmLeaveCreSimulationDTO dto = new WtmLeaveCreSimulationDTO();
            dto.setYmd(empDate);
            dto.setTerm("입사일");
            dto.setMonthlyLeave("11");
            dto.setAnnualLeave("-");
            dto.setReasonText("11개월개근");
            dto.setReasonPeriod(DateUtil.convertLocalDateToString(empDate, "yyyy.MM.dd") + " ~ " + DateUtil.convertLocalDateToString(empDate.plusMonths(11).minusDays(1), "yyyy.MM.dd"));
            list.add(dto);

        } else if (WtmMonthlyLeaveCreateTypeU1Y.DIVIDED_DAYS.equals(this.wtmLeaveCreOption.getMonthlyCreTypeU1y())) {
            // 회계일 기준 분할

            if (this.wtmLeaveCreOption.isEmptyFinDate())
                throw new HrException("회계일을 입력해주세요.");

            // 입사일 이후 첫 번째 회계일자
            WtmLeaveCreEmployee employee = new WtmLeaveCreEmployee("", "", "", DateUtil.convertLocalDateToString(empDate));
            LocalDate finDate = employee.getFirstFinDateAfterEmpDate(this.wtmLeaveCreOption.getFinDateMonth(), this.wtmLeaveCreOption.getFinDateDay());


            // 생성기준종료일. 입사일 이후 첫 번째 회계일자보다 작으면서 입사일과 동일한 날짜인 일자를 구해야 한다.
            LocalDate endDate = (finDate.getDayOfMonth() <= empDate.getDayOfMonth()) ? finDate.minusMonths(1).withDayOfMonth(empDate.getDayOfMonth()) : finDate.withDayOfMonth(empDate.getDayOfMonth());

            WtmLeaveCreSimulationDTO dto1 = new WtmLeaveCreSimulationDTO();
            dto1.setYmd(empDate);
            dto1.setTerm("입사일");
            long creCnt = empDate.until(endDate, ChronoUnit.MONTHS);
            dto1.setMonthlyLeave(String.valueOf(creCnt));
            dto1.setAnnualLeave("-");
            dto1.setReasonText("입사일자 ~ 첫 번째 회계일자");
            dto1.setReasonPeriod(DateUtil.convertLocalDateToString(empDate, "yyyy.MM.dd") + " ~ " + DateUtil.convertLocalDateToString(endDate.minusDays(1), "yyyy.MM.dd"));
            list.add(dto1);

            // 첫 번째 회계일일 경우 지급 케이스. 이미 생성된 연차가 11개인 경우 더이상 생성할 입사일자 연차는 없다.
            if (creCnt != 11) {
                WtmLeaveCreSimulationDTO dto2 = new WtmLeaveCreSimulationDTO();
                dto2.setYmd(finDate);
                dto2.setTerm("회계일");
                dto2.setMonthlyLeave(String.valueOf(11 - creCnt));
                dto2.setAnnualLeave("-");
                dto2.setReasonText("첫 번째 회계일자 ~ 입사일로부터 1년");
                dto2.setReasonPeriod(DateUtil.convertLocalDateToString(endDate, "yyyy.MM.dd") + " ~ " + DateUtil.convertLocalDateToString(empDate.plusMonths(11).minusDays(1), "yyyy.MM.dd"));
                list.add(dto2);
            }

        } else {
            throw new HrException("일치하는 1년미만 대상자의 월차 생성기준이 없습니다. 정확한 생성기준을 확인해주세요.");
        }

        Log.DebugEnd();
        return list;
    }

    /**
     * 입사 1년 미만자의 연차 조회 (회계일 기준 연차 지급일 경우에만)
     * @param empDate 입사일자
     * @return 계산된 1년 미만 대상자의 연차 데이터
     * @throws Exception
     */
    public List<WtmLeaveCreSimulationDTO> getAnnualLeavesWithinOneYear(LocalDate empDate) throws Exception {
        Log.DebugStart();

        List<WtmLeaveCreSimulationDTO> list = new ArrayList<>();

        // 회계일 기준이 아닐 경우 지급할 필요가 없다.
        if (!WtmAnnualLeaveCreateType.FINANCIAL_DATE.equals(this.wtmLeaveCreOption.getAnnualCreType())) return list;

        if (this.wtmLeaveCreOption.isEmptyFinDate())
            throw new HrException("회계일을 입력해주세요.");

        // 입사일 이후 첫 번째 회계일자
        WtmLeaveCreEmployee employee = new WtmLeaveCreEmployee("", "", "", DateUtil.convertLocalDateToString(empDate));
        LocalDate finDate = employee.getFirstFinDateAfterEmpDate(this.wtmLeaveCreOption.getFinDateMonth(), this.wtmLeaveCreOption.getFinDateDay());


        // 사용기간 계산. 시작일자는 받은 날짜부터 종료일자는
        // 입사후 1년 미만 대상자 1년 개근시 연차 부여기준(A: 첫 회계일에 근무일수 대비 연차 부여, B: 첫 회계일에 15일 부여, C: 입사일에 첫 회계일까지 근무일수 대비 연차 선부여)
        if (WtmAnnualLeaveCreateTypeU1Y.CALCED_DAYS_AT_FIN_DATE.equals(this.wtmLeaveCreOption.getAnnualCreTypeU1y())) {
            // 첫 회계일에 근무일수 대비 연차 부여

            // 입사일 이후 첫 번째 회계일자 전까지 재직일자 조회.
            long empDaysOfYear = empDate.until(finDate.minusDays(1), ChronoUnit.DAYS);
            // 회계일자 속한 년도의 총 일수 조회.
            long totDaysOfYear = ("A".equals(this.wtmLeaveCreOption.getTotDaysType()) ? 365: finDate.minusYears(1).until(finDate.minusDays(1), ChronoUnit.DAYS));

            WtmLeaveCreSimulationDTO dto = new WtmLeaveCreSimulationDTO();
            dto.setYmd(finDate);
            dto.setTerm("1년차");
            dto.setMonthlyLeave("-");
            // 생성연차수: 입사년 재직일 / 총 일수
            String creCnt = String.valueOf(WtmUtils.getUpDownUnitValue(this.wtmLeaveCreOption.getUpbaseU1y(), this.wtmLeaveCreOption.getUnitU1y(), (double) empDaysOfYear /totDaysOfYear * 15));
            dto.setAnnualLeave(creCnt);
            dto.setReasonText("근무일수대비 연차생성");
            dto.setReasonPeriod(empDate.getYear() + "년 재직일 " + empDaysOfYear + "일 / 1년 총 일수 " + totDaysOfYear + "일 * 15 ≒ " + creCnt);
            list.add(dto);

        } else if (WtmAnnualLeaveCreateTypeU1Y.FIFTEEN_DAYS_AT_FIN_DATE.equals(this.wtmLeaveCreOption.getAnnualCreTypeU1y())) {
            // 첫 회계일에 15일 부여

            WtmLeaveCreSimulationDTO dto = new WtmLeaveCreSimulationDTO();
            dto.setYmd(finDate);
            dto.setTerm("1년차");
            dto.setMonthlyLeave("-");
            // 생성연차수: 15
            dto.setAnnualLeave("15");
            dto.setReasonText("입사일 이후 첫 회계일에 15일 부여");
            dto.setReasonPeriod("");
            list.add(dto);

        } else if (WtmAnnualLeaveCreateTypeU1Y.GET_LEAVE_DAYS_AT_JOIN.equals(this.wtmLeaveCreOption.getAnnualCreTypeU1y())) {
            // 입사일에 첫 회계일까지 근무기간 대비 연차 선부여

            // 입사일 이후 첫 번째 회계일자 전까지 재직일자 조회.
            long empDaysOfYear = empDate.until(finDate.minusDays(1), ChronoUnit.DAYS);
            // 회계일자 속한 년도의 총 일수 조회.
            long totDaysOfYear = ("A".equals(this.wtmLeaveCreOption.getTotDaysType()) ? 365: finDate.minusYears(1).until(finDate.minusDays(1), ChronoUnit.DAYS));

            WtmLeaveCreSimulationDTO dto = new WtmLeaveCreSimulationDTO();
            dto.setYmd(empDate);
            dto.setTerm("입사일");
            dto.setMonthlyLeave("-");
            // 생성연차수: 입사년 재직일 / 총 일수
            String creCnt = String.valueOf(WtmUtils.getUpDownUnitValue(this.wtmLeaveCreOption.getUpbaseU1y(), this.wtmLeaveCreOption.getUnitU1y(), (double) empDaysOfYear /totDaysOfYear * 15));
            dto.setAnnualLeave(creCnt);
            dto.setReasonText("근무일수대비 연차생성");
            dto.setReasonPeriod(empDate.getYear() + "년 재직예정일 " + empDaysOfYear + "일 / 1년 총 일수 " + totDaysOfYear + "일 * 15 ≒ " + creCnt);
            list.add(dto);

        } else {
            throw new HrException("일치하는 1년미만 대상자의 1년 개근 연차 생성기준이 없습니다. 정확한 생성기준을 확인해주세요.");
        }

        Log.DebugEnd();
        return list;
    }

    /**
     * 입사 1년 이후 대상자의 연차 생성
     * @param empDate 입사일자
     * @return 연차 데이터
     * @throws Exception
     */
    public List<WtmLeaveCreSimulationDTO> getAnnualLeaves(LocalDate empDate) throws Exception {
        Log.DebugStart();

        List<WtmLeaveCreSimulationDTO> list = new ArrayList<>();

        // 일단 24년간 데이터 생성
        for (int i = 1 ; i <= ANNUAL_LEAVE_CRE_YEAR_CNT ; i++) {

            String yearCnt = (i + 1) + "년차";

            // 사용기간 계산. 시작일자는 받은 날짜부터 종료일자는
            // 연차생성기준(A: 입사일, B: 회계일, C: 입사월)
            if (WtmAnnualLeaveCreateType.EMPLOYEE_DATE.equals(this.wtmLeaveCreOption.getAnnualCreType())) {
                // 입사일 기준 연차 생성

                WtmLeaveCreSimulationDTO dto = new WtmLeaveCreSimulationDTO();
                dto.setYmd(empDate.plusYears(i));
                dto.setTerm(yearCnt);
                dto.setMonthlyLeave("-");
                // 생성연차수: 15 + 근속년수에 따른 가산연차
                long creCnt = 15 + (empDate.until(empDate.plusYears(i), ChronoUnit.YEARS) - 1) / 2;
                if (creCnt > MAX_ANNUAL_LEAVE_CNT) {
                    dto.setAnnualLeave(String.valueOf(MAX_ANNUAL_LEAVE_CNT));
                    dto.setReasonText("입사 " + yearCnt + "의 입사일 기준 연차");
                    dto.setReasonPeriod("15 + (" + (i+1) + " - 1) / 2 = " + MAX_ANNUAL_LEAVE_CNT);
                } else {
                    dto.setAnnualLeave(String.valueOf(creCnt));
                    dto.setReasonText("입사 " + yearCnt + "의 입사일 기준 연차");
                    dto.setReasonPeriod("15 + (" + (i+1) + " - 1) / 2 = " + creCnt);
                }
                list.add(dto);

            } else if (WtmAnnualLeaveCreateType.FINANCIAL_DATE.equals(this.wtmLeaveCreOption.getAnnualCreType())) {
                // 회계일 기준 연차 생성

                if (this.wtmLeaveCreOption.isEmptyFinDate())
                    throw new HrException("회계일을 입력해주세요.");

                // 입사일 이후 첫 번째 회계일자
                WtmLeaveCreEmployee employee = new WtmLeaveCreEmployee("", "", "", DateUtil.convertLocalDateToString(empDate));
                LocalDate finDate = employee.getFirstFinDateAfterEmpDate(this.wtmLeaveCreOption.getFinDateMonth(), this.wtmLeaveCreOption.getFinDateDay());
                double workCnt = employee.getWorkCnt(finDate.plusYears(i), this.wtmLeaveCreOption.getUpbase(), this.wtmLeaveCreOption.getUnit(), this.wtmLeaveCreOption.getTotDaysType());

                WtmLeaveCreSimulationDTO dto = new WtmLeaveCreSimulationDTO();
                dto.setYmd(finDate.plusYears(i));
                dto.setTerm(yearCnt + "(근속년차: " + workCnt + ")");
                dto.setMonthlyLeave("-");
                // 생성연차수: 15 + 근속년수에 따른 가산연차
                long creCnt = 15 + ((long) Math.floor(workCnt) - 1) / 2;
                if (creCnt > MAX_ANNUAL_LEAVE_CNT) {
                    dto.setAnnualLeave(String.valueOf(MAX_ANNUAL_LEAVE_CNT));
                    dto.setReasonText("입사 " + yearCnt + "의 회계일 기준 연차");
                    dto.setReasonPeriod("15 + (" + ((long) Math.floor(workCnt)) + " - 1) / 2 = " + MAX_ANNUAL_LEAVE_CNT);
                } else {
                    dto.setAnnualLeave(String.valueOf(creCnt));
                    dto.setReasonText("입사 " + yearCnt + "의 회계일 기준 연차");
                    dto.setReasonPeriod("15 + (" + ((long) Math.floor(workCnt)) + " - 1) / 2 = " + creCnt);
                }
                list.add(dto);

            } else if (WtmAnnualLeaveCreateType.EMPLOYEE_MONTH.equals(this.wtmLeaveCreOption.getAnnualCreType())) {
                // 입사월 기준 연차 생성

                WtmLeaveCreSimulationDTO dto = new WtmLeaveCreSimulationDTO();
                dto.setYmd(empDate.plusYears(i).withDayOfMonth(1));
                dto.setTerm(yearCnt);
                dto.setMonthlyLeave("-");
                // 생성연차수: 15 + 근속년수에 따른 가산연차
                long creCnt = 15 + (empDate.until(empDate.plusYears(i), ChronoUnit.YEARS) - 1) / 2;
                if (creCnt > MAX_ANNUAL_LEAVE_CNT) {
                    dto.setAnnualLeave(String.valueOf(MAX_ANNUAL_LEAVE_CNT));
                    dto.setReasonText("입사 " + yearCnt + "의 입사월 기준 연차");
                    dto.setReasonPeriod("15 + (" + (i + 1) + " - 1) / 2 = " + MAX_ANNUAL_LEAVE_CNT);
                } else {
                    dto.setAnnualLeave(String.valueOf(creCnt));
                    dto.setReasonText("입사 " + yearCnt + "의 입사월 기준 연차");
                    dto.setReasonPeriod("15 + (" + (i + 1) + " - 1) / 2 = " + creCnt);
                }
                list.add(dto);

            } else {
                throw new HrException("일치하는 연차생성기준이 없습니다. 정확한 생성기준을 확인해주세요.");
            }
        }

        Log.DebugEnd();
        return list;
    }
}
