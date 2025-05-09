package com.hr.pap.evaluation.mboTargetMidReg;
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
 * 중간점검등록 Controller 
 * 
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/MboTargetMidReg.do", method=RequestMethod.POST )
public class MboTargetMidRegController {
	/**
	 * 중간점검등록 서비스
	 */
	@Inject
	@Named("MboTargetMidRegService")
	private MboTargetMidRegService mboTargetMidRegService;
	/**
	 * 중간점검등록 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMboTargetMidReg", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMboTargetMidReg() throws Exception {
		return "pap/evaluation/mboTargetMidReg/mboTargetMidReg";
	}
	/**
	 * 중간점검등록 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMboTargetMidReg2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMboTargetMidReg2() throws Exception {
		return "mboTargetMidReg/mboTargetMidReg";
	}
	/**
	 * 중간점검등록 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMboTargetMidRegList", method = RequestMethod.POST )
	public ModelAndView getMboTargetMidRegList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = mboTargetMidRegService.getMboTargetMidRegList(paramMap);
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
	 * 중간점검등록 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMboTargetMidRegMap", method = RequestMethod.POST )
	public ModelAndView getMboTargetMidRegMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = mboTargetMidRegService.getMboTargetMidRegMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}

}
