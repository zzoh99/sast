package com.hr.sys.system.dictMgr;
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

import com.hr.common.com.ComService;
import com.hr.common.language.Language;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;

/**
 * 사전관리 Controller
 *
 * @author CBS
 *
 */
@Controller
@RequestMapping(value="/DictMgr.do", method=RequestMethod.POST )
public class DictMgrController {
	/**
	 * 사전관리 서비스
	 */
	@Inject
	@Named("DictMgrService")
	private DictMgrService dictMgrService;

	/* ComService */
	@Inject
	@Named("ComService")
	private ComService comService;

	@Inject
	@Named("Language")
	private Language language;

	/**
	 *  사전관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	
	@RequestMapping(params="cmd=viewDict", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewDict(HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String jspIs = paramMap.get("is") == null ? "" : StringUtil.getCamelize(String.valueOf(paramMap.get("is")));
		mv.setViewName("sys/system/dictMgr/dictMgr"+ jspIs);
		mv.addObject("isPooup", "N");
		Log.DebugEnd();
		return mv;
	}
	@RequestMapping(params="cmd=viewDictLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewDictLayer() throws Exception {
		return "sys/system/dictMgr/dictMgrLayer";
	}

	@RequestMapping(params="cmd=viewApplyDict", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView applyDict(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		String message = "";
		int cnt = 0;

		if(language.refresh() == true) {
			cnt = language.getMessageCnt();
			message = "총"+cnt+"건이 로딩되었습니다.";
		} else {
			message = "메시지 로딩중 오류가 발생하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}

	

	//Sheet 1, 2, 3 
	@RequestMapping(params="cmd=getDictMgrList", method = RequestMethod.POST )
	public ModelAndView getWordOnlyOne(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		String queryId = "getDictMgrList"+ StringUtil.getCamelize((String)paramMap.get("is"));
		
		try{
			paramMap.put("queryId", queryId );
			list = dictMgrService.getDictMgrList(paramMap);
		}
		catch(Exception e){
			Message= language.getMessage("msg.alertSearchFail");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	//Sheet 1, 2, 3	
	@RequestMapping(params="cmd=getDictMgrSave", method = RequestMethod.POST )
	public ModelAndView getDictMgrSave(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		String sheetId = StringUtil.getCamelize((String)paramMap.get("is"));
		
		convertMap.put("sheetId", sheetId);

		String Message = "";
		int resultCnt = -1;
		try{
			resultCnt =dictMgrService.getDictMgrSave(convertMap);
			if(resultCnt > 0){ Message = "저장되었습니다."; }
				else{ Message = "저장된 내용이 없습니다."; }
		}catch(Exception e){
			
			resultCnt = -1; Message="저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", Message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	

}
