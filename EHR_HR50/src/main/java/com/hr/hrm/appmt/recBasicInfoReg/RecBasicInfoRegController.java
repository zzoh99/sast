package com.hr.hrm.appmt.recBasicInfoReg;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.PrivateKey;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilderFactory;

import com.hr.common.util.RSA;
import org.json.JSONObject;
import org.json.XML;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.saveData.SaveDataService;
import com.hr.common.util.DateUtil;
import com.hr.common.util.ParamUtils;
import com.hr.hrm.appmt.largeAppmtMgr.LargeAppmtMgrService;
import com.hr.hrm.appmtBasic.appmtItemMapMgr.AppmtItemMapMgrService;
import com.hr.hrm.dispatch.dispatchApr.DispatchAprService;
import com.hr.hrm.retire.retireApr.RetireAprService;
import com.hr.hrm.timeOff.timeOffApr.TimeOffAprService;


/**
 * 채용기본사항등록 Controller
 *
 * @author bckim
 *
 */
@Controller
@SuppressWarnings("unchecked")
@RequestMapping(value="/RecBasicInfoReg.do", method=RequestMethod.POST )
public class RecBasicInfoRegController {
	/**
	 * 채용기본사항등록 서비스
	 */
	@Inject
	@Named("RecBasicInfoRegService")
	private RecBasicInfoRegService recBasicInfoRegService;

	@Inject
	@Named("AppmtItemMapMgrService")
	private AppmtItemMapMgrService appmtItemMapMgrService;

	@Inject
	@Named("LargeAppmtMgrService")
	private LargeAppmtMgrService largeAppmtMgrService;

	@Inject
	@Named("DispatchAprService")
	private DispatchAprService dispatchAprService;
	
	@Inject
	@Named("RetireAprService")
	private RetireAprService retireAprService;
	
	@Inject
	@Named("TimeOffAprService")
	private TimeOffAprService timeOffAprService;

	/**
	 * SAVE DATA 서비스
	 */
	@Inject
	@Named("SaveDataService")
	private SaveDataService saveDataService;
	
