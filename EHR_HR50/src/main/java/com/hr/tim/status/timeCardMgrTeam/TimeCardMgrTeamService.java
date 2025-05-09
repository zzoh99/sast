package com.hr.tim.status.timeCardMgrTeam;
import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.excelTxtFilePas.ExcelRead;
import com.hr.common.excelTxtFilePas.ExcelReadOption;
import com.hr.common.excelTxtFilePas.TextRead;
import com.hr.common.logger.Log;
/**
 * TimeCard관리 Service
 *
 * @author jcy
 *
 */
@Service("TimeCardMgrTeamService")
public class TimeCardMgrTeamService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * TimeCard관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTimeCardMgrTeamList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTimeCardMgrTeamList", paramMap);
	}

	/**
	 * TTIM999 마감여부
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?,?> getTimeCardMgrTeamCount(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>) dao.getMap("getTimeCardMgrTeamCount", paramMap);
	}

	/**
	 * TimeCard관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTimeCardMgrTeam(Map<?, ?> convertMap) throws Exception {
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

			for (int i = 0; i < list.size(); i++ ){

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

				if( totCnt >= chkCnt ){
					chkCnt++;
				}

				if ( chkCnt == 100 ){
					returnMap.put("ssnEnterCd",(String) convertMap.get("ssnEnterCd"));
					returnMap.put("ssnSabun",(String) convertMap.get("ssnSabun"));
					cnt += dao.delete("deleteTimeCardMgrTeam", returnMap);
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
						cnt += dao.delete("deleteTimeCardMgrTeam", returnMap);
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

				if( totCnt >= chkCnt ){
					chkCnt++;
				}

				if ( chkCnt == 100 ){
					returnMap.put("ssnEnterCd",(String) convertMap.get("ssnEnterCd"));
					returnMap.put("ssnSabun",(String) convertMap.get("ssnSabun"));
					cnt += dao.update("saveTimeCardMgrTeam", returnMap);
					dao.update("saveTimeCardMgrTeamTemp", returnMap);
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
						cnt += dao.update("saveTimeCardMgrTeam", returnMap);
						dao.update("saveTimeCardMgrTeamTemp", returnMap);
					}
				}

			}
		}

		return cnt;
	}

	public int textUpload(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		String textFile = (String) convertMap.get("rPath");
		String searchYmd = ((String) convertMap.get("searchYmd")).replaceAll("-", "");
		String searchGntCd = (String) convertMap.get("searchGntCd");

		Log.Debug("textFile : " + textFile);

		String searchGntCdproc = "01".equals(searchGntCd) ? "W" : "F" ;

		String query = "";
		String queryFirst = "SELECT \n";
		String queryLast  = "FROM DUAL \n";
		String initQuery = "";

		String contents = "";

		try{

			contents = TextRead.read(textFile);

			Log.Debug("contents.getBytes().length : " + contents.getBytes().length);

			query = queryFirst + "'" + searchYmd + "' AS YMD \n";
			query = query+ ( ",'" + searchGntCd + "' AS GNT_CD \n");

			if ( contents.getBytes().length > 4000 ){
				Log.Debug("=====================================if start");
				for ( int i = 0 ; i < (contents.getBytes().length / 4000)+1 ; i++ ){
					Log.Debug("=====================================for start (" + i);
					Log.Debug("((contents.getBytes().length - (4000*i)) ) : " + ((contents.getBytes().length - (4000*i)) ));
					//String text = getCalcStr(contents, 4000*i , ((contents.getBytes().length)%(4000*(i+1))) > 4000 ? 4000 : contents.getBytes().length);

					Log.Debug("from : " + (4000*i));
					Log.Debug("to : " + ( ((contents.getBytes().length - (4000*i)) ) > 4000 ? 4000*(i+1) : contents.getBytes().length-1 ));

					//String text = getCalcStr(contents, 4000*i , 4000*(i+1));
					String text = getCalcStr(contents, 4000*i , ( ( (contents.getBytes().length - (4000*i)) ) > 4000 ? 4000*(i+1) : contents.getBytes().length-1 ));


					//Log.Debug("((contents.getBytes().length)%(i+1)) : " + ((contents.getBytes().length)%(i+1)));
					Log.Debug("text ("+i+") : " + text);

					if ( i == 0 ){
						initQuery = initQuery + ",TO_CLOB('"  +text + "')";
					}else{
						initQuery = initQuery + "||TO_CLOB('"  +text + "')";
					}
					Log.Debug("=====================================for end (" + i);
				}
				query = query + initQuery + " AS CONTENTS \n";
				Log.Debug("=====================================if end");
			}else{
				query = query + ",TO_CLOB('" + contents+ "')" +" AS CONTENTS \n";
				//query = query + contents +" AS CONTENTS \n";
			}

			query = query + queryLast;

			Log.Debug("query : " + query);

			convertMap.put("query", query);
			convertMap.put("contents", contents);
			convertMap.put("searchGntCdproc", searchGntCdproc);

			convertMap.put("searchSymd", searchYmd);
			convertMap.put("searchEymd", searchYmd);
			convertMap.put("timeGroupCd", "");

			//cnt =+ dao.delete("deleteTextUploadTTIM251",convertMap);
			cnt =+ dao.update("textUploadTTIM251",convertMap);
			dao.excute("procP_TIM_WORK_DAY_UPLOAD", convertMap);
			dao.excute("procP_TIM_DAILY_WORK_CRE", convertMap);

		}catch(IOException e){
			throw new RuntimeException(e.getMessage(),e);
		}

		return cnt;
	}


	public int excelUpload(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		String excelFile = (String) convertMap.get("rPath");
		String searchYmd = ((String) convertMap.get("searchYmd")).replaceAll("-", "");

		String query = "";
		String queryFirst = "SELECT \n";
		String queryLast  = "FROM DUAL \n";
		String initQuery = "";

		String contents = "";


		try{
			ExcelReadOption ro = new ExcelReadOption();
			ro.setFilePath(excelFile);
			ro.setOutputColumns("A", "B", "C", "D", "E", "F", "G");
			ro.setStartRow(1);

			List<Map<String, String>> result = ExcelRead.read(ro);

			int v = 0;

			for(Map<String, String> map : result) {

				if ( map.get("A").length() < 3 ){

					Log.Debug(
							(v) +"|" +map.get("A")+"|"+map.get("B")+"|"+map.get("C")+"|"+map.get("D")
							+"|"+map.get("E")+"|"+map.get("F")+"|"+map.get("G")
					);
					if ( v == 0 ){
						//contents = contents + (map.get("A")+"|"+map.get("B")+"|"+map.get("C")+"|"+map.get("D")+"|"+map.get("E")+"|"+map.get("F")+"|"+map.get("G"));
						contents = contents + (map.get("A")+"|"+map.get("B")+"|"+map.get("C")+"|"+map.get("D")+"|"+map.get("G"));
					}else{
						//contents = contents + ","+(map.get("A")+"|"+map.get("B")+"|"+map.get("C")+"|"+map.get("D")+"|"+map.get("E")+"|"+map.get("F")+"|"+map.get("G"));
						contents = contents + ","+(map.get("A")+"|"+map.get("B")+"|"+map.get("C")+"|"+map.get("D")+"|"+map.get("G"));
					}
					v++;
				}
			}

			query = queryFirst + "'" + searchYmd + "' AS YMD \n";

			Log.Debug("contents : " + contents);

			if ( contents.getBytes().length > 4000 ){
				Log.Debug("=====================================if start");
				for ( int i = 0 ; i < (contents.getBytes().length / 4000)+1 ; i++ ){
					Log.Debug("=====================================for start (" + i);
					Log.Debug("((contents.getBytes().length - (4000*i)) ) : " + ((contents.getBytes().length - (4000*i)) ));
					//String text = getCalcStr(contents, 4000*i , ((contents.getBytes().length)%(4000*(i+1))) > 4000 ? 4000 : contents.getBytes().length);

					Log.Debug("from : " + (4000*i));
					Log.Debug("to : " + ( ((contents.getBytes().length - (4000*i)) ) > 4000 ? 4000*(i+1) : contents.getBytes().length-1 ));

					//String text = getCalcStr(contents, 4000*i , 4000*(i+1));
					String text = getCalcStr(contents, 4000*i , ( ( (contents.getBytes().length - (4000*i)) ) > 4000 ? 4000*(i+1) : contents.getBytes().length-1 ));


					//Log.Debug("((contents.getBytes().length)%(i+1)) : " + ((contents.getBytes().length)%(i+1)));
					Log.Debug("text ("+i+") : " + text);

					if ( i == 0 ){
						initQuery = initQuery + ",TO_CLOB('"  +text + "')";
					}else{
						initQuery = initQuery + "||TO_CLOB('"  +text + "')";
					}
					Log.Debug("=====================================for end (" + i);
				}
				query = query + initQuery + " AS CONTENTS \n";
				Log.Debug("=====================================if end");
			}else{
				query = query + ",TO_CLOB('" + contents+ "')" +" AS CONTENTS \n";
			}

			query = query + queryLast;

			Log.Debug("query : " + query);

			convertMap.put("query", query);
			convertMap.put("contents", contents);
			convertMap.put("searchGntCdproc", "W");

			convertMap.put("searchSymd", searchYmd);
			convertMap.put("searchEymd", searchYmd);
			convertMap.put("timeGroupCd", "");


			//cnt =+ dao.delete("deleteExcelUploadTTIM250",convertMap);
			cnt =+ dao.update("excelUploadTTIM250",convertMap);
			dao.excute("procP_TIM_WORK_DAY_UPLOAD", convertMap);
			dao.excute("procP_TIM_DAILY_WORK_CRE", convertMap);

		}catch(IOException e){
			throw new RuntimeException(e.getMessage(),e);
		}

		return cnt;
	}

	/**
	 * procP_TIM_DAILY_WORK_CRE 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map procP_TIM_DAILY_WORK_CRE(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("procP_TIM_DAILY_WORK_CRE", paramMap);
	}

	/**
	 * callP_TIM_WORK_HOUR_CHG_OSSTEM 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map callP_TIM_WORK_HOUR_CHG_OSSTEM(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("callTimeCardMgrTeamP_TIM_WORK_HOUR_CHG_OSSTEM", paramMap);
	}

	/**
	 * callP_TIM_SECOM_TIME_CRE 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map callP_TIM_SECOM_TIME_CRE(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("callP_TIM_SECOM_TIME_CRE", paramMap);
	}



    public static String getCalcStr(String str, int sLoc, int eLoc) {
        byte[] bystStr;
        String rltStr = str;
        try
        {
            bystStr = str.getBytes();
            int bytelen =  bystStr.length;
            if(bytelen > eLoc){
               rltStr = new String(bystStr, sLoc, eLoc - sLoc);
            }
        }
        catch(Exception e)
        {
            return rltStr;
        }
       return rltStr;
    }

    /**
     * TimeCard 일괄마감 처리 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int saveTimeCardMgrTeamAllColse(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;

        cnt += dao.update("saveTimeCardMgrTeamAllColse", convertMap);


        return cnt;
    }

}