package com.hr.cpn.payReport.payPrintSta;
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
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 급/상여대장 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PayPrintSta.do", method=RequestMethod.POST )
public class PayPrintStaController {
	/**
	 * 급/상여대장 서비스
	 */
	@Inject
	@Named("PayPrintStaService")
	private PayPrintStaService payPrintStaService;

	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;

	@Inject
	@Named("EncryptRdService")
	private EncryptRdService encryptRdService;

	/**
	 * 급/상여대장 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayPrintSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayPrintSta() throws Exception {
		return "cpn/payReport/payPrintSta/payPrintSta";
	}

	/**
	 * 공통코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSheetHeaderCnt1", method = RequestMethod.POST )
	public ModelAndView getCommonCodeList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
//		paramMap.put("name", 	session.getAttribute("ssnName"));
//		paramMap.put("foreignYn",session.getAttribute("ssnForeignYn"));
//		paramMap.put("birYmd", 	session.getAttribute("ssnBirYmd"));
		List<?> result = payPrintStaService.getSheetHeaderCnt1(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 급/상여대장 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayPrintStaList", method = RequestMethod.POST )
	public ModelAndView getPayPrintStaList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = payPrintStaService.getPayPrintStaList(paramMap);
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
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM);
			String payActionCd = paramMap.get("searchPayActionCd").toString();
			String bpCd = paramMap.get("searchBusinessPlaceCd").toString();
			String orgCd = paramMap.get("searchOrgCd").toString();
			String prtUnit = paramMap.get("searchPrintUnit").toString();
			if (encryptKey != null) {
				String rk = payActionCd + "#" +
							bpCd + "#" +
							orgCd + "#" +
							prtUnit + "#" +
							prtUnit + "#";
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

	@RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
	public ModelAndView getEncryptRd(
			HttpSession session, HttpServletRequest request
			, @RequestBody Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();

		if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
			String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";

			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM);

			String rk = CryptoUtil.decrypt(encryptKey, paramMap.get("rk")+"");
			String[] rks = rk.split("#");

			String securityKey = request.getAttribute("securityKey")+"";

			String mrdPath = "/cpn/payReport/PaySheet_R2.mrd";
			String param = "/rp [ '" + ssnEnterCd + "' ]"
					+ " ['" + rks[0] + "']"
					+ " ['" + rks[1] + "']"
					+ " ['" + rks[2] + "']"
					+ " ['" + rks[3] + "']"
					+ " ['CC']"
					+ " ['1']"
					+ " /rv securityKey[" + securityKey + "]"
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
