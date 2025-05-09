package com.hr.api.m.ben.club;

import com.hr.api.common.code.ApiCommonCodeService;
import com.hr.common.com.ComService;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


@Service("ApiClubService")
public class ApiClubService {

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
    public List<?> getClubpayAppDetMoMap(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        Map<String, Object> result = new LinkedHashMap<>();

        paramMap.put("cmd", "getClubpayAppDetMap");
        Map<?, ?> resultMap = comService.getDataMap(paramMap);

//        List<Map<?, ?>> infoList = (List<Map<?, ?>>) apiCommonCodeService.getCommonNSCodeList(paramMap, "getLoanRepAppDetLoanInfo");
//        Optional<Map<?, ?>> loanCd = infoList.stream().filter(map -> (resultMap.get("loanCd") + "_" + resultMap.get("loanYmd")).equals(map.get("code"))).findFirst();

        result.put("동호회명", resultMap.get("name"));
        result.put("신청분기", resultMap.get("nameEn"));
        result.put("회원수", resultMap.get("orgNm"));
        result.put("회장", resultMap.get("orgNmEn"));
        result.put("총무", resultMap.get("jikweeNm"));
        result.put("신청금액", resultMap.get("jikweeNmEn"));
        result.put("입금은행", resultMap.get("phoneNo"));
        result.put("예금주", resultMap.get("phoneNoEn"));
        result.put("계좌번호", resultMap.get("mailId"));

        // Map을 List로 변환
        List<Map.Entry<String, Object>> list = new ArrayList<>(result.entrySet());

        Log.Debug();
        return list;
    }

}