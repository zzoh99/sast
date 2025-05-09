package com.hr.common.rd;

public class RdData{
    private String hrBasic1 = "Y";//인사기본1
    private String hrBasic2 = "Y";//인사기본2
    private String appointmentIssue = "Y";//발령사항
    private String education = "Y";//교육사항
    private String military = "N";//병역
    private String departmentAppointment = "N";//타부서 발령 여부

    //여기부터 체크박스 선택값 반영
    private String evaluation = "N";//평가
    private String phone = "N";//연락처
    private String academic = "N";//학력
    private String career = "N";//경력
    private String reward = "N";//포상
    private String disciplinary = "N";//징계
    private String qualification = "N";//자격
    private String languageAbility = "N";//어학
    private String family = "N";//가족
    private String appointment = "N";//발령
    private String job = "N";//직무
    private String imageBaseUrl = "";//사진 base url
    private String masking = "Y";//마스킹
    private String payActionCd = "";//급여일자코드

    private String searchEnterCdSabuns;
    private String searchSabuns;

    public String getSearchEnterCdSabuns() {
        return searchEnterCdSabuns;
    }

    public void setSearchEnterCdSabuns(String searchEnterCdSabuns) {
        this.searchEnterCdSabuns = searchEnterCdSabuns;
    }

    public String getSearchSabuns() {
        return searchSabuns;
    }

    public void setSearchSabuns(String searchSabuns) {
        this.searchSabuns = searchSabuns;
    }

    public String getHrBasic1() {
        return hrBasic1;
    }

    public String getHrBasic2() {
        return hrBasic2;
    }

    public String getAppointmentIssue() {
        return appointmentIssue;
    }

    public String getEducation() {
        return education;
    }

    public String getMilitary() {
        return military;
    }

    public String getDepartmentAppointment() {
        return departmentAppointment;
    }

    public String getEvaluation() {
        return evaluation;
    }

    public void setEvaluation(String evaluation) {
        this.evaluation = evaluation;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAcademic() {
        return academic;
    }

    public void setAcademic(String academic) {
        this.academic = academic;
    }

    public String getCareer() {
        return career;
    }

    public void setCareer(String career) {
        this.career = career;
    }

    public String getReward() {
        return reward;
    }

    public void setReward(String reward) {
        this.reward = reward;
    }

    public String getDisciplinary() {
        return disciplinary;
    }

    public void setDisciplinary(String disciplinary) {
        this.disciplinary = disciplinary;
    }

    public String getQualification() {
        return qualification;
    }

    public void setQualification(String qualification) {
        this.qualification = qualification;
    }

    public String getLanguageAbility() {
        return languageAbility;
    }

    public void setLanguageAbility(String languageAbility) {
        this.languageAbility = languageAbility;
    }

    public String getFamily() {
        return family;
    }

    public void setFamily(String family) {
        this.family = family;
    }

    public String getAppointment() {
        return appointment;
    }

    public void setAppointment(String appointment) {
        this.appointment = appointment;
    }

    public String getJob() {
        return job;
    }

    public void setJob(String job) {
        this.job = job;
    }

    public String getImageBaseUrl() {
        return imageBaseUrl;
    }

    public void setImageBaseUrl(String imageBaseUrl) {
        this.imageBaseUrl = imageBaseUrl;
    }

    public String getMasking() {
        return masking;
    }

    public void setMasking(String masking) {
        this.masking = masking;
    }

    public String getPayActionCd() {
        return payActionCd;
    }

    public void setPayActionCd(String payActionCd) {
        this.payActionCd = payActionCd;
    }
}
