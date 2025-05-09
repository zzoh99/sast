package com.hr.sys.pwrSrch.pwrSrchCdElemtMgr;

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
import com.hr.common.util.ParamUtils;
import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;

/**
 * 조건검색코드항목관리
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/PwrSrchCdElemtMgr.do", method=RequestMethod.POST )
public class PwrSrchCdElemtMgrController {

	@Inject
	@Named("PwrSrchCdElemtMgrService")
	private PwrSrchCdElemtMgrService pwrSrchCdElemtMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	/**
	 * 조건검색코드항목관리 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPwrSrchCdElemtMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPwrSrchCdElemtMgr(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("PwrSrchCdElemtMgrController.viewPwrSrchCdElemtMgr");
		return "sys/pwrSrch/pwrSrchCdElemtMgr/pwrSrchCdElemtMgr";
	}

	/**
	 * 조건검색코드항목관리 리스트 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchCdElemtMgrList", method = RequestMethod.POST )
	public ModelAndView getPwrSrchCdElemtMgrList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		//한글이 들어 올경우 UTF-8로 Convertion해줘야 된다.
		paramMap = ParamUtils.converterParams(request);
		paramMap.put("enterCd", session.getAttribute("ssnEnterCd"));
		
		List<?> result = pwrSrchCdElemtMgrService.getPwrSrchCdElemtMgrList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조건검색코드항목관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=savePwrSrchCdElemtMgr", method = RequestMethod.POST )
	public ModelAndView savePwrSrchCdElemtMgr(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		String ssnEnterCd = session.getAttribute("ssnEnterCd").toString();
		
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", ssnEnterCd);
		 
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> insertList = (List<Map<String, Object>>)convertMap.get("insertRows");
		List<Map<String, Object>> dupList = new ArrayList<Map<String,Object>>();
		int cnt = 0;
		if(insertList.size()>0){
    		for(Map<String,Object> mp : insertList) { Map<String,Object> dupMap = new HashMap<String,Object>();
    			dupMap.put("ENTER_CD"	,ssnEnterCd);
    			dupMap.put("SEARCH_ITEM_CD"	,mp.get("searchItemCd"));
    			dupList.add(dupMap);
    		}
    		try{ cnt = commonCodeService.getDupCnt("THRI203", "ENTER_CD,SEARCH_ITEM_CD", "s,s",dupList);
	    		if(cnt > 0 ) cnt = -1; message="중복된 값이 존재합니다.";
    		}catch(Exception e){ cnt = -1; message="중복 체크에 실패하였습니다."; }
		}
		if(cnt == 0){
			try{ cnt = pwrSrchCdElemtMgrService.savePwrSrchCdElemtMgr(convertMap);
				if (cnt > 0) { message="저장되었습니다."; }  else { message="저장된 내용이 없습니다."; }
			}catch(Exception e){ cnt=-1; message="저장 실패하였습니다."; }
		}
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조건검색코드항목관리 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwrSrchCdElemtMgrPopup", method = RequestMethod.POST )
	public ModelAndView pwrSrchCdElemtMgrPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("PwrSrchCdElemtMgrController.pwrSrchCdElemtMgrPopup");
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
//		Map<?,?> result = pwrSrchCdElemtMgrService.getPwrSrchCdElemtMgrDetail(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("sys/pwrSrch/pwrSrchCdElemtMgr/pwrSrchCdElemtMgrPopup");
//		mv.addObject(result);
		return mv;
	}
	
	@RequestMapping(params="cmd=viewPwrSrchCdElemtMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPwrSrchCdElemtMgrPopup() {
		return "sys/pwrSrch/pwrSrchCdElemtMgr/pwrSrchCdElemtMgrLayer";
	}
}
