package com.hr.tim.code.payWayMgr.payWorkTimeRewardTab;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 근무보상기준관리 Service
 *
 * @author
 *
 */
@Service("PayWorkTimeRewardTabService")
public class PayWorkTimeRewardTabService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  근무보상기준관리 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayWorkTimeRewardTabList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayWorkTimeRewardTabList", paramMap);
	}

	/**
	 *  근무보상기준관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayWorkTimeRewardTab(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayWorkTimeRewardTab", convertMap);
			dao.delete("deletePayWorkTimeRewardTabDetail", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayWorkTimeRewardTab", convertMap);
		}

		Log.Debug();
		return cnt;
	}
}