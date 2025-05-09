package com.hr.common.getDataMap;
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
 * GET DATA MAP TYPE Controller
 *
 * @author RYU SIOONG
 *
 */
@Controller
@RequestMapping(value="/GetDataMap.do", method=RequestMethod.POST )
public class GetDataMapController {

	/**
	 * GET DATA MAP TYPE 서비스
	 */
	@Inject
	@Named("GetDataMapService")
	private GetDataMapService getDataMapService;

	@RequestMapping
	public ModelAndView getDataMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = getDataMapService.getDataMap(paramMap);
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