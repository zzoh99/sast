package com.hr.cpn.payRetroact.retroPersonal;
import java.util.ArrayList;
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

/**
 * 월별급여지급현황 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/RetroPersonal.do", method=RequestMethod.POST )
public class RetroPersonalController {

	/**
	 * 월별급여지급현황 서비스
	 */
	@Inject
	@Named("RetroPersonalService")
	private RetroPersonalService retroPersonalService;

	/**
	 * 월별급여지급현황 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetroPersonal", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetroPersonal() throws Exception {
		return "cpn/payRetroact/retroPersonal/retroPersonal";
	}

	/**
	 * 월별급여지급현황 Sub Main View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetroPersonalSub", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetroPersonalSub() throws Exception {
		return "cpn/payRetroact/retroPersonal/retroPersonalSub";
	}

	/**
	 * 월별급여지급현황 항목세부내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetroPersonalSubDtl", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetroPersonalSubDtl() throws Exception {
		return "cpn/payRetroact/retroPersonal/retroPersonalSubDtl";
	}
	
	/**
	 * 월별급여지급현황 계산내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetroPersonalSubLst", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetroPersonalSubLst() throws Exception {
		return "cpn/payRetroact/retroPersonal/retroPersonalSubLst";
	}

	@RequestMapping(params="cmd=viewRetroDetailPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewRetroDetailPop(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		String Message = "";

		ModelAndView mv = new ModelAndView();

		try{
			mv.addObject("list", retroPersonalService.getRetroDetailPopLst(paramMap, "getRetroDetailPopLst"));	// 소급전/후/차
			mv.addObject("list2",  retroPersonalService.getRetroDetailPopMap (paramMap, "getRetroDetailPopMap")); // 상세내역
			mv.addObject("list3",  retroPersonalService.getRetroDetailPopLst2 (paramMap, "getRetroDetailPopLst2")); // 상세내역
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		
		mv.setViewName("cpn/payRetroact/retroPersonal/retroPersonalSubDtlPop");
		mv.addObject("Message", Message);
		mv.addObject("paramMap",    paramMap);
		
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetroPersonalLst", method = RequestMethod.POST )
	public ModelAndView getRetroPersonalLst(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			// 항목구분(A.지급 D.공제)
			// 공제분류(ER_CAG.회사부담금) 제외
			list = retroPersonalService.getRetroPersonalLst(paramMap);
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
	 * 월별급여지급현황 계산내역TAB 세금내역 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetroPersonalMap", method = RequestMethod.POST )
	public ModelAndView getRetroPersonalMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = retroPersonalService.getRetroPersonalMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map",map);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 월별급여지급현황 항목세부내역TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetroPersonalDtlList", method = RequestMethod.POST )
	public ModelAndView getRetroPersonalDtlList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = retroPersonalService.getRetroPersonalDtlList(paramMap);
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

    @RequestMapping(params="cmd=getRetroDetailPopList1", method = RequestMethod.POST )
    public ModelAndView getRetroDetailPopList1(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

        List<?> list = new ArrayList<Object>();
        String Message = "";

        try{
            list = retroPersonalService.getRetroDetailPopList1(paramMap);
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

    @RequestMapping(params="cmd=getRetroDetailPopList2", method = RequestMethod.POST )
    public ModelAndView getRetroDetailPopList2(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

        List<?> list = new ArrayList<Object>();
        String Message = "";

        try{
            list = retroPersonalService.getRetroDetailPopList2(paramMap);
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

    @RequestMapping(params="cmd=getRetroDetailPopLst", method = RequestMethod.POST )
    public ModelAndView getRetroDetailPopLst(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

        List<?> list = new ArrayList<Object>();
        String Message = "";

        try{
            list = retroPersonalService.getRetroDetailPopLst(paramMap);
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
}
