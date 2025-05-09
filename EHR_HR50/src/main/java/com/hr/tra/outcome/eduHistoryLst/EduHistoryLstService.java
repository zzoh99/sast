package com.hr.tra.outcome.eduHistoryLst;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * Load Service
 *
 * @author JSG
 *
 */
@Service("EduHistoryLstService")
public class EduHistoryLstService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 교육이력관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduHistoryLstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduHistoryLstList", paramMap);
	}

	/**
	 * 교육이력관리 저장 Service
	 *
	 * @param convertMap
	 * @return List
	 * @throws Exception
	 */
	public int saveEduHistoryLst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduHistoryLst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEduHistoryLst", convertMap);
		}

		return cnt;
	}

	/**
	 * 엑셀업로드 후 검사 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public List<?> getEduHistoryLstChk(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		List<Map<String,Object>> mergeList = (List<Map<String,Object>>)convertMap.get("mergeRows");
		List<Map<String,Object>>  returnRows		= new ArrayList<Map<String,Object>>();
		
		if( mergeList.size() > 0){
			for(Map<String,Object> mp : mergeList) {

				Map<String,Object> chkMap = (Map<String,Object>)dao.getMap("getEduHistoryLstChk", mp);
				if( chkMap != null && chkMap.get("eduSeq") != null ){
					returnRows.add(chkMap);
				}else{
					returnRows.add(mp);
				}
			}
		}
		return returnRows;
	}
}