package com.hr.tim.request.vacationAppUpload;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 일괄근태업로드 Service
 *
 * @author JSG
 *
 */
@Service("VacationAppUploadService")
public class VacationAppUploadService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * vacationAppUpload 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getVacationAppUploadList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getVacationAppUploadList", paramMap);
	}
	
	/**
	 * vacationAppUpload 다건 조회 2 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getVacationAppUploadListCre(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getVacationAppUploadListCre", paramMap);
	}
	
	/**
	 * 일괄근태업로드 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveVacationAppUpload(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){

			List<Map> deleteList = (List<Map>)convertMap.get("deleteRows");

			for ( Map<String, Object> mp : deleteList ){

				Map<String,Object> deleteMap = new HashMap<String,Object>();

				if ( "Y".equals(mp.get("applyYn")) ){                      // 반영여부가 Y인것만

					deleteMap.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
					deleteMap.put("applSeq", mp.get("applSeq"));					
					deleteMap.put("sabun", mp.get("sabun"));
					deleteMap.put("gntCd", mp.get("gntCd"));
					deleteMap.put("sdate", mp.get("sdate"));

					dao.delete("deleteVacationAppUploadFirst", deleteMap); // THRI103 DELETE
					dao.delete("deleteVacationAppUploadSecond", deleteMap);// THRI107 DELETE
					dao.delete("deleteVacationAppUploadThird", deleteMap); // TTIM301 DELETE			
					dao.excute("prcP_TIM_VACATION_CLEAN", deleteMap);     // 사용개수 복원

				}	
			}
			cnt += dao.delete("deleteVacationAppUpload", convertMap);      // TTIM311 DELETE
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveVacationAppUpload", convertMap);
		}
		
		Log.Debug();
		return cnt;
	}
	
	/**
	 * Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map prcP_TIM_CREW_CREATE(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("prcP_TIM_CREW_CREATE", paramMap);
	}

	/**
	 * vacationAppUpload 적용일수 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<String, Object> getVacationAppUploadCloseCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<String, Object>) dao.getMap("getVacationAppUploadCloseCnt", paramMap);
	}

}