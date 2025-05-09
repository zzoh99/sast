package com.hr.sys.system.sabunChange;
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
 * 사번변경 Controller 
 * 
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/SabunChange.do", method=RequestMethod.POST )
public class SabunChangeController {
	/**
	 * 사번변경 서비스
	 */
	@Inject
	@Named("SabunChangeService")
	private SabunChangeService sabunChangeService;
	/**
	 * 사번변경 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSabunChange", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSabunChange() throws Exception {
		return "sys/system/sabunChange/sabunChange";
	}
	
	/**
	 * 사번변경 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSabunDupCheckPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSabunChange2() throws Exception {
		return "sys/system/sabunChange/sabunDupCheckPopup";
	}
	
	@RequestMapping(params="cmd=viewSabunDupCheckLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSabunDupCheckLayer() throws Exception {
		return "sys/system/sabunChange/sabunDupCheckLayer";
	}
	
	/**
	 * 사번변경 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSabunChangeList", method = RequestMethod.POST )
	public ModelAndView getSabunChangeList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = sabunChangeService.getSabunChangeList(paramMap);
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
	 * 사번변경 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSabunChangeMap", method = RequestMethod.POST )
	public ModelAndView getSabunChangeMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = sabunChangeService.getSabunChangeMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	
	/**
     * 사번변경 팝업 중복체크 단건 조회
     * 
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getSabunDupCheckPopupMap", method = RequestMethod.POST )
    public ModelAndView getSabunDupCheckPopupMap(
            HttpSession session,  HttpServletRequest request, 
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        Map<?, ?> map = sabunChangeService.getSabunDupCheckPopupMap(paramMap);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("map", map);
        Log.DebugEnd();
        return mv;
    }
	
	
	
	/**
	 * 사번변경 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSabunChange", method = RequestMethod.POST )
	public ModelAndView saveSabunChange(
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
			resultCnt =sabunChangeService.saveSabunChange(convertMap);
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
	
	
	
	/**
     * 사번변경 프로시져
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=prcP_SYS_SABUN_DATA_MODIFY", method = RequestMethod.POST )
    public ModelAndView prcP_BEN_MTH_CLUB_INFO_CRE(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

        Map<?, ?> map = sabunChangeService.prcP_SYS_SABUN_DATA_MODIFY(paramMap);

        Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("Code", "");

        if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
            resultMap.put("Code", map.get("sqlcode").toString());
            if (map.get("sqlerrm") != null) {
                resultMap.put("Message", map.get("sqlerrm").toString());
            } else {
                resultMap.put("Message", "사번변경 중 오류가 발생 했습니다.");
            }
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", resultMap);

        Log.DebugEnd();
        return mv;
    }

}
