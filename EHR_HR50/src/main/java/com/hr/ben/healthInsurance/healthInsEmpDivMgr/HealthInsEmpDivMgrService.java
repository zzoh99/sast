package com.hr.ben.healthInsurance.healthInsEmpDivMgr;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * HealthInsEmpDivMgr Service
 *
 * @author EW
 *
 */
@Service("HealthInsEmpDivMgrService")
public class HealthInsEmpDivMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * HealthInsEmpDivMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHealthInsEmpDivMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHealthInsEmpDivMgrList", paramMap);
	}

	/**
	 * HealthInsEmpDivMgr 저장 Service
	 *
	 * @param convertMapDetail
	 * @return int
	 * @throws Exception
	 */
	public int saveHealthInsEmpDivMgr(Map<?, ?> convertMapDetail) throws Exception {
		Log.Debug();
		int cnt=0;

		HashMap<String, Object> returnMap 	= new HashMap<>();

		List<Serializable>  mergeRows		= new ArrayList<>();
		List<Serializable>  insertRows		= new ArrayList<>();
		List<Serializable>  updateRows 		= new ArrayList<>();
		List<Serializable>  deleteRows 		= new ArrayList<>();


		if( ((List<?>)convertMapDetail.get("deleteRows")).size() > 0){

			List<?> list = ((List<?>)convertMapDetail.get("deleteRows"));

			int totCnt = ((List<?>)convertMapDetail.get("deleteRows")).size();
			int chkCnt = 0;
			int nCnt = totCnt%100;

			for(int i=0; i < list.size(); i++){

				HashMap<String, String> map  =  (HashMap<String, String>)list.get(i);

				map.put("ssnEnterCd",(String) convertMapDetail.get("ssnEnterCd"));
				map.put("ssnSabun",(String) convertMapDetail.get("ssnSabun"));

				if( 	map.get("sStatus").equals("I") ){ insertRows.add(map); mergeRows.add(map);}
				else if(map.get("sStatus").equals("U") ){ updateRows.add(map); mergeRows.add(map);}
				else if(map.get("sStatus").equals("D") ){ deleteRows.add(map); }

				returnMap.put( "mergeRows" , mergeRows );
				returnMap.put( "insertRows" , insertRows );
				returnMap.put( "updateRows" , updateRows );
				returnMap.put( "deleteRows" , deleteRows );

				if( totCnt >= chkCnt ){
					chkCnt++;
				}

				if ( chkCnt == 100 ){
					returnMap.put("ssnEnterCd", convertMapDetail.get("ssnEnterCd"));
					returnMap.put("ssnSabun", convertMapDetail.get("ssnSabun"));
					cnt += dao.update("deleteHealthInsEmpDivMgr", returnMap);
					totCnt = totCnt - chkCnt;
					chkCnt = 0;
					mergeRows		= new ArrayList<>();
					insertRows		= new ArrayList<>();
					updateRows 		= new ArrayList<>();
					deleteRows 		= new ArrayList<>();
				}else {
					if ( totCnt == nCnt && totCnt == chkCnt ){
						returnMap.put("ssnEnterCd", convertMapDetail.get("ssnEnterCd"));
						returnMap.put("ssnSabun", convertMapDetail.get("ssnSabun"));
						cnt += dao.update("deleteHealthInsEmpDivMgr", returnMap);
					}
				}
			}
		}
		if( ((List<?>)convertMapDetail.get("mergeRows")).size() > 0){

			List<?> list = ((List<?>)convertMapDetail.get("mergeRows"));

			int totCnt = ((List<?>)convertMapDetail.get("mergeRows")).size();
			int chkCnt = 0;
			int nCnt = totCnt%100;

			for(int i=0; i < list.size(); i++){

				HashMap<String, String> map  =  (HashMap<String, String>)list.get(i);

				map.put("ssnEnterCd",(String) convertMapDetail.get("ssnEnterCd"));
				map.put("ssnSabun",(String) convertMapDetail.get("ssnSabun"));

				if( 	map.get("sStatus").equals("I") ){ insertRows.add(map); mergeRows.add(map);}
				else if(map.get("sStatus").equals("U") ){ updateRows.add(map); mergeRows.add(map);}
				else if(map.get("sStatus").equals("D") ){ deleteRows.add(map); }

				returnMap.put( "mergeRows" , mergeRows );
				returnMap.put( "insertRows" , insertRows );
				returnMap.put( "updateRows" , updateRows );
				returnMap.put( "deleteRows" , deleteRows );

				if( totCnt >= chkCnt ){
					chkCnt++;
				}

				if ( chkCnt == 100 ){
					returnMap.put("ssnEnterCd", convertMapDetail.get("ssnEnterCd"));
					returnMap.put("ssnSabun", convertMapDetail.get("ssnSabun"));
					returnMap.put("searchBaseYmd", convertMapDetail.get("searchBaseYmd"));
					cnt += dao.update("saveHealthInsEmpDivMgr", returnMap);
					totCnt = totCnt - chkCnt;
					chkCnt = 0;
					mergeRows		= new ArrayList<>();
					insertRows		= new ArrayList<>();
					updateRows 		= new ArrayList<>();
					deleteRows 		= new ArrayList<>();
				}else {
					if ( totCnt == nCnt && totCnt == chkCnt ){
						returnMap.put("ssnEnterCd", convertMapDetail.get("ssnEnterCd"));
						returnMap.put("ssnSabun", convertMapDetail.get("ssnSabun"));
						returnMap.put("searchBaseYmd", convertMapDetail.get("searchBaseYmd"));
						cnt += dao.update("saveHealthInsEmpDivMgr", returnMap);
					}
				}
			}
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * HealthInsEmpDivMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHealthInsEmpDivMgrList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHealthInsEmpDivMgrList2", paramMap);
	}

	/**
	 * HealthInsEmpDivMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveHealthInsEmpDivMgr2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteHealthInsEmpDivMgr2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveHealthInsEmpDivMgr2", convertMap);
		}

		return cnt;
	}
	
	/**
	 * HealthInsEmpDivMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHealthInsEmpDivMgrList3(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHealthInsEmpDivMgrList3", paramMap);
	}
	
	/**
	 * contractCre 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<String, Object> prcCreateHealthInsEmpDiv(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<String, Object>) dao.excute("prcCreateHealthInsEmpDiv", paramMap);
	}

	/**
	 * 건강보험 연말정산 분할납부 횟수 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<String, Object> getHealthInsEmpDivMgrTab1DivCnt(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (Map<String, Object>) dao.getMap("getHealthInsEmpDivMgrTab1DivCnt", paramMap);
	}
	
}
