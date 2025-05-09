package com.hr.wtm.domain;

import com.hr.common.logger.Log;

public class WtmUtils {

    /**
     * 최대 지급 가능 연차 개수
     */
    public static final int MAX_ANNUAL_LEAVE_CNT = 25;

    /**
     * 발생 기준연차
     */
    public static final double CRE_ANNUAL_LEAVE_CNT = 15;

    public static double getUpDownUnitValue(String upbase, String unit, double value) {
        double v = value * Integer.parseInt(unit);

        if ("1".equals(upbase) || "N".equals(upbase)) return value; // 사용안함
        else if ("3".equals(upbase) || "C".equals(upbase)) {
            // 절상
            return Math.ceil(v) / Double.parseDouble(unit+".0");
        } else if ("5".equals(upbase) || "F".equals(upbase)) {
            // 절사
            return Math.floor(v) / Double.parseDouble(unit+".0");
        } else if ("7".equals(upbase) || "R".equals(upbase)) {
            // 반올림
            return Math.round(v) / Double.parseDouble(unit+".0");
        } else {
            Log.Error("허용되지 않는 올림기준입니다. 소수점 처리 방법을 확인해주세요.");
            return value;
        }
    }
}
