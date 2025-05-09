package com.hr.wtm.config.wtmLeaveCreStd;

import com.hr.common.util.DateUtil;

import java.time.LocalDate;

/**
 * HolidaySimulation 을 통해 전달할 객체
 * @author isu
 */
public class WtmLeaveCreSimulationDTO {

    private String ymd;
    private String formattedYmd;
    private String term;
    private String monthlyLeave;
    private String annualLeave;
    private String reasonText; // 생성사유
    private String reasonPeriod; // 생성사유(기간)

    public String getYmd() {
        return ymd;
    }

    public String getFormattedYmd() {
        return DateUtil.convertLocalDateToString(DateUtil.getLocalDate(this.ymd), "yyyy.MM.dd");
    }

    public String getTerm() {
        return term;
    }

    public String getMonthlyLeave() {
        return monthlyLeave;
    }

    public String getAnnualLeave() {
        return annualLeave;
    }

    public String getReasonText() {
        return reasonText;
    }
    public String getReasonPeriod() {
        return reasonPeriod;
    }

    public void setYmd(String ymd) {
        this.ymd = ymd;
        this.formattedYmd = this.getFormattedYmd();
    }

    public void setYmd(LocalDate date) {
        this.setYmd(DateUtil.convertLocalDateToString(date));
    }

    public void setTerm(String term) {
        this.term = term;
    }

    public void setMonthlyLeave(String monthlyLeave) {
        this.monthlyLeave = monthlyLeave;
    }

    public void setAnnualLeave(String annualLeave) {
        this.annualLeave = annualLeave;
    }

    public void setReasonText(String reasonText) {
        this.reasonText = reasonText;
    }
    public void setReasonPeriod(String reasonPeriod) {
        this.reasonPeriod = reasonPeriod;
    }

    @Override
    public String toString() {
        return "{"
            + "\"ymd\" : \"" + this.ymd + "\""
            + ", \"formattedYmd\" : \"" + this.formattedYmd + "\""
            + ", \"term\": \"" + this.term + "\""
            + ", \"monthlyLeave\": \"" + this.monthlyLeave + "\""
            + ", \"annualLeave\": \"" + this.annualLeave + "\""
            + ", \"reasonText\": \"" + this.reasonText + "\""
            + ", \"reasonPeriod\": \"" + this.reasonPeriod + "\""
            + "}";
    }
}
