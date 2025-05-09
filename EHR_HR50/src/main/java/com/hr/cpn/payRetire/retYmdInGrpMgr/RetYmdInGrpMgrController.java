package com.hr.cpn.payRetire.retYmdInGrpMgr;
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
 * 그룹내 퇴직정산일(\C774\C218) Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/RetYmdInGrpMgr.do", method=RequestMethod.POST )
public class RetYmdInGrpMgrController {
	/**
	 * 그룹내 퇴직정산일(\C774\C218) 서비스
	 */
	@Inject
	@Named("RetYmdInGrpMgrService")
	private RetYmdInGrpMgrService retYmdInGrpMgrService;

	/**
	 * 그룹내 퇴직정산일(\C774\C218) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetYmdInGrpMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetYmdInGrpMgr() throws Exception {
		return "cpn/payRetire/retYmdInGrpMgr/retYmdInGrpMgr";
	}

	/**
	 * 그룹내 퇴직정산일(\C774\C218) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetYmdInGrpMgrList", method = RequestMethod.POST )
	public ModelAndView getRetYmdInGrpMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = retYmdInGrpMgrService.getRetYmdInGrpMgrList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}

