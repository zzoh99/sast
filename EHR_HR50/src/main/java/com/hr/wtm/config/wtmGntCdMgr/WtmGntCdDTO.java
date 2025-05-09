package com.hr.wtm.config.wtmGntCdMgr;

import com.hr.common.util.StringUtil;

import java.util.Map;

public class WtmGntCdDTO {

    private String enterCd;
    private String gntCd;
    private int seq;
    private String gntGubunCd; // 근태종류
    private String gntNm; // 근태코드명
    private boolean isBasicGntCd; // 대표근태코드여부
    private boolean isUse; // 사용여부
    private boolean isMobileUse; // 모바일사용여부
    private String gntShortNm; // 약어
    private String color; // 색상(RGB)
    private String note; // 비고
    private String requestUseType; // 근태신청구분
    private double baseCnt; // 신청최소일수
    private double maxCnt; // 신청최대한도일수
    private boolean isHolIncl; // 휴일포함여부_일수산정시
    private double stdApplyHour; // 적용시간
    private boolean isVacation; // 발생휴가여부
    private boolean isMinusAllow; // 초과사용여부(-허용여부)
    private String orgLevelCd; // 예외결재선코드(N: 결재선유지, W82020)
    private String excpSearchSeq; // 제외대상자조건검색순번
    private int divCnt; // 분할사용횟수

    public WtmGntCdDTO() {}

    public WtmGntCdDTO(Map<String, Object> paramMap) {
        this.enterCd = StringUtil.stringValueOf(paramMap.get("enterCd"));
        this.gntCd = StringUtil.stringValueOf(paramMap.get("gntCd"));
        this.seq = StringUtil.parseInt(StringUtil.stringValueOf(paramMap.get("seq")));
        this.gntGubunCd = StringUtil.stringValueOf(paramMap.get("gntGubunCd"));
        this.gntNm = StringUtil.stringValueOf(paramMap.get("gntNm"));
        this.isBasicGntCd = "Y".equals(paramMap.get("basicGntCdYn"));
        this.isUse = "Y".equals(paramMap.get("useYn"));
        this.isMobileUse = "Y".equals(paramMap.get("mobileUseYn"));
        this.gntShortNm = StringUtil.stringValueOf(paramMap.get("gntShortNm"));
        this.color = StringUtil.stringValueOf(paramMap.get("color"));
        this.note = StringUtil.stringValueOf(paramMap.get("note"));
        this.requestUseType = StringUtil.stringValueOf(paramMap.get("requestUseType"));
        this.baseCnt = StringUtil.parseDouble(StringUtil.stringValueOf(paramMap.get("baseCnt")));
        this.maxCnt = StringUtil.parseDouble(StringUtil.stringValueOf(paramMap.get("maxCnt")));
        this.isHolIncl = "Y".equals(paramMap.get("holInclYn"));
        this.stdApplyHour = StringUtil.parseDouble(StringUtil.stringValueOf(paramMap.get("stdApplyHour")));
        this.isVacation = "Y".equals(paramMap.get("vacationYn"));
        this.isMinusAllow = "Y".equals(paramMap.get("minusAllowYn"));
        this.orgLevelCd = StringUtil.stringValueOf(paramMap.get("orgLevelCd"));
        this.excpSearchSeq = StringUtil.stringValueOf(paramMap.get("excpSearchSeq"));
        this.divCnt = StringUtil.parseInt(StringUtil.stringValueOf(paramMap.get("divCnt")));
    }

    public boolean isMinusAllow() {
        return isMinusAllow;
    }

    @Override
    public String toString() {
        return "{"
                + "\"enterCd\": \"" + this.enterCd + "\""
                + ", \"gntCd\": \"" + this.gntCd + "\""
                + ", \"seq\": " + this.seq
                + ", \"gntGubunCd\": \"" + this.gntGubunCd + "\""
                + ", \"gntNm\": \"" + this.gntNm + "\""
                + ", \"isBasicGntCd\": " + this.isBasicGntCd
                + ", \"isUse\": " + this.isUse
                + ", \"isMobileUse\": " + this.isMobileUse
                + ", \"gntShortNm\": \"" + this.gntShortNm + "\""
                + ", \"color\": \"" + this.color + "\""
                + ", \"note\": \"" + this.note + "\""
                + ", \"requestUseType\": \"" + this.requestUseType + "\""
                + ", \"baseCnt\": " + this.baseCnt
                + ", \"maxCnt\": " + this.maxCnt
                + ", \"isHolIncl\": " + this.isHolIncl
                + ", \"stdApplyHour\": " + this.stdApplyHour
                + ", \"isVacation\": " + this.isVacation
                + ", \"isMinusAllow\": " + this.isMinusAllow
                + ", \"orgLevelCd\": \"" + this.orgLevelCd + "\""
                + ", \"excpSearchSeq\": \"" + this.excpSearchSeq + "\""
                + ", \"divCnt\": " + this.divCnt
                + "}";
    }
}
