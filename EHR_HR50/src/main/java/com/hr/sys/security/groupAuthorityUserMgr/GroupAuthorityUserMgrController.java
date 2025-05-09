package com.hr.sys.security.groupAuthorityUserMgr;

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

import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;


/**
 * 그룹사권한사용자관리 관리
 * 
 * @author ParkMoohun
 *
 */
@Controller
@RequestMapping(value="/GroupAuthorityUserMgr.do", method=RequestMethod.POST )
public class GroupAuthorityUserMgrController {

	@Inject
	@Named("GroupAuthorityUserMgrService")
	private GroupAuthorityUserMgrService groupAuthorityUserMgrService;

	/**
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewGroupAuthorityUserMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewGroupAuthorityUserMgr(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug();
		
		return "sys/security/groupAuthorityUserMgr/groupAuthorityUserMgr";
	}
	
	@RequestMapping(params="cmd=getGroupAuthorityUserMgrList", method = RequestMethod.POST )
	public ModelAndView getGroupAuthorityUserMgrList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap)throws HrException {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		List<?> result = new ArrayList<Object>();
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try{
			result = groupAuthorityUserMgrService.getGroupAuthorityUserMgrList(paramMap);
			mv.addObject("DATA", result);
		}catch(Exception e){
			mv.addObject("DATA", "");
			mv.addObject("Code", "-1");
			mv.addObject("Message", "데이터 조회에 실패하였습니다.");
		}	
		Log.DebugEnd();
		return mv;
	}
	
	
	@RequestMapping(params="cmd=saveGroupAuthorityUserMgr", method = RequestMethod.POST )
	public ModelAndView saveGroupAuthorityUserMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws HrException {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		int	result = -1;
		Map<String, Object> resultMap= new HashMap<String, Object>();
		String message = "";
		try{
			result = groupAuthorityUserMgrService.saveGroupAuthorityUserMgr(convertMap);
			if (result > 0) { message="저장 되었습니다."; } 
			else { message="저장 실패하였습니다."; }
			resultMap.put("Code", 		result);
			resultMap.put("Message", 	message);
		}catch(Exception e){
			resultMap.put("Code", 		result);
			resultMap.put("Message", 	message);
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(params="cmd=loginInfoCreate", method = RequestMethod.POST )
	public ModelAndView loginInfoCreate(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws HrException {
		Log.DebugStart();
		paramMap.put("chkid", session.getAttribute("ssnEnterCd"));
		Map<String, Object> resultMap= new HashMap<String, Object>();
		Map map  ;
		try{
			map = groupAuthorityUserMgrService.loginInfoCreate(paramMap);
			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			}
		}catch(Exception e){
			resultMap.put("Code", 		"-1");
			resultMap.put("Message", 	"프로시져 호출중 에러가 발생하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
}