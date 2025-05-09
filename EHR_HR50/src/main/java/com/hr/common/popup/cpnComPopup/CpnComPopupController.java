package com.hr.common.popup.cpnComPopup;
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
 * 급여 공통팝업 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/CpnComPopup.do", method=RequestMethod.POST )
public class CpnComPopupController {

	/**
	 * 급여 공통팝업 서비스
	 */
	@Inject
	@Named("CpnComPopupService")
	private CpnComPopupService cpnComPopupService;

	/**
	 * 진행상태확인팝업 View
	 *
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCpnProcessBarComPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCpnProcessBarComPopup() throws Exception {
		Log.DebugStart();
		return "common/popup/cpnProcessBarPopup";
	}
	@RequestMapping(params="cmd=viewCpnProcessBarComLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCpnProcessBarComLayer() throws Exception {
		Log.DebugStart();
		return "common/popup/cpnProcessBarLayer";
	}

	/**
	 * 프로시저 진행상태 팝업 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCpnProcessBarComPopupMap", method = RequestMethod.POST )
	public ModelAndView getCpnProcessBarComPopupMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = cpnComPopupService.getCpnProcessBarComPopupMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map",map);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}
}