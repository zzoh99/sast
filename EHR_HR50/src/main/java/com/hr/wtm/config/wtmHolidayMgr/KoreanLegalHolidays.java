package com.hr.wtm.config.wtmHolidayMgr;

public enum KoreanLegalHolidays {

    NEW_YEAR("설날(신정)", "0101", false, false, "N", ""),
    LUNAR_NEW_YEAR("설날(구정)", "0101", true, true, "A", "2014"),
    SAMILJEOL("삼일절", "0301", false, false, "B", "2022"),
    LABOR_DAY("근로자의날", "0501", false, false, "N", ""),
    CHILD_DAY("어린이날", "0505", false, false, "B", "2014"),
    BUDDHA_DAY("부처님오신날", "0408", true, false, "B", "2023"),
    MEMORIAL_DAY("현충일", "0606", false, false, "N", ""),
    LIBERATION_DAY("광복절", "0815", false, false, "B", "2021"),
    FOUNDATION_DAY("개천절", "1003", false, false, "B", "2021"),
    CHUSEOK("추석", "0815", true, true, "A", "2014"),
    HANGUL_DAY("한글날", "1009", false, false, "B", "2021"),
    CHRISTMAS("성탄절", "1225", false, false, "B", "2023");

    private final String title; // 명절이름
    private final String date; // 월일
    private final boolean isLunarEvent; // 음력 명절인지 여부
    private final boolean isAddTwoDays; // 앞뒤로 하루씩 추가할지 여부
    private final String subHolidayType; // 대체공휴일 타입 (N: 대체공휴일 지정안함, A: 일요일 및 다른 공휴일과 겹칠 경우 적용, B: 토요일, 일요일 및 다른 공휴일과 겹칠 경우 적용)
    private final String subHolidaySYear; // 대체공휴일 적용 시작년도

    KoreanLegalHolidays(String title, String date, boolean isLunarEvent, boolean isAddTwoDays, String subHolidayType, String subHolidaySYear) {
        this.title = title;
        this.date = date;
        this.isLunarEvent = isLunarEvent;
        this.isAddTwoDays = isAddTwoDays;
        this.subHolidayType = subHolidayType;
        this.subHolidaySYear = subHolidaySYear;
    }

    public String getTitle() {
        return title;
    }

    public String getDate() {
        return date;
    }

    public boolean isLunarEvent() {
        return isLunarEvent;
    }

    public boolean isAddTwoDays() {
        return isAddTwoDays;
    }

    public String getSubHolidayType() {
        return subHolidayType;
    }

    public String getSubHolidaySYear() {
        return subHolidaySYear;
    }

    @Override
    public String toString() {
        return "{title=" + this.title + ", date=" + this.date + ", isLunarEvent=" + this.isLunarEvent + ", isAddTwoDays=" + this.isAddTwoDays + ", subHolidayType=" + this.subHolidayType + ", subHolidaySYear=" + subHolidaySYear + "}";
    }
}
