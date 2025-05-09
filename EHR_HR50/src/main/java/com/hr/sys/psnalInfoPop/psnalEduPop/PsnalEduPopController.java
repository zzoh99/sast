package com.hr.sys.psnalInfoPop.psnalEduPop;
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

/**
 * 인사기본(교육) Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PsnalEduPop.do", method=RequestMethod.POST )
public class PsnalEduPopController {

	/**
	 * 인사기본(교육) 서비스
	 */
	@Inject
	@Named("PsnalEduPopService")
	private PsnalEduPopService psnalEduPopService;

	/**
	 * 인사기본(교육) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalEduPopList", method = RequestMethod.POST )
	public ModelAndView getPsnalEduPopList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> list  = new ArrayList<Object>();
		Map<?, ?> map  = new HashMap<String,Object>();
		String Message = "";
		try{
			list = psnalEduPopService.getPsnalEduPopList(paramMap);
			map = psnalEduPopService.getPsnalEduPopScore(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		mv.addObject("Etc", map);
		Log.DebugEnd();
		return mv;
	}
}
