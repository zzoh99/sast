package com.hr.cpn.personalPay.perlAccChgApp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.code.CommonCodeService;
/**
 * 메뉴명 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PerlAccChgApp.do", method=RequestMethod.POST )
public class PerlAccChgAppController {
	/**
	 * 메뉴명 서비스
	 */
	@Inject
	@Named("PerlAccChgAppService")
	private PerlAccChgAppService perlAccChgAppService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;


	/**
	 * 메뉴명 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerlAccChgApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerlAccChgApp() throws Exception {
		return "cpn/personalPay/perlAccChgApp/perlAccChgApp";
	}
	/**
	 * 메뉴명 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerlAccChgApp2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerlAccChgApp2() throws Exception {
		return "perlAccChgApp/perlAccChgApp";
	}

	/**
	 * 계좌번경신청 상세 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerlAccChgAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerlAccChgAppDet() throws Exception {
		return "cpn/personalPay/perlAccChgApp/perlAccChgAppDet";
	}

	/**
	 * 메뉴명 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerlAccChgAppList", method = RequestMethod.POST )
	public ModelAndView getPerlAccChgAppList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String Message = "";
		try{
			list = perlAccChgAppService.getPerlAccChgAppList(paramMap);
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
	 * 메뉴명 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePerlAccChgApp", method = RequestMethod.POST )
	public ModelAndView savePerlAccChgApp(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =perlAccChgAppService.savePerlAccChgApp(convertMap);
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
	 * 현재 유효한 급여계좌 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerlAccChgAppDetCurrAccountList", method = RequestMethod.POST )
	public ModelAndView getPerlAccChgAppDetCurrAccountList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		try {
			List<Map<String, Object>> list = (List<Map<String, Object>>) perlAccChgAppService.getPerlAccChgAppDetCurrAccountList(paramMap);
			mv.addObject("list", list);
			mv.addObject("msg", "");
		} catch(Exception e) {
			Log.Error(" ** 현재 계좌정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("list", new ArrayList<Map<String, Object>>());
			mv.addObject("msg", "조회에 실패하였습니다.");
		}
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 메뉴명 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePerlAccChgAppDet", method = RequestMethod.POST )
	public ModelAndView savePerlAccChgAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap,
			@RequestBody Map<String, Object> body ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.putAll(body);

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = perlAccChgAppService.savePerlAccChgAppDet(paramMap);
			if(resultCnt > 0) { message="저장 되었습니다."; } else { message="저장된 내용이 없습니다."; }
		} catch(Exception e) {
			Log.Error(" ** 급여계좌신청/취소신청 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			message = "저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}


}
