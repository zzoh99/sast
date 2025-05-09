package com.hr.hrm.other.empPictureChangeMgr;

import com.hr.common.logger.Log;
import com.hr.common.mail.CommonMailController;
import com.hr.common.upload.outerTry.OuterTryService;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.PropertyResourceUtil;
import com.hr.common.util.StringUtil;
import com.hr.common.util.fileupload.impl.FileHandlerFactory;
import com.hr.common.util.fileupload.impl.IFileHandler;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.*;


@Controller
@SuppressWarnings("unchecked")
@RequestMapping({"EmpPictureChangeMgr.do","/PsnalBasicInf.do"})
public class EmpPictureChangeMgrController {

	@Inject
	@Named("EmpPictureChangeMgrService")
	private EmpPictureChangeMgrService empPictureChangeMgrService;

	@Autowired
	private CommonMailController commonMailController;
	
	@Inject
	@Named("OuterTryService")
	private OuterTryService outerTryService;
	
	/**
	 *
	 *
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpPictureChangeMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpPictureChangeMgr(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		return "hrm/other/empPictureChangeMgr/empPictureChangeMgr";
	}

	/**
	 * 신청내역 (로그인한 사용자의 신청내역)
	 *
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpPictureChangeLst", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewEmpInfoChangeLst(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("hrm/other/empPictureChangeMgr/empPictureChangeMgr");
		mv.addObject("cmd", "viewEmpPictureChangeLst");
		Log.DebugEnd();

		return mv;
	}

	/**
	 *
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpPictureChangeMgrList", method = RequestMethod.POST )
	public ModelAndView getEmpPictureChangeMgrList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		List<?> result = empPictureChangeMgrService.getEmpPictureChangeMgrList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;

	}
	@RequestMapping(params="cmd=saveEmpPictureChangeMgr", method = RequestMethod.POST )
	public ModelAndView saveEmpPictureChangeMgr(HttpSession session,
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		int resultCnt = -1;
		String message = "";
		Log.DebugStart();
		
		try {
			Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
			convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
			convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
			paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
			paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

			//삭제 처리
			List<Map<String, Object>> deleteRows =  (List<Map<String, Object>>) convertMap.get("deleteRows");
			if(deleteRows.size()>0){
				IFileHandler fileHandler = FileHandlerFactory.getFileHandler("pht003", request, response);
				fileHandler.delete();
				
				resultCnt = empPictureChangeMgrService.deleteEmpPictureChangeMgr(convertMap);//delete 805
				if(resultCnt>0) resultCnt = empPictureChangeMgrService.deleteEmpPictureChangeEmp(convertMap); //delete 911_emp
			}

			//반영 처리
			List<Map<String, Object>> mergeRows =  (List<Map<String, Object>>) convertMap.get("mergeRows");
			if(mergeRows.size()>0){
				for(Map<String, Object> map : mergeRows ){
					String applStatusCd = (String) map.get("applStatusCd");
					String applStatusCdTmp = (String) map.get("applStatusCdTmp");
					map.put("newPictureFilename", "");
					if(applStatusCdTmp.equals("1") && applStatusCd.equals("2")){
						
						String[] fileSeqs = { (String) map.get("fileSeq") };
						String[] seqNos = { (String) map.get("seqNo") };

						IFileHandler fileHandler = FileHandlerFactory.getFileHandler("pht003", request, response);
						JSONArray jArr = fileHandler.copy("pht001", fileSeqs, seqNos);
						
						JSONObject jObj = jArr.getJSONObject(0);
						map.put("fileSeq", jObj.get("fileSeq"));
						map.put("seqNo", jObj.get("seqNo"));
					}
					if(applStatusCd.equals("2") || applStatusCd.equals("3")) {
						Log.Debug("send mail start================>");
						// 알림 전송 시작
						Map <String, Object> chgItems = null;
						/*
						// 타이틀 변경 데이터 입력
						chgItems = new ArrayList<Map<String,Object>>();
						sendMap.put("titleChagne", chgItems);
						 */
						// 메일 내용 변경 데이터 입력
						
