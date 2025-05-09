package com.hr.pap.evaluation.mltsrcEvlt;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 개인별 다면평가 Service
 *
 * @author JCY
 *
 */
@Service("MltsrcEvltService")
public class MltsrcEvltService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 *  개인별 다면평가 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getMltsrcEvltMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMltsrcEvltMap", paramMap);
	}
	/**
	 * 개인별 다면평가 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMltsrcEvlt(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMltsrcEvlt", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMltsrcEvlt", convertMap);
		}

		//평가의견 저장
		cnt += dao.update("saveMltsrcEvltMemo", convertMap);

		//평가점수 합산
		dao.excute("prcMltsrcEvltUpd", convertMap);


		Log.Debug();
		return cnt;
	}


	/**
     * 개인별 다면평가 저장 -  - (평가완료)
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public Map prcMltsrcEvlt(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (Map) dao.excute("prcMltsrcEvlt", paramMap);
    }

	/**
	 * 개인별 다면평가 의견 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMltsrcEvltAppItemOpinion(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMltsrcEvltAppItemOpinion", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}