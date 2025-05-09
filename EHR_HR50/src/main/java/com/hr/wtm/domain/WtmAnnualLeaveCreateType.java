package com.hr.wtm.domain;

import com.hr.common.exception.HrException;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public enum WtmAnnualLeaveCreateType {

    EMPLOYEE_DATE("A", "입사일"),
    FINANCIAL_DATE("B", "회계일"),
    EMPLOYEE_MONTH("C", "입사월");

    private final String code;
    private final String title;
    WtmAnnualLeaveCreateType(String code, String title) {
        this.code = code;
        this.title = title;
    }

    public String getCode() {
        return this.code;
    }

    public String getTitle() {
        return this.title;
    }

    public static WtmAnnualLeaveCreateType findByCode(String code) throws HrException {
        return Arrays.stream(WtmAnnualLeaveCreateType.values())
                .filter(type -> code.equals(type.getCode()))
                .findAny()
                .orElseThrow(() -> new HrException("일치하는 연차생성기준이 없습니다. 정확한 연차생성기준을 입력해주세요."));
    }

    public static List<Map<String, Object>> getCodeList() {
        return Arrays.stream(WtmAnnualLeaveCreateType.class.getEnumConstants()).map(m -> {
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
