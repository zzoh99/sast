package com.hr.common.dao;

import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.hr.common.logger.Log;
import com.hr.common.util.SessionUtil;

/**
 * 공통 DAO 
 * @author ParkMoohun
 */
@Repository("RecDao")
public class RecDao{
	
	@Autowired
	private SqlSessionTemplate sqlSession;

	/**
	 * List Type 다행 조회
	 * 
	 * @param queryId
	 * @param paramMap
	 * @return Collection
	 * @throws Exception
	 */
	public Collection<?> getList(String queryId, Map<?, ?> paramMap) throws Exception {
		Object[] param = convertParams(paramMap);
		Collection<?> collection = sqlSession.selectList(queryId, param);
		Object[] rtnMap = collection.toArray();

		Log.Debug("┌────────────────── "+queryId+" Result List Start────────────────────────");
		for(Object m:rtnMap){
			Log.Debug("│  "+m.toString());
		}
		Log.Debug("└────────────────── "+queryId+" Result List End──────────────────────────");
		insertLog(queryId, "조회", paramMap);
		return collection;
	}
	
	/**
	 * Map Type 단행 조회
	 * 
	 * @param queryId
	 * @param paramMap
	 * @return Collection
	 * @throws Exception
	 */
	public Map<?, ?> getMap(String queryId, Map<?, ?> paramMap) throws Exception {
		Object[] param = convertParams(paramMap);
		Map<?,?> map = null;
		List<?> list = (List<?>) sqlSession.selectList(queryId, param);
		if(!list.isEmpty()) {
			Log.Debug("┌────────────────── "+queryId+" Result Map Start────────────────────────");
			map = (Map<?, ?>) list.get(0);
			Log.Debug("│  "+map.toString());
			Log.Debug("└────────────────── "+queryId+" Result Map End──────────────────────────");
		}
		insertLog(queryId, "조회", paramMap);
		return map;
	}
	
	/**
	 * 데이터 생성
	 * 
	 * @param queryId
	 * @param insertMap
	 * @return int
	 * @throws Exception
	 */
	public int create(String queryId, Map<?, ?> insertMap) throws Exception {
		Object[] param = convertParams(insertMap);
		int cnt = sqlSession.insert(queryId, param );
		insertLog(queryId, "생성", insertMap);
		return cnt;
	}
	
	/**
	 * 데이터 갱신
	 * 
	 * @param queryId
	 * @param updateMap
	 * @return int
	 * @throws Exception
	 */
	public int update(String queryId, Map<?, ?> updateMap) throws Exception {
		Object[] param = convertParams(updateMap);
		int cnt = sqlSession.update(queryId, param );
		insertLog(queryId, "저장", updateMap);
		return cnt;
	}

	/**
	 * @param queryId
	 * @param deleteMap
	 * @return int
	 * @throws Exception
	 */
	public int delete(String queryId, Map<?, ?> deleteMap) throws Exception {
		Object[] param = convertParams(deleteMap);
		int cnt = sqlSession.delete(queryId, param);
		insertLog(queryId, "삭제", deleteMap);
		return cnt;
	}
	
