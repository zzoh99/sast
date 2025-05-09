package com.hr.common.view;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.SessionUtil;
import com.hr.common.util.StringUtil;

/**
 * View Controller
 *
 * @author RYU SIOONG
 *
 */
@Controller
@RequestMapping(value="/View.do", method=RequestMethod.POST )
public class ViewController {

	/**
	 * View 서비스
	 */
	@Inject
	@Named("ViewService")
	private ViewService viewService;
	
	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;
	
	@RequestMapping
	public String getViewPath(HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		String jspFileName = null;
		String lowerCase = null;
		String viewPath = null;
		String directoryPath = null;
		
		jspFileName = (String) paramMap.get("cmd");
		jspFileName = jspFileName.replaceFirst("view", "");
		
		lowerCase = jspFileName.substring(0,1);
		lowerCase = lowerCase.toLowerCase();
		jspFileName = lowerCase + jspFileName.substring(1);
		
		try{
			paramMap.put("logRequestUrl", String.format("View.do?cmd=%s", paramMap.get("cmd")));
			List<Map<String,String>> prgList = viewService.getDirectoryPathListByStartWithPrgCd(paramMap);
			directoryPath = getDirectoryPath(prgList, paramMap);
			
			Object sra = SessionUtil.getRequestAttribute("logRequestUrl");
			String logRequestUrl = sra != null ? sra.toString().substring(1):null;
			
			Log.Info("[VIEW]============================================================================");
			Log.Info("[VIEW] - getRequestURI : " + request.getRequestURI());
			Log.Info("[VIEW] - getRequestURL : " + request.getRequestURL());
			Log.Info("[VIEW] - queryString : " + request.getQueryString());
			Log.Info("[VIEW] - cmd : " + paramMap.get("cmd"));
			Log.Info("[VIEW] - jspFileName : " + jspFileName);
			Log.Info("[VIEW] - logRequestUrl : " + logRequestUrl);
			Log.Info("[VIEW]============================================================================");
			
			// 결정된 디렉토리 경로가 없는 경우 세션에 저장된 logRequestUrl 객체의 데이터에 jspFileName 데이터가 포함되어 있는 경우 기존 방식으로 진행함.
			if(StringUtils.isBlank(directoryPath) && logRequestUrl != null && logRequestUrl.contains(jspFileName)) {
				paramMap.put("logRequestUrl", logRequestUrl);
				directoryPath = viewService.getDirectoryPath(paramMap);
			}
			
			//Log.Debug( "----------------------------------------controll" );
			//Log.Debug( "paramMap ="+paramMap);
			//Log.Debug( "----------------------------------------" );
			//directoryPath = viewService.getDirectoryPath(paramMap);
		} catch(Exception e) {
			Log.Debug(e.getLocalizedMessage());
			try {
				/*
				Map<String, Object> urlParam = new HashMap<String, Object>();
				String surl =paramMap.get("surl").toString();
				String skey = session.getAttribute("ssnEncodedKey").toString();
				
				urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( surl, skey );
				
				paramMap.put("logRequestUrl", (String)urlParam.get("url") );
				
				directoryPath = viewService.getDirectoryPath(paramMap);
				*/
				//Log.Debug( "########################################controll2" );
				//Log.Debug( "########################################controll2" );
				//Log.Debug( "########################################controll2" );
				//Log.Debug( "########################################controll2" );
				//Log.Debug( "paramMap ="+paramMap);
				//Log.Debug( "----------------------------------------" );
				
			} catch(Exception ex) {
				directoryPath = "";
			}
			
		}
		
		viewPath = directoryPath + jspFileName;
		
		Log.DebugEnd();
		return viewPath;
	}

	/**
	 * JSP 경로 반환
	 *  - 동일한 cmd 파라미터로 여러건이 등록되어 있는 경우 파라미터값을 비교하여 일치하는 건의 directory path값을 결정함.
	 * @param prgList
	 * @param paramMap
	 * @return
	 */
	public String getDirectoryPath(List<Map<String,String>> prgList, Map<String, Object> paramMap) {
		String directoryPath = "";
		
		if(prgList != null && prgList.size() > 0) {
			// 조회된 목록이 1개인 경우
			if(prgList.size() == 1) {
				directoryPath = prgList.get(0).get("directoryPath").toString();
			} else {
				String logRequestUrl = (String) paramMap.get("logRequestUrl");
				String prgCd = null;
				String addedQueryString = null;
				
				int idx = 0;
				for (Map<String, String> prg : prgList) {
					prgCd = (String) prg.get("prgCd");
					Log.Debug(String.format("prgCd : %s, logRequestUrl : %s", prgCd, logRequestUrl));
					
					// TSYS301에 저장된 PRG_CD 데이터와 체크 URL이 일치하지 않는 경우 파라미터 값 체크 진행함.
					if(!prgCd.equals(logRequestUrl)) {
						addedQueryString = prgCd.substring(logRequestUrl.length() + 1, prgCd.length());
						Log.Info( String.format("[GET_DIRECTORY_PATH][%s] addedQueryString : %s", idx, addedQueryString) );
						
						if(!StringUtils.isBlank(addedQueryString)) {
							Map<String,String> prgParamMap = getConvertParamMap(addedQueryString);
							Log.Info( String.format("[GET_DIRECTORY_PATH][%s] prgParamMap : %s", idx, prgParamMap) );
							
							// 매칭되는 데이터
							if(isMatched(prgParamMap, paramMap)) {
								Log.Info("matched addedQueryString >>> " + addedQueryString);
								directoryPath = prg.get("directoryPath");
								break;
							}
						} else {
							// TSYS301에 저장된 PRG_CD 데이터와 체크 URL이 일치하는 경우 임시로  directory path값으로 결정함.
							Log.Info( String.format("[GET_DIRECTORY_PATH][%s] temp matched directory path : %s", idx, prg.get("directoryPath")) );
							directoryPath = prg.get("directoryPath");
						}// end if
					} else {
						directoryPath = prg.get("directoryPath").toString();
						break;
					}// end if
					
					idx++;
				}// end loop
			}
		}
		Log.Info("[GET_DIRECTORY_PATH][FINAL] directoryPath : " + directoryPath);
		return directoryPath;
	}
	
	/**
	 * QueryString Convert to Map
	 * @param queryString
	 * @return
	 */
	public Map<String,String> getConvertParamMap(String queryString) {
		Map<String,String> paramMap = new HashMap<String, String>();
		
		if(queryString.startsWith("?")) {
			queryString = queryString.substring(1, queryString.length());
		}
		
		String[] paramArr = queryString.split("&");
		for (String query : paramArr) {
			String[] arr = StringUtil.getSplitArray(query, "=");
			if( arr != null && arr.length == 2 ) {
				paramMap.put(arr[0], arr[1]);
			}
		}
		
		return paramMap;
	}
	
	/**
	 * source map의 모든 key에 해당하는 값이 target map 객체에 포함되는지 체크
	 * @param source
	 * @param target
	 * @return
	 */
	public boolean isMatched(Map<String,String> source, Map<String,Object> target) {
		boolean isMatch = true;
		
		for( String key : source.keySet() ){
			
			if(!target.containsKey(key)) {
				isMatch = false;
				break;
			} else {
				String value1 = source.get(key);
				String value2 = (String) target.get(key);
				if(!value1.equals(value2)) {
					isMatch = false;
					break;
				}
			}
			
		}// end loop
		
		return isMatch;
	}
}