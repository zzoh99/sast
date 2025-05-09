package com.hr.sys.other.sendMgr;
import java.util.ArrayList;
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
import com.hr.common.util.StringUtil ;
/**
 * 메뉴명 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/SendMgr.do", method=RequestMethod.POST )
public class SendMgrController {
	/**
	 * 메뉴명 서비스
	 */
	@Inject
	@Named("SendMgrService")
	private SendMgrService sendMgrService;
	
	/**
	 * viewSendMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSendMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSendMgr() throws Exception {
		return "sys/other/sendMgr/sendMgr";
	}
	
	/**
	 * getSendMgrOrgList 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSendMgrOrgList", method = RequestMethod.POST )
	public ModelAndView getSendMgrOrgList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = sendMgrService.getSendMgrOrgList(paramMap);
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
	 * getSendMgrOrgUserList 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSendMgrOrgUserList", method = RequestMethod.POST )
	public ModelAndView getSendMgrOrgUserList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = sendMgrService.getSendMgrOrgUserList(paramMap);
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
	 * 사번으로 이름/전화번호/메일주소 가져오기 
	 * 
	 * @return String
	 * @throws Exception
	 */	
	@RequestMapping(params="cmd=getMailInfo", method = RequestMethod.POST )
	public ModelAndView getMailInfo(
			HttpSession session, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		//paramMap.put("insabun",    StringUtil.replaceInParam(paramMap.get("receiverSabuns").toString()));
		paramMap.put("insabun",    paramMap.get("receiverSabuns")+",");
	
		List<?> result = sendMgrService.getMailInfo(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", result);
		Log.DebugEnd();
		return mv;
	}
	
	
	
	
	
	/**
	 * 사번,이름,메일로 이름/전화번호/메일주소 가져오기 
	 * 
	 * @return String
	 * @throws Exception
	 */	
	@RequestMapping(params="cmd=getMailInfo2", method = RequestMethod.POST )
	public ModelAndView getMailInfo2(
			HttpSession session, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		List<?> result = sendMgrService.getMailInfo2(paramMap);
		
		ModelAndView mv = new ModelAndView();  
		mv.setViewName("jsonView");
		mv.addObject("result", result);
		Log.DebugEnd();
		return mv;
	}

}
