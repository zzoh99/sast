package com.hr.hrm.empContract.perEmpContractSrch;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.com.ComService;
import com.hr.common.rd.EncryptRdService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.code.CommonCodeService;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * perEmpContractSrch Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/PerEmpContractSrch.do", method=RequestMethod.POST )
public class PerEmpContractSrchController {
	/**
	 * perEmpContractSrch 서비스
	 */
	@Inject
	@Named("PerEmpContractSrchService")
	private PerEmpContractSrchService perEmpContractSrchService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Value("${rd.image.base.url}")
	private String imageBaseUrl;


	@Autowired private EncryptRdService encryptRdService;

	@Autowired private ComService comService;

	/*
	@RequestMapping
	public String test(HttpServletRequest request) {
		Log.Debug("CMD = " + request.getParameter("cmd"));
		return "hrm/empContract/perEmpContractSrch/perEmpContractSrch";
	}
	*/
	
	/**
	 * perEmpContractSrch View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerEmpContractSrch", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerEmpContractSrch() throws Exception {
		Log.Debug("CALL CMD = VIEW PER EMP CONTRACT SRCH");
		return "hrm/empContract/perEmpContractSrch/perEmpContractSrch";
	}

	/**
	 * perEmpContractSrch(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerEmpContractSrchPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerEmpContractSrchPop() throws Exception {
		return "hrm/empContract/perEmpContractSrch/perEmpContractSrchPop";
	}

	/**
	 * perEmpContractSrch 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerEmpContractSrchList", method = RequestMethod.POST )
	public ModelAndView getPerEmpContractSrchList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
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
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
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
	@RequestMapping(params="cmd=savePerEmpContractSrch", method = RequestMethod.POST )
	public ModelAndView savePerEmpContractSrch(
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
			resultCnt =perEmpContractSrchService.savePerEmpContractSrch(convertMap);
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
	 * perEmpContractSrch 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerEmpContractSrchMap", method = RequestMethod.POST )
	public ModelAndView getPerEmpContractSrchMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = perEmpContractSrchService.getPerEmpContractSrchMap(paramMap);
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
	 * RD Layer
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerEmpContractSrchLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerEmpContractSrchLayer() throws Exception {
		return "hrm/empContract/perEmpContractSrch/perEmpContractSrchLayer";
	}

	/**
	 * 싸인 패드 레이어
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSignPadLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSignPadLayer() throws Exception {
		return "hrm/empContract/perEmpContractSrch/signPadLayer";
	}



	@RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
	public ModelAndView getEncryptRd(
			HttpSession session, HttpServletRequest request
			, @RequestBody Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();

		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
		String ssnSabun = session.getAttribute("ssnSabun") + "";

		String param = "";

		if(paramMap.containsKey("rv")){

		}

		//String enterCd = paramMap.get("enterCd");

		if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
			paramMap.put("str", paramMap.get("rk")+"");
			paramMap.put("enterCd", ssnEnterCd);
			paramMap.put("encType", "A");
			String decStr = comService.getComDecRtnStr(paramMap, "getDecryptByEncType");
			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.

			String[] splited = decStr.split("#") ;

			if(paramMap.containsKey("rp")){
				param += "/rp ";
				Map<String, String> rpMap = (Map<String, String>) paramMap.get("rp");
				param += "[" + ssnEnterCd + "] [(('" + splited[0] +"','"+ splited[1]+"','"+rpMap.get("stdDate")+"'))] [" + imageBaseUrl + "]";
			}

			String mrdPath = paramMap.get("mrdPath")+"";
//			String param = "/rp ['" + ssnEnterCd + "']"
//					+ " [ '" +  payAcitionCdKey + "' ]"
//					+ " [ " +  empKeys + " ]"
//					+ " [ " + imageBaseUrl + " ] "
//					;

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
}
