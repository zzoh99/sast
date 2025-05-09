package com.hr.cpn.payUpload.payUploadEleMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 업로드항목관리 Service
 *
 */
@Service("PayUploadEleMgrService")
public class PayUploadEleMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 업로드항목관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayUploadEleMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayUploadEleMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayUploadEleMgr", convertMap);
		}

		return cnt;
	}

}