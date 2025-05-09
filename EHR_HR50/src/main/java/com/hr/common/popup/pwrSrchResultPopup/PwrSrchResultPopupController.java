package com.hr.common.popup.pwrSrchResultPopup;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.hr.common.ibsheet.DirectDown2Excel;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.wrapper.ReadableRequestWrapper;
import com.ibleaders.ibsheet.IBSheetDown;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.util.QueryUtil;
import com.hr.common.util.StringUtil;

import static com.ibleaders.ibsheet.util.CommonUtil.getRequestMap;

/**
 * 검색조건 결과 팝업
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/PwrSrchResultPopup.do", method=RequestMethod.POST )
public class PwrSrchResultPopupController {

	@Inject
	@Named("PwrSrchResultPopupService")
	private PwrSrchResultPopupService pwrSrchResultPopupService;

	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;

	/**
	 * 검색조건 결과 팝업
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwrSrchResultPopup", method = RequestMethod.POST )
	public ModelAndView pwrSrchResultPopup(@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Log.DebugStart();
		mv.setViewName("common/popup/pwrSrchReusultPopup");
		mv.addObject("adminFlag", paramMap.get("adminFlag"));
		mv.addObject("srchSeq", paramMap.get("srchSeq"));
		return mv;
	}
	@RequestMapping(params="cmd=viewPwrSrchResultLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView pwrSrchResultLayer(@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Log.DebugStart();
		mv.setViewName("common/popup/pwrSrchResultLayer");
		mv.addObject("adminFlag", paramMap.get("adminFlag"));
		mv.addObject("srchSeq", paramMap.get("srchSeq"));
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
	@RequestMapping(params="cmd=getPwrSrchResultPopupIBSheetColsList", method = RequestMethod.POST )
	public ModelAndView getPwrSrchResultPopupIBSheetColsList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		try{
			Log.Debug("paramMap===>"+ paramMap);
			list = pwrSrchResultPopupService.getPwrSrchResultPopupIBSheetColsList(paramMap);
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
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=getPwrSrchResultPopupList", method = RequestMethod.POST )
	public ModelAndView getPwrSrchResultPopupList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		String ssnEnterCd 		= session.getAttribute("ssnEnterCd").toString();
		String ssnSabun 		= session.getAttribute("ssnSabun").toString(); 
		String ssnSearchType	= session.getAttribute("ssnSearchType").toString();
		String ssnGrpCd			= session.getAttribute("ssnGrpCd").toString();
		String ssnBaseDate		= session.getAttribute("ssnBaseDate").toString();
		String srchSeq 			= paramMap.get("srchSeq").toString();
		String iborderby 		= (String)paramMap.get("iborderby");
		String dfIdvSabun 		= (String)paramMap.get("dfIdvSabun");
		String message			= "";
		String queryStr 		= null;
		Map<String, Object> query = new HashMap<>();
		List<?> result = new ArrayList<>();
		String orderbyStr = "";
		
		paramMap.put("ssnEnterCd", 		ssnEnterCd);
		paramMap.put("ssnSabun", 		ssnSabun);
		paramMap.put("ssnSearchType", 	ssnSearchType);
		paramMap.put("ssnGrpCd", 		ssnGrpCd);
		paramMap.put("ssnBaseDate", 	ssnBaseDate);
		paramMap.put("srchSeq",			srchSeq);
		
		
		if(iborderby==null||"".equals(iborderby)){
			
		}else{
			
			String[] colArr = null;
			String[] sortArr = null;
			Log.Debug("orderby■■■■■>"+ iborderby);
			String[] ColandSort = iborderby.split("\\^");
			if(ColandSort[0].indexOf("|")>-1){
				colArr = ColandSort[0].split("\\|");
				sortArr = ColandSort[1].split("\\|");
				for(int i=0;i<colArr.length;i++){
					orderbyStr += ","+colArr[i]+ " " +sortArr[i];
					Log.Debug("■■■■■■■■■■■■■■■■■■■■>"+colArr[i]);
				}
			}else{
				Log.Debug(ColandSort[0]);
				Log.Debug(ColandSort[1]);
				orderbyStr = " "+ColandSort[0]+ " " +ColandSort[1];			
			}

			
			orderbyStr = orderbyStr.substring(1);
			
		}
		
		paramMap.put("orderbyStr",	orderbyStr);
		Log.Debug("orderbyStr■■■■■>"+ orderbyStr);
		
		Map<?, ?> map  = new HashMap<>();
		try{
			query = (Map<String, Object>) pwrSrchResultPopupService.getPwrSrchResultPopupQueryMap(paramMap);
			//paramMap.put("query",query.get("query"));
			if(query != null) {
				queryStr = (String) query.get("query");
			}
			if( !StringUtil.isBlank(queryStr) ) {
				if( queryStr.contains(":dfIdvSabun") && !StringUtil.isBlank(dfIdvSabun) ) {
					queryStr = queryStr.replace(":dfIdvSabun", dfIdvSabun);
				}
			}
			paramMap.put("selectViewQuery", queryStr);
			map = pwrSrchResultPopupService.getPwrSrchResultPopupResulCntMap(paramMap);
			result = pwrSrchResultPopupService.getPwrSrchResultPopupResultList(paramMap);
		} catch(Exception e){
			message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("TOTAL", map.get("cnt"));
		mv.addObject("Botal","");
		mv.addObject("Message", message);
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 검색조건 결과 팝업 다운로드 
	 * SheetHeader 정보가 multipart/form-data 로 전달되므로 MultipartHttpServletRequest 로 받아야 함.
	 *
	 * @param session
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=getPwrSrchResultPopupDown", method = RequestMethod.POST )
	public void getPwrSrchResultPopupDown(
			HttpSession session, MultipartHttpServletRequest request, HttpServletResponse response
			, @RequestParam Map<String, Object> paramMap
			) throws Exception {
		Log.DebugStart();

		String ssnEnterCd 		= session.getAttribute("ssnEnterCd").toString();
		String ssnSabun 		= session.getAttribute("ssnSabun").toString(); 
		String ssnSearchType	= session.getAttribute("ssnSearchType").toString();
		String ssnGrpCd			= session.getAttribute("ssnGrpCd").toString();
		String ssnBaseDate		= session.getAttribute("ssnBaseDate").toString();
		String srchSeq 			= paramMap.get("srchSeq").toString();
		String message			= "";

		Map<?, ?> query = new HashMap<>();
		List<Map<String, Object>> result = new ArrayList<>();

		paramMap.put("ssnEnterCd", 		ssnEnterCd);
		paramMap.put("ssnSabun", 		ssnSabun);
		paramMap.put("ssnSearchType", 	ssnSearchType);
		paramMap.put("ssnGrpCd", 		ssnGrpCd);
		paramMap.put("ssnBaseDate", 	ssnBaseDate);
		paramMap.put("srchSeq",			srchSeq);
		
		try{
			query = pwrSrchResultPopupService.getPwrSrchResultPopupQueryMap(paramMap);
			paramMap.put("query", query.get("query"));
			result = (List<Map<String, Object>>) pwrSrchResultPopupService.getPwrSrchResultPopupResultDown(paramMap);
		}catch(Exception e){
			message="조회에 실패하였습니다.";
		}

		request.setAttribute("SHEETDATA", result);

		DirectDown2Excel direcetDown2Excel = new DirectDown2Excel();
		direcetDown2Excel.downExcel(request, response);

		Log.DebugEnd();
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
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=getPwrSrchResultPopupList2", method = RequestMethod.POST )
	public ModelAndView getPwrSrchResultPopupList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String ssnEnterCd 		= session.getAttribute("ssnEnterCd").toString();
		String ssnSabun 		= session.getAttribute("ssnSabun").toString(); 
		String ssnSearchType	= session.getAttribute("ssnSearchType").toString();
		String ssnGrpCd			= session.getAttribute("ssnGrpCd").toString();
		String ssnBaseDate		= session.getAttribute("ssnBaseDate").toString();
		String srchSeq 			= paramMap.get("srchSeq").toString();
		String srchType			= "";
		String Message 			= "";
		String chgViewNm 		= "";
		String chgStmt 			= "";
		String queryStr 		= "";
		String query			= "";
		String adminQuery		= "";
		//List<?> colList  = new ArrayList<>();
		Map<?, ?> elemQueryMap = new HashMap<>();
		List<?>   condElemQueryMap = new ArrayList<>();
		Map<String, Object> chgMap = new HashMap<>();
		
		paramMap.put("ssnEnterCd", 		ssnEnterCd);
		paramMap.put("ssnSabun", 		ssnSabun);
		paramMap.put("ssnSearchType", 	ssnSearchType);
		paramMap.put("ssnGrpCd", 		ssnGrpCd);
		paramMap.put("ssnBaseDate", 	ssnBaseDate);
		paramMap.put("srchSeq",			srchSeq);
		
		
		if(ssnSearchType.equals("O")){
			queryStr = pwrSrchResultPopupService.getQueryInfo("getPwrSrchResultPopupAuthStmtList");
		}else{
			queryStr = pwrSrchResultPopupService.getQueryInfo("getPwrSrchResultPopupTrackStmtList");
		}
		
		chgStmt = QueryUtil.queryForceHandle(queryStr,paramMap);
		try{
			//colList 		= pwrSrchResultPopupService.getPwrSrchResultPopupIBSheetColsList(paramMap);
			elemQueryMap	= (Map<String, Object>) pwrSrchResultPopupService.getPwrSrchResultPopupElemDetailList(paramMap);
			condElemQueryMap= (List<Map<String, Object>>) pwrSrchResultPopupService.getPwrSrchResultPopupConditionList(paramMap);
			query   		= (String) elemQueryMap.get("sqlSyntax"); 	
			adminQuery		= (String) elemQueryMap.get("adminSqlSyntax"); 	
			srchType		= (String) elemQueryMap.get("searchType"); 
			chgViewNm		= (String) elemQueryMap.get("viewNm"); 
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		if(query != null && srchType.equals("2") ){
			query = query.replaceAll("__EXCHANGE__VIEW__NM__", chgViewNm);
			query = query.replaceAll("__EXCHANGE__AHTHTABLE__", chgStmt);
			query = query.replaceAll("&&", "@@");
			chgMap.put("회사", 			cAdd( ssnEnterCd) );
			chgMap.put("담당자", 		cAdd( ssnSabun) );
			chgMap.put("적용일자", 		cAdd( ssnBaseDate) );
			chgMap.put("조회일자", 		"SYSDATE");
			chgMap.put("@@회사@@", 		cAdd( ssnEnterCd) );
			chgMap.put("@@담당자@@", 	cAdd( ssnSabun) );
			chgMap.put("@@적용일자@@", 	cAdd( ssnBaseDate) );
			chgMap.put("@@조회일자@@", 	"SYSDATE");
			query = changeQuery(query,chgMap).replaceAll("＇","'");
		}else if(query != null && srchType.equals("3") ){
			adminQuery = adminQuery.replaceAll("__EXCHANGE__AHTHTABLE__", chgStmt);
			adminQuery = adminQuery.replaceAll("&&", "@@");
			chgMap.put("dfCompany", 	cAdd( ssnEnterCd) );
			chgMap.put("dfSabun", 		cAdd( ssnSabun) );
			chgMap.put("dfBaseDate",	cAdd( ssnBaseDate) );
			chgMap.put("dfToday", 		"SYSDATE");
			chgMap.put("@@dfCompany@@", cAdd( ssnEnterCd) );
			chgMap.put("@@dfSabun@@", 	cAdd( ssnSabun) );
			chgMap.put("@@dfBaseDate@@",cAdd( ssnBaseDate) );
			chgMap.put("@@dfToday@@", 	"SYSDATE");
			chgMap = getSessionQuery(chgMap, condElemQueryMap);
			query = changeQuery(adminQuery, chgMap).replaceAll("＇","'");
		}
		List<?> resultQuery = new ArrayList<>();
		paramMap.put("resultQuery",query);
		Log.Debug(paramMap.toString());
		try{
			resultQuery = pwrSrchResultPopupService.getPwrSrchResultPopupQueryResultList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		Log.Debug("##############################\n"+query);
		Log.Debug("##############################\n"+adminQuery);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", resultQuery);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	public Map<String, Object> getSessionQuery(Map<String, Object> tMap, List<?> sList){
		for(int i =0; i<sList.size(); i++){
			Map<?, ?> m = (Map<?, ?>) sList.get(i);
			tMap.put("@@"+StringUtil.nvl_trim( m.get("columnNm").toString(),"") +"@@",m.get("inputValue"));
		}
		return tMap;
	}
	
	public String changeQuery(String query, Map<String, Object> tMap){
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