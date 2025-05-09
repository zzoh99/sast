package com.hr.hrm.other.hrmSta;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 현황/검색  Controller
 *
 * @author jcy
 *
 */
@Controller
@RequestMapping(value="/HrmSta.do", method=RequestMethod.POST )
public class HrmStaController {
	/**
	 * 현황/검색  서비스
	 */
	@Inject
	@Named("HrmStaService")
	private HrmStaService hrmStaService;
	/**
	 * 현황/검색  View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHrmSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHrmSta() throws Exception {
		return "hrm/other/hrmSta/hrmSta";
	}
	/**
	 * 현황/검색  View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHrmSta2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHrmSta2() throws Exception {
		return "hrmSta/hrmSta";
	}
	
	/**
	 * 현황/검색 팝업  View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHrmStaPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHrmStaPopup() throws Exception {
		return "hrm/other/hrmSta/hrmStaPopup";
	}

	@RequestMapping(params="cmd=viewHrmStaLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHrmStaLayer() throws Exception {
		return "hrm/other/hrmSta/hrmStaLayer";
	}

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;


	/**
	 * 현황/검색  다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHrmStaList", method = RequestMethod.POST )
	public ModelAndView getHrmStaList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();

		HashMap<String, String> mapElement = null;
		
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> titles = new ArrayList<Serializable>();

		String Message = "";
		try{

			// 검색 조건에 따라 헤더 정보 가져옴
			String schType = (String)paramMap.get("schType");
			String grpCd = (String)paramMap.get("grpCd");
			String useYn = (String)paramMap.get("useYn");
			
			paramMap.put("grpCd", grpCd);
			paramMap.put("useYn", useYn);
			
			titleList = hrmStaService.getHrmStaTitleList(paramMap);
		
			for(int i = 0 ; i < titleList.size() ; i++){
				mapElement = new HashMap<String, String>();
				Map<String, String> map = (Map)titleList.get(i);
				mapElement.put("code", map.get("code").toString());
				titles.add(mapElement);
				paramMap.put("titles", titles);
			}
			
			//Log.Debug("2>>>>> " + paramMap.toString());
			list = hrmStaService.getHrmStaList(paramMap);

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
	 * 현황/검색 팝업 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHrmStaPopupList", method = RequestMethod.POST )
	public ModelAndView getHrmStaPopupList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();

		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> titles = new ArrayList<Serializable>();

		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));
		try{
			list = hrmStaService.getHrmStaPopupList(paramMap);
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