						chgItems = new HashMap<String, Object>();
						if(applStatusCd.equals("2")) {
							chgItems.put("#CHG_STATUS#", "반영");
						} else if(applStatusCd.equals("3")) {
							chgItems.put("#CHG_STATUS#", "반려");
						}
						
						String ctx = StringUtil.getBaseUrl(request);
						chgItems.put("#URL#"  , ctx);
						chgItems.put("#PATH#"  , "인사관리>사원정보관리>사원이미지변경신청내역");
						chgItems.put("#CHG_ITEM#"  , "사진");
						chgItems.put("#CHG_ACTION#", "수정 신청");
						chgItems.put("#SABUN#"     , map.get("sabun"));
						chgItems.put("#NAME#"      , map.get("name"));

						paramMap.put("ssnSabun", map.get("sabun"));
						paramMap.put("ssnName", map.get("sabun"));
						paramMap.put("contentsChange", chgItems);
						paramMap.put("bizCd", "HRM_P_COM");
						
						String gwMsg = "사원 이미지 변경신청이 " + chgItems.get("#CHG_STATUS#") + "되었습니다.\n인사 정보 시스템의 '" + chgItems.get("#PATH#") + "'에서 확인 해 주세요.";
						paramMap.put("gwMsg", gwMsg);
						
						message = commonMailController.sendAlarmOnComPersonalInfo(session, request, paramMap);
					}
					paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
					//805 update
					int updateCnt = empPictureChangeMgrService.insertEmpPictureChangeReq(convertMap);
					
					//911 update
					if(!applStatusCd.equals("3")){
						if(updateCnt>0) resultCnt += empPictureChangeMgrService.updateEmpPicture(convertMap);
					}
				}
				if(message.equals("") && resultCnt > 0) {
					message="저장 되었습니다.";
				}
			}
		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
			throw e;
