package com.hr.wtm.calc.dto;

/**
 * 근무시간 계산결과를 주별로 담는 클래스
 */
public class WtmWeeklyCountDTO {
    private String enterCd;     /* 회사코드 */
    private String sabun;       /* 사번 */
    private String weekSymd;    /* 주 시작일 */
    private String weekEymd;    /* 주 종료일 */
    private double weekCount;   /* 주차수(주평균계산용) */
    private String workClassCd; /* 근무유형 */
    private int basicMm;        /* 기본근무시간(분) */
    private int otMm;           /* 연장근무시간(분) */
    private int ltnMm;          /* 야간근무시간(분) */
    private int vacationMm;     /* 휴가시간(분) */

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

    public String getWeekSymd() {
        return weekSymd;
    }

    public void setWeekSymd(String weekSymd) {
        this.weekSymd = weekSymd;
    }

    public String getWeekEymd() {
        return weekEymd;
    }

    public void setWeekEymd(String weekEymd) {
        this.weekEymd = weekEymd;
    }

    public double getWeekCount() {
        return weekCount;
    }

    public void setWeekCount(double weekCount) {
        this.weekCount = weekCount;
    }

    public String getWorkClassCd() {
        return workClassCd;
    }

    public void setWorkClassCd(String workClassCd) {
        this.workClassCd = workClassCd;
    }

    public int getBasicMm() {
        return basicMm;
    }

    public void setBasicMm(int basicMm) {
        this.basicMm = basicMm;
    }

    public int getOtMm() {
        return otMm;
    }

    public void setOtMm(int otMm) {
        this.otMm = otMm;
    }

    public int getLtnMm() {
        return ltnMm;
    }

    public void setLtnMm(int ltnMm) {
        this.ltnMm = ltnMm;
    }

    public int getVacationMm() {
        return vacationMm;
    }

    public void setVacationMm(int vacationMm) {
        this.vacationMm = vacationMm;
    }
}
