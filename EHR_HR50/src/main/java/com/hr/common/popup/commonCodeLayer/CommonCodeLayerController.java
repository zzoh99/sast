package com.hr.common.popup.commonCodeLayer;
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
@RequestMapping(value="/CommonCodeLayer.do", method=RequestMethod.POST )
public class CommonCodeLayerController extends ComController {
	
	/**
	 * 공통코드 레이어팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCommonCodeLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCommonCodeLayer() throws Exception {
		return "common/popup/commonCodeLayer";
	}

	@RequestMapping(params="cmd=viewCommonRdLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCommonRdLayer() throws Exception {
		return "common/popup/commonRdLayer";
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
	@RequestMapping(params="cmd=getCommonCodeLayerList", method = RequestMethod.POST )
	public ModelAndView getCommonCodeLayerList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
}
