package com.hr.wtm.workType.wtmWorkTypeMgr;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class WtmWorkClassTarget {

    private String targetCd;
    private String type;
    private String sdate;
    private String edate;
    private String oldClassCd;

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

    public String getSdate() {
        return sdate;
    }

    public void setSdate(String sdate) {
        this.sdate = sdate;
    }

    public String getEdate() {
        return edate;
    }

    public void setEdate(String edate) {
        this.edate = edate;
    }

    public String getOldClassCd() {
        return oldClassCd;
    }

    public void setOldClassCd(String oldClassCd) {
        this.oldClassCd = oldClassCd;
    }

    public static List<WtmWorkClassTarget> from(Map<String, Object> paramMap) {
        return paramMap.keySet().stream()
                .filter(key -> key.startsWith("targetList["))
                .map(key -> key.replaceAll("\\D+", "")) // 숫자 부분만 추출
                .distinct()
                .map(index -> {
                    String targetCdKey = "targetList[" + index + "].targetCd";
                    String typeKey = "targetList[" + index + "].type";
                    String sdateKey = "targetList[" + index + "].sdate";
                    String edateKey = "targetList[" + index + "].edate";
                    String oldClassCdKey = "targetList[" + index + "].oldClassCd";

                    WtmWorkClassTarget target = new WtmWorkClassTarget();
                    target.setTargetCd((String) paramMap.get(targetCdKey));
                    target.setType((String) paramMap.get(typeKey));
                    target.setSdate((String) paramMap.get(sdateKey));
                    target.setEdate((String) paramMap.get(edateKey));
                    target.setOldClassCd((String) paramMap.get(oldClassCdKey));

                    return target;
                })
                .collect(Collectors.toList());
    }
}
