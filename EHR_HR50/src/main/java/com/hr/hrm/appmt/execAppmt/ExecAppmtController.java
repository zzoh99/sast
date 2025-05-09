package com.hr.hrm.appmt.execAppmt;
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
import com.hr.common.other.OtherService;
//import com.hr.common.sap.JcoExcute;
import com.hr.common.util.ParamUtils;
import com.hr.hrm.appmtBasic.appmtItemMapMgr.AppmtItemMapMgrService;

/**
 * 발령처리 Controller
 *
 * @author bckim
 *
 */
@Controller
@SuppressWarnings("unchecked")
@RequestMapping(value="/ExecAppmt.do", method=RequestMethod.POST )
public class ExecAppmtController {
	/**
	 * 발령처리 서비스
	 */
	@Inject
	@Named("ExecAppmtService")
	private ExecAppmtService execAppmtService;
	
	
	@Inject
	@Named("AppmtItemMapMgrService")
	private AppmtItemMapMgrService appmtItemMapMgrService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("OtherService")
	private OtherService otherService;


	/**
	 * 발령처리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewExecAppmt", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewExecAppmt() throws Exception {
		return "hrm/appmt/execAppmt/execAppmt";
	}

	/**
	 * 발령세부내역 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewExecAppmtPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewExecAppmtPop() throws Exception {
		return "hrm/appmt/execAppmt/execAppmtPop";
	}

	/**
	 * 발령처리 권한 정보 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExecAppmtAuthInfo", method = RequestMethod.POST )
	public ModelAndView getExecAppmtAuthInfo(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		Map<?, ?> map  = new HashMap<String,Object>();
		String Message = "";
		try{
			map = execAppmtService.getExecAppmtAuthInfo(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	

	/**
	 * 발령처리 다건 조회 ( 페이징有 )
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExecAppmtList", method = RequestMethod.POST )
	public ModelAndView getExecAppmtList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		paramMap.put("searchUseYn", "Y");
		// 발령항목(select문을 만들기위해 post_item을 조회)조회
		List<?> postItemList  = appmtItemMapMgrService.getAppmtItemMapMgrList(paramMap);
		paramMap.put("postItemRows", postItemList);
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = execAppmtService.getExecAppmtList(paramMap);
			Log.Debug("@@@@@@@@@@@@@@@@@@LIST@@@@@@@@@@@@@@@@@@@");
			Log.Debug(list.toString());
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
	
	@RequestMapping(params="cmd=getExecAppmtList2", method = RequestMethod.POST )
	public ModelAndView getExecAppmtList2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = execAppmtService.getExecAppmtList2(paramMap);
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
	
	
	

	/**
	 * 발령처리 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExecAppmtMap", method = RequestMethod.POST )
	public ModelAndView getExecAppmtMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		Map<?, ?> map  = new HashMap<String,Object>();
		String Message = "";
		try{
			map = execAppmtService.getExecAppmtMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 발령세부내역 팝업(발령항목) 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExecAppmtPopColumMap", method = RequestMethod.POST )
	public ModelAndView getExecAppmtPopColumMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		Map<?, ?> map  = new HashMap<String,Object>();
		String Message = "";
		try{
			map = execAppmtService.getExecAppmtPopColumMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 발령세부내역 팝업(발령전내역) 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExecAppmtPopBeforeMap", method = RequestMethod.POST )
	public ModelAndView getExecAppmtPopBeforeMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		Map<?, ?> map  = new HashMap<String,Object>();
		String Message = "";
		try{
			map = execAppmtService.getExecAppmtPopBeforeMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 발령세부내역 팝업(발령후내역) 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExecAppmtPopAfterMap", method = RequestMethod.POST )
	public ModelAndView getExecAppmtPopAfterMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		Map<?, ?> map  = new HashMap<String,Object>();
		String Message = "";
		try{
			map = execAppmtService.getExecAppmtPopAfterMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 발령 APPLY_SEQ 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExecAppmtApplySeqMap", method = RequestMethod.POST )
	public ModelAndView getExecAppmtApplySeqMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		Map<?, ?> map  = new HashMap<String,Object>();
		String Message = "";
		try{
			map = execAppmtService.getExecAppmtApplySeqMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 발령처리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveExecAppmt", method = RequestMethod.POST )
	public ModelAndView saveExecAppmt(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		// 중복체크 ( 같은일자, 같은발령은 입력할 수 없음)
		
		
		//발령처리용(THRM221)
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		//발령세부내역용 (THRM223)
		Map<String, Object> convertMap2 = ParamUtils.requestInParamsMultiDMLPost(request,paramMap.get("s_SAVENAME").toString(),paramMap.get("s_SAVENAME2").toString(),"VALUE");
		convertMap2.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap2.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = execAppmtService.saveExecAppmt(convertMap, convertMap2);
			
			//발령확정 처리
			convertMap.put("ordYn", "Y");//발령확정 건만 조회
			List<Map<?, ?>> rlist = execAppmtService.prcExecAppmtSave((List<Map<String,Object>>)execAppmtService.getExecAppmtSoredList(convertMap));
			//에러건수 count
			int errorCnt = 0;
			for(Map<?,?> m : rlist){
				Map<String,String> map = (Map<String, String>) m;
				String rMsg = map.get("rMsg");
				if(!rMsg.equals("OK")){
					errorCnt ++ ;
				}
			}
			convertMap.put("ordYn", "N");//발령확정취소 건만 조회	
			List<Map<?, ?>> rlist2 = execAppmtService.prcExecAppmtCancel((List<Map<String,Object>>)execAppmtService.getExecAppmtSoredList(convertMap));
			for(Map<?,?> m : rlist2){
				Map<String,String> map = (Map<String, String>) m;
				String rMsg = map.get("rMsg");
				if(!rMsg.equals("OK")){
					errorCnt ++ ;
				}
			}
			
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			if(errorCnt>0) message = Integer.toString(errorCnt)+"|확정 중 에러건이 있습니다.";
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하 였습니다.";
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
	
	@SuppressWarnings("unused")
	private List<Map<String,Object>> sortExecAppmt(List<Map<String,Object>> paramList) throws Exception {
		List<Map<String,Object>> sortedList = new ArrayList<Map<String,Object>>();//확정목록
		//List<Map<String,Object>> sortedCnslList = new ArrayList<Map<String,Object>>(); // 취소목록
		Integer[] order = new Integer[paramList.size()];
		for(int i=0 ; i<order.length ; i++) order[i] = -1; // 초기값 설정
		
		/*String sabun = null, ordYmd = null;
		int applySeq = -1;
		for(Map<String,Object> mp : paramList){
			if(mp == null) continue;
			if(sabun==null){
				sabun = (String)mp.get("sabun");
				ordYmd = (String)mp.get("ordYmd");
				applySeq = ((BigDecimal)mp.get("applySeq")).intValue();
			}
			
			String ordYn = (String)mp.get("ordYn");			
			if(!ordYn.equals((String)mp.get("ordYnTmp"))){
				//가발령 -> 확정 or 확정상태 -> 취소
				if(sabun.equals((String)mp.get("sabun")) && ordYmd.equals((String)mp.get("ordYmd"))){
					if(applySeq > ((BigDecimal)mp.get("applySeq")).intValue()){
						
					}
				}
				if(ordYn.equals("Y")){
					//getMinData();
				}else{
					
				}
			}
		}*/
		order[0] = 0;
		int orderInd =1;
		for(int i =0 ; i<paramList.size() ; i++){
			Map<String,Object> mp = paramList.get(i);
			for(int ii : order){
				if(ii<0)break;
				Map<String,Object> mpTmp = paramList.get(ii);
				//mpTmp 
				
			}
		}
		return sortedList;
	}

	/**
	 * 일괄발령 확정  프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcExecAppmtSave", method = RequestMethod.POST )
	public ModelAndView prcExecAppmtSave(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("searchOrdYn", "N");//확정되지 않은건
		
		//1. 발령확정처리할 목록을 조회
		//List<Map<?, ?>> list  = (List<Map<?, ?>>) execAppmtService.getExecAppmtList2(paramMap);
		execAppmtService.prcExecAppmtSave(paramMap);
		/*for(Map<String,Object> mp : list){
			mp.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
			mp.put("ssnSabun",session.getAttribute("ssnSabun"));
			//2. 확정 proc 호출
			try{
			Map map  = execAppmtService.prcExecAppmtSave(mp);
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
			}catch(Exception e){
				Log.Debug(e.toString());
			}
			
		}*/
		

		/*Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("sqlCode") != null) {
			resultMap.put("Code", map.get("sqlCode").toString());
		}
		if (map.get("sqlErrm") != null) {
			resultMap.put("Message", map.get("sqlErrm").toString());
		}*/
		
		//3.확정결과 에러갯수 조회
		paramMap.put("searchOrdYn", "N");//확정성공하지 못한 
		paramMap.put("searchErrorYn", "Y");//에러난 
		Map<?, ?> result = execAppmtService.getExecAppmtCnt(paramMap);
		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		if(result != null) {
			mv.addObject("errorCount", result.get("cnt"));
		}
		// 그리드에 맵핑 되는 데이터 이면 DATA에 담아서 보냄
		// comment 종료
		Log.DebugEnd();
		return mv;
	}

	
	/**
	 * callP_COM_SET_LOG 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callP_COM_SET_LOG", method = RequestMethod.POST )
	public ModelAndView callP_COM_SET_LOG(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<?, ?> map = execAppmtService.callP_COM_SET_LOG(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));

			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			}
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
	
	/**
	 * 가장최근발령정보 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmployeePostInfo", method = RequestMethod.POST )
	public ModelAndView getEmployeePostInfo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("ExecAppmtController.getEmployeePostInfo Start");
		
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		
		// 발령항목(select문을 만들기위해 post_item을 조회)조회
		List<?> postItemList  = (List<?>)appmtItemMapMgrService.getAppmtItemMapMgrList(paramMap);
		
		paramMap.put("postItemRows", postItemList);
		
		List<?> result = execAppmtService.getEmployeePostInfo(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.Debug("EmployeeController.getEmployeeHiddenInfo End");
		return mv;
		
	}
	
	/**
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPostItemPropList", method = RequestMethod.POST )
	public ModelAndView getPostItemPropList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("ExecAppmtController.getEmployeePostInfo Start");
		
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		
		List<?> result = execAppmtService.getPostItemPropList(paramMap);		
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.Debug("EmployeeController.getPostItemPropList End");
		return mv;
	}
	
	@RequestMapping(params="cmd=getExecAppmtCnt", method = RequestMethod.POST )
	public ModelAndView getExecAppmtCnt(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		
		Log.Debug("ExecAppmtController.getPostDetailTypeList Start");
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));

		//조회결과 총갯수		
		Map<?, ?> result = execAppmtService.getExecAppmtCnt(paramMap);
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		if(result != null) {
			mv.addObject("DATA", result.get("cnt"));
		}
		Log.Debug("EmployeeController.getPostDetailTypeList End");
		return mv;
		
	}
	
	@RequestMapping(params="cmd=getPostDetailTypeList", method = RequestMethod.POST )
	public ModelAndView getPostDetailTypeList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		
		Log.Debug("ExecAppmtController.getPostDetailTypeList Start");
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		List<?> result = execAppmtService.getPostDetailTypeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.Debug("EmployeeController.getPostDetailTypeList End");
		return mv;
		
	}
	
	@RequestMapping(params="cmd=getMaxApplySeq", method = RequestMethod.POST )
	public ModelAndView getMaxApplySeq(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("ExecAppmtController.getMaxApplySeq Start");
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		Map<String, Object> result = (Map<String, Object>) execAppmtService.getMaxApplySeq(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.Debug("EmployeeController.getMaxApplySeq End");
		return mv;
		
	}
	
	@RequestMapping(params="cmd=getPostDupChk", method = RequestMethod.POST )
	public ModelAndView getPostDupChk(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("ExecAppmtController.getPostDupChk Start");
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		Map<String, Object> result = (Map<String, Object>) execAppmtService.getPostDupChk(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.Debug("EmployeeController.getPostDupChk End");
		return mv;
		
	}
	
	@RequestMapping(params="cmd=getOrdTypeYn", method = RequestMethod.POST )
	public ModelAndView getOrdTypeYn(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("ExecAppmtController.getOrdTypeYn Start");
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		Map<String, Object> result = (Map<String, Object>) execAppmtService.getOrdTypeYn(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.Debug("EmployeeController.getOrdTypeYn End");
		return mv;
		
	}
	
	@RequestMapping(params="cmd=getMainDeptCnt", method = RequestMethod.POST )
	public ModelAndView getMainDeptCnt(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("ExecAppmtController.getMainDeptCnt Start");
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		Map<String, Object> result = (Map<String, Object>) execAppmtService.getMainDeptCnt(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.Debug("EmployeeController.getMainDeptCnt End");
		return mv;
		
	}
	
	
	@RequestMapping(params="cmd=getPunishSeq", method = RequestMethod.POST )
	public ModelAndView getPunishSeq(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("ExecAppmtController.getPunishSeq Start");
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		Map<String, Object> result = (Map<String, Object>) execAppmtService.getPunishSeq(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.Debug("EmployeeController.getPunishSeq End");
		return mv;
		
	}
	

	@RequestMapping(params="cmd=getExecAppmtMdHstListPop", method = RequestMethod.POST )
	public ModelAndView getExecAppmtMdHstListPop(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = execAppmtService.getExecAppmtMdHstListPop(paramMap);
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
	
	@RequestMapping(params="cmd=getOrdTypeStatusCd", method = RequestMethod.POST )
	public ModelAndView getOrdTypeStatusCd(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("ExecAppmtController.getOrdTypeStatusCd Start");
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		Map<String, Object> result = (Map<String, Object>) execAppmtService.getOrdTypeStatusCd(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.Debug("EmployeeController.getOrdTypeStatusCd End");
		return mv;
		
	}
	
}
