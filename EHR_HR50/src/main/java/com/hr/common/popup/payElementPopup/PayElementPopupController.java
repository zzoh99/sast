package com.hr.common.popup.payElementPopup;
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
 * 급여항목검색 팝업
 * @author 
 */
@Controller
@RequestMapping(value="/PayElementPopup.do", method=RequestMethod.POST )
public class PayElementPopupController {

	@Inject
	@Named("PayElementPopupService")
	private PayElementPopupService payElementPopupService;
	
	/**
	 * 급여항목
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=payElementPopup", method = RequestMethod.POST )
	public String payElementPopup() throws Exception {
		return "common/popup/payElementPopup";
	}
	@RequestMapping(params="cmd=viewPayElementLayer",method = {RequestMethod.POST, RequestMethod.GET} )
	public String payElementLayer() throws Exception {
		return "common/popup/payElementLayer";
	}
	
	/**
	 * 급여항목
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayElementList", method = RequestMethod.POST )
	public ModelAndView getPayElementList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		try{
			// 호출대상 쿼리판단
			String queryFile = "Element";
			if ("".equals(paramMap.get("searchElementLinkType1").toString())) {
				queryFile = "ElementAll";
			} else if (!paramMap.get("searchElementLinkType1").toString().equals(paramMap.get("searchElementLinkType2").toString())) {
		        queryFile = "Element1";
		    }
			if ("".equals(paramMap.get("searchElementLinkType1").toString())) {
				queryFile = "RetroElement";
			} else if(paramMap.get("isSep") != null && ("Y".equals(paramMap.get("isSep").toString()) || "EY".equals(paramMap.get("isSep").toString()))) {
		        queryFile = "SepElement";
		    }

		    if (paramMap.get("callPage") != null && !"".equals(paramMap.get("callPage"))) {
		    	list = payElementPopupService.getPayElementCallPageList(paramMap);

		    } else if (queryFile.equals("Element")) {
		    	list = payElementPopupService.getPayElementList(paramMap);
		    } else if (queryFile.equals("ElementAll")) {
		    	list = payElementPopupService.getPayElementAllList(paramMap);
		    } else if (queryFile.equals("Element1")) {
		    	list = payElementPopupService.getPayElement1List(paramMap);
		    } else if (queryFile.equals("RetroElement")) {
		    	// 소급
		    	list = payElementPopupService.getRetroElementList(paramMap);
		    } else if (queryFile.equals("SepElement")) {
		    	// 퇴직
		    	list = payElementPopupService.getSepElementList(paramMap);
		    }
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}
}