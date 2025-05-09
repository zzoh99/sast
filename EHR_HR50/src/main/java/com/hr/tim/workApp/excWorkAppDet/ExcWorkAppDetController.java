package com.hr.tim.workApp.excWorkAppDet;
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
import com.hr.common.com.ComController;
import com.hr.common.language.LanguageUtil;
/**
 * 당직신청 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping({"/ExcWorkAppDet.do", "/ExcWorkApp.do"})
public class ExcWorkAppDetController extends ComController {
	/**
	 * 당직신청 서비스
	 */
	@Inject
	@Named("ExcWorkAppDetService")
	private ExcWorkAppDetService excWorkAppDetService;

	/**
	 * 당직신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewExcWorkAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewExcWorkAppDet() throws Exception {
		return "tim/workApp/excWorkAppDet/excWorkAppDet";
	}
	
	/**
	 * 당직신청 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExcWorkAppDet", method = RequestMethod.POST )
	public ModelAndView getExcWorkAppDet(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	
	/**
	 * 당직신청 근무시간 계산 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExcWorkAppDetHour", method = RequestMethod.POST )
	public ModelAndView getExcWorkAppDetHour(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 당직신청 기 신청건 체크 
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExcWorkAppDetDupCnt", method = RequestMethod.POST )
	public ModelAndView getExcWorkAppDetDupCnt(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	

	/**
	 * 당직신청 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveExcWorkAppDet", method = RequestMethod.POST )
	public ModelAndView saveExcWorkAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		return saveData(session, request, paramMap);
		
	}
	
	
}
