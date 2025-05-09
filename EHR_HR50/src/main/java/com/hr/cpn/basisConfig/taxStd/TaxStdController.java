package com.hr.cpn.basisConfig.taxStd;
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
 * 세율 및 과세표준 관리 Controller 
 * 
 * @author AhnChangJu
 *
 */
@Controller
@RequestMapping(value="/TaxStd.do", method=RequestMethod.POST )
public class TaxStdController {
	/**
	 * 세율 및 과세표준 관리 서비스
	 */
	@Inject
	@Named("TaxStdService")
	private TaxStdService taxStdService;
	/**
	 * 세율 및 과세표준 관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTaxStd", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTaxStd() throws Exception {
		return "cpn/basisConfig/taxStd/taxStd";
	}
	
	/**
	 * 세율 및 과세표준 관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTaxStdList", method = RequestMethod.POST )
	public ModelAndView getTaxStdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = taxStdService.getTaxStdList(paramMap);
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
	 * 세율 및 과세표준 관리 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTaxStdMap", method = RequestMethod.POST )
	public ModelAndView getTaxStdMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map =null;
		String Message = "";
		try{
			map = taxStdService.getTaxStdMap(paramMap);
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
