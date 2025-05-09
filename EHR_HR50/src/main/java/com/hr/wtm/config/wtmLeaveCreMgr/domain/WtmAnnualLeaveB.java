package com.hr.wtm.config.wtmLeaveCreMgr.domain;

import com.hr.common.util.DateUtil;
import com.hr.wtm.domain.WtmUtils;

import java.time.LocalDate;

/**
 * 입사 후 1년 지난 대상자의 연차 부여 로직<br>
 * @지급기준 회계일 기준 연차 생성 케이스
 * @지급여부판단 기준일자의 월일이 회계일자의 월일과 동일한 경우 대상.
 * @생성기준 직전년도 회계일자 ~ 현재년도 회계일자 -1일 까지 개근으로 인한 생성.
 * @사용기간 현재년도 회계일자부터 1년 동안 사용가능.
 * @생성개수 입사년차에 따른 휴가수 계산
 */
public class WtmAnnualLeaveB implements WtmLeaveCreLogic, WtmAnnualLeaveCreLogic {

    private final LocalDate empDate;
    private final LocalDate stdDate;
    private final LocalDate finDate;
    private double workCnt;

    public WtmAnnualLeaveB(LocalDate empDate, LocalDate stdDate, LocalDate finDate) {
        this.empDate = empDate;
        this.stdDate = stdDate;
        this.finDate = finDate;
    }

    public void setWorkCnt(double workCnt) {
        this.workCnt = workCnt;
    }

    @Override
    public boolean isTarget() {
        return finDate.getMonthValue() == stdDate.getMonthValue() && finDate.getDayOfMonth() == stdDate.getDayOfMonth();
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
        double restLeaveCnt = WtmUtils.MAX_ANNUAL_LEAVE_CNT - getCreAnnualCnt();
        return Math.min(restLeaveCnt, Math.floor((this.workCnt - 1) / 2));
    }
}
