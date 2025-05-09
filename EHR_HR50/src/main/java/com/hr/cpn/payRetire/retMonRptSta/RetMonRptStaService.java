package com.hr.cpn.payRetire.retMonRptSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * retMonRptSta Service
 *
 * @author EW
 *
 */
@Service("RetMonRptStaService")
public class RetMonRptStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * retMonRptSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetMonRptStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetMonRptStaList", paramMap);
	}

	/**
	 * retMonRptSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetMonRptSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRetMonRptSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetMonRptSta", convertMap);
		}

		return cnt;
	}
	/**
	 * retMonRptSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getRetMonRptStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getRetMonRptStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
