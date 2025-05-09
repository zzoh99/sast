package com.hr.wtm.domain;

import com.hr.common.util.StringUtil;
import com.hr.wtm.config.wtmGntCdMgr.WtmGntCdDTO;

import java.util.Map;

public class WtmLeaveAppInfo {

    private final String enterCd;
    private final String applSeq;
    private final String gntCd;
    private final String sabun;
    private final String ymd;
    private final double appDay;
    private final String basicGntCd;
    private final WtmGntCdDTO gntCdDTO;

    public WtmLeaveAppInfo(String enterCd, String applSeq, String gntCd, String sabun, String ymd, double appDay, String basicGntCd, WtmGntCdDTO gntCdDTO) {
        this.enterCd = enterCd;
        this.applSeq = applSeq;
        this.gntCd = gntCd;
        this.sabun = sabun;
        this.ymd = ymd;
        this.appDay = appDay;
        this.basicGntCd = basicGntCd;
        this.gntCdDTO = gntCdDTO;
    }

    public WtmLeaveAppInfo(Map<String, Object> paramMap, WtmGntCdDTO gntCdDTO) {
        this.enterCd = StringUtil.stringValueOf(paramMap.get("enterCd"));
        this.applSeq = StringUtil.stringValueOf(paramMap.get("applSeq"));
        this.gntCd = StringUtil.stringValueOf(paramMap.get("gntCd"));
        this.sabun = StringUtil.stringValueOf(paramMap.get("sabun"));
        this.ymd = StringUtil.stringValueOf(paramMap.get("ymd"));
        this.appDay = Double.parseDouble(StringUtil.stringValueOf(paramMap.get("appDay")));
        this.basicGntCd = StringUtil.stringValueOf(paramMap.get("basicGntCd"));
        this.gntCdDTO = gntCdDTO;
    }

    public String getEnterCd() {
        return enterCd;
    }

    public String getGntCd() {
        return gntCd;
    }

    public String getSabun() {
        return sabun;
    }

    public String getYmd() {
        return ymd;
    }

    public double getAppDay() {
        return appDay;
    }

    public String getBasicGntCd() {
        return basicGntCd;
    }

    public WtmGntCdDTO getGntCdDTO() {
        return gntCdDTO;
    }

    @Override
    public String toString() {
        return "{ \"enterCd\": \"" + this.enterCd + "\""
                + ", \"applSeq\": \"" + this.applSeq + "\""
                + ", \"gntCd\": \"" + this.gntCd + "\""
                + ", \"sabun\": \"" + this.sabun + "\""
                + ", \"ymd\": \"" + this.ymd + "\""
                + ", \"appDay\": " + this.appDay + "\""
                + ", \"basicGntCd\": \"" + this.basicGntCd + "\""
                + ", \"gntCdDTO\": " + this.gntCdDTO.toString() + "\" }";
    }
}
