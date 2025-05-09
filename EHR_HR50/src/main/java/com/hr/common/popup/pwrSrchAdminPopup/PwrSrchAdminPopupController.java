package com.hr.common.popup.pwrSrchAdminPopup;

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.nhncorp.lucy.security.xss.XssPreventer;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * 검색조건 결과 팝업
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/PwrSrchAdminPopup.do", method=RequestMethod.POST )
public class PwrSrchAdminPopupController {
	
	@Inject
	@Named("PwrSrchAdminPopupService")
	private PwrSrchAdminPopupService pwrSrchAdminPopupService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	
	/**
	 * 검색조건 결과 팝업
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwrSrchAdminPopup", method = RequestMethod.POST )
	public ModelAndView pwrSrchAdminPopup(@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Log.Debug("PwrSrchAdminPopup.pwrSrchAdminPopup");
		mv.setViewName("common/popup/pwrSrchAdminPopup");
		return mv;
	}
	
	@RequestMapping(params="cmd=viewPwrSrchAdminLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView pwrSrchAdminLayer(@RequestParam Map<String, Object> param) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/pwrSrchAdminLayer");
		return mv;
	}
	
	/**
	 * 검색조건 결과 팝업 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchAdminPopupElemDetailList", method = RequestMethod.POST )
	public ModelAndView getPwrSrchAdminPopupElemDetailList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List elemDetailList  = new ArrayList();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		try{
			elemDetailList = pwrSrchAdminPopupService.getPwrSrchAdminPopupElemDetailList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", elemDetailList);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 검색조건 결과 팝업 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchAdminPopupElemList", method = RequestMethod.POST )
	public ModelAndView getPwrSrchAdminPopupElemList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List list  = new ArrayList();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		try{
			list = pwrSrchAdminPopupService.getPwrSrchAdminPopupElemList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 검색조건 결과 팝업 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchAdminPopupConditionList", method = RequestMethod.POST )
	public ModelAndView getPwrSrchAdminPopupConditionList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List list  = new ArrayList();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		try{
			list = pwrSrchAdminPopupService.getPwrSrchAdminPopupConditionList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	
	/**
	 * 검색조건 결과 팝업 조회 -- @@ OR && 변수 중 선택해서 조회할 수 있도록처리
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchAdminPopupConditionListVar", method = RequestMethod.POST )
	public ModelAndView getPwrSrchAdminPopupConditionListVar(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List list  = new ArrayList();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		try{
			list = pwrSrchAdminPopupService.getPwrSrchAdminPopupConditionListVar(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 검색조건 결과 팝업 수정
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updatePwrSrchAdminPopupSql", method = RequestMethod.POST )
	public ModelAndView updatePwrSrchAdminPopupSql(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		//paramMap.put("sqlTxt",paramMap.get("sqlTxt").toString().replaceAll("</BR>", "\r\n"));
		String message = "";
		int resultCnt = -1;
		
		String sqlTxt = XssPreventer.unescape(paramMap.get("adminSqlSyntax").toString());
		
		paramMap.put("sqlConv",sqlTxt);
		try{
			resultCnt = pwrSrchAdminPopupService.updatePwrSrchAdminPopupSqlEmpty(paramMap);
			if(resultCnt < 1){ message="데이터 초기화에 실패하였습니다."; }
			else{
				resultCnt = pwrSrchAdminPopupService.updatePwrSrchAdminPopupSql(paramMap);
				if(resultCnt > 0){ message="수정되었습니다."; }
				else{ message="수정된 내용이 없습니다."; }
			}
		}catch(Exception e){
			Log.Debug(e.getLocalizedMessage());
			resultCnt = -1;
			message="수정에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("message", message);
		Log.DebugEnd();
		return mv;
	}
	
	
	/**
	 * 검색조건 결과 팝업 수정
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updatePwrSrchAdminPopupSqlDesc", method = RequestMethod.POST )
	public ModelAndView updatePwrSrchAdminPopupSqlDesc(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		//paramMap.put("sqlTxt",paramMap.get("sqlTxt").toString().replaceAll("</BR>", "\r\n"));
		String message = "";
		int resultCnt = -1;
		String sqlDescTxt = paramMap.get("conditionDesc").toString();
		paramMap.put("sqlDescConv",sqlDescTxt);
		try{
			resultCnt = pwrSrchAdminPopupService.updatePwrSrchAdminPopupSqlDesc(paramMap);
			if(resultCnt > 0){ message="수정되었습니다."; }
			else{ message="수정된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1;
			message="수정에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("message", message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 검색조건 결고 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePwrSrchAdminPopupElem", method = RequestMethod.POST )
	public ModelAndView savePwrSrchAdminPopupElem(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		String enterCd = session.getAttribute("ssnEnterCd").toString();
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();
		int cnt = 0;
		if(insertList.size()>0){
    		for(Map<String,Object> mp : insertList) {
    			Map<String,Object> dupMap = new HashMap<String,Object>();
    			dupMap.put("ENTER_CD"	,enterCd);
    			dupMap.put("SEARCH_SEQ"	,mp.get("searchSeq"));
    			dupMap.put("COLUMN_NM"	,mp.get("columnNm"));
    			dupList.add(dupMap);
    		}
    		try{
		    	cnt = commonCodeService.getDupCnt("THRI213", "ENTER_CD,SEARCH_SEQ,COLUMN_NM", "s,i,s",dupList);
	    		if(cnt > 0 ){
	    			cnt = -1; message="중복된 값이 존재합니다.";
	    		}
    		}catch(Exception e){
    			cnt = -1; message="중복 체크에 실패하였습니다.";
    		}
		}
		if(cnt == 0){
			try{
				cnt = pwrSrchAdminPopupService.savePwrSrchAdminPopupElem(convertMap);
				if (cnt > 0) { message="저장되었습니다."; } 
				else {cnt=-1;  message="저장된 내용이 없습니다."; }
				
			}catch(Exception e){
				cnt=-1;
				message="저장 실패하였습니다.";
			}
		}
		resultMap.put("Code", 		cnt);
		resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
	
	
	/**
	 * 검색조건 결고 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePwrSrchAdminPopupCondition", method = RequestMethod.POST )
	public ModelAndView savePwrSrchAdminPopupCondition(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		String enterCd = session.getAttribute("ssnEnterCd").toString();
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();
		int cnt = 0;
		if(insertList.size()>0){
    		for(Map<String,Object> mp : insertList) {
    			Map<String,Object> dupMap = new HashMap<String,Object>();
    			dupMap.put("ENTER_CD"	,enterCd);
    			dupMap.put("SEARCH_SEQ"	,mp.get("searchSeq"));
    			dupMap.put("COLUMN_NM"	,mp.get("columnNm"));
    			dupList.add(dupMap);
    		}
    		try{
		    	cnt = commonCodeService.getDupCnt("THRI215", "ENTER_CD,SEARCH_SEQ,COLUMN_NM", "s,i,s",dupList);
	    		if(cnt > 0 ){
	    			cnt = -1; message="중복된 값이 존재합니다.";
	    		}
    		}catch(Exception e){
    			cnt = -1; message="중복 체크에 실패하였습니다.";
    		}
		}
		if(cnt == 0){
			try{
				cnt = pwrSrchAdminPopupService.savePwrSrchAdminPopupCondition(convertMap);
				if (cnt > 0) { message="저장되었습니다."; } 
				else {cnt=-1;  message="저장된 내용이 없습니다."; }
				
			}catch(Exception e){
				cnt=-1;
				message="저장 실패하였습니다.";
			}
		}
		resultMap.put("Code", 		cnt);
		resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 검색조건 결과 팝업 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */

