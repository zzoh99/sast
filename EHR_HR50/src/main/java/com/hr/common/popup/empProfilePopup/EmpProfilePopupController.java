package com.hr.common.popup.empProfilePopup;

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
 * 개인신상 공통 팝업
 * @author JSG
 */
@Controller
@RequestMapping(value="/EmpProfilePopup.do", method=RequestMethod.POST )
public class EmpProfilePopupController {

	@Inject
	@Named("EmpProfilePopupService")
	private EmpProfilePopupService empProfilePopupService;

	/**
	 * 개인신상팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpProfile", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRdPopup() throws Exception {
		return "common/popup/empProfilePopup";
	}
	
	   /**
     * 개인신상팝업 View Layer
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewEmpProfileLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewEmpProfileLayer() throws Exception {
        return "common/popup/empProfileLayer";
    }

	/**
	 * 개인신상 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpProfile", method = RequestMethod.POST )
	public ModelAndView getEmpProfile(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map =null;
		String Message = "";
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));

		try{
			map = empProfilePopupService.getEmpProfile(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}