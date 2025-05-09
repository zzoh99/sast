package com.hr.eis.hrm.welfareJangaeEmpSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * welfareJangaeEmpSta Service
 *
 * @author EW
 *
 */
@Service("WelfareJangaeEmpStaService")
public class WelfareJangaeEmpStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * welfareJangaeEmpSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWelfareJangaeEmpStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWelfareJangaeEmpStaList", paramMap);
	}

	/**
	 * welfareJangaeEmpSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWelfareJangaeEmpSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWelfareJangaeEmpSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWelfareJangaeEmpSta", convertMap);
		}

		return cnt;
	}
	/**
	 * welfareJangaeEmpSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWelfareJangaeEmpStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWelfareJangaeEmpStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
