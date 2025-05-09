package com.hr.hrm.timeOff.timeOffApp;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.rd.EncryptRdService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
import com.hr.common.util.ParamUtils;
import com.hr.common.language.Language;

/**
 * 휴복직기준 관리 관리
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/TimeOffApp.do", method=RequestMethod.POST )
public class TimeOffAppController {

	@Inject
	@Named("TimeOffAppService")
	private TimeOffAppService timeOffAppService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	@Inject
	@Named("OtherService")
	private OtherService otherService;

	@Inject
	@Named("EncryptRdService")
	private EncryptRdService encryptRdService;

	@Autowired
	private SecurityMgrService securityMgrService;

	@Value("${rd.image.base.url}")
	private String imageBaseUrl;

	/**
	 * 다국어처리 서비스
	 */
	@Inject
	@Named("Language")
	private	Language language;
	
	/**
	 * 휴복직 신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTimeOffApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTimeOffApp() throws Exception {
		return "hrm/timeOff/timeOffApp/timeOffApp";
	}
	
	/**
	 * 휴복직기준 관리  육아휴직신청 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTimeOffAppPatDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewTimeOffAppPatDet(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("TimeOffAppController.viewTimeOffAppPatDet");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("hrm/timeOff/timeOffApp/timeOffAppPatDetPopup"); 
		mv.addObject("searchApplSabun", paramMap.get("searchApplSabun").toString());
		mv.addObject("searchApplSeq", 	paramMap.get("searchApplSeq").toString());
		mv.addObject("searchApplCd",	paramMap.get("searchApplCd").toString());
		mv.addObject("adminYn", 		paramMap.get("adminYn").toString());
		mv.addObject("authPg", 			paramMap.get("authPg").toString());
		mv.addObject("searchApplYmd", 	paramMap.get("searchApplYmd").toString());
		mv.addObject("searchSabun", 	paramMap.get("searchSabun").toString());
		return mv;
	}
	/**
	 * 휴복직기준 관리  가족돌봄휴직신청 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTimeOffAppFamDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView timeOffAppFamDet(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("TimeOffAppController.timeOffAppFamDet");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("hrm/timeOff/timeOffApp/timeOffAppFamDetPopup"); 
		mv.addObject("searchApplSabun", paramMap.get("searchApplSabun").toString());
		mv.addObject("searchApplSeq", 	paramMap.get("searchApplSeq").toString());
		mv.addObject("searchApplCd",	paramMap.get("searchApplCd").toString());
		mv.addObject("adminYn", 		paramMap.get("adminYn").toString());
		mv.addObject("authPg", 			paramMap.get("authPg").toString());
		mv.addObject("searchApplYmd", 	paramMap.get("searchApplYmd").toString());
		mv.addObject("searchSabun", 	paramMap.get("searchSabun").toString());
		return mv;
	}
	/**
	 * 휴복직기준 관리  복직신청 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTimeOffAppReturnWorkAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewTimeOffAppReturnWorkAppDet(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("TimeOffAppController.viewTimeOffAppReturnWorkAppDet");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("hrm/timeOff/timeOffApp/timeOffAppReturnWorkAppDetPopup"); 
		mv.addObject("searchApplSabun", paramMap.get("searchApplSabun").toString());
		mv.addObject("searchApplSeq", 	paramMap.get("searchApplSeq").toString());
		mv.addObject("searchApplCd",	paramMap.get("searchApplCd").toString());
		mv.addObject("adminYn", 		paramMap.get("adminYn").toString());
		mv.addObject("authPg", 			paramMap.get("authPg").toString());
		mv.addObject("searchApplYmd", 	paramMap.get("searchApplYmd").toString());
		mv.addObject("searchSabun", 	paramMap.get("searchSabun").toString());
		return mv;
	}
	/**
	 * 휴복직기준 관리  일반 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTimeOffAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewTimeOffAppDet(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("TimeOffAppController.viewTimeOffAppDet");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("hrm/timeOff/timeOffApp/timeOffAppDetPopup"); 
		mv.addObject("searchApplSabun", paramMap.get("searchApplSabun").toString());
		mv.addObject("searchApplSeq", 	paramMap.get("searchApplSeq").toString());
		mv.addObject("searchApplCd",	paramMap.get("searchApplCd").toString());
		mv.addObject("adminYn", 		paramMap.get("adminYn").toString());
		mv.addObject("authPg", 			paramMap.get("authPg").toString());
		mv.addObject("searchApplYmd", 	paramMap.get("searchApplYmd").toString());
		mv.addObject("searchSabun", 	paramMap.get("searchSabun").toString());
		return mv;
	}
	
	/**
	 * 휴복직기준 관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveTimeOffApp", method = RequestMethod.POST )
	public ModelAndView saveTimeOffApp(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0; 
		try{ cnt = timeOffAppService.saveTimeOffApp(convertMap);
			if (cnt > 0) { message= "저장되었습니다."; }  else { message= "저장된 내용이 없습니다."; }
			  
		}catch(Exception e){ cnt=-1; message= "저장에 실패하였습니다.";}
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 육아휴직 및 공상신청시 중복날짜 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTimeOffAppDateValideCnt", method = RequestMethod.POST )
	public ModelAndView getTimeOffAppDateValideCnt(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));

		if( paramMap.get("conditionEnterCd") == null || "".equals(paramMap.get("conditionEnterCd").toString()) ) {
			paramMap.put("conditionEnterCd", 	session.getAttribute("ssnEnterCd"));
		}

		Map result = timeOffAppService.getTimeOffAppDateValideCnt(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 휴복직기준 휴복직신청 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveTimeOffAppPatDet", method = RequestMethod.POST )
	public ModelAndView saveTimeOffAppPatDet(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0; 
		try{ cnt = timeOffAppService.saveTimeOffAppPatDet(paramMap);
			if (cnt > 0) { message= language.getMessage("msg.109987", "저장되었습니다.");}  else { message= language.getMessage("msg.alertSaveNoData", "저장된 내용이 없습니다."); }
		}catch(Exception e){ cnt=-1; message= language.getMessage("msg.alertSaveFail2", "저장에 실패하였습니다."); }
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 휴복직기준 가족돌봄휴직신청 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveTimeOffAppFamDet", method = RequestMethod.POST )
	public ModelAndView saveTimeOffAppFamDet(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0; 
		try{ cnt = timeOffAppService.saveTimeOffAppFamDet(paramMap);
			if (cnt > 0) { message= language.getMessage("msg.109987", "저장되었습니다.");}  else { message= language.getMessage("msg.alertSaveNoData", "저장된 내용이 없습니다."); }
		}catch(Exception e){ cnt=-1; message= language.getMessage("msg.alertSaveFail2", "저장에 실패하였습니다."); }
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 휴복직기준 복직신청 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveTimeOffAppReturnWorkAppDet", method = RequestMethod.POST )
	public ModelAndView saveTimeOffAppReturnWorkAppDet(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0; 
		try{ cnt = timeOffAppService.saveTimeOffAppReturnWorkAppDet(paramMap);
			if (cnt > 0) { message= language.getMessage("msg.109987", "저장되었습니다.");}  else { message= language.getMessage("msg.alertSaveNoData", "저장된 내용이 없습니다."); }
		}catch(Exception e){ cnt=-1; message= language.getMessage("msg.alertSaveFail2", "저장에 실패하였습니다."); }
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 휴복직기준 관리 일반 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveTimeOffAppDet", method = RequestMethod.POST )
	public ModelAndView saveTimeOffAppDet(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0; 
		try{ cnt = timeOffAppService.saveTimeOffAppDet(paramMap);
			if (cnt > 0) { message= language.getMessage("msg.109987", "저장되었습니다.");}  else { message= language.getMessage("msg.alertSaveNoData", "저장된 내용이 없습니다."); }
		}catch(Exception e){ cnt=-1; message= language.getMessage("msg.alertSaveFail2", "저장에 실패하였습니다."); }
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
		
	/**
	 * 서명 데이타 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveTimeOffAppSignData", method = RequestMethod.POST )
	public ModelAndView saveTimeOffAppSignData(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;
		try{
			String enterCd  = (String) paramMap.get("enterCd");    // 회사코드
			String sabun    = (String) paramMap.get("sabun");      // 사번
			String applSeq = (String) paramMap.get("applSeq");   // 신청서순번
			String applCd = (String) paramMap.get("applCd");   // 신청서코드
			String applYmd  = (String) paramMap.get("applYmd");    //신청일

			// default storage path
			String defaultStoragePath = String.format("%s/timeoffretireapp/%s_%s_%s_%s", enterCd, sabun, applSeq, applCd, applYmd);
			// default file name
			String defaultFileNam = String.format("%s_%s_%s_%s_%s", enterCd, sabun, applSeq, applCd, applYmd);
			
			paramMap.put("signImgPath", String.format("%s/%s.png", defaultStoragePath, defaultFileNam));
			paramMap.put("pdfPath", String.format("%s/%s.pdf", defaultStoragePath, defaultFileNam));

			resultCnt = timeOffAppService.saveTimeOffAppSignData(paramMap);
			if(resultCnt > 0){
				resultCnt = timeOffAppService.saveTimeOffAppProcCall(paramMap);
				if(resultCnt > 0){
					message= language.getMessage("msg.109987", "저장되었습니다.");
				} else {
					message= language.getMessage("msg.alertSaveNoData", "저장된 내용이 없습니다.");
				}
				message= language.getMessage("msg.109987", "저장되었습니다.");
			} else { 
				message= language.getMessage("msg.alertSaveNoData", "저장된 내용이 없습니다.");
			}
		}catch(Exception e){
			resultCnt = -1; message= language.getMessage("msg.alertSaveFail2", "저장에 실패하였습니다.");			
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
	 * getTimeOffAppList 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTimeOffAppList", method = RequestMethod.POST )
	public ModelAndView getRetireAppList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		String ssnEnterCd = String.valueOf(session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<Map<String, Object>> list  = null;
		String Message = "";
		try{
			list = (List<Map<String, Object>>) timeOffAppService.getTimeOffAppList(paramMap);

			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_TIMEOFF);
			if (encryptKey != null) {
				for (Map<String, Object> map : list) {
					map.put("rk", CryptoUtil.encrypt(encryptKey, map.get("applSeq") + "#" + map.get("applCd")  ));
				}
			}
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
	 * 동의서용 rk 생성
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRdRk", method = RequestMethod.POST )
	public ModelAndView getRdRk(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String Message = "";
		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
		Map<String, Object> mapResult = new HashMap<>();

		try{

			String detType = (String) paramMap.get("detType");
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_RETIRE);
			String sabun = paramMap.get("searchApplSabun").toString().isEmpty() ? " " : paramMap.get("searchApplSabun").toString();
			String reqDate = paramMap.get("searchApplYmd").toString().isEmpty() ? " " : paramMap.get("searchApplYmd").toString();
			String sdate = " ";
			String edate = " ";
			if(detType.equals("return")) {
				sdate = paramMap.get("returnDate").toString().isEmpty() ? " " : paramMap.get("returnDate").toString();
			} else if(detType.equals("rest")) {
				sdate = paramMap.get("sdate").toString().isEmpty() ? " " : paramMap.get("sdate").toString();
				edate = paramMap.get("edate").toString().isEmpty() ? " " : paramMap.get("edate").toString();
			}
			String applCd = paramMap.get("searchApplCd").toString().isEmpty() ? " " : paramMap.get("searchApplCd").toString();
			String signFileSeq = paramMap.get("signFileSeq").toString().isEmpty() ? " " : paramMap.get("signFileSeq").toString();
			String note = paramMap.get("reason").toString().isEmpty() ? " " : paramMap.get("reason").toString();

			if (encryptKey != null) {
				String rk = sabun + "#" +
						reqDate + "#" +
						sdate + "#" +
						edate + "#" +
						applCd + "#" +
						signFileSeq + "#" +
						note + "#";
				mapResult.put("rk", CryptoUtil.encrypt(encryptKey, rk));
			}

		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", mapResult);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 동의서용
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAgreeEncryptRd", method = RequestMethod.POST )
	public ModelAndView getAgreeEncryptRd(
			HttpSession session, HttpServletRequest request
			, @RequestBody Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();


		if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {

			String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";

			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_RETIRE);

			String strParam = paramMap.get("rk").toString();

			strParam = strParam.replaceAll("[\\[\\]]", "");
			String[] splited = strParam.split(",") ;

			String mrdPath = "";
			String param = "";
			String sabun = "";
			String reqDate = "";
			String sdate = "";
			String edate = "";
			String applCd = "";
			String signFileSeq = "";
			String note = "";

			for(String str : splited) {
				String strDecrypt = CryptoUtil.decrypt(encryptKey, str.trim()+"");
				String[] keys = strDecrypt.split("#");
				sabun = keys[0];
				reqDate = keys[1];
				sdate = keys[2];
				edate = keys[3];
				applCd = keys[4];
				signFileSeq = keys[5];
				note = keys[6];
			}

			mrdPath =  "hrm/timeOff/TimeOffAgree.mrd";
			param = "/rp [" + ssnEnterCd + "]"
					+ "["+sabun+"]"
					+ "["+reqDate+"]"
					+ "["+sdate+"]"
					+ "["+edate+"]"
					+ "[" + imageBaseUrl + "]"
					+ "["+applCd+"]"
					+ "["+signFileSeq+"]"
					+ "["+note+"]"
			;

			ModelAndView mv = new ModelAndView();
			mv.setViewName("jsonView");
			try {
				mv.addObject("DATA", encryptRdService.encrypt(mrdPath, param));
				mv.addObject("Message", "");
			} catch (Exception e) {
				mv.addObject("Message", "암호화에 실패했습니다.");
			}

			Log.DebugEnd();
			return mv;
		}
		return new ModelAndView("redirect:/Info.do?code=999"); //잘못된 접근
	}

	@RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
	public ModelAndView getEncryptRd(
			HttpSession session, HttpServletRequest request
			, @RequestBody Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();

		//String enterCd = paramMap.get("enterCd");

		if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
//			String type = String.valueOf(paramMap.get("type"));

			String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";

			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_RETIRE);
//			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_RETIRE);
			//rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.

			String strParam = paramMap.get("rk").toString();

			strParam = strParam.replaceAll("[\\[\\]]", "");
			String[] splited = strParam.split(",") ;

			String mrdPath = "";
			String param = "";
			String applSeq = "";
			String applCd = "";
			String signFileSeq = "";

			for(String str : splited) {
				String strDecrypt = CryptoUtil.decrypt(encryptKey, str.trim()+"");
				String[] keys = strDecrypt.split("#");
				applSeq = keys[0];
				applCd = keys[1];
			}

			mrdPath =  "hrm/timeOff/TimeOffAppDet.mrd";
			param = "/rp [" + ssnEnterCd + "]"
					+ "[,('"+ssnEnterCd+"','" +  applSeq + "')]"
					+ "[" + imageBaseUrl + "]"
			;

			ModelAndView mv = new ModelAndView();
			mv.setViewName("jsonView");
			try {
				mv.addObject("DATA", encryptRdService.encrypt(mrdPath, param));
				mv.addObject("Message", "");
			} catch (Exception e) {
				mv.addObject("Message", "암호화에 실패했습니다.");
			}

			Log.DebugEnd();
			return mv;
		}
		return new ModelAndView("redirect:/Info.do?code=999"); //잘못된 접근
	}

    @RequestMapping(params="cmd=getTimeOffAppApplCodeList", method = RequestMethod.POST )
    public ModelAndView getTimeOffAppApplCodeList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = timeOffAppService.getTimeOffAppApplCodeList(paramMap);
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

    @RequestMapping(params="cmd=getTimeOffAppPatDetFamCodeList", method = RequestMethod.POST )
    public ModelAndView getTimeOffAppPatDetFamCodeList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = timeOffAppService.getTimeOffAppPatDetFamCodeList(paramMap);
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

    @RequestMapping(params="cmd=getTimeOffAppPatDetSaveMap", method = RequestMethod.POST )
    public ModelAndView getTimeOffAppPatDetSaveMap(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = timeOffAppService.getTimeOffAppPatDetSaveMap(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", map);
        mv.addObject("Message", Message);

        Log.DebugEnd();
        return mv;
    }

    @RequestMapping(params="cmd=getTimeOffTypeTermMap", method = RequestMethod.POST )
    public ModelAndView getTimeOffTypeTermMap(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = timeOffAppService.getTimeOffTypeTermMap(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", map);
        mv.addObject("Message", Message);

        Log.DebugEnd();
        return mv;
    }

    @RequestMapping(params="cmd=getTimeOffAppPatDetEmpYmdMap", method = RequestMethod.POST )
    public ModelAndView getTimeOffAppPatDetEmpYmdMap(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = timeOffAppService.getTimeOffAppPatDetEmpYmdMap(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", map);
        mv.addObject("Message", Message);

        Log.DebugEnd();
        return mv;
    }

    @RequestMapping(params="cmd=getTimeOffAppPatDetList", method = RequestMethod.POST )
    public ModelAndView getTimeOffAppPatDetList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = timeOffAppService.getTimeOffAppPatDetList(paramMap);
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

    @RequestMapping(params="cmd=getTimeOffAppMap", method = RequestMethod.POST )
    public ModelAndView getTimeOffAppMap(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = timeOffAppService.getTimeOffAppMap(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", map);
        mv.addObject("Message", Message);

        Log.DebugEnd();
        return mv;
    }

    @RequestMapping(params="cmd=getStatusCd", method = RequestMethod.POST )
    public ModelAndView getStatusCd(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = timeOffAppService.getStatusCd(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", map);
        mv.addObject("Message", Message);

        Log.DebugEnd();
        return mv;
    }

    @RequestMapping(params="cmd=getTimeOffAppDetSumMap", method = RequestMethod.POST )
    public ModelAndView getTimeOffAppDetSumMap(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = timeOffAppService.getTimeOffAppDetSumMap(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", map);
        mv.addObject("Message", Message);

        Log.DebugEnd();
        return mv;
    }

    @RequestMapping(params="cmd=getTimeOffAppReturnWorkAppDetSaveMap", method = RequestMethod.POST )
    public ModelAndView getTimeOffAppReturnWorkAppDetSaveMap(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = timeOffAppService.getTimeOffAppReturnWorkAppDetSaveMap(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", map);
        mv.addObject("Message", Message);

        Log.DebugEnd();
        return mv;
    }

    @RequestMapping(params="cmd=getTimeOffAppFamDetList", method = RequestMethod.POST )
    public ModelAndView getTimeOffAppFamDetList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = timeOffAppService.getTimeOffAppFamDetList(paramMap);
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

    @RequestMapping(params="cmd=getTimeOffAppFamDetFamCodeList", method = RequestMethod.POST )
    public ModelAndView getTimeOffAppFamDetFamCodeList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = timeOffAppService.getTimeOffAppFamDetFamCodeList(paramMap);
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

	@RequestMapping(params="cmd=getTimeOffAppReturnWorkAppDetMap", method = RequestMethod.POST )
	public ModelAndView getTimeOffAppReturnWorkAppDetMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		Map<?, ?> result = null;
		String Message = "";
		try{
			result = timeOffAppService.getTimeOffAppReturnWorkAppDetMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


}