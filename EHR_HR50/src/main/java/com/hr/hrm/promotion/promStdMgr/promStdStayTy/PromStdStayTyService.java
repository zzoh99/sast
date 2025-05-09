package com.hr.hrm.promotion.promStdMgr.promStdStayTy;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 승진기준관리 Service
 * 
 * @author 이름
 *
 */
@Service("PromStdStayTyService")  
public class PromStdStayTyService{
	
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 승진년차 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPromStdStayTyList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPromStdStayTyList", paramMap);
	}	
	
	/**
	 * 승진년차 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePromStdStayTy(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePromStdStayTy", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePromStdStayTy", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 가감점 포상사항 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPromStdStayTyPrizeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPromStdStayTyPrizeList", paramMap);
	}

	/**
	 * 가감점 포상사항 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePromStdStayTyPrize(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePromStdStayTyPrize", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePromStdStayTyPrize", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 가감점 징계사항 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPromStdStayTyPunishList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPromStdStayTyPunishList", paramMap);
	}

	/**
	 * 가감점 징계사항 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePromStdStayTyPunish(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePromStdStayTyPunish", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePromStdStayTyPunish", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 가감점 자격사항 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPromStdStayTyLicenseList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPromStdStayTyLicenseList", paramMap);
	}

	/**
	 * 가감점 자격사항 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePromStdStayTyLicense(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePromStdStayTyLicense", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePromStdStayTyLicense", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 가감점 근태사항 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPromStdStayTyGntList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPromStdStayTyGntList", paramMap);
	}

	/**
	 * 가감점 근태사항 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePromStdStayTyGnt(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePromStdStayTyGnt", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePromStdStayTyGnt", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}