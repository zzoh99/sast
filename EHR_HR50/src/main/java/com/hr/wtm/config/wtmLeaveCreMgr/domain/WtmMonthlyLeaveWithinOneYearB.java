package com.hr.wtm.config.wtmLeaveCreMgr.domain;

import com.hr.common.util.DateUtil;

import java.time.LocalDate;

/**
 * 입사 후 1년 미만 대상자의 월차 부여 로직<br>
 * @지급기준 입사 시 11일 선 부여 케이스
 * @지급여부판단 입사일자와 생성일자가 동일할 경우 지급
 * @생성기준 입사일자 ~ 입사일자 + 11개월 까지, 11개 일괄 생성.
 * @사용기간 입사일자 ~ 입사일자 1년 후 1일 전까지 사용 가능
 * @생성개수 11개
 */
public class WtmMonthlyLeaveWithinOneYearB implements WtmLeaveCreLogic, WtmMonthlyLeaveWithinOneYearCreLogic {

    private final LocalDate empDate;
    private final LocalDate stdDate;

    public WtmMonthlyLeaveWithinOneYearB(LocalDate empDate, LocalDate stdDate) {
        this.empDate = empDate;
        this.stdDate = stdDate;
    }

    @Override
    public boolean isTarget() {
        return this.empDate.isEqual(this.stdDate);
    }

    @Override
    public String getGntSYmd() {
        return DateUtil.convertLocalDateToString(this.empDate);
    }

    @Override
    public String getGntEYmd() {
        return DateUtil.convertLocalDateToString(empDate.plusYears(1).minusMonths(1).minusDays(1));
    }

    @Override
    public String getUseSYmd() {
        return DateUtil.convertLocalDateToString(this.empDate);
    }

    @Override
    public String getUseEYmd() {
        return DateUtil.convertLocalDateToString(this.empDate.plusYears(1).minusDays(1));
    }

    @Override
    public Integer getMonthlyWithinOneYearCnt() {
        return 11;
    }
}
