package com.hr.wtm.config.wtmLeaveCreMgr.domain;

import com.hr.common.util.DateUtil;
import com.hr.wtm.domain.WtmUtils;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * 입사 후 1년 지난 대상자의 연차 부여 로직<br>
 * @지급기준 입사일 기준 연차 부여 케이스
 * @지급여부판단 생성일자의 월일이 입사일의 월일과 동일하거나 입사일이 해당년월의 마지막 일자이고 생성일자의 월일이 해당 월의 마지막 일자인 경우 지급.
 * @생성기준 직전년도 입사일자의 월일이 동일한 날짜 ~ 현재년도 입사일자의 월일이 동일한 날짜 -1일 까지 개근으로 인한 생성.
 * @사용기간 현재년도 입사일자의 월일이 동일한 날짜 ~ 내년도 입사일자의 월일이 동일한 날짜 -1 까지 사용 가능.
 * @생성개수 입사년차에 따른 휴가수 계산
 */
public class WtmAnnualLeaveA implements WtmLeaveCreLogic, WtmAnnualLeaveCreLogic {

    private final LocalDate empDate;
    private final LocalDate stdDate;

    public WtmAnnualLeaveA(LocalDate empDate, LocalDate stdDate) {
        this.empDate = empDate;
        this.stdDate = stdDate;
    }

    @Override
    public boolean isTarget() {
        // 입사일자 년월의 마지막 일자
        LocalDate empLastDayOfMonth = this.empDate.withDayOfMonth(this.empDate.lengthOfMonth());
        // 생성일자 년월의 마지막 일자
        LocalDate stdLastDayOfMonth = this.stdDate.withDayOfMonth(this.stdDate.lengthOfMonth());
        return (
                (this.stdDate.getMonth() == this.empDate.getMonth() && this.stdDate.getDayOfMonth() == this.empDate.getDayOfMonth())
                ||
                (this.empDate.isEqual(empLastDayOfMonth) && this.stdDate.isEqual(stdLastDayOfMonth))
        );
    }

    @Override
    public String getGntSYmd() {
        return DateUtil.convertLocalDateToString(this.stdDate.minusYears(1));
    }

    @Override
    public String getGntEYmd() {
        return DateUtil.convertLocalDateToString(this.stdDate.minusDays(1));
    }

    @Override
    public String getUseSYmd() {
        return DateUtil.convertLocalDateToString(this.stdDate);
    }

    @Override
    public String getUseEYmd() {
        return DateUtil.convertLocalDateToString(this.stdDate.plusYears(1).minusDays(1));
    }

    @Override
    public Double getCreAnnualCnt() {
        return WtmUtils.CRE_ANNUAL_LEAVE_CNT;
    }

    @Override
    public Double getAddAnnualCnt() {
        // 최대 지급 가능 연차 개수 고려하여 가산연차 지급
        double restLeaveCnt = WtmUtils.MAX_ANNUAL_LEAVE_CNT - this.getCreAnnualCnt();
        return Math.min(restLeaveCnt, Math.floor((double) (this.empDate.until(this.stdDate, ChronoUnit.YEARS) - 1) / 2));
    }
}
