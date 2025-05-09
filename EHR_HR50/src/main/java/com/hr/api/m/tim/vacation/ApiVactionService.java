package com.hr.api.m.tim.vacation;

import com.hr.api.common.code.ApiCommonCodeService;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.*;


@Service("ApiVactionService")
public class ApiVactionService {

    @Inject
    @Named("Dao")
    private Dao dao;

    @Autowired
    @Qualifier("ApiCommonCodeService")
    private ApiCommonCodeService apiCommonCodeService;

    /**
     * 근태신청 상세 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public List<?> getVacationAppDetMoMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<String, Object> result = new LinkedHashMap<>();
        Map<?, ?> resultMap = dao.getMap("getVacationAppDetList", paramMap);
        String applYmd = StringUtil.formatDate(paramMap.get("searchApplYmd").toString());
        String sYmd = StringUtil.formatDate(resultMap.get("sYmd").toString());
        String eYmd = StringUtil.formatDate(resultMap.get("eYmd").toString());

        result.put("휴가신청일", applYmd);

        List<Map<?, ?>> gubunCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonNSCodeList(paramMap, "getVacationAppDetGntGubunList");
        Optional<Map<?, ?>> gubunCd = gubunCdList.stream().filter(map -> resultMap.get("gntGubunCd").equals(map.get("code"))).findFirst();
        result.put("근태구분", gubunCd.get().get("codeNm"));

        List<Map<?, ?>> gntCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonNSCodeList(paramMap, "getCpnGntCdList2");
        Optional<Map<?, ?>> gntCd = gntCdList.stream().filter(map -> resultMap.get("gntCd").equals(map.get("code"))).findFirst();
        result.put("근태", gntCd.get().get("codeNm"));

        //경조후가
        if(resultMap.get("occCd") != null && !"".equals(resultMap.get("occCd"))){
            List<Map<?, ?>> occCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonNSCodeList(paramMap, "getVacationAppDetOccCd");
            Optional<Map<?, ?>> occCd = occCdList.stream().filter(map -> resultMap.get("occFamCd").equals(map.get("code"))).findFirst();

            if (occCd.isPresent()) {
                result.put("경조구분", occCd.get().get("codeNm"));
                Log.Debug("경조구분: " + result);
            }
            result.put("경조일자", resultMap.get("occYmd"));
        }

        //일시 set
        if(!"".equals(resultMap.get("reqSHm")) && !"".equals(resultMap.get("reqEHm"))){
            result.put("신청일자", sYmd);
            result.put("시작시간", resultMap.get("reqSHm"));
            result.put("종료시간", resultMap.get("reqEHm"));
            result.put("적용시간", resultMap.get("requestHour"));
        }else{
            result.put("신청일자", sYmd + " ~ " + eYmd);
            result.put("총일수", resultMap.get("holDay"));
            result.put("적용일수", resultMap.get("closeDay"));
        }

        //사용 연차휴가
        if("Y".equals(gubunCd.get().get("gntUse"))){
            Map<String, Object> occCdParams = (Map<String, Object>) paramMap;
            occCdParams.put("searchSabun", paramMap.get("ssnSabun"));
            occCdParams.put("searchGntCd1", gubunCd.get().get("code"));
            occCdParams.put("searchGntCd2", gntCd.get().get("code"));
            occCdParams.put("sYmd", resultMap.get("sYmd"));
            occCdParams.put("eYmd", resultMap.get("eYmd"));
            List<Map<?, ?>> useTargetAnnualList = (List<Map<?, ?>>) apiCommonCodeService.getCommonNSCodeList(paramMap, "getVacationAppUseCdList");
            Optional<Map<?, ?>> useTargetAnnual = useTargetAnnualList.stream().filter(map -> resultMap.get("useTargetAnnual").equals(map.get("code"))).findFirst();
            result.put("사용연차휴가", useTargetAnnual.get().get("codeNm"));
        }

        // Map을 List로 변환
        List<Map.Entry<String, Object>> list = new ArrayList<>(result.entrySet());

        Log.Debug();
        return list;
    }
    /**
     * 근태신청 상세 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public List<?> getVacationUpdAppDetMoMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<String, Object> result = new LinkedHashMap<>();
        Map<?, ?> resultMap = dao.getMap("getVacationUpdAppDetMap", paramMap);
        String applYmd = StringUtil.formatDate(paramMap.get("searchApplYmd").toString());
        String sYmd = StringUtil.formatDate(resultMap.get("sYmd").toString());
        String eYmd = StringUtil.formatDate(resultMap.get("eYmd").toString());

        result.put("휴가신청일", applYmd);

        List<Map<?, ?>> gubunCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonNSCodeList(paramMap, "getVacationAppDetGntGubunList");
        Optional<Map<?, ?>> gubunCd = gubunCdList.stream().filter(map -> resultMap.get("gntGubunCd").equals(map.get("code"))).findFirst();
        result.put("근태구분", gubunCd.get().get("codeNm"));

        List<Map<?, ?>> gntCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonNSCodeList(paramMap, "getCpnGntCdList2");
        Optional<Map<?, ?>> gntCd = gntCdList.stream().filter(map -> resultMap.get("gntCd").equals(map.get("code"))).findFirst();
        result.put("근태", gntCd.get().get("codeNm"));

        //경조후가
        if(resultMap.get("occCd") != null && !"".equals(resultMap.get("occCd"))){
            List<Map<?, ?>> occCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonNSCodeList(paramMap, "getVacationAppDetOccCd");
            Optional<Map<?, ?>> occCd = occCdList.stream().filter(map -> resultMap.get("occFamCd").equals(map.get("code"))).findFirst();

            if (occCd.isPresent()) {
                result.put("경조구분", occCd.get().get("codeNm"));
                Log.Debug("경조구분: " + result);
            }
            result.put("경조일자", resultMap.get("occYmd"));
        }

        //일시 set
        if(!"".equals(resultMap.get("reqSHm")) && !"".equals(resultMap.get("reqEHm"))){
            result.put("신청일자", sYmd);
            result.put("시작시간", resultMap.get("reqSHm"));
            result.put("종료시간", resultMap.get("reqEHm"));
            result.put("적용시간", resultMap.get("requestHour"));
        }else{
            result.put("신청일자", sYmd + " ~ " + eYmd);
            result.put("총일수", resultMap.get("holDay"));
            result.put("적용일수", resultMap.get("closeDay"));
        }

        //사용 연차휴가
        if("Y".equals(gubunCd.get().get("gntUse"))){
            Map<String, Object> occCdParams = (Map<String, Object>) paramMap;
            occCdParams.put("searchSabun", paramMap.get("ssnSabun"));
            occCdParams.put("searchGntCd1", gubunCd.get().get("code"));
            occCdParams.put("searchGntCd2", gntCd.get().get("code"));
            occCdParams.put("sYmd", resultMap.get("sYmd"));
            occCdParams.put("eYmd", resultMap.get("eYmd"));
            List<Map<?, ?>> useTargetAnnualList = (List<Map<?, ?>>) apiCommonCodeService.getCommonNSCodeList(paramMap, "getVacationAppUseCdList");
            Optional<Map<?, ?>> useTargetAnnual = useTargetAnnualList.stream().filter(map -> resultMap.get("useTargetAnnual").equals(map.get("code"))).findFirst();
            result.put("사용연차휴가", useTargetAnnual.get().get("codeNm"));
        }

        // Map을 List로 변환
        List<Map.Entry<String, Object>> list = new ArrayList<>(result.entrySet());

        Log.Debug();
        return list;
    }

}