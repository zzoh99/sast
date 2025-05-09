package com.hr.common.aop;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.apache.ibatis.mapping.BoundSql;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * 공통 DAO
 * @author ParkMoohun
 */
@Service
public class LoggingDao{

//	@Inject
//	@Named("queryService")
//	private QueryService queryService;

	@Autowired
	private SqlSessionTemplate sqlSession;

	public String getQueryString(String queryId, Object param){

		//쿼리 바인딩 준비
		BoundSql boundSql = sqlSession.getConfiguration().getMappedStatement(queryId).getBoundSql(param);
		//파라미터가 ?로 표시된 쿼리
		// query의 ? 순서대로 나열된 리스트
		//List<ParameterMapping> parameterMapping = boundSql.getParameterMappings();

		/* 결과값
		 * ["param.idx1", "param.idx2", "param.session.userid"]
		 */

		return boundSql.getSql();
	}

	/**
	 * 데이터 갱신
	 *
	 * @param queryId
	 * @param params
	 * @return int
	 * @throws Exception
	 */
	public int update(String queryId, Object params) throws Exception {
		params = Dao.convertParams(params);
		Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
		int cnt = sqlSession.update(queryId, params);
		Log.Debug("┌────────────────── {} Update Result ────────────────────────", queryId);
		Log.Debug("│  cnt : {}", cnt);
		Log.Debug("└────────────────── {} Update Result ────────────────────────", queryId);
		return cnt;
	}

	/**
	 * Procedure
	 *
	 * @param queryId
	 * @param params
	 * @return Object
	 * @throws Exception
	 */
	public Object execute(String queryId, Object params)  {
		params = Dao.convertParams(params);
		Log.Debug("\n■■■■■■■■■ [ execute queryId : {} ] ■■■■■■■■■\n", queryId);
		sqlSession.update(queryId, params);
		return params;
	}

	/**
	 * Map Type 단행 조회
	 *
	 * @param queryId
	 * @param params
	 * @return Collection
	 * @throws Exception
	 */
	public Map<?, ?> getMap(String queryId, Object params) throws Exception {
		params = Dao.convertParams(params);
		Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
		Map<?,?> map = null;

		try {
			List<?> list = sqlSession.selectList(queryId, params);
			if(!list.isEmpty()) {
				map = (Map<?, ?>) list.get(0);
				Log.Debug("┌────────────────── {} Result Map Start────────────────────────", queryId);
				Log.Debug("│  {}", map);
				Log.Debug("└────────────────── {} Result Map End──────────────────────────", queryId);
			} else {
				Log.Debug("─────────────────── {} Result Map Is Null ─────────────────────", queryId);
			}
		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
		}

		return map;
	}

}