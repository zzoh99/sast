package com.hr.wtm.calc.dto;

/**
 * 근무,휴게시간 계산결과를 일별로 담는 클래스
 */
public class WtmDailyCountDTO {
    private String enterCd;
    private String ymd;
    private String sabun;
    private String workClassCd;
    private String inYmd;    // 사용안함
    private String inHm;  // 사용안함
    private String outYmd;
    private String outHm;
    private String dayType;
    private int basicMm;
    private int otMm;
    private int ltnMm;
    private int vacationMm;
    private String lateYn;
    private String leaveEarlyYn;
    private String absenceYn;

    public String getEnterCd() {
        return enterCd;
    }

    public void setEnterCd(String enterCd) {
        this.enterCd = enterCd;
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

    public String getWorkClassCd() {
        return workClassCd;
    }

    public void setWorkClassCd(String workClassCd) {
        this.workClassCd = workClassCd;
    }

    public String getInYmd() {
        return inYmd;
    }

    public void setInYmd(String inYmd) {
        this.inYmd = inYmd;
    }

    public String getInHm() {
        return inHm;
    }

    public void setInHm(String inHm) {
        this.inHm = inHm;
    }

    public String getOutYmd() {
        return outYmd;
    }

    public void setOutYmd(String outYmd) {
        this.outYmd = outYmd;
    }

    public String getOutHm() {
        return outHm;
    }

    public void setOutHm(String outHm) {
        this.outHm = outHm;
    }

    public String getDayType() {
        return dayType;
    }

    public void setDayType(String dayType) {
        this.dayType = dayType;
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

    public String getLateYn() {
        return lateYn;
    }

    public void setLateYn(String lateYn) {
        this.lateYn = lateYn;
    }

    public String getLeaveEarlyYn() {
        return leaveEarlyYn;
    }

    public void setLeaveEarlyYn(String leaveEarlyYn) {
        this.leaveEarlyYn = leaveEarlyYn;
    }

    public String getAbsenceYn() {
        return absenceYn;
    }

    public void setAbsenceYn(String absenceYn) {
        this.absenceYn = absenceYn;
    }
}
