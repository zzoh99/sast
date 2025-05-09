package com.hr.cpn.payReport.payDayChkStd;
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
 * 일할계산대상자 관리 Controller 
 * 
 * @author AhnChangJu
 *
 */
@Controller
@RequestMapping(value="/PayDayChkStd.do", method=RequestMethod.POST )
public class PayDayChkStdController {
	/**
	 * 일할계산대상자 관리 서비스
	 */
	@Inject
	@Named("PayDayChkStdService")
	private PayDayChkStdService payDayChkStdService;
	/**
	 * 일할계산대상자 관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayDayChkStd", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayDayChkStd() throws Exception {
		return "cpn/payReport/payDayChkStd/payDayChkStd";
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
	@RequestMapping(params="cmd=getPayDayChkStdList", method = RequestMethod.POST )
	public ModelAndView getPayDayChkStdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = payDayChkStdService.getPayDayChkStdList(paramMap);
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
