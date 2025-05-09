package com.hr.tim.annual.annualPlanApp;

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
import com.hr.common.util.ParamUtils;

/**
 * 제증명신청 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/AnnualPlanApp.do", method=RequestMethod.POST )
public class AnnualPlanAppController {

	/**
	 * 제증명신청 서비스
	 */
	@Inject
	@Named("AnnualPlanAppService")
	private AnnualPlanAppService annualPlanAppService;

	@Autowired
	private EncryptRdService encryptRdService;

	@Autowired
	private SecurityMgrService securityMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Value("${rd.image.base.url}")
	private String imageBaseUrl;
	
	/**
	 * annualPlanApp View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAnnualPlanApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAnnualPlanApp() throws Exception {
		return "tim/annual/annualPlanApp/annualPlanApp";
	}
	
	/**
	 * 제증명신청 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAnnualPlanApp", method = RequestMethod.POST )
	public ModelAndView saveAnnualPlanApp(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = annualPlanAppService.saveAnnualPlanApp(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
	 * annualPlanApp 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanAppList", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanAppList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		String ssnEnterCd = session.getAttribute("ssnEnterCd").toString();

		List<Map<String, Object>> list = null;
		String Message = "";
		try{
			if(ssnEnterCd != null) {
				list =  (List<Map<String, Object>>) annualPlanAppService.getAnnualPlanAppList(paramMap);
				String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM);
				if (encryptKey != null) {
					for (Map<String, Object> map : list) {
						String rk = map.get("sabun") + "#" +
								map.get("applSeq") + "#" +
								map.get("seq") + "#";
						map.put("rk", CryptoUtil.encrypt(encryptKey, rk));
					}
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

		if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
			String ssnEnterCd = session.getAttribute("ssnEnterCd").toString();

			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM);

			String rk = CryptoUtil.decrypt(encryptKey, paramMap.get("rk")+"");
			String[] rks = rk.split("#");

			String type = paramMap.get("type").toString();
			String mrdPath = type.equals("apr") ? "/tim/annual/annualPlanApr.mrd" : "/tim/annual/annualPlanNotify.mrd";

			String param = "/rp [ '" + ssnEnterCd + "' ]"
					+ " ['" + rks[0] + "']"
					+ " ['" + rks[1] + "']"
					+ " ['" + rks[2] + "']"
					+ " ['" + imageBaseUrl + "']"
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
	 * annualPlanApp 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAbleAnnualPlanCount", method = RequestMethod.POST )
	public ModelAndView getAbleAnnualPlanCount(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = annualPlanAppService.getAbleAnnualPlanCount(paramMap);
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
}
