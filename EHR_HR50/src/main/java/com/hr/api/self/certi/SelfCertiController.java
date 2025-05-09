package com.hr.api.self.certi;

import com.hr.api.common.util.JweToken;
import com.hr.api.self.common.SelfCommonService;
import com.hr.api.self.login.SelfLoginService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
import com.hr.common.rd.RdInvokerService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.StringUtil;
import com.hr.hrm.certificate.certiApp.CertiAppService;
import com.hr.hrm.certificate.certiAppDet.CertiAppDetService;
import com.hr.hrm.retire.retireApr.RetireAprService;
import com.nhncorp.lucy.security.xss.XssPreventer;
import com.nimbusds.jwt.SignedJWT;
import org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.expression.Expression;
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.StandardEvaluationContext;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 셀프서비스 제증명신청 Controller
 *
 * @author bckim
 *
 */
@RestController
@RequestMapping(value="/api/v5/self/certi")
public class SelfCertiController {

    @Inject
    @Named("CertiAppDetService")
    private CertiAppDetService certiAppDetService;

    @Inject
    @Named("CertiAppService")
    private CertiAppService certiAppService;

    @Inject
    @Named("SecurityMgrService")
    private SecurityMgrService securityMgrService;

    @Inject
    @Named("RetireAprService")
    private RetireAprService retireAprService;

    @Inject
    @Named("RdInvokerService")
    private RdInvokerService rdInvokerService;

    @Inject
    @Named("CommonCodeService")
    private CommonCodeService commonCodeService;

    @Inject
    @Named("OtherService")
    private OtherService otherService;

    @Inject
    @Named("SelfCertiService")
    private SelfCertiService selfCertiService;

    @Inject
    @Named("SelfCommonService")
    private SelfCommonService selfCommonService;

    @Inject
    @Named("SelfLoginService")
    private SelfLoginService selfLoginService;

    @Value("${rd.image.base.url}")
    private String imageBaseUrl;

    @Autowired
    private JweToken jwt;

