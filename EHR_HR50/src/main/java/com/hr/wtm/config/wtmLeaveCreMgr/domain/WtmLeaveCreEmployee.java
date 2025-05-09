package com.hr.wtm.config.wtmLeaveCreMgr.domain;

import com.hr.common.util.DateUtil;
import com.hr.wtm.domain.WtmUtils;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class WtmLeaveCreEmployee {

    private final String enterCd;
    private final String sabun;
    private final String name;
    private final String empYmd;
    private String leaveIdWithinOneYear = "";

    public WtmLeaveCreEmployee(String enterCd, String sabun, String name, String empYmd) {
        this.enterCd = enterCd;
        this.sabun = sabun;
        this.name = name;
        this.empYmd = empYmd;
    }

    public String getEnterCd() {
        return enterCd;
    }

    public String getSabun() {
        return sabun;
    }

    public String getEmpYmd() {
        return empYmd;
    }

    public LocalDate getEmpDate() {
        return DateUtil.getLocalDate(this.empYmd);
    }

    public String getName() {
        return name;
    }

    public String getLeaveIdWithinOneYear() {
        return leaveIdWithinOneYear;
    }

    public void setLeaveIdWithinOneYear(String leaveIdWithinOneYear) {
        this.leaveIdWithinOneYear = (leaveIdWithinOneYear == null ? "" : leaveIdWithinOneYear);
    }

    /**
     * 1년 내 입사자 여부
     * @param stdDate 기준일자
     * @return 1년 내 입사자 여부
     */
    public boolean isHiredWithinOneYear(LocalDate stdDate) {
        return stdDate.isBefore(getEmpDate().plusYears(1));
    }

    /**
     * 유효하지 않은 대상자 여부
     * @return 유효하지 않은 대상자 여부
     */
    public boolean isInvalidEmployee() {
        return (this.enterCd.isEmpty() || this.sabun.isEmpty() || this.empYmd.isEmpty());
    }

    /**
     * 근속년차 계산
     * @param stdDate 기준일자
     * @return 근속년차
     */
    public int getWorkYearCnt(LocalDate stdDate) {
        return (int) getEmpDate().until(stdDate, ChronoUnit.YEARS);
    }

    /**
     * 근속년수 계산
     * @param stdDate 기준일자
     * @return 근속년수
     */
    public double getWorkCnt(LocalDate stdDate, String upbase, String unit, String totDaysType) {
        // 근속년수
        long workYearCnt = getEmpDate().until(stdDate, ChronoUnit.YEARS);

        // 근속월수
        double workMonthCnt = WtmUtils.getUpDownUnitValue(upbase, unit,
                (double) getEmpDate().plusYears(workYearCnt).until(stdDate.minusDays(1), ChronoUnit.DAYS)
                        / ("A".equals(totDaysType) ? 365 : stdDate.minusYears(1).until(stdDate.minusDays(1), ChronoUnit.DAYS)));

        return workYearCnt + workMonthCnt;
    }

    /**
     * 입사일 이후 첫 번째 회계일자 조회
     * @param finDateMonth 회계일자 중 월
     * @param finDateDay 회계일자 중 일
     * @return 회계일자
     */
    public LocalDate getFirstFinDateAfterEmpDate(String finDateMonth, String finDateDay) {
        LocalDate empDate = getEmpDate();

        // 입사일 이후 첫 번째 회계일자
        LocalDate finDate = empDate.withMonth(Integer.parseInt(finDateMonth)).withDayOfMonth(Integer.parseInt(finDateDay));
        if (!finDate.isAfter(empDate))
            finDate = finDate.plusYears(1);

        return finDate;
    }

    @Override
    public String toString() {
        return "{ \"enterCd\": \"" + this.enterCd + "\", \"sabun\": \"" + this.sabun + "\", \"name\": \"" + this.name + "\", \"empYmd\": \"" + this.empYmd + "\" }";
    }
}
