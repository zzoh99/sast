package com.hr.pap.evaluation.appCompMgr;

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

import com.hr.common.com.ComController;
import com.hr.common.com.ComService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 역량평가 Controller
 *
 */
@Controller
@RequestMapping(value="/AppCompMgr.do", method=RequestMethod.POST )
public class AppCompMgrController extends ComController {

	@Inject
	@Named("AppCompMgrService")
	private AppCompMgrService appCompMgrService;

	/**
	 * 공통 서비스
	 */
	@Inject
	@Named("ComService")
	private ComService comService;

	/**
	 * 역량평가 View
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppCompMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppCompMgr(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		return "pap/evaluation/appCompMgr/appCompMgr";
	}

	/**
	 * 역량평가 저장
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppCompMgr", method = RequestMethod.POST )
	public ModelAndView saveAppCompMgr(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("cmd", "prcAppCompUpdate");
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,
				paramMap.get("s_SAVENAME").toString(), "");
		List<Map<String, String>> mergeRows = (List<Map<String, String>>) convertMap.get("mergeRows");

		for (int i = 0; i < mergeRows.size(); i++) {

			Map<String, String> row = mergeRows.get(i);

			paramMap.put("appOrgCd", row.get("appOrgCd"));
			paramMap.put("sabun", row.get("sabun"));

			paramMap.put("compCd1001", row.get("compCd1001"));
			paramMap.put("compCd1002", row.get("compCd1002"));
			paramMap.put("compCd1003", row.get("compCd1003"));
			paramMap.put("compCd1004", row.get("compCd1004"));
			paramMap.put("compCd1005", row.get("compCd1005"));
			paramMap.put("compCd1006", row.get("compCd1006"));
			paramMap.put("compCd1007", row.get("compCd1007"));

			Map<?, ?> map = comService.execPrc(paramMap);

			if(map != null) {
				Log.Debug("obj : " + map);
				Log.Debug("sqlcode : " + map.get("sqlcode"));
				Log.Debug("sqlerrm : " + map.get("sqlerrm"));
				
				if (map.get("sqlcode") != null) {
					resultMap.put("Code", map.get("sqlcode").toString());
				}
				if (map.get("sqlerrm") != null) {
					resultMap.put("Message", map.get("sqlerrm").toString());
				}
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 등급별 점수변환
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppCompCdToPoint", method = RequestMethod.POST )
	public ModelAndView getAppCompCdToPoint(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<?, ?> map = appCompMgrService.getAppCompCdToPoint(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 역량평가 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppCompMgrList", method = RequestMethod.POST )
	public ModelAndView getAppCompMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
}
