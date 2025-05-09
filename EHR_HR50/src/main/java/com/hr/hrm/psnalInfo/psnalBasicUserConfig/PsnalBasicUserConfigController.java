package com.hr.hrm.psnalInfo.psnalBasicUserConfig;

import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
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
import java.util.Map;

/**
 * 인사기본_임직원공통 설정 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PsnalBasicUserConfig.do", method=RequestMethod.POST )
public class PsnalBasicUserConfigController {

	/**
	 * 인사기본_임직원공통 설정 서비스
	 */
	@Inject
	@Named("PsnalBasicUserConfigService")
	private PsnalBasicUserConfigService psnalBasicUserConfigService;

	/**
	 * 인사기본_임직원공통 설정 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalBasicUserConfig", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalBasicUserConfig(HttpSession session
			, @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return "hrm/psnalInfo/psnalBasicUserConfig/psnalBasicUserConfig";
	}

	/**
	 * 인사기본_임직원공통 설정 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicUserConfigJson", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicUserConfigJson(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			Map<String, Object> map = psnalBasicUserConfigService.getPsnalBasicUserConfigJson(paramMap);
			mv.addObject("map", map);
			mv.addObject("msg", "");
		} catch(Exception e) {
			Log.Error(" ** 인사기본_임직원공통 설정 데이터 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("map", new HashMap<>());
			mv.addObject("msg", "조회에 실패하였습니다.");
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본_임직원공통 설정 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePsnalBasicUserConfig", method = RequestMethod.POST )
	public ModelAndView savePsnalBasicUserConfig(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			int cnt = psnalBasicUserConfigService.savePsnalBasicUserConfig(paramMap);
			mv.addObject("code", cnt);
			if (cnt > 0) {
				mv.addObject("msg", LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."));
			} else {
				mv.addObject("msg", LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."));
			}
		} catch(Exception e) {
			Log.Error(" ** 인사기본_임직원공통 설정 저장 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("code", -1);
			mv.addObject("msg", LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다."));
		}

		Log.DebugEnd();
		return mv;
	}
}
