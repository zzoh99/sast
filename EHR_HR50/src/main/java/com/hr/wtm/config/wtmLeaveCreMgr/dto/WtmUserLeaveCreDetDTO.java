package com.hr.wtm.config.wtmLeaveCreMgr.dto;

import com.hr.common.util.DateUtil;

import java.time.LocalDate;
import java.util.Map;

public class WtmUserLeaveCreDetDTO {

    private String enterCd;
    private String sabun;
    private String gntCd;
    private String ymd; // 일자
    private String reason; // 사유

    public WtmUserLeaveCreDetDTO() {}

    public WtmUserLeaveCreDetDTO(Map<String, Object> paramMap) {
        this.enterCd = (String) paramMap.get("enterCd");
        this.sabun = (String) paramMap.get("sabun");
        this.gntCd = (String) paramMap.get("gntCd");
        this.ymd = (String) paramMap.get("ymd");
        this.reason = (String) paramMap.get("reason");
    }

    public String getEnterCd() {
        return enterCd;
    }

    public String getSabun() {
        return sabun;
    }

    public String getGntCd() {
        return gntCd;
    }

    public String getYmd() {
        return ymd;
    }

    public String getReason() {
        return reason;
    }

    public void setEnterCd(String enterCd) {
        this.enterCd = enterCd;
    }

    public void setSabun(String sabun) {
        this.sabun = sabun;
    }

    public void setGntCd(String gntCd) {
        this.gntCd = gntCd;
    }

    public void setYmd(String ymd) {
        this.ymd = ymd;
    }

    public void setYmd(LocalDate date) {
        this.ymd = DateUtil.convertLocalDateToString(date);
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    @Override
    public String toString() {
        return "{"
                + "\"enterCd\": \"" + this.enterCd + "\""
                + ", \"sabun\": \"" + this.sabun + "\""
                + ", \"gntCd\": \"" + this.gntCd + "\""
                + ", \"ymd\": \"" + this.ymd + "\""
                + ", \"reason\": \"" + this.reason + "\""
                + "}";
    }
}
