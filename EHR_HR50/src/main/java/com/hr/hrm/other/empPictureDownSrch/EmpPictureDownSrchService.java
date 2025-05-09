package com.hr.hrm.other.empPictureDownSrch;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 사원이미지조회/다운로드 Service
 *
 * @author bckim
 *
 */
@Service("EmpPictureDownSrchService")
public class EmpPictureDownSrchService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 사원이미지조회/다운로드 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpPictureDownSrchOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpPictureDownSrchOrgList", paramMap);
	}

	/**
	 * 사원이미지조회/다운로드 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpPictureDownSrchUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpPictureDownSrchUserList", paramMap);
	}

	/**
	 * 사원이미지조회/다운로드 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpPictureDownSrch(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpPictureDownSrch", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpPictureDownSrch", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}