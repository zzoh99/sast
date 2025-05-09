package com.hr.cpn.payRetire.retMonPayAdjust;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.rd.EncryptRdService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.cpn.payRetire.retMonRptSta.RetMonRptStaService;

/**
 * 퇴직종합정산서
 *
 */
@Controller
@RequestMapping(value="/RetMonPayAdjust.do", method=RequestMethod.POST ) 
public class RetMonPayAdjustController extends ComController {
		
	@Inject
	@Named("RetMonRptStaService")
	private RetMonRptStaService retMonRptStaService;
	
    @Autowired
    private SecurityMgrService securityMgrService;

	@Inject
	@Named("EncryptRdService")
	private EncryptRdService encryptRdService;
    
	/**
	 * 퇴직종합정산서 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetMonPayAdjust", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetMonPayAdjust() throws Exception {
		return "cpn/payRetire/retMonPayAdjust/retMonPayAdjust";
	}

	/**
	 * retMonRptSta 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetMonRptStaList", method = RequestMethod.POST )
	public ModelAndView getRetMonRptStaList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		String ssnEnterCd = session.getAttribute("ssnEnterCd")+"";
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		//List<?> list  = new ArrayList<Object>();
		List<Map<String, Object>> list = null;
		
	
		String Message = "";
		try{
		    if(ssnEnterCd != null) {
		        list =  (List<Map<String, Object>>) retMonRptStaService.getRetMonRptStaList(paramMap);
		        String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.CPN_RETMONRPTSTA);
		        if (encryptKey != null) {
                    for (Map<String, Object> empMap : list) {
                        empMap.put("rk", CryptoUtil.encrypt(encryptKey,  empMap.get("payActionCd") + "#" + empMap.get("sabun")));
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

	@RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
	public ModelAndView getEncryptRd(
			HttpSession session, HttpServletRequest request
			, @RequestBody Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();

		if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
			String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";

			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.CPN_RETMONRPTSTA);
			//rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.

			String strParam = paramMap.get("rk").toString();
			strParam = strParam.replaceAll("[\\[\\]]", "");
			String[] splited = strParam.split(",") ;

			StringBuilder sabunAndPayActionCds = new StringBuilder();

			for(String str : splited) {
				String strDecrypt = CryptoUtil.decrypt(encryptKey, str.trim()+"");
				String[] keys = strDecrypt.split("#");

				//'사번_급여구분'
				sabunAndPayActionCds.append(",'" + keys[1] + "_" + keys[0] + "'");
			}

			//첫문째문자제거
			sabunAndPayActionCds.deleteCharAt(0);

			String mrdPath = "/cpn/payRetire/RetirementPayAdjust2.mrd";
			String param = "/rp [" + ssnEnterCd + "]"
					+ " [" +  sabunAndPayActionCds + "]"
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
