package com.hr.hrm.appmt.largeAppmtMgr;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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
import com.hr.hrm.appmtBasic.appmtItemMapMgr.AppmtItemMapMgrService;

/**
 * 대량발령 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/LargeAppmtMgr.do", method=RequestMethod.POST )
public class LargeAppmtMgrController {

	/**
	 * 대량발령 서비스
	 */
	@Inject
	@Named("LargeAppmtMgrService")
	private LargeAppmtMgrService largeAppmtMgrService;

	@Inject
	@Named("AppmtItemMapMgrService")
	private AppmtItemMapMgrService appmtItemMapMgrService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 대량발령 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewLargeAppmtMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewLargeAppmtMgr() throws Exception {
		return "hrm/appmt/largeAppmtMgr/largeAppmtMgr";
	}
	
	/**
	 * 발령처리 다건 조회(페이징無)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLargeAppmtMgrList", method = RequestMethod.POST )
	public ModelAndView getLargeAppmtMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		paramMap.put("searchUseYn", "Y");
		// 발령항목(select문을 만들기위해 post_item을 조회)조회
		List<?> postItemList  = appmtItemMapMgrService.getAppmtItemMapMgrList(paramMap);
		paramMap.put("postItemRows", postItemList);
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			paramMap.put("searchOrdYn", "N");//확정되지 않은건만 조회가능
			list = largeAppmtMgrService.getLargeAppmtMgrList(paramMap);
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
	
	@RequestMapping(params="cmd=getExectedDContent", method = RequestMethod.POST )
	public ModelAndView getExectedDContent(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			//String dContent = ((String)paramMap.get("dContent")).replaceAll("''","'");
			
			list  = largeAppmtMgrService.getExectedDContent(paramMap);
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
	 * 대량발령 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=saveLargeAppmtMgrExec", method = RequestMethod.POST )
	public ModelAndView saveLargeAppmtMgrExec(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("processNo",paramMap.get("searchProcessNo"));
		String message = "";
		Map<String,Object> returnMap = null;
		List<Map<String,Object>> errorList = null;
		int resultCnt = -1;
		try{
			//발령세부내역용 (THRM223)
			// 발령항목(select문을 만들기위해 post_item을 조회)조회
			paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
			paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));			
			paramMap.put("searchUseYn", "Y");			
			//paramMap.put("includeNm", "Y");
			;	
			Map<String, Object> convertMap2 = ParamUtils.requestInParamsMultiDMLPost(request, paramMap.get("s_SAVENAME").toString(), paramMap.get("s_SAVENAME2").toString(), "VALUE", appmtItemMapMgrService.getAppmtItemMapMgrList(paramMap));
			if (convertMap2 != null) {
				convertMap2.put("ssnSabun", 	session.getAttribute("ssnSabun"));
				convertMap2.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
				convertMap2.put("processNo",paramMap.get("processNo"));
					
				Log.Debug("---------->"+convertMap2);
				
				// insert or update
				returnMap = largeAppmtMgrService.saveLargeAppmtMgrExec(convertMap, convertMap2);
				// get result 
				resultCnt = (Integer)returnMap.get("successCnt");
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message = "저장된 내용이 없습니다."; }
				errorList = (List<Map<String,Object>>) returnMap.get("errorList");
				if(errorList!=null && errorList.size()>0){
					message = "";
					for(Map<String,Object> err : errorList){
						message += ",{\"ordError\":\"동일한 [발령, 발령일, 사원]이 품의번호["+err.get("dupProcessNo")+"["+err.get("dupProcessTitle")+"]]에 등록되어있습니다.\"";
						Iterator<?> errIterator = err.entrySet().iterator();
						while (errIterator.hasNext()) {
							Map.Entry<?, ?> entry = (Map.Entry<?, ?>) errIterator.next();
							message += ",\""+entry.getKey()+"\":\""+entry.getValue()+"\"";						
						 }
						message += "}";
					}
					message = "["+message.substring(1)+"]";
				}
			}
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
}
