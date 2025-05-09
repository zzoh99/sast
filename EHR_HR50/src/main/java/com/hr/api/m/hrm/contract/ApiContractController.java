package com.hr.api.m.hrm.contract;

import com.hr.common.com.ComService;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.rd.RdInvokerService;
import com.hr.hrm.empContract.perEmpContractSrch.PerEmpContractSrchService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping(value="/api/v5/contract")
public class ApiContractController {

    @Inject
    @Named("PerEmpContractSrchService")
    private PerEmpContractSrchService perEmpContractSrchService;

    @Inject
    @Named("RdInvokerService")
    private RdInvokerService rdInvokerService;

    @Inject
    @Named("ComService")
    private ComService comService;

    @Value("${rd.image.base.url}")
    private String imageBaseUrl;

    /**
     * perEmpContractSrch 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getPerEmpContractSrchList")
    public Map<String, Object> getPerEmpContractSrchList(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = perEmpContractSrchService.getPerEmpContractSrchList(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("Message", Message);
        Log.DebugEnd();
        return result;
    }

    @RequestMapping(value = "/downReport")
    public void downReport(
            HttpSession session, HttpServletRequest request
            , HttpServletResponse response
            , @RequestBody Map<String, Object> paramMap) throws Exception{
        Log.DebugStart();

        String ssnEnterCd = session.getAttribute("ssnEnterCd").toString();
        String mrdPath = paramMap.get("mrdPath").toString();

        paramMap.put("str", paramMap.get("rk")+"");
        paramMap.put("enterCd", ssnEnterCd);
        paramMap.put("encType", "A");
        Log.Debug(paramMap.toString());
        String decStr = comService.getComDecRtnStr(paramMap, "getDecryptByEncType");
        //반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.

        String[] splited = decStr.split("#") ;

        String param = "";
        if(paramMap.containsKey("rp")){
            param += "/rp ";
            Map<String, String> rpMap = (Map<String, String>) paramMap.get("rp");
            param += "[" + ssnEnterCd + "] [(('" + splited[0] +"','"+ splited[1]+"','"+rpMap.get("stdDate")+"'))] [" + imageBaseUrl + "]";
        }

        paramMap.put("mrdPath", mrdPath);
        paramMap.put("rdParam", param);
        paramMap.put("enterCd", ssnEnterCd);

        // 서버에 다운로드 처리
//        Map res = rdInvokerService.invokeToFile(paramMap, true, "pdf", null);
//        Log.Debug("파일 다운로드 경로: " +res.get("saveFileName").toString());

        // 서비스에서 byte[] 데이터를 받아옴
        byte[] rdData = rdInvokerService.invokeToByteArray(paramMap, true,"pdf", "report");

        // 응답 헤더 설정 (PDF 다운로드로 설정)
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"report.pdf\"");
        response.setContentLength(rdData.length);  // 데이터 크기를 설정

        // 클라이언트로 데이터 전송
        try (OutputStream os = response.getOutputStream()) {
            os.write(rdData);
            os.flush();
        } catch (Exception e) {
            Log.Debug("rd 데이터 전송 에러");
            e.printStackTrace();
        }

        Log.DebugEnd();
    }

    /**
     * perEmpContractSrch 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/savePerEmpContractSrch")
    public Map<String, Object> savePerEmpContractSrch(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();
        Log.Debug(paramMap.toString());
        String ssnSabun = session.getAttribute("ssnSabun").toString();
        String ssnEnterCd = session.getAttribute("ssnEnterCd").toString();

        List<Map<String, Object>> mergeRows = new ArrayList<>();
        Map<String, Object> mergeRow = new HashMap<>();
        mergeRow.put("sabun", ssnSabun);
        mergeRow.put("fileSeq", paramMap.get("fileSeq"));
        mergeRow.put("stdDate", paramMap.get("stdDate"));
        mergeRow.put("contType", paramMap.get("contType"));
        mergeRow.put("agreeYn", paramMap.get("agreeYn"));
        mergeRows.add(mergeRow);

        Map<String, Object> convertMap = new HashMap<>();
        convertMap.put("ssnSabun", ssnSabun);
        convertMap.put("ssnEnterCd",ssnEnterCd);
        convertMap.put("mergeRows", mergeRows);
        convertMap.put("deleteRows", new ArrayList<>());

        String message = "";
        int resultCnt = -1;
        try{
            Log.Debug(paramMap.toString());
            resultCnt =perEmpContractSrchService.savePerEmpContractSrch(convertMap);
            if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
        }catch(Exception e){
            resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
            Log.Debug(e.getMessage());
        }

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("Code", resultCnt);
        result.put("Message", message);
        Log.DebugEnd();

        return result;
    }
}
