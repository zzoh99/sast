package com.hr.wtm.config.wtmHolidayMgr;

import com.hr.common.util.DateUtil;

import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

public class WtmKoreanLegalHoliday {

    private String year; // 년도

    public WtmKoreanLegalHoliday(String year) {
        this.year = year;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

    /**
     * 모든 한국의 공휴일을 양력으로 변환하여 조회한다.
     * @return 공휴일 정보 리스트
     */
    public List<WtmHolidayVO> getAllKoreanHolidaySolarCalendar() {
        List<WtmHolidayVO> solarHolidayList = getKoreanSolarHolidayList();
        return getSubSolarHolidayList(solarHolidayList);
    }

    /**
     * DB에서 조회된 리스트를 바탕으로 공휴일을 양력으로 변환하여 조회한다.
     * @param list DB에서 조회된 리스트
     * @return 공휴일 정보 리스트
     */
    public List<WtmHolidayVO> getKoreanHolidaySolarCalendarByDBList(List<WtmHolidayVO> list) {
        List<WtmHolidayVO> solarHolidayList = getSolarCalendarByList(list);
        return getSubSolarHolidayList(solarHolidayList);
    }

    private List<WtmHolidayVO> getKoreanSolarHolidayList() {
        List<WtmHolidayVO> list = new ArrayList<>();

        Arrays.stream(KoreanLegalHolidays.values())
                .forEach(holiday -> {
                    WtmHolidayVO wtmHolidayVo = new WtmHolidayVO(year, holiday);
                    list.add(wtmHolidayVo);
                });

        return getSolarCalendarByList(list);
    }

    private List<WtmHolidayVO> getSolarCalendarByList(List<WtmHolidayVO> holidayList) {
        List<WtmHolidayVO> list = new ArrayList<>();

        AtomicInteger counter = new AtomicInteger(1);
        holidayList.forEach(wtmHolidayVo -> {
            String solarDate = wtmHolidayVo.getDate();

            // 음력일자일 경우
            if (wtmHolidayVo.isLunarEvent())
                solarDate = getSolarDate(solarDate);

            // 앞뒤로 하루씩 추가되어야 할 경우
            if (wtmHolidayVo.isAddTwoDays()) {
                for (int i = -1 ; i <= 1 ; i++) {
                    WtmHolidayVO newVo = new WtmHolidayVO(wtmHolidayVo);
                    String tmpSolarDate = DateUtil.convertLocalDateToString(DateUtil.getLocalDate(solarDate).plusDays(i));
                    newVo.setDate(tmpSolarDate);
                    newVo.setId(counter.getAndIncrement()+"");
                    list.add(newVo);
                }
            } else {
                wtmHolidayVo.setDate(solarDate);
                wtmHolidayVo.setId(counter.getAndIncrement()+"");
                list.add(wtmHolidayVo);
            }
        });

        return list;
    }

    private String getSolarDate(String lunarDate) {

        String[] dateArr = DateUtil.convertLocalDateToString(DateUtil.getLocalDate(lunarDate, "yyyyMMdd"), "yyyy-MM-dd").split("-");

        KoreanLunarCalendar calendar = KoreanLunarCalendar.getInstance();
        calendar.setLunarDate(Integer.parseInt(dateArr[0]), Integer.parseInt(dateArr[1]), Integer.parseInt(dateArr[2]), false); // 음력 -> 양력으로 변환
        return calendar.getSolarIsoFormat().replaceAll("[-]", "");
    }

    /**
     * 토요일인지 여부
     * @param solarDate 일자 (yyyyMMdd)
     * @return 토요일인지 여부
     */
    private boolean isSaturday(String solarDate) {
        return (DateUtil.getLocalDate(solarDate).getDayOfWeek().getValue() == 6);
    }

    /**
     * 일요일인지 여부
     * @param solarDate 일자 (yyyyMMdd)
     * @return 일요일인지 여부
     */
    private boolean isSunday(String solarDate) {
        return (DateUtil.getLocalDate(solarDate).getDayOfWeek().getValue() == 7);
    }

    /**
     * 조회된 양력 공휴일 리스트를 바탕으로 대한민국 헌법상의 대체공휴일을 생성한다.
     * @param solarHolidayList 양력 공휴일 리스트
     * @return 대체공휴일이 적용된 양력 공휴일 리스트
     */
    public List<WtmHolidayVO> getSubSolarHolidayList(List<WtmHolidayVO> solarHolidayList) {
        solarHolidayList.forEach(wtmHolidayVo -> {

            String solarDate = wtmHolidayVo.getDate();
            String id = wtmHolidayVo.getId();

            // 법령 시작여부
            boolean isLegalStart =
                    (
                            wtmHolidayVo.getSubHolidaySYear() == null
                                    || "".equals(wtmHolidayVo.getSubHolidaySYear())
                                    || !( DateUtil.getLocalDate(year + "0101").isBefore(DateUtil.getLocalDate(wtmHolidayVo.getSubHolidaySYear() + "0101")) )
                    );
            // 대체공휴일을 생성해야할지 여부
            boolean isMakeSubDay =
                    (
                        ( "A".equals(wtmHolidayVo.getSubHolidayType()) && isLegalStart && ( isSunday(solarDate) || isDuplicated(solarDate, id, solarHolidayList) ) ) // 일요일과 중복 공휴일 대체휴일
                        ||
                        ( "B".equals(wtmHolidayVo.getSubHolidayType()) && isLegalStart && ( isSaturday(solarDate) || isSunday(solarDate) || isDuplicated(solarDate, id, solarHolidayList) ) ) // 토, 일요일과 중복 공휴일 대체휴일
                    );
            if (isMakeSubDay) {
                String subDate = getSubDate(solarDate, id, solarHolidayList, wtmHolidayVo.getSubHolidayType());
                wtmHolidayVo.setSubDate(subDate);
            }
        });

        return solarHolidayList;
    }

    private boolean isDuplicated(String solarDate, String id, List<WtmHolidayVO> list) {
        return list.stream().anyMatch(wtmHolidayVo ->
                !id.equals(wtmHolidayVo.getId()) && solarDate.equals(wtmHolidayVo.getDate()));
    }

    private String getSubDate(String solarDate, String id, List<WtmHolidayVO> list, String subType) {
        if (!"A".equals(subType) && !"B".equals(subType)) return solarDate;

        String tmpSolarDate = DateUtil.convertLocalDateToString(DateUtil.getLocalDate(solarDate).plusDays(1));
        boolean isInvalid;
        if ("A".equals(subType)) {
            isInvalid = (isDuplicated(tmpSolarDate, id, list) || isSunday(tmpSolarDate));
        } else {
            isInvalid = (isDuplicated(tmpSolarDate, id, list) || isSunday(tmpSolarDate) || isSaturday(tmpSolarDate));
        }

        if (isInvalid) {
            return getSubDate(tmpSolarDate, id, list, subType);
        } else {
            return tmpSolarDate;
        }
    }
}
