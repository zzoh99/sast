package com.hr.wtm.config.wtmLeaveCreStd;

import com.hr.common.exception.HrException;
import com.hr.common.util.StringUtil;
import com.hr.wtm.domain.WtmAnnualLeaveCreateType;
import com.hr.wtm.domain.WtmAnnualLeaveCreateTypeU1Y;
import com.hr.wtm.domain.WtmMonthlyLeaveCreateTypeU1Y;

import java.util.Map;

public class WtmLeaveCreOption {

    private final String enterCd; // 회사코드
    private final String gntCd; // 근태코드
    private final String searchSeq; // 대상자조건검색
    private final WtmAnnualLeaveCreateType annualCreType; // 연차생성기준
    private final String annualCreJoinType; // 연차생성시 입사일기준(G: 그룹입사일, E: 입사일)
    private final String finDateMonth; // 회계일자_월
    private final String finDateDay; // 회계일자_일
    private final String totDaysType; // 당해년도 총일수(A: 365일, B: 당해총일수)
    private final String rewardType; // 잔여연차 처리방법(A: 이월, B: 보상, C: 소멸)
    private final String noCheckWorkRateYn; // 연차계산 시 근무율 80% 미만도 정상 부여할지 여부

    private final String autoCreU1yYn; // 입사후 1년 미만 대상자 연월차 자동생성 여부(Y/N)
    private final WtmMonthlyLeaveCreateTypeU1Y monthlyCreTypeU1y; // 입사후 1년 미만 대상자 월차 생성기준
    private final boolean isStartAtEmpYmdU1y; // 입사후 1년 미만 월차의 사용시작일이 입사일부터인지 여부
    private final WtmAnnualLeaveCreateTypeU1Y annualCreTypeU1y; // 입사후 1년 미만 대상자 1년 개근시 연차 부여기준
    private final String rewardTypeU1y; // 입사후 1년 미만 대상자 잔여연차 처리방법(A: 이월, B: 보상, C: 소멸)

    private final String upbaseU1y; // 입사후 1년 미만 대상자 연차 계산시 절상기준(N: 사용안함, C: 절상, R: 반올림)
    private final String unitU1y; // 입사후 1년 미만 대상자 연차 계산시 절상단위
    private final String upbase; // 근속년수 올림기준(N: 사용안함, C: 절상, R: 반올림)
    private final String unit; // 근속년수 단위자리수

    public WtmLeaveCreOption(String enterCd, String gntCd, String searchSeq, WtmAnnualLeaveCreateType annualCreType, String annualCreJoinType
            , String finDateMonth, String finDateDay, String totDaysType, String rewardType, String noCheckWorkRateYn
            , String autoCreU1yYn, WtmMonthlyLeaveCreateTypeU1Y monthlyCreTypeU1y, boolean isStartAtEmpYmdU1y, WtmAnnualLeaveCreateTypeU1Y annualCreTypeU1y, String rewardTypeU1y
            , String upbaseU1y, String unitU1y, String upbase, String unit) {
        this.enterCd = enterCd;
        this.gntCd = gntCd;
        this.searchSeq = searchSeq;
        this.annualCreType = annualCreType;
        this.annualCreJoinType = annualCreJoinType;
        this.finDateMonth = finDateMonth;
        this.finDateDay = finDateDay;
        this.totDaysType = totDaysType;
        this.rewardType = rewardType;
        this.noCheckWorkRateYn = noCheckWorkRateYn;
        this.autoCreU1yYn = autoCreU1yYn;
        this.monthlyCreTypeU1y = monthlyCreTypeU1y;
        this.isStartAtEmpYmdU1y = isStartAtEmpYmdU1y;
        this.annualCreTypeU1y = annualCreTypeU1y;
        this.rewardTypeU1y = rewardTypeU1y;
        this.upbaseU1y = upbaseU1y;
        this.unitU1y = unitU1y;
        this.upbase = upbase;
        this.unit = unit;
    }

