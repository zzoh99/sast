package com.hr.hrm.promotion.promTargetLst;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;

/**
 * 승진대상자명단 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/PromTargetLst.do", method=RequestMethod.POST )
public class PromTargetLstController {
	/**
	 * 승진대상자명단 서비스
	 */
	@Inject
	@Named("PromTargetLstService")
	private PromTargetLstService promTargetLstService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 승진대상자명단(대상자생성) 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcPromTargetLst", method = RequestMethod.POST )
	public ModelAndView prcPromTargetLst(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("promotionCd",paramMap.get("promotionCd"));
		paramMap.put("sabun","");

		Map map  = promTargetLstService.prcPromTargetLst(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
			
			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			}
		}

		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		// 그리드에 맵핑 되는 데이터 이면 DATA에 담아서 보냄
		// comment 종료
		Log.DebugEnd();
		return mv;
	}
}
