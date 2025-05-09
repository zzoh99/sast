package com.hr.pap.intern.internLstMgr;
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
/**
 * 촉탁직평가대상자관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/InternLstMgr.do", method=RequestMethod.POST )
public class InternLstMgrController {
	/**
	 * 촉탁직평가대상자관리 서비스
	 */
	@Inject
	@Named("InternLstMgrService")
	private InternLstMgrService internLstMgrService;
	/**
	 * 촉탁직평가대상자관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewInternLstMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewInternLstMgr() throws Exception {
		return "pap/intern/internLstMgr/internLstMgr";
	}
	/**
	 * 촉탁직평가대상자관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewInternLstMgr2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewInternLstMgr2() throws Exception {
		return "internLstMgr/internLstMgr";
	}
	/**
	 * 촉탁직평가대상자관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternLstMgrList", method = RequestMethod.POST )
	public ModelAndView getInternLstMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = internLstMgrService.getInternLstMgrList(paramMap);
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
	 * 촉탁직평가대상자관리 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternLstMgrMap", method = RequestMethod.POST )
	public ModelAndView getInternLstMgrMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = internLstMgrService.getInternLstMgrMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}

}