	/**
	 * param 값 변환
	 * 
	 * @param targetMap
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	private Object[] convertParams(Map<?, ?> targetMap) {
		Object[] params = new Object[targetMap.size()];
		Iterator<?> targetMapIterator = targetMap.entrySet().iterator();
		int i = 0;
		while (targetMapIterator.hasNext()) {
			Map.Entry entry = (Map.Entry) targetMapIterator.next();
			params[i] = new Object[] { entry.getKey(), entry.getValue() };
			i++;
		}
		
		return params;
	}
	
	/**
	 * 로그 생성
	 * 
	 * @param queryId
	 * @param job
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertLog(String queryId, String job, Map<?,?> paramMap) throws Exception {
		String enterCd = (String) SessionUtil.getRequestAttribute("ssnEnterCd");
		
		if(enterCd == null || enterCd.equals("")) return -1;
		
		Map<String, Object> logParam = new HashMap<String, Object>();
		logParam.put("logEnterCd",		SessionUtil.getRequestAttribute("ssnEnterCd") );
		logParam.put("logJob", 			job );
		logParam.put("logIp", 			SessionUtil.getRequestAttribute("logIp") );
		logParam.put("logRequestUrl", 	SessionUtil.getRequestAttribute("logRequestUrl") );
		logParam.put("logController", 	SessionUtil.getRequestAttribute("logController") );
		logParam.put("logParameter", 	paramMap.toString() );
		logParam.put("logQueryId", 		queryId );
		logParam.put("logSabun", 		SessionUtil.getRequestAttribute("ssnSabun") );
		
		Map<String, Object> map = sqlSession.selectOne("getLogMgrSeqMap", convertParams(logParam));
		String logSeq = map.get("seq").toString();
		logParam.put("logSeq", 			logSeq );
		sqlSession.insert("insertLogMgr", logParam);
		sqlSession.update("updateLogMgr", logParam);
		return 1;
	}
	
	/**
	 * Procedure 
	 * 
	 * @param queryId
	 * @param paramMap
	 * @return Object
	 * @throws Exception
	 */
	public Object excute(String queryId, Map<?, ?> paramMap) throws Exception {
		return sqlSession.update(queryId, paramMap);
	}
	
	/**
	 * Query Info 
	 * 
	 * @param queryId
	 * @throws Exception
	 */
	public String getStatement(String queryId) throws Exception {
	    return sqlSession.getConfiguration().getMappedStatement(queryId).getSqlSource().toString();
	}
	
	/**
	 * 데이터 갱신
	 *
	 * @param queryId
	 * @param updateMap
	 * @return int
	 * @throws Exception
	 */
	public int updateClob(String queryId, Map<?, ?> updateMap) throws Exception {
		int count = sqlSession.update(queryId, updateMap);
		insertLog(queryId, "updateMap저장", updateMap);
		return count;
	}


	/**
	 * 데이터 삭제 - for Batch
	 *
	 * @param queryId
	 * @param deleteMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteBatch(String queryId, Map<?, ?> deleteMap) throws Exception {
		Object[] param = convertParams(deleteMap);
		int cnt = sqlSession.delete(queryId, param );
		insertLog(queryId, "삭제", deleteMap);
		return cnt;
	}

	/**
	 * 데이터 갱신 - for Batch
	 *
	 * @param queryId
	 * @param updateMap
	 * @return int
	 * @throws Exception
	 */
	public int updateBatch(String queryId, Map<?, ?> updateMap) throws Exception {
		Object[] param = convertParams(updateMap);
		int cnt = sqlSession.update(queryId, param);
		insertLog(queryId, "저장", updateMap);
		return cnt;
	}

	/**
	 * List Type 다행 조회 - for Batch
	 *
	 * @param queryId
	 * @param paramMap
	 * @return Collection
	 * @throws Exception
	 */
	public Collection<?> getListBatch(String queryId, Map<?, ?> paramMap) throws Exception {
		Object[] param = convertParams(paramMap);
		Collection<?> collection = sqlSession.selectList(queryId, param );
		Object[] rtnMap = collection.toArray();
		Log.Debug("┌────────────────── "+queryId+" Result List Start────────────────────────");
		for(Object m:rtnMap){
			Log.Debug("│  "+m.toString());
		}
		Log.Debug("└────────────────── "+queryId+" Result List End──────────────────────────");
		insertLog(queryId, "조회", paramMap);
		return collection;
	}
	/**
	 * List Type 1행 조회 - for Batch
	 *
	 * @param queryId
	 * @param paramMap
	 * @return Collection
	 * @throws Exception
	 */
	public Map<?, ?> getMapBatch(String queryId, Map<?, ?> paramMap) throws Exception {
		Object[] param = convertParams(paramMap);
		Map<?,?> map = null;
		List<?> list = sqlSession.selectList(queryId, param );
		if(!list.isEmpty()) {
			Log.Debug("┌────────────────── "+queryId+" Result Map Start────────────────────────");
			map = (Map<?, ?>) list.get(0);
			Log.Debug("│  "+map.toString());
			Log.Debug("└────────────────── "+queryId+" Result Map End──────────────────────────");
		}
		insertLog(queryId, "조회", paramMap);
		return map;
	}
}