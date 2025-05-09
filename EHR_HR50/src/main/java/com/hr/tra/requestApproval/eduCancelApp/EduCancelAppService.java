package com.hr.tra.requestApproval.eduCancelApp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 교육취소신청 Service
 *
 * @author 이름
 *
 */
@Service("EduCancelAppService")
public class EduCancelAppService {
	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * 교육취소신청 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteEduCancelApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduCancelApp", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}
		return cnt;
	}
}
