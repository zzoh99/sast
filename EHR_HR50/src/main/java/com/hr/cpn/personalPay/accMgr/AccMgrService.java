package com.hr.cpn.personalPay.accMgr;
import java.util.HashMap;
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
@Service("AccMgrService")
public class AccMgrService{
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
	public List<?> getAccMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAccMgrList", paramMap);
	}
	/**
	 *  메뉴명 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAccMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAccMgrMap", paramMap);
	}
	/**
	 * 메뉴명 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAccMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAccMgr", convertMap);
			dao.delete("deleteAccMgrTCPN183", convertMap);

			List<Map> deleteList = (List<Map>)convertMap.get("deleteRows");
			for(Map<String,Object> mp : deleteList) {

				Map<String,Object> executeMap = new HashMap<String,Object>();
				executeMap.put("ssnEnterCd",   convertMap.get("ssnEnterCd"));
				executeMap.put("ssnSabun",     convertMap.get("ssnSabun"));
				executeMap.put("sabun",        mp.get("sabun"));
				executeMap.put("accountType",  mp.get("accountType"));

				dao.update("updatePerAccChgTCPN180", executeMap);
			}

		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAccMgr", convertMap);
			cnt += dao.update("saveAccMgrTCPN183", convertMap);

			List<Map> mergeList = (List<Map>)convertMap.get("mergeRows");
			for(Map<String,Object> mp : mergeList) {

				Map<String,Object> executeMap = new HashMap<String,Object>();
				executeMap.put("ssnEnterCd",   convertMap.get("ssnEnterCd"));
				executeMap.put("ssnSabun",     convertMap.get("ssnSabun"));
				executeMap.put("sabun",        mp.get("sabun"));
				executeMap.put("accountType",  mp.get("accountType"));

				dao.update("updatePerAccChgTCPN180", executeMap);
			}
		}
		Log.Debug();
		return cnt;
	}


}