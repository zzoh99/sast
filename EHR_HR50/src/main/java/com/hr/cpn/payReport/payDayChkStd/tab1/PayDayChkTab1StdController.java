package com.hr.cpn.payReport.payDayChkStd.tab1;
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
import com.hr.common.code.CommonCodeService;

/**
 * 일할계산대상자 관리 Controller 
 * 
 * @author AhnChangJu
 *
 */
@Controller
@RequestMapping({"/PayDayChkStd.do", "/PayDayChkTab1Std.do"}) 
public class PayDayChkTab1StdController {
	/**
	 * 일할계산대상자 관리 서비스
	 */
	@Inject
	@Named("PayDayChkTab1StdService")
	private PayDayChkTab1StdService taxTab1StdService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	

	/**
	 * 일할계산대상자 관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayDayChkTab1Std", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayDayChkTab1Std() throws Exception {
		return "cpn/payReport/payDayChkStd/tab1/payDayChkTab1Std";
	}
	/**
	 * 일할계산대상자 관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayDayChkTab1StdList", method = RequestMethod.POST )
	public ModelAndView getPayDayChkTab1StdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = taxTab1StdService.getPayDayChkTab1StdList(paramMap);
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
