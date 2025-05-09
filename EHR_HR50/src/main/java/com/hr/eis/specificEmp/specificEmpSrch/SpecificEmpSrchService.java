package com.hr.eis.specificEmp.specificEmpSrch;
import java.math.BigDecimal;
import java.util.*;

import javax.inject.Inject;
import javax.inject.Named;

import com.hr.common.util.StringUtil;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 맞춤인재검색 Service
 *
 * @author JSG
 *
 */
@Service("SpecificEmpSrchService")
public class SpecificEmpSrchService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 맞춤인재검색 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSpecificEmpSrchPeopleMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getSpecificEmpSrchPeopleMap", paramMap);
	}
	
	/**
	 *  다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSpecificEmpList(Map<?, ?> paramMap) throws Exception {
		Log.Debug("getSpecificEmpList ");
		return (List<?>) dao.getList("getSpecificEmpList", paramMap);
	}

	/**
	 *  다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSpecificEmpListPop(Map<?, ?> paramMap) throws Exception {
		Log.Debug("getSpecificEmpList ");
		return (List<?>) dao.getList("getSpecificEmpListPop", paramMap);
	}
	
	/**
	 *  다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSpecificEmpExcel(Map<?, ?> paramMap) throws Exception {
		Log.Debug("getSpecificEmpExcel");
		return (List<?>) dao.getList("getSpecificEmpExcel", paramMap);
	}

	/**
	 *  인재탐색/비교 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSpecificEmpSrchNewList(Map<?, ?> paramMap) throws Exception {
		Log.Debug("getSpecificEmpSrchNewList");
		return (List<?>) dao.getList("getSpecificEmpSrchNewList", paramMap);
	}

	/**
	 *  키워드 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSpecificEmpSrchKeywordList(Map<?, ?> paramMap) throws Exception {
		Log.Debug("getSpecificEmpSrchKeywordList");
		return (List<?>) dao.getList("getSpecificEmpSrchKeywordList", paramMap);
	}

	public Map<String, Object> saveSpecificEmpSrchNewChgOrd(Map<?, ?> convertMap, Map<?, ?> convertMap2)  throws Exception {
		Log.Debug("00번");
		Map<String,Object> returnMap = new HashMap<String, Object>();
		List<Map<String,Object>> errorList = new ArrayList<Map<String,Object>>();

		//convertMap2 의 키는 enterCd+ordDetailCd+sabun+ordYmd 의 조합임.
		Log.Debug();
		int cnt=0;

		List<Map<String,Object>> mergeRows = (List<Map<String,Object>>)convertMap.get("mergeRows");

		//삭제
		cnt += dao.delete("deleteSpecificEmpSrchNewChgOrdExec", convertMap);
		dao.delete("deleteSpecificEmpSrchNewChgOrdExec2", convertMap);

		//입력, 수정 분리( apply_seq의 유무에 따라 분리됨 ( apply_seq : 유 -> update, 무->insert)
		if( mergeRows.size() > 0){
			for(Map<String,Object> mp : mergeRows) {
				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
				mp.put("ssnSabun", convertMap.get("ssnSabun") );
				mp.put("ordTypeCd", convertMap.get("chgOrdTypeCd") );
				mp.put("ordDetailCd", convertMap.get("chgOrdDetailCd") );
				mp.put("ordYmd", convertMap.get("chgOrdYmd").toString() );

				String key = convertMap.get("ssnEnterCd")+(String)mp.get("ordDetailCd")+(String)mp.get("sabun")+(String)mp.get("ordYmd");
				List<Map<String,Object>> postItemList =  (List<Map<String, Object>>) convertMap2.get(key);

				if(mp.get("applySeq")!=null && !"".equals((String)mp.get("applySeq"))){
					//수정
					cnt += dao.update("updateSpecificEmpSrchNewChgOrd", mp);

					mp.put("postItemList", postItemList);//발령항목
					dao.update("updateSpecificEmpSrchNewChgOrd2", mp);
				}else{
					//입력전 중복확인체크
					mp.put("postItemList", postItemList);//발령항목

					Map<String, Object> maxSeq = (Map<String, Object>) dao.getMap("getSpecificEmpSrchNewChgOrdMaxApplySeq", mp);
					int dupCnt = ((BigDecimal) maxSeq.get("dupCnt")).intValue();

					if(dupCnt>0){
						errorList.add(maxSeq);
					} else {
						//입력
						cnt += dao.create("insertSpecificEmpSrchNewChgOrd1", maxSeq);
						for(Map<String,Object> postItem : postItemList){
							String ckey = StringUtil.getCamelize((String)postItem.get("columnCd"));
							if(maxSeq.get(ckey)==null) postItem.put("value191", "");//조회된 값이 없으면 ""으로 put 해줌
							else postItem.put("value191", maxSeq.get(ckey));
							if("P".equals(postItem.get("cType")) || "C".equals(postItem.get("cType"))){
								postItem.put("nmValue191", maxSeq.get(StringUtil.getCamelize((String)postItem.get("nmColumnCd"))));
							}
						}
						maxSeq.put("postItemList", postItemList);//발령항목
						dao.create("insertSpecificEmpSrchNewChgOrd2", maxSeq);
					}
				}
			}
		}
		returnMap.put("successCnt", cnt);
		returnMap.put("errorList", errorList);
		Log.Debug();
		return returnMap;
	}
}