package com.hr.api.common.controller;

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComService;
import com.hr.common.database.DatabaseService;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.StringUtil;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * GET DATA LIST TYPE Controller
 *
 * @author RYU SIOONG
 *
 */
public class ApiComController {


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
	public Map<String, Object> getDataList(
			HttpSession session, HttpServletRequest request,
			Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Log.Debug("getDataList ===== ");
		Log.Debug(paramMap.toString());

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

		Map<String, Object> result = new HashMap<>();

		result.put("DATA", list);
		result.put("Message", Message);

		Log.DebugEnd();
		return result;
	}

}