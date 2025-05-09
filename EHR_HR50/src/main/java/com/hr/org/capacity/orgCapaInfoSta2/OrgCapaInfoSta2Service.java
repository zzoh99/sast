package com.hr.org.capacity.orgCapaInfoSta2;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 정원대비인원현황 Service
 * 
 * @author CBS
 *
 */
@Service("OrgCapaInfoSta2Service")  
public class OrgCapaInfoSta2Service{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 정원대비인원현황 sheet1 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgCapaInfoSta2Sheet1List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgCapaInfoSta2Sheet1List", paramMap);
	}
	
	public int saveOrgCapaInfoSta2(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgCapaInfoSta2", convertMap);
		}

		return cnt;
	}
	
}