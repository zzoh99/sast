package com.hr.wtm.calc.key;

import java.util.Objects;

/**
 * 근무시간 계산시에 사용할 복합키
 */
public class WtmCalcGroupKey {
    private String enterCd;
    private String sabun;
    private String ymd;
    private String workTimeType;
    private String workClassCd;

    public String getEnterCd() {
        return enterCd;
    }

    public void setEnterCd(String enterCd) {
        this.enterCd = enterCd;
    }

    public String getSabun() {
        return sabun;
    }

    public void setSabun(String sabun) {
        this.sabun = sabun;
    }

    public String getYmd() {
        return ymd;
    }

    public void setYmd(String ymd) {
        this.ymd = ymd;
    }

    public String getWorkTimeType() {
        return workTimeType;
    }

    public void setWorkTimeType(String workTimeType) {
        this.workTimeType = workTimeType;
    }

    public String getWorkClassCd() {
        return workClassCd;
    }

    public void setWorkClassCd(String workClassCd) {
        this.workClassCd = workClassCd;
    }

    public WtmCalcGroupKey(String enterCd, String sabun, String ymd, String workTimeType) {
        this.enterCd = enterCd;
        this.ymd = ymd;
        this.sabun = sabun;
        this.workTimeType = workTimeType;
    }

    public WtmCalcGroupKey(String enterCd, String sabun, String ymd) {
        this.enterCd = enterCd;
        this.ymd = ymd;
        this.sabun = sabun;
    }

    public WtmCalcGroupKey(String enterCd, String sabun) {
        this.enterCd = enterCd;
        this.sabun = sabun;
    }

    public WtmCalcGroupKey(String enterCd, String sabun, String ymd, String workTimeType, String workClassCd) {
        this.enterCd = enterCd;
        this.ymd = ymd;
        this.sabun = sabun;
        this.workTimeType = workTimeType;
        this.workClassCd = workClassCd;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        WtmCalcGroupKey that = (WtmCalcGroupKey) o;

        // enterCd와 sabun은 필수값이므로 항상 비교
        if (!Objects.equals(enterCd, that.enterCd)) return false;
        if (!Objects.equals(sabun, that.sabun)) return false;

        // ymd가 null이 아닌 경우에만 비교
        if (ymd != null && that.ymd != null && !Objects.equals(ymd, that.ymd)) return false;
        if (workTimeType != null && that.workTimeType != null && !Objects.equals(workTimeType, that.workTimeType)) return false;
        if (workClassCd != null && that.workClassCd != null && !Objects.equals(workClassCd, that.workClassCd)) return false;

        return true;
    }

    @Override
    public int hashCode() {
        if (ymd == null && workTimeType == null && workClassCd == null) {
            return Objects.hash(enterCd, sabun);
        } else if (ymd == null && workTimeType == null) {
            return Objects.hash(enterCd, sabun, workClassCd);
        } else if (ymd == null && workClassCd == null) {
            return Objects.hash(enterCd, sabun, workTimeType);
        } else if (workTimeType == null && workClassCd == null) {
            return Objects.hash(enterCd, sabun, ymd);
        } else if (ymd == null) {
            return Objects.hash(enterCd, sabun, workTimeType, workClassCd);
        } else if (workTimeType == null) {
            return Objects.hash(enterCd, sabun, ymd, workClassCd);
        } else if (workClassCd == null) {
            return Objects.hash(enterCd, sabun, ymd, workTimeType);
        } else {
            return Objects.hash(enterCd, sabun, ymd, workTimeType, workClassCd);
        }
    }

}
