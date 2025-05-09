package com.hr.wtm.config.wtmLeaveCreMgr.domain;

import com.hr.common.util.DateUtil;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * 입사 후 1년 미만 대상자의 월차 부여 로직<br>
 * @지급기준 회계일 기준 분할 케이스면서 생성일자가 입사일일 경우
 * @지급여부판단 생성일자가 입사일일 때 지급
 * @생성기준 입사일자 + 1개월 ~ 회계일 직전 입사일자가 동일한 일자 까지 개근으로 인한 생성.
 * @사용기간 입사일자 ~ 입사일자 1년 후 1일 전까지 사용 가능
 * @생성개수 입사일자 ~ 생성기준종료일까지로 발생하는 개수 계산하여 적용
 */
public class WtmMonthlyLeaveWithinOneYearC1 implements WtmLeaveCreLogic, WtmMonthlyLeaveWithinOneYearCreLogic {

    private final LocalDate empDate;
    private final LocalDate stdDate;
    private final LocalDate endDate;

    public WtmMonthlyLeaveWithinOneYearC1(LocalDate empDate, LocalDate stdDate, LocalDate finDate) {
        this.empDate = empDate;
        this.stdDate = stdDate;

        // 생성기준일: 입사일자 + 1개월 ~ 회계일 직전 입사일자가 동일한 일자 까지 개근으로 인한 생성.
        this.endDate = (finDate.getDayOfMonth() <= empDate.getDayOfMonth()) ? finDate.minusMonths(1).withDayOfMonth(empDate.getDayOfMonth()) : finDate.withDayOfMonth(empDate.getDayOfMonth());
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
        return DateUtil.convertLocalDateToString(this.endDate.minusDays(1));
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
        return Math.toIntExact(this.empDate.until(this.endDate, ChronoUnit.MONTHS));
    }
}
