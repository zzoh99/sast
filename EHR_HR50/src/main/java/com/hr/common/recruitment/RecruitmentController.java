package com.hr.common.recruitment;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.logger.Log;
import com.hr.main.login.LoginService;
import org.json.JSONArray;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.MessageDigest;
import java.security.cert.CertificateException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 *  채용
 *
 * @author kwook
 *
 */
@Controller

public class RecruitmentController {

	@Inject
	@Named("LoginService")
	private LoginService loginService;

	@Inject
	@Named("RecruitmentService")
	private RecruitmentService recruitmentService;

	/*AuthTable */
	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;
	
	/**
	 * 채용시스템_로그인
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/RemLogin.do", method = RequestMethod.POST, consumes = "application/json; charset=UTF-8", produces = "application/json; charset=UTF-8")
	public @ResponseBody ModelAndView remLogin(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		try {
			// 회사코드 들어오는 지 확인
			if(!paramMap.containsKey("companyCd") || paramMap.get("companyCd") == null) {
				throw new IllegalArgumentException("companyCd가 들어오지 않습니다.");
			}
			
			// loginId 들어오는 지 확인
			if(!paramMap.containsKey("loginId") || paramMap.get("loginId") == null) {
				throw new IllegalArgumentException("loginId가 들어오지 않습니다.");
			}
			
			// password 들어오는 지 확인
			if(!paramMap.containsKey("password") || paramMap.get("password") == null) {
				throw new IllegalArgumentException("password가 들어오지 않습니다.");
			}
			
			Map<String, Object> paramObj = new HashMap<String, Object>();
			paramObj.put("loginEnterCd", paramMap.get("companyCd").toString());
			paramObj.put("loginUserId", paramMap.get("loginId").toString());
			paramObj.put("loginPassword", paramMap.get("password").toString());
			
			Map<String, String> loginTryCntMap = (Map<String, String>) loginService.loginTryCnt(paramObj);
			
			/**
			 * 해당 ID가 존재 하지 않음
			 */
			if ("N".equals(loginTryCntMap.get("idExst"))) {
				mv.addObject("isUser", "notExist");
				mv.addObject("message", "존재하지 않는 아이디입니다.");
				Log.DebugEnd();
				return mv;
			}
			/**
			 * ID가 잠김
			 */
			if ("Y".equals(loginTryCntMap.get("rockingYn"))) {
				mv.addObject("isUser", "rocking");
				mv.addObject("message", "아이디가 잠금상태입니다. 인사담당자에게 문의하세요.");
				Log.DebugEnd();
				return mv;
			}

			/**
			 * 로그인 실패 횟수 Over
			 */
			if ("Y".equals(loginTryCntMap.get("loginFailCntYn"))) {
				mv.addObject("isUser", "cntOver");
				mv.addObject("message", "로그인 실패횟수를 초과하였습니다. 인사담당자에게 문의하세요.");
				Log.DebugEnd();
				return mv;
			}

			/**
			 * 비밀번호가 틀림
			 */
			if ("Y".equals(loginTryCntMap.get("pswdClct"))) {
				int loginFailCnt = Integer.parseInt(loginTryCntMap.get("loginFailCnt") == null ? "" : String.valueOf(loginTryCntMap.get("loginFailCnt"))); // 로그인 실패 횟수
				paramObj.put("loginFailCnt", loginFailCnt);
				mv.addObject("isUser", "notMatch");
				mv.addObject("message", "비밀번호가 일치하지 않습니다.");
				mv.addObject("loginFailCntStd", loginTryCntMap.get("loginFailCntStd"));
				mv.addObject("loginFailCnt", loginFailCnt + 1);
				Log.DebugEnd();
				return mv;
			}

			Map<String, String> loginUserMap = (Map<String, String>) loginService.loginUser(paramObj);

	  		/**
	  		 * 사용자 정보가 없음
	  		 */
	  		if (loginUserMap == null || loginUserMap.size() == 0) {
	  			mv.addObject("isUser", "notExist");
	            mv.addObject("message", "존재하지 않는 아이디입니다.");
	    		Log.DebugEnd();
	    		return mv;
	  		} else {
	  			paramObj.put("ssnEnterCd", loginUserMap.get("ssnEnterCd"));
	  			paramObj.put("ssnSabun", loginUserMap.get("ssnSabun"));
	  			loginUserMap.put("empKey", loginUserMap.get("ssnEnterCd") + "@" + loginUserMap.get("ssnSabun"));
	  		}
	  	
