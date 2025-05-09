package com.hr.common.popup.pwrSrchBizPopup;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.nhncorp.lucy.security.xss.XssPreventer;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;
/**
 * 검색조건 설정 팝업
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/PwrSrchBizPopup.do", method=RequestMethod.POST )
public class PwrSrchBizPopupController {
	
	@Inject
	@Named("PwrSrchBizPopupService")
	private PwrSrchBizPopupService pwrSrchBizPopupService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	
	/**
	 * 검색조건 설정 팝업
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwrSrchBizPopup", method = RequestMethod.POST )
	public ModelAndView pwrSrchBizPopup(@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Log.Debug("PwrSrchBizPopup.pwrSrchBizPopup");
		mv.setViewName("common/popup/pwrSrchBizPopup");
		return mv;
	}
	
	@RequestMapping(params="cmd=viewPwrSrchBizLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPwrSrchBizLayer() throws Exception {
		return "common/popup/pwrSrchBizLayer";
	}
	
	/**
	 * 검색조건 설정 팝업 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchBizPopupViewElemList", method = RequestMethod.POST )
	public ModelAndView getPwrSrchBizPopupViewElemList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List elemDetailList  = new ArrayList();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		try{
			elemDetailList = pwrSrchBizPopupService.getPwrSrchBizPopupViewElemList(paramMap);
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
	 * 검색조건 설정 팝업 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchBizPopupElemList", method = RequestMethod.POST )
	public ModelAndView getPwrSrchBizPopupElemList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List elemDetailList  = new ArrayList();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		try{
			elemDetailList = pwrSrchBizPopupService.getPwrSrchBizPopupElemList(paramMap);
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
	 * 검색조건 설정 팝업 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchBizPopupConditionList", method = RequestMethod.POST )
	public ModelAndView getPwrSrchBizPopupConditionList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List list  = new ArrayList();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		try{
			list = pwrSrchBizPopupService.getPwrSrchBizPopupConditionList(paramMap);
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
	 * 검색조건 설정 팝업 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updatePwrSrchBizPopupSql", method = RequestMethod.POST )
	public ModelAndView updatePwrSrchBizPopupSql(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		String message = "";
		int resultCnt = -1;
		
		try{
			resultCnt = pwrSrchBizPopupService.updatePwrSrchBizPopupSql(paramMap);
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
	 * 검색조건 설정 팝업 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updatePwrSrchBizPopupSqlDesc", method = RequestMethod.POST )
	public ModelAndView updatePwrSrchBizPopupSqlDesc(
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
			resultCnt = pwrSrchBizPopupService.updatePwrSrchBizPopupSqlDesc(paramMap);
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
	@RequestMapping(params="cmd=savePwrSrchBizPopupElem", method = RequestMethod.POST )
	public ModelAndView savePwrSrchBizPopupElem(HttpSession session,
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
				cnt = pwrSrchBizPopupService.savePwrSrchBizPopupElem(convertMap);
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
	@RequestMapping(params="cmd=savePwrSrchBizPopupCondition", method = RequestMethod.POST )
	public ModelAndView savePwrSrchBizPopupCondition(HttpSession session,
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
				cnt = pwrSrchBizPopupService.savePwrSrchBizPopupCondition(convertMap);
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
	 * 검색조건 설정 팝업 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchBizPopupList", method = RequestMethod.POST )
	public ModelAndView getPwrSrchBizPopupList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String ssnEnterCd 		= session.getAttribute("ssnEnterCd").toString();
		String ssnSabun 		= session.getAttribute("ssnSabun").toString(); 
		String ssnSearchType	= session.getAttribute("ssnSearchType").toString();
		String ssnGrpCd			= session.getAttribute("ssnGrpCd").toString();
		String ssnBaseDate		= session.getAttribute("ssnBaseDate").toString();
		String srchSeq 			= paramMap.get("srchSeq").toString();
		String message			= "";
		Map query = new HashMap();
		List result = new ArrayList();
		
		paramMap.put("ssnEnterCd", 		ssnEnterCd);
		paramMap.put("ssnSabun", 		ssnSabun);
		paramMap.put("ssnSearchType", 	ssnSearchType);
		paramMap.put("ssnGrpCd", 		ssnGrpCd);
		paramMap.put("ssnBaseDate", 	ssnBaseDate);
		paramMap.put("srchSeq",			srchSeq);
		
		try{
			//query = pwrSrchBizPopupService.getPwrSrchBizPopupQueryMap(paramMap);
			paramMap.put("query",query.get("query"));
			result = pwrSrchBizPopupService.getPwrSrchBizPopupResultList(paramMap);
		}catch(Exception e){
			message="조회에 실패하였습니다.";
		}
		
		Log.Debug("##############################\n"+query);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", result);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}
	public Map getSessionQuery(Map tMap, List sList){
		for(int i =0; i<sList.size(); i++){
			Map m = (Map) sList.get(i);
			tMap.put("@@"+StringUtil.nvl_trim( m.get("columnNm").toString(),"") +"@@",m.get("inputValue"));
		}
		return tMap;
	}
	
	public String changeQuery(String query, Map tMap){
		Set<String> gSet = tMap.keySet();
		Iterator<String> iterator = gSet.iterator();
		while (iterator.hasNext()) {
			String key = iterator.next();
			String value = tMap.get(key).toString();
			query = query.replaceAll(key, value);
		}
		iterator = gSet.iterator();
		while (iterator.hasNext()) {
			String key = iterator.next();
			String value = tMap.get(key).toString();
			query = query.replaceAll(key, value);
		}
		return query;
	}
	
	public String cAdd(String str){
		return "'"+str+"'";
	}
}