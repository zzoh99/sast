package com.hr.hri.applicationBasis.appPathReg;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 개인 신청 결재 Service
 *
 * @author ParkMoohun
 *
 */

@Service("AppPathRegService")
public class AppPathRegService{

	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 개인 신청 결재 결재 경로 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppPathRegList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppPathRegList", paramMap);
	}
	/**
	 * 개인 신청 결재 결재자 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppPathRegOrgUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppPathRegOrgUserList", paramMap);
	}

	/**
	 * 사원리스트 (Token발생) Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgUserTokenList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getOrgUserTokenList", paramMap);
	}


	/**
	 * 개인 신청 결재 결재자 조직도 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppPathOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppPathOrgList", paramMap);
	}
	/**
	 * 개인 신청 결재 결재선 내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppPathRegApplList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppPathRegApplList", paramMap);
	}
	/**
	 * 개인 신청 결재 참조 내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppPathRegReferList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppPathRegReferList", paramMap);
	}

	/**
	 * @param convertMap
	 * @return Int
	 * @throws Exception
	 */
	public int saveAppPathReg(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppPathReg127", convertMap);
			cnt += dao.delete("deleteAppPathReg105", convertMap);
			cnt += dao.delete("deleteAppPathReg", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppPathReg", convertMap);
		}
		if( ((List<?>)convertMap.get("insertRows")).size() > 0){
			dao.update("saveAppPathRegAppl2", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * @param convertMap
	 * @return Int
	 * @throws Exception
	 */
	public int saveAppPathRegAppl(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppPathRegAppl", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppPathRegAppl", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * @param convertMap
	 * @return Int
	 * @throws Exception
	 */
	public int saveAppPathRegRefer(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppPathRegRefer", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppPathRegRefer", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 개인 신청 결재 결재선 내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getChar(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getChar", paramMap);
	}

}