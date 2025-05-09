package com.hr.wtm.calc.dto;

/**
 * 근무,휴게시간 계산을 위한 근무조스케줄 클래스
 */
public class WtmWrkSchDTO {
    private String enterCd;     /* 회사코드 */
    private String sabun;       /* 사번 */
    private String name;        /* 이름 */
    private String ymd;         /* 일자 */
    private String postYn;      /* 근무스케줄게시여부(Y/N) */
    private String wrkDtlId;    /* 근무 디테일 ID */
    private String workClassCd; /* 근무유형코드 */
    private String workSchCd;   /* 근무스케줄코드 */
    private String workTimeF;   /* 근무시작시간 */
    private String workTimeT;   /* 근무종료시간 */
    private String breakTimes;  /* 휴게시간 */
    private String systemCdYn;  /* 시스템코드여부(Y/N) */

    public String getBreakTimes() {
        return breakTimes;
    }

    public void setBreakTimes(String breakTimes) {
        this.breakTimes = breakTimes;
    }

    public String getWorkTimeT() {
        return workTimeT;
    }

    public void setWorkTimeT(String workTimeT) {
        this.workTimeT = workTimeT;
    }

    public String getWorkTimeF() {
        return workTimeF;
    }

    public void setWorkTimeF(String workTimeF) {
        this.workTimeF = workTimeF;
    }

    public String getWorkSchCd() {
        return workSchCd;
    }

    public void setWorkSchCd(String workSchCd) {
        this.workSchCd = workSchCd;
    }

    public String getWorkClassCd() {
        return workClassCd;
    }

    public void setWorkClassCd(String workClassCd) {
        this.workClassCd = workClassCd;
    }

    public String getWrkDtlId() {
        return wrkDtlId;
    }

    public void setWrkDtlId(String wrkDtlId) {
        this.wrkDtlId = wrkDtlId;
    }

    public String getPostYn() {
        return postYn;
    }

    public void setPostYn(String postYn) {
        this.postYn = postYn;
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

    public String getEnterCd() {
        return enterCd;
    }

    public void setEnterCd(String enterCd) {
        this.enterCd = enterCd;
    }

    public String getSystemCdYn() {
        return systemCdYn;
    }

    public void setSystemCdYn(String systemCdYn) {
        this.systemCdYn = systemCdYn;
    }
}
