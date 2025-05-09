package com.hr.tra.basis.eduServeryItemMgr;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 교육만족도항목관리 Controller
 *
 * @author
 *
 */

@Controller
@RequestMapping(value="/EduServeryItemMgr.do", method=RequestMethod.POST )
public class EduServeryItemMgrController {

	/**
	 * 교육만족도항목관리 서비스
	 */
	@Inject
	@Named("EduServeryItemMgrService")
	private EduServeryItemMgrService eduServeryItemMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 *  교육만족도항목관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduServeryItemMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduServeryItemMgr() throws Exception {
		return "tra/basis/eduServeryItemMgr/eduServeryItemMgr";
	}

	/**
	 * 교육만족도항목관리 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduServeryItemMgrList", method = RequestMethod.POST )
	public ModelAndView getEduServeryItemMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = eduServeryItemMgrService.getEduServeryItemMgrList(paramMap);
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
	 * 교육만족도항목관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEduServeryItemMgr", method = RequestMethod.POST )
	public ModelAndView saveEduServeryItemMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();
		
		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("SURVEY_ITEM_CD",mp.get("surveyItemCd"));
			dupList.add(dupMap);
		}
		String message = "";
		int resultCnt = -1;
		try{
			int dupCnt = 0;
			
			if(insertList.size() > 0) {
				// 중복검사
				dupCnt = commonCodeService.getDupCnt("TTRA005", "ENTER_CD,SURVEY_ITEM_CD", "s,s",dupList);
			}
			if(dupCnt > 0) {
				resultCnt = -1; message="중복되어 저장할 수 없습니다.";
			} else {
				resultCnt = eduServeryItemMgrService.saveEduServeryItemMgr(convertMap);
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			}
			
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
