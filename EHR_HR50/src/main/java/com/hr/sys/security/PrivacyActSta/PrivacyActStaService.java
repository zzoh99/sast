package com.hr.sys.security.PrivacyActSta;
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
 * 개인정보보호법현황 Service
 *
 * @author CBS
 *
 */
@Service("PrivacyActStaService")
public class PrivacyActStaService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 개인정보보호법현황 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPrivacyActStaSubList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEleSeqList", paramMap);
	}
	/**
	 * 개인정보보호법현황 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPrivacyActStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		Log.Debug("searchInfoSeq : " + paramMap.get("searchInfoSeq"));

		HashMap<String, Object> returnMap 	= new HashMap<String, Object>();

		List<?> listSub  = new ArrayList<Object>();
		listSub = (List<?>) dao.getList("getEleSeqList", paramMap);

		String eleYn = "";

		Log.Debug("listSub.size() : " + listSub.size() );

		if ( listSub.size() > 0 ){
			Log.Debug("=========================================================1");
			for ( int i=0; i < listSub.size(); i++ ){


				Log.Debug("=========================================================i : " + i);
				HashMap<String, String> map = (HashMap<String, String>)listSub.get(i);
				Log.Debug("=========================================================i1 : " + i);
				Log.Debug("map("+i+")"+ map);
				String code = String.valueOf(map.get("code"));
				Log.Debug("=========================================================i2 : " + i);
				if ( !"".equals(code) ){

					//eleYn = eleYn +  ( ", MAX(DECODE(X.ELE_SEQ,'" + code + "', X.ELE_YN)) AS " + "ELE_YN_" +code ) ;
					eleYn = eleYn +  ( ", CASE WHEN MAX(DECODE(X.ELE_SEQ,'" + code + "', X.ELE_YN)) = '0'	THEN 'X' ELSE 'O' END AS " + "ELE_YN_" +code ) ;
				}
				Log.Debug("=========================================================i3 : " + i);
			}
			Log.Debug("=========================================================5");
		}

		Log.Debug("eleYn : " + eleYn );

		//paramMap.

		returnMap = (HashMap<String, Object>) paramMap;
		returnMap.put("eleYn", eleYn);

		List<?> list  = new ArrayList<Object>();
		list = (List<?>) dao.getList("getPrivacyActStaList", returnMap);

		return list;
	}

	/**
	 * 개인정보보호법현황 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePrivacyActSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePrivacyActSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePrivacyActSta", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 개인정보보호법현황 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deletePrivacyActSta(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deletePrivacyActSta", paramMap);
	}
}