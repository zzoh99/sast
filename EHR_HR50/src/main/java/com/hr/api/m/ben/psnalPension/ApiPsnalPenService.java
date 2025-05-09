package com.hr.api.m.ben.psnalPension;

import com.hr.api.common.code.ApiCommonCodeService;
import com.hr.common.com.ComService;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.NumberUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.*;


@Service("ApiPsnalPenService")
public class ApiPsnalPenService {

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
    public List<?> getPsnalPenAppDetMoMap(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        Map<String, Object> result = new LinkedHashMap<>();

        paramMap.put("cmd", "getPsnalPenAppDetMap");
        Map<?, ?> resultMap = comService.getDataMap(paramMap);

        List<Map<?, ?>> pensCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonCodeList(paramMap, "B65110");
        Optional<Map<?, ?>> pensCd = pensCdList.stream().filter(map -> resultMap.get("pensCd").equals(map.get("code"))).findFirst();

        StringBuffer payYm = new StringBuffer(resultMap.get("payYm").toString());
        payYm.insert(4, "-");
        String compMon = resultMap.get("compMon") != null ? NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("compMon").toString()), 3) : "";
        String psnlMon = resultMap.get("psnlMon") != null ? NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("psnlMon").toString()), 3) : "";
        String totMon = resultMap.get("totMon") != null ? NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("totMon").toString()), 3) : "";

        result.put("가입상품", pensCd.get().get("codeNm"));
        result.put("직급", resultMap.get("jikgubNm"));
        result.put("개인부담금", psnlMon);
        result.put("회사지원금", compMon);
        result.put("계", totMon);
        result.put("적용시작년월", payYm);
        result.put("비고", resultMap.get("note"));

        // Map을 List로 변환
        List<Map.Entry<String, Object>> list = new ArrayList<>(result.entrySet());

        Log.Debug();
        return list;
    }

}