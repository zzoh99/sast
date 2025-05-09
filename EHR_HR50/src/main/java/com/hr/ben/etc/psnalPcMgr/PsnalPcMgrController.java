package com.hr.ben.etc.psnalPcMgr;

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

/**
 * 개인PC정보 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PsnalPcMgr.do", method=RequestMethod.POST ) 
public class PsnalPcMgrController extends ComController {
	/**
	 * 개인PC정보 서비스
	 */
	@Inject
	@Named("PsnalPcMgrService")
	private PsnalPcMgrService psnalPcMgrService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 개인PC정보 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalPcMgr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalPcMgr() throws Exception {
		return "ben/etc/psnalPcMgr/psnalPcMgr";
	}
	
	/**
	 * 개인PC정보 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalPcMgrList", method = RequestMethod.POST )
	public ModelAndView getPsnalPcMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	
	/**
	 * 개인PC정보  조직도  조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalPcMgrOrgList", method = RequestMethod.POST )
	public ModelAndView getPsnalPcMgrOrgList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 개인PC정보 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePsnalPcMgr", method = RequestMethod.POST )
	public ModelAndView savePsnalPcMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		//String[] dupList= {"TBEN650", "ENTER_CD,JIKGUB_CD,SDATE", "ssnEnterCd,jikgubCd,sdate", "s,s,s"};
		//paramMap.put("dupList", dupList);
		
		return saveData(session, request, paramMap);
	}

}
