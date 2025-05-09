package com.hr.hrd.trmCdMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 조직도관리 Service
 *
 * @author CBS
 *
 */
@Service("TrmCdMgrService")
public class TrmCdMgrService {
	@Inject
	@Named("Dao")
	private Dao dao;


	public List<?> getTrmCdMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTrmCdMgrList", paramMap);
	}

	
	/**
	 *  TRM조회화면 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTrmCdMgrList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		
		int cnt=0;

//		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
//			cnt += dao.delete("deleteTcdpw203", convertMap);
//		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTrmCdMgrList", convertMap);
		}
		
		Log.Debug();
		
		return cnt;
	}

}