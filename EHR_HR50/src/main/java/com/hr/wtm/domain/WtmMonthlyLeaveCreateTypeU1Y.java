package com.hr.wtm.domain;

import com.hr.common.exception.HrException;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public enum WtmMonthlyLeaveCreateTypeU1Y {

    ONE_DAY_BY_MONTH("A", "매월 개근 시 1일 부여"),
    ELEVEN_DAYS_AT_JOIN("B", "입사 시 11일 선부여"),
    DIVIDED_DAYS("C", "회계일 기준 분할 지급");

    private final String code;
    private final String title;
    WtmMonthlyLeaveCreateTypeU1Y(String code, String title) {
        this.code = code;
        this.title = title;
    }

    public String getCode() {
        return this.code;
    }

    public String getTitle() {
        return this.title;
    }

    public static WtmMonthlyLeaveCreateTypeU1Y findByCode(String code) throws HrException {
        return Arrays.stream(WtmMonthlyLeaveCreateTypeU1Y.values())
                .filter(type -> code.equals(type.getCode()))
                .findAny()
                .orElseThrow(() -> new HrException("일치하는 1년 미만 대상자 월차 생성기준이 없습니다. 정확한 생성기준을 입력해주세요."));
    }

    public static List<Map<String, Object>> getCodeList() {
        return Arrays.stream(WtmMonthlyLeaveCreateTypeU1Y.class.getEnumConstants()).map(m -> {
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
