package com.hr.hrd.code.shrOfcWrkMgr;

import com.hr.common.language.Language;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/ShrOfcWrkMgr.do", method=RequestMethod.POST )
public class ShrOfcWrkMgrController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("ShrOfcWrkMgrService")
	private ShrOfcWrkMgrService shrOfcWrkMgrService;

	@RequestMapping(params="cmd=viewShrOfcWrkMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewShrOfcWrkMgr(
		HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/code/shrOfcWrkMgr/shrOfcWrkMgr";
	}

	@RequestMapping(params="cmd=getShrOfcWrkMgrList", method = RequestMethod.POST )
	public ModelAndView getShrOfcWrkMgrList(HttpSession session, HttpServletRequest request,
	@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try {
			list = shrOfcWrkMgrService.getShrOfcWrkMgrList(paramMap);
		} catch (Exception e) {
			Message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	@RequestMapping(params="cmd=saveShrOfcWrkMgrList", method = RequestMethod.POST )
	public ModelAndView saveShrOfcWrkMgrList(
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
			resultCnt = shrOfcWrkMgrService.saveShrOfcWrkMgrList(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
	
	@RequestMapping(params="cmd=prcShrOfcWrkMgr", method = RequestMethod.POST )
	public ModelAndView prcAppCompItemCreateMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		

		Map<?, ?> map  = shrOfcWrkMgrService.prcShrOfcWrkMgr(paramMap);

		if (map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("sqlcode") != null) {
			resultMap.put("Code", map.get("sqlcode").toString());
		}
		if (map.get("sqlerrm") != null) {
			resultMap.put("Message", map.get("sqlerrm").toString());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}




}
