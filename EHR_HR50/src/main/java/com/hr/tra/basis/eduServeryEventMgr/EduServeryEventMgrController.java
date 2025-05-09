package com.hr.tra.basis.eduServeryEventMgr;
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
import com.hr.tra.basis.eduEventMgr.EduEventMgrService;
import com.hr.tra.basis.eduServeryItemMgr.EduServeryItemMgrService;
/**
 * 교육만족도항목관_회차별 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/EduServeryEventMgr.do", method=RequestMethod.POST )
public class EduServeryEventMgrController {
	/**
	 * 교육만족도항목관_회차별 서비스
	 */
	@Inject
	@Named("EduServeryEventMgrService")
	private EduServeryEventMgrService eduServeryEventMgrService;

	/**
	 * 교육회차관리 서비스
	 */
	@Inject
	@Named("EduEventMgrService")
	private EduEventMgrService eduEventMgrService;

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
	 * 교육만족도항목관_회차별 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduServeryEventMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduServeryEventMgr() throws Exception {
		return "tra/basis/eduServeryEventMgr/eduServeryEventMgr";
	}

	/**
	 * 교육만족도항목관_회차별 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduServeryEventMgrList", method = RequestMethod.POST )
	public ModelAndView getEduServeryEventMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = eduServeryEventMgrService.getEduServeryEventMgrList(paramMap);
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
	 * 교육만족도항목관_회차별 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEduServeryEventMgr", method = RequestMethod.POST )
	public ModelAndView saveEduServeryEventMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("EDU_SEQ",mp.get("eduSeq"));
			dupMap.put("EDU_EVENT_SEQ",mp.get("eduEventSeq"));
			dupMap.put("SURVEY_ITEM_CD",mp.get("surveyItemCd"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TTRA150","ENTER_CD,EDU_SEQ,EDU_EVENT_SEQ,SURVEY_ITEM_CD","s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt =eduServeryEventMgrService.saveEduServeryEventMgr(convertMap);
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

	/**
	 * 교육만족도항목관리_회차별 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteEduServeryEventMgr", method = RequestMethod.POST )
	public ModelAndView deleteEduServeryEventMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sStatus,eduSeq,eduEventSeq,surveyItemCd";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = eduServeryEventMgrService.deleteEduServeryEventMgr(convertMap);
			if(resultCnt > 0){ message="삭제 되었습니다."; } else{ message="삭제된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="삭제에 실패하였습니다.";
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
	 * 교육만족도항목관리_회차별 교육회차관리popup View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduEventMgrPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduEventMgrPopup() throws Exception {
		return "tra/basis/eduServeryEventMgr/eduEventMgrPopup";
	}

	/**
	 * 교육만족도항목관리_회차별 교육회차관리popup2 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduEventMgrPopup2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduEventMgrPopup2() throws Exception {
		return "tra/basis/eduServeryEventMgr/eduEventMgrPopup2";
	}

	/**
	 * 교육만족도항목관리_회차별 교육회차관리popup 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduEventMgrPopupList", method = RequestMethod.POST )
	public ModelAndView getEduEventMgrPopupList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = eduEventMgrService.getEduEventMgrList(paramMap);
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
	 * 교육만족도항목관리_회차별 과정명popup 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduServeryItemMgrPopupList", method = RequestMethod.POST )
	public ModelAndView getEduServeryItemMgrPopupList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = eduServeryItemMgrService.getEduServeryItemMgrList(paramMap);
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
	 * 교육만족도항목관리_회차별 프로시저 popup View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduServeryProcPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduServeryProcPopup() throws Exception {
		return "tra/basis/eduServeryEventMgr/eduServeryProcPopup";
	}

	/**
	 * 교육만족도항목관리_회차별 프로시저(popup)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcEduServery", method = RequestMethod.POST )
	public ModelAndView prcEduServery(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));


		Map map  = eduServeryEventMgrService.prcEduServery(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
			
			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
}