	//사용안함 20240717 jyp 주석처리함
//	@RequestMapping(params="cmd=getPwrSrchAdminPopupList", method = RequestMethod.POST )
//	public ModelAndView getPwrSrchAdminPopupList(
//			HttpSession session,  HttpServletRequest request,
//			@RequestParam Map<String, Object> paramMap ) throws Exception {
//		Log.DebugStart();
//		String ssnEnterCd 		= session.getAttribute("ssnEnterCd").toString();
//		String ssnSabun 		= session.getAttribute("ssnSabun").toString();
//		String ssnSearchType	= session.getAttribute("ssnSearchType").toString();
//		String ssnGrpCd			= session.getAttribute("ssnGrpCd").toString();
//		String ssnBaseDate		= session.getAttribute("ssnBaseDate").toString();
//		String srchSeq 			= paramMap.get("srchSeq").toString();
//		String message			= "";
//		Map query = new HashMap();
//		List result = new ArrayList();
//
//		paramMap.put("ssnEnterCd", 		ssnEnterCd);
//		paramMap.put("ssnSabun", 		ssnSabun);
//		paramMap.put("ssnSearchType", 	ssnSearchType);
//		paramMap.put("ssnGrpCd", 		ssnGrpCd);
//		paramMap.put("ssnBaseDate", 	ssnBaseDate);
//		paramMap.put("srchSeq",			srchSeq);
//
//		try{
//			//query = pwrSrchAdminPopupService.getPwrSrchAdminPopupQueryMap(paramMap);
//			paramMap.put("query",query.get("query"));
//			result = pwrSrchAdminPopupService.getPwrSrchAdminPopupResultList(paramMap);
//		}catch(Exception e){
//			message="조회에 실패하였습니다.";
//		}
//
//		Log.Debug("##############################\n"+query);
//		ModelAndView mv = new ModelAndView();
//		mv.setViewName("jsonView");
//		mv.addObject("data", result);
//		mv.addObject("Message", message);
//		Log.DebugEnd();
//		return mv;
//	}
//	public Map getSessionQuery(Map tMap, List sList){
//		for(int i =0; i<sList.size(); i++){
//			Map m = (Map) sList.get(i);
//			tMap.put("@@"+StringUtil.nvl_trim( m.get("columnNm").toString(),"") +"@@",m.get("inputValue"));
//		}
//		return tMap;
//	}
//
//	public String changeQuery(String query, Map tMap){
//		Set<String> gSet = tMap.keySet();
//		Iterator<String> iterator = gSet.iterator();
//		while (iterator.hasNext()) {
//			String key = iterator.next();
//			String value = tMap.get(key).toString();
//			query = query.replaceAll(key, value);
//		}
//		iterator = gSet.iterator();
//		while (iterator.hasNext()) {
//			String key = iterator.next();
//			String value = tMap.get(key).toString();
//			query = query.replaceAll(key, value);
//		}
//		return query;
//	}
//
//	public String cAdd(String str){
//		return "'"+str+"'";
//	}
}