package com.hr.sys.layout.layoutMgr;

import com.hr.common.com.ComService;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 레이아웃 관리
 */
@Controller
@RequestMapping(value="/LayoutMgr.do", method=RequestMethod.POST )
public class LayoutMgrController {
	/**
	 * 공통 서비스
	 */
	@Inject
	@Named("ComService")
	private ComService comService;

	@Inject
	@Named("LayoutMgrService")
	private LayoutMgrService layoutMgrService;

	/**
	 * 쿼리생성 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewLayoutMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewLayoutMgr(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		return "sys/layout/layoutMgr/layoutMgr";
	}

	/**
	 * 리스트 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLayoutMgrCount", method = RequestMethod.POST )
	public Map<String, Object> getLayoutMgrCount(HttpSession session,
			HttpServletRequest request,
			@RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = layoutMgrService.getLayoutMgrCount(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		Map<String, Object> result = new HashMap<>();
		result.put("auths", list);
		result.put("Message", Message);
		Log.DebugEnd();
		return result;
	}
}