	/**
	 * 채용기본사항등록 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRecBasicInfoReg", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRecBasicInfoReg() throws Exception {
		return "hrm/appmt/recBasicInfoReg/recBasicInfoReg";
	}
	
	/**
	 * 채용기본사항승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRecBasicInfoMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRecBasicInfoMgr() throws Exception {
		return "hrm/appmt/recBasicInfoReg/recBasicInfoMgr";
	}
	
	

	/**
	 * 채용기본사항등록(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRecBasicInfoRegPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRecBasicInfoRegPop() throws Exception {
		return "hrm/appmt/recBasicInfoReg/recBasicInfoRegPop";
	}

	/**
	 * 채용기본사항등록(업로드) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRecBasicInfoRegUploadPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRecBasicInfoRegUploadPop() throws Exception {
		return "hrm/appmt/recBasicInfoReg/recBasicInfoRegUploadPop";
	}
	
	 /**
     * 채용기본사항등록(업로드) 팝업 Layer
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewRecBasicInfoRegUploadLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewRecBasicInfoRegUploadLayer() throws Exception {
        return "hrm/appmt/recBasicInfoReg/recBasicInfoRegUploadLayer";
    }

	/**
	 * 채용기본사항등록(합격자정보I/F) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRecBasicInfoRegIfPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRecBasicInfoRegIfPop() throws Exception {
		return "hrm/appmt/recBasicInfoReg/recBasicInfoRegIfPop";
	}

	 /**
     * 채용기본사항등록(합격자정보I/F) 팝업 Layer
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewRecBasicInfoRegIfLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewRecBasicInfoRegIfLayer() throws Exception {
        return "hrm/appmt/recBasicInfoReg/recBasicInfoRegIfLayer";
    }

    
	/**
	 * 채용기본사항등록 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRecBasicInfoRegList", method = RequestMethod.POST )
	public ModelAndView getRecBasicInfoRegList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = recBasicInfoRegService.getRecBasicInfoRegList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 채용기본사항등록(팝업) 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRecBasicInfoRegPopList", method = RequestMethod.POST )
	public ModelAndView getRecBasicInfoRegPopList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = recBasicInfoRegService.getRecBasicInfoRegPopList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 채용기본사항등록(합격자정보I/F 팝업) 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRecBasicInfoRegIfPopList", method = RequestMethod.POST )
	public ModelAndView getRecBasicInfoRegIfPopList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = recBasicInfoRegService.getRecBasicInfoRegIfPopList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 채용기본사항등록 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRecBasicInfoReg", method = RequestMethod.POST )
	public ModelAndView saveRecBasicInfoReg(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{

			//223 번 table 에 데이터를 insert하기위해 값 정렬
			paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
			paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
			paramMap.put("searchUseYn", "Y");
			Map<String, Object> convertMap2 = ParamUtils.requestInParamsMultiDMLPost(request,paramMap.get("s_SAVENAME").toString(),paramMap.get("s_SAVENAME2").toString(),"VALUE", appmtItemMapMgrService.getAppmtItemMapMgrList(paramMap));
			if (convertMap2 != null) {
				//가발령 적용 목록만
				Map<String, Object> postMap = new HashMap<String,Object>();
				postMap.put("ssnSabun", session.getAttribute("ssnSabun"));
				postMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
				postMap.put("processNo", paramMap.get("searchProcessNo"));
				List<?> list = (List<?>)convertMap.get("mergeRows");
				List<Map<String,Object>> postMergeList = new ArrayList<Map<String,Object>>();
				List<Map<String,Object>> postDeleteList = new ArrayList<Map<String,Object>>();
				for(Object o : list){
					Map<String,Object> m =(Map<String, Object>) o;
					String prePostYn = (String)m.get("prePostYn");//사용자가 수정한 값
					String prePostYn2 = (String)m.get("prePostYn2");// backup 값
					if(prePostYn!=null && prePostYn2!=null ){
						if(prePostYn.equals("Y") && !prePostYn.equals(prePostYn2)){
							//가발령 적용
							postMergeList.add(m);
						}else{
							//가발령 적용취소
							postDeleteList.add(m);
						}
					}

				}
				postMap.put("mergeRows", postMergeList);
				postMap.put("deleteRows", postDeleteList);

				/* Map<String,Object> returnMap = */
				largeAppmtMgrService.saveLargeAppmtMgrExec(postMap, convertMap2);

				// 암호화처리된 주민번호 복호화
				List<Map<String, Object>> mergeRows = (List<Map<String, Object>>) convertMap.get("mergeRows");
				PrivateKey privateKey = (PrivateKey) session.getAttribute("_RSA_WEB_Key_");  // 세션에 저장된 개인키를 가져온다.
				for (Map<String, Object> map : mergeRows) {
					String resNo = RSA.decryptRsa(privateKey, map.get("resNo").toString());
					map.put("resNo", resNo);
				}

