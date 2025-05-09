package com.hr.hrd.code.careerTarget;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("CareerTargetService")
public class CareerTargetService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getCareerTargetList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getCareerTargetList", paramMap);
	}

	public int saveCareerTarget(Map<?, ?> convertMap) throws Exception {
	int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCareerTarget", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCareerTarget", convertMap);
		}

		return cnt;
	}

	public int deleteCareerTarget(Map<?, ?> paramMap) throws Exception {
		return dao.delete("deleteCareerTarget", paramMap);
	}

	public List<?> getCareerPathDetailSHT1(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getCareerPathDetailSHT1", paramMap);
	}

	public List<?> getCareerPathDetailSHT2(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getCareerPathDetailSHT2", paramMap);
	}

	public int saveCareerPathDetailSHT2(Map<?, ?> convertMap) throws Exception {
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCareerPathDetailSHT2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCareerPathDetailSHT2", convertMap);
		}

		return cnt;
	}
	public int saveCareerMapEmpty(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("saveCareerMapEmpty", paramMap);
	}

	/**
	 * 근로계약서관리 Contents 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCareerMapContents(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = dao.updateClob("saveCareerMapContents", convertMap);
		Log.Debug();
		return cnt;
	}
}
