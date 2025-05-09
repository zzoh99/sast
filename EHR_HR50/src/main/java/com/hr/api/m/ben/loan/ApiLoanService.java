package com.hr.api.m.ben.loan;

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


@Service("ApiLoanService")
public class ApiLoanService {

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
     * 대출신청 상세 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public List<?> getLoanAppDetMoMap(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        Map<String, Object> result = new LinkedHashMap<>();

        paramMap.put("cmd", "getLoanAppDetMap");
        Map<?, ?> resultMap = comService.getDataMap(paramMap);
        String loanReqYmd = resultMap.get("loanReqYmd") != null ? StringUtil.formatDate(resultMap.get("loanReqYmd").toString()) : "";
        String loanLmtMon = NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("loanLmtMon").toString()), 3);
        String loanReqMon = NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("loanReqMon").toString()), 3);

        List<Map<?, ?>> typeCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonCodeList(paramMap, "B50010");
        Optional<Map<?, ?>> typeCd = typeCdList.stream().filter(map -> resultMap.get("loanCd").equals(map.get("code"))).findFirst();

        List<Map<?, ?>> bankCdList = (List<Map<?, ?>>) apiCommonCodeService.getCommonCodeList(paramMap, "B50010");
        Optional<Map<?, ?>> bankCd = bankCdList.stream().filter(map -> resultMap.get("loanCd").equals(map.get("code"))).findFirst();

        result.put("대출희망일", loanReqYmd);
        result.put("근속개월", resultMap.get("workMonth") + "개월(대출희망일기준)");
        result.put("대출구분", typeCd.get().get("codeNm"));
        result.put("대출처", resultMap.get("loanOrgNm"));
        result.put("대출한도", loanLmtMon + "원");
        result.put("최대상환기간", resultMap.get("stdLoanPeriod") + "개월");
        result.put("제출서류", resultMap.get("loanDoc"));
        result.put("유의사항", resultMap.get("loanNote"));
        result.put("상환기간", resultMap.get("loanReqPeriod") + "개월");
        result.put("이율", resultMap.get("reqIntRate"));
        result.put("대출신청금액", loanReqMon + "원");
        result.put("입금은행", bankCd.get().get("codeNm"));
        result.put("예금주", resultMap.get("accHolder"));
        result.put("계좌번호", resultMap.get("accNo"));
        result.put("비고", resultMap.get("note"));

        // Map을 List로 변환
        List<Map.Entry<String, Object>> list = new ArrayList<>(result.entrySet());

        Log.Debug();
        return list;
    }

    /**
     * 대출상환신청 상세 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public List<?> getLoanRepAppDetMoMap(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        Map<String, Object> result = new LinkedHashMap<>();

        paramMap.put("cmd", "getLoanRepAppDetMap");
        Map<?, ?> resultMap = comService.getDataMap(paramMap);

        List<Map<?, ?>> infoList = (List<Map<?, ?>>) apiCommonCodeService.getCommonNSCodeList(paramMap, "getLoanRepAppDetLoanInfo");
        Optional<Map<?, ?>> loanCd = infoList.stream().filter(map -> (resultMap.get("loanCd") + "_" + resultMap.get("loanYmd")).equals(map.get("code"))).findFirst();

        String repYmd = resultMap.get("repYmd") != null ? StringUtil.formatDate(resultMap.get("repYmd").toString()) : "";
        String loanMon = resultMap.get("loanMon") != null ? NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("loanMon").toString()), 3) + "원" : "";
        String repMon = resultMap.get("repMon") != null ? NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("repMon").toString()), 3) + "원" : "";
        String intMon = resultMap.get("intMon") != null ? NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("intMon").toString()), 3) + "원" : "";
        String totMon = resultMap.get("totMon") != null ? NumberUtil.getCommaNumber(Double.parseDouble(resultMap.get("totMon").toString()), 3) + "원" : "";

        result.put("대출구분", loanCd.get().get("codeNm"));
        result.put("대출금액", loanMon);
        result.put("상환금액(잔액)", repMon);
        result.put("상환일자", repYmd);
        result.put("이자금액", intMon);
        result.put("적용일수", resultMap.get("applyDay")+"일");
        result.put("계", totMon);
        result.put("비고", resultMap.get("note"));

        // Map을 List로 변환
        List<Map.Entry<String, Object>> list = new ArrayList<>(result.entrySet());

        Log.Debug();
        return list;
    }

}