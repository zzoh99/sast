package com.hr.pap.appCompetency.compAppraisal;
import java.io.Serializable;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComController;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.mail.CommonMailController;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;
/**
 * 리더십진단 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/CompAppraisal.do", method=RequestMethod.POST )
public class CompAppraisalController extends ComController {
	/**
	 * 리더십진단 서비스
	 */
	@Inject
	@Named("CompAppraisalService")
	private CompAppraisalService compAppraisalService;
	
	@Autowired
	private CommonMailController commonMailController;

	/**
	 * 리더십진단 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCompAppraisal", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCompAppraisal() throws Exception {
		return "pap/appCompetency/compAppraisal/compAppraisal";
	}

	/**
	 * 리더십진단 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCompAppraisal2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCompAppraisal2() throws Exception {
		return "pap/appCompetency/compAppraisal/compAppraisal2";
	}
	
	
	/**
	 * 리더십진단 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCompAppraisal3", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCompAppraisal3() throws Exception {
		return "pap/appCompetency/compAppraisal/compAppraisal3";
	}
	

	/**
	 * 리더십진단 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCompAppraisalPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCompAppraisalPop() throws Exception {
		return "pap/appCompetency/compAppraisal/compAppraisalPop";
	}
	@RequestMapping(params="cmd=viewCompAppraisalLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCompAppraisalLayer() throws Exception {
		return "pap/appCompetency/compAppraisal/compAppraisalLayer";
	}
	
	/**
	 * 리더십진단 코멘트 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCompAppraisalCommentPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCompAppraisalCommentPop() throws Exception {
		return "pap/appCompetency/compAppraisal/compAppraisalCommentPop";
	}

	/**
	 * 리더십진단 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCompAppraisalList", method = RequestMethod.POST )
	public ModelAndView getCompAppraisalList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = compAppraisalService.getCompAppraisalList(paramMap);
		}catch(Exception e){
			e.printStackTrace();
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
	 * 리더십진단 다건 조회(부서장)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTeamCompAppraisalList", method = RequestMethod.POST )
	public ModelAndView getTeamCompAppraisalList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = compAppraisalService.getTeamCompAppraisalList(paramMap);
		}catch(Exception e){
			e.printStackTrace();
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
	 * 리더십진단  해더 조회(부서장) 그룹별 조회 한투 전용
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTeamHeaderList", method = RequestMethod.POST )
	public ModelAndView getTeamHeaderList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = compAppraisalService.getTeamHeaderList(paramMap);
		}catch(Exception e){
			e.printStackTrace();
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
	 * 리더십진단  리스트 조회(부서장) 그룹별 조회  한투 전용
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTeamList", method = RequestMethod.POST )
	public ModelAndView getTeamList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> titles = new ArrayList<Serializable>();

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			titleList = compAppraisalService.getTeamHeaderList(paramMap);
			for(int i = 0 ; i < titleList.size() ; i++){
				mapElement = new HashMap<String, String>();
				Map<String, String> map = (Map)titleList.get(i);
				mapElement.put("saveName",       map.get("saveName").toString());
				mapElement.put("saveName1",       map.get("saveName1").toString());
				mapElement.put("saveName2",       map.get("saveName2").toString());
				mapElement.put("saveNameDisp",   map.get("saveNameDisp").toString());
				mapElement.put("saveNameDisp2",   map.get("saveNameDisp2").toString());
				titles.add(mapElement);
			}
			paramMap.put("titles", titles);
			list = compAppraisalService.getTeamList(paramMap);

		}catch(Exception e){
			e.printStackTrace();
			Message=LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	

	/**
	 * 리더십진단 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCompAppraisalPopList", method = RequestMethod.POST )
	public ModelAndView getCompAppraisalPopList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = compAppraisalService.getCompAppraisalPopList(paramMap);
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
	 * 리더십진단 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCompAppraisalPopMap", method = RequestMethod.POST )
	public ModelAndView getCompAppraisalPopMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = compAppraisalService.getCompAppraisalPopMap(paramMap);
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
	
	/**
	 * 리더십진단 저장(완료여부 저장)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveCompAppraisal", method = RequestMethod.POST )
	public ModelAndView saveCompAppraisal(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		// Request에서 파싱하여 저장용도로 Param을 따로 구성
		// 파싱된 객체 목록
		// "mergeRows" 	merge문을 사용하여 update,insert를 한번에 처리하기 위한 저장 List
		// "insertRows" 생성 List
		// "updateRows" 수정 List
		// "deleteRows" 삭제 List
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =compAppraisalService.saveCompAppraisal(convertMap);
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
	 * 리더십진단 팝업상단 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveCompAppraisalPop1", method = RequestMethod.POST )
	public ModelAndView saveCompAppraisalPop1(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		// Request에서 파싱하여 저장용도로 Param을 따로 구성
		// 파싱된 객체 목록
		// "mergeRows" 	merge문을 사용하여 update,insert를 한번에 처리하기 위한 저장 List
		// "insertRows" 생성 List
		// "updateRows" 수정 List
		// "deleteRows" 삭제 List
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =compAppraisalService.saveCompAppraisalPop1(convertMap);
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
	 * 리더십진단 팝업하단 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveCompAppraisalPop2", method = RequestMethod.POST )
	public ModelAndView saveCompAppraisalPop2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =compAppraisalService.saveCompAppraisalPop2(paramMap);
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
	 * 리더십진단 팝업진단완료 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveCompAppraisalPop3", method = RequestMethod.POST )
	public ModelAndView saveCompAppraisalPop3(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =compAppraisalService.saveCompAppraisalPop3(paramMap);
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
	 * 리더십진단 코멘트팝업 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCompAppraisalCommentPopMap", method = RequestMethod.POST )
	public ModelAndView getCompAppraisalCommentPopMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = compAppraisalService.getCompAppraisalCommentPopMap(paramMap);
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
	
	/**
	 * 하위 부서 다면평가 완료여부 체크 
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCompAppraisalTeamChk", method = RequestMethod.POST )
	public ModelAndView getCompAppraisalTeamChk(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = compAppraisalService.getCompAppraisalTeamChk(paramMap);
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
	
	
	/**
	 * 리더십진단 코멘트팝업 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveCompAppraisalCommentPop", method = RequestMethod.POST )
	public ModelAndView saveCompAppraisalCommentPop(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = compAppraisalService.saveCompAppraisalCommentPop(paramMap);
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
	 * 다면평가 알림메일 전송
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=sendMailCompAppraisal", method = RequestMethod.POST )
	public ModelAndView sendMailCompAppraisal(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		//comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = 0;
		try{
			//회사정보 및 진단명정보 불러오기
			Map<String, Object> compMap = compAppraisalService.getCompAppraisalCdMap(paramMap);
			
			Map<String, Object> chgItems = null; //메일내용데이터 Map
			Map<String, Object> mailInfoMap = null; //수신대상자 메일정보 Map
			// 메일 내용 변경 데이터 입력
			String senderNm = String.valueOf(session.getAttribute("ssnName"));
			String content1 = compMap.get("appSYmd") + " ~ " + compMap.get("appEYmd");
			Log.Debug("senderNm==>"+senderNm);
			
			paramMap.put("searchEnterCd", session.getAttribute("ssnEnterCd"));
			paramMap.put("bizCd", "COMP");
			
			if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
				List<Map<String, Object>> list = (List<Map<String, Object>>)convertMap.get("mergeRows");
				for(Map<String, Object> map : list ) {
					chgItems = new HashMap<String, Object>();
					
					chgItems.put("#CONTENT_TITLE1#", compMap.get("compAppraisalNm")); //리더십진단명
					chgItems.put("#CONTENT1#"	  , content1);						 //교육회차
					
					chgItems.put("#CONTENT2#"     , compMap.get("compAppraisalNm") + "_" + map.get("appSeqNm") + "평가");			 //차수명
					chgItems.put("#CONTENT3#"     , map.get("name"));				 //평가대상자
					
					chgItems.put("#CORP#"     	  , compMap.get("enterEngNm"));		 //회사명
					
					//평가자 메일정보 불러오기
					map.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
					mailInfoMap = compAppraisalService.getCompAppraisalMailInfoMap(map);
					
					paramMap.put("contentsChange", chgItems);
					
					String receverStr = "";
					if(mailInfoMap.get("contAddress") != null) {
						receverStr = mailInfoMap.get("contAddress")+";"+map.get("appName");
						
						//TODO: 아래줄은 임시 메일, 추후 삭제 필요
						//receverStr = "hyunjoon.kim@isu.co.kr;김현준";
						
						if(receverStr != null && !"".equals(receverStr)) {
							paramMap.put("receverStr", receverStr);
							resultCnt++;
							commonMailController.callMailType6(session, request, paramMap);
						}
					}
				}
			}
			
			if(resultCnt > 0){ 
				message="알림메일이 전송 되었습니다.";
			} else{ 
				message="전송된 내용이 없습니다."; 
			}
			
		}catch(Exception e){
 			resultCnt = -1; message="전송에 실패하였습니다.";
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
