package com.hr.cpn.payRetroact.retroCalcCre;
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
 * 소급계산 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping({"/RetroCalcCreProc.do", "/RetroCalcCre.do"})
public class RetroCalcCreProcController {

	/**
	 * 소급계산 서비스
	 */
	@Inject
	@Named("RetroCalcCreProcService")
	private RetroCalcCreProcService retroCalcCreProcService;

	/**
	 * 소급계산
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_RE_PAY_MAIN", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_RE_PAY_MAIN(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		Map<String, Object> resultMap = new HashMap<String, Object>();

		try{
			Map map = retroCalcCreProcService.prcP_CPN_RE_PAY_MAIN(paramMap);
//			Log.Debug("retroCalcCreProcService.prcP_CPN_RE_PAY_MAIN map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");
			resultMap.put("Code", "0");
			if (map != null && map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
				resultMap.put("Code", map.get("sqlcode").toString());
				if (map.get("sqlerrm") != null) {
					resultMap.put("Message", map.get("sqlerrm").toString());
				} else {
					resultMap.put("Message", "소급계산 오류입니다.111111");
				}
			}
			
		}catch(Exception e){
			resultMap.put("Code", "");
			resultMap.put("Message", "소급계산 오류입니다.222222" + e.toString());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}
}