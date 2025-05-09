package com.hr.sys.system.map;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 국민연금 소득총액산정 Service
 *
 * @author JM
 *
 */
@SuppressWarnings("unchecked")
@Service("MapPrintAddrService")
public class MapPrintAddrService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * getMapPrintAddr2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMapPrintAddr2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMapPrintAddr2", paramMap);
	}

	public int saveMapPrintAddr(Map<String, Object> convertMap) throws Exception {
		// TODO Auto-generated method stub

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){

			Map<String,Object> tempMap = (Map<String, Object>) (((List<?>)convertMap.get("mergeRows")).get(0));

			tempMap.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
			tempMap.put("ssnSabun", convertMap.get("ssnSabun"));

			dao.update("deleteMapPrintAddr", tempMap);
			dao.update("updateMapPrintAddr", convertMap);
		}
		return 1;
	}

	public int deleteMapPrintCombo(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub

		dao.update("deleteMapPrintAddr", paramMap );

		return 1;
	}

	public int saveMapAddrByRecord(Map<String, Object> paramMap) throws Exception {
		Map<?, ?> dupMap = dao.getMap("getMapPrintAddrDupCheck", paramMap);
		if(dupMap != null) {
			String isDup = (String) dupMap.get("isDup");
			
			if ( "Y".equals(isDup)){
				return -1;
			} else {
				dao.update("saveMapAddrByRecord", paramMap);
			}
		}

		return 1;
	}

}