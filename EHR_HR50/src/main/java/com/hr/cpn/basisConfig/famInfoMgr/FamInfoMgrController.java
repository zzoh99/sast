package com.hr.cpn.basisConfig.famInfoMgr;
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

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 부양가족정보생성 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/FamInfoMgr.do", method=RequestMethod.POST )
public class FamInfoMgrController {
	/**
	 * 부양가족정보생성 서비스
	 */
	@Inject
	@Named("FamInfoMgrService")
	private FamInfoMgrService famInfoMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;

	/**
	 * 부양가족정보생성 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewFamInfoMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewFamInfoMgr() throws Exception {
		return "cpn/basisConfig/famInfoMgr/famInfoMgr";
	}
	/**
	 * 부양가족정보생성 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewFamInfoMgr2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewFamInfoMgr2() throws Exception {
		return "famInfoMgr/famInfoMgr";
	}
	/**
	 * 부양가족정보생성 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getFamInfoMgrList", method = RequestMethod.POST )
	public ModelAndView getFamInfoMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSearchType", 	session.getAttribute("ssnSearchType"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
			if(query != null) {
				Log.Debug("query.get=> "+ query.get("query"));
				paramMap.put("query",query.get("query"));
				list = famInfoMgrService.getFamInfoMgrList(paramMap);
			} else {
				Message="조회에 실패하였습니다.";
			}
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
	 * 부양가족정보생성 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getFamInfoMgrMap", method = RequestMethod.POST )
	public ModelAndView getFamInfoMgrMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = famInfoMgrService.getFamInfoMgrMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 부양가족정보생성 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=saveFamInfoMgr", method = RequestMethod.POST )
	public ModelAndView saveFamInfoMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<Map<String, Object>> insertList = (List<Map<String, Object>>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupMap.put("SDATE",mp.get("sdate"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN101","ENTER_CD,SABUN,SDATE","s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt =famInfoMgrService.saveFamInfoMgr(convertMap);
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
	 * 부양가족정보생성 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteFamInfoMgr", method = RequestMethod.POST )
	public ModelAndView deleteFamInfoMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sResult,sStatus,orgNm,name,sabun,statusCd,foreignYn,handicapYn,womanYn,spouseYn,familyCnt1,familyCnt2,oldCnt1,oldCnt2,handicapCnt,childCnt,addChildCnt";

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = famInfoMgrService.deleteFamInfoMgr(convertMap);
			if(resultCnt > 0){ message="삭제 되었습니다."; } else{ message="삭제된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="삭제에 실패하였습니다.";
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
	 * 부양가족정보생성 프로시져 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcFamilyInfoCreateCall", method = RequestMethod.POST )
	public ModelAndView prcFamilyInfoCreateCall(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		// 프로시져 파라미터
		Map<?, ?> map  = famInfoMgrService.prcFamilyInfoCreateCall(paramMap);
		Map<String, Object> resultMap = new HashMap<String, Object>();

//		if(Integer.parseInt(map.get("pCnt").toString()) == -1){
//
//			resultMap.put("Code", Integer.parseInt(map.get("pCnt").toString()));
//			resultMap.put("Message", "해당 년도 자료가 있습니다.");
//		}else{
//			resultMap.put("Code", Integer.parseInt(map.get("pCnt").toString()));
//			resultMap.put("Message", "자료를 복사 하였습니다.");
//		}

		if(Integer.parseInt(map.get("pCnt").toString()) < 0){
			resultMap.put("pCnt", map.get("pCnt").toString());
			resultMap.put("Code", map.get("pSqlcode").toString());
			resultMap.put("Message", "처리도중 다음과 같은 문제가 발생하였습니다.");
		}else{
			resultMap.put("pCnt", map.get("pCnt").toString());
		}


		Log.Debug("obj : "+map);
		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		// 그리드에 맵핑 되는 데이터 이면 DATA에 담아서 보냄
		// comment 종료
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 부양가족정보생성 프로시져 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=procP_CPN_FAM_UPDATE", method = RequestMethod.POST )
	public ModelAndView procP_CPN_FAM_UPDATE(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		// 프로시져 파라미터
		Map<?, ?> map  ;
		Map<String, Object> resultMap = new HashMap<String, Object>();

		try{
			map = famInfoMgrService.procP_CPN_FAM_UPDATE(paramMap);

			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}else{
				resultMap.put("Code", "");
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			}else{
				resultMap.put("Message", "생성되었습니다.");
			}
		} catch(Exception e){
			resultMap.put("Code", "ERROR");
			resultMap.put("Message", "처리 중 오류 발생");
		}

		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		// 그리드에 맵핑 되는 데이터 이면 DATA에 담아서 보냄
		// comment 종료
		Log.DebugEnd();
		return mv;
	}
}
