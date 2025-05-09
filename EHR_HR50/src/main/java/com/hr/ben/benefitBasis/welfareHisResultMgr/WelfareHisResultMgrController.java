package com.hr.ben.benefitBasis.welfareHisResultMgr;
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

/**
 * 복리후생마감관리 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/WelfareHisResultMgr.do", method=RequestMethod.POST )
public class WelfareHisResultMgrController {

	/**
	 * 복리후생마감관리 서비스
	 */
	@Inject
	@Named("WelfareHisResultMgrService")
	private WelfareHisResultMgrService welfareHisResultMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	
	/**
	 * 복리후생마감관리 화면 View
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWelfareHisResultMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWelfareHisResultMgr(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug();
		return "ben/benefitBasis/welfareHisResultMgr/welfareHisResultMgr";
	}
	
	/**
	 * 복리후생마감관리 화면 View
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWelfareHisResult2Mgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWelfareHisResultMgr2(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug();
		return "ben/benefitBasis/welfareHisResult2Mgr/welfareHisResult2Mgr";
	}
	
	
	/**
	 * getWelfareHisResultMgrList 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWelfareHisResultMgrList", method = RequestMethod.POST )
	public ModelAndView getWelfareHisResultMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = welfareHisResultMgrService.getWelfareHisResultMgrList(paramMap);
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
	 * getWelfareHisResultMgr2List 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWelfareHisResult2MgrList", method = RequestMethod.POST )
	public ModelAndView getWelfareHisResultMgr2List(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = welfareHisResultMgrService.getWelfareHisResult2MgrList(paramMap);
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
	
}