//			resultCnt = -1;
//			message = e.getMessage();
		}
		
		//if(!paramMap.get("applStatusCd").equals(paramMap.get("applStatusCdTmp")) && "".equals())
		//1. 파일 move
		//2. 911_emp update
		//2. 911 update
		//3. 805 update


		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;

	}
	
	@RequestMapping(params="cmd=saveEmpPictureChangeReq", method = RequestMethod.POST )
	public ModelAndView saveEmpPictureChangeReq(HttpSession session,
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		int resultCnt = -1;
		String message = "";

		Log.DebugStart();

		Map<String, Object> convertMap = new HashMap<String, Object>();
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		String utype = (String) paramMap.get("utype");
		//String ssnEnterCd = (String) session.getAttribute("ssnEnterCd");
		String fileName = (String) paramMap.get("filename");
		fileName = fileName.toLowerCase();//소문자로 수정(저장시 확장자를 소문자로 수정함)
		try{
			if(fileName == null) throw new Exception();
			if(utype == null) utype = "applpicture";

			//1. appl_seq select
			Map<String,Object> seqMap = (Map<String, Object>) empPictureChangeMgrService.getEmpPictureChangeSeq(paramMap);
			if(seqMap == null) {
				seqMap = new HashMap<String, Object>();
			}
			paramMap.put("applSeq", seqMap.get("applSeq"));

			//2. insert 805
			List<Map<String, Object>> mergeRows = new ArrayList<Map<String, Object>>();
			mergeRows.add(paramMap);
			convertMap.put("mergeRows", mergeRows);
			resultCnt = empPictureChangeMgrService.insertEmpPictureChangeReq(convertMap);
			//3. insert 911_hist
			
			mergeRows = new ArrayList<Map<String, Object>>();
			convertMap = new HashMap<String, Object>();
			
			paramMap.put("abCd", "AFT");
			mergeRows.add(paramMap);
			
			Map<?, ?> result = empPictureChangeMgrService.getEmpPictureChangeMgrBeforeTHRM911(paramMap);

			if ( result != null ) {
				
				String filePath = (String) result.get("filePath");
				String sFileNm = (String) result.get("sFileNm");
				
				if ( !"".equals(filePath) && !"".equals(sFileNm) ) {
					
					//String path  =  request.getSession().getServletContext().getRealPath("/")+"hrfile" + File.separator + session.getAttribute("ssnEnterCd") + filePath + File.separator + sFileNm;
					String path = PropertyResourceUtil.getHrfilePath(request) + File.separator + session.getAttribute("ssnEnterCd") + filePath + File.separator + sFileNm;
					File file = new File(path);
					
					if ( file.isFile()) {
						
						Map<String, Object> paramMap2 = new HashMap<String, Object>();
						
						paramMap2.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
						paramMap2.put("applSeq", seqMap.get("applSeq"));
						paramMap2.put("sabun", paramMap.get("sabun"));
						paramMap2.put("imageType", "1");
						paramMap2.put("filename", "");
						paramMap2.put("abCd", "BEF");
						String[] fileSeqs = { String.valueOf(result.get("fileSeq")) };
						String[] seqNos = { String.valueOf(result.get("seqNo")) };
						IFileHandler fileHandler = FileHandlerFactory.getFileHandler("pht001", request, response);
						JSONArray jArr = fileHandler.copy("pht003", fileSeqs, seqNos);
						JSONObject jObj = jArr.getJSONObject(0);
						paramMap2.put("fileSeq", jObj.get("fileSeq"));
						paramMap2.put("seqNo", jObj.get("seqNo"));
						mergeRows.add(paramMap2);
					}
					
					
				}
				
			}

			
			convertMap.put("mergeRows", mergeRows);
			

			if(resultCnt>0) resultCnt = empPictureChangeMgrService.insertEmpPictureChangeHist(convertMap);

			if(resultCnt > 0){ 
				
				Map <String, Object> chgItems = null;
				/*
				// 타이틀 변경 데이터 입력
				chgItems = new ArrayList<Map<String,Object>>();
				sendMap.put("titleChagne", chgItems);
				 */
				// 메일 내용 변경 데이터 입력
				
				chgItems = new HashMap<String, Object>();
				String ctx = StringUtil.getBaseUrl(request);
				Log.Debug("request.getContextPath()::= :===>"+ctx);
				
				chgItems.put("#URL#"  , ctx);
				chgItems.put("#PATH#"  , "인사관리>사원정보변경>사원이미지변경신청관리");
				chgItems.put("#CHG_ITEM#"  , "사진");
				chgItems.put("#CHG_ACTION#", "수정 신청");
				chgItems.put("#SABUN#"     , paramMap.get("sabun"));
				chgItems.put("#NAME#"      , paramMap.get("name"));
				
				paramMap.put("searchEnterCd", session.getAttribute("ssnEnterCd"));
				paramMap.put("contentsChange", chgItems);
				paramMap.put("bizCd", "HRM_P_CHG");
				
				String gwMsg = "사원 이미지 변경신청이 있습니다.\n인사 정보 시스템의 '" + chgItems.get("#PATH#") + "'에서 확인 해 주세요.";
				paramMap.put("gwMsg", gwMsg);
				
				message = commonMailController.sendAlarmOnChgPersonalInfo(session, request, paramMap);
				
				if(message.equals("")) {
					message="저장 되었습니다.";
				}
				
			} else{ message="저장된 내용이 없습니다."; }


			
			//4. 원본 삭제
//			deleteFile(fromPath, fileName);

		}catch(Exception e){
			Log.Debug("e : " + e);
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
	 * 신청내역 상세조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpPictureChangeMgrDupChk", method = RequestMethod.POST )
	public ModelAndView getEmpPictureChangeMgrDupChk(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		Map<String, Object> map  = (Map<String, Object>) empPictureChangeMgrService.getEmpPictureChangeMgrDupChk(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		Log.DebugEnd();
		return mv;
		
	}

	private String getTimeStemp() throws NoSuchAlgorithmException {
		Random ranGet = SecureRandom.getInstance("SHA1PRNG");//new Random();
		ranGet.setSeed(new Date().getTime());

		String rtnStr = ranGet.nextDouble()+ "";
		rtnStr = rtnStr.substring(2);
		return rtnStr;
	}

}
