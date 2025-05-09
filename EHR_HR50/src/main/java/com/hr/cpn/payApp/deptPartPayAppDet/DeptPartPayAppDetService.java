package com.hr.cpn.payApp.deptPartPayAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 수당지급신청 세부내역 Service
 *
 * @author  YSH
 *
 */
@Service("DeptPartPayAppDetService")
public class DeptPartPayAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 수당지급신청 세부내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getDeptPartPayAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getDeptPartPayAppDetList", paramMap);
	}

	/**
	 * 수당지급신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveDeptPartPayAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		//수당지급신청 Master (TCPN431) 저장
		//cnt += dao.update("insertDeptPartPayApp", convertMap);
		cnt += dao.update("saveDeptPartPayApp", convertMap);
		
		//수당지급신청 Detail (TCPN433) 저장
		cnt += dao.update("saveDeptPartPayAppDet", convertMap);

		Log.Debug();
		return cnt;
	}

	
}