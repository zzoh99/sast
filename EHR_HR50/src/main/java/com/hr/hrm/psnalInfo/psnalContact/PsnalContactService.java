package com.hr.hrm.psnalInfo.psnalContact;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 인사기본 Service
 *
 * @author 이름
 *
 */
@Service("PsnalContactService")
public class PsnalContactService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * getPsnalContactUserList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalContactUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalContactUserList", paramMap);
	}
	
	/**
	 * getPsnalContactAddressList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalContactAddressList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalContactAddressList", paramMap);
	}
	
	/**
	 * 인사기본 유저정보 수정 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updatePsnalContactTel(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updatePsnalContactTel", paramMap);
		dao.update("updatePsnalContactTel", paramMap);
		return cnt;
	}

	/**
	 * 인사기본 주소 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalContactAddress(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalContactAddress", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalContactAddress", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * savePsnalContactTel 주소 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalContactTel(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalContactTel", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}