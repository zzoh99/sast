package com.hr.api.m.hri.approval;

import com.hr.api.common.controller.ApiComController;
import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.com.ComService;
import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.hri.applyApproval.appBeforeLst.AppBeforeLstService;
import com.hr.hri.applyApproval.approvalMgr.ApprovalMgrService;
import com.hr.hri.applyApproval.approvalMgrResult.ApprovalMgrResultService;
import com.hr.tim.request.vacationAppDet.VacationAppDetService;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@RestController
@RequestMapping(value="/api/v5/approval")
public class ApiApprovalController extends ApiComController {

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
    @Named("ApiApprovalService")
    private ApiApprovalService apiApprovalService;

    @Inject
    @Named("ApprovalMgrResultService")
    private ApprovalMgrResultService approvalMgrResultService;

    @Inject
    @Named("VacationAppDetService")
    private VacationAppDetService vacationAppDetService;

    @Inject
    @Named("AppBeforeLstService")
    private AppBeforeLstService appBeforeLstService;

    @Inject
    @Named("ComService")
    private ComService comService;

    @Inject
    @Named("AuthTableService")
    private AuthTableService authTableService;

    /**
     * 미결함 리스트 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getApprovalList")
    public Map<String, Object> getAppBeforeLstList(
            HttpSession session,
            HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        //페이징 설정
        int totalPage = apiApprovalService.getApprovalListCnt(paramMap);
        Log.Debug("totalPage:"+totalPage);

        int divPage = 10;
        Log.Debug(paramMap.get("searchPage").toString());
        int page = paramMap.get("searchPage") == null? 1: Integer.valueOf(paramMap.get("searchPage").toString());
        int stNum = (page -1) * divPage + 1;
        int edNum = page * divPage;
        int lastPage = (totalPage / 10) + 1;

        paramMap.put("stNum", stNum);
        paramMap.put("edNum", edNum);

        List<?> list = apiApprovalService.getApprovalList(paramMap);
        Log.Debug(list.toString());


        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("lastPage", lastPage);
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
     * 경조신청 상세 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getOccAppDetMap")
    public Map<String, Object> getOccAppDetMap(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        Map<String, Object> result = new HashMap<>();
        paramMap.put("cmd", "getOccAppDetMap");
//        result.put("DATA", getDataMap(session, request, paramMap));
        return result;
    }

    /**
     * 경조신청 상세 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getSchAppDetMap")
    public Map<String, Object> getSchAppDetMap(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        Map<String, Object> result = new HashMap<>();
        paramMap.put("cmd", "getSchAppDetMap");
//        result.put("DATA", getDataMap(session, request, paramMap));
        return result;
    }

    /**
     * 신청기준 목록 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getMedAppDetMap")
    public Map<String, Object> getMedAppDetMap(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        Map<String, Object> result = new HashMap<>();

                Log.Debug("getMedAppDetMap ===== ");
        Log.Debug(paramMap.toString());
//        Map<String, Object> params = paramMap;
//        params.put("cmd", "getMedAppDetMap");
//        Map<String, Object> MedData = getDataMap(session, request, params);
//
//        Log.Debug("getMedAppDetDpndntYn ===== ");
//        Map<String, Object> buyangParams = paramMap;
//        buyangParams.put("cmd", "getMedAppDetDpndntYn");
//        Map<String, Object> buyang = (Map<String, Object>) getDataMap(session, request, buyangParams).get("DATA");
//        result.put("buyangYn", buyang.get("buyangYn"));
//
//        Log.Debug("getMedAppDetTotalPayMon ===== ");
//        Map<String, Object> tpmParams = paramMap;
//        tpmParams.put("cmd", "getMedAppDetTotalPayMon");
//        Map<String, Object> totalPayMon = (Map<String, Object>) getDataMap(session, request, tpmParams).get("DATA");
//        result.put("totalPayMon", totalPayMon.get("totalPayMon"));
//
//        Log.Debug("getMedStd ===== ");
//        Map<String, Object> stdParams = paramMap;
//        stdParams.put("cmd", "getMedStd");
//        stdParams.put("famCd", MedData.get("famCd"));
//        Map<String, Object> medStd = (Map<String, Object>) getDataMap(session, request, stdParams).get("DATA");
//        result.put("medStd", medStd.get("medStd"));

//        Log.Debug(buyang.toString());
//        Log.Debug(totalPayMon.toString());
//        Log.Debug(medStd.toString());
//        Log.Debug("getMedAppDetMap End ===== ");
//        Log.Debug(result.toString());
//        Log.Debug("getMedAppDetMap End ===== ");
//        result.put("DATA", MedData);

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
     * Sequence 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getSequence")
    public Map<String, Object> getSequence(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";
        String searchApplSeq = "";

        try{
            paramMap.put("seqId", "APPL");
            Map<?, ?> sequenceMap = (Map<?, ?>)otherService.getSequence(paramMap);

            searchApplSeq = String.valueOf(sequenceMap.get("getSeq"));
            if("null".equals(searchApplSeq)) {
                searchApplSeq = "";
            }
            Log.Debug("APPL SEQ IS NOT EXISTS");
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        Map<String, Object> result = new HashMap<>();
        result.put("searchApplSeq", searchApplSeq);
        result.put("Message", Message);

        Log.DebugEnd();

        return result;
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
        //session.removeAttribute("ssnSabun");
        //session.setAttribute("ssnSabun", "P10062");
        paramMap.put("ssnSabun",		session.getAttribute("ssnSabun")		);
        paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd")		);
        paramMap.put("ssnLocaleCd", 	session.getAttribute("ssnLocaleCd"));
        String searchApplSabun  = paramMap.get("searchApplSabun").toString();
        String searchApplSeq   	= paramMap.get("searchApplSeq").toString();
        String searchApplCd   	= paramMap.get("searchApplCd").toString();
        String adminYn			= paramMap.get("adminYn").toString();
        String authPg   		= paramMap.get("authPg").toString();
        String searchApplYmd   	= paramMap.get("searchApplYmd").toString();
        String searchSabun  	= paramMap.get("searchSabun").toString();
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
        result.put("searchApplSabun", searchApplSabun);
        result.put("searchApplSeq", 	searchApplSeq);
        result.put("searchApplCd", 	searchApplCd);
        result.put("adminYn", 		adminYn);
        result.put("authPg", 			authPg);
        result.put("searchApplYmd", 	searchApplYmd);
        result.put("searchSabun", 	searchSabun);
        result.put("applSeqExist", 	applSeqExist);
        result.put("uiInfo", 			uiInfo);
        result.put("userInfo", 		userInfo);
        result.put("orgLvl", 			orgLvl);
        result.put("etc01", 			etc01);
        result.put("etc02", 			etc02);
        result.put("etc03", 			etc03);
        result.put("reApplSeq", 			reApplSeq);
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
    @RequestMapping(value = "/getApprovalMgrApplChgList")
    public Map<String, Object> getApprovalMgrApplChgList(
            HttpSession session,
            @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        List<?> list = approvalMgrService.getApprovalMgrApplChgList(paramMap);
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        Log.DebugEnd();
        return result;
    }

    /**
     * 신청서 결재 내부결자선 조회
     *
     * @param session
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getApprovalMgrInList")
    public Map<String, Object> getApprovalMgrInList(
            HttpSession session,
            @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list = approvalMgrService.getApprovalMgrInList(paramMap);
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

        int cnt = 0;
        String message = "";
        int code = -1;

        String ssnEnterCd 	= session.getAttribute("ssnEnterCd").toString();
        String ssnSabun 	= session.getAttribute("ssnSabun").toString();

        params.put("ssnSabun", 	ssnSabun);
        params.put("ssnEnterCd", 	ssnEnterCd);
        params.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
        Map<String, Object> lines = (Map<String, Object>) params.get("lines");
        Log.Debug(lines.toString());
        List<Map<String, Object>> applList = (List<Map<String, Object>>) params.get("applList");
        Log.Debug(applList.toString());

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
        List<Map<String, Object>> inusers = (List<Map<String, Object>>) lines.get("inusers");
        Log.Debug(inusers.toString());
        List<Map<String, Object>> refers = (List<Map<String, Object>>) lines.get("refers");
        Log.Debug(refers.toString());

        //ADD IN_USER
        AtomicInteger index = new AtomicInteger();
        inusers = inusers.stream().map(o -> {
            o.put("agreeSeq", appls.size() + (index.getAndIncrement() + 1));
            return o;
        }).collect(Collectors.toList());
        appls.addAll(inusers);

        for(Map<String, Object> appl : applList){
            String applSeq = appl.get("searchApplSeq").toString();
            String referApplGubun = "11".equals((String) appl.get("applStatusCd")) ? "0":"1";

            appl.put("insertAgreeUser", appls);
            appl.put("insertReferUser", refers);
            appl.put("referApplGubun", referApplGubun);
            appl.put("applSeq", applSeq);
            appl.put("refers", refers);
            appl.put("ssnSabun", ssnSabun);
            appl.put("ssnEnterCd", ssnEnterCd);
            appl.put("fileSeq", fileSeq);

            String rm = "11".equals((String) appl.get("applStatusCd")) ? "임시저장":"신청";
            try{
                Log.Debug(appl.toString());
                cnt = approvalMgrService.saveApprovalMgr(appl);
                if (cnt < 1) {
                    message= rm + "된 내용이 없습니다.";
                    code = 0;
                    return makeReturnValue(cnt, message, code);
                }

                message= rm + " 되었습니다.";
                code = 1;

                approvalMgrService.sendNotification(session, appl, "notification");
                approvalMgrService.sendAppPush(appl, "신규 결재 건이 있습니다.");

//			// 결재후처리 작업 (P_HRI_AFTER_PROC_EXEC 프로시저 대체)
//			int aftCode = approvalAfterJob(params);
//			if(aftCode < 0)
//				message = "후처리작업에 실패하였습니다.";

//			commonMailController.callMailApp(request, params);
            } catch(Exception e){
                e.printStackTrace();
                Log.Error(e.getMessage());
                cnt=-1;
                message= rm + " 실패하였습니다.";
                return makeReturnValue(cnt, message, code);
            }
        }

        return makeReturnValue(cnt, message, code);
    }

    /**
     * 일괄결제 프로시져 호출
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/prcAppBeforeLstProcCall")
    public Map<String, Object> prcAppBeforeLstProcCall(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));


        Map map  = appBeforeLstService.prcAppBeforeLstProcCall(paramMap);

        Log.Debug("obj : "+map);
        Log.Debug("sqlcode : "+map.get("sqlcode"));
        Log.Debug("sqlerrm : "+map.get("sqlerrm"));

        Map<String, Object> result = new HashMap<String, Object>();
        if (map.get("sqlCode") != null) {
            result.put("Code", map.get("sqlCode").toString());
        }
        if (map.get("sqlErrm") != null) {
            result.put("Message", map.get("sqlErrm").toString());
        } else {
            result.put("Message", "결재가 완료되었습니다.");
        }

        Log.DebugEnd();
        return result;
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

}
