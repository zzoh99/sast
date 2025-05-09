package com.hr.tra.basis.eduInstiMgr;

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

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 교육기관관리 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping(value="/EduInstiMgr.do", method=RequestMethod.POST )
public class EduInstiMgrController {
	/**
	 * 교육기관관리 서비스
	 */
	@Inject
	@Named("EduInstiMgrService")
	private EduInstiMgrService eduInstiMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 교육기관관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduInstiMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduInstiMgr() throws Exception {
		return "tra/basis/eduInstiMgr/eduInstiMgr";
	}

	/**
	 * 교육기관관리 Popup View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduInstiMgrPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduInstiMgrPopup() throws Exception {
		return "tra/basis/eduInstiMgr/eduInstiMgrPopup";
	}

	/**
	 * 교육기관관리 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduInstiMgrList", method = RequestMethod.POST )
	public ModelAndView getEduInstiMgrList(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try {
			list = eduInstiMgrService.getEduInstiMgrList(paramMap);
		} catch (Exception e) {
			Message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 교육기관관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEduInstiMgr", method = RequestMethod.POST )
	public ModelAndView saveEduInstiMgr(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,
				paramMap.get("s_SAVENAME").toString(), "");
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<Map> insertList = (List<Map>) convertMap.get("insertRows");
		List<Map<String, Object>> dupList = new ArrayList<Map<String, Object>>();

		for (Map<String, Object> mp : insertList) {
			Map<String, Object> dupMap = new HashMap<String, Object>();
			dupMap.put("ENTER_CD", convertMap.get("ssnEnterCd"));
			dupMap.put("COMPANY_NUM", mp.get("companyNum"));
			dupList.add(dupMap);
		}
		String message = "";
		int resultCnt = -1;
		try {
			int dupCnt = 0;

			if (insertList.size() > 0) {
				// 중복검사
				dupCnt = commonCodeService.getDupCnt("TTRA001", "ENTER_CD,EDU_ORG_CD", "s,s", dupList);
			}
			if (dupCnt > 0) {
				resultCnt = -1;
				message = "사업자등록번호가 중복되어 저장할 수 없습니다.";
			} else {
				resultCnt = eduInstiMgrService.saveEduInstiMgr(convertMap);
				if (resultCnt > 0) {
					message = "저장 되었습니다.";
				} else {
					message = "저장된 내용이 없습니다.";
				}
			}

		} catch (Exception e) {
			resultCnt = -1;
			message = "저장에 실패하였습니다.";
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
}
