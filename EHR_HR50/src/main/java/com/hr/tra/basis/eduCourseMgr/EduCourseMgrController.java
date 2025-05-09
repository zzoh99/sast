package com.hr.tra.basis.eduCourseMgr;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.language.LanguageUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;
/**
 * 교육과정관리 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping({"/EduCourseMgr.do", "/EduApp.do"})
public class EduCourseMgrController extends ComController {
	/**
	 * 교육과정관리 서비스
	 */
	@Inject
	@Named("EduCourseMgrService")
	private EduCourseMgrService eduCourseMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 *  교육과정관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduCourseMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduCourseMgr() throws Exception {
		return "tra/basis/eduCourseMgr/eduCourseMgr";
	}

	/**
	 *  교육과정관리 Popup View   -- 교육과정만 Old  (벽산에서 사용 안함)
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduCourseMgrPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduCourseMgrPopup() throws Exception {
		return "tra/basis/eduCourseMgr/eduCourseMgrPopup";
	}

	/**
	 *  교육과정관리 Popup View  -- 교육과정 + 교육회차  2020.07.16 New
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduMgrPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduMgrPopup() throws Exception {
		return "tra/basis/eduCourseMgr/eduMgrPopup";
	}

	@RequestMapping(params="cmd=viewEduMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduMgrLayer() throws Exception {
		return "tra/basis/eduCourseMgr/eduMgrLayer";
	}

	/**
	 *  교육과정관리 관련역량 Popup View  -- 벽산 New
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduMgrComptyPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduMgrComptyPop() throws Exception {
		return "tra/basis/eduCourseMgr/eduMgrComptyPop";
	}

	/**
	 *  교육과정관리 관련역량 Layer View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduMgrComptyLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduMgrComptyLayer() throws Exception {
		return "tra/basis/eduCourseMgr/eduMgrComptyLayer";
	}

	/**
	 * 교육과정관리 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduCourseMgrList", method = RequestMethod.POST )
	public ModelAndView getEduCourseMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = eduCourseMgrService.getEduCourseMgrList(paramMap);
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
	 * 교육담당자 개인정보 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduCourseMgrUserInfo", method = RequestMethod.POST )
	public ModelAndView getEduCourseMgrUserInfo(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = eduCourseMgrService.getEduCourseMgrUserInfo(paramMap);
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
	 * 교육과정관리-교육분류 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduMBranchMgrList", method = RequestMethod.POST )
	public ModelAndView getEduMBranchMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = eduCourseMgrService.getEduMBranchMgrList(paramMap);
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
	 * 교육과정관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEduCourseMgr", method = RequestMethod.POST )
	public ModelAndView saveEduCourseMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("EDU_SEQ",mp.get("eduSeq"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;
			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TTRA101","ENTER_CD,EDU_SEQ","s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = eduCourseMgrService.saveEduCourseMgr(convertMap);
				if(resultCnt > 0){
					message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
				} else{
					message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
				}
			}
		}catch(HrException he){
			resultCnt = -1;
			message= he.getMessage();
			he.printStackTrace();
		}catch(Exception e){
			resultCnt = -1;
			message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
			Log.Debug(e.getLocalizedMessage());
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
	 * 교육과정관리 저장(다건)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEduCourseMgrSheet", method = RequestMethod.POST )
	public ModelAndView saveEduCourseMgrSheet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("EDU_SEQ",mp.get("eduSeq"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;
			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TTRA101","ENTER_CD,EDU_SEQ","s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = eduCourseMgrService.saveEduCourseMgrSheet(convertMap);
				if(resultCnt > 0){
					message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
				} else{
					message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
				}
			}
		}catch(HrException he){
			resultCnt = -1;
			message= he.getMessage();
			he.printStackTrace();
		}catch(Exception e){
			resultCnt = -1;
			message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
			Log.Debug(e.getLocalizedMessage());
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
	 * 교육과정 세부내역 저장 (과정/회차 저장)
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEduCourseMgrDet", method = RequestMethod.POST )
	public ModelAndView saveEduCourseMgrDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		
		String message = "";
		int resultCnt = -1;
		try{
			//------------------------------------------------------------------------------------
			//  관련역량 파라메터
			//------------------------------------------------------------------------------------
			Map<?, ?> reqMap 		= request.getParameterMap();
			List<Serializable> cmtyRows = new ArrayList<Serializable>();
			if(reqMap.get("competencyCd") != null){
				String[] cols = (String[]) reqMap.get( "competencyCd") ;
				for ( int i = 0; i < cols.length; i++ )  {
					HashMap<String, String> map = new HashMap<String, String>();
					map.put( "competencyCd" , StringUtil.replaceSingleQuot( cols[i] ));	
					cmtyRows.add(map);
				}
			}
			Log.Debug("cmtyRows  : "+ cmtyRows);
			//------------------------------------------------------------------------------------			
			
			if( paramMap.get("sStatus") == null ){
				paramMap.put("cmtyRows", cmtyRows); //관련역량
				resultCnt = eduCourseMgrService.saveEduCourseMgrDet(paramMap);
			}else{
				Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),""); //강사내역
				convertMap.put("cmtyRows", cmtyRows); //관련역량
				resultCnt = eduCourseMgrService.saveEduCourseMgrDet(convertMap);
				if(resultCnt == -99) {
					message="동일한 교육기간["+convertMap.get("eduSYmd")+"~"+convertMap.get("eduSYmd")+"]이 존재하여 저장 할 수 없습니다.";
				}
			}

			if(resultCnt > 0){
				message="저장 되었습니다.";
			} else if (resultCnt == -99) {
				resultCnt = -1;
			} else{
				message="저장된 내용이 없습니다.";
			}
		}catch(HrException he){
			resultCnt = -1; message= he.getMessage();
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
			Log.Debug(e.getLocalizedMessage());
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
	 * 교육과정관리 관련역량 Popup 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduMgrComptyList", method = RequestMethod.POST )
	public ModelAndView getEduMgrComptyList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = eduCourseMgrService.getEduMgrComptyList(paramMap);
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
	 * 교육과정관리 관련역량-역량분류표 Popup 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduMgrComptyStdList", method = RequestMethod.POST )
	public ModelAndView getEduMgrComptyStdList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = eduCourseMgrService.getEduMgrComptyStdList(paramMap);
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
	 * 교육과정관리 관련역량 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEduMgrCompty", method = RequestMethod.POST )
	public ModelAndView saveEduMgrCompty(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = eduCourseMgrService.saveEduMgrCompty(convertMap);
			if(resultCnt > 0){
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			} else{
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
			}
		}catch(HrException he){
			resultCnt = -1;
			message= he.getMessage();
			he.printStackTrace();
		}catch(Exception e){
			resultCnt = -1;
			message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
			Log.Debug(e.getLocalizedMessage());
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
