package com.hr.common.popup.payAllowanceElementPropertyPopup;

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
 * 공통 팝업
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/PayAllowanceElementPropertyPopup.do", method=RequestMethod.POST )
public class PayAllowanceElementPropertyPopupController {

	@Inject
	@Named("PayAllowanceElementPropertyPopupService")
	private PayAllowanceElementPropertyPopupService payAllowanceElementPropertyPopupService;
	
	/**
	 * 항목그룹
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=payAllowanceElementPropertyPopup", method = RequestMethod.POST )
	public String payAllowanceElementPropertyPopup() throws Exception {
		return "common/popup/payAllowanceElementPropertyPopup";
	}
	@RequestMapping(params="cmd=viewPayAllowanceElementPropertyLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String payAllowanceElementPropertyLayer() throws Exception {
		return "common/popup/payAllowanceElementPropertyLayer";
	}
	
	/**
	 * 항목그룹1
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayAllowanceElementPropertyPopupListFirst", method = RequestMethod.POST )
	public ModelAndView getPayAllowanceElementPropertyPopupListFirst(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		try{
			list = payAllowanceElementPropertyPopupService.getPayAllowanceElementPropertyPopupListFirst(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 항목그룹2
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayAllowanceElementPropertyPopupListSecond", method = RequestMethod.POST )
	public ModelAndView getPayAllowanceElementPropertyPopupListSecond(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		try{
			list = payAllowanceElementPropertyPopupService.getPayAllowanceElementPropertyPopupListSecond(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		// 변경전 임시
		HashMap<String, String> converMap = null;
		converMap = (HashMap)list.get(0);
		
	    // 변경후 완성된
	    List<HashMap> createList = new ArrayList<HashMap>();

		// 수습적용율
	    HashMap<String, String> createMap2 = new HashMap<String, String>();
	    createMap2.put("elementCd", converMap.get("elementCd").toString());
	    createMap2.put("elementSetNm", "수습적용율");
	    createMap2.put("attribute", converMap.get("attribute2").toString());
	    createList.add(createMap2);

	    // 과세여부
	    HashMap<String, String> createMap3 = new HashMap<String, String>();
	    createMap3.put("elementCd", converMap.get("elementCd").toString());
	    createMap3.put("elementSetNm", "과세여부");
	    createMap3.put("attribute", converMap.get("attribute3").toString());
	    createList.add(createMap3);
	    
		// 신입/복직일할계산
	    HashMap<String, String> createMap4 = new HashMap<String, String>();
	    createMap4.put("elementCd", converMap.get("elementCd").toString());
	    createMap4.put("elementSetNm", "신입/복직일할계산");
	    createMap4.put("attribute", converMap.get("attribute4").toString());
	    createList.add(createMap4);

		// 퇴직당월일할계산
	    HashMap<String, String> createMap5 = new HashMap<String, String>();
	    createMap5.put("elementCd", converMap.get("elementCd").toString());
	    createMap5.put("elementSetNm", "퇴직당월일할계산");
	    createMap5.put("attribute", converMap.get("attribute5").toString());
	    createList.add(createMap5);
	    
		// 발령관련일할계산
	    HashMap<String, String> createMap6 = new HashMap<String, String>();
	    createMap6.put("elementCd", converMap.get("elementCd").toString());
	    createMap6.put("elementSetNm", "발령관련일할계산");
	    createMap6.put("attribute", converMap.get("attribute6").toString());
	    createList.add(createMap6);
	    
		// 징계관련일할계산
	    HashMap<String, String> createMap7 = new HashMap<String, String>();
	    createMap7.put("elementCd", converMap.get("elementCd").toString());
	    createMap7.put("elementSetNm", "징계관련일할계산");
	    createMap7.put("attribute", converMap.get("attribute7").toString());
	    createList.add(createMap7);
	    
		// 근태관련일할계산
	    HashMap<String, String> createMap9 = new HashMap<String, String>();
	    createMap9.put("elementCd", converMap.get("elementCd").toString());
	    createMap9.put("elementSetNm", "근태관련일할계산");
	    createMap9.put("attribute", converMap.get("attribute9").toString());
	    createList.add(createMap9);
	    
	    // 산재관련일할계산
	    HashMap<String, String> createMap11 = new HashMap<String, String>();
	    createMap11.put("elementCd", converMap.get("elementCd").toString());
	    createMap11.put("elementSetNm", "산재관련일할계산");
	    createMap11.put("attribute", converMap.get("attribute11").toString());
	    createList.add(createMap11);
	    
		// 연말정산필드
	    HashMap<String, String> createMap8 = new HashMap<String, String>();
	    createMap8.put("elementCd", converMap.get("elementCd").toString());
	    createMap8.put("elementSetNm", "연말정산필드");
	    createMap8.put("attribute", converMap.get("attribute8").toString());
	    createMap8.put("attributeNm", converMap.get("attribute8Nm").toString());
	    createList.add(createMap8);
	    
		// 상여관련
	    HashMap<String, String> createMap10 = new HashMap<String, String>();
	    createMap10.put("elementCd", converMap.get("elementCd").toString());
	    createMap10.put("elementSetNm", "상여관련");
	    createMap10.put("attribute", converMap.get("attribute10").toString());
	    createList.add(createMap10);
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", createList);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 항목그룹3
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayAllowanceElementPropertyPopupListThird", method = RequestMethod.POST )
	public ModelAndView getPayAllowanceElementPropertyPopupListThird(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		try{
			list = payAllowanceElementPropertyPopupService.getPayAllowanceElementPropertyPopupListThird(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}