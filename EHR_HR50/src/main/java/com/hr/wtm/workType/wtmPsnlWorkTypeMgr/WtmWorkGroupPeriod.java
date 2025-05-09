package com.hr.wtm.workType.wtmPsnlWorkTypeMgr;

import com.hr.common.util.DateUtil;

import java.time.LocalDate;

public class WtmWorkGroupPeriod implements Cloneable {

    private String enterCd;
    private String sabun;
    private String workClassCd;
    private String workGroupCd;
    private String sdate;
    private String edate;
    private String oldSdate;
    private String oldEdate;

    public WtmWorkGroupPeriod(String enterCd, String sabun, String workClassCd, String workGroupCd, String sdate, String edate) {
        this.enterCd = enterCd;
        this.sabun = sabun;
        this.workClassCd = workClassCd;
        this.workGroupCd = workGroupCd;
        this.sdate = sdate;
        this.edate = edate;
    }

    public String getEnterCd() {
        return enterCd;
    }

    public String getSabun() {
        return sabun;
    }

    public String getWorkClassCd() {
        return workClassCd;
    }

    public String getWorkGroupCd() {
        return workGroupCd;
    }

    public String getSdate() {
        return sdate;
    }

    public String getEdate() {
        return edate;
    }

    public LocalDate getSdateToLocalDate() {
        return DateUtil.getLocalDate(sdate);
    }

    public LocalDate getEdateToLocalDate() {
        return DateUtil.getLocalDate(edate);
    }

    public void setOldSdate(String oldSdate) {
        this.oldSdate = oldSdate;
    }

    public void setOldEdate(String oldEdate) {
        this.oldEdate = oldEdate;
    }

    public void setSdate(String sdate) {
        this.sdate = sdate;
    }

    public void setEdate(String edate) {
        this.edate = edate;
    }

    @Override
    public WtmWorkGroupPeriod clone() throws CloneNotSupportedException {
        return (WtmWorkGroupPeriod) super.clone();
    }
}
