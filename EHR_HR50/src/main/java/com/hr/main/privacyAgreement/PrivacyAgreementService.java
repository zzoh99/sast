package com.hr.main.privacyAgreement;
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
@Service("PrivacyAgreementService")  
public class PrivacyAgreementService{
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
	public List<?> getPrivacyAgreementList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPrivacyAgreementList", paramMap);
	}	
	
	/**
	 * 메뉴명 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPrivacyAgreementMaster(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPrivacyAgreementMaster", paramMap);
	}	
	
	/**
	 *  메뉴명 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPrivacyAgreementMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPrivacyAgreementMap", paramMap);
	}
	/**
	 *  메뉴명 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPrivacyAgreementMasterNoMinMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPrivacyAgreementMasterNoMinMap", paramMap);
	}
	
	/**
	 * 메뉴명 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePrivacyAgreement(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePrivacyAgreement", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePrivacyAgreement", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 메뉴명 생성 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertPrivacyAgreement(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.create("insertPrivacyAgreement", paramMap);
	}


}