package com.hr.org.organization.hrmEmpManageSta;
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
 * 사원구분별 인원현황 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/HrmEmpManageSta.do", method=RequestMethod.POST )
public class HrmEmpManageStaController {

	/**
	 * 사원구분별 인원현황 서비스
	 */
	@Inject
	@Named("HrmEmpManageStaService")
	private HrmEmpManageStaService hrmEmpManageStaService;

	/**
	 * viewHrmEmpHQSta View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHrmEmpManageSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHrmEmpManageStaList() throws Exception {
		return "org/organization/hrmEmpManageSta/hrmEmpManageSta";
	}

	/**
	 * 사원구분별 인원현황 Title 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHrmEmpManageStaTitleList", method = RequestMethod.POST )
	public ModelAndView getHrmEmpManageStaTitleList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("searchDate", paramMap.get("searchDate").toString().replaceAll("-", ""));
		
		List<?> list = new ArrayList<Object>();
		String Message = "";

		try {
			list = hrmEmpManageStaService.getHrmEmpManageStaTitleList(paramMap);
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
	 * 사원구분별 인원현황 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHrmEmpManageStaList", method = RequestMethod.POST )
	public ModelAndView getHrmEmpManageStaList(
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
			// 사원구분별 인원현황 Title 다건 조회
			titleList = hrmEmpManageStaService.getHrmEmpManageStaTitleList(paramMap);

			for(int i = 0 ; i < titleList.size() ; i++) {
				mapElement = new HashMap<String, String>();
				Map<String, String> map = (Map)titleList.get(i);
				mapElement.put("baseYmd"    , map.get("baseYmd").toString());
				mapElement.put("elementName", map.get("elementName").toString());
				titles.add(mapElement);
				paramMap.put("titles", titles);
			}

			list = hrmEmpManageStaService.getHrmEmpManageStaList(paramMap);
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
