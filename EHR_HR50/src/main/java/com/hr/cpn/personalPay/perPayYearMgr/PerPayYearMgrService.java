package com.hr.cpn.personalPay.perPayYearMgr;
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
 * 연봉관리 Service
 *
 * @author JSG
 *
 */
@Service("PerPayYearMgrService")
public class PerPayYearMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 연봉관리 title 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayYearMgrTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerPayYearMgrTitleList", paramMap);
	}
	
	/**
	 * 연봉관리 title 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayYearEleGroupCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerPayYearEleGroupCodeList", paramMap);
	}
	/**
	 * 연봉관리 title 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayYearMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerPayYearMgrList", paramMap);
	}
	
	

	/**
	 * 연봉관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePerPayYearMgr(Map<?, ?> convertMapDetail, Map<?, ?> convertMapMaster) throws Exception {
		Log.Debug();
		int cnt=0;

		HashMap<String, Object> returnMap 	= new HashMap<String, Object>();

		List<Serializable>  mergeRows		= new ArrayList<Serializable>();
		List<Serializable>  insertRows		= new ArrayList<Serializable>();
		List<Serializable>  updateRows 		= new ArrayList<Serializable>();
		List<Serializable>  deleteRows 		= new ArrayList<Serializable>();


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
					returnMap.put("ssnEnterCd",(String) convertMapDetail.get("ssnEnterCd"));
					returnMap.put("ssnSabun",(String) convertMapDetail.get("ssnSabun"));
					cnt += dao.update("deletePerPayYearMgrFirst", returnMap);
					cnt += dao.update("deletePerPayYearMgrSecond", returnMap);
					totCnt = totCnt - chkCnt;
					chkCnt = 0;
					mergeRows		= new ArrayList<Serializable>();
					insertRows		= new ArrayList<Serializable>();
					updateRows 		= new ArrayList<Serializable>();
					deleteRows 		= new ArrayList<Serializable>();
				}else {
					if ( totCnt == nCnt && totCnt == chkCnt ){
						returnMap.put("ssnEnterCd",(String) convertMapDetail.get("ssnEnterCd"));
						returnMap.put("ssnSabun",(String) convertMapDetail.get("ssnSabun"));
						cnt += dao.update("deletePerPayYearMgrFirst", returnMap);
						cnt += dao.update("deletePerPayYearMgrSecond", returnMap);
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
					returnMap.put("ssnEnterCd",(String) convertMapDetail.get("ssnEnterCd"));
					returnMap.put("ssnSabun",(String) convertMapDetail.get("ssnSabun"));
					cnt += dao.update("savePerPayYearMgr", returnMap);
					totCnt = totCnt - chkCnt;
					chkCnt = 0;
					mergeRows		= new ArrayList<Serializable>();
					insertRows		= new ArrayList<Serializable>();
					updateRows 		= new ArrayList<Serializable>();
					deleteRows 		= new ArrayList<Serializable>();
				}else {
					if ( totCnt == nCnt && totCnt == chkCnt ){
						returnMap.put("ssnEnterCd",(String) convertMapDetail.get("ssnEnterCd"));
						returnMap.put("ssnSabun",(String) convertMapDetail.get("ssnSabun"));
						cnt += dao.update("savePerPayYearMgr", returnMap);
					}
				}

			}
			cnt += dao.update("savePerPayYearMgrSecond", convertMapMaster);
		}

		Log.Debug();
		return cnt;
	}
	
	/**
	 * 연봉관리종료일자 UPDATE
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN403_EDATE_UPDATE(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("prcP_CPN403_EDATE_UPDATE", paramMap);
	}
	

}