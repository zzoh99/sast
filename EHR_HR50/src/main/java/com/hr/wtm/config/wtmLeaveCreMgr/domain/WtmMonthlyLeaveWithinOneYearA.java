package com.hr.wtm.config.wtmLeaveCreMgr.domain;

import com.hr.common.util.DateUtil;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.temporal.ChronoUnit;

/**
 * 입사 후 1년 미만 대상자의 월차 부여 로직<br>
 * @지급기준 매월 개근에 따라 1일 부여 케이스
 * @지급여부판단 생성일자가 입사일 보다 크고, 입사일의 일자와 생성일자의 일자가 동일한 경우 지급.
 * @생성기준 생성일자 1달전 ~ 생성일자 1일 전까지 개근으로 인한 생성.
 * @사용기간 생성일자 ~ 입사일 1일 전까지 사용 가능
 * @생성개수 1개
 */
public class WtmMonthlyLeaveWithinOneYearA implements WtmLeaveCreLogic, WtmMonthlyLeaveWithinOneYearCreLogic {

    private final LocalDate empDate;
    private final LocalDate stdDate;
    private boolean isStartAtEmpYmd = true; // 매월 생성되는 월차를 하나로 통합할지 여부. 기본값은 통합.

    public WtmMonthlyLeaveWithinOneYearA(LocalDate empDate, LocalDate stdDate) {
        this.empDate = empDate;
        this.stdDate = stdDate;
    }

    public void setStartAtEmpYmd(boolean startAtEmpYmd) {
        isStartAtEmpYmd = startAtEmpYmd;
    }

    /**
     * 생성일자가 입사일 이후여야 하며,
     * 입사일자의 일과 생성일자의 일이 동일하거나 -> 입사일: 2024-02-28, 생성일: 2024-03-28
     * 입사월의 마지막 일자가 생성월의 마지막 일자보다 크고 생성일자가 생성월의 마지막 일자인 경우 -> 입사일: 2024-01-31, 생성일: 2024-02-29
     * @return
     */
    @Override
    public boolean isTarget() {
        return this.stdDate.isAfter(this.empDate)
                && ( this.empDate.getDayOfMonth() == this.stdDate.getDayOfMonth()
                        || ( getEndOfMonthFromEmpDate().getDayOfMonth() > getEndOfMonthFromStdDate().getDayOfMonth() && this.stdDate.isEqual(getEndOfMonthFromStdDate()) ) );
    }

    @Override
    public String getGntSYmd() {
        if (isStartAtEmpYmd) {
            return DateUtil.convertLocalDateToString(this.empDate);
        } else {
            return DateUtil.convertLocalDateToString(this.stdDate.minusMonths(1));
        }
    }

    @Override
    public String getGntEYmd() {
        return DateUtil.convertLocalDateToString(this.stdDate.minusDays(1));
    }

    @Override
    public String getUseSYmd() {
        if (isStartAtEmpYmd) {
            return DateUtil.convertLocalDateToString(this.empDate.plusMonths(1));
        } else {
            return DateUtil.convertLocalDateToString(this.stdDate);
        }
    }

    @Override
    public String getUseEYmd() {
        return DateUtil.convertLocalDateToString(this.empDate.plusYears(1).minusDays(1));
    }

    /**
     * 입사 후 1년 미만 대상자의 월차 개수 조회
     * 통합할 경우 입사일자부터 생성일자까지의 기간 동안의 총 근무 월 수로 계산한다.
     * 통합하지 않을 경우 월 별 1개만 생성된다.
     * @return
     */
    @Override
    public Integer getMonthlyWithinOneYearCnt() {
        if (isStartAtEmpYmd) {
            LocalDate tmpDate = this.empDate;
            if ( getEndOfMonthFromEmpDate().getDayOfMonth() > getEndOfMonthFromStdDate().getDayOfMonth()
                    && this.stdDate.isEqual(getEndOfMonthFromStdDate()) ) {
                // 입사월의 마지막 일자가 생성월의 마지막 일자보다 크고 생성일자가 생성월의 마지막 일자인 경우 -> 입사일: 2023-12-31, 생성일: 2024-02-29 => 2개가 발생해야 함.
                // 입사일의 일자를 생성일자의 일자로 대체. -> 대체일: 2024-01-29, 생성일: 2024-02-29

                tmpDate = this.empDate.withDayOfMonth(this.stdDate.getDayOfMonth());
            }
            return Math.toIntExact(ChronoUnit.MONTHS.between(tmpDate, this.stdDate));
        } else {
            return 1;
        }
    }

    private LocalDate getEndOfMonthFromEmpDate() {
        return YearMonth.from(this.empDate).atEndOfMonth();
    }

    private LocalDate getEndOfMonthFromStdDate() {
        return YearMonth.from(this.stdDate).atEndOfMonth();
    }
}
