package com.hr.ben.apply.benApplyUser;

import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.StringUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 복리후생신청 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/BenApplyUser.do", method=RequestMethod.POST )
public class BenApplyUserController {

	/**
	 * 복리후생신청 서비스
	 */
	@Inject
	@Named("BenApplyUserService")
	private BenApplyUserService benApplyUserService;

	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;

	/**
	 * 복리후생신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewBenApplyTypeUser", method = {RequestMethod.POST, RequestMethod.GET } )
	public String viewBenApplyTypeUser() throws Exception {
		return "ben/apply/benApplyTypeUser/benApplyTypeUser";
	}

	/**
	 * 복리후생신청 리스트 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewBenApplyListUser",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewBenApplyListUser() throws Exception {
		return "ben/apply/benApplyListUser/benApplyListUser";
	}

	/**
	 * 복리후생신청 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBenApplList", method = RequestMethod.POST )
	public ModelAndView getBenApplList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd", 	session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		try {
			mv.addObject("DATA", benApplyUserService.getBenApplList(paramMap));
			mv.addObject("msg", "");
		} catch(Exception e) {
			e.printStackTrace();
			Log.Error(" ** 임직원공통_인사신청서 리스트 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("map", new HashMap<>());
			mv.addObject("msg", "조회에 실패 하였습니다.");
		}
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=getBenAppCodeList", method = RequestMethod.POST )
	public ModelAndView getBenAppCodeList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd", 	session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		try {
			mv.addObject("DATA", benApplyUserService.getBenAppCodeList(paramMap));
			mv.addObject("msg", "");
		} catch(Exception e) {
			e.printStackTrace();
			Log.Error(" ** 임직원공통_인사신청서 리스트 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("map", new HashMap<>());
			mv.addObject("msg", "조회에 실패 하였습니다.");
		}
		Log.DebugEnd();
		return mv;
	}

}
