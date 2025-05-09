package com.hr.hrm.appmtBasic.appmtProcessNoMgr;

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

import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.code.CommonCodeService;


@Controller
@RequestMapping(value="/AppmtProcessNoMgr.do", method=RequestMethod.POST )
public class AppmtProcessNoMgrController {

    @Inject
    @Named("CommonCodeService")
    private CommonCodeService commonCodeService;
    
    
	@Inject
	@Named("AppmtProcessNoMgrService")
	private AppmtProcessNoMgrService appmtProcessNoMgrService;
	
	/**
	 * 발령품의번호관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppmtProcessNoMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppmtProcessNoMgr() throws Exception {
		return "hrm/appmtBasic/appmtProcessNoMgr/appmtProcessNoMgr";
	}
	
	
	
	@RequestMapping(params="cmd=getAppmtProcessNoMgrList", method = RequestMethod.POST )
	public ModelAndView getAppmtProcessNoMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appmtProcessNoMgrService.getAppmtProcessNoMgrList(paramMap);
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
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppmtProcessNoSeq", method = RequestMethod.POST )
	public ModelAndView getAppmtProcessNoSeq(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		Object processNoSeq = null;
		String Message = "";
		try{
			processNoSeq = appmtProcessNoMgrService.getAppmtProcessNoSeq(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", processNoSeq);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppmtProcessNoMgr", method = RequestMethod.POST )
	public ModelAndView saveAppmtProcessNoMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
        List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

        for(Map<String,Object> mp : insertList) {
            Map<String,Object> dupMap = new HashMap<String,Object>();
            dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
            dupMap.put("PROCESS_NO",mp.get("sabun"));
            dupList.add(dupMap);
        }
		
		
		String message = "";
		int resultCnt = -1;
		try{
		    int dupCnt = 0;
		    if(insertList.size() > 0) {
                // 중복체크
                dupCnt = commonCodeService.getDupCnt("THRM220","ENTER_CD,PROCESS_NO","s,s",dupList);
            }

            if(dupCnt > 0) {
                resultCnt = -1; message="중복된 값이 존재 합니다.";
            } else {
            
		    
		    resultCnt = appmtProcessNoMgrService.saveAppmtProcessNoMgr(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
            }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패 하였습니다.";
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
