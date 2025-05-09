package com.hr.wtm.config.wtmLeaveCreMgr.dto;

import com.hr.common.util.DateUtil;
import yjungsan.util.StringUtil;

import java.time.LocalDate;
import java.util.Comparator;
import java.util.Map;

public class WtmUserLeaveDTO {

    private String enterCd;
    private String leaveId;
    private String sabun;
    private String gntCd;
    private String useSYmd; // 사용기준시작일
    private String useEYmd; // 사용기준종료일
    private Double creCnt; // 총발생일수
    private Double useCnt; // 사용가능일수
    private Double usedCnt; // 사용일수
    private Double restCnt; // 잔여일수
    private Double frdCnt; // 이월일수
    private Double comCnt; // 보상일수
    private String under1yYn; // 1년미만입사자여부
    private String note; // 생성 시 비고
    private int seq;

    public WtmUserLeaveDTO() {}

    public WtmUserLeaveDTO(Map<String, Object> paramMap) {
        this.enterCd = StringUtil.stringValueOf(paramMap.get("enterCd"));
        this.leaveId = StringUtil.stringValueOf(paramMap.get("leaveId"));
        this.sabun = StringUtil.stringValueOf(paramMap.get("sabun"));
        this.gntCd = StringUtil.stringValueOf(paramMap.get("gntCd"));
        this.useSYmd = StringUtil.stringValueOf(paramMap.get("useSYmd"));
        this.useEYmd = StringUtil.stringValueOf(paramMap.get("useEYmd"));
        this.creCnt = StringUtil.parseDouble(StringUtil.stringValueOf(paramMap.get("creCnt")));
        this.useCnt = StringUtil.parseDouble(StringUtil.stringValueOf(paramMap.get("useCnt")));
        this.usedCnt = StringUtil.parseDouble(StringUtil.stringValueOf(paramMap.get("usedCnt")));
        this.restCnt = StringUtil.parseDouble(StringUtil.stringValueOf(paramMap.get("restCnt")));
        this.frdCnt = StringUtil.parseDouble(StringUtil.stringValueOf(paramMap.get("frdCnt")));
        this.comCnt = StringUtil.parseDouble(StringUtil.stringValueOf(paramMap.get("comCnt")));
        this.under1yYn = StringUtil.stringValueOf(paramMap.get("under1yYn"));
        this.note = StringUtil.stringValueOf(paramMap.get("note"));
    }

    public WtmUserLeaveDTO(
            String enterCd, String leaveId, String sabun, String gntCd, String useSYmd,
            String useEYmd, double creCnt, double useCnt, double usedCnt, double restCnt,
            double frdCnt, double comCnt, String under1yYn, String note
    ) {
        this.enterCd = enterCd;
        this.leaveId = leaveId;
        this.sabun = sabun;
        this.gntCd = gntCd;
        this.useSYmd = useSYmd;
        this.useEYmd = useEYmd;
        this.creCnt = creCnt;
        this.useCnt = useCnt;
        this.usedCnt = usedCnt;
        this.restCnt = restCnt;
        this.frdCnt = frdCnt;
        this.comCnt = comCnt;
        this.under1yYn = under1yYn;
        this.note = note;
    }

    public String getEnterCd() {
        return enterCd;
    }

    public String getLeaveId() {
        return leaveId;
    }

    public String getSabun() {
        return sabun;
    }

