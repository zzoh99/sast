package com.hr.common.code;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.StringUtil;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service("CommonCodeService")
public class CommonCodeService {

	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getCommonCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getCommonCodeList", paramMap);
	}

	public List<?> getCommonCodeLists(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getCommonCodeLists", paramMap);
	}

	public List<?> getCommonNSCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		if(paramMap != null && paramMap.containsKey("queryId") && paramMap.get("queryId") != null) {
			return (List<?>) dao.getList(paramMap.get("queryId").toString(), paramMap);
		}else{
			return null;
		}
	}

	public List<?> getAddlCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAddlCodeList", paramMap);
	}

	/* 근로시간단축 콤보 조회 */
	public List<?> getWorkingTypeCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getWorkingTypeCodeList", paramMap);
	}

	/* 날짜(주)계산 */
	public List<?> getCommonWeek(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getCommonWeek", paramMap);
	}

	/* 가족관계 */
	public List<?> getFamilyRelations(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getFamilyRelations", paramMap);
	}

	/* Table의 PK중 암호화된 컬럼이 없는경우 사용한다. */
	@SuppressWarnings("unchecked")
	public int getDupCnt(String table, String cols, String colsType, List<?> valueList) throws Exception {
		Log.Debug();
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("cols",cols);
		paramMap.put("values",valueList);
		String colsArray[] = cols == null ? new String[0]:cols.split(",");
		String colsTypeArray[] = colsType == null ? new String[0]:colsType.split(",");
		String values = "";
		String valueSet = "";

		int cnt = 0;
		
		if (valueList != null) {
			for(int i=0; i<valueList.size(); i++){
				valueSet = "";
				Map<String, String> map = (Map<String, String>) valueList.get(i);
				if(i==0){ valueSet = "(";}
				else{ valueSet += ",("; }
				if(map != null) {
					for (int x = 0; x < colsArray.length; x++) {
						if (colsTypeArray[x].equals("i")) {
							if (map.get(colsArray[x]) != null && ((String) map.get(colsArray[x])).length() != 0) {
								valueSet += map.get(colsArray[x]) + ",";
							} else {
								valueSet += "NULL" + ",";
							}
						} else {
							valueSet += "'" + map.get(colsArray[x]) + "',";
						}
					}
				}
				if(valueSet != null && !valueSet.equals("")) {
					valueSet = valueSet.substring(0, valueSet.length() - 1);
				}
				valueSet +=")";
				values +=valueSet;
			}
			values = "("+values+")";

			paramMap.put("table",table);
			paramMap.put("cols","("+cols+")");
			paramMap.put("values",values);

			
			Map<String, Object> m = (Map<String, Object>) dao.getMap("getDupCnt", paramMap);
			if(m != null && m.containsKey("cnt") && m.get("cnt") != null){
				cnt = Integer.parseInt( m.get("cnt").toString() );
			}
		}
		
		return cnt;
	}

	/* exist 로 중복 체크 */
	public int getDupCnt(String table, String cols, List<?> valueList) throws Exception {
		Log.Debug();
		if (valueList == null || valueList.isEmpty()) {
			return 0;
		}

		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("table", table);
		paramMap.put("colsList", cols.split(","));
		paramMap.put("valueList", valueList);

		Map<String, Object> result = (Map<String, Object>) dao.getMap("getDupCnt2", paramMap);
		return (result != null && result.get("cnt") != null)
				? Integer.parseInt(result.get("cnt").toString())
				: 0;
	}

	/* Table의 PK중 암호화 된 컬럼이 있는 경우 cryptKey를 따로 받아 colsType가 s0 컬럼에 대하여 해당 키로 인크립트 하여 체크한다. */
	@SuppressWarnings("unchecked")
	public int getDupCnt(String table, String cols, String colsType, List<?> valueList, String cryptKey) throws Exception {
		Log.Debug();
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("cols",cols);
		paramMap.put("values",valueList);
		String colsArray[] = cols != null ? cols.split(","):new String[0];
		String colsTypeArray[] = colsType != null ? colsType.split(","):new String[0];
		String values = "";
		String valueSet = "";

		if (valueList != null) {
			for(int i=0; i<valueList.size(); i++){
				valueSet = "";
				Map<String, String> map = (Map<String, String>)valueList.get(i);
				if(i==0){
					valueSet = "(";}
				else{
					valueSet += ",(";
				}
				for(int x=0; x<colsArray.length; x++){
					if(colsTypeArray[x].equals("i") ){
						valueSet += map.get(colsArray[x])+",";
					}else if( colsTypeArray[x].equals("s0") ){
						valueSet += "CRYPTIT.ENCRYPT('"+map.get(colsArray[x])+"','" +cryptKey+ "'),";
					} else {
						valueSet += "'"+map.get(colsArray[x])+"',";
					}
				}
				if(valueSet != null && !valueSet.equals("")) {
					valueSet = valueSet.substring(0, valueSet.length() - 1);
				}
				valueSet +=")";
				values +=valueSet;
			}
		}
		values = "("+values+")";

		paramMap.put("table",table);
		paramMap.put("cols","("+cols+")");
		paramMap.put("values",values);

		int cnt = 0;
		Map<String, Object> m = (Map<String, Object>) dao.getMap("getDupCnt", paramMap);
		if(m != null && m.containsKey("cnt") && m.get("cnt") != null){
			cnt = Integer.parseInt( m.get("cnt").toString() );
		}
		return cnt;
	}

	@SuppressWarnings("unchecked")
	public int getDupCnt(Map<?, ?> convertMap, String paramTable, String paramCol, String paramType) throws Exception {
		paramCol = paramCol.replaceAll(" ", "");
		paramType = paramType.replaceAll(" ", "");

		String[] arrCol = paramCol.split(",");

		List<Map<String, Object>> insertList = (List<Map<String, Object>>) convertMap.get("insertRows");

		if( insertList != null ){
			List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

			for(Map<String,Object> mp : insertList) {
				Map<String,Object> dupMap = new HashMap<String,Object>();
				dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));

				for(int i=0; i<arrCol.length; i++) {
					if ( arrCol[i] == null ) continue;
					dupMap.put(arrCol[i], mp.get( StringUtil.getCamelize(arrCol[i]) ));
				}

				dupList.add(dupMap);
			}

			int dupCnt = 0;

			if(insertList.size() > 0) {
				dupCnt = this.getDupCnt(paramTable,"ENTER_CD,"+ paramCol, "s," + paramType, dupList);
			}

			return dupCnt;
		}else{
			return 0;
		}
	}
}