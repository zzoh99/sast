package com.hr.hrm.successor.succPsnalEmp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.rd.EncryptRdService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;

/**
 * succPsnalEmp Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/SuccPsnalEmp.do", method=RequestMethod.POST )
public class SuccPsnalEmpController {
	/**
	 * succPsnalEmp 서비스
	 */
	@Inject
	@Named("SuccPsnalEmpService")
	private SuccPsnalEmpService succPsnalEmpService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	/*AuthTable */
	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;

	@Inject
	@Named("EncryptRdService")
	private EncryptRdService encryptRdService;

	@Autowired
	private SecurityMgrService securityMgrService;

	@Value("${rd.image.base.url}")
	private String imageBaseUrl;


	/**
	 * succPsnalEmp View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSuccPsnalEmp", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSuccPsnalEmp() throws Exception {
		return "hrm/successor/succPsnalEmp/succPsnalEmp";
	}

	/**
	 * succPsnalEmp(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSuccPsnalEmpPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSuccPsnalEmpPop() throws Exception {
		return "hrm/successor/succPsnalEmp/succPsnalEmpPop";
	}

	/**
	 * getSuccPsnalEmpOrgList 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSuccPsnalEmpOrgList", method = RequestMethod.POST )
	public ModelAndView getSuccPsnalEmpOrgList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = succPsnalEmpService.getSuccPsnalEmpOrgList(paramMap);
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
	 * getSuccPsnalEmpUserList 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSuccPsnalEmpUserList", method = RequestMethod.POST )
	public ModelAndView getSuccPsnalEmpUserList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		//List<?> list  = new ArrayList<Object>();
		List<Map<String, Object>>  list = null;
		String Message = "";
		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
		try{
			list =  (List<Map<String, Object>>) succPsnalEmpService.getSuccPsnalEmpUserList(paramMap);
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_SUCCEMPCARD);
			
            if (encryptKey != null) {
                for (Map<String, Object> map  : list) {
                    map.put("rk", CryptoUtil.encrypt(encryptKey, map.get("enterCd") + "#" + map.get("sabun")));
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
	 * succPsnalEmp 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSuccPsnalEmpList", method = RequestMethod.POST )
	public ModelAndView getSuccPsnalEmpList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = succPsnalEmpService.getSuccPsnalEmpList(paramMap);
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
	 * succPsnalEmp 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSuccPsnalEmp", method = RequestMethod.POST )
	public ModelAndView saveSuccPsnalEmp(
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
			resultCnt =succPsnalEmpService.saveSuccPsnalEmp(convertMap);
			if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
	 * succPsnalEmp 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSuccPsnalEmpMap", method = RequestMethod.POST )
	public ModelAndView getSuccPsnalEmpMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		try{
			map = succPsnalEmpService.getSuccPsnalEmpMap(paramMap);
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
	
	/**
	 * succPsnalEmp 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSuccEmpMap", method = RequestMethod.POST )
	public ModelAndView getSuccEmpMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		try{
			map = succPsnalEmpService.getSuccEmpMap(paramMap);
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
	
	/**
	 * 퇴직설문항목관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSuccPsnalEmpUserList", method = RequestMethod.POST )
	public ModelAndView saveRetireMgr(
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
			resultCnt =succPsnalEmpService.saveSuccPsnalEmpUserList(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
 * RD 데이터 암호화
 * @param session
 * @param request
 * @param paramMap
 * @return
 * @throws Exception
 */
@RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
public ModelAndView getEncryptRd(
		HttpSession session, HttpServletRequest request
		, @RequestBody Map<String, Object> paramMap) throws Exception{
	Log.DebugStart();

	//String enterCd = paramMap.get("enterCd");

	if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
		String ssnSabun = session.getAttribute("ssnSabun") + "";
		String ssnLocaleCd = session.getAttribute("ssnLocaleCd") + "";

		//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
		String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_SUCCEMPCARD);
		//rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.

		String strParam = paramMap.get("rk").toString();


		strParam = strParam.replaceAll("[\\[\\]]", "");
		String[] splited = strParam.split(",") ;

        StringBuilder empKeys = new StringBuilder();
        StringBuilder empSabunKeys = new StringBuilder();

		if (StringUtils.isNoneEmpty(splited)) {
			for (String str : splited) {
				String strDecrypt = CryptoUtil.decrypt(encryptKey, str.trim() + "");
				String[] keys = strDecrypt.split("#");

				//('회사코드','사번')
				empKeys.append(",('").append(keys[0]).append("','").append(keys[1]).append("')");
				//,사번
				empSabunKeys.append(",").append(keys[1]);
				//첫문째문자제거
				empSabunKeys.deleteCharAt(0);
			}
		}
		String securityKey = request.getAttribute("securityKey")+"";

		String itemType = paramMap.get("itemType")+"";
		String mrdPath = itemType.equals("1") ? "/hrm/empcard/PersonInfoCardType1_HR.mrd" : "/hrm/empcard/PersonInfoCardType2_HR.mrd";
		String param = "/rp [" +  empKeys + "]"
				+ " [" + imageBaseUrl + "] "
				+ " [" + paramMap.get("maskingYn") + "]" // 마스킹 여부
				+ " [Y]" // hrbasic1
				+ " [Y]" // hrbasic2
				+ " [Y]" // 발령사항
				+ " [Y]" // 교육사항
				+ " [" +  paramMap.get("hrAppt") +"]" // 전체발령표시여부
				+ " [" + ssnEnterCd + "]"
				+ " ['" + ssnSabun + "']"
				+ " [" + ssnLocaleCd + "]"
				+ " ['" + empSabunKeys + "']"  //사번
                + " [" +  paramMap.get("rdViewType6") +"]" // 평가
                + " [" +  paramMap.get("rdViewType") +"]" // 타부서발령여부
                + " [" +  paramMap.get("rdViewType") +"]" // 연락처
                + " [" +  paramMap.get("rdViewType3") +"]" // 병역
                + " [" +  paramMap.get("rdViewType4") +"]" // 학력
                + " [" +  paramMap.get("rdViewType5") +"]" // 경력
                + " [" +  paramMap.get("rdViewType7") +"]" // 포상
                + " [" +  paramMap.get("rdViewType8") +"]" // 징계
                + " [" +  paramMap.get("rdViewType9") +"]" // 자격
                + " [" +  paramMap.get("rdViewType10") +"]" // 어학
                + " [" +  paramMap.get("rdViewType11") +"]" // 가족
                + " [" +  paramMap.get("rdViewType12") +"]" // 발령
                + " [" +  paramMap.get("rdViewType13") +"]" // 경력
				+ " [" + securityKey + "] "
				+ " /rv securityKey[" + securityKey + "] /rloadimageopt [1]"
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
	  return null;
}

/**
 * rk 생성
 *
 * @param session
 * @param request
 * @param paramMap
 * @return ModelAndView
 * @throws Exception
 */
@RequestMapping(params="cmd=getEmpCardPrtRk", method = RequestMethod.POST )
public ModelAndView getEmpCardPrtRk(
		HttpSession session,  HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap ) throws Exception {
	Log.DebugStart();

	paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
	paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

	String Message = "";
	String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
	Map<String, Object> mapResult = new HashMap<>();

	try{
		String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_EMPCARD);

		if (encryptKey != null) {
			mapResult.put("rk", CryptoUtil.encrypt(encryptKey, paramMap.get("enterCd") + "#" + paramMap.get("sabun")));

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
}