				resultCnt =recBasicInfoRegService.saveRecBasicInfoReg(convertMap);// 채용 table update
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			}
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하 였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}


	/**
     * 채용기본사항등록 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveRecBasicInfoRegNew", method = RequestMethod.POST )
    public ModelAndView saveRecBasicInfoRegNew(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();

        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun",  session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        String message = "";
        int resultCnt = -1;
        try{

            //223 번 table 에 데이터를 insert하기위해 값 정렬
            paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
            paramMap.put("ssnSabun",    session.getAttribute("ssnSabun"));
            paramMap.put("searchUseYn", "Y");
            Map<String, Object> convertMap2 = ParamUtils.requestInParamsMultiDMLPost(request,paramMap.get("s_SAVENAME").toString(),paramMap.get("s_SAVENAME2").toString(),"VALUE", appmtItemMapMgrService.getAppmtItemMapMgrList(paramMap));
            if (convertMap2 != null) {
            	//가발령 적용 목록만
                Map<String, Object> postMap = new HashMap<String,Object>();
                postMap.put("ssnSabun", session.getAttribute("ssnSabun"));
                postMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

                List<?> list = (List<?>)convertMap.get("mergeRows");
                List<Map<String,Object>> postMergeList = new ArrayList<Map<String,Object>>();
                List<Map<String,Object>> postDeleteList = new ArrayList<Map<String,Object>>();
                for(Object o : list){
                    Map<String,Object> m =(Map<String,Object>) o;
                    String prePostYn = (String)m.get("prePostYn");//사용자가 수정한 값
                    String prePostYn2 = (String)m.get("prePostYn2");// backup 값
                    if(prePostYn!=null && prePostYn2!=null ){
                        if(prePostYn.equals("Y") && !prePostYn.equals(prePostYn2)){
                            //가발령 적용
                            postMergeList.add(m);
                        }else{
                            //가발령 적용취소
                            postDeleteList.add(m);
                        }
                    }

                }
                postMap.put("mergeRows", postMergeList);
                postMap.put("deleteRows", postDeleteList);

    			/* Map<String,Object> returnMap = */largeAppmtMgrService.saveLargeAppmtMgrExecNew(postMap, convertMap2);
				// 암호화처리된 주민번호 복호화
				List<Map<String, Object>> mergeRows = (List<Map<String, Object>>) convertMap.get("mergeRows");
				PrivateKey privateKey = (PrivateKey) session.getAttribute("_RSA_WEB_Key_");  // 세션에 저장된 개인키를 가져온다.
				for (Map<String, Object> map : mergeRows) {
					String resNo = RSA.decryptRsa(privateKey, map.get("resNo").toString());
					map.put("resNo", resNo);
				}

				resultCnt =recBasicInfoRegService.saveRecBasicInfoReg(convertMap);// 채용 table update
