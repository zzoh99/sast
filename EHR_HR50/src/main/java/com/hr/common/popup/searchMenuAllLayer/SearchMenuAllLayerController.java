package com.hr.common.popup.searchMenuAllLayer;
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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;

/**
 * 공통코드레이어팝업 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/SearchMenuAllLayer.do", method=RequestMethod.POST )
public class SearchMenuAllLayerController extends ComController {

	@Inject
	@Named("SearchMenuAllLayerService")
	private SearchMenuAllLayerService searchMenuAllLayerService;

	/**
	 * 공통코드 레이어팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSearchMenuAllLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSearchMenuAllLayer() throws Exception {
		return "common/popup/searchMenuAllLayer";
	}
	
	/**
	 * 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSearchMenuAllLayerList", method = RequestMethod.POST )
	public ModelAndView getSearchMenuAllLayerList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = searchMenuAllLayerService.getSearchMenuAllLayerList(paramMap);
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
