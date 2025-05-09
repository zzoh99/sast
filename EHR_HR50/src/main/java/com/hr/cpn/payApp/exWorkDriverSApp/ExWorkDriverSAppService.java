package com.hr.cpn.payApp.exWorkDriverSApp;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 특근수당(기원) 종합신청 Service
 *
 * @author YSH
 *
 */
@Service("ExWorkDriverSAppService")
public class ExWorkDriverSAppService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 특근수당(기원) 종합신청 삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteExWorkDriverSApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		// detail 테이블 삭제
		cnt = cnt + dao.delete("deleteExWorkDriverSAppDetail", convertMap);
		
		// master 테이블 삭제		
		cnt = cnt + dao.delete("deleteExWorkDriverSApp", convertMap);

		Log.Debug();
		return cnt;
	}

}