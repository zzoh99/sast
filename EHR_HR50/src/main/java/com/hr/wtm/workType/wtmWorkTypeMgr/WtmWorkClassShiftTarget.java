package com.hr.wtm.workType.wtmWorkTypeMgr;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class WtmWorkClassShiftTarget {

    private String targetCd;
    private String type;
    private String sabun;
    private String oldGroupCd;

    public String getTargetCd() {
        return targetCd;
    }

    public void setTargetCd(String targetCd) {
        this.targetCd = targetCd;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getSabun() {
        return sabun;
    }

    public void setSabun(String sabun) {
        this.sabun = sabun;
    }

    public String getOldGroupCd() {
        return oldGroupCd;
    }

    public void setOldGroupCd(String oldGroupCd) {
        this.oldGroupCd = oldGroupCd;
    }

    public static List<WtmWorkClassShiftTarget> from(Map<String, Object> paramMap) {
        return paramMap.keySet().stream()
                .filter(key -> key.startsWith("targetList["))
                .map(key -> key.replaceAll("\\D+", "")) // 숫자 부분만 추출
                .distinct()
                .map(index -> {
                    String targetCdKey = "targetList[" + index + "].targetCd";
                    String typeKey = "targetList[" + index + "].type";
                    String sabun = "targetList[" + index + "].sabun";
                    String oldGroupCdKey = "targetList[" + index + "].oldGroupCd";

                    WtmWorkClassShiftTarget target = new WtmWorkClassShiftTarget();
                    target.setTargetCd((String) paramMap.get(targetCdKey));
                    target.setType((String) paramMap.get(typeKey));
                    target.setSabun((String) paramMap.get(sabun));
                    target.setOldGroupCd((String) paramMap.get(oldGroupCdKey));

                    return target;
                })
                .collect(Collectors.toList());
    }
}
