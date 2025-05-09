package com.hr.cpn.common.cpnQuery;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 복리후생 공통쿼리 Service
 *
 * @author JM
 *
 */
@Service("CpnQueryService")
public class CpnQueryService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 복리후생 공통쿼리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCpnQueryList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList(paramMap.get("queryId").toString(), paramMap);
	}

	/**
	 * 복리후생 공통쿼리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCpnQuery(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		int cnt = dao.update(paramMap.get("queryId").toString(), paramMap);

		return cnt;
	}
}