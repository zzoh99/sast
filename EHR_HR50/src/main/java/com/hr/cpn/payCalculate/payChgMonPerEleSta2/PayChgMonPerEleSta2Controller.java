package com.hr.cpn.payCalculate.payChgMonPerEleSta2;
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
import com.nhncorp.lucy.security.xss.XssPreventer;

/**
 * 급여변동내역(개인별-항목별) Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/PayChgMonPerEleSta2.do", method=RequestMethod.POST )
public class PayChgMonPerEleSta2Controller {

	/**
	 * 급여변동내역(개인별-항목별) 서비스
	 */
	@Inject
	@Named("PayChgMonPerEleSta2Service")
	private PayChgMonPerEleSta2Service payChgMonPerEleSta2Service;

	/**
	 * 급여변동내역(개인별-항목별) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayChgMonPerEleSta2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayChgMonPerEleSta2() throws Exception {
		return "cpn/payCalculate/payChgMonPerEleSta2/payChgMonPerEleSta2";
	}

	/**
	 * 급여변동내역(개인별-항목별) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayChgMonPerEleMltSta2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayChgMonPerEleMltSta2() throws Exception {
		return "cpn/payCalculate/payChgMonPerEleSta2/payChgMonPerEleMltSta2";
	}
	
	/**
	 * 급여변동내역(개인별-항목별) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayChgMonPerEleSta2List", method = RequestMethod.POST )
	public ModelAndView getPayChgMonPerEleSta2List(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<>();
		String Message = "";

		try {
			List<Map<String, String>> titleList = payChgMonPerEleSta2Service.getPayChgMonPerEleSta2TitleList(paramMap);

			List<Map<String, String>> titles = new ArrayList<>();
			for (Map<String, String> map : titleList) {
				Map<String, String> mapElement = new HashMap<>();
				mapElement.put("elementCd", map.get("elementCd").toString());
				mapElement.put("elementNm", map.get("elementNm").toString());
				titles.add(mapElement);
			}
			paramMap.put("titles", titles);
			paramMap.put("B", "B");
			paramMap.put("C", "C");
			list = payChgMonPerEleSta2Service.getPayChgMonPerEleSta2List(paramMap);
		} catch(Exception e) {
			Message = "조회에 실패하였습니다.";
			Log.Error(Message + " => " + e.getLocalizedMessage());
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	
	@RequestMapping(params="cmd=getPayChgMonPerEleSta2TitleList", method = RequestMethod.POST )
	public ModelAndView getPayChgMonPerEleSta2TitleList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = payChgMonPerEleSta2Service.getPayChgMonPerEleSta2TitleList(paramMap);
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
	
	@RequestMapping(params="cmd=getPayChgMonPerEleMltSta2List", method = RequestMethod.POST )
	public ModelAndView getPayChgMonPerEleMltSta2List(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try {
			List<Map<String, String>> titleList = payChgMonPerEleSta2Service.getPayChgMonPerEleSta2TitleList(paramMap);

			List<Map<String, String>> titles = new ArrayList<>();
			for (Map<String, String> map : titleList) {
				HashMap<String, String> mapElement = new HashMap<>();
				mapElement.put("elementCd", map.get("elementCd").toString());
				mapElement.put("elementNm", map.get("elementNm").toString());
				titles.add(mapElement);
			}
			paramMap.put("titles", titles);
			paramMap.put("B", "B");
			paramMap.put("C", "C");
			list = payChgMonPerEleSta2Service.getPayChgMonPerEleMltSta2List(paramMap);
		} catch(Exception e) {
			Message = "조회에 실패하였습니다.";
			Log.Error(Message + " => " + e.getLocalizedMessage());
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}	
}
