package com.hr.common.com;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.database.DatabaseService;
import com.hr.common.exception.HrException;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;

/**
 * GET DATA LIST TYPE Controller
 *
 * @author RYU SIOONG
 *
 */
public class ComController {


	@Inject
	@Named("ComService")
	private ComService comService;

	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("DatabaseService")
	private DatabaseService databaseService;


	/**
	 * 공통 데이터 리스트 조회
	 * 
		return getDataList(session, request, paramMap);
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getDataList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		//임직원공통일때 사번은 본인으로 제한
		if( session.getAttribute("ssnGrpCd").equals("99") ) {
			String chkSabun = (String)session.getAttribute("ssnSabun");
			String paramSabun =  StringUtil.stringValueOf(paramMap.get("sabun"));
			if(!paramSabun.equals("")) {

				Log.Debug("//임직원공통일때 사번은 본인으로 제한");
				Log.Debug("GetDataList paramMap==> {}", paramMap);

				paramSabun = paramSabun.equals(chkSabun) ? paramSabun : chkSabun;
				paramMap.put("sabun",paramSabun);
			}
		}

		Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
		//Log.Debug("query.get=> {}", query.get("query"));
		paramMap.put("query", query == null ? null:query.get("query"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = comService.getDataList(paramMap);
		}catch(Exception e){
			Message = LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
			Log.Debug(Message);
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 데이터 단건 조회
	 * 
		return getDataMap(session, request, paramMap);
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getDataMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = comService.getDataMap(paramMap);
		}catch(Exception e){
			Message=LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
			Log.Debug(e.getLocalizedMessage());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 공통 데이터 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 *
	 *  ( 중복체크 시 예제 )
		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		String[] dupList= {"TBEN470", "ENTER_CD,OCC_CD,FAM_CD,OCC_SDATE", "ssnEnterCd,occCd,famCd,occSdate", "s,s,s,s"};
		paramMap.put("dupList", dupList);
		
		return saveData(session, request, paramMap);
 	 */
	public ModelAndView saveData(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = null;
		int lengthSSavename = StringUtil.stringValueOf(paramMap.get("s_SAVENAME")).length();

		if(lengthSSavename > 0){
			convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		}else{
			convertMap = ParamUtils.requestInParamsMultiDML(request,StringUtil.join(paramMap.keySet().toArray(), ","),"");
			convertMap.put("cmd",paramMap.get("cmd"));
			convertMap.put("s_SAVENAME",StringUtil.join(paramMap.keySet().toArray(), ","));
		}

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		//중복체크 관련 파라메터
		convertMap.put("dupList",		paramMap.get("dupList"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = comService.saveData(convertMap);
			if(resultCnt > 0){
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			} else {
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); 
			}
		}catch(HrException he){
			resultCnt = -1; message= he.getMessage();
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
	 * 데이터 대량 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 *
	 *  ( 중복체크 시 예제 )
		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		String[] dupList= {"TBEN470", "ENTER_CD,OCC_CD,FAM_CD,OCC_SDATE", "ssnEnterCd,occCd,famCd,occSdate", "s,s,s,s"};
		paramMap.put("dupList", dupList);
		
		return saveData(session, request, paramMap);
	 */
	public ModelAndView saveDataBatch(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = null;
		int lengthSSavename = StringUtil.stringValueOf(paramMap.get("s_SAVENAME")).length();

		if(lengthSSavename > 0){
			convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		}else{
			convertMap = ParamUtils.requestInParamsMultiDML(request,StringUtil.join(paramMap.keySet().toArray(), ","),"");
			convertMap.put("cmd",paramMap.get("cmd"));
			convertMap.put("s_SAVENAME",StringUtil.join(paramMap.keySet().toArray(), ","));
		}
		convertMap.put("ssnLocaleCd",    session.getAttribute("ssnLocaleCd"));
		convertMap.put("ssnEnterCd",     session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",       session.getAttribute("ssnSabun"));
		convertMap.put("ssnSearchType" , session.getAttribute("ssnSearchType"));
		convertMap.put("ssnGrpCd" , 	 session.getAttribute("ssnGrpCd"));
		convertMap.put("ssnAdminYn" , 	 session.getAttribute("ssnAdminYn"));
		

		//중복체크 관련 파라메터
		convertMap.put("dupList",		paramMap.get("dupList"));


		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = comService.saveDataBatch(convertMap);
			if(resultCnt > 0){
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			} else {
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); 
			}
		}catch(HrException he){
			resultCnt = -1; message= he.getMessage();
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
	
	public ModelAndView execPrc(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));


		paramMap.put("sqlCode", "");
		paramMap.put("sqlErrm", "");
		paramMap.put("sqlcode", "");
		paramMap.put("sqlerrm", "");
		paramMap.put("sqlCnt", "");
		Map<?, ?> map  = comService.execPrc(paramMap);


		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlCode : "+map.get("sqlCode"));
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlErrm : "+map.get("sqlErrm"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));

			if (map.get("sqlCode") != null && !map.get("sqlCode").equals("")) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlcode") != null && !map.get("sqlcode").equals("")) {
				resultMap.put("Code", map.get("sqlcode").toString());
			}
			if (map.get("sqlErrm") != null && !map.get("sqlErrm").equals("")) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			}
			if (map.get("sqlerrm") != null && !map.get("sqlerrm").equals("")) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			}

		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}
}