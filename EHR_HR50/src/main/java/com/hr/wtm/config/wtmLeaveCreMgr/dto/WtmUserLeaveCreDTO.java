package com.hr.wtm.config.wtmLeaveCreMgr.dto;

import com.github.f4b6a3.tsid.TsidCreator;
import com.hr.common.util.DateUtil;
import com.hr.wtm.config.wtmLeaveCreMgr.domain.WtmLeaveCreEmployee;
import com.hr.wtm.config.wtmLeaveCreStd.WtmLeaveCreOption;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class WtmUserLeaveCreDTO implements Cloneable {

    private String enterCd;
    private String leaveId; // 휴가ID
    private String ym;
    private String sabun;
    private String gntCd;
    private String searchSeq; // 휴가생성기준_대상자조건검색SEQ(TWTM011)
    private String gntSYmd; // 생성기준시작일
    private String gntEYmd; // 생성기준종료일
    private String empYmd; // 생성기준입사일
    private Integer workYearCnt; // 근속년차
    private Double workCnt; // 근속년수
    private Integer realWorkDays; // 생성기준기간 내 실질 소정근로일수
    private Integer totWorkDays; // 생성기준기간 내 총 소정근로일수
    private Double creAnnualCnt; // 발생기준연차
    private Double addAnnualCnt; // 근속에 따른 가산연차
    private Double monthlyCnt; // 월차(근무율80%미만)
    private Double monthlyU1yCnt; // 1년미만대상자월차
    private Double annualU1yCnt; // 1년미만대상자연차(회계일기준)
    private Double carryOverCnt; // 이월일수
    private String useSYmd; // 사용기준시작일
    private String useEYmd; // 사용기준종료일
    private String applYn; // 반영여부(Y/N)
    private String note; // 비고
    private List<WtmUserLeaveCreDetDTO> creDetDTOList; // 개인별휴가내역생성_소정근무제외

    public WtmUserLeaveCreDTO(WtmLeaveCreEmployee employee, WtmLeaveCreOption option, LocalDate stdDate) throws Exception {
        this.enterCd = employee.getEnterCd();
        this.leaveId = TsidCreator.getTsid().toString();
        this.ym = DateUtil.convertLocalDateToString(stdDate, "yyyyMM");
        this.sabun = employee.getSabun();
        this.gntCd = option.getGntCd();
        this.searchSeq = option.getSearchSeq();
        this.empYmd = employee.getEmpYmd();
        this.workYearCnt = employee.getWorkYearCnt(stdDate);
        this.workCnt = employee.getWorkCnt(stdDate, option.getUpbase(), option.getUnit(), option.getTotDaysType());
        this.creDetDTOList = new ArrayList<>();
    }

    public WtmUserLeaveCreDTO(Map<String, Object> paramMap) {
        this.enterCd = (String) paramMap.get("enterCd");
        this.leaveId = TsidCreator.getTsid().toString();
        this.ym = (String) paramMap.get("ym");
        this.sabun = (String) paramMap.get("sabun");
        this.gntCd = (String) paramMap.get("gntCd");
        this.searchSeq = paramMap.get("searchSeq").toString();
        this.gntSYmd = (String) paramMap.get("gntSYmd");
        this.gntEYmd = (String) paramMap.get("gntEYmd");
        this.empYmd = (String) paramMap.get("empYmd");
        this.workYearCnt = Integer.parseInt((String) paramMap.get("workYearCnt"));
        this.workCnt = Double.parseDouble((String) paramMap.get("workCnt"));
        this.realWorkDays = Integer.parseInt((String) paramMap.get("realWorkDays"));
        this.totWorkDays = Integer.parseInt((String) paramMap.get("totWorkDays"));
        this.creAnnualCnt = Double.parseDouble((String) paramMap.get("creAnnualCnt"));
        this.addAnnualCnt = Double.parseDouble((String) paramMap.get("addAnnualCnt"));
        this.monthlyCnt = Double.parseDouble((String) paramMap.get("monthlyCnt"));
        this.monthlyU1yCnt = Double.parseDouble((String) paramMap.get("monthlyU1yCnt"));
        this.annualU1yCnt = Double.parseDouble((String) paramMap.get("annualU1yCnt"));
        this.carryOverCnt = Double.parseDouble((String) paramMap.get("carryOverCnt"));
        this.useSYmd = (String) paramMap.get("useSYmd");
        this.useEYmd = (String) paramMap.get("useEYmd");
        this.applYn = (String) paramMap.get("applYn");
        this.note = (String) paramMap.get("note");
        this.creDetDTOList = new ArrayList<>();
    }

    public String getEnterCd() {
        return enterCd;
    }

    public String getLeaveId() {
        return leaveId;
    }

    public String getYm() {
        return ym;
    }

    public String getSabun() {
        return sabun;
    }

    public String getGntCd() {
        return gntCd;
    }

    public String getSearchSeq() {
        return searchSeq;
    }

    public String getGntSYmd() {
        return gntSYmd;
    }

    public String getGntEYmd() {
        return gntEYmd;
    }

    public String getEmpYmd() {
        return empYmd;
    }

    public Integer getWorkYearCnt() {
        return workYearCnt;
    }

    public Double getWorkCnt() {
        return workCnt;
    }

    public Integer getRealWorkDays() {
        return realWorkDays;
    }

    public Integer getTotWorkDays() {
        return totWorkDays;
    }

    public Double getCreAnnualCnt() {
        return creAnnualCnt;
    }

    public Double getAddAnnualCnt() {
        return addAnnualCnt;
    }

    public Double getMonthlyCnt() {
        return monthlyCnt;
    }

    public Double getMonthlyU1yCnt() {
        return monthlyU1yCnt;
    }

    public Double getAnnualU1yCnt() {
        return annualU1yCnt;
    }

    public Double getCarryOverCnt() {
        return carryOverCnt;
    }

    public String getUseSYmd() {
        return useSYmd;
    }

    public LocalDate getUseSDate() {
        return DateUtil.getLocalDate(useSYmd);
    }

    public String getUseEYmd() {
        return useEYmd;
    }

    public String getApplYn() {
        return applYn;
    }

    public String getNote() {
        return note;
    }

    public List<WtmUserLeaveCreDetDTO> getCreDetDTOList() {
        return creDetDTOList;
    }

    public void setEnterCd(String enterCd) {
        this.enterCd = enterCd;
    }

    public void setLeaveId(String leaveId) {
        this.leaveId = leaveId;
    }

    public void setYm(String ym) {
        this.ym = ym;
    }

    public void setSabun(String sabun) {
        this.sabun = sabun;
    }

    public void setGntCd(String gntCd) {
        this.gntCd = gntCd;
    }

    public void setSearchSeq(String searchSeq) {
        this.searchSeq = searchSeq;
    }

    public void set(String enterCd, String ym, String sabun, String gntCd, String searchSeq) {
        this.setEnterCd(enterCd);
        this.setYm(ym);
        this.setSabun(sabun);
        this.setGntCd(gntCd);
        this.setSearchSeq(searchSeq);
    }

    public void setGntSYmd(String gntSYmd) {
        this.gntSYmd = gntSYmd;
    }

    public void setGntEYmd(String gntEYmd) {
        this.gntEYmd = gntEYmd;
    }

    public void setGntSYmd(LocalDate gntSDate) {
        this.gntSYmd = DateUtil.convertLocalDateToString(gntSDate);
    }

    public void setGntEYmd(LocalDate gntEDate) {
        this.gntEYmd = DateUtil.convertLocalDateToString(gntEDate);
    }

    public void setEmpYmd(String empYmd) {
        this.empYmd = empYmd;
    }

    public void setWorkYearCnt(int workYearCnt) {
        this.workYearCnt = workYearCnt;
    }

    public void setWorkCnt(double workCnt) {
        this.workCnt = workCnt;
    }

    public void setRealWorkDays(int realWorkDays) {
        this.realWorkDays = realWorkDays;
    }

    public void setTotWorkDays(int totWorkDays) {
        this.totWorkDays = totWorkDays;
    }

    public void setCreAnnualCnt(double creAnnualCnt) {
        this.creAnnualCnt = creAnnualCnt;
    }

    public void setAddAnnualCnt(double addAnnualCnt) {
        this.addAnnualCnt = addAnnualCnt;
    }

    public void setMonthlyCnt(double monthlyCnt) {
        this.monthlyCnt = monthlyCnt;
    }

    public void setMonthlyU1yCnt(double monthlyU1yCnt) {
        this.monthlyU1yCnt = monthlyU1yCnt;
    }

    public void setAnnualU1yCnt(double annualU1yCnt) {
        this.annualU1yCnt = annualU1yCnt;
    }

    public void setCarryOverCnt(double carryOverCnt) {
        this.carryOverCnt = carryOverCnt;
    }

    public void setUseSYmd(String useSYmd) {
        this.useSYmd = useSYmd;
    }

    public void setUseEYmd(String useEYmd) {
        this.useEYmd = useEYmd;
    }

    public void setUseSYmd(LocalDate useSDate) {
        this.useSYmd = DateUtil.convertLocalDateToString(useSDate);
    }

    public void setUseEYmd(LocalDate useEDate) {
        this.useEYmd = DateUtil.convertLocalDateToString(useEDate);
    }

    public void setApplYn(String applYn) {
        this.applYn = applYn;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public void setCreDetDTOList(List<WtmUserLeaveCreDetDTO> creDetDTOList) {
        this.creDetDTOList = creDetDTOList;
    }

    /**
     * 1년 미만 연월차 여부
     * @return 1년 미만 연월차 여부
     */
    public boolean isUnder1y() {
        return (this.monthlyU1yCnt != null || this.annualU1yCnt != null);
    }

    @Override
    public String toString() {
        return "{"
                + "\"enterCd\": \"" + this.enterCd + "\""
                + ", \"leaveId\": \"" + this.leaveId + "\""
                + ", \"ym\": \"" + this.ym + "\""
                + ", \"sabun\": \"" + this.sabun + "\""
                + ", \"gntCd\": \"" + this.gntCd + "\""
                + ", \"searchSeq\": \"" + this.searchSeq + "\""
                + ", \"gntSYmd\": \"" + this.gntSYmd + "\""
                + ", \"gntEYmd\": \"" + this.gntEYmd + "\""
                + ", \"empYmd\": \"" + this.empYmd + "\""
                + ", \"workYearCnt\": " + this.workYearCnt
                + ", \"workCnt\": " + this.workCnt
                + ", \"realWorkDays\": " + this.realWorkDays
                + ", \"totWorkDays\": " + this.totWorkDays
                + ", \"creAnnualCnt\": " + this.creAnnualCnt
                + ", \"addAnnualCnt\": " + this.addAnnualCnt
                + ", \"monthlyCnt\": " + this.monthlyCnt
                + ", \"monthlyU1yCnt\": " + this.monthlyU1yCnt
                + ", \"carryOverCnt\": " + this.carryOverCnt
                + ", \"useSYmd\": \"" + this.useSYmd + "\""
                + ", \"useEYmd\": \"" + this.useEYmd + "\""
                + ", \"applYn\": \"" + this.applYn + "\""
                + ", \"note\": \"" + this.note + "\""
                + "}";
    }

    @Override
    public Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}
