package com.hr.sys.system.processMap;
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
 * 프로세스맵 Controller 
 * 
 * @author jin
 *
 */
@Controller
@RequestMapping(value="/ProcessMap.do", method={RequestMethod.GET, RequestMethod.POST} )
public class ProcessMapController {

	@Inject
	@Named("ProcessMapService")
	private ProcessMapService processMapService;
	
	
	/**
	 * 프로세스맵 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewProcessMap", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewProcessMap(HttpSession session,  HttpServletRequest request) throws Exception{
		
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		List<Map<String,Object>> mainMenuList = new ArrayList();

		try{
			mainMenuList = processMapService.getMainMenuList(session);
			mv.addObject("status","SUCCESS");
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			mv.addObject("status","FAIL");
		}

		mv.setViewName("sys/system/processMap/processMap");
		mv.addObject("mainMenuList",mainMenuList);

		
		Log.DebugEnd();
		return mv;
	}
	
	
	/**
	 * 프로세스맵 리스트
	 * @param session
	 * @param request
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(params="cmd=getProcessMapList", method = RequestMethod.POST )
	public ModelAndView viewProcessList(HttpSession session,  HttpServletRequest request,
			@RequestParam(required = true) String mainMenuCd) throws Exception{
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		Map<String,Object> processList = new HashMap();
	
		try{
			processList = processMapService.getProcessList(session,mainMenuCd);
			mv.addObject("status","SUCCESS");
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			mv.addObject("status","FAIL");
		}
		
		mv.setViewName("jsonView");
		mv.addObject("procMapList", processList.get("procMapList"));

		Log.DebugEnd();
		return mv;
	}
	
	
}
