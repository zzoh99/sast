package com.hr.hrm.apply.hrmApplyUser;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 임직원공통_인사신청 Service
 *
 * @author 이름
 *
 */
@Service("HrmApplyUserService")
public class HrmApplyUserService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 임직원공통_인사신청 인사신청 가능한 리스트 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<String, Object> getHrmApplyTypeUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<String, Object> map = new HashMap<>();
		map.put("basicApply", dao.getList("getHrmApplyTypeUserPsnalBasicAppList", paramMap));
		map.put("etcApply", dao.getList("getHrmApplyTypeUserAppList", paramMap));
		return map;
	}
}