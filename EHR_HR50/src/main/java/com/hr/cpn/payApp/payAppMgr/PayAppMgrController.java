package com.hr.cpn.payApp.payAppMgr;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;


/**
 * 급여지급승인 Controller
 *
 * @author YSH
 *
 */
@Controller
@RequestMapping(value="/PayAppMgr.do", method=RequestMethod.POST )
public class PayAppMgrController {

	/**
	 * 급여지급승인 서비스
	 */
	@Inject
	@Named("PayAppMgrService")
	private PayAppMgrService payAppMgrService;
	
	/**
	 *  급여지급승인  전자서명 데이터 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePayAppMgrSignData", method = RequestMethod.POST )
	public ModelAndView savePayAppMgrSignData(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
		
		String message = "";
		int resultCnt = -1;
		try{
			
			String enterCd     = (String) paramMap.get("ssnEnterCd");	// 회사코드
			String payActionCd = (String) paramMap.get("payActionCd");	// 급여계산코드
			
			// default storage path
			String defaultStoragePath = String.format("%s/payapp/%s", enterCd, payActionCd);
			// default file name
			String defaultFileNam = String.format("%s_%s", enterCd, payActionCd);
			
			paramMap.put("signImgPath", String.format("%s/%s.png", defaultStoragePath, defaultFileNam));
			paramMap.put("pdfPath", String.format("%s/%s.pdf", defaultStoragePath, defaultFileNam));
			
			resultCnt = payAppMgrService.savePayAppMgrSignData(paramMap);
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
