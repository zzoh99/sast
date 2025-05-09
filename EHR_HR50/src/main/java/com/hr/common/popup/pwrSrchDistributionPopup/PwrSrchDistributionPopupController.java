package com.hr.common.popup.pwrSrchDistributionPopup;

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

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 조건검색 설정 배포 팝업
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/PwrSrchDistributionPopup.do", method=RequestMethod.POST )
public class PwrSrchDistributionPopupController {

	@Inject
	@Named("PwrSrchDistributionPopupService")
	private PwrSrchDistributionPopupService pwrSrchDistributionPopupService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	/**
	 * 조건검색 설정 배포 팝업
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwrSrchDistributionPopup", method = RequestMethod.POST )
	public ModelAndView pwrSrchDistributionPopup(@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/pwrSrchDistributionPopup");
		return mv;
	}
	
	/**
	 * 조건검색 설정 배포 팝업 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getpwrSrchDistributionPopupList", method = RequestMethod.POST )
	public ModelAndView getPayUdfMasterList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		try{
			list = pwrSrchDistributionPopupService.getPwrSrchDistributionPopupList(paramMap);
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
	 * 조건검색 설정 배포 팝업 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePwrSrchDistributionPopup", method = RequestMethod.POST )
	public ModelAndView savepwrSrchDistributionPopup(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames = "sNo,sDelete,sStatus,searchSeq,columnNm,seq,orderBySeq,ascDesc,inqType";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();
		int cnt = 0;
		if(insertList.size()>0){
    		for(Map<String,Object> mp : insertList) {
    			Map<String,Object> dupMap = new HashMap<String,Object>();
    			dupMap.put("ENTER_CD"	,mp.get("ssnEnterCd"));
    			dupMap.put("SEARCH_SEQ"	,mp.get("searchSeq"));
    			dupMap.put("SABUN"		,mp.get("ssnSabun"));
    			dupList.add(dupMap);
    		}
    		try{
		    	cnt = commonCodeService.getDupCnt("THRI217", "ENTER_CD,SEARCH_SEQ,SABUN", "s,i,s",dupList);
	    		if(cnt > 0 ){
	    			cnt = -1; message="중복된 값이 존재합니다.";
	    		}
    		}catch(Exception e){
    			cnt = -1; message="중복 체크에 실패하였습니다.";
    		}
		}
		if(cnt == 0){
			try{
				cnt = pwrSrchDistributionPopupService.savePwrSrchDistributionPopup(convertMap);
				if (cnt > 0) { message="저장되었습니다."; } 
				else { message="저장된 내용이 없습니다."; }
				
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
}