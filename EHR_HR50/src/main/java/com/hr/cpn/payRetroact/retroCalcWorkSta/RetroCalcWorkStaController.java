package com.hr.cpn.payRetroact.retroCalcWorkSta;
import java.io.Serializable;
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
 * 소급작업결과조회 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/RetroCalcWorkSta.do", method=RequestMethod.POST )
public class RetroCalcWorkStaController {

	/**
	 * 소급작업결과조회 서비스
	 */
	@Inject
	@Named("RetroCalcWorkStaService")
	private RetroCalcWorkStaService retroCalcWorkStaService;

	/**
	 * 소급작업결과조회 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetroCalcWorkSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetroCalcWorkSta() throws Exception {
		return "cpn/payRetroact/retroCalcWorkSta/retroCalcWorkSta";
	}

	/**
	 * 소급작업결과조회 급여구분별 항목리스트 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetroCalcWorkStaTitleList", method = RequestMethod.POST )
	public ModelAndView getRetroCalcWorkStaTitleList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = retroCalcWorkStaService.getRetroCalcWorkStaTitleList(paramMap);
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
	 * 소급작업결과조회 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetroCalcWorkStaList", method = RequestMethod.POST )
	public ModelAndView getRetroCalcWorkStaList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> titles = new ArrayList<Serializable>();
		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			// 소급작업결과조회 급여구분별 항목리스트 조회
			titleList = retroCalcWorkStaService.getRetroCalcWorkStaTitleList(paramMap);

			for(int i = 0 ; i < titleList.size() ; i++){
				mapElement = new HashMap<String, String>();
				Map<String, String> map = (Map)titleList.get(i);
				mapElement.put("elementCd", map.get("elementCd").toString());
				mapElement.put("gapElementCd", map.get("gapElementCd").toString());
				titles.add(mapElement);
			}
			paramMap.put("titles", titles);

			list = retroCalcWorkStaService.getRetroCalcWorkStaList(paramMap);
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
}