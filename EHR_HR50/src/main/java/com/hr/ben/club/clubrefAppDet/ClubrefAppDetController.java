package com.hr.ben.club.clubrefAppDet;

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
 * ClubrefAppDet Controller
 */
@Controller
@RequestMapping({"/ClubrefAppDet.do", "/ClubrefApp.do"})
public class ClubrefAppDetController extends ComController {

	/**
	 * ClubrefAppDet 서비스
	 */
	@Inject
	@Named("ClubrefAppDetService")
	private ClubrefAppDetService clubrefAppDetService;

	/**
	 * ClubrefAppDet View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewClubrefAppDet",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewClubrefAppDet() throws Exception {
		return "ben/club/clubrefAppDet/clubrefAppDet";
	}
	
	/**
	 * ClubrefAppDet 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubrefAppDetMap", method = RequestMethod.POST )
	public ModelAndView getClubrefAppDetMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * ClubrefAppDet 중복 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubrefAppDetDupChk", method = RequestMethod.POST )
	public ModelAndView getClubrefAppDetDupChk(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * ClubrefAppDet 동호회(콤보선택시) 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubrefAppDetClubMap", method = RequestMethod.POST )
	public ModelAndView getClubrefAppDetClubMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * ClubrefAppDet 급여공제동의내역 회원 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubrefAppDetMember", method = RequestMethod.POST )
	public ModelAndView getClubrefAppDetMember(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * ClubrefAppDet 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveClubrefAppDet", method = RequestMethod.POST )
	public ModelAndView saveClubrefAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Log.Info(paramMap.toString());

        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
            
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		Log.Info(convertMap.toString());

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = clubrefAppDetService.saveClubrefAppDet(paramMap,convertMap);
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
