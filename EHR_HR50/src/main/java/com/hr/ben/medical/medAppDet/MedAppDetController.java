package com.hr.ben.medical.medAppDet;
import java.io.Serializable;
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


// 데이터 가공을 위한 Bean
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;

/**
 * 의료비신청 세부내역 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping({"/MedAppDet.do", "/MedApp.do"})
public class MedAppDetController extends ComController {

	/**
	 * 의료비신청 세부내역 서비스
	 */
	@Inject
	@Named("MedAppDetService")
	private MedAppDetService medAppDetService;

	/**
	 * 의료비신청 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMedAppDet",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMedAppDet() throws Exception {
		return "ben/medical/medAppDet/medAppDet";
	}
	
	/**
	 * 의료비신청 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMedAppDetPopup",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMedAppDetPopup() throws Exception {
		return "ben/medical/medAppDet/medAppDetPopup";
	}
	
    /**
     * 질병분류 코드 검색  Layer View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewMedAppDetLayer",method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewMedAppDetLayer() throws Exception {
        return "ben/medical/medAppDet/medAppDetLayer";
    }

	/**
	 * 신청자 대상자 콤보 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMedAppDetFamCdList", method = RequestMethod.POST )
	public ModelAndView getMedAppDetFamCdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 해당 질병 지원시작년월 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMedAppDetPayYm", method = RequestMethod.POST )
	public ModelAndView getMedAppDetPayYm(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 년간지원받은금액 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMedAppDetTotalPayMon", method = RequestMethod.POST )
	public ModelAndView getMedAppDetTotalPayMon(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 년간지원받을수있는금액 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMedAppDetFreelPayMon", method = RequestMethod.POST )
	public ModelAndView getMedAppDetFreelPayMon(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 의료비신청 담당자 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMedAppDetAdmin", method = RequestMethod.POST )
	public ModelAndView saveMedAppDetAdmin(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	/**
	 * 의료비신청 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMedAppDet", method = RequestMethod.POST )
	public ModelAndView saveMedAppDet(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	/**
	 * 신청자 재직상태 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMedAppDetUserStsCd", method = RequestMethod.POST )
	public ModelAndView getMedAppDetUserStsCd(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 신청정보 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMedAppDetMap", method = RequestMethod.POST )
	public ModelAndView getMedAppDetMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 전년도 연말정산 부양가족여부 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMedAppDetDpndntYn", method = RequestMethod.POST )
	public ModelAndView getMedAppDetDpndntYn(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
}
