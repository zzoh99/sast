package com.hr.ben.healthInsurance.healthInsMgr;
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
 * 건강보험기본사항 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/HealthInsMgr.do", method=RequestMethod.POST )
public class HealthInsMgrController {

	/**
	 * 건강보험기본사항 서비스
	 */
	@Inject
	@Named("HealthInsMgrService")
	private HealthInsMgrService healthInsMgrService;

	/**
	 * 건강보험기본사항 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHealthInsMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHealthInsMgr() throws Exception {
		return "ben/healthInsurance/healthInsMgr/healthInsMgr";
	}

	/**
	 * 건강보험기본사항 기본사항TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHealthInsMgrBasic", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHealthInsMgrBasic() throws Exception {
		return "ben/healthInsurance/healthInsMgr/healthInsMgrBasic";
	}

	/**
	 * 건강보험기본사항 변동내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHealthInsMgrChange", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHealthInsMgrChange() throws Exception {
		return "ben/healthInsurance/healthInsMgr/healthInsMgrChange";
	}

	/**
	 * 건강보험기본사항 기본사항/변동내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHealthInsMgrBasicChange", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHealthInsMgrBasicChange() throws Exception {
		return "ben/healthInsurance/healthInsMgr/healthInsMgrBasic";
	}

	/**
	 * 건강보험기본사항 불입내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHealthInsMgrPayment", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHealthInsMgrPayment() throws Exception {
		return "ben/healthInsurance/healthInsMgr/healthInsMgrPayment";
	}

	/**
	 * 건강보험기본사항 기본사항TAB 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHealthInsMgrBasicMap", method = RequestMethod.POST )
	public ModelAndView getHealthInsMgrBasicMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = healthInsMgrService.getHealthInsMgrBasicMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map",map);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 건강보험기본사항 변동내역TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHealthInsMgrChangeList", method = RequestMethod.POST )
	public ModelAndView getHealthInsMgrChangeList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = healthInsMgrService.getHealthInsMgrChangeList(paramMap);
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
	 * 건강보험기본사항 불입내역TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHealthInsMgrPaymentList", method = RequestMethod.POST )
	public ModelAndView getHealthInsMgrPaymentList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = healthInsMgrService.getHealthInsMgrPaymentList(paramMap);
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
	 * 건강보험기본사항 기본사항TAB 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveHealthInsMgrBasic", method = RequestMethod.POST )
	public ModelAndView saveHealthInsMgrBasic(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = healthInsMgrService.saveHealthInsMgrBasic(paramMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 건강보험기본사항 변동내역TAB 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveHealthInsMgrChange", method = RequestMethod.POST )
	public ModelAndView saveHealthInsMgrChange(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = healthInsMgrService.saveHealthInsMgrChange(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}
	/**
	 * 보험료 가져오기
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSelfMonLongTermCareMon", method = RequestMethod.POST )
	public ModelAndView getSelfMonLongTermCareMon(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;
		try{
			map = healthInsMgrService.getSelfMonLongTermCareMon(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map",map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 보험료 가져오기
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSelfMonLongTermCareF_CPN_GET_UPDOWN_MON", method = RequestMethod.POST )
	public ModelAndView getSelfMonLongTermCareF_CPN_GET_UPDOWN_MON(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;
		try{
			map = healthInsMgrService.getSelfMonLongTermCareF_CPN_GET_UPDOWN_MON(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map",map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}