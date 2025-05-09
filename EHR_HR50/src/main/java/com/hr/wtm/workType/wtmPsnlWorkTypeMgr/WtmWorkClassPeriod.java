package com.hr.wtm.workType.wtmPsnlWorkTypeMgr;

import com.hr.common.util.DateUtil;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class WtmWorkClassPeriod implements Cloneable {

    private String enterCd;
    private String sabun;
    private String workClassCd;
    private String sdate;
    private String edate;
    private String oldSdate;
    private String oldEdate;
    private List<WtmWorkGroupPeriod> workGroupPeriodList;

    public WtmWorkClassPeriod(String enterCd, String sabun, String workClassCd, String sdate, String edate) {
        this.enterCd = enterCd;
        this.sabun = sabun;
        this.workClassCd = workClassCd;
        this.sdate = sdate;
        this.edate = edate;
        this.workGroupPeriodList = new ArrayList<>();
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

    public String getSdate() {
        return sdate;
    }

    public String getEdate() {
        return edate;
    }

    public void setSdate(String sdate) {
        this.sdate = sdate;
    }

    public void setEdate(String edate) {
        this.edate = edate;
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

    public List<WtmWorkGroupPeriod> getWorkGroupPeriodList() {
        return workGroupPeriodList;
    }

    public void setWorkGroupPeriodList(List<WtmWorkGroupPeriod> workGroupPeriodList) {
        this.workGroupPeriodList = workGroupPeriodList;
    }

    @Override
    public WtmWorkClassPeriod clone() throws CloneNotSupportedException {
        return (WtmWorkClassPeriod) super.clone();
    }
}
