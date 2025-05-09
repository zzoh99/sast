package com.hr.cpn.payApp.etcPayApp;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 기타지급신청 Service
 *
 * @author YSH
 *
 */
@Service("EtcPayAppService")
public class EtcPayAppService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 기타지급신청 삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteEtcPayApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		// detail 테이블 삭제
		dao.delete("deleteEtcPayAppDetail", convertMap);
		
		// master 테이블 삭제		
		dao.delete("deleteEtcPayApp", convertMap);

		Log.Debug();
		return cnt;
	}

}