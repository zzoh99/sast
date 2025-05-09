package com.hr.common.popup.benComPopup;
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
 * 복리후생 공통팝업 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/BenComPopup.do", method=RequestMethod.POST )
public class BenComPopupController {

	/**
	 * 복리후생 공통팝업 서비스
	 */
	@Inject
	@Named("BenComPopupService")
	private BenComPopupService benComPopupService;

	/**
	 * 조직맵핑구분검색팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewBenMapComPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewBenMapComPopup() throws Exception {
		return "common/popup/benMapPopup";
	}

	/**
	 * 기숙사동/호실검색팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewBenDongSilComPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewBenDongSilComPopup() throws Exception {
		return "common/popup/benDongSilPopup";
	}

	/**
	 * 인사마스타&기숙사업체인원팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewBenEmployeeComPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewBenEmployeeComPopup() throws Exception {
		return "common/popup/benEmployeePopup";
	}

	/**
	 * 조직맵핑구분검색팝업조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBenMapComPopupList", method = RequestMethod.POST )
	public ModelAndView getBenMapComPopupList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = benComPopupService.getBenMapComPopupList(paramMap);
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
	 * 기숙사동/호실검색팝업조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBenDongSilComPopupList", method = RequestMethod.POST )
	public ModelAndView getBenDongSilComPopupList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = benComPopupService.getBenDongSilComPopupList(paramMap);
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
	 * 인사마스타&기숙사업체인원팝업조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBenEmployeeComPopupList", method = RequestMethod.POST )
	public ModelAndView getBenEmployeeComPopupList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = benComPopupService.getBenEmployeeComPopupList(paramMap);
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
}
