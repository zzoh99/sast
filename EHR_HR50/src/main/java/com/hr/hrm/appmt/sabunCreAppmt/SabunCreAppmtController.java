package com.hr.hrm.appmt.sabunCreAppmt;
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
 * 사번생성/가발령 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/SabunCreAppmt.do", method=RequestMethod.POST )
public class SabunCreAppmtController {
	/**
	 * 사번생성/가발령 서비스
	 */
	@Inject
	@Named("SabunCreAppmtService")
	private SabunCreAppmtService sabunCreAppmtService;

	/**
	 * 채용발령내역(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSabunCreAppmtPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSabunCreAppmtPop() throws Exception {
		return "hrm/appmt/sabunCreAppmt/sabunCreAppmtPop";
	}

	/**
	 * 사번생성/가발령 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSabunCreAppmt", method = RequestMethod.POST )
	public ModelAndView saveSabunCreAppmt(
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
			resultCnt =sabunCreAppmtService.saveSabunCreAppmt(convertMap);
			if(resultCnt > 0) { message="저장되었습니다.";} else if(resultCnt == 0) {message="저장된 내용이 없습니다.";}
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
	 * 사번생성/가발령 사번생성
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSabunCreAppmtSabunCre", method = RequestMethod.POST )
	public ModelAndView saveSabunCreAppmtSabunCre(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		String getParamNames ="sNo,sStatus,receiveNo,autoYn,fixGbn,fixVal,fixVal2,autonum";

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =sabunCreAppmtService.saveSabunCreAppmtSabunCre(convertMap);
			if(resultCnt > 0) { message="저장되었습니다.";} else if(resultCnt == 0) {message="저장된 내용이 없습니다.";}
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
	 * 발령처리 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcSabunCreAppmtSave", method = RequestMethod.POST )
	public ModelAndView prcSabunCreAppmtSave(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<?, ?> map  = sabunCreAppmtService.prcSabunCreAppmtSave(paramMap);
		
		if (map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("sqlCode") != null) {
			resultMap.put("Code", map.get("sqlCode").toString());
		}
		if (map.get("sqlErrm") != null) {
			resultMap.put("Message", map.get("sqlErrm").toString());
		} else {
			resultMap.put("Message", "사번이 생성되었습니다.");
		}

		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		// 그리드에 맵핑 되는 데이터 이면 DATA에 담아서 보냄 
		// comment 종료
		Log.DebugEnd();
		return mv;
	}
}
