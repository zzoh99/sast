package com.hr.hrm.psnalInfo.psnalConYmdMgr;
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

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;

/**
 * psnalConYmdMgr Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/PsnalConYmdMgr.do", method=RequestMethod.POST )
public class PsnalConYmdMgrController {
	/**
	 * psnalConYmdMgr 서비스
	 */
	@Inject
	@Named("PsnalConYmdMgrService")
	private PsnalConYmdMgrService psnalConYmdMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;


	/**
	 * psnalConYmdMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalConYmdMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalConYmdMgr() throws Exception {
		return "hrm/psnalInfo/psnalConYmdMgr/psnalConYmdMgr";
	}

	/**
	 * psnalConYmdMgr(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalConYmdMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalConYmdMgrPop() throws Exception {
		return "hrm/psnalInfo/psnalConYmdMgr/psnalConYmdMgrPop";
	}

	/**
	 * psnalConYmdMgr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalConYmdMgrList", method = RequestMethod.POST )
	public ModelAndView getPsnalConYmdMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
			if(query != null) {
				Log.Debug("query.get=> "+ query.get("query"));
				paramMap.put("query",query.get("query"));
			}

			list = psnalConYmdMgrService.getPsnalConYmdMgrList(paramMap);
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
