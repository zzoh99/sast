package com.hr.cpn.payRetire.sepRateStd;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 개별퇴직가산율관리(임원) Service
 *
 * @author JM
 *
 */
@Service("SepRateStdService")
public class SepRateStdService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 개별퇴직가산율관리(임원) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepRateStdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepRateStdList", paramMap);
	}

	/**
	 * 개별퇴직가산율관리(임원) 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepRateStd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		int edateCnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSepRateStd", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSepRateStd", convertMap);
		}

		// 종료일 UPDATE
		if( ((List<?>)convertMap.get("insertRows")).size() > 0){
			edateCnt += dao.update("updateSepRateStdEdate", convertMap);
		}

		Log.Debug();
		return cnt;
	}
}