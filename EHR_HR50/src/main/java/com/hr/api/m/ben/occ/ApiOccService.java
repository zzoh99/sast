package com.hr.api.m.ben.occ;

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


@Service("ApiOccService")
public class ApiOccService {

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
    public List<?> getOccAppDetMoMap(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        Map<String, Object> result = new LinkedHashMap<>();

        paramMap.put("cmd", "getOccAppDetMap");
        Map<?, ?> resultMap = comService.getDataMap(paramMap);

        List<Map<?, ?>> occCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonCodeList(paramMap, "B60020");
        Optional<Map<?, ?>> occCd = occCdList.stream().filter(map -> resultMap.get("occCd").equals(map.get("code"))).findFirst();

        paramMap.put("occCd", resultMap.get("occCd"));
        paramMap.put("useYn", "Y");
        List<Map<?, ?>> infoCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonNSCodeList(paramMap, "getOccAppDetFamCdList");
        Optional<Map<?, ?>> infoCd = infoCdList.stream().filter(map -> resultMap.get("famCd").equals(map.get("code"))).findFirst();

        List<Map<?, ?>> bankCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonCodeList(paramMap, "H30001");
        Optional<Map<?, ?>> bankCd = bankCdList.stream().filter(map -> resultMap.get("bankCd").equals(map.get("code"))).findFirst();

        List<Map<?, ?>> accCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonCodeList(paramMap, "C00180");
        Optional<Map<?, ?>> accCd = accCdList.stream().filter(map -> resultMap.get("accTypeCd").equals(map.get("code"))).findFirst();

        String occYmd = resultMap.get("occYmd") != null ? StringUtil.formatDate(resultMap.get("occYmd").toString()) : "";
        String occMon = infoCd.get().get("occMon") != null ? NumberUtil.getCommaNumber(Double.parseDouble(infoCd.get().get("occMon").toString()), 3) + "원" : "";
//        String loanReqMon = NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("loanReqMon").toString()), 3);

        String occItem = "";
        if ("Y".equals(resultMap.get("flowerBasketYn"))) occItem += "꽃바구니 ";
        if ("Y".equals(resultMap.get("wreathYn"))) occItem += "경조화환 ";
        if ("Y".equals(resultMap.get("outfitYn"))) occItem += "상조물품 ";
        if ("Y".equals(resultMap.get("giftYn"))) occItem += "축하선물 ";

        result.put("경조구분", occCd.get().get("codeNm"));
        result.put("가족구분", infoCd.get().get("codeNm"));
        result.put("경조일자", occYmd);
        result.put("대상자명", resultMap.get("famNm"));
        result.put("경조금", occMon);
        result.put("휴가일수", resultMap.get("occHoliday") + "일");
        result.put("지원물품", occItem);
        result.put("장수(주소)", resultMap.get("addr"));
        result.put("전화번호", resultMap.get("phoneNo"));
        result.put("계좌구분", accCd.get().get("codeNm"));
        result.put("입금은행", bankCd.get().get("codeNm"));
        result.put("예금주명", resultMap.get("accNm"));
        result.put("계좌번호", resultMap.get("accNo"));
        result.put("기타", resultMap.get("note"));

        // Map을 List로 변환
        List<Map.Entry<String, Object>> list = new ArrayList<>(result.entrySet());

        Log.Debug();
        return list;
    }

}