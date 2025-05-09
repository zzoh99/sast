package com.hr.wtm.calc.dto;

/**
 * 근무,휴게시간 계산을 위한 근태디테일 클래스
 */
public class WtmGntDtlDTO {
    private String enterCd;
    private String gntDtlId;
    private String ymd;
    private String sabun;
    private String name;
    private String gntCd;
    private String symd;
    private String shm;
    private String eymd;
    private String ehm;
    private int mm;
    private String requestUseType;

    public WtmGntDtlDTO() {
    }

    public WtmGntDtlDTO(String enterCd, String gntDtlId, String ymd, String sabun, String name, String gntCd, String symd, String shm, String eymd, String ehm, int mm) {
        this.enterCd = enterCd;
        this.gntDtlId = gntDtlId;
        this.ymd = ymd;
        this.sabun = sabun;
        this.name = name;
        this.gntCd = gntCd;
        this.symd = symd;
        this.shm = shm;
        this.eymd = eymd;
        this.ehm = ehm;
        this.mm = mm;
    }

    public String getEnterCd() {
        return enterCd;
    }

    public void setEnterCd(String enterCd) {
        this.enterCd = enterCd;
    }

    public String getGntDtlId() {
        return gntDtlId;
    }

    public void setGntDtlId(String gntDtlId) {
        this.gntDtlId = gntDtlId;
    }

    public String getYmd() {
        return ymd;
    }

    public void setYmd(String ymd) {
        this.ymd = ymd;
    }

    public String getSabun() {
        return sabun;
    }

    public void setSabun(String sabun) {
        this.sabun = sabun;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getGntCd() {
        return gntCd;
    }

    public void setGntCd(String gntCd) {
        this.gntCd = gntCd;
    }

    public String getSymd() {
        return symd;
    }

    public void setSymd(String symd) {
        this.symd = symd;
    }

    public String getShm() {
        return shm;
    }

    public void setShm(String shm) {
        this.shm = shm;
    }

    public String getEymd() {
        return eymd;
    }

    public void setEymd(String eymd) {
        this.eymd = eymd;
    }

    public String getEhm() {
        return ehm;
    }

    public void setEhm(String ehm) {
        this.ehm = ehm;
    }

    public int getMm() {
        return mm;
    }

    public void setMm(int mm) {
        this.mm = mm;
    }

    public String getRequestUseType() {
        return requestUseType;
    }

    public void setRequestUseType(String requestUseType) {
        this.requestUseType = requestUseType;
    }
}
