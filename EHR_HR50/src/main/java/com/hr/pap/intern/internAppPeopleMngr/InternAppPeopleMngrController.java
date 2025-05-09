package com.hr.pap.intern.internAppPeopleMngr;

import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.rd.EncryptRdService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;

/**
 * 수습평가대상자관리 Controller
 * 
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/InternAppPeopleMngr.do", method=RequestMethod.POST )
public class InternAppPeopleMngrController extends ComController {

	@Inject
	@Named("EncryptRdService")
	private EncryptRdService encryptRdService;

	@Value("${rd.image.base.url}")
	private String imageBaseUrl;

	/**
	 * View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewInternAppPeopleMngr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewInternAppPeopleMngr() throws Exception {
		return "pap/intern/internAppPeopleMngr/internAppPeopleMngr";
	}

	/**
	 * 수습평가대상자관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternAppPeopleMngrList", method = RequestMethod.POST )
	public ModelAndView getInternAppPeopleMngrList(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 수습평가대상자관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveInternAppPeopleMngr", method = RequestMethod.POST )
	public ModelAndView saveInternAppPeopleMngr(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	@RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
	public ModelAndView getEncryptRd(
			HttpSession session, HttpServletRequest request
			, @RequestBody Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();

		String mrdPath = paramMap.get("mrdPath").toString();

		String param = "/rp"
				+ " " + paramMap.get("parameters");

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			mv.addObject("DATA", encryptRdService.encrypt(mrdPath, param));
			mv.addObject("Message", "");
		} catch (Exception e) {
			mv.addObject("Message", "암호화에 실패했습니다.");
		}
		Log.DebugEnd();
		return mv;
	}
}
