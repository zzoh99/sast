package com.hr.ben.carAllocate.carAllocateMgr;
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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 업무차량배차관리 Controller
 *
 * @author kwook
 *
 */
@Controller
@RequestMapping(value="/CarAllocateMgr.do", method=RequestMethod.POST )
public class CarAllocateMgrController extends ComController {
	/**
	 * 업무차량배차관리 서비스
	 */
	@Inject
	@Named("CarAllocateMgrService")
	private CarAllocateMgrService carAllocateMgrService;
	
    /**
     * 업무차량배차관리 View
     * 
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewCarAllocateMgr",method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewCarAllocateMgr() throws Exception {
        return "ben/carAllocate/carAllocateMgr/carAllocateMgr";
    }

    /**
     * 업무차량배차 관리 다건 조회
     * 
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getCarAllocateMgrList", method = RequestMethod.POST )
    public ModelAndView getCarAllocateMgrList(
            HttpSession session,  HttpServletRequest request, 
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        
        paramMap.put("ssnEnterCd",      session.getAttribute("ssnEnterCd"));
        List<?> result = carAllocateMgrService.getCarAllocateMgrList(paramMap);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", result);
        Log.DebugEnd();
        return mv;
    }


    /**
	 * 업무차량배차 관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveCarAllocateMgr", method = RequestMethod.POST )
	public ModelAndView saveCarAllocateMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = carAllocateMgrService.saveCarAllocateMgr(convertMap);

			if(resultCnt > 0){
				message="저장 되었습니다.";
			} else {
				if ("".equals(message)) {
					message="처리된 내용이 없습니다.";
				}
			}
		} catch(Exception e) {
			Log.Debug(e.getLocalizedMessage());
			resultCnt = -1; message="저장을 실패하였습니다.";
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
     * 업무차량배차  저장
     * 
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=deleteCarAllocateMgr", method = RequestMethod.POST )
    public ModelAndView deleteOccApp(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();

        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun",  session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        String message = "";
        int resultCnt = -1;
        try{
            resultCnt =carAllocateMgrService.deleteCarAllocateMgr(convertMap);
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
