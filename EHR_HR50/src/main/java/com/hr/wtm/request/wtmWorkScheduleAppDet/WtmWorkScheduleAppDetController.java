package com.hr.wtm.request.wtmWorkScheduleAppDet;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 근무스케쥴신청 Controller
 */
@Controller
@RequestMapping({"/WtmWorkScheduleApp.do","/WtmWorkScheduleAppDet.do"})
public class WtmWorkScheduleAppDetController extends ComController {
	/**
	 * 부서근무스케쥴신청 서비스
	 */
	@Inject
	@Named("WtmWorkScheduleAppDetService")
	private WtmWorkScheduleAppDetService wtmWorkScheduleAppDetService;


    @RequestMapping(params="cmd=viewWtmWorkScheduleAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewWtmWorkScheduleAppDet() throws Exception {
        return "wtm/request/wtmWorkScheduleAppDet/wtmWorkScheduleAppDet";
    }

	/**
	 * 근무스케쥴 신청 헤더 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkScheduleAppDetHeaderList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkScheduleAppDetHeaderList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmWorkScheduleAppDetService.getWtmWorkScheduleAppDetHeaderList(paramMap);
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
	 * 근무스케쥴 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkScheduleAppDet", method = RequestMethod.POST )
	public ModelAndView getWtmWorkScheduleAppDet(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = wtmWorkScheduleAppDetService.getWtmWorkScheduleAppDet(paramMap);
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
	 * 근무스케줄 신청 상세 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkScheduleAppDetDetailList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkScheduleAppDetDetailList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmWorkScheduleAppDetService.getWtmWorkScheduleAppDetDetailList(paramMap);
		} catch(Exception e){
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
	 * 근무스케줄 기 신청 건 체크
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkScheduleAppDetDupCnt", method = RequestMethod.POST )
	public ModelAndView getWtmWorkScheduleAppDetDupCnt(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> pMap 		= request.getParameterMap();
		List<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
		String[] sabuns = (String[]) pMap.get("sabun");
		for( int i=0; i<sabuns.length; i++){
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("sabun", sabuns[i]);
			list.add(map);
		}

		paramMap.put("sabuns", list);


		Map<?, ?> map = null;
		String Message = "";

		try{
			map = wtmWorkScheduleAppDetService.getWtmWorkScheduleAppDetDupCnt(paramMap);
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
	 * 부서콤보 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkScheduleAppDetOrgList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkScheduleAppDetOrgList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	/**
	 * 근무조 조회 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkScheduleAppDetWorkOrg", method = RequestMethod.POST )
	public ModelAndView getWtmWorkScheduleAppDetWorkOrg(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 근무한도 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkScheduleAppDetLimit", method = RequestMethod.POST )
	public ModelAndView getWtmWorkScheduleAppDetLimit(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 부서근무스케쥴신청 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmWorkScheduleAppDet", method = RequestMethod.POST )
	public ModelAndView saveWtmWorkScheduleAppDet(
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

			Map<?, ?> pMap 		= request.getParameterMap();
			List<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
			String[] sabuns = (String[]) pMap.get("sabun");
			for( int i=0; i<sabuns.length; i++){
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("sabun", sabuns[i]);
				list.add(map);
			}
			convertMap.put("sabuns", list);
			
			resultCnt = wtmWorkScheduleAppDetService.saveWtmWorkScheduleAppDet(convertMap);
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

}
