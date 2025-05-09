package com.hr.ben.famResUpd;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 복리후생 가족주민번호 갱신 Service
 *
 * @author EW
 *
 */
@Service("FamResUpdService")
public class FamResUpdService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 복리후생 가족주민번호 갱신 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveFamResUpd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveFamResUpd751", convertMap); //학자금
			cnt += dao.update("saveFamResUpd703", convertMap); //의료비
		}

		return cnt;
	}
}
