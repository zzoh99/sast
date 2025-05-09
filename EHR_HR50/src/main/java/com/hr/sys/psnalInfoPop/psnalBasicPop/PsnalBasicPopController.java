package com.hr.sys.psnalInfoPop.psnalBasicPop;
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
 * 인사기본(기본탭) Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PsnalBasicPop.do", method=RequestMethod.POST )
public class PsnalBasicPopController {

	/**
	 * 인사기본(기본탭) 서비스
	 */
	@Inject
	@Named("PsnalBasicPopService")
	private PsnalBasicPopService psnalBasicPopService;

	/**
	 * 근무지 코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicPopLocationCodeList", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicPopLocationCodeList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> result = psnalBasicPopService.getPsnalBasicPopLocationCodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}
}
