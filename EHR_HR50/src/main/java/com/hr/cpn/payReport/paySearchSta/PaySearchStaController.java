package com.hr.cpn.payReport.paySearchSta;
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

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.logger.Log;

/**
 * 급/상여대장검색(개인별) Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/PaySearchSta.do", method=RequestMethod.POST )
public class PaySearchStaController {

	/**
	 * 급/상여대장검색(개인별) 서비스
	 */
	@Inject
	@Named("PaySearchStaService")
	private PaySearchStaService paySearchStaService;

	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;	

	
	/**
	 * 급/상여대장검색(개인별) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPaySearchSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPaySearchSta() throws Exception {
		return "cpn/payReport/paySearchSta/paySearchSta";
	}

	/**
	 * 급/상여대장검색(개인별) 급여구분별 항목리스트 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPaySearchStaTitleList", method = RequestMethod.POST )
	public ModelAndView getPaySearchStaTitleList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = paySearchStaService.getPaySearchStaTitleList(paramMap);
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
	 * 급/상여대장검색(개인별) 급여구분별 항목리스트 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=getPaySearchStaList", method = RequestMethod.POST )
	public ModelAndView getPaySearchStaList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ssnSearchType", 	session.getAttribute("ssnSearchType"));

		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> titles = new ArrayList<Serializable>();
		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			// 급/상여대장검색(개인별) 급여구분별 항목리스트 다건 조회
			titleList = paySearchStaService.getPaySearchStaTitleList(paramMap);

			for(int i = 0 ; i < titleList.size() ; i++){
				mapElement = new HashMap<String, String>();
				Map<String, String> map = (Map<String, String>) titleList.get(i);
				mapElement.put("elementCd", map.get("elementCd").toString());
				mapElement.put("elementNm", map.get("elementNm").toString());
				titles.add(mapElement);
				paramMap.put("titles", titles);
			}
			Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
			if(query != null) {
				Log.Debug("query.get=> "+ query.get("query"));
				paramMap.put("query",query.get("query"));
			}
			
			list = paySearchStaService.getPaySearchStaList(paramMap);
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
	 * 급/상여대장검색(개인별) 급여구분 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPaySearchStaCpnPayCdList", method = RequestMethod.POST )
	public ModelAndView getPaySearchStaCpnPayCdList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = paySearchStaService.getPaySearchStaCpnPayCdList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}
}