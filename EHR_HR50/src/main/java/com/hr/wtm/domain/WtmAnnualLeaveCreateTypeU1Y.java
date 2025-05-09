package com.hr.wtm.domain;

import com.hr.common.exception.HrException;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public enum WtmAnnualLeaveCreateTypeU1Y {

    CALCED_DAYS_AT_FIN_DATE("A", "첫 회계일에 근무기간 대비 연차 부여"),
    FIFTEEN_DAYS_AT_FIN_DATE("B", "첫 회계일에 15일 부여"),
    GET_LEAVE_DAYS_AT_JOIN("C", "입사일에 첫 회계일까지 근무기간 대비 연차 선부여");

    private final String code;
    private final String title;
    WtmAnnualLeaveCreateTypeU1Y(String code, String title) {
        this.code = code;
        this.title = title;
    }

    public String getCode() {
        return this.code;
    }

    public String getTitle() {
        return this.title;
    }

    public static WtmAnnualLeaveCreateTypeU1Y findByCode(String code) throws HrException {
        return Arrays.stream(WtmAnnualLeaveCreateTypeU1Y.values())
                .filter(type -> code.equals(type.getCode()))
                .findAny()
                .orElseThrow(() -> new HrException("일치하는 1년 미만 대상자 연차 생성기준이 없습니다. 정확한 생성기준을 입력해주세요."));
    }

    public static List<Map<String, Object>> getCodeList() {
        return Arrays.stream(WtmAnnualLeaveCreateTypeU1Y.class.getEnumConstants()).map(m -> {
            Map<String, Object> map = new HashMap<>();
            map.put("code", m.getCode());
            map.put("title", m.getTitle());
            return map;
        }).collect(Collectors.toList());
    }

    @Override
    public String toString() {
        return "{"
                + "\"code\": \"" + this.code + "\""
                + ", \"title\": \"" + this.title + "\""
                + "}";
    }
}
