package com.hr.hrm.retire.retireApp;
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

import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 퇴직신청 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/RetireApp.do", method=RequestMethod.POST )
public class RetireAppController {

	/**
	 * 퇴직신청 서비스
	 */
	@Inject
	@Named("RetireAppService")
	private RetireAppService retireAppService;

	@Autowired
	private SecurityMgrService securityMgrService;

	/**
	 * viewRetireApp View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetireApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetireApp() throws Exception {
		return "hrm/retire/retireApp/retireApp";
	}
	
	/**
	 * getRetireAppList 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetireAppList", method = RequestMethod.POST )
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
			list = (List<Map<String, Object>>) retireAppService.getRetireAppList(paramMap);

			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_RETIRE);
			if (encryptKey != null) {
				for (Map<String, Object> map : list) {
					map.put("rk", CryptoUtil.encrypt(encryptKey, map.get("sabun") + "#" + map.get("applYmd") + "#" + map.get("signFileSeq")));
					map.put("rk2", CryptoUtil.encrypt(encryptKey, map.get("sabun") + "#" + map.get("applYmd") + "#" + map.get("applSeq") + "#" + map.get("signFileSeq1")
							+ "#" + map.get("finWorkYmd") + "#" + map.get("retSchYmd") + "#" + map.get("note") + "#" + map.get("retContractNo")));
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
	 *  퇴직신청  저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRetireApp", method = RequestMethod.POST )
	public ModelAndView saveRetireApp(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = retireAppService.saveRetireApp(convertMap);
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
}
