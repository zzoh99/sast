package com.hr.hrm.appmt.appmtHistoryMgr;
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
 * 발령내역수정 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/AppmtHistoryMgr.do", method=RequestMethod.POST )
public class AppmtHistoryMgrController {

	/**
	 * 발령내역수정 서비스
	 */
	@Inject
	@Named("AppmtHistoryMgrService")
	private AppmtHistoryMgrService appmtHistoryMgrService;

	/**
	 * 발령내역수정 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppmtHistoryMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppmtHistoryMgr() throws Exception {
		return "hrm/appmt/appmtHistoryMgr/appmtHistoryMgr";
	}

	/**
	 * 발령내역수정 Layer View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppmtHistoryMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppmtHistoryMgrLayer() throws Exception {
		return "hrm/appmt/appmtHistoryMgr/appmtHistoryMgrLayer";
	}

	/**
	 * 발령내역수정(개인발령내역) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppmtHistoryMgrExecList", method = RequestMethod.POST )
	public ModelAndView getAppmtHistoryMgrExecList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appmtHistoryMgrService.getAppmtHistoryMgrExecList(paramMap);
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
	 * 발령내역수정(개인조직사항) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppmtHistoryMgrOrgList", method = RequestMethod.POST )
	public ModelAndView getAppmtHistoryMgrOrgList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appmtHistoryMgrService.getAppmtHistoryMgrOrgList(paramMap);
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
	 * 발령내역수정(개인발령내역) 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppmtHistoryMgrExec", method = RequestMethod.POST )
	public ModelAndView saveAppmtHistoryMgrExec(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("modifyCmt", String.valueOf(paramMap.get("modifyCmt")));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = appmtHistoryMgrService.saveAppmtHistoryMgrExec(convertMap);
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

	/**
	 * 발령처리 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppmtHistoryEdateCreate", method = RequestMethod.POST )
	public ModelAndView prcAppmtHistoryEdateCreate(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<?, ?> map  = appmtHistoryMgrService.prcAppmtHistoryEdateCreate(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		if (map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));

			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			} else {
				resultMap.put("Message", "저장되었습니다.");
			}
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
	
	/**
	 * 발령처리 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppmtHistoryCreate", method = RequestMethod.POST )
	public ModelAndView prcAppmtHistoryCreate(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		
		Map<?, ?> map  = appmtHistoryMgrService.prcAppmtHistoryCreate(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		if (map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));

			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			} else {
				resultMap.put("Message", "저장되었습니다.");
			}
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
