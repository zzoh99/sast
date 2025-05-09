package com.hr.api.self.approval;

import com.hr.api.common.util.JweToken;
import com.hr.api.self.certi.SelfCertiService;
import com.hr.api.self.common.SelfCommonService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.DateUtil;
import com.hr.hri.applyApproval.approvalMgr.ApprovalMgrService;
import com.hr.hri.applyApproval.approvalMgrResult.ApprovalMgrResultService;
import com.nimbusds.jwt.SignedJWT;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@RestController
@RequestMapping(value="/api/v5/self/approval")
public class SelfApprovalController {

    @Inject
    @Named("ApprovalMgrService")
    private ApprovalMgrService approvalMgrService;

    @Inject
    @Named("OtherService")
    private OtherService otherService;

    @Inject
    @Named("SecurityMgrService")
    private SecurityMgrService securityMgrService;

    @Inject
    @Named("ApprovalMgrResultService")
    private ApprovalMgrResultService approvalMgrResultService;

    @Inject
    @Named("CommonCodeService")
    private CommonCodeService commonCodeService;

    @Inject
    @Named("SelfCommonService")
    private SelfCommonService selfCommonService;

    @Inject
    @Named("SelfCertiService")
    private SelfCertiService selfCertiService;

    @Autowired
    private JweToken jwt;