    /**
     * 신청구분 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getCertiEmpHisList")
    public Map<String, Object> getCertiEmpHisList(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        String token = request.getHeader("Authorization");
        Log.Debug("token :: {}", token);
        SignedJWT sToken = jwt.decodeJWT(token);
        Log.Debug("sToken :: {}", sToken);

        Log.Debug("sToken.getPayload :: {}", (String) sToken.getPayload().toJSONObject().toString());
        String ssnSabun = (String) sToken.getPayload().toJSONObject().get("sabun");
        String ssnEnterCd = (String) sToken.getPayload().toJSONObject().get("enterCd");
        paramMap.put("ssnEnterCd", ssnEnterCd);
        paramMap.put("ssnSabun", ssnSabun);

//        List<?> list = selfCertiService.getCertiEmpHisList(paramMap);



        Map<String, Object> elemQueryMap = new HashMap<>();
        Map<String, Object> chgMap = new HashMap<>();
        String stdCdClob = "";
        String Message = "";
        String query = "";
        try{
            //재직 이력 쿼리 조회 SELF_EMP_HIS
            paramMap.put("stdCd", "SELF_EMP_HIS_SQL");
            elemQueryMap	= (Map<String, Object>) selfCommonService.getStdCdClob(paramMap);
            stdCdClob   		= (String) elemQueryMap.get("stdCdClob");
            Log.Debug(elemQueryMap.toString());
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
            Log.Debug(e.getMessage());
        }

        query = stdCdClob.replace("#{ssnEnterCd}", cAdd(ssnEnterCd));
        query = query.replace("#{ssnSabun}", cAdd(ssnSabun));
        Log.Debug(query);
        paramMap.put("resultQuery", query);
        Log.Debug(paramMap.toString());

        List<?> list = selfCommonService.getSelfQueryResultList(paramMap);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        Log.DebugEnd();
        return result;
    }

    /**
     * getRetireAprList 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getRetireAprList")
    public Map<String, Object> getRetireAprList(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        String ssnEnterCd = String.valueOf(session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnEnterCd", ssnEnterCd);
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<Map<String, Object>> list  = new ArrayList<>();
        String Message = "";
        try{
            list = (List<Map<String, Object>>) retireAprService.getRetireAprList(paramMap);

            String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_RETIRE);
            if (encryptKey != null) {
                for (Map<String, Object> map : list) {
                    map.put("rk", CryptoUtil.encrypt(encryptKey, map.get("sabun") + "#" + map.get("applYmd") + "#" + map.get("signFileSeq")));
                    map.put("rk2", CryptoUtil.encrypt(encryptKey, map.get("sabun") + "#" + map.get("applYmd") + "#" + map.get("applSeq") + "#" + map.get("signFileSeq1")
                            + "#" + map.get("finWorkYmd") + "#" + map.get("retSchYmd") + "#" + map.get("note") + "#" + map.get("retContractNo")));
                }
            }
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("Message", Message);
        Log.DebugEnd();

        return result;
    }

    /**
     * 제증명신청 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getCertiAppList")
    public Map<String, Object> getCertiAppList(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Log.Debug(paramMap.toString());
        String token = request.getHeader("Authorization");
        SignedJWT sToken = jwt.decodeJWT(token);
        Log.Debug("sToken :: {}", sToken);

        Log.Debug("sToken.getPayload :: {}", (String) sToken.getPayload().toJSONObject().toString());
        String ssnSabun = (String) sToken.getPayload().toJSONObject().get("sabun");
        String ssnEnterCd = (String) sToken.getPayload().toJSONObject().get("enterCd");
        paramMap.put("ssnEnterCd", ssnEnterCd);
        paramMap.put("ssnSabun", ssnSabun);
        paramMap.put("searchSabun", ssnSabun);

        //List<?> list  = new ArrayList<Object>();
        List<Map<String, Object>> list = null;
        String Message = "";
        try{
            if(ssnEnterCd != null) {
                list =  (List<Map<String, Object>>) selfCertiService.getSelfCertiAppList(paramMap);
                String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_CERTIFICATE);
//                grpCd: 'R10010',
//                queryId: 'R10010'
                paramMap.put("grpCd", "R10010");

                Log.Debug(paramMap.toString());
                getBaseYmd(paramMap);
                Log.Debug(paramMap.toString());
                List<Map<String, Object>> codeList = (List<Map<String, Object>>) commonCodeService.getCommonCodeList(paramMap);
                Log.Debug(codeList.toString());

                if (encryptKey != null) {
                    for (Map<String, Object> empMap : list) {
                        empMap.put("rk", CryptoUtil.encrypt(encryptKey,  empMap.get("applCd") + "#" + empMap.get("sabun")));
                        Map<String, Object> codes = codeList.stream()
                                .filter(code -> empMap.get("applStatusCd").equals(code.get("code")))
                                .collect(Collectors.toList()).get(0);
                        empMap.put("codeNm", codes.get("codeNm"));
                        Log.Debug(codes.toString());
                    }
                }
                Log.Debug(list.toString());
            }

        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("Message", Message);
        Log.DebugEnd();
        return result;
    }

    /**
     * 제증명신청 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getCertiAppDet")
    public Map<String, Object> getCertiAppDet(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        String token = request.getHeader("Authorization");
        SignedJWT sToken = jwt.decodeJWT(token);
        Log.Debug("sToken :: {}", sToken);

        Log.Debug("sToken.getPayload :: {}", (String) sToken.getPayload().toJSONObject().toString());
        String ssnSabun = (String) sToken.getPayload().toJSONObject().get("sabun");
        String ssnEnterCd = (String) sToken.getPayload().toJSONObject().get("enterCd");
        paramMap.put("ssnEnterCd", ssnEnterCd);
        paramMap.put("ssnSabun", ssnSabun);
        paramMap.put("searchSabun", ssnSabun);

//        String ssnEnterCd = paramMap.get("ssnEnterCd").toString();
//        String ssnEnterCd = session.getAttribute("ssnEnterCd")+"";
//        paramMap.put("ssnEnterCd", ssnEnterCd);
//        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        //List<?> list  = new ArrayList<Object>();
        List<Map<String, Object>> list = null;
        String Message = "";
        try{
            if(ssnEnterCd != null) {
                list =  (List<Map<String, Object>>) selfCertiService.getSelfCertiAppDetList(paramMap);
                String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_CERTIFICATE);
//                grpCd: 'R10010',
//                queryId: 'R10010'
                paramMap.put("grpCd", "R10010");

                Log.Debug(paramMap.toString());
                getBaseYmd(paramMap);
                Log.Debug(paramMap.toString());
                List<Map<String, Object>> codeList = (List<Map<String, Object>>) commonCodeService.getCommonCodeList(paramMap);
                Log.Debug(codeList.toString());

                if (encryptKey != null) {
                    Log.Debug(encryptKey);
                    Log.Debug(list.toString());
                    for (Map<String, Object> empMap : list) {
                        empMap.put("rk", CryptoUtil.encrypt(encryptKey,  empMap.get("applCd") + "#" + ssnSabun));
                        Map<String, Object> codes = codeList.stream()
                                .filter(code -> empMap.get("applStatusCd").equals(code.get("code")))
                                .collect(Collectors.toList()).get(0);
                        empMap.put("codeNm", codes.get("codeNm"));
                        Log.Debug(codes.toString());
                    }
                }
                Log.Debug(list.toString());
            }

        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("Message", Message);
        Log.DebugEnd();
        return result;
    }

    /**
     * 증명서신청 세부내역 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getCertiAppDetList")
    public Map<String, Object> getCertiAppDetList(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        String token = request.getHeader("Authorization");
        SignedJWT sToken = jwt.decodeJWT(token);
        Log.Debug("sToken :: {}", sToken);

        Log.Debug("sToken.getPayload :: {}", (String) sToken.getPayload().toJSONObject().toString());
        String ssnSabun = (String) sToken.getPayload().toJSONObject().get("sabun");
        String ssnEnterCd = (String) sToken.getPayload().toJSONObject().get("enterCd");
        paramMap.put("ssnEnterCd", ssnEnterCd);
        paramMap.put("ssnSabun", ssnSabun);

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = selfCertiService.getSelfCertiAppDetList(paramMap);

        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("Message", Message);
        Log.DebugEnd();
        return result;
    }

    /**
     * 재직이력 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getApplType")
    public Map<String, Object> getApplType(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        Map<String, Object> result = new HashMap<>();

        String token = request.getHeader("Authorization");
        SignedJWT sToken = jwt.decodeJWT(token);

        String ssnSabun = (String) sToken.getPayload().toJSONObject().get("sabun");
        String ssnEnterCd = (String) sToken.getPayload().toJSONObject().get("enterCd");
        paramMap.put("ssnEnterCd", ssnEnterCd);
        paramMap.put("ssnSabun", ssnSabun);

        Map<String, Object> elemQueryMap = new HashMap<>();
        Map<String, Object> chgMap = new HashMap<>();
        String stdCdClob = "";
        try{
            //재직 이력 쿼리 조회 SELF_EMP_HIS
            paramMap.put("stdCd", "SELF_APPL_TYPE");
            elemQueryMap	= (Map<String, Object>) selfCommonService.getStdCdClob(paramMap);
            stdCdClob   		= (String) elemQueryMap.get("stdCdClob");
            JSONParser jsonParser = new JSONParser();
            Log.Debug(stdCdClob);
            org.json.simple.JSONObject jsonObject = (org.json.simple.JSONObject) jsonParser.parse(stdCdClob);
            Log.Debug(jsonObject.toString());
            result.put("list", jsonObject.get("list"));
        }catch(Exception e){
            Log.Debug(e.getMessage());
        }
        Log.DebugEnd();
        return result;
    }

    /**
     * 증명서신청 세부내역 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/saveCertiAppDet")
    public Map<String, Object> saveCertiAppDet(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();

        Log.Debug(paramMap.toString());
        Map<String, Object> result = new HashMap<String, Object>();

        String token = request.getHeader("Authorization");
        Log.Debug("token :: {}", token);
        SignedJWT sToken = jwt.decodeJWT(token);
        Log.Debug("sToken :: {}", sToken);

        Log.Debug("sToken.getPayload :: {}", (String) sToken.getPayload().toJSONObject().toString());
        String ssnSabun = (String) sToken.getPayload().toJSONObject().get("sabun");
        String ssnEnterCd = (String) sToken.getPayload().toJSONObject().get("enterCd");

        String searchApplSeq = "";

        paramMap.put("sabun", ssnSabun);

        Log.Debug(paramMap.toString());
        if (paramMap.get("reqYy") != null && !"".equals(paramMap.get("reqYy"))) {
            Log.Debug(paramMap.toString());
            Map<?, ?> map = certiAppDetService.getCertiAppDetCheckPdfExist(paramMap);
            Log.Debug(map.toString());
            if ("N".equals(map.get("searchYn"))) {
                result.put("Code", -1);
                result.put("Message", "해당 신청년도의 연말정산이 미완료 상태입니다.\n다시 신청하여 주십시오.");
                Log.DebugEnd();
                return result;
            }
        }

        //applSeq get
        paramMap.put("seqId", "APPL");
        Map<?, ?> sequenceMap = (Map<?, ?>)otherService.getSequence(paramMap);

        searchApplSeq = String.valueOf(sequenceMap.get("getSeq"));
        if("null".equals(searchApplSeq)) {
            searchApplSeq = "";
        }

        String getParamNames ="sNo,sStatus,sabun,applYmd,sYmd,eYmd,address,reqYy,purpose,etc,submitOffice,resNoYn,orgYn,pmTime,nightPmTime,applCd,applYmd,applSeq,reqSabun,prtCnt,locationCd,locationNm";


        List<Map<String, Object>> mergeRows = new ArrayList<>();

        mergeRows.add(paramMap);

        Map<String, Object> convertMap = new HashMap<>();
        convertMap.put("ssnSabun", 	ssnSabun);
        convertMap.put("ssnEnterCd",ssnEnterCd);
        convertMap.put("mergeRows", mergeRows);
        convertMap.put("deleteRows", new ArrayList<>());

        String message = "";
        int resultCnt = -1;
        try{
            resultCnt = certiAppDetService.saveCertiAppDet(convertMap);
            if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
        }catch(Exception e){
            resultCnt = -1; message="저장에 실패하였습니다.";
        }

        result.put("Code", resultCnt);
        result.put("searchApplSeq", searchApplSeq);
        result.put("Message", message);
        Log.DebugEnd();
        return result;
    }

    /**
     * 원천징수영수증 PDF 존재 유무 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getCertiAppDetCheckPdfExist")
    public Map<String, Object> getCertiAppDetCheckPdfExist(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        String token = request.getHeader("Authorization");
        SignedJWT sToken = jwt.decodeJWT(token);
        Log.Debug("sToken :: {}", sToken);

        Log.Debug("sToken.getPayload :: {}", (String) sToken.getPayload().toJSONObject().toString());

        String ssnEnterCd = (String) sToken.getPayload().toJSONObject().get("enterCd");
        paramMap.put("ssnEnterCd", ssnEnterCd);

        Map<?, ?> map  = new HashMap<String,Object>();
        String Message = "";
        try{
            map = certiAppDetService.getCertiAppDetCheckPdfExist(paramMap);

        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("DATA", map);
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

        String token = request.getHeader("Authorization");
        Log.Debug(token);
        SignedJWT sToken = jwt.decodeJWT(token);
        Log.Debug("sToken :: {}", sToken);

        Log.Debug("sToken.getPayload :: {}", (String) sToken.getPayload().toJSONObject().toString());

        String ssnSabun = (String) sToken.getPayload().toJSONObject().get("sabun");
        String ssnEnterCd = (String) sToken.getPayload().toJSONObject().get("enterCd");
//        String ssnLocaleCd = session.getAttribute("ssnLocaleCd") + "";

        paramMap.put("ssnEnterCd", ssnEnterCd);
        paramMap.put("ssnSabun", ssnSabun);
        paramMap.put("token", token);

        String mrdPath = "";
        String param = "";


        if(paramMap.containsKey("rp")){
            param += "/rp ";
            Map<String, Object> rpMap = (Map<String, Object>) paramMap.get("rp");
            Log.Debug(rpMap.toString());
            String securityKey = securityCheck(request, paramMap);
            param += paramMap.get("rpParams").toString()
                    .replaceAll("\\{ssnEnterCd\\}", ssnEnterCd)
                    .replaceAll("\\{sabun\\}", ssnSabun)
                    .replaceAll("\\{imageBaseUrl\\}", imageBaseUrl)
                    .replaceAll("\\{imgPath\\}", rpMap.get("imgPath").toString().replaceAll("\\{enterCd\\}", ssnEnterCd))
                    .replaceAll("\\{securityKey\\}", securityKey)
            ;

            for (Map.Entry<String, Object> entry : rpMap.entrySet()) {
                if(entry != null){
                    param = param.replaceAll("\\{" + entry.getKey() + "\\}", entry.getValue().toString());
                }
            }

            String reqYy = rpMap.get("reqYy").toString();
            if(reqYy != null && reqYy != ""){
                //원천징수 등 신청년도가 있는 경우 mrdPath
                StandardEvaluationContext context = new StandardEvaluationContext();
                context.setVariable("reqYy", Integer.parseInt(reqYy));
                ExpressionParser parser = new SpelExpressionParser();
                String mrd = XssPreventer.unescape(paramMap.get("mrdPath").toString());
                Expression exp = parser.parseExpression(mrd);
                mrdPath = (String) exp.getValue(context);
            }else{
                mrdPath = paramMap.get("mrdPath").toString();
            }
            Log.Debug(mrdPath);
        }

        paramMap.put("mrdPath", mrdPath);
        paramMap.put("rdParam", param);
        paramMap.put("enterCd", ssnEnterCd);

        // 서버에 다운로드 처리
//        Map res = rdInvokerService.invokeToFile(paramMap, true, "pdf", null);
//        Log.Debug("파일 다운로드 경로: " +res.get("saveFileName").toString());

        Log.Debug(paramMap.toString());
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

    public String securityCheck(HttpServletRequest request, Map<String, Object> reqParamMap){
        String securityKey = "";
        try {

            Map<?, ?> loginUser = selfLoginService.getLoginSelf(reqParamMap);
            String ssnEnterCd   = (String) loginUser.get("ssnEnterCd");
            String ssnAdmin     = "N"; //관리자 여부
            String ssnSabun 	= (String) loginUser.get("ssnSabun");
            String ssnGrpCd 	= "10";
            String cmd 			= "getEncryptRd";

            String searchApplSeq = reqParamMap.get("applSeq") == null ? "" : String.valueOf(reqParamMap.get("applSeq")); //신청서

            Map<String, Object> paramMap = new HashMap<String, Object>();
            paramMap.put("ssnEnterCd", 			ssnEnterCd);
            paramMap.put("ssnSabun", 			ssnSabun);
            paramMap.put("ssnGrpCd", 			ssnGrpCd);
            paramMap.put("cmd", 				cmd);
            paramMap.put("ssnAdmin", 			ssnAdmin);
            paramMap.put("clientIp", 			StringUtil.getClientIP(request) );
            paramMap.put("sessionId", 			reqParamMap.get("token"));
            paramMap.put("relUrl", 				"/CertiApp.do?cmd=getEncryptRd");

            // 기안자가 아닌 다른 이가 신청서를 조회할 때 결재라인 및 참조자에 있는지 체크 하기 위해 신청서순번을 함께 넘김.
            paramMap.put("searchApplSeq", 		searchApplSeq);

            Log.Debug("★★★paramMap : " + paramMap );
            String mrd = (String)request.getParameter("Mrd");
            if( mrd != null ) mrd = mrd.substring(mrd.lastIndexOf("/")+1);
            paramMap.put("mrd", 				mrd);
            paramMap.put("rdParam", 			(String)request.getParameter("Param"));

//            session.setAttribute("errorUrl", StringUtil.getRelativeUrl(request));

            //체크 프로시저 호출
            Map<?, ?> rs = securityMgrService.PrcCall_F_SEC_GET_AUTH_CHK(paramMap);
            Log.Debug("PrcCall_F_SEC_GET_AUTH_CHK : " + rs );

            if(rs != null) {
                //체크 결과
                String result = (String) rs.get("result");
                JSONObject jObject = new JSONObject(result); //CODE, SECURITY_KEY
                String code = jObject.getString("CODE");

                // 로그인사번이 결재라인 및 참조자에 있으면 기안자(또는 대리기안자)의 사번이 리턴됨.
                String applSabun = "";

                if (searchApplSeq.length() > 0) {
                    applSabun = jObject.getString("APPL_SABUN"); //신청순번이 있을 때 신청자 사번
                } else {
                    applSabun = ssnSabun; //로그인사번
                }
                Log.Debug("★★★ applSabun : " + applSabun);

                if (code.equals("0")) {
                    // CSRF (Cross-Site Request Forgery) 대응 START
                    // 브라우저 내 쿠키에 담기는 JSESSIONID 탈취에 대응하기 위한 조치
                    // User-Agent (접근 브라우저 정보), 로그인 IP 검증 절차. 로그인 시 세션에 담았던 User-Agent, client IP 와 현재 접근하려는 User-Agent, client IP 를 검증한다.
                    String userAgent = request.getHeader("User-Agent");
                    String clientIp = StringUtil.getClientIP(request);

                    String ssnLoginAgent = (String) loginUser.get("ssnLoginAgent");
                    String logIp = (String) loginUser.get("logIp");

//                    Log.Debug("■■■■■■■■■■ securityCheck.isEqualIP&UserAgent Start ■■■■■■■■■■");
//                    Log.Debug(" header.userAgent: " + userAgent + ", session.userAgent: " + ssnLoginAgent);
//                    Log.Debug(" header.clientIp: " + clientIp + ", session.clientIp: " + logIp);
//                    Log.Debug("■■■■■■■■■■ securityCheck.isEqualIP&UserAgent End   ■■■■■■■■■■");
//
//                    if (!userAgent.equals(ssnLoginAgent) || !clientIp.equals(logIp)) {
//                        return "991";
//                    }
                    // CSRF (Cross-Site Request Forgery) 대응 END

                    //RD에서 체크 하는 키 값
                    securityKey = jObject.getString("SECURITY_KEY");
                    if (securityKey != null && !securityKey.equals("")) { //securityKey
                        request.setAttribute("securityKey", securityKey);
                    }
                } else {
                    if (code.equals("991")) { //세션변조 일 때
//                        session.setAttribute("errorSessionId", jObject.getString("SECURITY_KEY"));
                    }
                    Log.Debug(code);
                    return code; //에러
                }
            }else{
                Log.Debug("□□□□□□□□□□□□□□□□□□□□□ PrcCall_F_SEC_GET_AUTH_CHK is null" );
            }
        }catch(Exception e){

            Log.Debug("□□□□□□□□□□□□□□□□□□□□□ Exception 체크 실패! " + e.getMessage() );
            //Log.Debug(e.getLocalizedMessage());
        }
        return securityKey;
    }

    private void getBaseYmd(@RequestParam Map<String, Object> paramMap) {
        if (paramMap.containsKey("baseSYmd") && paramMap.get("baseSYmd") != null && !"".equals(paramMap.get("baseSYmd"))) {
            paramMap.put("baseSYmd", replaceBaseYmd(paramMap.get("baseSYmd").toString()));
        } else {
            paramMap.put("baseSYmd", getToday());
        }

        if (paramMap.containsKey("baseEYmd") && paramMap.get("baseEYmd") != null && !"".equals(paramMap.get("baseEYmd"))) {
            paramMap.put("baseEYmd", replaceBaseYmd(paramMap.get("baseEYmd").toString()));
        }
    }

    private String replaceBaseYmd(String baseYmd) {
        return baseYmd.replaceAll("-", "");
    }

    private String getToday() {
        Date today = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        return dateFormat.format(today);
    }

    public String changeQuery(String query, Map<String, Object> tMap){
        Set<String> gSet = tMap.keySet();
        Iterator<String> iterator = gSet.iterator();
        while (iterator.hasNext()) {
            String key = iterator.next();
            String value = tMap.get(key).toString();
            query = query.replaceAll(key, value);
        }
        iterator = gSet.iterator();
        while (iterator.hasNext()) {
            String key = iterator.next();
            String value = tMap.get(key).toString();
            query = query.replaceAll(key, value);
        }
        return query;
    }

    public String cAdd(String str){
        return "'"+str+"'";
    }
}