package com.hr.cpn.payCalculate.payCalcCre;
import java.util.HashMap;
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

import com.hr.common.execPrc.ExecPrcAsyncService;
import com.hr.common.logger.Log;

/**
 * 급여계산 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping({"/PayCalcCreProc.do", "/PayCalcCre.do"})
public class PayCalcCreProcController {

	/**
	 * 급여계산 서비스
	 */
	@Inject
	@Named("PayCalcCreProcService")
	private PayCalcCreProcService payCalcCreProcService;
	
	@Inject
	@Named("ExecPrcAsyncService")
	private ExecPrcAsyncService execPrcAsyncService;

	/**
	 * 급여계산 작업
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_CAL_PAY_MAIN", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_CAL_PAY_MAIN(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<String, Object> resultMap = new HashMap<String, Object>();

		try{
			/*
			Map map = payCalcCreProcService.prcP_CPN_CAL_PAY_MAIN(paramMap);
			
			Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

			resultMap.put("Code", "0");

			if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
				resultMap.put("Code", map.get("sqlcode").toString());
				if (map.get("sqlerrm") != null) {
					resultMap.put("Message", map.get("sqlerrm").toString());
				} else {
					resultMap.put("Message", "급여계산 오류입니다.");
				}
			}*/
			
			// 20200618 비동기 방식으로 실행
			Map map = execPrcAsyncService.execPrc("PayCalcCreProcP_CPN_CAL_PAY_MAIN", paramMap);
			resultMap.put("Code", "0");
			resultMap.put("Message", "급여계산이 실행되었습니다.");

		}catch(Exception e){
			resultMap.put("Code", "");
			resultMap.put("Message", "급여계산 오류입니다.");
			//Log.Debug(e.getLocalizedMessage());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 상여계산 작업
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_BON_PAY_MAIN", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_BON_PAY_MAIN(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<String, Object> resultMap = new HashMap<String, Object>();

		try{
			Map map = payCalcCreProcService.prcP_CPN_BON_PAY_MAIN(paramMap);

			Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

			resultMap.put("Code", "0");

			if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
				resultMap.put("Code", map.get("sqlcode").toString());
				if (map.get("sqlerrm") != null) {
					resultMap.put("Message", map.get("sqlerrm").toString());
				} else {
					resultMap.put("Message", "급여계산 오류입니다.");
				}
			}
		}catch(Exception e){
			resultMap.put("Code", "");
			resultMap.put("Message", "급여계산 오류입니다.");
			//Log.Debug(e.getLocalizedMessage());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여계산 작업(개인별)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_CAL_PAY_MAIN2", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_CAL_PAY_MAIN2(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<String, Object> resultMap = new HashMap<String, Object>();

		try{
			Map map = payCalcCreProcService.prcP_CPN_CAL_PAY_MAIN2(paramMap);
			
			if (map != null) {
				Log.Debug("\n\n\n\n map \n\t" + map);
				Log.Debug("\n\tsqlcode :: " + map.get("sqlcode"));
				Log.Debug("\n\tsqlerrm :: " + map.get("sqlerrm"));
				Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");
			}

			resultMap.put("Code", "0");

			if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
				resultMap.put("Code", map.get("sqlcode").toString());
				if (map.get("sqlerrm") != null) {
					resultMap.put("Message", map.get("sqlerrm").toString());
				} else {
					resultMap.put("Message", "급여계산 오류입니다.");
				}
			}
		}catch(Exception e){
			resultMap.put("Code", "");
			resultMap.put("Message", "급여계산 오류입니다.");
			Log.Debug(e.getLocalizedMessage());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 상여계산 작업(개인별)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_BON_PAY_MAIN2", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_BON_PAY_MAIN2(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<String, Object> resultMap = new HashMap<String, Object>();

		try{
			Map map = payCalcCreProcService.prcP_CPN_BON_PAY_MAIN2(paramMap);

			Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

			resultMap.put("Code", "0");

			if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
				resultMap.put("Code", map.get("sqlcode").toString());
				if (map.get("sqlerrm") != null) {
					resultMap.put("Message", map.get("sqlerrm").toString());
				} else {
					resultMap.put("Message", "급여계산 오류입니다.");
				}
			}
		}catch(Exception e){
			resultMap.put("Code", "");
			resultMap.put("Message", "급여계산 오류입니다.");
			//Log.Debug(e.getLocalizedMessage());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 급여계산 복리후생 연계자료 생성
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
//	@RequestMapping(params="cmd=prcP_BEN_PAY_DATA_CREATE_ALL", method = RequestMethod.POST )
//	public ModelAndView prcP_BEN_PAY_DATA_CREATE_ALL(
//			HttpSession session, HttpServletRequest request,
//			@RequestParam Map<String, Object> paramMap ) throws Exception {
//		Log.DebugStart();
//
//		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
//		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
//
//		Map<String, Object> resultMap = new HashMap<String, Object>();
//
//		try{
//			Map map = payCalcCreProcService.prcP_BEN_PAY_DATA_CREATE_ALL(paramMap);
//
//			Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");
//
//			resultMap.put("Code", "0");
//
//			if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
//				resultMap.put("Code", map.get("sqlcode").toString());
//				if (map.get("sqlerrm") != null) {
//					resultMap.put("Message", map.get("sqlerrm").toString());
//				} else {
//					resultMap.put("Message", "복리후생연계작업 오류입니다.");
//				}
//			}
//		}catch(Exception e){
//			resultMap.put("Code", "");
//			resultMap.put("Message", "복리후생연계작업 오류입니다.");
//			//Log.Debug(e.getLocalizedMessage());
//		}
//
//		ModelAndView mv = new ModelAndView();
//		mv.setViewName("jsonView");
//		mv.addObject("Result", resultMap);
//
//		Log.DebugEnd();
//		return mv;
//	}	
}