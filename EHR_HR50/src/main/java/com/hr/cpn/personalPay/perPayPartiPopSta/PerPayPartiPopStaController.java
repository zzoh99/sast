package com.hr.cpn.personalPay.perPayPartiPopSta;
import java.util.ArrayList;
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
 * 급여명세서 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping({"/PerPayPartiPopSta.do", "/PerPayPartiAdminSta.do", "/PerPayPartiUserSta.do"})
public class PerPayPartiPopStaController {

	/**
	 * 급여명세서 서비스
	 */
	@Inject
	@Named("PerPayPartiPopStaService")
	private PerPayPartiPopStaService perPayPartiPopStaService;

	/**
	 * 급여명세서 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayPartiPopSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiPopSta(@RequestParam Map<String, Object> paramMap) throws Exception {
		return "cpn/personalPay/perPayPartiPopSta/perPayPartiPopSta";
	}
	@RequestMapping(params="cmd=viewPerPayPartiLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiLayer(@RequestParam Map<String, Object> paramMap) throws Exception {
		return "cpn/personalPay/perPayPartiPopSta/perPayPartiLayer";
	}
	
	/**
	 * 급여명세서  조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayPartiPopSta", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiPopSta(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;
		List<?> list1 = new ArrayList<Object>();
		List<?> list2 = new ArrayList<Object>();
		List<?> list3 = new ArrayList<Object>();

		try{
			// 급여명세서 기본정보 단건 조회
			map = perPayPartiPopStaService.getPerPayPartiPopStaBasicMap(paramMap);

			// 급여명세서 지급내역 다건 조회
			paramMap.put("elementType","A"); // 항목구분(A.지급 D.공제)
			list1 = perPayPartiPopStaService.getPerPayPartiPopStaCalcList(paramMap);

			// 급여명세서 공제내역 다건 조회
			paramMap.put("elementType","D"); // 항목구분(A.지급 D.공제)
			list2 = perPayPartiPopStaService.getPerPayPartiPopStaCalcList(paramMap);

			// 급여명세서 과표내역 다건 조회
			list3 = perPayPartiPopStaService.getPerPayPartiPopStaCalcTaxList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map",map);
		mv.addObject("DATA1", list1);
		mv.addObject("DATA2", list2);
		mv.addObject("DATA3", list3);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}