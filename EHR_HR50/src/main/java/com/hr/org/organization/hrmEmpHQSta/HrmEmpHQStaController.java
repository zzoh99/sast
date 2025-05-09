package com.hr.org.organization.hrmEmpHQSta;
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
 * 본부별 인원현황 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/HrmEmpHQSta.do", method=RequestMethod.POST )
public class HrmEmpHQStaController {

	/**
	 * 본부별 인원현황 서비스
	 */
	@Inject
	@Named("HrmEmpHQStaService")
	private HrmEmpHQStaService hrmEmpHQStaService;

	/**
	 * viewHrmEmpHQSta View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHrmEmpHQSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHrmEmpHQStaList() throws Exception {
		return "org/organization/hrmEmpHQSta/hrmEmpHQSta";
	}

	/**
	 * 본부별 인원현황 Title 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHrmEmpHQStaTitleList", method = RequestMethod.POST )
	public ModelAndView getHrmEmpHQStaTitleList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("searchDate", paramMap.get("searchDate").toString().replaceAll("-", ""));
		
		List<?> list = new ArrayList<Object>();
		String Message = "";

		try {
			list = hrmEmpHQStaService.getHrmEmpHQStaTitleList(paramMap);
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
	 * 본부별 인원현황 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHrmEmpHQStaList", method = RequestMethod.POST )
	public ModelAndView getHrmEmpHQStaList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("searchDate", paramMap.get("searchDate").toString().replaceAll("-", ""));
		
		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> titles = new ArrayList<Serializable>();
		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			// 본부별 인원현황 Title 다건 조회
			titleList = hrmEmpHQStaService.getHrmEmpHQStaTitleList(paramMap);

			for(int i = 0 ; i < titleList.size() ; i++) {
				mapElement = new HashMap<String, String>();
				Map<String, String> map = (Map)titleList.get(i);
				mapElement.put("baseYmd"    , map.get("baseYmd").toString());
				mapElement.put("elementName", map.get("elementName").toString());
				titles.add(mapElement);
				paramMap.put("titles", titles);
			}

			list = hrmEmpHQStaService.getHrmEmpHQStaList(paramMap);
		} catch(Exception e) {
			Message="조회에 실패 하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		
		return mv;
	}
}
