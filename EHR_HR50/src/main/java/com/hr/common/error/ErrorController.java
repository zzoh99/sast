package com.hr.common.error;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;

/**
 * 공통 에러 관리
 *
 * @author ParkMoohun
 */
@Controller
//@RequestMapping(value="/Error.do", method=RequestMethod.POST )
public class ErrorController {
	@Inject
	@Named("ErrorService")
	private ErrorService errorService;

	/**
	 * ERROR Message 설정
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/Error.do", method=RequestMethod.GET )
	public ModelAndView viewError(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Log.DebugStart();

		// Y정산 화면에서 Error.do 로 요청이 왔을 때 Info.do 로 Redirect 함.
		String code = (String) paramMap.get("code");
		response.sendRedirect("/Info.do?code="+code.replaceAll("[\\r\\n]", ""));

		return null;
	}

	/**
	 * Information Message 설정
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/Info.do", method=RequestMethod.GET )
	public ModelAndView viewInfo(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Log.DebugStart();
		Log.Debug("info start"+ paramMap.toString());
		String code = (String) paramMap.get("code");

		try {
			response.setStatus(Integer.parseInt(code));

		} catch (NumberFormatException e) {
			code ="1000";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/error/info");
		mv.addObject("code", code);
		Log.Debug("info end"+ paramMap.toString());
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/Mpage.do", method=RequestMethod.GET )
	public ModelAndView viewMpage(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Log.DebugStart();
		String code = (String) paramMap.get("code");
		String message = "";
		String title   = "";
	    title   = "Error";

		if(code == null) code ="904";
		if(code.equals("906")){
			title   = "Info";
			message = "요청 하신 페이지로 이동중입니다. <br>잠시 기다려 주십시오!";
		}else{
			message = "요청 하신 서비스를 사용하실수 없습니니다.<br>관리자에게 문의 하십시오!";
		}

		response.setStatus(Integer.parseInt(code));
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/error/info");
		mv.addObject("code", code);
		mv.addObject("title", title);
		mv.addObject("message", message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 에러 발생시 담당자 정보 표시
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getErrorChargeInfo.do", method=RequestMethod.GET )
	public ModelAndView getErrorChargeInfo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String Message = "";
		List<?> result = errorService.getErrorChargeInfo(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();

		return mv;
	}
}