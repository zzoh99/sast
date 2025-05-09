package com.hr.api.m.ben.sch;

import com.hr.api.common.code.ApiCommonCodeService;
import com.hr.api.common.service.ApiComService;
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
import java.util.*;


@Service("ApiSchService")
public class ApiSchService {

    @Inject
    @Named("Dao")
    private Dao dao;

    @Autowired
    @Qualifier("ComService")
    private ComService comService;

    @Autowired
    @Qualifier("ApiCommonCodeService")
    private ApiCommonCodeService apiCommonCodeService;

    @Autowired
    @Qualifier("ApiComService")
    private ApiComService apiComService;

    /**
     * 학자금신청 상세 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public List<?> getSchAppDetMoMap(Map<String, Object> paramMap, HttpSession session) throws Exception {
        Log.Debug();
        Map<String, Object> result = new LinkedHashMap<>();

        paramMap.put("cmd", "getSchAppDetMap");
        Map<?, ?> resultMap = comService.getDataMap(paramMap);

        //학자금구분
        List<Map<?, ?>> typeCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonNSCodeList(paramMap, "getSchAppDetTypeList");
        Optional<Map<?, ?>> typeCd = typeCdList.stream().filter(map -> resultMap.get("schTypeCd").equals(map.get("code"))).findFirst();

        //학자금지원구분
        paramMap.put("schTypeCd", resultMap.get("schTypeCd"));
        List<Map<?, ?>> subCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonNSCodeList(paramMap, "getSchAppDetSupTypeList");
        Optional<Map<?, ?>> subCd = subCdList.stream().filter(map -> resultMap.get("schSupTypeCd").equals(map.get("code"))).findFirst();

        //신청분기
        List<Map<?, ?>> divCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonCodeList(paramMap, "B60060");
        Optional<Map<?, ?>> divCd = divCdList.stream().filter(map -> resultMap.get("divCd").equals(map.get("code"))).findFirst();

        //학자금 기준
        paramMap.put("cmd", "getSchAppDetStdDataList");
        List<Map<?, ?>> stdCdList = (List<Map<?, ?>>) apiComService.getDataList(paramMap, session);
        String schCd = resultMap.get("schTypeCd") + "_" + resultMap.get("schSupTypeCd") + "_" + resultMap.get("famCd");
        Optional<Map<?, ?>> stdCd = stdCdList.stream().filter(map -> schCd.equals(map.get("schCd"))).findFirst();
        String famYmd = resultMap.get("famYmd") != null ? StringUtil.formatDate(resultMap.get("famYmd").toString()) : "";
        String applMon = NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("applMon").toString()), 3);
        String lmtApplMon = NumberUtil.getCommaNumber(Double.parseDouble(stdCd.get().get("applMon").toString()), 3);

        Log.Debug(famYmd);
        Log.Debug(applMon);
        Log.Debug(typeCd.get().toString());
        Log.Debug(subCd.get().toString());
        Log.Debug(divCd.get().toString());

        result.put("학자금구분", typeCd.get().get("codeNm") + " " + subCd.get().get("codeNm"));
        result.put("가족구분", resultMap.get("famCdNm"));
        result.put("대상자", resultMap.get("famNm"));
        result.put("생년월일/성별", famYmd + " / " + resultMap.get("sexType"));
        result.put("신청년도", resultMap.get("appYear"));

        result.put("신청분기", divCd.get().get("codeNm"));
        result.put("학교명", resultMap.get("schName"));
        result.put("입학년월", resultMap.get("schEntYm"));
        result.put("학과명", resultMap.get("schDept"));
        result.put("학년", resultMap.get("schYear"));
        result.put("국내/국외", "1".equals(resultMap.get("appYear")) ? "국외" : "국내");
        result.put("장학금수혜여부", resultMap.get("schPayYn"));
        result.put("외화금액", resultMap.get("extMon"));
        result.put("환율", resultMap.get("excRate"));
        result.put("신청금액", applMon + "원");
        result.put("신청가능금액", lmtApplMon + "원");
        result.put("특이사항", resultMap.get("note"));

        // Map을 List로 변환
        List<Map.Entry<String, Object>> list = new ArrayList<>(result.entrySet());

        Log.Debug();
        return list;
    }

}