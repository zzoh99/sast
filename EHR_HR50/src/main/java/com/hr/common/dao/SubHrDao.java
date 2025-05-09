/**
 * 멀티 DB용 DAO
 */

//package com.hr.common.dao;
//
//import com.hr.common.logger.Log;
//import com.hr.common.util.SessionUtil;
//import org.apache.ibatis.executor.BatchResult;
//import org.apache.ibatis.mapping.BoundSql;
//import org.mybatis.spring.SqlSessionTemplate;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.beans.factory.annotation.Qualifier;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.stereotype.Repository;
//
//import java.util.*;
//
//@Repository("SubHrDao")
//public class SubHrDao {
//
//	@Autowired
//	@Qualifier("subHrSqlSession")
//	private SqlSessionTemplate sqlSession;
//
//	@Autowired
//	@Qualifier("subHrBatchSqlSession")
//	private SqlSessionTemplate batchSqlSession;  // 배치 처리용
//
//	private static final int BATCH_SIZE = 1000;
//
//	private static String sabunParams; // 임직원 공통 권한에서 변조가 허용되지 않는 사번 키
//	@Value("${isu.auth.sabun.keys}")
//	public void setSabunParams(String sabunParams) {
//		SubHrDao.sabunParams = sabunParams;
//	}
//
//	private static String daoInParam;
//	@Value("${dao.inParam}")
//	public void setDaoInParam(String inparam) {
//		SubHrDao.daoInParam = inparam;
//	}
//
//	private static String commonGrpCd;
//	@Value("${isu.auth.common.grpCd}")
//	public void setCommonGrpCd(String commonGrpCd) {
//		SubHrDao.commonGrpCd = commonGrpCd;
//	}
//
//	public String getQueryString(String queryId, Map<?, ?> param){
//		//쿼리 바인딩 준비
//		BoundSql boundSql = sqlSession.getConfiguration().getMappedStatement(queryId).getBoundSql(param);
//		return boundSql.getSql();
//	}
//
//	public Collection<?> getList(String queryId, Object params) throws Exception {
//		Collection<?> collection = null;
//		params = SubHrDao.convertParams(params);
//		collection = sqlSession.selectList(queryId, params);
//		Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
//		Log.Debug("┌────────────────── {} GetList Result ────────────────────────", queryId);
//		Log.Debug("│  cnt : {}", collection.size());
//		Log.Debug("└────────────────── {} GetList Result ────────────────────────", queryId);
//		return collection;
//	}
//
//	public Object getOne(String queryId, Object params) throws Exception {
//		params = SubHrDao.convertParams(params);
//		return sqlSession.selectOne(queryId, params);
//	}
//
//	public Map<?, ?> getMap(String queryId, Object params) throws Exception {
//		params = SubHrDao.convertParams(params);
//		Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
//		Map<?,?> map = null;
//		map = sqlSession.selectOne(queryId, params);
//		Log.Debug("┌────────────────── {} Result Map Start────────────────────────", queryId);
//		Log.Debug("│  {}", map);
//		Log.Debug("└────────────────── {} Result Map End──────────────────────────", queryId);
//		return map;
//	}
//
//	/**
//	 * 데이터 생성
//	 *
//	 * @param queryId
//	 * @param params
//	 * @return int
//	 * @throws Exception
//	 */
//	public int create(String queryId, Object params) throws Exception {
//		params = SubHrDao.convertParams(params);
//		Log.Debug("\n■■■■■■■■■ [ queryId :{} ] ■■■■■■■■■\n", queryId);
//		int cnt = sqlSession.insert(queryId, params);
//		return cnt;
//	}
//
//	/**
//	 * 데이터 갱신
//	 *
//	 * @param queryId
//	 * @param params
//	 * @return int
//	 * @throws Exception
//	 */
//	public int update(String queryId, Object params) throws Exception {
//		params = SubHrDao.convertParams(params);
//		Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
//		int cnt = sqlSession.update(queryId, params);
//		Log.Debug("┌────────────────── {} Update Result ────────────────────────", queryId);
//		Log.Debug("│  cnt : {}", cnt);
//		Log.Debug("└────────────────── {} Update Result ────────────────────────", queryId);
//		return cnt;
//	}
//
//	/**
//	 * @param queryId
//	 * @param params
//	 * @return int
//	 * @throws Exception
//	 */
//	public int delete(String queryId, Object params) throws Exception {
//		params = SubHrDao.convertParams(params);
//		Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
//		int cnt = sqlSession.delete(queryId, params);
//		Log.Debug("┌────────────────── {} Delete Result ────────────────────────", queryId);
//		Log.Debug("│  cnt : {}", cnt);
//		Log.Debug("└────────────────── {} Delete Result ────────────────────────", queryId);
//		return cnt;
//	}
//
//	public Object excute(String queryId, Object params)  {
//		params = SubHrDao.convertParams(params);
//		Log.Debug("\n■■■■■■■■■ [ execute queryId : {} ] ■■■■■■■■■\n", queryId);
//		sqlSession.update(queryId, params);
//		return params;
//	}
//
//	public String getStatement(String queryId) {
//		Log.Debug("\n■■■■■■■■■ [ statement queryId : {} ] ■■■■■■■■■\n", queryId);
//		return sqlSession.selectOne(queryId);
//	}
//
//	public int updateClob(String queryId, Map<?, ?> params) throws Exception {
//		Object obj = SubHrDao.convertParams(params);
//		Log.Debug("\n■■■■■■■■■ [ update clob queryId : {} ] ■■■■■■■■■\n", queryId);
//		int cnt = sqlSession.update(queryId, obj);
//		//int cnt = Integer.parseInt(params.get("#update-count-1").toString());
//		return cnt;
//	}
//
//	public int deleteBatch(String queryId, Object params) throws Exception {
//		params = SubHrDao.convertParams(params);
//		Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
//		int cnt = sqlSession.delete(queryId, params);
//		return cnt;
//	}
//
//	public int updateBatch(String queryId, Object params) throws Exception {
//		params = SubHrDao.convertParams(params);
//		Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
//		int cnt = sqlSession.update(queryId, params);
//		return cnt;
//	}
//
//	public Collection<?> getListBatch(String queryId, Object params) throws Exception {
//		params = SubHrDao.convertParams(params);
//		Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
//		return sqlSession.selectList(queryId, params);
//	}
//
//	@SuppressWarnings("unchecked")
//	public Map<?, ?> getMapBatch(String queryId, Object params) throws Exception {
//		params = SubHrDao.convertParams(params);
//		Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
//		Map<?,?> map = null;
//		List<?> list = (List<?>) sqlSession.selectList(queryId, params);
//		if(!list.isEmpty()) {
//			map = (Map<String, Object>) list.get(0);
//		} else {
//			Log.Debug("─────────────────── {} Batch Map Is Null ─────────────────────", queryId);
//		}
//		return map;
//	}
//
//	public int[] batchUpdate(String queryId, List<Map<?, ?>> list) throws Exception {
//		Log.Debug("\n■■■■■■■■■ [ batch update queryId :{} ] ■■■■■■■■■\n", queryId);
//		int[] counts = new int[list.size()];
//		for (int i=0;i <list.size(); i++) {
//			Map<?, ?> param = list.get(i);
//			counts[i] = sqlSession.update(queryId, param);
//		}
//		return counts;
//	}
//
//	/* ======================================= */
//	/* ==== batchSqlSession 사용 메소드 선언 ==== */
//	/* =======================================  */
//
//	/**
//	 * batch 모드로 데이터 1건 조회
//	 * @param queryId
//	 * @param params
//	 * @return
//	 * @throws Exception
//	 */
//	public Map<?, ?> getMapBatchMode(String queryId, Object params) throws Exception {
//		params = SubHrDao.convertParams(params);
//		Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
//		Map<?,?> map = null;
//		map = batchSqlSession.selectOne(queryId, params);
//		Log.Debug("┌────────────────── {} Result Map Start────────────────────────", queryId);
//		Log.Debug("│  {}", map);
//		Log.Debug("└────────────────── {} Result Map End──────────────────────────", queryId);
//		return map;
//	}
//
//	/**
//	 * batch 모드로 데이터 다건 조회
//	 * @param queryId
//	 * @param params
//	 * @return
//	 * @throws Exception
//	 */
//	public Collection<?> getListBatchMode(String queryId, Object params) throws Exception {
//		Collection<?> collection = null;
//		params = SubHrDao.convertParams(params);
//		collection = batchSqlSession.selectList(queryId, params);
//		Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
//		Log.Debug("┌────────────────── {} GetList Result ────────────────────────", queryId);
//		Log.Debug("│  cnt : {}", collection.size());
//		Log.Debug("└────────────────── {} GetList Result ────────────────────────", queryId);
//		return collection;
//	}
//
//	/**
//	 * BATCH_SIZE 단위로 batch insert 처리
//	 * @param queryId
//	 * @param list
//	 * @return 처리된 총 row수
//	 * @throws Exception
//	 */
//	public int insertBatchMode(String queryId, List<?> list) throws Exception {
//		Log.Debug("\n■■■■■■■■■ [ batch insert queryId :{} ] ■■■■■■■■■\n", queryId);
//		int cnt = 0;
//
//		for (int i = 0; i < list.size(); i++) {
//			Object param = list.get(i);
//			batchSqlSession.insert(queryId, param);
//
//			if ((i > 0 && i % BATCH_SIZE == 0) || i == list.size() - 1) {
//				List<BatchResult> results = batchSqlSession.flushStatements();
//				for (BatchResult result : results) {
//					int[] updateCounts = result.getUpdateCounts();
//					for (int count : updateCounts) {
//						if (count >= 0) {  // 실제 영향받은 행의 수만 합산
//							cnt += count;
//						} else if (count == -2 ) { // 정상적으로 수행됐지만, 영향 받은 행의 수를 알 수 없을 때
//							cnt += 1;
//						} else {
//							cnt -= 1;
//						}
//					}
//				}
//			}
//		}
//
//		Log.Debug("┌────────────────── {} Batch Insert Result ────────────────────────", queryId);
//		Log.Debug("│ total inserted rows : {}", cnt);
//		Log.Debug("└────────────────── {} Batch Insert Result ────────────────────────", queryId);
//
//		return cnt;
//	}
//
//	/**
//	 * BATCH_SIZE 단위로 update 처리
//	 * @param queryId
//	 * @param list
//	 * @return 처리된 총 row수
//	 * @throws Exception
//	 */
//	public int updateBatchMode(String queryId, List<?> list) throws Exception {
//		Log.Debug("\n■■■■■■■■■ [ batch update queryId :{} ] ■■■■■■■■■\n", queryId);
//		int cnt = 0;
//
//		for (int i = 0; i < list.size(); i++) {
//			Object param = list.get(i);
//			batchSqlSession.update(queryId, param);
//
//			if ((i > 0 && i % BATCH_SIZE == 0) || i == list.size() - 1) {
//				List<BatchResult> results = batchSqlSession.flushStatements();
//				for (BatchResult result : results) {
//					int[] updateCounts = result.getUpdateCounts();
//					for (int count : updateCounts) {
//						if (count >= 0) {  // 실제 영향받은 행의 수만 합산
//							cnt += count;
//						} else if (count == -2) { // 정상적으로 수행됐지만, 영향 받은 행의 수를 알 수 없을 때
//							cnt += 1;
//						} else {
//							cnt -= 1;
//						}
//					}
//				}
//			}
//		}
//
//		Log.Debug("┌────────────────── {} Batch Update Result ────────────────────────", queryId);
//		Log.Debug("│ total updated rows : {}", cnt);
//		Log.Debug("└────────────────── {} Batch Update Result ────────────────────────", queryId);
//
//		return cnt;
//	}
//
//	/**
//	 * batch 모드로 update 처리
//	 * @param queryId
//	 * @param params
//	 * @return 처리된 총 row수
//	 * @throws Exception
//	 */
//	public int updateBatchMode(String queryId, Object params) throws Exception {
//		params = SubHrDao.convertParams(params);
//		Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
//		batchSqlSession.update(queryId, params);
//
//		// 배치 실행을 위한 flush 추가
//		List<BatchResult> results = batchSqlSession.flushStatements();
//		int cnt = 0;
//		for (BatchResult result : results) {
//			int[] updateCounts = result.getUpdateCounts();
//			for (int count : updateCounts) {
//				if (count >= 0) {  // 실제 영향받은 행의 수만 합산
//					cnt += count;
//				} else if (count == -2 ) { // 정상적으로 수행됐지만, 영향 받은 행의 수를 알 수 없을 때
//					cnt += 1;
//				} else {
//					cnt -= 1;
//				}
//			}
//		}
//		return cnt;
//	}
//
//	/**
//	 * BATCH_SIZE 단위로 delete 처리
//	 * @param queryId
//	 * @param list
//	 * @return 처리된 총 row수
//	 * @throws Exception
//	 */
//	public int deleteBatchMode(String queryId, List<Map<?, ?>> list) throws Exception {
//		Log.Debug("\n■■■■■■■■■ [ batch delete queryId :{} ] ■■■■■■■■■\n", queryId);
//		int cnt = 0;
//
//		for (int i = 0; i < list.size(); i++) {
//			Map<?, ?> param = list.get(i);
//			batchSqlSession.delete(queryId, param);
//
//			if ((i > 0 && i % BATCH_SIZE == 0) || i == list.size() - 1) {
//				List<BatchResult> results = batchSqlSession.flushStatements();
//				for (BatchResult result : results) {
//					int[] updateCounts = result.getUpdateCounts();
//					for (int count : updateCounts) {
//						if (count >= 0) {  // 실제 영향받은 행의 수만 합산
//							cnt += count;
//						} else if (count == -2 ) { // 정상적으로 수행됐지만, 영향 받은 행의 수를 알 수 없을 때
//							cnt += 1;
//						} else {
//							cnt -= 1;
//						}
//					}
//				}
//			}
//		}
//
//		Log.Debug("┌────────────────── {} Batch Delete Result ────────────────────────", queryId);
//		Log.Debug("│ total deleted rows : {}", cnt);
//		Log.Debug("└────────────────── {} Batch Delete Result ────────────────────────", queryId);
//
//		return cnt;
//	}
//
//	public int deleteBatchMode(String queryId, Object params) throws Exception {
//		params = SubHrDao.convertParams(params);
//		Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
//		batchSqlSession.delete(queryId, params);
//
//		// 배치 실행을 위한 flush 추가
//		List<BatchResult> results = batchSqlSession.flushStatements();
//		int cnt = 0;
//		for (BatchResult result : results) {
//			int[] updateCounts = result.getUpdateCounts();
//			for (int count : updateCounts) {
//				if (count >= 0) {  // 실제 영향받은 행의 수만 합산
//					cnt += count;
//				} else if (count == -2 ) { // 정상적으로 수행됐지만, 영향 받은 행의 수를 알 수 없을 때
//					cnt += 1;
//				} else {
//					cnt -= 1;
//				}
//			}
//		}
//
//		Log.Debug("┌────────────────── {} Batch Delete Result ────────────────────────", queryId);
//		Log.Debug("│ total deleted rows : {}", cnt);
//		Log.Debug("└────────────────── {} Batch Delete Result ────────────────────────", queryId);
//
//		return cnt;
//	}
//	/**
//	 * param 값 변환
//	 *
//	 * @param params
//	 * @return
//	 */
//	@SuppressWarnings("unchecked")
//	public static Object convertParams(Object params) {
//		Object convert = null;
//		if (params instanceof Map) {
//			Map<String, Object> convertmap = (Map<String, Object>) params;
//			String[] ssnKeys = new String[] { "ssnEnterCd", "ssnLocaleCd", "ssnSearchType", "ssnGrpCd", "ssnBaseDate", "ssnSabun", "ssnEncodedKey", "ssnAdminYn" };
//			String[] excKeys = new String[] { "selectColumn", "selectViewQuery","query","memo","relUrl","sqlConv","sqlSyntax","executeSQL", "content", "helpTxtContent", "cols", "values", "templateContent"};
//			String[] inParam = daoInParam.split(",");
//			//String[] changeKeys = new String[] { "grpCd", "runType", "multiStatusCd"}; //columnInfo >> 이놈은 스트립트에서 자바로 변경해야한다
//			Arrays.stream(ssnKeys).filter(k -> SessionUtil.getRequestAttribute(k) != null).forEach(key ->  convertmap.put(key, SessionUtil.getRequestAttribute(key)));
//			Iterator<String> it = convertmap.keySet().iterator();
//			while(it.hasNext()){
//				String k = it.next();
//				Object v = convertmap.get(k);
//				//&& !k.startsWith("log")
//				if (v instanceof String && Arrays.asList(inParam).contains(k) && v != null && !v.equals("") && ((String) v).indexOf(",") != -1) {
//					convertmap.put(k,((String) v).split(","));
//				}
//			}
//
//			checkEmployeeSabun(convertmap);
//
//			convert = convertmap;
//		} else {
//			convert = params;
//		}
//
//		return convert;
//	}
//
//	private static void checkEmployeeSabun(Map<String, Object> map) {
//		//임직원 공통일때 본인 사번으로 제한
//		if (Arrays.stream(commonGrpCd.split(","))
//				.anyMatch(code -> code.equals(map.get("ssnGrpCd")))) {
//
//			String ssnSabun = String.valueOf(map.get("ssnSabun"));
//			Log.Debug("임직원 공통일때 본인 사번으로 제한");
//			Log.Debug("GetDataList paramMap==>" + map.toString());
//
//			try {
//				Arrays.stream(sabunParams.split(","))
//						.filter(map::containsKey)
//						.forEach(key -> map.put(key, ssnSabun));
//			} catch(Exception e) {
//				Log.Error("Error occured at checkEmployeeSabun => " + e.getLocalizedMessage());
//			}
//
//			Log.Debug("Changed map data ==>" + map.toString());
///*
//			map.put("sabun", ssnSabun);
//
//			// searchUserId 변조 방지
//			if (map.containsKey("searchUserId")) {
//				map.put("searchUserId", ssnSabun);
//			}
//*/
//		}
//	}
//
//}