//
//                if ("C".equals(paramMap.get("ordGubun").toString())) {
//                	convertMap.put("cmd", "saveTimeOffApr");
//                	resultCnt = saveDataService.saveData(convertMap); //휴직
//                	resultCnt += timeOffAprService.saveTimeOffAprTHRM229(convertMap); //휴직
//
//                }else if ("D".equals(paramMap.get("ordGubun").toString())) {
//                	convertMap.put("cmd", "saveTimeOffApr");
//                	resultCnt = saveDataService.saveData(convertMap); //복직
//                }else if ("K".equals(paramMap.get("ordGubun").toString())) {
//                	resultCnt = dispatchAprService.updateDispatchApr(convertMap); // 국내 파견발령
//                }else if ("k".equals(paramMap.get("ordGubun").toString())) {
//                	resultCnt = dispatchAprService.updateDispatchApr(convertMap);  //해외파견발령
//                }else if ("E".equals(paramMap.get("ordGubun").toString())) {
//                	resultCnt = retireAprService.updateRetireApr(convertMap);
//                	//resultCnt = recBasicInfoRegService.saveRetireAppmt(convertMap);// 퇴직발령
//                }else if ("F".equals(paramMap.get("ordGubun").toString())) {
//                	convertMap.put("cmd", "savePromTargetMgr");
//                	resultCnt = saveDataService.saveData(convertMap);  //승진대상자
//
//                }else {
//
//					// 암호화처리된 주민번호 복호화
//					List<Map<String, Object>> mergeRows = (List<Map<String, Object>>) convertMap.get("mergeRows");
//					PrivateKey privateKey = (PrivateKey) session.getAttribute("_RSA_WEB_Key_");  // 세션에 저장된 개인키를 가져온다.
//					for (Map<String, Object> map : mergeRows) {
//						String resNo = RSA.decryptRsa(privateKey, map.get("resNo").toString());
//						map.put("resNo", resNo);
//					}
//
//                	resultCnt =recBasicInfoRegService.saveRecBasicInfoReg(convertMap);// 채용 table update
//                }
                if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
            }
        }catch(Exception e){
            resultCnt = -1; message="저장에 실패하였습니다.";
        }

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("Code", resultCnt);
        resultMap.put("Message", message);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", resultMap);
        Log.DebugEnd();
        return mv;
    }



	/**
	 * 채용기본사항등록(합격자정보I/F 팝업) 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRecBasicInfoRegIfPop", method = RequestMethod.POST )
	public ModelAndView saveRecBasicInfoRegIfPop(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =recBasicInfoRegService.saveRecBasicInfoRegIfPop(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하 였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 발령처리 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcSabunCreAppmtSave", method = RequestMethod.POST )
	public ModelAndView prcSabunCreAppmtSave(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<?, ?> map  = recBasicInfoRegService.prcSabunCreAppmtSave(paramMap);
		
		if (map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("sqlCode") != null) {
			resultMap.put("Code", map.get("sqlCode").toString());
		}
		if (map.get("sqlErrm") != null) {
			resultMap.put("Message", map.get("sqlErrm").toString());
		} else {
			resultMap.put("Message", "사번이 생성되었습니다.");
		}

		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		// 그리드에 맵핑 되는 데이터 이면 DATA에 담아서 보냄
		// comment 종료
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 사번 중복자 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSabunCreAppmtCnt", method = RequestMethod.POST )
	public ModelAndView getSabunCreAppmtCnt(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = recBasicInfoRegService.getSabunCreAppmtCnt(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map", map);
		Log.DebugEnd();
		return mv;
	}

	/**
     * 채용기본사항등록 면수습일 날짜 계산
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getRecBasicInfoRegPopMap", method = RequestMethod.POST )
    public ModelAndView getTemplateMap(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();


        String traYmd = DateUtil.addMonths(paramMap.get("searchEmpYmd").toString(),3);

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("traYmd", traYmd);
        Log.DebugEnd();
        return mv;
    }

	@RequestMapping(params="cmd=recBasicInfoRegRejoinOrdPop", method = RequestMethod.POST )
	public ModelAndView viewrecBasicInfoRegRejoinOrdPop(@RequestParam Map<String, Object> paramMap, HttpServletRequest request)
			throws Exception {

		String uri = "hrm/appmt/recBasicInfoReg/recBasicInfoRegRejoinOrdPop";
		ModelAndView mv = new ModelAndView();
		mv.setViewName(uri);
		Log.DebugEnd();
		return mv;
	}
	
    /**
     * 재입사 발령 팝업 Layer
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewRecBasicInfoRegRejoinOrdLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewRecBasicInfoRegRejoinOrdLayer() throws Exception {
        return "hrm/appmt/recBasicInfoReg/recBasicInfoRegRejoinOrdLayer";
    }


	@RequestMapping(params="cmd=recBasicInfoRegEnterOrdPop", method = RequestMethod.POST )
	public ModelAndView viewRecBasicInfoRegEnterOrdPop(@RequestParam Map<String, Object> paramMap, HttpServletRequest request)
			throws Exception {

		String uri = "hrm/appmt/recBasicInfoReg/recBasicInfoRegEnterOrdPop";
		ModelAndView mv = new ModelAndView();
		mv.setViewName(uri);
		Log.DebugEnd();
		return mv;
	}

    /**
     * 시간전입 발령 팝업 Layer
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewRecBasicInfoRegEnterOrdLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewRecBasicInfoRegEnterOrdLayer() throws Exception {
        return "hrm/appmt/recBasicInfoReg/recBasicInfoRegEnterOrdLayer";
    }
    
	/**
	 * 채용기본사항등록 > 사번 채번된 채용공고를 통해 등록된 직원 이미지 파일 복사
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=copyPictureFilesByRecServiceReg", method = RequestMethod.POST )
	public ModelAndView copyPictureFilesByRecServiceReg(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		
		try{
			resultCnt = recBasicInfoRegService.copyPictureFilesByRecServiceReg(paramMap);
			if(resultCnt > 0){ message="직원이미지 복사 처리가 완료 되었습니다."; } else{ message="처리된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="복사 처리에 실패하였습니다.";
			Log.Debug(e.getLocalizedMessage());
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	
	/*
	@RequestMapping(params="cmd=viewGroupWareIdCheck", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewGroupWareIdCheck() throws Exception {
		return "hrm/appmt/recBasicInfoReg/getGroupWareIdCheck";
	}
	*/
	
	/**
	 *  id중복 check
	 *
	 * @return String
	 * @throws Exception
	 */
	/*
	@RequestMapping(params="cmd=getGroupWareIdCheck", method = RequestMethod.POST )
	public ModelAndView getGroupWareIdCheck(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		String idCheck = (String)paramMap.get("idCheck");
		String urlStr = (String)paramMap.get("urlStr");
		String user_id = (String)paramMap.get("user_id");
		String message = "";
		String rtnData = "";
		urlStr = urlStr+"&user_id="+user_id;
		
		try{
			XmlParseSax handler = new XmlParseSax(); 
			SAXParserFactory factory = SAXParserFactory.newInstance();
			
			SAXParser saxParser = factory.newSAXParser();
			saxParser.parse(urlStr,handler);
			Log.Debug("handler.getData() : "+handler.getData());
			rtnData = handler.getData();
					
		}catch(Exception e){
			
			message= "아이디 중복체크 중 오류가 발생 했습니다.\n"+e.toString();
			        
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("message", 		message);
		mv.addObject("rtnData", 		rtnData);
		Log.DebugEnd();
		return mv;
	}
	*/
	
	/**
	 * 사번 중복자 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMailAddrChk", method = RequestMethod.POST )
	public ModelAndView getMailAddrChk(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String result = "";
		
		try {
			
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setNamespaceAware(true);
			//DocumentBuilder parser = factory.newDocumentBuilder();
			
			String mailAddr = paramMap.get("mailAddr").toString();
			
			String sendMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
					"<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">" +
					"<soap12:Body>" +
					"<DuplicateCheck_UR xmlns=\"http://tempuri.org/\">" +
					"<pStrUR_Code>"+mailAddr+"</pStrUR_Code>" +
					"</DuplicateCheck_UR>" +
					"</soap12:Body>" +
					"</soap12:Envelope>";

			URL url = new URL("http://do.ebestsecdev.co.kr/WebSite/Base/Controls/ExternalWebService.asmx");
			HttpURLConnection conn = null;
			InputStreamReader in = null;
			OutputStreamWriter wr = null;
			
			try {
				conn = (HttpURLConnection)url.openConnection();
				conn.setConnectTimeout(3000);
				conn.setDoOutput(true);
				conn.setRequestMethod("POST");
				conn.addRequestProperty("Content-Type", "text/xml");
				
				wr = new OutputStreamWriter(conn.getOutputStream());
				wr.write(sendMessage);
				wr.flush();
				
				in = new InputStreamReader(conn.getInputStream(),"utf-8");
				BufferedReader br = new BufferedReader(in);
				String strLine;
				String returnString = "";
				
				/*
				 * 보낸 XML에 대한 응답을 받아옴
				 */
				while ((strLine = br.readLine()) != null){
					returnString = returnString.concat(strLine);
				}
				
				JSONObject xmlJsonObj = XML.toJSONObject(returnString);
				result = xmlJsonObj.toString(4);
			} catch (IOException e) {
				Log.Debug(e.getLocalizedMessage());
			} finally {
				if (in != null) in.close();
				if (wr != null) wr.close();
				if (conn != null) conn.disconnect();
			}
			
		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", result);
		Log.DebugEnd();
		return mv;
	}

}
