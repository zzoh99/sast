package com.hr.hrm.other.hrQueryAppDet;
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
 * HR문의요청 신청팝업 Controller
 *
 * @author jcy
 *
 */
@Controller
@RequestMapping({"/HrQueryAppDet.do", "/HrQueryApp.do"})
public class HrQueryAppDetController {
	/**
	 * HR문의요청 신청팝업 서비스
	 */
	@Inject
	@Named("HrQueryAppDetService")
	private HrQueryAppDetService hrQueryAppDetService;
	/**
	 * HR문의요청 신청팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHrQueryAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHrQueryAppDet() throws Exception {
		return "hrm/other/hrQueryAppDet/hrQueryAppDet";
	}
	/**
	 * HR문의요청 신청팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHrQueryAppDet2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHrQueryAppDet2() throws Exception {
		return "hrQueryAppDet/hrQueryAppDet";
	}
	/**
	 * HR문의요청 신청팝업 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHrQueryAppDetList", method = RequestMethod.POST )
	public ModelAndView getHrQueryAppDetList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = hrQueryAppDetService.getHrQueryAppDetList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * HR문의요청 신청팝업 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHrQueryAppDetMap", method = RequestMethod.POST )
	public ModelAndView getHrQueryAppDetMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = hrQueryAppDetService.getHrQueryAppDetMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * HR문의요청 신청팝업 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveHrQueryAppDet", method = RequestMethod.POST )
	public ModelAndView saveHrQueryAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		String message = "";
		int resultCnt = -1;
		try{

			paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
			resultCnt =hrQueryAppDetService.saveHrQueryAppDet(paramMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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

}
