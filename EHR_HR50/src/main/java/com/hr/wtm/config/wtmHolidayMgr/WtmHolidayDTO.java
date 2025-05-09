package com.hr.wtm.config.wtmHolidayMgr;

import java.util.Map;

public class WtmHolidayDTO {

    private String enterCd;
    private String yy; // 년도(양력)
    private String mm; // 월(양력)
    private String dd; // 일(양력)
    private String holidayCd;
    private String holidayNm;
    private String gubun;
    private String festiveYn;
    private String holidayYn;
    private String payYn;
    private String businessPlaceCd;
    private String businessPlaceNm;
    private String rpYy;
    private String rpMm;
    private String rpDd;
    private String repeatYn;
    private String substituteType;
    private String inputDate; // 공휴일 추가시 실제 입력한 일자
    private String addDaysYn = "N";
    private String inputGroupId = "";

    public WtmHolidayDTO() {
    }

    public WtmHolidayDTO(WtmHolidayDTO dto) {
        this.enterCd = dto.enterCd;
        this.yy = dto.yy;
        this.mm = dto.mm;
        this.dd = dto.dd;
        this.holidayCd = dto.holidayCd;
        this.holidayNm = dto.holidayNm;
        this.gubun = dto.gubun;
        this.festiveYn = dto.festiveYn;
        this.holidayYn = dto.holidayYn;
        this.payYn = dto.payYn;
        this.businessPlaceCd = dto.businessPlaceCd;
        this.businessPlaceNm = dto.businessPlaceNm;
        this.rpYy = dto.rpYy;
        this.rpMm = dto.rpMm;
        this.rpDd = dto.rpDd;
        this.repeatYn = dto.repeatYn;
        this.substituteType = dto.substituteType;
        this.inputDate = dto.inputDate;
        this.addDaysYn = dto.addDaysYn;
        this.inputGroupId = dto.inputGroupId;
    }

    public WtmHolidayDTO(WtmHolidayVO vo) {
        this.yy = vo.getYear();
        this.mm = vo.getMonth();
        this.dd = vo.getDay();
        this.holidayNm = vo.getName();
        this.gubun = (vo.isLunarEvent()) ? "2" : "1";
        this.rpYy = vo.getSubYear();
        this.rpMm = vo.getSubMonth();
        this.rpDd = vo.getSubDay();
        this.substituteType = vo.getSubHolidayType();
        this.inputDate = vo.getDate();
        this.addDaysYn = vo.isAddTwoDays() ? "Y" : "N";
    }

    public static WtmHolidayDTO of(Object obj) {
        Map<String, Object> map = (Map<String, Object>) obj;

        WtmHolidayDTO holiday = new WtmHolidayDTO();
        holiday.setEnterCd((String) map.get("enterCd"));
        holiday.setYy((String) map.get("yy"));
        holiday.setMm((String) map.get("mm"));
        holiday.setDd((String) map.get("dd"));
        holiday.setHolidayCd((String) map.get("holidayCd"));
        holiday.setHolidayNm((String) map.get("holidayNm"));
        holiday.setGubun((String) map.get("gubun"));
        holiday.setFestiveYn((String) map.get("festiveYn"));
        holiday.setHolidayYn((String) map.get("holidayYn"));
        holiday.setPayYn((String) map.get("payYn"));
        holiday.setBusinessPlaceCd((String) map.get("businessPlaceCd"));
        holiday.setBusinessPlaceNm((String) map.get("businessPlaceNm"));
        holiday.setRpYy((String) map.get("rpYy"));
        holiday.setRpMm((String) map.get("rpMm"));
        holiday.setRpDd((String) map.get("rpDd"));
        holiday.setRepeatYn((String) map.get("repeatYn"));
        holiday.setSubstituteType((String) map.get("substituteType"));
        holiday.setInputDate((String) map.get("inputDate"));
        holiday.setAddDaysYn((String) map.get("addDaysYn"));
        holiday.setInputGroupId((String) map.get("inputGroupId"));

        return holiday;
    }

    public String getEnterCd() {
        return enterCd;
    }

    public void setEnterCd(String enterCd) {
        this.enterCd = enterCd;
    }

    public String getYy() {
        return yy;
    }

    public void setYy(String yy) {
        this.yy = yy;
    }

    public String getMm() {
        return mm;
    }

    public void setMm(String mm) {
        this.mm = mm;
    }

    public String getDd() {
        return dd;
    }

    public void setDd(String dd) {
        this.dd = dd;
    }

    public String getHolidayCd() {
        return holidayCd;
    }

    public void setHolidayCd(String holidayCd) {
        this.holidayCd = holidayCd;
    }

    public String getHolidayNm() {
        return holidayNm;
    }

    public void setHolidayNm(String holidayNm) {
        this.holidayNm = holidayNm;
    }

    public String getGubun() {
        return gubun;
    }

    public void setGubun(String gubun) {
        this.gubun = gubun;
    }

    public String getFestiveYn() {
        return festiveYn;
    }

    public void setFestiveYn(String festiveYn) {
        this.festiveYn = festiveYn;
    }

    public String getHolidayYn() {
        return holidayYn;
    }

    public void setHolidayYn(String holidayYn) {
        this.holidayYn = holidayYn;
    }

    public String getPayYn() {
        return payYn;
    }

    public void setPayYn(String payYn) {
        this.payYn = payYn;
    }

    public String getBusinessPlaceCd() {
        return businessPlaceCd;
    }

    public void setBusinessPlaceCd(String businessPlaceCd) {
        this.businessPlaceCd = businessPlaceCd;
    }

    public String getBusinessPlaceNm() {
        return businessPlaceNm;
    }

    public void setBusinessPlaceNm(String businessPlaceNm) {
        this.businessPlaceNm = businessPlaceNm;
    }

    public String getRpYy() {
        return rpYy;
    }

    public void setRpYy(String rpYy) {
        this.rpYy = rpYy;
    }

    public String getRpMm() {
        return rpMm;
    }

    public void setRpMm(String rpMm) {
        this.rpMm = rpMm;
    }

    public String getRpDd() {
        return rpDd;
    }

    public void setRpDd(String rpDd) {
        this.rpDd = rpDd;
    }

    public String getRepeatYn() {
        return repeatYn;
    }

    public void setRepeatYn(String repeatYn) {
        this.repeatYn = repeatYn;
    }

    public String getSubstituteType() {
        return substituteType;
    }

    public void setSubstituteType(String substituteType) {
        this.substituteType = substituteType;
    }

    public String getInputDate() {
        return inputDate;
    }

    public void setInputDate(String inputDate) {
        this.inputDate = inputDate;
    }

    public String getAddDaysYn() {
        return addDaysYn;
    }

    public void setAddDaysYn(String addDaysYn) {
        this.addDaysYn = addDaysYn;
    }

    public String getRpDate() {
        return this.rpYy + this.rpMm + this.rpDd;
    }

    public String getInputGroupId() {
        return inputGroupId;
    }

    public void setInputGroupId(String inputGroupId) {
        this.inputGroupId = inputGroupId;
    }
}
