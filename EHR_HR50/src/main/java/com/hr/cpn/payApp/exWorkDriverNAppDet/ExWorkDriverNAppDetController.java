package com.hr.cpn.payApp.exWorkDriverNAppDet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
 * 야근수당(기원) 종합신청 세부내역 Controller
 *
 * @author YSH
 *
 */
@Controller
@RequestMapping(value="/ExWorkDriverNAppDet.do", method=RequestMethod.POST )
public class ExWorkDriverNAppDetController {

	/**
	 * 야근수당(기원) 종합신청 세부내역 서비스
	 */
	@Inject
	@Named("ExWorkDriverNAppDetService")
	private ExWorkDriverNAppDetService exWorkDriverNAppDetService;

	/**
	 * 야근수당(기원) 종합신청 세부내역 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExWorkDriverNAppDetList", method = RequestMethod.POST )
	public ModelAndView getExWorkDriverNAppDetList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = exWorkDriverNAppDetService.getExWorkDriverNAppDetList(paramMap);

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
	 * 야근수당(기원) 종합신청 세부내역 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveExWorkDriverNAppDet", method = RequestMethod.POST )
	public ModelAndView saveExWorkDriverNAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
				
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		
		if ( convertMap == null) {
			convertMap = new HashMap<String, Object>(); 			
		}
				
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("searchApplSeq",paramMap.get("searchApplSeq"));
		convertMap.put("searchApplSabun",paramMap.get("searchApplSabun"));		
		convertMap.put("workYm",paramMap.get("workYm"));
		convertMap.put("totMon",paramMap.get("totMon"));
		convertMap.put("bigo",paramMap.get("bigo"));

		String message = "";
		int resultCnt = -1;
		try{
		
			resultCnt = exWorkDriverNAppDetService.saveExWorkDriverNAppDet(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다"; }
		
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
			e.getStackTrace();
		}		
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code",resultCnt);
		resultMap.put("Message",message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
}
