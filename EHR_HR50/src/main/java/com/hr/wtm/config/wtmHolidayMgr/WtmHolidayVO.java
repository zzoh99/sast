package com.hr.wtm.config.wtmHolidayMgr;

import com.hr.common.util.DateUtil;

import java.lang.reflect.Field;
import java.util.*;

public class WtmHolidayVO {

    private String id;
    private String date; // 양력 일자
    private String name;
    private boolean isLunarEvent = false; // 음력 공휴일 여부
    private boolean isAddTwoDays = false; // 앞 뒤로 하루씩 추가할지 여부(설날, 추석)
    private String subHolidayType = "N"; // 대체공휴일 타입 (N: 대체공휴일 지정안함, A: 일요일 및 다른 공휴일과 겹칠 경우 적용, B: 토요일, 일요일 및 다른 공휴일과 겹칠 경우 적용)
    private String subHolidaySYear; // 대체공휴일 적용 시작년도
    private String subDate = ""; // 대체공휴일 일자(YYYYMMDD)
    private String inputDate = ""; // 추가할 때 실제 입력한 일자
    private WtmHolidayDTO wtmHolidayDTO;
    private Map<String, Object> wtmHolidayMap = new HashMap<>();

    public WtmHolidayVO(String id, String date, String name, boolean isLunarEvent, boolean isAddTwoDays, String subHolidayType, String subHolidaySYear) {
        this.id = id;
        this.date = date;
        this.name = name;
        this.isLunarEvent = isLunarEvent;
        this.isAddTwoDays = isAddTwoDays;
        this.subHolidayType = subHolidayType;
        this.subHolidaySYear = subHolidaySYear;
    }

    public WtmHolidayVO(WtmHolidayVO vo) {
        this.id = vo.id;
        this.date = vo.date;
        this.name = vo.name;
        this.isLunarEvent = vo.isLunarEvent;
        this.isAddTwoDays = vo.isAddTwoDays;
        this.subHolidayType = vo.subHolidayType;
        this.subHolidaySYear = vo.subHolidaySYear;
        this.subDate = vo.subDate;
        this.inputDate = vo.inputDate;
        this.wtmHolidayDTO = vo.wtmHolidayDTO;
    }

    public WtmHolidayVO(String year, KoreanLegalHolidays holiday) {
        this.date = year + holiday.getDate();
        this.name = holiday.getTitle();
        this.isLunarEvent = holiday.isLunarEvent();
        this.isAddTwoDays = holiday.isAddTwoDays();
        this.subHolidayType = holiday.getSubHolidayType();
        this.subHolidaySYear = holiday.getSubHolidaySYear();
        this.inputDate = year + holiday.getDate();
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isLunarEvent() {
        return isLunarEvent;
    }

    public void setLunarEvent(boolean lunarEvent) {
        isLunarEvent = lunarEvent;
    }

    public boolean isAddTwoDays() {
        return isAddTwoDays;
    }

    public void setAddTwoDays(boolean addTwoDays) {
        isAddTwoDays = addTwoDays;
    }

    public String getSubHolidayType() {
        return subHolidayType;
    }

    public void setSubHolidayType(String subHolidayType) {
        this.subHolidayType = subHolidayType;
    }

    public String getSubHolidaySYear() {
        return subHolidaySYear;
    }

    public void setSubHolidaySYear(String subHolidaySYear) {
        this.subHolidaySYear = subHolidaySYear;
    }

    public String getSubDate() {
        return subDate;
    }

    public void setSubDate(String subDate) {
        this.subDate = subDate;
    }

    public String getInputDate() {
        return inputDate;
    }

    public void setInputDate(String inputDate) {
        this.inputDate = inputDate;
    }

    public WtmHolidayDTO getWtmHoliday() {
        return wtmHolidayDTO;
    }

    public void setWtmHoliday(WtmHolidayDTO wtmHolidayDTO) {
        this.wtmHolidayDTO = wtmHolidayDTO;
    }

    public Map<String, Object> getWtmHolidayMap() {
        return wtmHolidayMap;
    }

    public void setWtmHolidayMap(Map<String, Object> wtmHolidayMap) {
        this.wtmHolidayMap = wtmHolidayMap;
    }

    public String getFinalDate() {
        return (this.subDate != null && !this.subDate.isEmpty()) ? this.subDate : this.date;
    }

    public String getFinalYear() {
        return DateUtil.convertLocalDateToString(DateUtil.getLocalDate(getFinalDate()), "yyyy");
    }

    public String getFinalMonth() {
        return DateUtil.convertLocalDateToString(DateUtil.getLocalDate(getFinalDate()), "MM");
    }

    public String getFinalDay() {
        return DateUtil.convertLocalDateToString(DateUtil.getLocalDate(getFinalDate()), "dd");
    }

    public String getYear() {
        return DateUtil.convertLocalDateToString(DateUtil.getLocalDate(this.date), "yyyy");
    }

    public String getMonth() {
        return DateUtil.convertLocalDateToString(DateUtil.getLocalDate(this.date), "MM");
    }

    public String getDay() {
        return DateUtil.convertLocalDateToString(DateUtil.getLocalDate(this.date), "dd");
    }

    public String getSubYear() {
        return (this.subDate != null && !this.subDate.isEmpty()) ? DateUtil.convertLocalDateToString(DateUtil.getLocalDate(this.subDate), "yyyy") : "";
    }

    public String getSubMonth() {
        return (this.subDate != null && !this.subDate.isEmpty()) ? DateUtil.convertLocalDateToString(DateUtil.getLocalDate(this.subDate), "MM") : "";
    }

    public String getSubDay() {
        return (this.subDate != null && !this.subDate.isEmpty()) ? DateUtil.convertLocalDateToString(DateUtil.getLocalDate(this.subDate), "dd") : "";
    }

    public Set<String> getKeySet() {
        Set<String> keySet = new HashSet<>();
        Field[] fields = this.getClass().getDeclaredFields();

        Arrays.stream(fields).forEach(field -> {
            field.setAccessible(true);
            keySet.add(field.getName());
        });

        return keySet;
    }

    @Override
    public String toString() {
        return "{id=" + this.id +
                ", date=" + this.date +
                ", name=" + this.name +
                ", isLunarEvent=" + this.isLunarEvent +
                ", isAddTwoDays=" + this.isAddTwoDays +
                ", subHolidayType=" + this.subHolidayType +
                ", subHolidaySYear=" + this.subHolidaySYear +
                ", subDate=" + this.subDate +
                ", inputDate=" + this.inputDate + "}";
    }
}
