package com.hr.common.popup.zipCodePopup;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

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
 * 공통 팝업
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/ZipCodePopup.do", method=RequestMethod.POST )
public class ZipCodePopupController {

	@Inject
	@Named("ZipCodePopupService")
	private ZipCodePopupService zipCodePopupService;

	@RequestMapping(params="cmd=viewZipCodePopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewZipCodePopup(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		paramMap.put("searchStdCd", "ZIPCODE_REF_YN");
		Map<?, ?> map = zipCodePopupService.getZipCodeRefYn(paramMap);
		
		/* 조회 방식에 따른 View 선택 */
		String zipcodeRefYn = "W";	// Y:자체DB, W:행자부API, D:검색불가
		if( map != null && map.containsKey("value") && map.get("value") != null ) {
			zipcodeRefYn = (String) map.get("value");
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/zipCodePopupType" + zipcodeRefYn);
		return mv;
	}
	
	@RequestMapping(params="cmd=viewZipCodeLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewZipCodeLayer(HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		param.put("searchStdCd", "ZIPCODE_REF_YN");
		Map<?, ?> map = zipCodePopupService.getZipCodeRefYn(param);
		
		/* 조회 방식에 따른 View 선택 */
		String zipcodeRefYn = "W";	// Y:자체DB, W:행자부API, D:검색불가
		if( map != null && map.containsKey("value") && map.get("value") != null ) {
			zipcodeRefYn = (String) map.get("value");
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/zipCodeLayerType" + zipcodeRefYn);
		return mv;
	}
	

	/**
	 * 우편번호 지번 리스트 조회
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getZipCodePopupBungiList", method = RequestMethod.POST )
	public ModelAndView getZipCodePopupBungiList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));

		List<?> result = zipCodePopupService.getZipCodePopupBungiList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA",result);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 우편번호 도로명 시도 코드 리스트 조회
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getZipCodePopupSidoCodeList", method = RequestMethod.POST )
	public ModelAndView getZipCodePopupSidoList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));

		List<?> result = zipCodePopupService.getZipCodePopupSidoCodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList",result);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 우편번호 도로명 구군 코드 리스트 조회
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getZipCodePopupGugunCodeList", method = RequestMethod.POST )
	public ModelAndView getZipCodePopupGugunCodeList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));

		List<?> result = zipCodePopupService.getZipCodePopupGugunCodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList",result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 우편번호 도로명 리스트 조회
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getZipCodePopupDoroList", method = RequestMethod.POST )
	public ModelAndView getZipCodePopupDoroList(
		HttpSession session,  HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<>();
		Map<?, ?> map  = new HashMap<>();
		String message = "";

		String searchWord	= paramMap.get("searchWord").toString().replaceAll("-"," ");
		StringTokenizer st = new StringTokenizer(searchWord);
		List<Serializable> sword = new ArrayList<Serializable>();
		StringBuffer query = new StringBuffer();

		while(st.hasMoreTokens()) {
			String tocken = st.nextToken();
			sword.add(tocken);
		}

		for( int i = 0 ; i < sword.size() ; i ++ ){
			query.append(" AND "
						+ "("
						+ " SIDO LIKE '"+sword.get(i)+"%'"
						+ " OR SIGUNGU LIKE '"+sword.get(i)+"%'"
						+ " OR UPMYON LIKE '"+sword.get(i)+"%'"
						+ " OR ROAD_NAME LIKE '"+sword.get(i)+"%'"
						+ " OR SIGUNGUBD_NAME LIKE '"+sword.get(i)+"%'"
						+ " OR BDNO_M LIKE '"+sword.get(i)+"%'"
						+ " OR BDNO_S LIKE '"+sword.get(i)+"%'"
						+ " OR LAW_DONG_NAME LIKE '"+sword.get(i)+"%'"
						+ " OR GOV_DONG_NAME  LIKE '"+sword.get(i)+"%'"
						+ " OR JIBUN_M LIKE '"+sword.get(i)+"%'"
						+ " OR JIBUN_S LIKE '"+sword.get(i)+"%'"
						+ " )");
		}

		paramMap.put("query", query.toString());

		try{
			// 서비스 호출
			map = zipCodePopupService.getZipCodePopupDoroListCnt(paramMap);
		}catch(Exception e){
			message="조회에 실패하였습니다.";
		}

		try{
			// 서비스 호출
			list = zipCodePopupService.getZipCodePopupDoroList(paramMap);
		}catch(Exception e){
			message="조회에 실패하였습니다.";
		}

		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		
		// 그리드에 맵핑 되는 데이터 이면 DATA에 담아서 보냄
		mv.addObject("TOTAL", map.get("cnt"));
		mv.addObject("Botal","");
		mv.addObject("Message", message);
		mv.addObject("DATA", list);
		
		// comment 종료
		Log.DebugEnd();
		return mv;
	}
}