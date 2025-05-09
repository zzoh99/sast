package com.hr.sys.security.userMgr;

import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.hr.common.util.StringUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.wrapper.ReadableRequestWrapper;
import org.springframework.web.servlet.ModelAndView;


/**
 * 비밀번호 확인 
 * 
 * -. 비밀번호 확인 화면으로 forward 하기 때문에 cmd로 구분하면 cmd가 여러가 넘어 가므로
 *    cmd로 구분하지 않고 url을 별도로 지정 함.
 * -. 해당 url은 보안체크 하지 않도록 함 (taglib.jsp)
 * 
 */
@Controller
public class UserMgrPwCheckController {

	@Inject
	@Named("UserMgrService")
	private UserMgrService userMgrService;

	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;

	/**
	 * 비밀번호 확인 view
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/PwConForm.do", method=RequestMethod.POST )
	public String viewPwConForm(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		//Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■");
		//Log.Debug("urlParam====>>>>"+ paramMap.toString());
		//Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■");
		Log.DebugEnd();
		return "common/popup/pwConForm";
	}

	/*
	 * 패스워드 확인
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/PwConCheck.do", method=RequestMethod.POST )
	public void pwConCheck(
			HttpSession session,
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		Log.DebugStart();
		try {
			
			String enterCd = (String) session.getAttribute("ssnEnterCd");
			/*
			 * 비밀번호 확인
			 */
			paramMap.put("ssnEnterCd", enterCd);
			paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
			List<?> result = userMgrService.pwdConfirm(paramMap);

			Log.Debug("result=================================================>" + result);

			Map<String, Object> map = (Map<String, Object>) result.get(0);
			String cnt = String.valueOf(map.get("cnt"));

			/*
			 * 비밀번호 확인 여부
			 */
			HashMap<String, Object> pmap = new HashMap<String, Object>();
			if (cnt.equals("0")) { //비밀번호 틀림.
				pmap.put("pwConfirmYn", "N");
			} else {
				pmap.put("pwConfirmYn", "Y");
			}

			/*
			 * forward URL 조회
			 */
			String surl = (String) paramMap.get("surl");
			String key = (String) session.getAttribute("ssnEncodedKey");

			HashMap<String, Object> umap = (HashMap<String, Object>) securityMgrService.getDecryptUrl(surl, key);

			String fwUrl = (String) umap.get("url");
			pmap.put("ssnEncodedKey", key);
			pmap.put("fwUrl", fwUrl);
			request.setAttribute("pwConfirmFwUrl", fwUrl); //Forward 때문에 request_url이 다르게 나와서 확인차 넣어줌.

			Log.Debug("pmap=================================================>" + pmap);

			/*
			 * 비밀번호 확인여부 암호화
			 */
			String ssurl = securityMgrService.getEncryptPwConfirm(pmap);
			Log.Debug("ssurl=================================================>" + ssurl);
			request.setAttribute("encPwConfirmYn", ssurl);
			
			if (fwUrl.contains("?")) {
				String qstring = fwUrl.substring(fwUrl.indexOf("?") + 1);
				fwUrl = fwUrl.substring(0, fwUrl.indexOf("?"));
				Map<String, String> params = Arrays.stream(qstring.split("&"))
												   .map(s -> s.split("=", 2))
												   .collect(Collectors.toMap(a -> (String) a[0], a -> (String) a[1]));
				ReadableRequestWrapper rrw = new ReadableRequestWrapper(request, securityMgrService.getEncryptKey(enterCd), false);
				for (String name: params.keySet()) {
					rrw.setParameter(name, params.get(name));
				}
				request = (HttpServletRequest) rrw;
			}

			/*
			 * forward
			 */
			RequestDispatcher dispatcher = request.getRequestDispatcher(request.getAttribute("pwConfirmFwUrl")+"");
			dispatcher.forward(request, response);

			Log.DebugEnd();
			return;
		}catch(Exception e){
			Log.Debug(e.getLocalizedMessage());
		}
	}

	/*
	 * 패스워드 확인
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/CheckValidPassword.do", method=RequestMethod.POST )
	public ModelAndView checkValidPassword(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		Log.DebugStart();

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		/*
		 * 비밀번호 확인
		 */
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		try {
			Map<String, Object> result = userMgrService.confirmPassword(paramMap);

			Log.Debug("result=================================================>" + result);

			int cnt = StringUtil.parseInt(StringUtil.stringValueOf(result.get("cnt")));

			/*
			 * 비밀번호 확인 여부
			 */
			if (cnt == 0) { //비밀번호 틀림.
				mv.addObject("pwConfirmYn", "N");
				mv.addObject("message", "비밀번호가 일치하지 않습니다.");
			} else {
				mv.addObject("pwConfirmYn", "Y");
				mv.addObject("message", "");
			}
		} catch (Exception e) {
			Log.Error(" ** 비밀번호 확인 시 오류 발생 >> " + e.getLocalizedMessage());
			mv.addObject("message", "비밀번호 확인 시 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
		}

		return mv;
	}
}