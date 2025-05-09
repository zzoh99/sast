package com.hr.pap.config.appInternItemCreateMgr;
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
/**
 * 촉탁직평가표생성관리 Controller
 *
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/AppInternItemCreateMgr.do", method=RequestMethod.POST )
public class AppInternItemCreateMgrController {
	/**
	 * 촉탁직평가표생성관리 서비스
	 */
	@Inject
	@Named("AppInternItemCreateMgrService")
	private AppInternItemCreateMgrService appInternItemCreateMgrService;
	/**
	 * 촉탁직평가표생성관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppInternItemCreateMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppInternItemCreateMgr() throws Exception {
		return "pap/config/appInternItemCreateMgr/appInternItemCreateMgr";
	}
	/**
	 * 촉탁직평가표생성관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppInternItemCreateMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppInternItemCreateMgr2() throws Exception {
		return "pap/config/appInternItemCreateMgr/appInternItemCreateMgrPop";
	}
	/**
	 * 촉탁직평가표생성관리 -생성결과- 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppInternItemCreateMgrList", method = RequestMethod.POST )
	public ModelAndView getAppInternItemCreateMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = appInternItemCreateMgrService.getAppInternItemCreateMgrList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 촉탁직평가표생성관리 -생성관리- 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppInternItemCreateMgrList1", method = RequestMethod.POST )
	public ModelAndView getAppInternItemCreateMgrList1(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = appInternItemCreateMgrService.getAppInternItemCreateMgrList1(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 촉탁직평가표생성관리 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppInternItemCreateMgrMap", method = RequestMethod.POST )
	public ModelAndView getAppInternItemCreateMgrMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = appInternItemCreateMgrService.getAppInternItemCreateMgrMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 촉탁직평가표생성관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppInternItemCreateMgr", method = RequestMethod.POST )
	public ModelAndView saveAppInternItemCreateMgr(
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
			resultCnt =appInternItemCreateMgrService.saveAppInternItemCreateMgr(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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



	/**
	 * 촉탁직평가표생성관리 - 쵝탁직평가표생성 - 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppInternItemCreateMgr", method = RequestMethod.POST )
	public ModelAndView prcAppCompItemCreateMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));


		Map map  = appInternItemCreateMgrService.prcAppInternItemCreateMgr(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();

		if(map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
			
			if (map.get("sqlcode") != null) {
				resultMap.put("Code", map.get("sqlcode").toString());
			}
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

}
