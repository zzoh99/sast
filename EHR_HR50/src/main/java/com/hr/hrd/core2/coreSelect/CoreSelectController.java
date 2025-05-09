package com.hr.hrd.core2.coreSelect;

import com.hr.common.logger.Log;
import com.hr.common.rd.EncryptRdService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.ParamUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 핵심인재선정 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/CoreSelect.do", method=RequestMethod.POST )
public class CoreSelectController {

	/**
	 * 핵심인재선정 서비스
	 */
	@Inject
	@Named("CoreSelectService")
	private CoreSelectService coreSelectService;

	@Inject
	@Named("EncryptRdService")
	private EncryptRdService encryptRdService;

	@Autowired
	private SecurityMgrService securityMgrService;

	@Value("${rd.image.base.url}")
	private String imageBaseUrl;

	/**
	 * 핵심인재선정 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCoreSelect", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCoreSelect() throws Exception {
		return "hrd/core2/coreSelect/coreSelect";
	}

	/**
	 * 조건 불러오기 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCoreSelectConditionLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCoreSelectConditionLayer() throws Exception {
		return "hrd/core2/coreSelect/coreSelectConditionLayer";
	}

	/**
	 * 키워드 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCoreSelectKeywordLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCoreSelectKeywordLayer() throws Exception {
		return "hrd/core2/coreSelect/coreSelectKeywordLayer";
	}

	/**
	 *  핵심인재후보추천자 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCoreSelectList", method = RequestMethod.POST )
	public ModelAndView getCoreSelectList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		String ssnEnterCd = String.valueOf(session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));

		try {
			mv.addObject("DATA", coreSelectService.getCoreSelectList(paramMap));
			mv.addObject("Message", "");
		} catch(Exception e) {
			Log.Error("조회에 실패하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("DATA", new ArrayList<>());
			mv.addObject("Message", "조회에 실패하였습니다.");
		}
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 핵심인재 Pool-In 저장
	 */
	@RequestMapping(params="cmd=saveCoreSelectPoolIn", method = RequestMethod.POST )
	public ModelAndView saveCoreSelectPoolIn(
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
			resultCnt = coreSelectService.saveCoreSelectPoolIn(convertMap);
			if(resultCnt > 0){
				message="저장 되었습니다.";
			} else{
				message="저장된 내용이 없습니다.";
			}
		}catch(Exception e){
			resultCnt = -1;
			message="저장에 실패하였습니다.";
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
	 * 핵심인재 다건조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCoreSelectList2", method = RequestMethod.POST )
	public ModelAndView getCoreSelectList2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = coreSelectService.getCoreSelectList2(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 핵심인재 Pool-Out 저장
	 */
	@RequestMapping(params="cmd=saveCoreSelectPoolOut", method = RequestMethod.POST )
	public ModelAndView saveCoreSelectPoolOut(
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
			resultCnt = coreSelectService.saveCoreSelectPoolOut(convertMap);
			if(resultCnt > 0){
				message="저장 되었습니다.";
			} else{
				message="저장된 내용이 없습니다.";
			}
		}catch(Exception e){
			resultCnt = -1;
			message="저장에 실패하였습니다.";
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
	 * 핵심인재 저장
	 */
	@RequestMapping(params="cmd=saveCoreSelect2", method = RequestMethod.POST )
	public ModelAndView saveCoreSelect2(
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
			resultCnt = coreSelectService.saveCoreSelect2(convertMap);
			if(resultCnt > 0){
				message="저장 되었습니다.";
			} else{
				message="저장된 내용이 없습니다.";
			}
		}catch(Exception e){
			resultCnt = -1;
			message="저장에 실패하였습니다.";
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
	 *  핵심인재_이미 추가된 대상자 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCoreSelectIsExistsMap", method = RequestMethod.POST )
	public ModelAndView getCoreSelectIsExistsMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = new HashMap<String, Object>();
		String Message = "";

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		try {
			map = coreSelectService.getCoreSelectIsExistsMap(convertMap);
		} catch(Exception e) {
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
	 * 핵심인재_과거이력 다건조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCoreSelectList3", method = RequestMethod.POST )
	public ModelAndView getCoreSelectList3(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = coreSelectService.getCoreSelectList3(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
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
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		String Message = "";
		String ssnEnterCd = String.valueOf(session.getAttribute("ssnEnterCd"));
		Map<String, Object> mapResult = new HashMap<>();

		try{
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM);

			if (encryptKey != null) {
				String sabun = String.valueOf(paramMap.get("sabun"));
				mapResult.put("rk", CryptoUtil.encrypt(encryptKey, ssnEnterCd + "#" + sabun));
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

	@RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
	public ModelAndView getEncryptRd(
			HttpSession session, HttpServletRequest request
			, @RequestBody Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();

		if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
			String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
			String ssnSabun = session.getAttribute("ssnSabun") + "";
			String ssnLocaleCd = session.getAttribute("ssnLocaleCd") + "";

			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM);
			//rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.
			String empKey = CryptoUtil.decrypt(encryptKey, paramMap.get("rk")+"");
			String[] empKeys = empKey.split("#");

			String securityKey = request.getAttribute("securityKey")+"";

			String mrdPath = "/hrm/empcard/PersonInfoCardType1_HR.mrd";
			String param = "/rp [ ,('" + empKeys[0] + "','" + empKeys[1] +"') ]"
					+ " [" + imageBaseUrl + "] "
					+ " [Y]" // 마스킹 여부
					+ " [Y]" // hrbasic1
					+ " [Y]" // hrbasic2
					+ " [Y]" // 발령사항
					+ " [Y]" // 교육사항
					+ " [Y]" // 전체발령표시여부
					+ " [" + ssnEnterCd + "]"
					+ " ['" + ssnSabun + "']"
					+ " [" + ssnLocaleCd + "]"
					+ " ['," + empKeys[1] + "']"
					+ " [Y]" // 평가
					+ " [Y]" // 타부서발령여부
					+ " [Y]" // 연락처
					+ " [Y]" // 병역
					+ " [Y]" // 학력
					+ " [Y]" // 경력
					+ " [Y]" // 포상
					+ " [Y]" // 징계
					+ " [Y]" // 자격
					+ " [Y]" // 어학
					+ " [Y]" // 가족
					+ " [Y]" // 발령
					+ " [Y]" // 경력
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

	@RequestMapping(params="cmd=getEncryptRd2", method = RequestMethod.POST )
	public ModelAndView getEncryptRd2(
			HttpSession session, HttpServletRequest request
			, @RequestBody Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();

		if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
			String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
			String ssnSabun = session.getAttribute("ssnSabun") + "";
			String ssnLocaleCd = session.getAttribute("ssnLocaleCd") + "";

			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM);
			//rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.
			String empKey = CryptoUtil.decrypt(encryptKey, paramMap.get("rk")+"");
			String[] empKeys = empKey.split("#");

			String securityKey = request.getAttribute("securityKey")+"";

			String mrdPath = "/hrm/empcard/SuccessorCard.mrd";
			String param = "/rp [ ,('" + empKeys[0] + "','" + empKeys[1] +"') ]"
					+ " [" + imageBaseUrl + "] "
					+ " [Y]" // 마스킹 여부
					+ " [" + ssnEnterCd + "]"
					+ " ['" + ssnSabun + "']"
					+ " [" + ssnLocaleCd + "]"
					+ " ['," + empKeys[1] + "']"
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
}