package com.hr.cpn.payApp.deptPartPayApp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 수당지급신청 Service
 *
 * @author YSH
 *
 */
@Service("DeptPartPayAppService")
public class DeptPartPayAppService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 수당지급신청 삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteDeptPartPayApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		// detail 테이블 삭제
		dao.delete("deleteDeptPartPayAppDetail", convertMap);
		
		// master 테이블 삭제		
		dao.delete("deleteDeptPartPayApp", convertMap);

		Log.Debug();
		return cnt;
	}

    public List<?> getDeptPartPayAppList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getDeptPartPayAppList", paramMap);
    }

    public List<?> getDeptPartPayAppDetailList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getDeptPartPayAppDetailList", paramMap);
    }
}