package com.hr.sys.psnalInfoPop;
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
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.ParamUtils;

/**
 * 인사기본 팝업 Controller
 *
 * @author isu system
 *
 */
@Controller
@RequestMapping(value="/PsnalInfoPop.do", method=RequestMethod.POST )
public class PsnalInfoPopController {

	/**
	 * 인사기본 팝업 서비스
	 */
	@Inject
	@Named("PsnalInfoPopService")
	private PsnalInfoPopService PsnalInfoPopService;

	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;


	/**
	 * 인사기본 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalInfoPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalAssurancePop() throws Exception {
		return "sys/psnalInfoPop/psnalInfoPop";
	}

	/**
	 * 인사기본 공통 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalInfoPopCommonCodeList", method = RequestMethod.POST )
	public ModelAndView getPsnalInfoPopCommonCode(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> result = PsnalInfoPopService.getPsnalInfoPopCommonCodeList(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본 공통 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalInfoPopCommonNSCodeList", method = RequestMethod.POST )
	public ModelAndView getPsnalInfoPopCommonNSCodeList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> result = PsnalInfoPopService.getPsnalInfoPopCommonNSCodeList(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 사원검색 상세
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalInfoPopEmployeeDetail", method = RequestMethod.POST )
	public ModelAndView baseEmployeeDetail(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		// 서비스 호출
		Map<?, ?> map = PsnalInfoPopService.getPsnalInfoPopEmployeeDetail(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map",map);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 공통탭 정보 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalInfoPopTabInfoList", method = RequestMethod.POST )
	public ModelAndView getPsnalInfoPopTabInfoList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		Map<String, Object> urlParam = new HashMap<String, Object>();
		String surl =paramMap.get("surl").toString();
		String skey = session.getAttribute("ssnEncodedKey").toString();

		String subGrpCd = null;
		String subGrpNm = null;
		urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( surl, skey  );

		paramMap.put("mainMenuCd", 	urlParam.get("mainMenuCd"));
		paramMap.put("menuCd", 	urlParam.get("priorMenuCd"));




		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = PsnalInfoPopService.getPsnalInfoPopTabInfoList(paramMap);
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
