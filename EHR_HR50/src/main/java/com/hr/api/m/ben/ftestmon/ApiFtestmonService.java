package com.hr.api.m.ben.ftestmon;

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


@Service("ApiFtestmonService")
public class ApiFtestmonService {

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
     * 어학시험응시료신청 상세 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public List<?> getFtestmonAppDetMoMap(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        Map<String, Object> result = new LinkedHashMap<>();

        paramMap.put("cmd", "getFtestmonAppDetMap");
        Map<?, ?> resultMap = comService.getDataMap(paramMap);

        List<Map<?, ?>> typeCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonCodeList(paramMap, "H20307");
        Optional<Map<?, ?>> testCd = typeCdList.stream().filter(map -> resultMap.get("testCd").equals(map.get("code"))).findFirst();

        String testYmd = resultMap.get("testYmd") != null ? StringUtil.formatDate(resultMap.get("testYmd").toString()) : "";
        String testMon = resultMap.get("testMon") != null ? NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("testMon").toString()), 3) + "원" : "";
        result.put("어학시험", testCd.get().get("codeNm"));
        result.put("시험일자", testYmd);
        result.put("응시료", testMon);
        result.put("비고", resultMap.get("note"));

        if("Y".equals(resultMap.get("adminRecevYn"))){
            String payMon = resultMap.get("payMon") != null ? NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("payMon").toString()), 3) + "원" : "";
            result.put("지급금액", payMon);
            result.put("급여년월", resultMap.get("payYm"));
            result.put("지급메모", resultMap.get("payNote"));
        }
        // Map을 List로 변환
        List<Map.Entry<String, Object>> list = new ArrayList<>(result.entrySet());

        Log.Debug();
        return list;
    }

}