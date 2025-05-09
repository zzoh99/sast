package com.hr.common.execPrc;
import java.util.HashMap;
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
 * EXECUTE PROCEDURE Controller
 *
 * @author RYU SIOONG
 *
 */
@Controller
@RequestMapping(value="/ExecPrc.do", method=RequestMethod.POST )
public class ExecPrcController {

	/**
	 * EXECUTE PROCEDURE 서비스
	 */
	@Inject
	@Named("ExecPrcService")
	private ExecPrcService execPrcService;

	@RequestMapping
	public ModelAndView execPrc(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<?, ?> map  = execPrcService.execPrc(paramMap);

		if (map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlCode : "+map.get("sqlCode"));
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlErrm : "+map.get("sqlErrm"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("sqlCode") != null) {
			resultMap.put("Code", map.get("sqlCode").toString());
		}
		if (map.get("sqlcode") != null) {
			resultMap.put("Code", map.get("sqlcode").toString());
		}
		if (map.get("sqlErrm") != null) {
			resultMap.put("Message", map.get("sqlErrm").toString());
		}
		if (map.get("sqlerrm") != null) {
			resultMap.put("Message", map.get("sqlerrm").toString());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		
		Log.DebugEnd();
		return mv;
	}
	
}