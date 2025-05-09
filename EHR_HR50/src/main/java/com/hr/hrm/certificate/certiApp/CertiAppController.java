package com.hr.hrm.certificate.certiApp;
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
@RequestMapping(value="/CertiApp.do", method=RequestMethod.POST )
public class CertiAppController {

	/**
	 * 제증명신청 서비스
	 */
	@Inject
	@Named("CertiAppService")
	private CertiAppService certiAppService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("EncryptRdService")
	private EncryptRdService encryptRdService;

	@Autowired
	private SecurityMgrService securityMgrService;

	//@Value("${rd.image.base.url}")
	@Value("${rd.image.base.url}")
	private String imageBaseUrl;
	/**
	 * 제증명신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCertiApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCertiApp() throws Exception {
		return "hrm/certificate/certiApp/certiApp";
	}
	
	/**
	 * 제증명신청 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCertiAppList", method = RequestMethod.POST )
	public ModelAndView getCertiAppList(
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
				list =  (List<Map<String, Object>>) certiAppService.getCertiAppList(paramMap);
				String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_CERTIFICATE);
				if (encryptKey != null) {
					for (Map<String, Object> empMap : list) {
						empMap.put("rk", CryptoUtil.encrypt(encryptKey,  empMap.get("applCd") + "#" + empMap.get("sabun")));
					}
				}
			}

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
	 * 제증명신청 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveCertiApp", method = RequestMethod.POST )
	public ModelAndView saveCertiApp(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = certiAppService.saveCertiApp(convertMap);
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
	 * getEmployeeInfoMap 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmployeeInfoMap", method = RequestMethod.POST )
	public ModelAndView getEmployeeInfoMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = certiAppService.getEmployeeInfoMap(paramMap);
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
	 * getLoanStdDateCertiApp 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLoanStdDateCertiApp", method = RequestMethod.POST )
	public ModelAndView getLoanStdDateCertiApp(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		Map<?, ?> map = null;
		String Message = "";
		
		try{
			map = certiAppService.getLoanStdDateCertiApp(paramMap);
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
			String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
			String ssnSabun = session.getAttribute("ssnSabun") + "";
			String ssnLocaleCd = session.getAttribute("ssnLocaleCd") + "";

			String mrdPath = "";
			mrdPath = paramMap.get("mrdPath")+"";
			String applCd = "";
			String param = "";
			String securityKey = request.getAttribute("securityKey")+"";

			if(paramMap.containsKey("rp")){
				param += "/rp ";
				Map<String, String> rpMap = (Map<String, String>) paramMap.get("rp");
				applCd = rpMap.get("applCd")+"";

				//원천징수영수증
				if(applCd.equals("16")){
					int reqYy = Integer.parseInt(rpMap.get("reqYy"));
					if(reqYy >= 2007) {
						mrdPath = "cpn/yearEnd/WorkIncomeWithholdReceipt_"+reqYy+".mrd";
					} else {
						mrdPath = "cpn/yearEnd/WorkIncomeWithholdReceipt.mrd";
					}

					param += " ["+ssnEnterCd+"]"
						  + "[" + reqYy + "]"
						  + "[" + 1 + "]"
						  + "['" + rpMap.get("sabun") + "']"
						  + "['']"
						  + "[ALL]"
						  + "[A]"
						  + "["+imageBaseUrl+rpMap.get("imgPath") + "]"
						  + "[4]"
						  + "[" + rpMap.get("sabun") + "]"
						  + "[1]"
						  + "[7]"
						  + "[" + rpMap.get("date") + "]"
						  + "[Stamp_Ingam.gif]"
						  + "[1]"
						  + "[" + rpMap.get("stamp") + "]"
						  + "[N]" //사대보험출력여부
						  + "[" + 1 + "]"
						  + " /rv sKey[] gKey[] sType[] qId[] themKey[] securityKey[" + securityKey + "]"
					;
				}
				//원천징수부
				else if(applCd.equals("19")){
					int reqYy = Integer.parseInt(rpMap.get("reqYy"));
					if(reqYy >= 2008) {
						mrdPath = "cpn/yearEnd/EmpWorkIncomeWithholdReceiptBook_"+reqYy+".mrd";
					} else {
						mrdPath = "cpn/yearEnd/EmpWorkIncomeWithholdReceiptBook.mrd";
					}

					param += "["+ssnEnterCd+"]"
							+ "["+reqYy+"]"
							+ "[9]"
							+ "['"+rpMap.get("sabun")+"']"
							+ "[]"
							+ "[ALL]"
							+ "["+rpMap.get("date")+"]"
							+ "[4]"
							+ "["+rpMap.get("sabun")+"]"
							+ "[]"
							+ "["+rpMap.get("date")+"]"
							+ "["+imageBaseUrl+rpMap.get("imgPath") + "]"
							+ "[Stamp_Ingam.gif]"
							+ "[0]"
							+ "[1]"
							+ "[N]" //사대보험출력여부
							+ "[9]"
							+ " /rv sKey[] gKey[] sType[] qId[] themKey[] securityKey[" + securityKey + "]"

					;
				}
				//갑근세증명원
				else if(applCd.equals("18")){

					param += "["+ssnEnterCd+"]"
							+ "["+rpMap.get("sYmd")+"]"
							+ "["+rpMap.get("eYmd")+"]"
							+ "["+rpMap.get("sabun")+"]"
							+ "[10]"
							+ "["+rpMap.get("purpose")+"]"
							+ "["+rpMap.get("submitOffice")+"]"
							+ "[]"
							+ "["+imageBaseUrl+"]"
							+ " /rv securityKey[" + securityKey + "]"
					;

				}
				//재직,경력증명서
				else{
					param += "["+ssnEnterCd+"] ["+rpMap.get("applSeq")+"] ["+imageBaseUrl+"]";
				}

			}
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
