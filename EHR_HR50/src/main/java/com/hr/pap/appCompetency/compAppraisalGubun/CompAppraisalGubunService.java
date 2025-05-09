package com.hr.pap.appCompetency.compAppraisalGubun;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 리더십진단항목정의 Service
 *
 * @author JSG
 *
 */
@Service("CompAppraisalGubunService")
public class CompAppraisalGubunService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 리더십진단항목정의 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompAppraisalGubunList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompAppraisalGubunList", paramMap);
	}

	/**
	 * 리더십진단항목정의 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompAppraisalGubun(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCompAppraisalGubun", convertMap);
		}
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCompAppraisalGubun_991", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCompAppraisalGubun", convertMap);
		}
		Log.Debug();
		return cnt;
	}

    public List<?> getAppGroupMgrRngPopList1(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getAppGroupMgrRngPopList1", paramMap);
    }
}