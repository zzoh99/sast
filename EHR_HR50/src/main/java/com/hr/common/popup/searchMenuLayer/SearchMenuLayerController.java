package com.hr.common.popup.searchMenuLayer;
import java.util.Map;

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
@RequestMapping(value="/SearchMenuLayer.do", method=RequestMethod.POST )
public class SearchMenuLayerController extends ComController {
	
	/**
	 * 공통코드 레이어팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSearchMenuLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSearchMenuLayer() throws Exception {
		return "common/popup/searchMenuLayer";
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
	@RequestMapping(params="cmd=getSearchMenuLayerList", method = RequestMethod.POST )
	public ModelAndView getSearchMenuLayerList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
}