	  		mv.addObject("isUser", "exist");
	  		mv.addObject("message", "");
	  		mv.addObject("empKey", loginUserMap.get("ssnEnterCd") + "@" + loginUserMap.get("ssnSabun"));
	  		mv.addObject("userData", loginUserMap);
			
		} catch (IllegalArgumentException ex) {
			//ex.printStackTrace();
			mv.addObject("message", "회사인증에 실패하였습니다. 관리자에게 문의하세요.");
			Log.Debug(" * remLogin Exception 발생 : " + ex.getMessage());
		} catch (Exception ex) {
			//ex.printStackTrace();
			mv.addObject("message", ex.getMessage());
			Log.Debug(" * remLogin Exception 발생 : " + ex.getMessage());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 채용시스템_임직원 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/RemEmployeeList.do", method = RequestMethod.GET)
	public ModelAndView getRemEmployeeList(
			HttpSession session, HttpServletRequest request,
			@RequestParam String apiKey, 
			@RequestParam String searchWord, 
			@RequestParam String secret,
			@RequestParam String locale,
			@RequestParam String targetUserKey,
			@RequestParam String userKey) throws Exception {
		Log.DebugStart();
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		Map<String, Object> paramObj = new HashMap<String, Object>();
		
		try {
			if(userKey == null || "".equals(userKey)) {
				throw new IllegalArgumentException("userKey가 없습니다.");
			} else if(userKey.toString().indexOf("@") < 0) {
				throw new IllegalArgumentException("userKey가 잘못넘어옵니다.  (@가 존재하지 않음.)");
			}
			
			if(apiKey == null || "".equals(apiKey)) {
				throw new IllegalArgumentException("apiKey가 없습니다.");
			}
			
			if(secret == null || "".equals(secret)) {
				throw new IllegalArgumentException("secret이 없습니다.");
			}
			
			String[] userKeyArr = userKey.toString().split("@");
			if(userKeyArr.length != 2) {
				throw new IllegalArgumentException("userKey가 잘못넘어옵니다. (@로 나눴을때 갯수가 이상함)");
			}
			
			Map<String, Object> paramMap = new HashMap<String, Object>();
			
			String enterCd = userKeyArr[0];
			String sabun = userKeyArr[1];
			
			paramMap.put("ssnEnterCd", enterCd);
			paramMap.put("ssnSabun", sabun);
			
			paramObj.put("ssnEnterCd", enterCd);
			paramObj.put("ssnSabun", sabun);
			
			// apiKey를 시스템 코드에서 가져오기
			Map<String, Object> codeParams = new HashMap<String, Object>();
			codeParams.put("queryId", "getSystemStdData");
			codeParams.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			codeParams.put("searchStdCd", "HR_API.API_KEY");
			codeParams.put("searchBizCd", "11");
			Map<?, ?> stdCdMap = recruitmentService.getSystemStdCdValue(codeParams);
			if(stdCdMap == null || stdCdMap.get("codeNm") == null || "".equals(stdCdMap.get("codeNm"))) {
				throw new NullPointerException("시스템 관리 코드의 apiKey가 존재하지 않습니다.");
			}
			
			if(!stdCdMap.get("codeNm").toString().equals(apiKey)) {
				throw new CertificateException("apiKey 인증에 실패하였습니다.");
			}
			
			codeParams.put("searchStdCd", "HR_API.SECRET");
			stdCdMap = recruitmentService.getSystemStdCdValue(codeParams);
			if(stdCdMap == null || stdCdMap.get("codeNm") == null || "".equals(stdCdMap.get("codeNm"))) {
				throw new NullPointerException("시스템 관리 코드의 secret이 존재하지 않습니다.");
			}
			
			MessageDigest dig = MessageDigest.getInstance("SHA-256");
			byte[] hash = dig.digest(secret.toString().getBytes("UTF-8"));
			StringBuffer hexStr = new StringBuffer();
			
			for(int i = 0 ; i < hash.length ; i++) {
				String hex = Integer.toHexString(0xff & hash[i]);
				if(hex.length() == 1) hexStr.append('0');
				hexStr.append(hex);
			}
			
			Log.Debug(" * codeNm : " + stdCdMap.get("codeNm").toString());
			Log.Debug(" * hexStr : " + hexStr.toString());
			
			if(!stdCdMap.get("codeNm").toString().toUpperCase().equals(hexStr.toString().toUpperCase())) {
				throw new CertificateException("secret 인증에 실패하였습니다.");
			}

			List<?> athGrpList = loginService.getAuthGrpList(paramMap);
			if(athGrpList == null || athGrpList.isEmpty()) {
				throw new Exception("사용자 권한이 없습니다.");
			}
			
			if(athGrpList.get(0) instanceof Map) {
				@SuppressWarnings("unchecked")
				Map<String, Object> athGrpMap = (Map<String, Object>) athGrpList.get(0);
				if(!athGrpMap.containsKey("ssnGrpCd") || athGrpMap.get("ssnGrpCd") == null) {
					throw new Exception("권한그룹 코드가 존재하지 않습니다.");
				}
				
				if(!athGrpMap.containsKey("ssnSearchType") || athGrpMap.get("ssnSearchType") == null) {
					throw new Exception("권한그룹 검색타입이 존재하지 않습니다.");
				}
				
				paramObj.put("ssnGrpCd", athGrpMap.get("ssnGrpCd").toString());
				paramObj.put("ssnSearchType", athGrpMap.get("ssnSearchType").toString());
			}
			
			if(targetUserKey != null && !"".equals(targetUserKey)) {
				JSONArray targetUserKeyArr = new JSONArray(targetUserKey);
				
				List<Object> tList = new ArrayList<Object>();
				for(int i = 0 ; i < targetUserKeyArr.length() ; i++) {
					tList.add(targetUserKeyArr.get(i));
				}
				
				if(!tList.isEmpty()) {
					List<String> tk = new ArrayList<>();

					for(int i = 0 ; i < tList.size() ; i++) {
						tk.add(tList.get(i).toString());
					}

					/*
					String targetUserKeyStr = "";
					for(int i = 0 ; i < tList.size() ; i++) {
						targetUserKeyStr += ",'" + tList.get(i).toString() + "'";
					}

					if(targetUserKeyStr.length() > 1)
						targetUserKeyStr = targetUserKeyStr.substring(1, targetUserKeyStr.length());
					*/
					paramObj.put("targetUserKey", tk);
				}
			}
			
			Log.Info(" * searchWord : " + searchWord);
			
			if(searchWord != null && !"".equals(searchWord)) {
				paramObj.put("searchWord", searchWord);
			}
			
			paramObj.put("authSqlID", "THRM151");
			
			Map<?, ?> query = authTableService.getAuthQueryMap(paramObj);
			Log.Debug("query.get=> "+ query.get("query"));
			paramObj.put("query", query.get("query"));

			List<?> result = recruitmentService.getRemEmployeeList(paramObj);
			if(result == null) {
				result = new ArrayList<Object>();
			}
			
			ObjectMapper mapper = new ObjectMapper();
			Log.Debug(" * getRemEmployeeList : " + mapper.writeValueAsString(result));
			
			mv.addObject("result", result);
			
		} catch (Exception ex) {
			//ex.printStackTrace();
			mv.addObject("message", ex.getMessage());
		}
		
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 채용시스템_채용합격자 발령
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/RemRecData.do", method = RequestMethod.POST, consumes = "application/json; charset=UTF-8", produces = "application/json; charset=UTF-8")
	public @ResponseBody ModelAndView getRemRecData(
			HttpSession session, HttpServletRequest request,
			@RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		try {
			if(!paramMap.containsKey("userKey") || paramMap.get("userKey") == null) {
				throw new IllegalArgumentException("userKey가 없습니다.");
			} else if(paramMap.get("userKey").toString().indexOf("@") < 0) {
				throw new IllegalArgumentException("userKey가 잘못넘어옵니다.  (@가 존재하지 않음.)");
			}
			
			if(!paramMap.containsKey("apiKey") || paramMap.get("apiKey") == null) {
				throw new IllegalArgumentException("apiKey가 없습니다.");
			}
			
			if(!paramMap.containsKey("secret") || paramMap.get("secret") == null) {
				throw new IllegalArgumentException("secret이 없습니다.");
			}
			
			// userKey를 @를 구분자로 하여 enterCd, sabun으로 분리
			String[] userKeyArr = paramMap.get("userKey").toString().split("@");
			if(userKeyArr.length != 2) {
				throw new IllegalArgumentException("userKey가 잘못넘어옵니다. (@로 나눴을때 갯수 오류)");
			}
			
			String enterCd = userKeyArr[0];
			String sabun = userKeyArr[1];
			
			// apiKey를 시스템 코드에서 가져오기
			Map<String, Object> codeParams = new HashMap<String, Object>();
			codeParams.put("queryId", "getSystemStdData");
			codeParams.put("ssnEnterCd", enterCd);
			codeParams.put("searchStdCd", "HR_API.API_KEY");
			codeParams.put("searchBizCd", "11");
			Map<?, ?> stdCdMap = recruitmentService.getSystemStdCdValue(codeParams);
			if(stdCdMap == null || stdCdMap.get("codeNm") == null || "".equals(stdCdMap.get("codeNm"))) {
				throw new CertificateException("시스템 관리 코드의 apiKey가 존재하지 않습니다.");
			}
			
			if(!stdCdMap.get("codeNm").toString().equals(paramMap.get("apiKey"))) {
				throw new CertificateException("apiKey 인증에 실패하였습니다.");
			}
			
			// secret 체크
			codeParams.put("searchStdCd", "HR_API.SECRET");
			stdCdMap = recruitmentService.getSystemStdCdValue(codeParams);
			if(stdCdMap == null || stdCdMap.get("codeNm") == null || "".equals(stdCdMap.get("codeNm"))) {
				throw new CertificateException("시스템 관리 코드의 secret이 존재하지 않습니다.");
			}
			
			MessageDigest dig = MessageDigest.getInstance("SHA-256");

			byte[] hash = dig.digest(paramMap.get("secret").toString().getBytes("UTF-8"));

			StringBuffer hexStr = new StringBuffer();
			
			for(int i = 0 ; i < hash.length ; i++) {
				String hex = Integer.toHexString(0xff & hash[i]);
				if(hex.length() == 1) hexStr.append('0');
				hexStr.append(hex);
			}
			
			Log.Debug(" * codeNm : " + stdCdMap.get("codeNm").toString());
			Log.Debug(" * hexStr : " + hexStr.toString());
			
			if(!stdCdMap.get("codeNm").toString().equals(hexStr.toString())) {
				throw new CertificateException("secret 인증에 실패하였습니다.");
			}
			
			ObjectMapper mapper = new ObjectMapper();
			Log.Debug(" * paramMap : " + mapper.writeValueAsString(paramMap));
			
			if(!paramMap.containsKey("resumeValues") || paramMap.get("resumeValues") == null) {
				throw new IllegalArgumentException("가져온 채용합격자 데이터가 없습니다.");
			}

			Map<String, Object> paramObj = new HashMap<String, Object>();
			paramObj.put("enterCd", enterCd);
			
			// 채용테이블에서 seq 조회
			Map<?, ?> seqMap = recruitmentService.getRemRecruitSeq(paramObj);
			if(seqMap == null || seqMap.get("seq") == null) {
				throw new NullPointerException("seq를 가져오지 못했습니다.");
			}
			
			paramObj.put("seq", seqMap.get("seq"));
			paramObj.put("ssnSabun", sabun);
			paramObj.put("person", mapper.writeValueAsString(paramMap.get("resumeValues")));
			
			String message = "";
			// 가져온 채용합격자 데이터 저장
			int resCnt = recruitmentService.saveRecEmployee(paramObj);
			if(resCnt > 0){
				message = "저장 되었습니다.";
			} else {
				message = "저장된 내용이 없습니다.";
			}
			
			mv.addObject("message", message);
			
		} catch (IllegalArgumentException ex) {
			//ex.printStackTrace();
			mv.addObject("message", "회사 인증에 실패하였습니다. 관리자에게 문의바랍니다.");
			Log.Error(" * IllegalArgumentException : " + ex.getMessage());
		} catch (CertificateException ex) {
			//ex.printStackTrace();
			mv.addObject("message", "회사 인증에 실패하였습니다. 관리자에게 문의바랍니다.");
			Log.Error(" * CertificateException : " + ex.getMessage());
		} catch (NullPointerException ex) {
			//ex.printStackTrace();
			mv.addObject("message", "데이터 조회에 실패하였습니다.");
			Log.Error(" * NullPointerException : " + ex.getMessage());
		} catch (Exception ex) {
			//ex.printStackTrace();
			mv.addObject("message", ex.getMessage());
		}
		
		return mv;
	}

}

