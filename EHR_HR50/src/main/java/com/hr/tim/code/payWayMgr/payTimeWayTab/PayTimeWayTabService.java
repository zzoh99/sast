package com.hr.tim.code.payWayMgr.payTimeWayTab;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 근태사항 Service
 *
 * @author bckim
 *
 */
@Service("PayTimeWayTabService")
public class PayTimeWayTabService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 근태사항 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayTimeWayTabList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayTimeWayTabList", paramMap);
	}

	/**
	 * 근태사항 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayTimeWayTab(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayTimeWayTab", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayTimeWayTab", convertMap);
		}
		
		return cnt;
	}
}