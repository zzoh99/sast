package com.hr.eis.statsSrch.statsMng;

import com.hr.common.com.ComController;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.StringUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 통계그래프 > 통계 관리 컨트롤러
 * @author gjyoo
 *
 */
@Controller
@RequestMapping({"/StatsMng.do", "/StatsSrch.do"})
public class StatsMngController extends ComController {

	@Inject
	@Named("StatsMngService")
	private StatsMngService statsMngService;
	
	/**
	 * 통계 관리 View
	 * 
	 * @return Stringm
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewStatsMng", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStatsMng() throws Exception {
		return "eis/statsSrch/statsMng/statsMng";
	}
	
	/**
	 * 통계 관리 > 관리 팝업 View
	 * 
	 * @return Stringm
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewStatsMngPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStatsMngMngPop() throws Exception {
		return "eis/statsSrch/statsMng/statsMngPop";
	}
	
	@RequestMapping(params="cmd=viewStatsMngLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStatsMngLayer() throws Exception {
		return "eis/statsSrch/statsMng/statsMngLayer";
	}
	
	
	/**
	 * 통계 관리 > 차트 옵션 편집 팝업 View
	 * 
	 * @return Stringm
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewStatsMngChartOptEditPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStatsMngChartOptEditPop() throws Exception {
		return "eis/statsSrch/statsMng/statsMngChartOptEditPop";
	}
	
	@RequestMapping(params="cmd=viewStatsMngChartOptEditLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStatsMngChartOptEditLayer() {
		return "eis/statsSrch/statsMng/statsMngChartOptEditLayer";
	}
	
	/**
	 * 통계 관리 > 차트 옵션 편집 팝업 View
	 * 
	 * @return Stringm
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewStatsMngSQLSyntaxEditPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStatsMngSQLEditPop() throws Exception {
		return "eis/statsSrch/statsMng/statsMngSQLSyntaxEditPop";
	}
	
	@RequestMapping(params="cmd=viewStatsMngSQLSymtaxEditLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStatsMngSQLEditLayer() throws Exception {
		return "eis/statsSrch/statsMng/statsMngSQLSyntaxEditLayer";
	}
	
	/**
	 * 통계 관리 > 미리보기 팝업 View
	 * 
	 * @return Stringm
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewStatsMngPreviewPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStatsMngPreviewPop() throws Exception {
		return "eis/statsSrch/statsMng/statsMngPreviewPop";
	}
	
	@RequestMapping(params="cmd=viewStatsMngPreviewLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStatsMngPreviewLayer() throws Exception {
		return "eis/statsSrch/statsMng/statsMngPreviewLayer";
	}

	/**
	 * 통계 관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getStatsMngList", method = RequestMethod.POST )
	public ModelAndView getStatsMngList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 통계 관리 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getStatsMngMap", method = RequestMethod.POST )
	public ModelAndView getStatsMngMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 통계 관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveStatsMng", method = RequestMethod.POST )
	public ModelAndView saveStatsMng(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 통계 관리 차트 옵션 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getStatsMngChartOptMap", method = RequestMethod.POST )
	public ModelAndView getStatsMngChartOptMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 통계 관리 > 차트 옵션 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveStatsMngChartOpt", method = RequestMethod.POST )
	public ModelAndView saveStatsMngChartOpt(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = statsMngService.saveStatsMngChartOpt(paramMap);
			if(resultCnt > 0){ message="저장되었습니다."; }
			else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1;
			message="저장에 실패하였습니다.";
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
	 * 통계 관리 데이터 조회 SQL 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getStatsMngSQLSyntaxMap", method = RequestMethod.POST )
	public ModelAndView getStatsMngSQLSyntaxMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 통계 관리 > 데이터 조회 SQL 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveStatsMngSQLSyntax", method = RequestMethod.POST )
	public ModelAndView saveStatsMngSQLSyntax(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = statsMngService.saveStatsMngSQLSyntax(paramMap);
			if(resultCnt > 0){ message="저장되었습니다."; }
			else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1;
			message="저장에 실패하였습니다.";
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
	 * 통계 관리 > 설정 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveStatsMngSetting", method = RequestMethod.POST )
	public ModelAndView saveStatsMngSetting(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = statsMngService.saveStatsMngSetting(paramMap);
			if(resultCnt > 0){ message="저장되었습니다."; }
			else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1;
			message="저장에 실패하였습니다.";
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
	 * 통계 관리 > 차트 데이터 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getStatsMngChartDataMap", method = RequestMethod.POST )
	public ModelAndView getStatsMngChartDataMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> map = null;
		List<?> dataList = null;
		String Message = "";

		try{
			map = statsMngService.getStatsMngMap(paramMap);
			if( map != null && map.containsKey("sqlSyntax") ) {
				String executeSQL = (String) map.get("sqlSyntax");
				if( !StringUtil.isBlank(executeSQL) ) {
					paramMap.put("sqlSyntax", executeSQL);
					dataList = statsMngService.getStatsMngChartDataList(request, paramMap);
				}
				// sqlSyntax 값 삭제
				map.remove("sqlSyntax");
			}
			
		}catch(Exception e){
			Message=LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
			Log.Debug(e.getLocalizedMessage());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("LIST", dataList);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 통계 관리 > SQL실행 데이터 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getStatsMngChartDataList", method = RequestMethod.POST )
	public ModelAndView getStatsMngChartDataList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> list = null;
		String Message = "";

		try{
			list = statsMngService.getStatsMngChartDataList(request, paramMap);
		}catch(Exception e){
			Message=LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
			Log.Debug(e.getLocalizedMessage());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}
}
