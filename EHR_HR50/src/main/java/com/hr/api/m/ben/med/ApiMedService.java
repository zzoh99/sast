package com.hr.api.m.ben.med;

import com.hr.api.common.code.ApiCommonCodeService;
import com.hr.common.com.ComService;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.NumberUtil;
import com.hr.common.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


@Service("ApiMedService")
public class ApiMedService {

    @Inject
    @Named("Dao")
    private Dao dao;

    @Autowired
    @Qualifier("ComService")
    private ComService comService;

    @Autowired
    @Qualifier("ApiCommonCodeService")
    private ApiCommonCodeService apiCommonCodeService;

    /**
     * 경조금신청 상세 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public List<?> getMedAppDetMoMap(Map<String, Object> paramMap, HttpSession session) throws Exception {
        Log.Debug();
        Map<String, Object> result = new LinkedHashMap<>();

        paramMap.put("cmd", "getMedAppDetMap");
        Map<?, ?> resultMap = comService.getDataMap(paramMap);

        Map<String, Object> buyangParams = paramMap;
        buyangParams.put("cmd", "getMedAppDetDpndntYn");
        Map<String, Object> buyang = (Map<String, Object>) comService.getDataMap(buyangParams);

        Map<String, Object> tpmParams = paramMap;
        tpmParams.put("cmd", "getMedAppDetTotalPayMon");
        Map<String, Object> totalPayMon = (Map<String, Object>) comService.getDataMap(tpmParams);

        Map<String, Object> stdParams = paramMap;
        stdParams.put("cmd", "getMedStd");
        stdParams.put("famCd", resultMap.get("famCd"));
        Map<String, Object> medStd = (Map<String, Object>) comService.getDataMap(stdParams);

        Log.Debug(buyang.toString());
        Log.Debug(totalPayMon.toString());
        Log.Debug(medStd.toString());

        String famYmd = resultMap.get("famYmd") != null ? StringUtil.formatDate(resultMap.get("famYmd").toString()) : "";
        String medSYm = medStd.get("medStd") != null ? StringUtil.formatDate(medStd.get("medStd").toString()) : "";
        String stdMon = medStd.get("stdMon") != null ? NumberUtil.getCommaNumber(Double.parseDouble(medStd.get("stdMon").toString()), 3) + "원" : "";
        String totalPayMonVal = totalPayMon.get("totalPayMon") != null ? NumberUtil.getCommaNumber(Double.parseDouble(totalPayMon.get("totalPayMon").toString()), 3) + "원" : "";

        result.put("대상자", famYmd);
        result.put("생년월일/성별", famYmd + " / " + resultMap.get("sexTypeNm"));
        result.put("관계", resultMap.get("famCdNm"));
        result.put("전년도 연말정산 부양가족여부", buyang.get("buyangYn"));
        result.put("병명", resultMap.get("medCode") + " " + resultMap.get("medName"));
        result.put("지원시작년월", medSYm);
        result.put("년간지원받은금액(근로자1인기준)", totalPayMonVal);
        result.put("기준금액(초과금액지원)", stdMon);
        result.put("비고", resultMap.get("note"));

        // Map을 List로 변환
        List<Map.Entry<String, Object>> list = new ArrayList<>(result.entrySet());

        Log.Debug();
        return list;
    }

}