package com.hr.cpn.personalPay.perPayPartiUserSta1;
import java.util.ArrayList;
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

import com.hr.common.logger.Log;

/**
 * 월별급여지급현황 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/PerPayPartiUserSta1.do", method=RequestMethod.POST )
public class PerPayPartiUserSta1Controller {

	/**
	 * 월별급여지급현황 서비스
	 */
	@Inject
	@Named("PerPayPartiUserSta1Service")
	private PerPayPartiUserSta1Service perPayPartiUserSta1Service;

	@Inject
	@Named("EncryptRdService")
	private EncryptRdService encryptRdService;

	@Autowired
	private SecurityMgrService securityMgrService;

	@Value("${rd.image.base.url}")
	private String imageBaseUrl;

	/**
	 * 월별급여지급현황 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayPartiUserSta1", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiUserSta1() throws Exception {
		return "cpn/personalPay/perPayPartiUserSta1/perPayPartiUserSta1";
	}


	/**
	 * 월별급여지급현황 지급내역 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayPartiUserSta1List1", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiUserSta1List1(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayPartiUserSta1Service.getPerPayPartiUserSta1List("getPerPayPartiUserSta1List1", paramMap);
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
	 * 월별급여지급현황 지급내역 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayPartiUserSta1List2", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiUserSta1List2(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayPartiUserSta1Service.getPerPayPartiUserSta1List("getPerPayPartiUserSta1List2", paramMap);
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
	 * 월별급여지급현황 지급총액,공제총액, 실지급액 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayPartiUserSta1TaxMap", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiUserSta1TaxMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		String ssnEnterCd = session.getAttribute("ssnEnterCd").toString();
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<String, Object> map = null;

		try{
			map = perPayPartiUserSta1Service.getPerPayPartiUserSta1Map("getPerPayPartiUserSta1TaxMap", paramMap);
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.CPN_PARTIPOPSTA);
			map.put("rk", CryptoUtil.encrypt(encryptKey, paramMap.get("payActionCd") + "#" + paramMap.get("sabun")));
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map",map);
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
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.CPN_PARTIPOPSTA);
			//rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.

			String strParam = paramMap.get("rk").toString();

			strParam = strParam.replaceAll("[\\[\\]]", "");
			String[] splited = strParam.split(",") ;

			List<String> list = new ArrayList<String>();
			String payAcitionCdKey = "";

			for(String str : splited) {
				String strDecrypt = CryptoUtil.decrypt(encryptKey, str.trim()+"");
				String[] keys = strDecrypt.split("#");
				payAcitionCdKey = keys[0];
				//순서위해 list에 들어감
				list.add(keys[1]);
			}
			StringBuilder empKeys = new StringBuilder();

			for (String str  : list) {
				//'사번'
				empKeys.append(",'" + str + "'");
			}
			//첫문째문자제거
			empKeys.deleteCharAt(0);

			String mrdPath = "/cpn/payReport/PayAllowanceParticulars.mrd";
			String param = "/rp ['" + ssnEnterCd + "']"
					+ " [ '" +  payAcitionCdKey + "' ]"
					+ " [ " +  empKeys + " ]"
					+ " [ " + imageBaseUrl + " ] "
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
}
