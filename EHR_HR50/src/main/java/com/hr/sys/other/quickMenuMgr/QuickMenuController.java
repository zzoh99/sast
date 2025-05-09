package com.hr.sys.other.quickMenuMgr;
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
 * 메뉴명 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/QuickMenu.do", method=RequestMethod.POST )
public class QuickMenuController {
	/**
	 * 메뉴명 서비스
	 */
	@Inject
	@Named("QuickMenuService")
	private QuickMenuService quickMenuService;
	/**
	 * 메뉴명 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewQuickMenu", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewQuickMenu() throws Exception {
		return "sys/quickMenuMgr/quickMenu_popup";
	}

	/**
	 * 메뉴명 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewQuickMenuLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewQuickMenuLayer() throws Exception {
		return "sys/quickMenuMgr/quickMenuLayer";
	}
	

	/**
	 * 퀵메뉴 메뉴 콤보
	 * 
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getQuickMuComboList", method = RequestMethod.POST )
	public ModelAndView getQuickMuComboList( 
			HttpSession session, HttpServletRequest request
			,@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnGrpCd",session.getAttribute("ssnGrpCd"));
		
		list = quickMenuService.getQuickMuComboList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", list);
		Log.DebugEnd();
		return mv;
	}
	
	
	/**
	 * Quick메뉴프로그램관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getQuickMuPrgList", method = RequestMethod.POST )
	public ModelAndView getQuickMuPrgList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List list  		= new ArrayList();
		List rtnList  	= new ArrayList();
		String Message 	= "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnGrpCd",session.getAttribute("ssnGrpCd"));
		try{
			list = quickMenuService.getQuickMuPrgList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		String mainMenuNm = paramMap.get("mainMenuNm").toString();
		String mainMenuCd = paramMap.get("mainMenuCd").toString();
		Map<String, String> m = new HashMap<String, String>();
		m.put("Level","0");
		m.put("mainMenuCd",mainMenuCd);
		m.put("priorMenuCd","0");
		m.put("menuCd","0");
		m.put("menuSeq","");
		m.put("type","");
		m.put("menuNm",mainMenuNm);
		m.put("grpCd",session.getAttribute("ssnGrpCd").toString());
		m.put("prgCd","");
		m.put("searchSeq","");
		m.put("searchDesc","");
		m.put("dataPrgType","");
		m.put("dataRwType","");
		m.put("seq","");
		m.put("cnt","");
		rtnList.add(m);
		
		for(int i=0; i<list.size(); i++){
			rtnList.add(list.get(i));
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", rtnList);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	

	/**
	 * MyQuick Menu 
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=tsys333SelectMyQuickMenuList", method = RequestMethod.POST )
	public ModelAndView tsys333SelectMyQuickMenuList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		try{
			list = quickMenuService.tsys333SelectMyQuickMenuList(paramMap);
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
	 * 메뉴명 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getQuickMenuMap", method = RequestMethod.POST )
	public ModelAndView getQuickMenuMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = quickMenuService.getQuickMenuMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 메뉴명 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveQuickMenu", method = RequestMethod.POST )
	public ModelAndView saveQuickMenu(
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
			resultCnt =quickMenuService.saveQuickMenu(convertMap);
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
