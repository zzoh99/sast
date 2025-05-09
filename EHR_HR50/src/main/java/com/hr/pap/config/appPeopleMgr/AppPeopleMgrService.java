package com.hr.pap.config.appPeopleMgr;

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
 * 평가대상자생성/관리 Service
 *
 * @author JSG
 *
 */
@Service("AppPeopleMgrService")
public class AppPeopleMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  평가대상자생성/관리 단건 조회 Service(평가단계별 날짜조회)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppPeopleMgrMap1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppPeopleMgrMap1", paramMap);
		Log.Debug();
		return resultMap;
	}

	/**
	 * 평가대상자생성/관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppPeopleMgr1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppPeopleMgr1", convertMap);
			cnt += dao.delete("deleteAppPeopleMgr1Sub", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppPeopleMgr1", convertMap);
		}

		Log.Debug();
		return cnt;
	}

	/**
	 * 평가대상자생성/관리 전체삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAppPeopleMgrAll(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.delete("deleteAppPeopleMgrAll", paramMap);
		cnt += dao.delete("deleteAppPeopleMgrAllSub", paramMap);

		Log.Debug();
		return cnt;
	}

	/**
	 * 평가대상자생성 - 평가대상자생성 - 프로시저(평가대상자)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcAppPeopleMgr1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcAppPeopleMgr1", paramMap);
	}

	/**
	 * 평가대상자생성 - 평가대상자생성 - 프로시저(평가대상자)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcAppPeopleMgr2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcAppPeopleMgr2", paramMap);
	}

	/**
	 * 평가대상자생성 - 역량생성
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int saveAppPeopleMgrTmp(Map<String, Object> paramMap, Map<?, ?> reqParamMap) throws Exception {
		Log.Debug();

		int cnt = 0;
		String msg = "";

		cnt += dao.update("updAppPeopleMgrTmpYn1", paramMap); //전부 N 으로 변경


		HashMap<String, String> map 		= null;
		List<Serializable>  paramRows		= new ArrayList<Serializable>();
		int idx = 0;

		String[] sabuns = (String[]) reqParamMap.get( "sabun" );
		String[] appOrgs = (String[]) reqParamMap.get( "appOrgCd" );

		Log.Debug(" sabuns.length : "+ sabuns.length);

		for ( int j = 0; j < sabuns.length; j++ )  {
			map = new HashMap<String, String>();
			map.put("sabun", sabuns[j]);
			map.put("appOrgCd", appOrgs[j]);
			paramRows.add(map);
			idx++;

			//500 건씩 저장
			if( idx % 500 == 0 ){
				Log.Debug(" idx : "+ idx);
				paramMap.put("paramRows", paramRows);
				cnt += dao.update("updAppPeopleMgrTmpYn2", paramMap); //대상자만 Y로 변경

				//초기화
				idx = 0;
				paramRows = new ArrayList<Serializable>();
			}

		}

		Log.Debug(" idx : "+ idx);
   		if( idx > 0 ){
			paramMap.put("paramRows", paramRows);
			cnt += dao.update("updAppPeopleMgrTmpYn2", paramMap); //대상자만 Y로 변경
   		}


		/*


		List<?> list = (List<?>)convertMap.get("paramRows");
		if( list.size() > 0){
			Map<String,Object> mp = (Map<String,Object>)list.get(0);

			convertMap.put("searchAppraisalCd", mp.get("appraisalCd"));
			convertMap.put("searchAppStepCd", mp.get("appStepCd"));

			cnt += dao.update("updAppPeopleMgrTmpYn2", convertMap); //대상자만 Y로 변경
		}
		*/
		return cnt;
	}

	/**
	 * 평가대상자생성 - 역량생성
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcAppPeopleMgr4(Map<String, Object> convertMap) throws Exception {
		Log.Debug();

		int cnt = 0;
		String msg = "";

		List<?> list = (List<?>)convertMap.get("paramRows");
		if( list.size() > 0){
			convertMap.put("flag", "Y");
			cnt = dao.update("updAppPeopleMgrTmpYn", convertMap);


			Map<String,Object> mp = (Map<String,Object>)list.get(0);
			Map<String, Object> mp2 = new HashMap<String, Object>();
			mp2.put("ssnEnterCd", (String)convertMap.get("ssnEnterCd"));
			mp2.put("ssnSabun", (String)convertMap.get("ssnSabun"));
			mp2.put("sabun", "TMPSABUN");
			mp2.put("appOrgCd", "");
			mp2.put("appraisalCd", mp.get("appraisalCd"));
			mp2.put("appStepCd", mp.get("appStepCd"));

			Map map =  (Map) dao.excute("prcAppPeopleMgr4", mp2);

			convertMap.put("flag", "N");
			cnt = dao.update("updAppPeopleMgrTmpYn", convertMap);
		}
/*
		if(list != null && list.size() > 0) {
			for(int i = 0; i < list.size(); i++) {
				Map<String,Object> mp = (Map<String,Object>)list.get(i);
				mp.put("ssnEnterCd", (String)convertMap.get("ssnEnterCd"));
				mp.put("ssnSabun", (String)convertMap.get("ssnSabun"));

				Map map =  (Map) dao.excute("prcAppPeopleMgr4", mp);

				Log.Debug("obj : "+map);
				Log.Debug("sqlcode : "+map.get("sqlcode"));
				Log.Debug("sqlerrm : "+map.get("sqlerrm"));

				if (map.get("sqlerrm") != null) {
					cnt = -1;
					msg += (String)convertMap.get("sabun")+"=>"+map.get("sqlerrm")+"\n";
				}

			}
		}
*/

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Message", msg);
		resultMap.put("Code", cnt);

		return resultMap;
	}

}
