package com.hr.api.m.ben.resort;

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
import java.util.*;


@Service("ApiResortService")
public class ApiResortService {

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
     * 명함신청 상세 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public List<?> getResortAppDetMoMap(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        Map<String, Object> result = new LinkedHashMap<>();

        paramMap.put("cmd", "getResortAppDetMap");
        Map<?, ?> resultMap = comService.getDataMap(paramMap);

        List<Map<?, ?>> companyCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonCodeList(paramMap, "B49530");
        Optional<Map<?, ?>> companyCd = companyCdList.stream().filter(map -> resultMap.get("companyCd").equals(map.get("code"))).findFirst();

        String sdate = resultMap.get("sdate") != null ? StringUtil.formatDate(resultMap.get("sdate").toString()) : "";
        String edate = resultMap.get("edate") != null ? StringUtil.formatDate(resultMap.get("edate").toString()) : "";
        String resortMon = resultMap.get("resortMon") != null ? NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("resortMon").toString()), 3) : "";
        String comMon = resultMap.get("comMon") != null ? NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("comMon").toString()), 3) : "";
        String psnalMon = resultMap.get("psnalMon") != null ? NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("psnalMon").toString()), 3) : "";

        result.put("리조트명", companyCd.get().get("codeNm"));
        result.put("지점명", resultMap.get("resortNm"));
        result.put("사용기간", sdate + " ~ " + edate );
        result.put("희망순번", resultMap.get("hopeCd")+"지망");
        result.put("객실타입", resultMap.get("roomType"));
        result.put("이용금액", resortMon);
        result.put("지원금액", comMon);
        result.put("개인부담금", psnalMon);
        result.put("연락처", resultMap.get("phoneNo"));
        result.put("메일주소", resultMap.get("mailId"));

        // Map을 List로 변환
        List<Map.Entry<String, Object>> list = new ArrayList<>(result.entrySet());

        Log.Debug();
        return list;
    }

}