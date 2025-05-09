package com.hr.sys.alteration.mainMuPrg;
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

import com.hr.common.language.Language;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.sys.system.dictMgr.DictMgrService;
import com.hr.common.language.LanguageUtil;

/**
 * 메인메뉴프로그램관리 Controller
 *
 * @author ParkMoohun
 *
 */
@Controller
@RequestMapping(value="/MainMuPrg.do", method=RequestMethod.POST )
public class MainMuPrgController {
	/**
	 * 메인메뉴프로그램관리 서비스
	 */
	@Inject
	@Named("MainMuPrgService")
	private MainMuPrgService mainMuPrgService;

	@Inject
	@Named("DictMgrService")
	private DictMgrService dictMgrService;

	@Inject
	@Named("Language")
	private	Language language;

	/**
	 * 메인메뉴프로그램관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMainMuPrg", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMainMuPrg() throws Exception {
		return "sys/alteration/mainMuPrg/mainMuPrg";
	}
	
	/**
	 * 메인메뉴프로그램관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMainMnMgrHelpPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMainMnMgrHelpPop() throws Exception {
		return "sys/alteration/mainMnMgr/mainMnMgrHelpPop";
	}
	
	/**
	 * 메인메뉴프로그램관리 팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMainMuPrgPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMainMuPrgPop() throws Exception {
		return "sys/alteration/mainMuPrg/mainMuPrgPop";
	}
	
	 /**
     * 메인메뉴프로그램관리 팝업 Layer View
     * 
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewMainMuPrgLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewMainMuPrgLayer() throws Exception {
        return "sys/alteration/mainMuPrg/mainMuPrgLayer";
    }
	
	/**
	 * 메인메뉴프로그램관리 팝업 View
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewIframeEditor", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewIframeEditor(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("MainMuPrgController.viewIframeEditor");
		//return "sys/alteration/mainMuPrg/mainMuPrgPop";
		return "common/plugin/Editor/iframe_editor";
	}

	/**
	 * 메인메뉴프로그램관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMainMuPrgList", method = RequestMethod.POST )
	public ModelAndView getMainMuPrgList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List list  		= new ArrayList();
		List rtnList  	= new ArrayList();
		String Message 	= "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		try{
			list = mainMuPrgService.getMainMuPrgList(paramMap);
		}catch(Exception e){
			Message= language.getMessage("msg.alertSearchFail");
		}
		String mainMenuNm = paramMap.get("mainMenuNm").toString();
		String mainMenuCd = paramMap.get("mainMenuCd").toString();
		Map m = new HashMap();
		m.put("Level","0");
		m.put("mainMenuCd",mainMenuCd);
		m.put("priorMenuCd","0");
		m.put("menuCd","0");
		m.put("menuSeq","");
		m.put("type","");
		m.put("menuNm",mainMenuNm);
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
	 * 메인메뉴프로그램관리 메뉴 조회
	 * 
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMainMuPrgMainMenuList", method = RequestMethod.POST )
	public ModelAndView getMainMuPrgMainMenuList( 
			HttpServletRequest request,@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		list = mainMuPrgService.getMainMuPrgMainMenuList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", list);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 메인메뉴프로그램관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMainMuPrg", method = RequestMethod.POST )
	public ModelAndView saveMainMuPrg(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();


		String sSavename = paramMap.get("s_SAVENAME")== null ? "" : String.valueOf(paramMap.get("s_SAVENAME"));
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,sSavename,"");

		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =mainMuPrgService.saveMainMuPrg(convertMap);

			if(resultCnt > 0){ message= language.getMessage("msg.alertSaveOk", null, "자료가 저장되었습니다.."); } else{ message= language.getMessage("msg.alertNoSaveData", null, "저장할 자료가 없습니다."); }
		}
		catch(Exception e){
			resultCnt = -1; message= language.getMessage("msg.alertSaveFail", null, "저장 중 오류가 발생하였습니다.");
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
	 * 메인메뉴프로그램관리 도움말 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMainMuPrgPop", method = RequestMethod.POST )
	public ModelAndView saveMainMuPrgPop(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =mainMuPrgService.saveMainMuPrgPop(paramMap);
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
	 * 메인메뉴관리 도움말 조회
	 *
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMainMnMgrHelpPopMap", method = RequestMethod.POST )
	public ModelAndView getMainMnMgrHelpPopMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));
		Map<?,?> map = mainMuPrgService.getMainMnMgrHelpPopMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 메인메뉴관리 도움말 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMainMnMgrHelpPop", method = RequestMethod.POST )
	public ModelAndView saveMainMnPrgPop(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =mainMuPrgService.saveMainMnMgrHelpPop(paramMap);
			if(resultCnt > 0){ message=LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message= LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message=LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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

    @RequestMapping(params="cmd=getMainMuPrgPopMap", method = RequestMethod.POST )
    public ModelAndView getMainMuPrgPopMap(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = mainMuPrgService.getMainMuPrgPopMap(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", map);
        mv.addObject("Message", Message);

        Log.DebugEnd();
        return mv;
    }
}
