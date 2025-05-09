package com.hr.hrm.appmt.escapeApprentice;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 면수습발령 Service
 *
 * @author 이름
 *
 */
@Service("EscapeApprenticeService")
public class EscapeApprenticeService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 면수습발령처리
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public int saveEscapeApprentice(Map<?, ?> convertMap) throws Exception {
		Log.DebugStart();

		int cnt = 0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			try{
				for(Map<String,Object> mp : (List<Map>)convertMap.get("mergeRows")) {

					// delete THRM221
					dao.delete( "deleteEscapeApprentice221" , mp );

					// INSERT THRM221
					dao.update( "insertEscapeApprentice221" , mp );

					// CALL PROCEDURE P_HRM_POST_APPRENTICE
					mp.put("processNo", "");
					Map tempMap = (Map) dao.excute( "prcExecAppmtApprentice" , mp );

					//Log.Debug("sqlCode : " + tempMap.get("sqlCode") );
					//Log.Debug("sqlErrm : " + tempMap.get("sqlErrm") );

					if ( "S".equals(tempMap.get("sqlCode")) ) {

						cnt++;
					}else{

						return -1;
					}
				}
			} catch(Exception e) {
				Log.Debug(e.toString());
			}
		}

		return cnt;
	}
}