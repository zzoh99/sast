package com.hr.common.popup.papCptcPopup;
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
 * 평가관리 - 역량 팝업 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PapCptcPopup.do", method=RequestMethod.POST ) 
public class PapCptcPopupController {
	/**
	 * 평가관리 - 역량 팝업 서비스
	 */
	@Inject
	@Named("PapCptcPopupService")
	private PapCptcPopupService papCptcPopupService;
	/**
	 * 평가관리 - 역량 팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPapCptcLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPapCptcLayer() throws Exception {
		return "common/popup/papCptcLayer";
	}
	/**
	 * 평가관리 - 역량 팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPapCptcPopup2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPapCptcPopup2() throws Exception {
		return "papCptcPopup/papCptcPopup";
	}
	/**
	 * 평가관리 - 역량 팝업 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPapCptcPopupList", method = RequestMethod.POST )
	public ModelAndView getPapCptcPopupList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = papCptcPopupService.getPapCptcPopupList(paramMap);
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
	 * 평가관리 - 역량 팝업 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPapCptcPopupMap", method = RequestMethod.POST )
	public ModelAndView getPapCptcPopupMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = papCptcPopupService.getPapCptcPopupMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}



}
