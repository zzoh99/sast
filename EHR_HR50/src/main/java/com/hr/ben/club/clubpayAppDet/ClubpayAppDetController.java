package com.hr.ben.club.clubpayAppDet;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
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
 * ClubpayAppDet Controller
 */
@Controller
@RequestMapping({"/ClubpayAppDet.do", "/ClubpayApp.do"})
public class ClubpayAppDetController extends ComController {

	/**
	 * ClubpayAppDet 서비스
	 */
	@Inject
	@Named("ClubpayAppDetService")
	private ClubpayAppDetService clubpayAppDetService;

	/**
	 * ClubpayAppDet View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewClubpayAppDet",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewClubpayAppDet() throws Exception {
		return "ben/club/clubpayAppDet/clubpayAppDet";
	}
	
	/**
	 * ClubpayAppDet 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubpayAppDetMap", method = RequestMethod.POST )
	public ModelAndView getClubpayAppDetMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * ClubpayAppDet 중복 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubpayAppDetDupChk", method = RequestMethod.POST )
	public ModelAndView getClubpayAppDetDupChk(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * ClubpayAppDet 동호회(콤보선택시) 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubpayAppDetClubMap", method = RequestMethod.POST )
	public ModelAndView getClubpayAppDetClubMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * ClubpayAppDet 지원금활동사항 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubpayAppDetaActInfo", method = RequestMethod.POST )
	public ModelAndView getClubpayAppDetaActInfo(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * ClubpayAppDet 지원금활동사항 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteClubpayAppDetaActInfo", method = RequestMethod.POST )
	public ModelAndView deleteClubpayAppDetaActInfo(
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
				resultCnt =clubpayAppDetService.deleteClubpayAppDetaActInfo(convertMap);
				if(resultCnt > 0){ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");}
				else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");}
			}catch(Exception e){
				resultCnt = -1; message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");;
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
	 * ClubpayAppDet 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveClubpayAppDet", method = RequestMethod.POST )
	public ModelAndView saveClubpayAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Log.Info(paramMap.toString());
		
		paramMap.put("ssnSabun",  session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		Log.Info(convertMap.toString());

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = clubpayAppDetService.saveClubpayAppDet(paramMap,convertMap);
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
	
}
