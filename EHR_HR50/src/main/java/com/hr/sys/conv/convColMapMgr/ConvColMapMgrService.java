package com.hr.sys.conv.convColMapMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 이관컬럼매핑관리 Service
 *
 * @author bckim
 *
 */
@Service("ConvColMapMgrService")
public class ConvColMapMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 이관컬럼매핑관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getConvColMapMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getConvColMapMgrList", paramMap);
	}

	/**
	 * 이관컬럼매핑관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveConvColMapMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteConvColMapMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveConvColMapMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 이관컬럼매핑관리(원본컬럼 생성) 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcConvColMapMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcConvColMapMgr", paramMap);
	}
	
	/**
	 * 복사본의 빈 칼럼 맞춤 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcConvColMapMgr2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcConvColMapMgr2", paramMap);
	}	

}