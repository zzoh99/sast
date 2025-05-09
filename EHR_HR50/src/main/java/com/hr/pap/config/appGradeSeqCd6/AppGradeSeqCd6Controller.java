package com.hr.pap.config.appGradeSeqCd6;
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

/**
 * 배분결과(3차) Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping({"EvaMain.do","/AppGradeSeqCd6.do"})
public class AppGradeSeqCd6Controller {
	/**
	 * 배분결과(3차) 서비스
	 */
	@Inject
	@Named("AppGradeSeqCd6Service")
	private AppGradeSeqCd6Service appGradeSeqCd6Service;

	/**
	 * 배분결과(3차) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGradeSeqCd6", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGradeSeqCd6() throws Exception {
		return "pap/config/appGradeSeqCd6/appGradeSeqCd6";
	}

	/**
	 * 배분결과(3차)(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGradeSeqCd6Pop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGradeSeqCd6Pop() throws Exception {
		return "pap/config/appGradeSeqCd6/appGradeSeqCd6Pop";
	}
	@RequestMapping(params="cmd=viewAppGradeOrgRateMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGradeOrgRateMgrLayer() throws Exception {
		return "pap/config/appGradeSeqCd2/appGradeOrgRateMgrLayer";
	}

	/**
	 * 배분결과(3차) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGradeSeqCd6List", method = RequestMethod.POST )
	public ModelAndView getAppGradeSeqCd6List(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appGradeSeqCd6Service.getAppGradeSeqCd6List(paramMap);
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

