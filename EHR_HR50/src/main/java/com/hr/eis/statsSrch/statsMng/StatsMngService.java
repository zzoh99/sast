package com.hr.eis.statsSrch.statsMng;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.time.DateFormatUtils;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.StringUtil;

/**
 * 통계 그래프 > 통계 관리 Service
 * @author gjyoo
 *
 */
@Service("StatsMngService")
public class StatsMngService {
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 차트 옵션  저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveStatsMngChartOpt(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.update("saveStatsMngChartOpt", convertMap);
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 데이터 조회 SQL 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveStatsMngSQLSyntax(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.updateClob("saveStatsMngSQLSyntax", convertMap);
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 설정 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveStatsMngSetting(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.update("saveStatsMngSetting", convertMap);
		// update sqlSyntax CLOB
		dao.updateClob("saveStatsMngSQLSyntax", convertMap);
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 통계 단건 조회 Service
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<?, ?> getStatsMngMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getStatsMngMap", paramMap);
		return resultMap;
	}
	
	/**
	 * 차트 데이터 목록 조회
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getStatsMngChartDataList(HttpServletRequest request, Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		
		HttpSession session = null;
		List<?> list = null;
		
		// SQL Template
		String executeSQL = (String) paramMap.get("sqlSyntax");
		// 기준일자
		String searchYmd  = (request.getParameter("searchYmd") != null) ? request.getParameter("searchYmd") : (String) paramMap.get("searchYmd");
		
		// 기준일자 데이터가 없는 경우 오늘날짜로 설정
		if( StringUtil.isBlank(searchYmd) ) {
			searchYmd = DateFormatUtils.format(new Date(), "yyyyMMdd");
		}
		Log.Debug("searchYmd ==> " + searchYmd);
		
		if( !StringUtil.isBlank(executeSQL) ) {
			session = request.getSession();
			
			//luccy-xss-filter로 인해 변경된 query 정보 수정
			executeSQL = executeSQL.replaceAll("&#39;", "'");
			executeSQL = executeSQL.replaceAll("&lt;", "<");
			executeSQL = executeSQL.replaceAll("&gt;", ">");
			
			// replace
			executeSQL = executeSQL.replace("@@회사코드@@", (String) session.getAttribute("ssnEnterCd"));
			executeSQL = executeSQL.replace("@@searchYmd@@", searchYmd);
			executeSQL = executeSQL.replace("@@조회권한@@", (String) session.getAttribute("ssnSearchType"));
			executeSQL = executeSQL.replace("@@사번@@", (String) session.getAttribute("ssnSabun"));
			executeSQL = executeSQL.replace("@@권한그룹@@", (String) session.getAttribute("ssnGrpCd"));
			
			// 실행 SQL 삽입
			paramMap.put("executeSQL", executeSQL);
			list = (List<?>) dao.getList("getStatsMngChartDataList", paramMap);
		}
		
		return list;
	}

}
