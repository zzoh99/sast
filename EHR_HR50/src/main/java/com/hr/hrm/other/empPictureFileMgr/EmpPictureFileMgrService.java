package com.hr.hrm.other.empPictureFileMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 사원이미지관리(파일등록) Service
 *
 * @author bckim
 *
 */
@Service("EmpPictureFileMgrService")
public class EmpPictureFileMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 사원이미지관리(파일등록) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpPictureFileMgrOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpPictureFileMgrOrgList", paramMap);
	}

	/**
	 * 사원이미지관리(파일등록) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpPictureFileMgrUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpPictureFileMgrUserList", paramMap);
	}

	/**
	 * 사원이미지관리(파일등록) 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpPictureFileMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpPictureFileMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpPictureFileMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}