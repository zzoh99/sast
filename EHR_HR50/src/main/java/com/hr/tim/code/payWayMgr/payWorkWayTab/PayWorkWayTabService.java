package com.hr.tim.code.payWayMgr.payWorkWayTab;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 근무사항 Service
 *
 * @author bckim
 *
 */
@Service("PayWorkWayTabService")
public class PayWorkWayTabService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 근무사항 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayWorkWayTabList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayWorkWayTabList", paramMap);
	}

	/**
	 * 근무사항 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayWorkWayTab(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayWorkWayTab", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayWorkWayTab", convertMap);
		}
		
		return cnt;
	}
}