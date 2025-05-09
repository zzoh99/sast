package com.hr.pap.evaluation.mboTargetApr;
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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 목표등록,중간점검승인 Controller 
 * 
 * @author JCY
 *
 */
@Controller
@RequestMapping({"EvaMain.do", "/MboTargetApr.do"})
public class MboTargetAprController extends ComController {
	/**
	 * 목표등록,중간점검승인 서비스
	 */
	@Inject
	@Named("MboTargetAprService")
	private MboTargetAprService mboTargetAprService;

	/**
	 * 목표등록,중간점검승인 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMboTargetAprList", method = RequestMethod.POST )
	public ModelAndView getMboTargetAprList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

}
