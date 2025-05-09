package com.hr.hrm.psnalInfo.psnalOverStudy;
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
import com.hr.common.util.ParamUtils;

/**
 * 인사기본(해외연수) Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/PsnalOverStudy.do", method=RequestMethod.POST )
public class PsnalOverStudyController {
	/**
	 * 인사기본(해외연수) 서비스
	 */
	@Inject
	@Named("PsnalOverStudyService")
	private PsnalOverStudyService psnalOverStudyService;

	/**
	 * 인사기본(해외연수) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalOverStudy", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalOverStudy() throws Exception {
		return "hrm/psnalInfo/psnalOverStudy/psnalOverStudy";
	}

	@RequestMapping(params="cmd=viewPsnalOverStudyLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalOverStudyLayer() throws Exception {
		return "hrm/psnalInfo/psnalOverStudy/psnalOverStudyLayer";
	}

	/**
	 * 인사기본(해외연수)(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalOverStudyPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalOverStudyPop() throws Exception {
		return "hrm/psnalInfo/psnalOverStudy/psnalOverStudyPop";
	}

	/**
	 * 인사기본(해외연수) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalOverStudyList", method = RequestMethod.POST )
	public ModelAndView getPsnalOverStudyList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = psnalOverStudyService.getPsnalOverStudyList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 인사기본(해외연수) 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePsnalOverStudy", method = RequestMethod.POST )
	public ModelAndView savePsnalOverStudy(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =psnalOverStudyService.savePsnalOverStudy(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
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
	 * 인사기본(해외연수) 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalOverStudyMap", method = RequestMethod.POST )
	public ModelAndView getPsnalOverStudyMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = psnalOverStudyService.getPsnalOverStudyMap(paramMap);
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

	/**
	 * 인사기본(해외연수) 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=psnalOverStudyPrc", method = RequestMethod.POST )
	public ModelAndView psnalOverStudyPrc(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ssnSearchType",session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",session.getAttribute("ssnGrpCd"));

		Map<?, ?> map  = psnalOverStudyService.psnalOverStudyPrc(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlCode : "+map.get("sqlCode"));
			Log.Debug("sqlErrm : "+map.get("sqlErrm"));
			
			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}
}
