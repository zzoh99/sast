package com.hr.eis.statsSrch.statsPresetMng;

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

import com.hr.common.com.ComController;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;
import com.hr.eis.statsSrch.statsMng.StatsMngService;

/**
 * 통계그래프 > 통계구성 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping({"/StatsPresetMng.do", "/StatsSrch.do"})
public class StatsPresetMngController extends ComController {

	@Inject
	@Named("StatsPresetMngService")
	private StatsPresetMngService statsPresetMngService;
	
	/** 통계 그래프 > 통계 관리 Service */
	@Inject
	@Named("StatsMngService")
	private StatsMngService statsMngService;

	/**
	 * 통계구성 관리 > 레이아웃 편집 팝업 View
	 * 
	 * @return Stringm
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewStatsPresetMngLayoutEditPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStatsPresetMngChartOptEditPop() throws Exception {
		return "eis/statsSrch/statsPresetMng/statsPresetMngLayoutEditPop";
	}
	
	@RequestMapping(params="cmd=viewStatsPresetMngLayoutEditLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStatsPresetMngLayoutEditLayer() throws Exception {
		return "eis/statsSrch/statsPresetMng/statsPresetMngLayoutEditLayer";
	}
	
	/**
	 * 통계구성 관리 > 미리보기 팝업 View
	 * 
	 * @return Stringm
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewStatsPresetMngPreviewPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStatsPresetMngPreviewPop() throws Exception {
		return "eis/statsSrch/statsPresetMng/statsPresetMngPreviewPop";
	}
	
	@RequestMapping(params="cmd=viewStatsPresetMngPreviewLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStatsPresetMngPreviewLayer() throws Exception {
		return "eis/statsSrch/statsPresetMng/statsPresetMngPreviewLayer";
	}

	/**
	 * 통계구성 관리 > 개인 통계구성 편집 팝업 View
	 * 
	 * @return Stringm
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewStatsPresetMngEmpPresetEditPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStatsPresetMngEmpPresetEditPop() throws Exception {
		return "eis/statsSrch/statsPresetMng/statsPresetMngEmpPresetEditPop";
	}
	
	@RequestMapping(params="cmd=viewStatsPresetMngEmpPresetEditLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStatsPresetMngEmpPresetEditLayer() throws Exception {
		return "eis/statsSrch/statsPresetMng/statsPresetMngEmpPresetEditLayer";
	}

	/**
	 * 통계구성 관리 권한그룹별 통계구성  다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getStatsPresetMngGrpList", method = RequestMethod.POST )
	public ModelAndView getStatsPresetMngGrpList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 통계구성 관리 개인 통계구성  다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getStatsPresetMngEmpList", method = RequestMethod.POST )
	public ModelAndView getStatsPresetMngEmpList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 통계구성 관리 사용 통계 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getStatsPresetMngUseItemList", method = RequestMethod.POST )
	public ModelAndView getStatsPresetMngUseItemList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 통계구성 관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveStatsPresetMng", method = RequestMethod.POST )
	public ModelAndView saveStatsPresetMng(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt  = -1;
		try{
			resultCnt = statsPresetMngService.saveStatsPresetMng(convertMap);
			if(resultCnt > 0){
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			} else {
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); 
			}
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
	 * 통계구성 관리 사용 통계 목록 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveStatsPresetMngUseItem", method = RequestMethod.POST )
	public ModelAndView saveStatsPresetMngUseItem(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt  = -1;
		try{
			resultCnt = statsPresetMngService.saveStatsPresetMngUseItem(convertMap);
			if(resultCnt > 0){
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			} else {
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); 
			}
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
	 * 통계 구성 사용 통계 차트 상세 목록 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=getStatsPresetMngUseItemDtlData", method = RequestMethod.POST )
	public ModelAndView getStatsPresetMngUseItemDtlData(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> map = null;
		List<Map<String, Object>> list = null;
		List<?> tmpList = null;
		
		String statsCd = null, useYn = null, sqlSyntax = null;
		String Message = "";

		try{
			
			list = (List<Map<String, Object>>) statsPresetMngService.getStatsPresetMngUseItemDtlDataList(paramMap);
			if( list != null && list.size() > 0 ) {
				map = new HashMap<String, Object>();
				
				// sql 실행  통계건 카운트
				int chkExeSQLCnt = 4, exeSQLCnt = 0;
				
				// Loop List
				for (Map<String, Object> item : list) {
					// SQL이 설정된 경우 데이터 조회
					if( "Y".equals((String) item.get("useYn")) && !StringUtil.isBlank((String) item.get("sqlSyntax")) ) {
						exeSQLCnt++;
					}
				}
				
				// Loop List
				for (Map<String, Object> item : list) {
					statsCd = (String) item.get("statsCd");
					useYn = (String) item.get("useYn");
					sqlSyntax = (String) item.get("sqlSyntax");
					
					// 데이터 조회 쿼리 실행건이 4건 이하인 경우 SQL 데이터 조회
					if( exeSQLCnt <= chkExeSQLCnt && "Y".equals(useYn) && !StringUtil.isBlank(sqlSyntax) ) {
						tmpList = statsMngService.getStatsMngChartDataList(request, item);
						map.put(statsCd, tmpList);
						item.remove("executeSQL");
					}
					
					// SQL 내용 삭제
					item.remove("sqlSyntax");
				}
				
				// 데이터 조회 쿼리 실행건이 4건 이하인 경우 SQL 데이터 조회
				map.put("ajaxCallFlag", ( exeSQLCnt <= chkExeSQLCnt ) ? "N" : "Y");
			}
			
		}catch(Exception e){
			Message=LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
			Log.Debug(e.getLocalizedMessage());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("LIST", list);
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 사용자의 권한그룹이 조회가능한 통계  다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getStatsPresetMngAllowStatsList", method = RequestMethod.POST )
	public ModelAndView getStatsPresetMngAllowStatsList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

}
