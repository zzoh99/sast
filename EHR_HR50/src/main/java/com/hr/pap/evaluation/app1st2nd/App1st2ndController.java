package com.hr.pap.evaluation.app1st2nd;

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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 1차/2차 평가 Controller
 *
 * @author jcy
 *
 */
@Controller
@RequestMapping({"EvaMain.do", "/App1st2nd.do"})
public class App1st2ndController extends ComController {
	/**
	 * 1차/2차 평가 서비스
	 */
	@Inject
	@Named("App1st2ndService")
	private App1st2ndService app1st2ndService;

	/**
	 * 1차/2차 평가 View(PopUp Kpi 상세 화면 로드)
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewApp1st2ndPopKpiDetail", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewApp1st2ndPopKpiDetail() throws Exception {
		return "pap/evaluation/app1st2nd/app1st2ndPopKpiDetail";
	}

	/**
	 * 1차/2차 평가 View(PopUp 인사정보 로드)
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewApp1st2ndPopPsnalBasic", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewApp1st2ndPopPsnalBasic() throws Exception {
		return "pap/evaluation/app1st2nd/app1st2ndPopPsnalBasic";
	}

	/**
	 * 1차/2차 평가 다건 조회(팝업 업적평가 조회)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApp1st2ndPopKpiList", method = RequestMethod.POST )
	public ModelAndView getApp1st2ndPopKpiList(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		try {
			list = app1st2ndService.getApp1st2ndPopKpiList(paramMap);
		} catch (Exception e) {
			Message = "조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 1차/2차 평가 단건 조회(팝업 업적평가 조회)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApp1st2ndPopKpiMap", method = RequestMethod.POST )
	public ModelAndView getApp1st2ndPopKpiMap(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<?, ?> map = app1st2ndService.getApp1st2ndPopKpiMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 1차/2차 평가 다건 조회(팝업 역량평가 조회)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApp1st2ndPopCompetencyList", method = RequestMethod.POST )
	public ModelAndView getApp1st2ndPopCompetencyList(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		try {
			list = app1st2ndService.getApp1st2ndPopCompetencyList(paramMap);
		} catch (Exception e) {
			Message = "조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 1차/2차 평가 단건 조회(팝업 역량평가 조회)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApp1st2ndPopCompetencyMap", method = RequestMethod.POST )
	public ModelAndView getApp1st2ndPopCompetencyMap(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<?, ?> map = app1st2ndService.getApp1st2ndPopCompetencyMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 1차/2차 평가 저장(팝업 업적평가 저장)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveApp1st2ndPopKpi", method = RequestMethod.POST )
	public ModelAndView saveApp1st2ndPopKpi(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,
				paramMap.get("s_SAVENAME").toString(), "");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = app1st2ndService.saveApp1st2ndPopKpi(convertMap);
			if (resultCnt > 0) {
				message = "저장되었습니다.";
			} else {
				message = "저장된 내용이 없습니다.";
			}
		} catch (Exception e) {
			resultCnt = -1;
			message = "저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 1차/2차 평가 저장(팝업 업적평가 본인의견 저장)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveApp1st2ndPopKpi350", method = RequestMethod.POST )
	public ModelAndView saveApp1st2ndPopKpi350(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = app1st2ndService.saveApp1st2ndPopKpi350(paramMap);
			if (resultCnt > 0) {
				message = "저장되었습니다.";
			} else {
				message = "저장된 내용이 없습니다.";
			}
		} catch (Exception e) {
			resultCnt = -1;
			message = "저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 1차/2차 평가 저장(팝업 역량평가 저장)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveApp1st2ndPopCompetency", method = RequestMethod.POST )
	public ModelAndView saveApp1st2ndPopCompetency(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,
				paramMap.get("s_SAVENAME").toString(), "");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = app1st2ndService.saveApp1st2ndPopCompetency(convertMap);
			if (resultCnt > 0) {
				message = "저장되었습니다.";
			} else {
				message = "저장된 내용이 없습니다.";
			}
		} catch (Exception e) {
			resultCnt = -1;
			message = "저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 1차/2차 평가 저장(팝업 역량평가 저장)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveApp1st2ndClassCd350", method = RequestMethod.POST )
	public ModelAndView saveApp1st2ndClassCd350(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,
				paramMap.get("s_SAVENAME").toString(), "");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = app1st2ndService.saveApp1st2ndClassCd350(convertMap);
			if (resultCnt > 0) {
				message = "저장되었습니다.";
			} else {
				message = "저장된 내용이 없습니다.";
			}
		} catch (Exception e) {
			resultCnt = -1;
			message = "저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 1차/2차 평가 저장(팝업 역량평가 본인의견 저장)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveApp1st2ndPopCompetency350", method = RequestMethod.POST )
	public ModelAndView saveApp1st2ndPopCompetency350(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = app1st2ndService.saveApp1st2ndPopCompetency350(paramMap);
			if (resultCnt > 0) {
				message = "저장되었습니다.";
			} else {
				message = "저장된 내용이 없습니다.";
			}
		} catch (Exception e) {
			resultCnt = -1;
			message = "저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 1차/2차 평가 저장 - (팝업 업적평가 저장)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcApp1st2ndPopKpi", method = RequestMethod.POST )
	public ModelAndView prcApp1st2ndPopKpi(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map map = app1st2ndService.prcApp1st2ndPopKpi(paramMap);
		
		Map<String, Object> resultMap = new HashMap<>();
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


		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 1차 평균점수 조회(팝업 업적평가 조회)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApp1st2ndPointInfoMap", method = RequestMethod.POST )
	public ModelAndView getApp1st2ndPointInfoMap(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<?, ?> map = app1st2ndService.getApp1st2ndPointInfoMap(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 1차2차 평가 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApp1st2ndList1", method = RequestMethod.POST )
	public ModelAndView getApp1st2ndList1(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 1차 일괄승인 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcApp1stAppAll", method = RequestMethod.POST )
	public ModelAndView prcApp1stAppAll(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return execPrc(session, request, paramMap);
	}
}
