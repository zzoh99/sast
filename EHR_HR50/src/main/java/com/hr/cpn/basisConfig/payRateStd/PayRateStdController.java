package com.hr.cpn.basisConfig.payRateStd;
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
 * 급여지급율관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PayRateStd.do", method=RequestMethod.POST )
public class PayRateStdController {
	/**
	 * 급여지급율관리 서비스
	 */
	@Inject
	@Named("PayRateStdService")
	private PayRateStdService payRateStdService;
	/**
	 * 급여지급율관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayRateStd", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayRateStd() throws Exception {
		return "cpn/basisConfig/payRateStd/payRateStd";
	}
	/**
	 * 급여지급율관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayRateStdList", method = RequestMethod.POST )
	public ModelAndView getPayRateStdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = payRateStdService.getPayRateStdList(paramMap);
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
	 * 급여지급율관리 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayRateStdMap", method = RequestMethod.POST )
	public ModelAndView getPayRateStdMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = payRateStdService.getPayRateStdMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}

}