    /**
     * 공통 COMBO 코드 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getCommonNSCodeList")
    public Map<String, Object> getCommonNSCodeList(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap) throws Exception {
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

//        paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
//        paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));
//        paramMap.put("ssnSearchType", 	session.getAttribute("ssnSearchType"));

        List<?> list = commonCodeService.getCommonNSCodeList(paramMap);
        Map<String, Object> result = new HashMap<>();
        result.put("codeList", list);
        Log.DebugEnd();
        return result;
    }

    @RequestMapping(value = "/getApprovalDet")
    public Map<String, Object> getApprovalDet(HttpSession session
            , @RequestBody Map<String, Object> params
            , HttpServletRequest request) throws Exception {
        Log.DebugStart();

        String searchApplSabun  = params.get("searchApplSabun").toString();
        String searchApplSeq   	= params.get("searchApplSeq").toString();
        String searchApplCd   	= params.get("searchApplCd").toString();
        String adminYn			= params.get("adminYn").toString();
        String authPg   		= params.get("authPg").toString();
        String searchApplYmd   	= params.get("searchApplYmd").toString();
        String searchSabun  	= params.get("searchSabun").toString();
        String etc01  			= (String) params.get("etc01");
        String etc02  			= (String) params.get("etc02");
        String etc03  			= (String) params.get("etc03");
        String gubun			= "";

        Map<String, Object> uiInfo 	= (Map<String, Object>) approvalMgrResultService.getUiInfo(params);
        uiInfo.put("etcNote", uiInfo.get("etcNote") == null ? null : uiInfo.get("etcNote").toString().replace("\n", "<br>"));
        Map<?, ?> userInfo = (Map<?, ?>)approvalMgrResultService.getApprovalMgrResultUserInfoMap(params);
        Map<?, ?> applMasterInfo = (Map<?, ?>)approvalMgrResultService.getApprovalMgrResultTHRI103(params);
        Map<?, ?> cancelButton = (Map<?, ?>)approvalMgrResultService.getCancelButtonMap(params);

        if(applMasterInfo != null) {
            searchApplCd = String.valueOf(applMasterInfo.get("applCd"));
            searchApplYmd = String.valueOf(applMasterInfo.get("applYmd"));
            searchApplSabun = String.valueOf(applMasterInfo.get("applSabun"));
        }
        params.put("searchApplSabun", searchApplSabun );
        Map<?, ?> userApplInfo = (Map<?, ?>)approvalMgrService.getApprovalMgrUserInfoMap(params);

        String applYn = "N";
        String ssnSabun = session.getAttribute("ssnSabun").toString();
        Map<?, ?> agreeInfo = (Map<?, ?>)approvalMgrResultService.getAgreeSabun(params);
        if(null != agreeInfo && ssnSabun.equals(agreeInfo.get("agreeSabun"))){
            applYn = "Y";
        }

        gubun = (String)approvalMgrResultService.getApprovalMgrThri107Gubun(params);

        Map<String, Object> result = new HashMap<>();
        result.put("searchApplSabun", searchApplSabun);
        result.put("searchApplSeq", searchApplSeq);
        result.put("searchApplCd", searchApplCd);
        result.put("adminYn", adminYn);
        result.put("authPg", authPg);
        result.put("searchApplYmd", searchApplYmd);
        result.put("searchSabun", searchSabun);
        result.put("uiInfo", uiInfo);
        result.put("userInfo", userInfo);
        result.put("userApplInfo", userApplInfo); // 2016.09.30 추가
        result.put("applMasterInfo", applMasterInfo);
        result.put("etc01", etc01);
        result.put("etc02", etc02);
        result.put("etc03", etc03);
        result.put("cancelButton", cancelButton);
        result.put("gubun", gubun);
        result.put("applYn", applYn);  //2019.12.17 jylee

        return result;
    }

    /**
     * 신청서 결재 관리  임시저장 신청서 결재자 조회
     *
     * @param session
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getApprovalMgrResultTHRI107")
    public Map<String, Object> getApprovalMgrResultTHRI107(
            HttpSession session,@RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        List<?> list = approvalMgrResultService.getApprovalMgrResultTHRI107(paramMap);
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        Log.DebugEnd();
        return result;
    }

    /**
     * 신청서 결재 관리  임시저장 수신참조자 조회
     *
     * @param session
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getApprovalMgrResultTHRI125")
    public Map<String, Object> getApprovalMgrResultTHRI125(
            HttpSession session, @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        List<?> list = approvalMgrResultService.getApprovalMgrResultTHRI125(paramMap);
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        Log.DebugEnd();
        return result;
    }

    /**
     * 신청서 결재 관리 저장
     *
     * @param session
     * @param request
     * @param params
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/saveApprovalMgrResult")
    public Map<String, Object> saveApprovalMgrResult(
            HttpSession session,
            HttpServletRequest request,
            @RequestBody Map<String, Object> params) throws Exception {
        Log.DebugStart();

        // BODY 에 있는 정보를 모두 PARAM에 넣는다.
//        params.putAll(body);
        int cnt = 0;
        String message = "";

        String applSave			= params.get("applSave").toString();
        String referSave		= params.get("referSave").toString();
        int	   cAgreeSeq		= Integer.parseInt(params.get("agreeSeq").toString());

        List<Map<String, Object>> appls = (List<Map<String, Object>>) params.get("appls");
        List<Map<String, Object>> inusers = (List<Map<String, Object>>) params.get("inusers");
        List<Map<String, Object>> refers = (List<Map<String, Object>>) params.get("refers");

        //전체 agreeSeq 보다 적은 것만 넣도록 한다.
        List<Map<String, Object>> users = appls.stream()
                .filter(m -> Integer.parseInt(m.get("agreeSeq").toString()) < cAgreeSeq)
                .collect(Collectors.toList());

        //ADD IN_USER
        AtomicInteger index = new AtomicInteger();
        inusers = inusers.stream().map(o -> {
            o.put("agreeSeq", users.size() + (index.getAndIncrement() + 1));
            return o;
        }).collect(Collectors.toList());
        users.addAll(inusers);

        params.put("insertReferUser", refers);
        params.put("insertAgreeUser", users);

        try{
            cnt = approvalMgrResultService.saveApprovalMgrResult(applSave, referSave, params);
            if (cnt == 0) {
                message = "저장된 내용이 없습니다.";
                return makeReturnValue(cnt, message);
            }
            message="저장되었습니다.";

            Map<String, Object> applInfo = (Map<String, Object>)approvalMgrResultService.getApprovalMgrResultTHRI103(params);

            Log.Debug(applInfo.toString());

            String applStatusCd = String.valueOf(applInfo.get("applStatusCd"));
            String applStatusNm = String.valueOf(applInfo.get("applStatusCdNm"));
            String pushMessage = "신규 결재 건이 있습니다.";
            if (applStatusCd.equals("23") || applStatusCd.equals("33") || applStatusCd.equals("99")) {
                pushMessage = applStatusNm + " 되었습니다.";
            }
            approvalMgrService.sendNotification(session, params, "notification");
            approvalMgrService.sendAppPush(params, pushMessage);
        } catch(Exception e) {
            Log.Debug(e.getMessage());
            cnt=-1;
            message="저장 실패하였습니다.";
            return makeReturnValue(cnt, message);
        }

        return makeReturnValue(cnt, message);
    }

    /**
     * UiInfo 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getUiInfo")
    public Map<String, Object> getUiInfo(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";
        String searchApplSeq = "";

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

        Map<String, Object> uiInfo = (Map<String, Object>) approvalMgrService.getUiInfo(paramMap);
        try{
            if(uiInfo != null) {
                String uiInfoValue = String.valueOf(uiInfo.get("etcNote"));
                if(!"".equals(uiInfoValue) && !"null".equals(uiInfoValue)) {
                    uiInfoValue = uiInfoValue.replace("\n", "<br>");
                }
                uiInfo.put("etcNote", uiInfoValue);
            }
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        Map<String, Object> result = new HashMap<>();
        result.put("uiInfo", uiInfo);
        result.put("Message", Message);

        Log.DebugEnd();
        return result;
    }

    /**
     * 신청서 결재 관리 화면
     *
     * @param paramMap
     * @param request
     * @return String
     * @throws Exception
     */
    @RequestMapping(value = "/getApprovalMgr")
    public Map<String, Object> getApprovalMgr(
            HttpSession session,
            @RequestBody Map<String, Object> paramMap,
            HttpServletRequest request) throws Exception {
        Log.Debug("getApprovalMgr");
        Map<String, Object> result = new HashMap<>();
        String token = request.getHeader("Authorization");
        SignedJWT sToken = jwt.decodeJWT(token);
        String ssnSabun = (String) sToken.getPayload().toJSONObject().get("sabun");
        String ssnEnterCd = (String) sToken.getPayload().toJSONObject().get("enterCd");
        paramMap.put("ssnSabun", ssnSabun);
        paramMap.put("ssnEnterCd", ssnEnterCd);
//        paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
        paramMap.put("searchSabun", ssnSabun);
        paramMap.put("searchApplSabun", ssnSabun);

        String searchApplSabun  = ssnSabun;
        String searchApplSeq   	= paramMap.get("searchApplSeq").toString();
        String searchApplCd   	= paramMap.get("searchApplCd").toString();
        String adminYn			= paramMap.get("adminYn").toString();
        String authPg   		= paramMap.get("authPg").toString();
        String searchApplYmd   	= paramMap.get("searchApplYmd").toString();
        String searchSabun  	= ssnSabun;
        String etc01  			= (String)paramMap.get("etc01");
        String etc02  			= (String)paramMap.get("etc02");
        String etc03  			= (String)paramMap.get("etc03");
        String reUseYn          = (String)paramMap.get("reUseYn");	//재사용여부
        String reApplSeq 	= "";		//재사용시 새로운 문서 SEQ
        String applSeqExist 	= "Y";
        //getSequence
        if(null == paramMap.get("searchApplSeq")|| paramMap.get("searchApplSeq").toString().equals("")) {
            paramMap.put("seqId","APPL");
            Map<?, ?> sequenceMap = (Map<?, ?>)otherService.getSequence(paramMap);

            searchApplSeq = String.valueOf(sequenceMap.get("getSeq"));
            if("null".equals(searchApplSeq)) {
                searchApplSeq = "";
            }

            applSeqExist = "N";
            Log.Debug("SEQ NULL");
        }

        if ("Y".equals(reUseYn)) {
            paramMap.put("seqId", "APPL");
            Map<?, ?> sequenceMap = (Map<?, ?>) otherService.getSequence(paramMap);
            reApplSeq = String.valueOf(sequenceMap.get("getSeq"));
            if ("null".equals(reApplSeq)) {
                reApplSeq = "";
            }
        }

        Log.Debug(applSeqExist);
        Map<String, Object> uiInfo = (Map<String, Object>) approvalMgrService.getUiInfo(paramMap);
        if(uiInfo != null) {
            String uiInfoValue = String.valueOf(uiInfo.get("etcNote"));
            if(!"".equals(uiInfoValue) && !"null".equals(uiInfoValue)) {
                uiInfoValue = uiInfoValue.replace("\n", "<br>");
            }
            uiInfo.put("etcNote", uiInfoValue);
        }

        Map<?, ?> userInfo 	= (Map<?, ?>)approvalMgrService.getApprovalMgrUserInfoMap(paramMap);
        Map<?, ?> orgLvl 		= (Map<?, ?>)approvalMgrService.getApprovalMgrApplOrgLvl(paramMap);

        request.setAttribute("TEST21", searchApplSeq);
        result.put("searchApplSeq", 	searchApplSeq);
//        result.put("searchApplCd", 	searchApplCd);
//        result.put("searchApplSabun", searchApplSabun);
//        result.put("adminYn", 		adminYn);
//        result.put("authPg", 			authPg);
//        result.put("searchApplYmd", 	searchApplYmd);
//        result.put("searchSabun", 	searchSabun);
//        result.put("applSeqExist", 	applSeqExist);
        result.put("uiInfo", 			uiInfo);
//        result.put("userInfo", 		userInfo);
//        result.put("orgLvl", 			orgLvl);
//        result.put("etc01", 			etc01);
//        result.put("etc02", 			etc02);
//        result.put("etc03", 			etc03);
//        result.put("reApplSeq", 			reApplSeq);
        return result;
    }

