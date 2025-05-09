package com.hr.pap.evaluation.mboTargetMidApr;
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
 * 중간점검승인 Controller 
 * 
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/MboTargetMidApr.do", method=RequestMethod.POST )
public class MboTargetMidAprController {
	/**
	 * 중간점검승인 서비스
	 */
	@Inject
	@Named("MboTargetMidAprService")
	private MboTargetMidAprService mboTargetMidAprService;
	/**
	 * 중간점검승인 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMboTargetMidApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMboTargetMidApr() throws Exception {
		return "pap/evaluation/mboTargetMidApr/mboTargetMidApr";
	}
	/**
	 * 중간점검승인 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMboTargetMidApr2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMboTargetMidApr2() throws Exception {
		return "mboTargetMidApr/mboTargetMidApr";
	}
	/**
	 * 중간점검승인 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMboTargetMidAprList", method = RequestMethod.POST )
	public ModelAndView getMboTargetMidAprList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = mboTargetMidAprService.getMboTargetMidAprList(paramMap);
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
	 * 중간점검승인 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMboTargetMidAprMap", method = RequestMethod.POST )
	public ModelAndView getMboTargetMidAprMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = mboTargetMidAprService.getMboTargetMidAprMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}

}
