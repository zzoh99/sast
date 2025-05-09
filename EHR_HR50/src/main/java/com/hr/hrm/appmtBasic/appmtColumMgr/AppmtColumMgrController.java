package com.hr.hrm.appmtBasic.appmtColumMgr;
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

import com.hr.hrm.appmtBasic.appmtItemMapMgr.AppmtItemMapMgrService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 발령항목정의 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/AppmtColumMgr.do", method=RequestMethod.POST )
public class AppmtColumMgrController {

	/**
	 * 발령항목정의 서비스
	 */
	@Inject
	@Named("AppmtColumMgrService")
	private AppmtColumMgrService appmtColumMgrService;
	
	@Inject
	@Named("AppmtItemMapMgrService")
	private AppmtItemMapMgrService appmtItemMapMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;


	/**
	 * 발령항목정의 탭 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppmtColumTab", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppmtColumTab() throws Exception {
		return "hrm/appmtBasic/appmtColumMgr/appmtColumTab";
	}

	/**
	 * 발령항목정의 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppmtColumMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppmtColumMgr() throws Exception {
		return "hrm/appmtBasic/appmtColumMgr/appmtColumMgr";
	}

	

	/**
	 * 발령항목정의 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppmtColumMgrList", method = RequestMethod.POST )
	public ModelAndView getAppmtCodeMappingList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("searchUseYn", "Y");
		// 발령항목(select문을 만들기위해 post_item을 조회)조회
		List<?> postItemList  = appmtItemMapMgrService.getAppmtItemMapMgrList(paramMap);
		paramMap.put("postItemRows", postItemList);

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appmtColumMgrService.getAppmtColumMgrList(paramMap);
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
	 * 발령항목정의 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppmtColumMgr", method = RequestMethod.POST )
	public ModelAndView saveAppmtColumMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDMLPost(request,paramMap.get("s_SAVENAME").toString(),paramMap.get("s_SAVENAME2").toString(), "VISIBLE_YN,MANDATORY_YN");
		
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("ORD_DETAIL_CD",mp.get("ordDetailCd"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;
		try{				
			resultCnt = appmtColumMgrService.saveAppmtColumMgr(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }			
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하 였습니다.";
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
