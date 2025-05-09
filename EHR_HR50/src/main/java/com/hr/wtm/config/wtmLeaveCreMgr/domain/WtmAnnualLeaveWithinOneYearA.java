package com.hr.wtm.config.wtmLeaveCreMgr.domain;

import com.hr.common.util.DateUtil;
import com.hr.wtm.domain.WtmUtils;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * 입사 후 1년 미만 대상자의 1년차 개근 연차 부여 로직<br>
 * @지급기준 첫 회계일에 근무기간 대비 연차 부여 케이스
 * @지급여부판단 생성일자가 회계일인 경우 지급.
 * @생성기준 입사일자 ~ 입사일 이후 첫 번째 회계일자 1일 전까지 개근으로 인한 생성.
 * @사용기간 입사일 이후 첫 번째 회계일자 부터 1년 동안 사용 가능
 * @생성개수 입사년 재직일 / 총 일수
 */
public class WtmAnnualLeaveWithinOneYearA implements WtmLeaveCreLogic, WtmAnnualLeaveWithinOneYearCreLogic {

    private final LocalDate empDate;
    private final LocalDate stdDate;
    private final LocalDate finDate;
    private String totDaysType;
    private String upbaseU1y;
    private String unitU1y;

    public WtmAnnualLeaveWithinOneYearA(LocalDate empDate, LocalDate stdDate, LocalDate finDate) {
        this.empDate = empDate;
        this.stdDate = stdDate;
        this.finDate = finDate;
    }

    public void setTotDaysType(String totDaysType) {
        this.totDaysType = totDaysType;
    }

    public void setUpbaseU1y(String upbaseU1y) {
        this.upbaseU1y = upbaseU1y;
    }

    public void setUnitU1y(String unitU1y) {
        this.unitU1y = unitU1y;
    }

    @Override
    public boolean isTarget() {
        return this.stdDate.isEqual(this.finDate);
    }

    @Override
    public String getGntSYmd() {
        return DateUtil.convertLocalDateToString(this.empDate);
    }

    @Override
    public String getGntEYmd() {
        return DateUtil.convertLocalDateToString(this.finDate.minusDays(1));
    }

    @Override
    public String getUseSYmd() {
        return DateUtil.convertLocalDateToString(this.finDate);
    }

    @Override
    public String getUseEYmd() {
        return DateUtil.convertLocalDateToString(this.finDate.plusYears(1).minusDays(1));
    }

    @Override
    public Double getAnnualWithinOneYearCnt() {
        // 입사일 이후 첫 번째 회계일자 전까지 재직일자 조회.
        long empDaysOfYear = empDate.until(finDate.minusDays(1), ChronoUnit.DAYS);
        // 회계일자 속한 년도의 총 일수 조회.
        long totDaysOfYear = ("A".equals(this.totDaysType) ? 365: finDate.minusYears(1).until(finDate.minusDays(1), ChronoUnit.DAYS));

        return WtmUtils.getUpDownUnitValue(this.upbaseU1y, this.unitU1y, (double) empDaysOfYear /totDaysOfYear * 15);
    }
}
