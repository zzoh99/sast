package com.hr.common.popup.orgCapaPlanPopup;
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
 * 월별 계획내역 팝업 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/OrgCapaPlanPopup.do", method=RequestMethod.POST )
public class OrgCapaPlanPopupController {

	/**
	 * 월별 계획내역 팝업 서비스
	 */
	@Inject
	@Named("OrgCapaPlanPopupService")
	private OrgCapaPlanPopupService orgCapaPlanPopupService;

	/**
	 * 조직맵핑구분검색팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	
	@RequestMapping(params="cmd=orgCapaPlanPopup", method = RequestMethod.POST )
	public String orgCapaPlanPopup() throws Exception {
		return "common/popup/orgCapaPlanPopup";
	}

	@RequestMapping(params="cmd=viewOrgCapaPlanLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgCapaPlanLayer() throws Exception {
		return "common/popup/orgCapaPlanLayer";
	}

	/**
	 * 월별 계획내역 팝업조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgCapaPlanList", method = RequestMethod.POST )
	public ModelAndView getOrgCapaPlanList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = orgCapaPlanPopupService.getOrgCapaPlanList(paramMap);
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
