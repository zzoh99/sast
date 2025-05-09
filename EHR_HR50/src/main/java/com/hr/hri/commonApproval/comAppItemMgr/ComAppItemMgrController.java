package com.hr.hri.commonApproval.comAppItemMgr;
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
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;

/**
 * 공통신청서항목관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/ComAppItemMgr.do", method=RequestMethod.POST ) 
public class ComAppItemMgrController extends ComController {
	/**
	 * 공통신청서항목관리 서비스
	 */
	@Inject
	@Named("ComAppItemMgrService")
	private ComAppItemMgrService comAppItemMgrService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 공통신청서항목관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewComAppItemMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewComAppItemMgr() throws Exception {
		return "hri/commonApproval/comAppItemMgr/comAppItemMgr";
	}
	
	/**
	 * 공통신청서항목관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getComAppItemMgrList", method = RequestMethod.POST )
	public ModelAndView getComAppItemMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 공통신청서항목관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveComAppItemMgr", method = RequestMethod.POST )
	public ModelAndView saveComAppItemMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

}
