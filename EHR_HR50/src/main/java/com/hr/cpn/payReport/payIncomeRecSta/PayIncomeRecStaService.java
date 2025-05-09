package com.hr.cpn.payReport.payIncomeRecSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * payIncomeRecSta Service
 *
 * @author EW
 *
 */
@Service("PayIncomeRecStaService")
public class PayIncomeRecStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * payIncomeRecSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayIncomeRecStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayIncomeRecStaList", paramMap);
	}

	/**
	 * payIncomeRecSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayIncomeRecSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayIncomeRecSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayIncomeRecSta", convertMap);
		}

		return cnt;
	}
	/**
	 * payIncomeRecSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPayIncomeRecStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPayIncomeRecStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
