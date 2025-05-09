package com.hr.tim.schedule.workScheduleOrgAppDet;
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
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.tim.schedule.workScheduleOrgApp.WorkScheduleOrgAppService;
import com.hr.common.com.ComController;
import com.hr.common.language.LanguageUtil;
/**
 * 부서근무스케쥴신청 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping({"/WorkScheduleOrgApp.do","/WorkScheduleOrgAppDet.do"})
public class WorkScheduleOrgAppDetController extends ComController {
	/**
	 * 부서근무스케쥴신청 서비스
	 */
	@Inject
	@Named("WorkScheduleOrgAppDetService")
	private WorkScheduleOrgAppDetService workScheduleOrgAppDetService;

	
    @RequestMapping(params="cmd=viewWorkScheduleOrgAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewWorkScheduleOrgAppDet() throws Exception {
        return "tim/schedule/workScheduleOrgAppDet/workScheduleOrgAppDet";
    }
    
	/**
	 * 부서근무스케쥴 신청 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkScheduleOrgAppDet", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleOrgAppDet(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 부서콤보 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkScheduleOrgAppDetOrgList", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleOrgAppDetOrgList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	/**
	 * 근무조 조회 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkScheduleOrgAppDetWorkOrg", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleOrgAppDetWorkOrg(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 근무한도 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkScheduleOrgAppDetLimit", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleOrgAppDetLimit(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 기 신청 건 체크 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkScheduleOrgAppDetDupCnt", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleOrgAppDetDupCnt(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> pMap 		= request.getParameterMap();
		List<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
		String[] sabuns = (String[]) pMap.get("sabun");
		for( int i=0; i<sabuns.length; i++){
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("sabun", sabuns[i]);
			list.add(map);
		}

		paramMap.put("sabuns", list);
		
			
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 부서근무스케쥴 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkScheduleOrgAppDetList", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleOrgAppWorkList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		List<?> titleList = workScheduleOrgAppDetService.getWorkScheduleOrgAppDetHeaderList(paramMap);
		paramMap.put("titles", titleList);
		
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 부서근무스케쥴 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkScheduleOrgAppDetHeaderList", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleOrgAppDetHeaderList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 부서근무스케쥴신청 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWorkScheduleOrgAppDet", method = RequestMethod.POST )
	public ModelAndView saveWorkScheduleOrgAppDet(
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

			Map<?, ?> pMap 		= request.getParameterMap();
			List<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
			String[] sabuns = (String[]) pMap.get("sabun");
			for( int i=0; i<sabuns.length; i++){
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("sabun", sabuns[i]);
				list.add(map);
			}
			convertMap.put("sabuns", list);
			
			resultCnt = workScheduleOrgAppDetService.saveWorkScheduleOrgAppDet(convertMap);
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
