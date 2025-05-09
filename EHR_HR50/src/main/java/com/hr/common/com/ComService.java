package com.hr.common.com;

import com.hr.common.dao.Dao;
import com.hr.common.dao.ProDao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.SessionUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.LocaleResolver;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;


@Service("ComService")
@SuppressWarnings("unchecked")
public class ComService{

	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("ProDao")
	private ProDao proDao;

	@Autowired
	@Qualifier("customLocaleResolver")
	private LocaleResolver localeResolver;

	//---------------------------------------------------------------------------------------------- 2020.06.08 start
	public List<?> getDataList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList(paramMap.get("cmd").toString(), paramMap);
	}
	
	public Map<?, ?> getDataMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap(paramMap.get("cmd").toString(), paramMap);
		return resultMap;
	}
	
	public int saveData(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt = 0; 
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			String deleteQueryId = convertMap.get("cmd").toString();
			deleteQueryId = deleteQueryId.replace("save","delete");
			cnt += dao.delete(deleteQueryId, convertMap);
		}

		if( !isNull(String.valueOf(convertMap.get("dupList")))){
			int dupCnt = getDupCnt(convertMap);
			//중복데이터 존재함.
			if( dupCnt > 0 ) {
				throw new HrException("중복된 값이 존재 합니다.");
			}
		}

		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update(convertMap.get("cmd").toString(), convertMap);
		}

		return cnt;
	}
	
	public int saveDataBatch(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=1;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			String deleteQueryId = convertMap.get("cmd").toString();
			deleteQueryId = deleteQueryId.replace("save","delete");
			ParamUtils.mergeParams(convertMap, (List<Map<String, Object>>)convertMap.get("deleteRows"));
			dao.delete(deleteQueryId, (List<Map<?,?>>)convertMap.get("deleteRows"));
		}

		if( !isNull(String.valueOf(convertMap.get("dupList")))){ 
			int dupCnt = getDupCnt(convertMap);
			//중복데이터 존재함.
			if( dupCnt > 0 ) {
				throw new HrException("중복된 값이 존재 합니다.");
			}
		}
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			ParamUtils.mergeParams(convertMap, (List<Map<String, Object>>)convertMap.get("mergeRows"));
			dao.update(convertMap.get("cmd").toString(), (List<Map<?,?>>)convertMap.get("mergeRows"));
		}

		return cnt;
	}
	
	/**
	 *  ExecPrc 실행 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> execPrc(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.excute(paramMap.get("cmd").toString(), paramMap);
		//return (Map<?, ?>) dao.getOne(paramMap.get("cmd").toString(), paramMap);
	}


	/**
	 * 중복체크 
	 */
	public int getDupCnt(Map<?, ?> convertMap) throws Exception {
		Log.DebugStart();
		
		String ssnEnterCd = (String) SessionUtil.getRequestAttribute("ssnEnterCd");
		String ssnSabun = (String) SessionUtil.getRequestAttribute("ssnSabun");
		
		String[] dupList 		= (String[]) convertMap.get("dupList");
		
		if( dupList.length != 4 ) {
			throw new HrException("중복체크 파라미터가 부족함.");
		}

		String dupTable 		= dupList[0];
		String dupColumn 		= dupList[1];
		String dupColumnKey 	= dupList[2];
		String dupColumnType 	= dupList[3];

		Log.Debug("convertMap:" + convertMap);
		Log.Debug("ssnEnterCd:" + ssnEnterCd + ", ssnSabun:" + ssnSabun);
		Log.Debug("table:" + dupTable + ", dupColumn:" + dupColumn+", dupColumnKey:" + dupColumnKey+", dupColumnType:" + dupColumnType );

		List<Map<?, ?>> insertRows = (List<Map<?, ?>>) convertMap.get("insertRows");
		
		if( insertRows.size() > 0 && !isNull(dupTable) && !isNull(dupColumn) && !isNull(dupColumnKey) && !isNull(dupColumnType)){
			
			String colsArray[]     = dupColumn.split(",");
			String colsKeyArray[]  = dupColumnKey.split(",");
			String colsTypeArray[] = dupColumnType.split(",");

			Log.Debug("colsArray[]:" + colsArray.toString());
			Log.Debug("colsTypeArray[]:" + colsTypeArray.toString());
			Log.Debug("colsTypeArray[]:" + colsTypeArray.toString());
			
			if( colsArray.length != colsTypeArray.length ) throw new HrException("중복체크 시 오류가 발생 했습니다.");
			if( !isNull(dupColumnKey) && colsArray.length != colsKeyArray.length ) throw new HrException("중복체크 시 오류가 발생 했습니다.");
			

			String values = "";
			String valueSet = "";
			for(int i=0; i<insertRows.size(); i++){
				valueSet = (i==0)?"(":",(";
				Map<String, String> map = (Map<String, String>)insertRows.get(i);
				Log.Debug("map:" + map);
				
				for(int x=0; x<colsKeyArray.length; x++){
					if("ssnEnterCd".equals(colsKeyArray[x]) ){
						valueSet += "'"+ssnEnterCd+"',";
						
					}else if("ssnSabun".equals(colsKeyArray[x]) ){
						valueSet += "'"+ssnSabun+"',";

					}else if(colsKeyArray[x].indexOf("search") > -1 ){ // "search"로 시작하면 배열이 아닌 파라메터에서 가져옴.2020.07.27 
						valueSet += "'"+String.valueOf(convertMap.get(colsKeyArray[x]))+"',";
						
					}else if(colsTypeArray[x].equals("s0") ){
						valueSet += "CRYPTIT.ENCRYPT('"+map.get(colsArray[x])+"','" +ssnEnterCd+ "'),";
						
					}else if(colsTypeArray[x].equals("i") ){
						if(map.get(colsKeyArray[x]) != null && ((String)map.get(colsKeyArray[x])).length() != 0) {
							valueSet += map.get(colsKeyArray[x])+",";
						} else {
							valueSet += "NULL"+",";
						}
					} else {
						valueSet += "'"+map.get(colsKeyArray[x])+"',";
					}
				}
				valueSet = valueSet.substring(0, valueSet.length()-1);
				valueSet +=")";
				values +=valueSet;
			}
			values = "("+values+")";

			Map<String, Object> paramMap = new HashMap<>();
			paramMap.put("table",dupTable);
			paramMap.put("cols","("+dupColumn+")");
			paramMap.put("values",values);
			
			int cnt = 0;
			Map<?, ?> m = dao.getMap("getDupCnt", paramMap);
			if(m.containsKey("CNT")){
				cnt = Integer.parseInt( m.get("CNT").toString() );
			} else if (m.containsKey("cnt")) {
				cnt = Integer.parseInt( m.get("cnt").toString() );
			}
			return cnt;
			
		}
		
		return 0;
		
	}


	private boolean isNull(String strTarget) {
		if (strTarget == null || "".equals(strTarget) || "null".equals(strTarget)) {
			return true;
		}
		return false;
	}
	//---------------------------------------------------------------------------------------------- 2020.06.08 end
	// 
	
	/**
	 * 공통 Auth Result 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAuthQueryMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAuthQueryMap", paramMap);
	}


	public List<?> getComQueryList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList(paramMap.get("queryId").toString(), paramMap);
	}

	public List<?> getComQueryList(Map<?, ?> paramMap, String queryId) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList(queryId, paramMap);
	}


	public Map<?,?> getComQueryMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap(paramMap.get("queryId").toString(), paramMap);
	}

	public Map<?,?> getComQueryMap(Map<?, ?> paramMap, String queryId) throws Exception {
		Log.Debug();
		return dao.getMap(queryId, paramMap);
	}


	public String getComRtnStr(Map<?, ?> paramMap) throws Exception {
		return (String) dao.getOne("getfunctionRetrunString", paramMap);
	}

	public String getComDecRtnStr(Map<?, ?> paramMap, String queryID) throws Exception {
		return (String) dao.getOne(queryID, paramMap);
	}

	
	/**
	 * 언어 설정을 바꾼다.
	 *
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public void changeLocale(HttpSession session, HttpServletRequest request, HttpServletResponse response, Map<?, ?> paramMap) throws Exception {
		String afterLang = paramMap.get("strLocale").toString();

		Log.Debug("changeLocale afterLang="+ afterLang + " length="+ afterLang.length());

		Locale locale = new Locale(afterLang.substring(0,2),afterLang.substring(3));

		String chkSabun =(String)session.getAttribute("ssnSabun");
		if (null != chkSabun ) {
			if (locale != null) {
				localeResolver.setLocale(request, response, locale);
				session.setAttribute("ssnLocaleCd", locale.toString());
				//session.setAttribute("ssnLocaleCountry", locale.getDisplayCountry(locale));
				session.setAttribute("ssnLocaleLanguage", locale.getDisplayLanguage(locale));
			}
		}
		Log.Debug("======>> " + localeResolver.resolveLocale(request));

		Log.DebugStart();
		session.setAttribute("ssnLocaleCd", afterLang);
		Log.DebugEnd();

/*
		Map<?, ?> localeCd = getComQueryMap(paramMap, "getLocaleCdStr");
		session.setAttribute("localeCd1", localeCd.get("localeCd1"));
		session.setAttribute("localeCd2", localeCd.get("localeCd2"));

		Log.Debug("┌────────────────── Language Start ────────────────────────");
		Log.Debug("│ localeResolver :" + localeResolver.resolveLocale(request));
		Log.Debug("│ ssnLocaleCd:" + session.getAttribute("ssnLocaleCd"));
		Log.Debug("│ localeCd1:" + session.getAttribute("localeCd1"));
		Log.Debug("│ localeCd2:" + session.getAttribute("localeCd2"));
		Log.Debug("└────────────────── Language End ────────────────────────");
*/
	}
}