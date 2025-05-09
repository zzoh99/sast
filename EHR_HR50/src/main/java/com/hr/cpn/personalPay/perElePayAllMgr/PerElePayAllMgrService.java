package com.hr.cpn.personalPay.perElePayAllMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 메뉴명 Service
 * 
 * @author 이름
 *
 */
@Service("PerElePayAllMgrService")  
public class PerElePayAllMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 메뉴명 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerElePayAllMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerElePayAllMgrList", paramMap);
	}	
	/**
	 *  메뉴명 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPerElePayAllMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPerElePayAllMgrMap", paramMap);
	}
	/**
	 * 메뉴명 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePerElePayAllMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePerElePayAllMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePerElePayAllMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	
	/**
	 * 항목별예외처리관리 종료일자 UPDATE
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN292_EDATE_UPDATE(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("prcP_CPN292_EDATE_UPDATE", paramMap);
	}
}