    public String getGntCd() {
        return gntCd;
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

    public LocalDate getUseEDate() {
        return DateUtil.getLocalDate(useEYmd);
    }

    public Double getCreCnt() {
        return creCnt;
    }

    public Double getUseCnt() {
        return useCnt;
    }

    public Double getUsedCnt() {
        return usedCnt;
    }

    public Double getRestCnt() {
        return restCnt;
    }

    public Double getFrdCnt() {
        return frdCnt;
    }

    public Double getComCnt() {
        return comCnt;
    }

    public String getUnder1yYn() {
        return under1yYn;
    }

    public String getNote() {
        return note;
    }

    public void setEnterCd(String enterCd) {
        this.enterCd = enterCd;
    }

    public void setLeaveId(String leaveId) {
        this.leaveId = leaveId;
    }

    public void setSabun(String sabun) {
        this.sabun = sabun;
    }

    public void setGntCd(String gntCd) {
        this.gntCd = gntCd;
    }

    public void setUseSYmd(String useSYmd) {
        this.useSYmd = useSYmd;
    }

    public void setUseEYmd(String useEYmd) {
        this.useEYmd = useEYmd;
    }

    public void setCreCnt(double creCnt) {
        this.creCnt = creCnt;
    }

    public void setUseCnt(double useCnt) {
        this.useCnt = useCnt;
    }

    public void setUsedCnt(double usedCnt) {
        this.usedCnt = usedCnt;
    }

    public void setRestCnt(double restCnt) {
        this.restCnt = restCnt;
    }

    public void setFrdCnt(double frdCnt) {
        this.frdCnt = frdCnt;
    }

    public void setComCnt(double comCnt) {
        this.comCnt = comCnt;
    }

    public void setUnder1yYn(String under1yYn) {
        this.under1yYn = under1yYn;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public int getSeq() {
        return seq;
    }

    public void setSeq(int seq) {
        this.seq = seq;
    }

    public void convertFromCreDTO(WtmUserLeaveCreDTO creDTO) {
        this.enterCd = creDTO.getEnterCd();
        this.leaveId = creDTO.getLeaveId();
        this.sabun = creDTO.getSabun();
        this.gntCd = creDTO.getGntCd();
        this.useSYmd = creDTO.getUseSYmd();
        this.useEYmd = creDTO.getUseEYmd();

        // 총발생일수 = 발생기준연차 + 근속에 따른 가산연차 + 월차(근무율80%미만) + 1년미만대상자월차 + 1년미만대상자연차(회계일기준)
        this.creCnt = ((creDTO.getCreAnnualCnt() == null) ? 0 : creDTO.getCreAnnualCnt())
                + ((creDTO.getAddAnnualCnt() == null) ? 0 : creDTO.getAddAnnualCnt())
                + ((creDTO.getMonthlyCnt() == null) ? 0 : creDTO.getMonthlyCnt())
                + ((creDTO.getMonthlyU1yCnt() == null) ? 0 : creDTO.getMonthlyU1yCnt())
                + ((creDTO.getAnnualU1yCnt() == null) ? 0 : creDTO.getAnnualU1yCnt());

        // 이월연차
        this.frdCnt = ((creDTO.getCarryOverCnt() == null) ? 0 : creDTO.getCarryOverCnt());

        // 사용가능일수 = 총발생일수 + 이월연차
        this.useCnt = this.creCnt + this.frdCnt;

        // 사용일수 = 1년미만대상자월차의 경우만 기존 사용한 일수. 나머지는 0
        if (creDTO.getMonthlyU1yCnt() == null || this.usedCnt == null) {
            this.usedCnt = (double) 0;
            this.restCnt = this.useCnt;
        }

        // 1년미만연차(월차) 여부
        this.under1yYn = (creDTO.getMonthlyU1yCnt() != null) ? "Y" : "N";
    }

    @Override
    public String toString() {
        return "{"
                + "\"enterCd\": \"" + this.enterCd + "\""
                + ", \"leaveId\": \"" + this.leaveId + "\""
                + ", \"sabun\": \"" + this.sabun + "\""
                + ", \"gntCd\": \"" + this.gntCd + "\""
                + ", \"useSYmd\": \"" + this.useSYmd + "\""
                + ", \"useEYmd\": \"" + this.useEYmd + "\""
                + ", \"creCnt\": " + this.creCnt
                + ", \"useCnt\": " + this.useCnt
                + ", \"usedCnt\": " + this.usedCnt
                + ", \"restCnt\": " + this.restCnt
                + ", \"frdCnt\": " + this.frdCnt
                + ", \"comCnt\": " + this.comCnt
                + ", \"under1yYn\": \"" + this.under1yYn + "\""
                + ", \"note\": \"" + this.note + "\""
                + "}";
    }

    public static class SYmdComparator implements Comparator<WtmUserLeaveDTO> {

        @Override
        public int compare(WtmUserLeaveDTO o1, WtmUserLeaveDTO o2) {
            if (o1.getUseSDate().isAfter(o2.getUseSDate()))
                return 1;
            else if (o1.getUseSDate().isBefore(o2.getUseSDate()))
                return -1;
            else return 0;
        }
    }
}