    /**
     * 신청서 결재 단계 조회
     *
     * @param session
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getApprovalMgrLevelCodeList")
    public Map<String, Object> getApprovalMgrLevelCodeList(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list = approvalMgrService.getApprovalMgrLevelCodeList(paramMap);
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        Log.DebugEnd();

        return result;
    }

    /**
     * 신청서 결재 관리 최초 신청 임시저장 신청서 결재자 조회
     *
     * @param session
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getApprovalMgrTHRI107")
    public Map<String, Object> getApprovalMgrTHRI107(HttpSession session,
                                                     @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        List<?> list = approvalMgrService.getApprovalMgrTHRI107(paramMap);
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        Log.DebugEnd();
        return result;
    }

    /**
     * 신청서 결재 관리 최초 신청 결재선 변경 리스트 조회
     *
     * @param session
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getApprovalMgrList")
    public Map<String, Object> getApprovalMgrApplChgList(
            HttpSession session,
            HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        String token = request.getHeader("Authorization");
        Log.Debug("token :: {}", token);
        SignedJWT sToken = jwt.decodeJWT(token);
        Log.Debug("sToken :: {}", sToken);

        Log.Debug("sToken.getPayload :: {}", (String) sToken.getPayload().toJSONObject().toString());
        String ssnSabun = (String) sToken.getPayload().toJSONObject().get("sabun");
        String ssnEnterCd = (String) sToken.getPayload().toJSONObject().get("enterCd");

        paramMap.put("ssnEnterCd", ssnEnterCd);
        paramMap.put("ssnSabun", 	ssnSabun);
        paramMap.put("searchApplSabun", 	ssnSabun);
        return setLines(paramMap);
    }

//    /**
//     * 신청서 결재 관리 최초 신청 결재선 변경 리스트 조회
//     *
//     * @param session
//     * @param paramMap
//     * @return Map
//     * @throws Exception
//     */
//    @RequestMapping(value = "/getApprovalMgrApplChgList")
//    public Map<String, Object> getApprovalMgrApplChgList(
//            HttpSession session,
//            @RequestBody Map<String, Object> paramMap) throws Exception {
//        Log.DebugStart();
//        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
//        List<?> list = approvalMgrService.getApprovalMgrApplChgList(paramMap);
//        Map<String, Object> result = new HashMap<>();
//        result.put("list", list);
//        Log.DebugEnd();
//        return result;
//    }
//
//    /**
//     * 신청서 결재 내부결자선 조회
//     *
//     * @param session
//     * @param paramMap
//     * @return Map
//     * @throws Exception
//     */
//    @RequestMapping(value = "/getApprovalMgrInList")
//    public Map<String, Object> getApprovalMgrInList(
//            HttpSession session,
//            @RequestBody Map<String, Object> paramMap) throws Exception {
//        Log.DebugStart();
//        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
//        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
//
//        List<?> list = approvalMgrService.getApprovalMgrInList(paramMap);
//        Map<String, Object> result = new HashMap<>();
//        result.put("list", list);
//        Log.DebugEnd();
//        return result;
//    }

