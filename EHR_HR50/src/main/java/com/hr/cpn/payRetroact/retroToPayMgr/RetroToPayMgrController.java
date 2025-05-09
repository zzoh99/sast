package com.hr.cpn.payRetroact.retroToPayMgr;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.util.ParamUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;

/**
 * 소급결과급여반영 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/RetroToPayMgr.do", method=RequestMethod.POST )
public class RetroToPayMgrController extends ComController {

	/**
	 * 소급결과급여반영 서비스
	 */
	@Inject
	@Named("RetroToPayMgrService")
	private RetroToPayMgrService retroToPayMgrService;

	/**
	 * 소급결과급여반영 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetroToPayMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetroToPayMgr() throws Exception {
		return "cpn/payRetroact/retroToPayMgr/retroToPayMgr";
	}

	/**
	 * 소급결과급여반영 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetroToPayMgrList", method = RequestMethod.POST )
	public ModelAndView getRetroToPayMgrList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = retroToPayMgrService.getRetroToPayMgrList(paramMap);
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
	 * 소급결과급여반영 급여반영
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_RE_CAL_TO_PAY_APPLY", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_RE_CAL_TO_PAY_APPLY(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map map = retroToPayMgrService.prcP_CPN_RE_CAL_TO_PAY_APPLY(paramMap);

		Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", "0");

		if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
			resultMap.put("Code", map.get("sqlcode").toString());
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			} else {
				resultMap.put("Message", "급여반영 오류입니다.");
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 소급결과급여반영 급여반영취소
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_RE_CAL_TO_PAY_CANCEL", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_RE_CAL_TO_PAY_CANCEL(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map map = retroToPayMgrService.prcP_CPN_RE_CAL_TO_PAY_CANCEL(paramMap);

		Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", "0");

		if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
			resultMap.put("Code", map.get("sqlcode").toString());
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			} else {
				resultMap.put("Message", "급여반영 취소 오류입니다.");
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 소급결과급여반영 급여반영취소
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_RE_CAL_TO_PAY_CREATE", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_RE_CAL_TO_PAY_CREATE(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return execPrc(session, request, paramMap);
	}

    @RequestMapping(params="cmd=getRetroToPayMgrPriorList", method = RequestMethod.POST )
    public ModelAndView getRetroToPayMgrPriorList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = retroToPayMgrService.getRetroToPayMgrPriorList(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", list);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        return mv;
    }

    @RequestMapping(params="cmd=saveRetroToPayMgrPriorList", method = RequestMethod.POST )
    public ModelAndView saveRetroToPayMgrPriorList(HttpSession session,
                                                    @RequestParam Map<String, Object> paramMap,
                                                    HttpServletRequest request) throws Exception {
        Log.DebugEnd();
        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        convertMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
        Log.Debug(convertMap.toString());
        String message = "";
        int cnt =0;
        try{
            cnt = retroToPayMgrService.saveRetroToPayMgrPriorList(convertMap);
            if (cnt > 0) {
                message="근속포상대상자 데이터가 확정취소되었습니다.";
            }else if(cnt == 0 ) { message="저장된 내용이 없습니다."; }
        }catch(Exception e){ Log.Debug(e.getMessage());cnt=-1; message="저장 실패하였습니다."; }

        Map resultMap = new HashMap();
        resultMap.put("Code",cnt);
        resultMap.put("Message",message);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", 	resultMap);
        Log.DebugStart();
        return mv;
    }
}