package com.hr.common.popup.orgCapaEmpPopup;
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
 * 월별 충원내역 팝업 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/OrgCapaEmpPopup.do", method=RequestMethod.POST )
public class OrgCapaEmpPopupController {

	/**
	 * 월별 충원내역 팝업 서비스
	 */
	@Inject
	@Named("OrgCapaEmpPopupService")
	private OrgCapaEmpPopupService orgCapaEmpPopupService;

	/**
	 * 조직맵핑구분검색팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	
	@RequestMapping(params="cmd=orgCapaEmpPopup", method = RequestMethod.POST )
	public String orgCapaEmpPopup() throws Exception {
		return "common/popup/orgCapaEmpPopup";
	}
	
	@RequestMapping(params="cmd=viewOrgCapaEmpLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgCapEmpLayer() throws Exception {
		return "common/popup/orgCapaEmpLayer";
	}
	

	/**
	 * 월별 충원내역 팝업조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgCapaEmpList", method = RequestMethod.POST )
	public ModelAndView getOrgCapaEmpList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = orgCapaEmpPopupService.getOrgCapaEmpList(paramMap);
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
