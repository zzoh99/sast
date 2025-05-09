package com.hr.wtm.calc.dto;

/**
 * 근무,휴게시간 계산을 위한 근무디테일 클래스
 */
public class WtmWrkDtlDTO {
    private String enterCd;
    private String wrkDtlId;
    private String ymd;
    private String sabun;
    private String name;
    private String workCd;
    private String planSymd;
    private String planShm;
    private String planEymd;
    private String planEhm;
    private int planMm;
    private String realSymd;
    private String realShm;
    private String realEymd;
    private String realEhm;
    private int realMm;
    private String type;
    private String autoCreYn;
    private String addWorkTimeYn; // 근무시간 합산 여부
    private String workTimeType;  // 근무 시간 유형
    private String requestUseType; // 근무 신청서 유형
    private String deemedYn; // 간주근로여부
    private String newDataYn; // 신규생성 데이터 여부

    public WtmWrkDtlDTO() {
    }

    public WtmWrkDtlDTO(String enterCd, String wrkDtlId, String ymd, String sabun, String name, String workCd, String planSymd, String planShm, String planEymd, String planEhm, int planMm, String type, String addWorkTimeYn, String workTimeType, String requestUseType) {
        this.enterCd = enterCd;
        this.wrkDtlId = wrkDtlId;
        this.ymd = ymd;
        this.sabun = sabun;
        this.name = name;
        this.workCd = workCd;
        this.planSymd = planSymd;
        this.planShm = planShm;
        this.planEymd = planEymd;
        this.planEhm = planEhm;
        this.planMm = planMm;
        this.type = type;
        this.addWorkTimeYn = addWorkTimeYn;
        this.workTimeType = workTimeType;
        this.requestUseType = requestUseType;
    }

    public String getEnterCd() {
        return enterCd;
    }

    public void setEnterCd(String enterCd) {
        this.enterCd = enterCd;
    }

    public String getWrkDtlId() {
        return wrkDtlId;
    }

    public void setWrkDtlId(String wrkDtlId) {
        this.wrkDtlId = wrkDtlId;
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

    public String getWorkCd() {
        return workCd;
    }

    public void setWorkCd(String workCd) {
        this.workCd = workCd;
    }

    public String getPlanSymd() {
        return planSymd;
    }

    public void setPlanSymd(String planSymd) {
        this.planSymd = planSymd;
    }

    public String getPlanShm() {
        return planShm;
    }

    public void setPlanShm(String planShm) {
        this.planShm = planShm;
    }

    public String getPlanEymd() {
        return planEymd;
    }

    public void setPlanEymd(String planEymd) {
        this.planEymd = planEymd;
    }

    public String getPlanEhm() {
        return planEhm;
    }

    public void setPlanEhm(String planEhm) {
        this.planEhm = planEhm;
    }

    public int getPlanMm() {
        return planMm;
    }

    public void setPlanMm(int planMm) {
        this.planMm = planMm;
    }

    public String getRealSymd() {
        return realSymd;
    }

    public void setRealSymd(String realSymd) {
        this.realSymd = realSymd;
    }

    public String getRealShm() {
        return realShm;
    }

    public void setRealShm(String realShm) {
        this.realShm = realShm;
    }

    public String getRealEymd() {
        return realEymd;
    }

    public void setRealEymd(String realEymd) {
        this.realEymd = realEymd;
    }

    public String getRealEhm() {
        return realEhm;
    }

    public void setRealEhm(String realEhm) {
        this.realEhm = realEhm;
    }

    public int getRealMm() {
        return realMm;
    }

    public void setRealMm(int realMm) {
        this.realMm = realMm;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getAutoCreYn() {
        return autoCreYn;
    }

    public void setAutoCreYn(String autoCreYn) {
        this.autoCreYn = autoCreYn;
    }

    public String getAddWorkTimeYn() {
        return addWorkTimeYn;
    }

    public void setAddWorkTimeYn(String addWorkTimeYn) {
        this.addWorkTimeYn = addWorkTimeYn;
    }

    public String getWorkTimeType() {
        return workTimeType;
    }

    public void setWorkTimeType(String workTimeType) {
        this.workTimeType = workTimeType;
    }

    public String getRequestUseType() {
        return requestUseType;
    }

    public void setRequestUseType(String requestUseType) {
        this.requestUseType = requestUseType;
    }

    public String getDeemedYn() {
        return deemedYn;
    }

    public void setDeemedYn(String deemedYn) {
        this.deemedYn = deemedYn;
    }

    public String getNewDataYn() {
        return newDataYn;
    }

    public void setNewDataYn(String newDataYn) {
        this.newDataYn = newDataYn;
    }
}
