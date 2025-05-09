package com.hr.tra.outcome.cyberEduLoad;
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
 * 사이버교육Load Service
 *
 * @author JSG
 *
 */
@Service("CyberEduLoadService")
public class CyberEduLoadService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 사이버교육Load 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCyberEduLoadList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCyberEduLoadList", paramMap);
	}
	
	/**
	 * 사이버교육Load 자료반영 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcCyberEduLoad(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcCyberEduLoad", paramMap);
	}

	/**
	 *  저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCyberEduLoad(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		HashMap<String, Object> returnMap 	= new HashMap<String, Object>();

		List<Serializable>  mergeRows		= new ArrayList<Serializable>();
		List<Serializable>  insertRows		= new ArrayList<Serializable>();
		List<Serializable>  updateRows 		= new ArrayList<Serializable>();
		List<Serializable>  deleteRows 		= new ArrayList<Serializable>();


		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){

			List<?> list = ((List<?>)convertMap.get("deleteRows"));

			int totCnt = ((List<?>)convertMap.get("deleteRows")).size();
			int chkCnt = 0;
			int nCnt = totCnt%100;

			for(int i=0; i < list.size(); i++){

				HashMap<String, String> map  =  (HashMap<String, String>)list.get(i);

				map.put("ssnEnterCd",(String) convertMap.get("ssnEnterCd"));
				map.put("ssnSabun",(String) convertMap.get("ssnSabun"));

				if( 	map.get("sStatus").equals("I") ){ insertRows.add(map); mergeRows.add(map);}
				else if(map.get("sStatus").equals("U") ){ updateRows.add(map); mergeRows.add(map);}
				else if(map.get("sStatus").equals("D") ){ deleteRows.add(map); }

				returnMap.put( "mergeRows" , mergeRows );
				returnMap.put( "insertRows" , insertRows );
				returnMap.put( "updateRows" , updateRows );
				returnMap.put( "deleteRows" , deleteRows );
				returnMap.put( "searchYm", (String)convertMap.get("searchYm"));

				if( totCnt >= chkCnt ){
					chkCnt++;
				}

				if ( chkCnt == 100 ){
					returnMap.put("ssnEnterCd",(String) convertMap.get("ssnEnterCd"));
					returnMap.put("ssnSabun",(String) convertMap.get("ssnSabun"));
					cnt += dao.update("deleteCyberEduLoad", returnMap);
					cnt += dao.delete("deleteCyberEduLoad301", returnMap);
					totCnt = totCnt - chkCnt;
					chkCnt = 0;
					mergeRows		= new ArrayList<Serializable>();
					insertRows		= new ArrayList<Serializable>();
					updateRows 		= new ArrayList<Serializable>();
					deleteRows 		= new ArrayList<Serializable>();
				}else {
					if ( totCnt == nCnt && totCnt == chkCnt ){
						returnMap.put("ssnEnterCd",(String) convertMap.get("ssnEnterCd"));
						returnMap.put("ssnSabun",(String) convertMap.get("ssnSabun"));
						cnt += dao.update("deleteCyberEduLoad", returnMap);
						cnt += dao.delete("deleteCyberEduLoad301", returnMap);
					}
				}

			}
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){

			List<?> list = ((List<?>)convertMap.get("mergeRows"));

			int totCnt = ((List<?>)convertMap.get("mergeRows")).size();
			int chkCnt = 0;
			int nCnt = totCnt%100;

			for(int i=0; i < list.size(); i++){

				HashMap<String, String> map  =  (HashMap<String, String>)list.get(i);

				map.put("ssnEnterCd",(String) convertMap.get("ssnEnterCd"));
				map.put("ssnSabun",(String) convertMap.get("ssnSabun"));

				if( 	map.get("sStatus").equals("I") ){ insertRows.add(map); mergeRows.add(map);}
				else if(map.get("sStatus").equals("U") ){ updateRows.add(map); mergeRows.add(map);}
				else if(map.get("sStatus").equals("D") ){ deleteRows.add(map); }

				returnMap.put( "mergeRows" , mergeRows );
				returnMap.put( "insertRows" , insertRows );
				returnMap.put( "updateRows" , updateRows );
				returnMap.put( "deleteRows" , deleteRows );
				returnMap.put( "searchYm", (String)convertMap.get("searchYm"));

				if( totCnt >= chkCnt ){
					chkCnt++;
				}

				if ( chkCnt == 100 ){
					returnMap.put("ssnEnterCd",(String) convertMap.get("ssnEnterCd"));
					returnMap.put("ssnSabun",(String) convertMap.get("ssnSabun"));
					cnt += dao.update("saveCyberEduLoad", returnMap);
					totCnt = totCnt - chkCnt;
					chkCnt = 0;
					mergeRows		= new ArrayList<Serializable>();
					insertRows		= new ArrayList<Serializable>();
					updateRows 		= new ArrayList<Serializable>();
					deleteRows 		= new ArrayList<Serializable>();
				}else {
					if ( totCnt == nCnt && totCnt == chkCnt ){
						returnMap.put("ssnEnterCd",(String) convertMap.get("ssnEnterCd"));
						returnMap.put("ssnSabun",(String) convertMap.get("ssnSabun"));
						cnt += dao.update("saveCyberEduLoad", returnMap);
					}
				}

			}
		}

		Log.Debug();
		return cnt;
	}
}