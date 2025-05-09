package com.hr.pap.config.appClassAssignMgr;
import java.util.ArrayList;
import com.hr.common.code.CommonCodeService;
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
/**
 * 평가등급부여기준 Controller 
 * 
 * @author jcy
 *
 */
@Controller
@RequestMapping(value="/AppClassAssignMgr.do", method=RequestMethod.POST )
public class AppClassAssignMgrController {
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	/**
	 * 평가등급부여기준 서비스
	 */
	@Inject
	@Named("AppClassAssignMgrService")
	private AppClassAssignMgrService templateService;
	/**
	 * 평가등급부여기준 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppClassAssignMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppClassAssignMgr() throws Exception {
		return "pap/config/appClassAssignMgr/appClassAssignMgr";
	}
	/**
	 * 평가등급부여기준 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppClassAssignMgr2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppClassAssignMgr2() throws Exception {
		return "template/template";
	}
	/**
	 * 평가등급부여기준 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppClassAssignMgrList", method = RequestMethod.POST )
	public ModelAndView getAppClassAssignMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = templateService.getAppClassAssignMgrList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 평가등급부여기준 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppClassAssignMgrMap", method = RequestMethod.POST )
	public ModelAndView getAppClassAssignMgrMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = templateService.getAppClassAssignMgrMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 평가등급부여기준 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppClassAssignMgr", method = RequestMethod.POST )
	public ModelAndView saveAppClassAssignMgr(
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
			dupMap.put("INWON",mp.get("inwon"));
			dupMap.put("CLASS_CD_FROM",mp.get("classCdFrom"));
			dupList.add(dupMap);
		}
		
		
		String message = "";
		int resultCnt = -1;
		try{
			
			int dupCnt = 0;
			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TPAP231","ENTER_CD,INWON,CLASS_CD_FROM","s,i,s",dupList);
			}
			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
			resultCnt =templateService.saveAppClassAssignMgr(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			}
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
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