    public WtmLeaveCreOption(Map<String, Object> optionMap) throws HrException {
        this.enterCd = StringUtil.stringValueOf(optionMap.get("enterCd"));
        this.gntCd = StringUtil.stringValueOf(optionMap.get("gntCd"));
        this.searchSeq = StringUtil.stringValueOf(optionMap.get("searchSeq"));
        this.annualCreType = WtmAnnualLeaveCreateType.findByCode(StringUtil.stringValueOf(optionMap.get("annualCreType")));
        this.annualCreJoinType = StringUtil.stringValueOf(optionMap.get("annualCreJoinType"));
        this.finDateMonth = StringUtil.stringValueOf(optionMap.get("finDateMonth"));
        this.finDateDay = StringUtil.stringValueOf(optionMap.get("finDateDay"));
        this.totDaysType = StringUtil.stringValueOf(optionMap.get("totDaysType"));
        this.rewardType = StringUtil.stringValueOf(optionMap.get("rewardType"));
        this.noCheckWorkRateYn = StringUtil.stringValueOf(optionMap.get("noCheckWorkRateYn"));
        this.autoCreU1yYn = StringUtil.stringValueOf(optionMap.get("autoCreU1yYn"));
        this.monthlyCreTypeU1y = WtmMonthlyLeaveCreateTypeU1Y.findByCode(StringUtil.stringValueOf(optionMap.get("monthlyCreTypeU1y")));
        this.isStartAtEmpYmdU1y = "Y".equals(StringUtil.stringValueOf(optionMap.get("startAtEmpYmdU1y")));
        this.annualCreTypeU1y = WtmAnnualLeaveCreateTypeU1Y.findByCode(StringUtil.stringValueOf(optionMap.get("annualCreTypeU1y")));
        this.rewardTypeU1y = StringUtil.stringValueOf(optionMap.get("rewardTypeU1y"));
        this.upbaseU1y = StringUtil.stringValueOf(optionMap.get("upbaseU1y"));
        this.unitU1y = StringUtil.stringValueOf(optionMap.get("unitU1y"));
        this.upbase = StringUtil.stringValueOf(optionMap.get("upbase"));
        this.unit = StringUtil.stringValueOf(optionMap.get("unit"));
    }

    public String getEnterCd() {
        return enterCd;
    }

    public String getGntCd() {
        return gntCd;
    }

    public String getSearchSeq() {
        return searchSeq;
    }

    public WtmAnnualLeaveCreateType getAnnualCreType() {
        return annualCreType;
    }

    public String getAnnualCreJoinType() {
        return annualCreJoinType;
    }

    public String getFinDateMonth() {
        return finDateMonth;
    }

    public String getFinDateDay() {
        return finDateDay;
    }

    public String getTotDaysType() {
        return totDaysType;
    }

    public String getRewardType() {
        return rewardType;
    }

    public String getNoCheckWorkRateYn() {
        return noCheckWorkRateYn;
    }

    public String getAutoCreU1yYn() {
        return autoCreU1yYn;
    }

    public WtmMonthlyLeaveCreateTypeU1Y getMonthlyCreTypeU1y() {
        return monthlyCreTypeU1y;
    }

    public boolean isStartAtEmpYmdU1y() {
        return isStartAtEmpYmdU1y;
    }

    public WtmAnnualLeaveCreateTypeU1Y getAnnualCreTypeU1y() {
        return annualCreTypeU1y;
    }

    public String getRewardTypeU1y() {
        return rewardTypeU1y;
    }

    public String getUpbaseU1y() {
        return upbaseU1y;
    }

    public String getUnitU1y() {
        return unitU1y;
    }

    public String getUpbase() {
        return upbase;
    }

    public String getUnit() {
        return unit;
    }

    /**
     * 회계일자가 비어있는지 여부
     * @return boolean
     */
    public boolean isEmptyFinDate() {
        return (this.finDateMonth == null || this.finDateDay == null);
    }
}
