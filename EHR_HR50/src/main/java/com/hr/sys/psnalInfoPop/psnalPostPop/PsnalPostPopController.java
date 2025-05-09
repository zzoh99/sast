package com.hr.sys.psnalInfoPop.psnalPostPop;
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

/**
 * 인사기본(발령) Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PsnalPostPop.do", method=RequestMethod.POST )
public class PsnalPostPopController {

	/**
	 * 인사기본(발령) 서비스
	 */
	@Inject
	@Named("PsnalPostPopService")
	private PsnalPostPopService psnalPostPopService;

	/**
	 * 인사기본(발령) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalPostPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalPostPop() throws Exception {
		return "sys/psnalInfoPop/psnalPostPop/psnalPostPop";
	}

	/**
	 * 인사기본(발령 세부내역) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalPostPop2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalPostPop2() throws Exception {
		return "sys/psnalInfoPop/psnalPostPop/psnalPostPop2";
	}

	/**
	 * 인사기본(발령) 발령형태 코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalPostPopAppmtCodeList", method = RequestMethod.POST )
	public ModelAndView getPsnalPostPopAppmtCodeList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		List<?> result = psnalPostPopService.getPsnalPostPopAppmtCodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본(발령 세부내역) 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalPostPop2", method = RequestMethod.POST )
	public ModelAndView getPsnalPostPop2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> map  = new HashMap<String,Object>();
		String Message = "";
		try{
			map = psnalPostPopService.getPsnalPostPop2(paramMap);
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
