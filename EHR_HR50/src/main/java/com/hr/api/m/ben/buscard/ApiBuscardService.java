package com.hr.api.m.ben.buscard;

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


@Service("ApiBuscardService")
public class ApiBuscardService {

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
    public List<?> getBuscardAppDetMoMap(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        Map<String, Object> result = new LinkedHashMap<>();

        paramMap.put("cmd", "getBuscardAppDetMap");
        Map<?, ?> resultMap = comService.getDataMap(paramMap);

        result.put("성명", resultMap.get("name"));
        result.put("영문성명", resultMap.get("nameEn"));
        result.put("부서명", resultMap.get("orgNm"));
        result.put("영문부서명", resultMap.get("orgNmEn"));
        result.put("직위", resultMap.get("jikweeNm"));
        result.put("영문직위명", resultMap.get("jikweeNmEn"));
        result.put("핸드폰 번호", resultMap.get("phoneNo"));
        result.put("영문 핸드폰번호", resultMap.get("phoneNoEn"));
        result.put("메일주소", resultMap.get("mailId"));
        result.put("전화번호", resultMap.get("telNo"));
        result.put("영문전화번호", resultMap.get("telNoEn"));
        result.put("팩스번호", resultMap.get("faxNo"));
        result.put("영문팩스번호", resultMap.get("faxNoEn"));
        result.put("회사주소", resultMap.get("compAddr"));
        result.put("영문회사주소", resultMap.get("compAddrEn"));
        result.put("명함타입", resultMap.get("cardTypeCd"));
        result.put("비고", resultMap.get("note"));

        // Map을 List로 변환
        List<Map.Entry<String, Object>> list = new ArrayList<>(result.entrySet());

        Log.Debug();
        return list;
    }

}