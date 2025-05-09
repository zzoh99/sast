package com.hr.cpn.payRetire.sepCalcBasicMgr;
import java.io.Serializable;
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
import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 퇴직금기본내역 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/SepCalcBasicMgr.do", method=RequestMethod.POST )
public class SepCalcBasicMgrController {

	/**
	 * 퇴직금기본내역 서비스
	 */
	@Inject
	@Named("SepCalcBasicMgrService")
	private SepCalcBasicMgrService sepCalcBasicMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 퇴직금기본내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepCalcBasicMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepCalcBasicMgr() throws Exception {
		return "cpn/payRetire/sepCalcBasicMgr/sepCalcBasicMgr";
	}

	/**
	 * 퇴직금기본내역 기본사항TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepCalcBasicMgrBasic", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepCalcBasicMgrBasic() throws Exception {
		return "cpn/payRetire/sepCalcBasicMgr/sepCalcBasicMgrBasic";
	}

	/**
	 * 퇴직금기본내역 평균임금TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepCalcBasicMgrAverageIncome", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepCalcBasicMgrAverageIncome() throws Exception {
		return "cpn/payRetire/sepCalcBasicMgr/sepCalcBasicMgrAverageIncome";
	}

	/**
	 * 퇴직금기본내역 퇴직금계산내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepCalcBasicMgrSeverancePayCalc", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepCalcBasicMgrSeverancePayCalc() throws Exception {
		return "cpn/payRetire/sepCalcBasicMgr/sepCalcBasicMgrSeverancePayCalc";
	}

	/**
	 * 퇴직금기본내역 퇴직종합정산TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepCalcBasicMgrRetireCalc", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepCalcBasicMgrRetireCalc() throws Exception {
		return "cpn/payRetire/sepCalcBasicMgr/sepCalcBasicMgrRetireCalc";
	}

	/**
	 * 퇴직금기본내역 전근무지사항TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepCalcBasicMgrBeforeWork", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepCalcBasicMgrBeforeWork() throws Exception {
		return "cpn/payRetire/sepCalcBasicMgr/sepCalcBasicMgrBeforeWork";
	}

	/**
	 * 퇴직금기본내역 기본사항TAB 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcBasicMgrBasicMap", method = RequestMethod.POST )
	public ModelAndView getSepCalcBasicMgrBasicMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = sepCalcBasicMgrService.getSepCalcBasicMgrBasicMap(paramMap);
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
	 * 퇴직금기본내역 평균임금TAB 급여 항목리스트 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcBasicMgrAverageIncomePayTitleList", method = RequestMethod.POST )
	public ModelAndView getSepCalcBasicMgrAverageIncomePayTitleList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepCalcBasicMgrService.getSepCalcBasicMgrAverageIncomePayTitleList(paramMap);
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
	 * 퇴직금기본내역 평균임금TAB 급여 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcBasicMgrAverageIncomePayList", method = RequestMethod.POST )
	public ModelAndView getSepCalcBasicMgrAverageIncomePayList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> titles = new ArrayList<Serializable>();
		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			// 퇴직금기본내역 평균임금TAB 급여 항목리스트 조회
			titleList = sepCalcBasicMgrService.getSepCalcBasicMgrAverageIncomePayTitleList(paramMap);

			for(int i = 0 ; i < titleList.size() ; i++){
				mapElement = new HashMap<String, String>();
				Map<String, String> map = (Map)titleList.get(i);
				mapElement.put("elementCd", map.get("elementCd").toString());
				titles.add(mapElement);
				paramMap.put("titles", titles);
			}

			list = sepCalcBasicMgrService.getSepCalcBasicMgrAverageIncomePayList(paramMap);
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
	 * 퇴직금기본내역 평균임금TAB 상여 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcBasicMgrAverageIncomeBonusList", method = RequestMethod.POST )
	public ModelAndView getSepCalcBasicMgrAverageIncomeBonusList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepCalcBasicMgrService.getSepCalcBasicMgrAverageIncomeBonusList(paramMap);
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
	 * 퇴직금기본내역 평균임금TAB 연차 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcBasicMgrAverageIncomeAnnualList", method = RequestMethod.POST )
	public ModelAndView getSepCalcBasicMgrAverageIncomeAnnualList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepCalcBasicMgrService.getSepCalcBasicMgrAverageIncomeAnnualList(paramMap);
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
	 * 퇴직금기본내역 평균임금TAB 퇴직금계산내역 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcBasicMgrSeverancePayMap", method = RequestMethod.POST )
	public ModelAndView getSepCalcBasicMgrSeverancePayMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = sepCalcBasicMgrService.getSepCalcBasicMgrSeverancePayMap(paramMap);
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
	 * 퇴직금기본내역 퇴직금계산내역TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcBasicMgrSeverancePayCalcList", method = RequestMethod.POST )
	public ModelAndView getSepCalcBasicMgrSeverancePayCalcList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepCalcBasicMgrService.getSepCalcBasicMgrSeverancePayCalcList(paramMap);
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
	 * 퇴직금기본내역 퇴직종합정산TAB 지급내역 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcBasicMgrRetireCalcPayList", method = RequestMethod.POST )
	public ModelAndView getSepCalcBasicMgrRetireCalcPayList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepCalcBasicMgrService.getSepCalcBasicMgrRetireCalcPayList(paramMap);
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
	 * 퇴직금기본내역 퇴직종합정산TAB 공제내역 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcBasicMgrRetireCalcDeductionList", method = RequestMethod.POST )
	public ModelAndView getSepCalcBasicMgrRetireCalcDeductionList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepCalcBasicMgrService.getSepCalcBasicMgrRetireCalcDeductionList(paramMap);
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
	 * 퇴직금기본내역 전근무지사항TAB 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcBasicMgrBeforeWorkMap", method = RequestMethod.POST )
	public ModelAndView getSepCalcBasicMgrBeforeWorkMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = sepCalcBasicMgrService.getSepCalcBasicMgrBeforeWorkMap(paramMap);
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
	 * 퇴직금기본내역 IRP정보 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSepCalcBasicMgrIrpInfo", method = RequestMethod.POST )
	public ModelAndView saveSepCalcBasicMgrIrpInfo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = sepCalcBasicMgrService.saveSepCalcBasicMgrIrpInfo(paramMap);
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
	 * 퇴직금기본내역 평균임금TAB 급여 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSepCalcBasicMgrAverageIncomePay", method = RequestMethod.POST )
	public ModelAndView saveSepCalcBasicMgrAverageIncomePay(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map> mergeList = (List<Map>)convertMap.get("mergeRows");

		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("PAY_ACTION_CD",mp.get("payActionCd"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupMap.put("CAL_FYMD",mp.get("calFymd"));
			dupList.add(dupMap);
		}

		List<Serializable> elementInfo = new ArrayList<Serializable>();

		for(Map<String,Object> mp : mergeList) {
			Map<String,Object> mergeMap = new HashMap<String,Object>();

			String[] detailElementCdList = mp.get("detailElementCd").toString().split(",");
			String[] detailMonList = mp.get("detailMon").toString().split(",");

			HashMap<String, String> map = null;

			Log.Debug("detailElementCdList.length      => ["+detailElementCdList.length+"]");

			for(int i = 0 ; i < detailElementCdList.length ; i++) {
				map = new HashMap<String, String>();
				map.put("payActionCd", mp.get("payActionCd").toString());
				map.put("sabun", mp.get("sabun").toString());
				map.put("calFymd", mp.get("calFymd").toString());
				map.put("elementCd", detailElementCdList[i]);
				map.put("mon", detailMonList[i]);

				elementInfo.add(map);
			}
		}
		convertMap.put("elementInfo", elementInfo);

		String message = "";
		int resultCnt = -1;
		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN757","ENTER_CD,PAY_ACTION_CD,SABUN,CAL_FYMD","s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = sepCalcBasicMgrService.saveSepCalcBasicMgrAverageIncomePay(convertMap);
				if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			}
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
	 * 퇴직금기본내역 평균임금TAB 상여 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSepCalcBasicMgrAverageIncomeBonus", method = RequestMethod.POST )
	public ModelAndView saveSepCalcBasicMgrAverageIncomeBonus(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = sepCalcBasicMgrService.saveSepCalcBasicMgrAverageIncomeBonus(convertMap);
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
	 * 퇴직금기본내역 평균임금TAB 연차 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSepCalcBasicMgrAverageIncomeAnnual", method = RequestMethod.POST )
	public ModelAndView saveSepCalcBasicMgrAverageIncomeAnnual(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = sepCalcBasicMgrService.saveSepCalcBasicMgrAverageIncomeAnnual(convertMap);
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
	 * 퇴직금재계산
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_SEP_PAY_MAIN", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_SEP_PAY_MAIN(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map map = sepCalcBasicMgrService.prcP_CPN_SEP_PAY_MAIN(paramMap);

		Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", "0");

		if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
			resultMap.put("Code", map.get("sqlcode").toString());
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			} else {
				resultMap.put("Message", "퇴직금재계산 오류입니다.");
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}
}