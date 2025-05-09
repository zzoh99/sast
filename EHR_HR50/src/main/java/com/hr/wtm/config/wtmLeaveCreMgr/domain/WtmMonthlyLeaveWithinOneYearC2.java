package com.hr.wtm.config.wtmLeaveCreMgr.domain;

import com.hr.common.util.DateUtil;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * 입사 후 1년 미만 대상자의 월차 부여 로직<br>
 * @지급기준 회계일 기준 분할 케이스면서 생성일자가 첫 번째 회계일일 경우
 * @지급여부판단 생성일자가 첫 번째 회계일과 동일할 경우 지급
 * @생성기준 회계일 직전 입사일자가 동일한 일자 ~ 입사일 + 1년 까지 개근으로 인한 생성.
 * @사용기간 회계일 ~ 입사일자 1년 후 1일 전까지 사용 가능
 * @생성개수 생성기준시작일 ~ 생성기준종료일까지로 발생하는 개수 계산하여 적용
 */
public class WtmMonthlyLeaveWithinOneYearC2 implements WtmLeaveCreLogic, WtmMonthlyLeaveWithinOneYearCreLogic {

    private final LocalDate empDate;
    private final LocalDate stdDate;
    private final LocalDate finDate;
    private final LocalDate startDate;
    private final LocalDate endDate;

    public WtmMonthlyLeaveWithinOneYearC2(LocalDate empDate, LocalDate stdDate, LocalDate finDate) {
        this.empDate = empDate;
        this.stdDate = stdDate;
        this.finDate = finDate;

        // 생성기준일: 회계일 직전 입사일자가 동일한 일자 ~ 입사일 + 1년 까지 개근으로 인한 생성.
        // 생성기준시작일: 회계일 직전 입사일자가 동일한 일자.
        this.startDate = (finDate.getDayOfMonth() <= empDate.getDayOfMonth()) ? finDate.minusMonths(1).withDayOfMonth(empDate.getDayOfMonth()) : finDate.withDayOfMonth(empDate.getDayOfMonth());
        // 생성기준종료일: 입사일 + 11개월.
        this.endDate = empDate.plusYears(1).minusMonths(1);
    }

    @Override
    public boolean isTarget() {
        return this.finDate.isEqual(this.stdDate);
    }

    @Override
    public String getGntSYmd() {
        return DateUtil.convertLocalDateToString(this.startDate);
    }

    @Override
    public String getGntEYmd() {
        return DateUtil.convertLocalDateToString(this.endDate.minusDays(1));
    }

    @Override
    public String getUseSYmd() {
        return DateUtil.convertLocalDateToString(this.finDate);
    }

    @Override
    public String getUseEYmd() {
        return DateUtil.convertLocalDateToString(this.empDate.plusYears(1).minusDays(1));
    }

    @Override
    public Integer getMonthlyWithinOneYearCnt() {
        return Math.toIntExact(this.startDate.until(endDate, ChronoUnit.MONTHS));
    }
}
