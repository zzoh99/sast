package com.hr.tim.status.timeCardMgrTeam;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.tika.Tika;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.PropertyResourceUtil;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import com.hr.common.util.securePath.SecurePathUtil;
import java.nio.file.Path;

/**
 * TimeCard관리 Controller
 *
 * @author jcy
 *
 */
@Controller
@RequestMapping(value="/TimeCardMgrTeam.do", method=RequestMethod.POST )
public class TimeCardMgrTeamController {
	/**
	 * TimeCard관리 서비스
	 */
	@Inject
	@Named("TimeCardMgrTeamService")
	private TimeCardMgrTeamService timeCardMgrTeamService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * TimeCard관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTimeCardMgrTeam", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTimeCardMgrTeam() throws Exception {
		return "tim/status/timeCardMgrTeam/timeCardMgrTeam";
	}

	/**
	 * TimeCard 일근태 생성 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTimeCardMgrTeamPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTimeCardMgrTeamPop() throws Exception {
		return "tim/status/timeCardMgrTeam/timeCardMgrTeamPop";
	}

	/**
	 * TimeCard text 젤텍 popup excel 업로드 관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTimeCardMgrTeamPopEXCEL", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTimeCardMgrTeamPopEXCEL() throws Exception {
		return "tim/status/timeCardMgrTeam/timeCardMgrTeamPopEXCEL";
	}

	/**
	 * TimeCard text 서흥 popup dat(text) 업로드 관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTimeCardMgrTeamPopTXT", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTimeCardMgrTeamPopTXT() throws Exception {
		return "tim/status/timeCardMgrTeam/timeCardMgrTeamPopTXT";
	}

	@RequestMapping(params="cmd=upload", method = RequestMethod.POST )
	public ModelAndView upload(HttpSession session, HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap)  throws Exception{

		String ssnEnterCd = (String) session.getAttribute("ssnEnterCd");
		String ssnSabun = (String) session.getAttribute("ssnSabun");

		String basePath = PropertyResourceUtil.getHrfilePath(request);
		
		// 안전한 경로 생성
		Path securePath = SecurePathUtil.getSecurePath(basePath, ssnEnterCd, "tim", ssnSabun);
		String rPath = securePath.toString();

		Log.Debug("File Upload Path : " + rPath);

		// 안전한 디렉토리 생성
		SecurePathUtil.createSecureDirectory(basePath, rPath);

		try {
			File df = new File(rPath);
			File[] destroy = df.listFiles();
			if (destroy != null) {
				for(File des : destroy) {
					Log.Debug("delete file list : " + des.getPath());
					des.delete();
				}
			}
		} catch(Exception e) {
			Log.Debug(e.getMessage());
		}

		int sizeLimit = 50 * 1024 * 1024 ;

		int resultCnt = -1;
		String message = "";

		try {
			MultipartRequest multi = new MultipartRequest(request, rPath, sizeLimit, "UTF-8", new DefaultFileRenamePolicy());
			String fileName = multi.getOriginalFileName("inputFile");
			
			// 파일명 검증
			fileName = SecurePathUtil.sanitizeFileName(fileName);
			Path destPath = SecurePathUtil.getSecurePath(rPath, fileName);
			File destFile = new File(destPath.toString());

			Log.Debug("create file : " + destPath.toString());

		} catch(IOException e) {
			resultCnt = -1; 
			message = "업로드에 실패하였습니다.";
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

	@RequestMapping(params="cmd=textUpload", method = RequestMethod.POST )
	public ModelAndView textUpload(HttpSession session, HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap)  throws Exception{

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSearchType", session.getAttribute("ssnSearchType"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));

		String ssnEnterCd = (String) session.getAttribute("ssnEnterCd");
		String ssnSabun = (String) session.getAttribute("ssnSabun");

		String textFile = (String) paramMap.get("file");
		
		// 파일명 검증
		textFile = SecurePathUtil.sanitizeFileName(textFile);
		
		String basePath = PropertyResourceUtil.getHrfilePath(request);
		Path securePath = SecurePathUtil.getSecurePath(basePath, ssnEnterCd, "tim", ssnSabun, textFile);
		String rPath = securePath.toString();

		paramMap.put("rPath", rPath);
		Log.Debug("rpath : " + rPath);

		File destFile = new File(rPath);

		Tika tika = new Tika();
		String fileType = tika.detect(destFile);

		Log.Debug("fileType : " + fileType);

		String ext =textFile.substring(textFile.lastIndexOf(".")+1).toUpperCase();

		boolean isImage = false;
		String[] mtList = {"text/plain"};

		int resultCnt = -1;
		String message = "";

		try{

			if ( "DAT".equals(ext) ){
				for( String str : mtList){
					if( fileType.equals(str) ){
						isImage = true;
						break;
					}
				}
			}

			if ( !isImage ){
				Map<String, Object> resultMap = new HashMap<String, Object>();
				resultMap.put("Code", resultCnt);
				resultMap.put("Message", "올바른 파일 형식이 아닙니다.");
				ModelAndView mv = new ModelAndView();
				mv.setViewName("jsonView");
				mv.addObject("Result", resultMap);
				return mv;
			}

			if(textFile==null || textFile.isEmpty()){
				Map<String, Object> resultMap = new HashMap<String, Object>();
				resultMap.put("Code", resultCnt);
				resultMap.put("Message", "DAT 파일을 선택 해 주세요.");
				ModelAndView mv = new ModelAndView();
				mv.setViewName("jsonView");
				mv.addObject("Result", resultMap);
				return mv;
			}

			if(!destFile.exists()) {
				Map<String, Object> resultMap = new HashMap<String, Object>();
				resultMap.put("Code", resultCnt);
				resultMap.put("Message", "파일이 존재하지 않습니다.");
				ModelAndView mv = new ModelAndView();
				mv.setViewName("jsonView");
				mv.addObject("Result", resultMap);
				return mv;
			}

			resultCnt = timeCardMgrTeamService.textUpload(paramMap);

			Log.Debug("resultCnt : " + resultCnt);

			if(resultCnt > 0){ message="업로드 되었습니다."; } else{ message="업로드된 내용이 없습니다."; }

		}catch(IOException e){
			resultCnt = -1; message="업로드에 실패하였습니다.";
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

	@RequestMapping(params="cmd=excelUpload", method = RequestMethod.POST )
	public ModelAndView excelUpload(HttpSession session,HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap)  throws Exception{

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSearchType", session.getAttribute("ssnSearchType"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));

		String ssnEnterCd = (String) session.getAttribute("ssnEnterCd");
		String ssnSabun = (String) session.getAttribute("ssnSabun");

		String excelFile = (String) paramMap.get("file");
		
		// 파일명 검증
		excelFile = SecurePathUtil.sanitizeFileName(excelFile);
		
		String basePath = PropertyResourceUtil.getHrfilePath(request);
		Path securePath = SecurePathUtil.getSecurePath(basePath, ssnEnterCd, "tim", ssnSabun, excelFile);
		String rPath = securePath.toString();

		paramMap.put("rPath", rPath);


		File destFile = new File(rPath);

		Tika tika = new Tika();
		String fileType = tika.detect(destFile);

		Log.Debug("fileType : " + fileType);

		String ext =excelFile.substring(excelFile.lastIndexOf(".")+1).toUpperCase();

		boolean isImage = false;
		String[] mtList = {"application/vnd.ms-excel"};


		int resultCnt = -1;
		String message = "";

		try{

			if ( "XLS".equals(ext) || "XLSX".equals(ext)){
				for( String str : mtList){
					if( fileType.equals(str) ){
						isImage = true;
						break;
					}
				}
			}

			if ( !isImage ){
				Map<String, Object> resultMap = new HashMap<String, Object>();
				resultMap.put("Code", resultCnt);
				resultMap.put("Message", "올바른 파일 형식이 아닙니다.");
				ModelAndView mv = new ModelAndView();
				mv.setViewName("jsonView");
				mv.addObject("Result", resultMap);
				return mv;
			}

			if(excelFile==null || excelFile.isEmpty()){
				Map<String, Object> resultMap = new HashMap<String, Object>();
				resultMap.put("Code", resultCnt);
				resultMap.put("Message", "엑셀파일을 선택 해 주세요.");
				ModelAndView mv = new ModelAndView();
				mv.setViewName("jsonView");
				mv.addObject("Result", resultMap);
				return mv;
			}

			if(!destFile.exists()) {
				Map<String, Object> resultMap = new HashMap<String, Object>();
				resultMap.put("Code", resultCnt);
				resultMap.put("Message", "파일이 존재하지 않습니다.");
				ModelAndView mv = new ModelAndView();
				mv.setViewName("jsonView");
				mv.addObject("Result", resultMap);
				return mv;
			}

			resultCnt = timeCardMgrTeamService.excelUpload(paramMap);

			Log.Debug("resultCnt : " + resultCnt);

			if(resultCnt > 0){ message="업로드 되었습니다."; } else{ message="업로드된 내용이 없습니다."; }

		}catch(IOException e){
			resultCnt = -1; message="업로드에 실패하였습니다.";
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
	 * TimeCard관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTimeCardMgrTeamList", method = RequestMethod.POST )
	public ModelAndView getTimeCardMgrTeamList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSearchType", session.getAttribute("ssnSearchType"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));

		try{
			list = timeCardMgrTeamService.getTimeCardMgrTeamList(paramMap);
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
	 * TTIM999 마감여부
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTimeCardMgrTeamCount", method = RequestMethod.POST )
	public ModelAndView getTimWorkCount(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map<?, ?> map  = new HashMap<String,Object>();
		String Message = "";
		try{
			map = timeCardMgrTeamService.getTimeCardMgrTeamCount(paramMap);

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
	 * TimeCard관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveTimeCardMgrTeam", method = RequestMethod.POST )
	public ModelAndView saveTimeCardMgrTeam(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",    convertMap.get("ssnEnterCd"));
			dupMap.put("YMD",         mp.get("ymd"));
			dupMap.put("SABUN",       mp.get("sabun"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;
		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복검사
				dupCnt = commonCodeService.getDupCnt("TTIM330", "ENTER_CD,YMD,SABUN", "s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복되어 저장할 수 없습니다.";
			} else {
				resultCnt = timeCardMgrTeamService.saveTimeCardMgrTeam(convertMap);

				/*
				List<Map> mergeList = (List<Map>)convertMap.get("mergeRows");

				for(Map<String,Object> mp : mergeList) {

					Map<String,Object> callProcMap = new HashMap<String,Object>();
					callProcMap.put("ssnSabun",   convertMap.get("ssnSabun"));
					callProcMap.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
					callProcMap.put("symd",       mp.get("ymd"));
					callProcMap.put("eymd",       mp.get("ymd"));
					callProcMap.put("sabun",      mp.get("sabun"));

					timeCardMgrTeamService.callP_TIM_WORK_HOUR_CHG_OSSTEM(callProcMap);
				}
				2014.12.17 막음
				*/

				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			}

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

	/**
	 * procP_TIM_DAILY_WORK_CRE 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=procP_TIM_DAILY_WORK_CRE", method = RequestMethod.POST )
	public ModelAndView procP_TIM_DAILY_WORK_CRE(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSearchType", session.getAttribute("ssnSearchType"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));

		Map map  ;
		Map<String, Object> resultMap = new HashMap<String, Object>();

		try{
			map = timeCardMgrTeamService.procP_TIM_DAILY_WORK_CRE(paramMap);

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

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * P_TIM_SECOM_TIME_CRE 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callP_TIM_SECOM_TIME_CRE", method = RequestMethod.POST )
	public ModelAndView callP_TIM_SECOM_TIME_CRE(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map map  ;
		map = timeCardMgrTeamService.callP_TIM_SECOM_TIME_CRE(paramMap);

		Log.Debug("obj : "+map);
		Log.Debug("sqlcode : "+map.get("sqlcode"));
		Log.Debug("sqlerrm : "+map.get("sqlerrm"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("sqlCode") != null) {
			resultMap.put("Code", map.get("sqlCode").toString());
		}
		if (map.get("sqlErrm") != null) {
			resultMap.put("Message", map.get("sqlErrm").toString());
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
	 * P_TIM_WORK_HOUR_CHG_OSSTEM 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callP_TIM_WORK_HOUR_CHG_OSSTEM", method = RequestMethod.POST )
	public ModelAndView callP_TIM_WORK_HOUR_CHG_OSSTEM(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		Map map  ;
		Map<String, Object> resultMap = new HashMap<String, Object>();

		try{
			map = timeCardMgrTeamService.callP_TIM_WORK_HOUR_CHG_OSSTEM(paramMap);
			//Log.Debug("obj : "+map);
			//Log.Debug("sqlcode : "+map.get("sqlcode"));
			//Log.Debug("sqlerrm : "+map.get("sqlerrm"));

			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			}
		} catch(Exception e){
			resultMap.put("Code", "ERROR");
			resultMap.put("Message", "처리 중 오류 발생");
			Log.Debug("timeCardMgrTeamService.callP_TIM_WORK_HOUR_CHG_OSSTEM e: "+e);
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

	private String getBrowser(HttpServletRequest request) {
		String header = request.getHeader("User-Agent");
		if (header.indexOf("MSIE") > -1) {
			return "MSIE";
		} else if (header.indexOf("Chrome") > -1) {
			return "Chrome";
		} else if (header.indexOf("Opera") > -1) {
			return "Opera";
		} else if (header.indexOf("Safari") > -1) {
			return "Safari";
		}
		return "Firefox";
	}


	/**
     * TimeCard 일괄마감 처리 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveTimeCardMgrTeamAllColse", method = RequestMethod.POST )
    public ModelAndView saveTimeCardMgrTeamAllColse(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();


        paramMap.put("ssnSabun",  session.getAttribute("ssnSabun"));
        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));


        String message = "";
        int resultCnt = -1;
        try{

                resultCnt = timeCardMgrTeamService.saveTimeCardMgrTeamAllColse(paramMap);



                if(resultCnt > 0){ message="마감처리 되었습니다."; } else{ message="마감처리된 내용이 없습니다."; }


        }catch(Exception e){
            resultCnt = -1; message="마감처리에 실패하 였습니다.";
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
