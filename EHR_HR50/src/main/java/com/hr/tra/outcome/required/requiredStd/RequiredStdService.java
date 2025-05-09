package com.hr.tra.outcome.required.requiredStd;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 필수교육과정기준관리 Service
 * 
 * @author 이름
 *
 */
@Service("RequiredStdService")  
public class RequiredStdService{
	@Inject
	@Named("Dao")
	private Dao dao;
	

	/**
	 * 필수교육과정기준관리 전년도복사 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRequiredStdYear(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		dao.delete("deleteRequiredStdYear", convertMap);
		cnt += dao.update("saveRequiredStdYear", convertMap); 

		return cnt;
	}
}