    /**
     * 신청서 결재 관리 저장
     *
     * @param session
     * @param request
     * @param params
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/saveApprovalMgr")
    public Map<String, Object> saveApprovalMgr(
            HttpSession session,
            HttpServletRequest request,
            @RequestBody Map<String, Object> params
    ) throws Exception {
        Log.DebugStart();
        Log.Debug(params.toString());

        String token = request.getHeader("Authorization");
        Log.Debug("token :: {}", token);
        SignedJWT sToken = jwt.decodeJWT(token);
        Log.Debug("sToken :: {}", sToken);

        Log.Debug("sToken.getPayload :: {}", (String) sToken.getPayload().toJSONObject().toString());
        String ssnSabun = (String) sToken.getPayload().toJSONObject().get("sabun");
        String ssnEnterCd = (String) sToken.getPayload().toJSONObject().get("enterCd");

        int cnt = 0;
        String message = "";
        int code = -1;

//        params.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));

        Map<String, Object> lines = (Map<String, Object>) params.get("lines");
        Log.Debug(lines.toString());

        String fileSeq = "";
        if(params.get("fileSeq") != null && params.get("fileSeq").toString() != ""){
            Log.Debug(params.get("fileSeq").toString());
            fileSeq = params.get("fileSeq").toString();
            Log.Debug(fileSeq);
            String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd);
            Log.Debug(encryptKey);
            fileSeq = CryptoUtil.decrypt(encryptKey, fileSeq);
            Log.Debug(fileSeq);
            params.put("fileSeq", fileSeq);
        }

        List<Map<String, Object>> appls = (List<Map<String, Object>>) lines.get("appls");
        Log.Debug(appls.toString());
//        List<Map<String, Object>> inusers = (List<Map<String, Object>>) lines.get("inusers");
//        Log.Debug(inusers.toString());
//        List<Map<String, Object>> refers = (List<Map<String, Object>>) lines.get("refers");
//        Log.Debug(refers.toString());

        //ADD IN_USER
        AtomicInteger index = new AtomicInteger();
        Log.Debug(appls.size()+"");
//        inusers = inusers.stream().map(o -> {
//            o.put("agreeSeq", appls.size() + (index.getAndIncrement() + 1));
//            return o;
//        }).collect(Collectors.toList());
//        Log.Debug(inusers.toString());
//        appls.addAll(inusers);
//        Log.Debug(appls.toString());

        String applSeq = params.get("searchApplSeq").toString();
        String referApplGubun = "11".equals((String) params.get("applStatusCd")) ? "0":"1";

        params.put("insertAgreeUser", appls);
//        params.put("insertReferUser", refers);
        params.put("referApplGubun", referApplGubun);
        params.put("applSeq", applSeq);
        params.put("refers", new ArrayList<>());
        params.put("ssnSabun", ssnSabun);
        params.put("searchApplSabun", ssnSabun);
        params.put("searchSabun", ssnSabun);
        params.put("ssnEnterCd", ssnEnterCd);
        params.put("fileSeq", fileSeq);

        String rm = "11".equals((String) params.get("applStatusCd")) ? "임시저장":"신청";
        try{
            Log.Debug(params.toString());

            cnt = approvalMgrService.saveApprovalMgr(params);
            if (cnt < 1) {
                message= rm + "된 내용이 없습니다.";
                code = 0;
                return makeReturnValue(cnt, message, code);
            }

            message= rm + " 되었습니다.";
            code = 1;

            approvalMgrService.sendNotification(session, params, "notification");
            approvalMgrService.sendAppPush(params, "신규 결재 건이 있습니다.");

            if(!"0".equals(referApplGubun)){
                Map<String, Object> elemQueryMap = new HashMap<>();
                params.put("stdCd", "SELF_APPL_CERTI_YN");
                elemQueryMap	= (Map<String, Object>) selfCommonService.getStdCdClob(params);
                String stdCdClob   		= (String) elemQueryMap.get("stdCdClob");
                if("Y".equals(stdCdClob)){
                    //자동 승인 로직 추가
                    params.remove("applStatusCd");
                    params.put("applStatusCd", "99");
                    selfCertiService.updateSelfCerti(params);
                }
            }

        } catch(Exception e){
            e.printStackTrace();
            Log.Error(e.getMessage());
            cnt=-1;
            message= rm + " 실패하였습니다.";
            return makeReturnValue(cnt, message, code);
        }

        return makeReturnValue(cnt, message, code);
    }

    private Map<String, Object> makeReturnValue(int cnt, String message) {
        Map<String, Object> result = new HashMap<>();
        result.put("cnt", cnt);
        result.put("Message", message);
        Log.DebugEnd();
        return result;
    }

    private Map<String, Object> makeReturnValue(int cnt, String message, int code) {
        Map<String, Object> result = new HashMap<>();
        result.put("cnt", cnt);
        result.put("Message", message);
        result.put("Code", code);
        Log.DebugEnd();
        return result;
    }

    private Map<String, Object> setLines(Map<String, Object> paramMap) throws Exception {
        Log.Debug(paramMap.toString());
        List<Map<String, Object>> applChgList = (List<Map<String, Object>>) approvalMgrService.getApprovalMgrApplChgList(paramMap);
        Log.Debug(applChgList.toString());

        List<Map<String, Object>> inList = (List<Map<String, Object>>) approvalMgrService.getApprovalMgrInList(paramMap);

        Log.Debug("inList");
        Log.Debug(inList.toString());

        List<Map<String, Object>> mgrList = new ArrayList<>();
        for(Map<String, Object> ac : applChgList){
            mgrList.add(ac);
        }
        Log.Debug("mgrList.toString()");
        Log.Debug(mgrList.toString());
        int iaIndex = 0;
        for(Map<String, Object> ia : inList){
            Map<String, Object> iaMap = new HashMap<>(ia);
            iaMap.put("empAlias", ia.get("name"));
            iaMap.put("agreeName", ia.get("name"));
            iaMap.put("agreeSabun", ia.get("sabun"));
            iaMap.put("gubun", "3");
            iaMap.put("org", ia.get("orgNm"));
            iaMap.put("orgCd", ia.get("orgCd"));
            iaMap.put("jikchak", ia.get("jikchakNm"));
            iaMap.put("jikchakCd", ia.get("jikchakCd"));
            iaMap.put("jikwee", ia.get("jikweeNm"));
            iaMap.put("jikweeCd", ia.get("jikweeCd"));
            iaMap.put("orgAppYn", ia.get("orgAppYn"));
            iaMap.put("agreeSeq", applChgList.size() + iaIndex + 1);
            mgrList.add(iaMap);
            iaIndex++;
        }
        Log.Debug(mgrList.toString());

        List<Map<String, Object>> approvalList = new ArrayList<>();

        int mgrIndex = 0;
        for(Map<String, Object> mgr : mgrList){
            String time = "";
            String status = "";
            String name = "";
            String orgNm = "";
            String orgCd = "";
            String jwNm = "";
            try {
                String agreeTime = "";
                Log.Debug("1");
                if(mgr.get("agreeTime") != null){
                    agreeTime = mgr.get("agreeTime").toString();
                }
                Log.Debug("2");
                time = cTimeFormat(agreeTime);
                Log.Debug("3");
                if(mgr.get("agreeStatusCdNm") != null) status = mgr.get("agreeStatusCdNm").toString();
                if(mgr.get("agreeName") != null) name = mgr.get("agreeName").toString();
                if(mgr.get("agreeOrgNm") != null) orgNm = mgr.get("agreeOrgNm").toString();
                if(mgr.get("orgNm") != null) orgNm = mgr.get("orgNm").toString();
                if(mgr.get("agreeOrgCd") != null) orgCd = mgr.get("agreeOrgCd").toString();
                if(mgr.get("orgCd") != null) orgCd = mgr.get("orgCd").toString();
                if(mgr.get("agreeJikweeNm") != null) jwNm = mgr.get("agreeJikweeNm").toString();

                Log.Debug("4");
                if(mgr.get("deputyYn") != null && "Y".equals(mgr.get("deputyYn"))){
                    Log.Debug("5");
                    Map<String, Object> approvalMap = new HashMap<>();
                    approvalMap.put("num", (mgrIndex+1)+"");
                    approvalMap.put("name", name);
                    approvalMap.put("team", orgNm);
                    approvalMap.put("position", jwNm);
                    approvalMap.put("date", "");
                    approvalMap.put("chip", mgr.get("applTypeCdNm"));
                    approvalMap.put("state", true);
                    approvalMap.put("reply", false);
                    approvalList.add(approvalMap);

                    Log.Debug("6");
                    approvalMap = new HashMap<>();
                    approvalMap.put("num", "");
                    approvalMap.put("name", mgr.get("deputyName"));
                    approvalMap.put("team", mgr.get("deputyOrgNm"));
                    approvalMap.put("position", mgr.get("deputyJikweeNm"));
                    approvalMap.put("date", time);
                    approvalMap.put("chip", "대결");
                    approvalMap.put("state", true);
                    approvalMap.put("reply", false);
                    approvalList.add(approvalMap);
                    Log.Debug("7");
                }else{
                    Log.Debug("8");
                    Map<String, Object> approvalMap = new HashMap<>();
                    approvalMap.put("num", (mgrIndex+1)+"");
                    approvalMap.put("name", name);
                    approvalMap.put("team", orgNm);
                    approvalMap.put("position", jwNm);
                    approvalMap.put("date", time);
                    approvalMap.put("chip", mgr.get("applTypeCdNm"));
                    approvalMap.put("state", true);
                    approvalMap.put("reply", false);
                    approvalList.add(approvalMap);
                    Log.Debug("9");
//                 // reply: c.applTypeCd == '30'?true:false,
                }
            } catch (ParseException e) {
                e.printStackTrace();
            }
            mgrIndex++;
        }

        Map<String, Object> result = new HashMap<>();
        result.put("mgrList", mgrList);
        result.put("approvalList", approvalList);

        Log.DebugEnd();
        return result;
    }

    public String cTimeFormat(String date) throws ParseException {
        String result = "";
        if(date == null || "".equals(date)){
            result = DateUtil.getDateTime("yyyy.MM.dd HH:mm");
        }else{
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
            Calendar cal = Calendar.getInstance();
            cal.setTime(sdf.parse(date));
            result = DateUtil.getDateTime(cal, "yyyy.MM.dd HH:mm");
        }
        Log.Debug(result);
        //YYYY.MM.DD HH:MM
//        String yyyy = date.getFullYear();
//        String mm = date.getMonth();
//        String dd = date.getDate();
//        String hh = date.getHours();
//        String mi = date.getMinutes();
//
//        return yyyy + '.'
//                + lpad((mm + 1).toString(), 2, '0') + '.'
//                + lpad(dd.toString(), 2, '0') + ' '
//                + lpad(hh.toString(), 2, '0') + ':'
//                + lpad(mi.toString(), 2, '0');

        return result;
    }
}
