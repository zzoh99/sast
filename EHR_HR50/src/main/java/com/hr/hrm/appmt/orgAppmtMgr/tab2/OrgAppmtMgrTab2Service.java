package com.hr.hrm.appmt.orgAppmtMgr.tab2;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.StringUtil;

/**
 * 조직개편발령 Service
 *
 * @author bckim
 *
 */
@Service("OrgAppmtMgrTab2Service")
public class OrgAppmtMgrTab2Service{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 발령구분(부서전배, 조직개편) 발령종류코드(콤보로 사용할때) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgAppmtMgrTabOrdTypeCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgAppmtMgrTabOrdTypeCodeList", paramMap);
	}
	
	/**
	 * 발령구분(부서전배, 조직개편) 발령종류코드(콤보로 사용할때) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgAppmtMgrTabOrdCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgAppmtMgrTabOrdCodeList", paramMap);
	}	
	

	/**
	 * 발령조직 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgAppmtMgrTab2OrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgAppmtMgrTab2OrgList", paramMap);
	}

	/**
	 * 발령사원 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgAppmtMgrTab2UserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgAppmtMgrTab2UserList", paramMap);
	}

	/**
	 * 발령사원 추가 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int insertOrgAppmtMgrTab2User(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.create("insertOrgAppmtMgrTab2User", paramMap);
	}
	
	
	/**
     * 대량발령 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
	@SuppressWarnings("unchecked")
    public Map<String,Object> saveOrgAppmtMgrTab2User(Map<?, ?> convertMap, Map<?, ?> convertMap2) throws Exception {
    	 Log.Debug("00번");
        Map<String,Object> returnMap = new HashMap<String, Object>();
        List<Map<String,Object>> errorList = new ArrayList<Map<String,Object>>();
        //convertMap2 의 키는 enterCd+ordDetailCd+sabun+ordYmd 의 조합임.
        Log.Debug();
        int cnt=0;
        /*List<Map<String,Object>> insertRows = new ArrayList<Map<String,Object>>();
        List<Map<String,Object>> updateRows = new ArrayList<Map<String,Object>>();*/
        
        Log.Debug("11번");
        
        List<Map<String,Object>> mergeRows = (List<Map<String,Object>>)convertMap.get("mergeRows");
        //List<Map<String,Object>> deleteRows = (List<Map<String,Object>>)convertMap.get("deleteRows");
        //삭제        
        cnt += dao.delete("deleteOrgAppmtMgrTab2Exec", convertMap);
        dao.delete("deleteOrgAppmtMgrTab2Exec2", convertMap);
        
        Log.Debug("22번");
        
        //입력, 수정 분리( apply_seq의 유무에 따라 분리됨 ( apply_seq : 유 -> update, 무->insert)
        if( mergeRows.size() > 0){
            for(Map<String,Object> mp : mergeRows) {
                
            	  Log.Debug("33번");

				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
                mp.put("ssnSabun", convertMap.get("ssnSabun") );
                mp.put("ordTypeCd", convertMap.get("chgOrdTypeCd") );
                mp.put("ordDetailCd", convertMap.get("chgOrdDetailCd") );
                mp.put("ordYmd", convertMap.get("chgOrdYmd").toString().replaceAll("-", "") );
                mp.put("processNo", convertMap.get("searchProcessNo") );
                
                String key = convertMap.get("ssnEnterCd")+(String)mp.get("ordDetailCd")+(String)mp.get("sabun")+(String)mp.get("ordYmd");
                List<Map<String,Object>> postItemList =  (List<Map<String, Object>>) convertMap2.get(key);
                
                Log.Debug("44번");
                
                if(mp.get("applySeq")!=null && !"".equals((String)mp.get("applySeq"))){
                    //수정
                    cnt += dao.update("updateOrgAppmtMgrTab2User", mp);
                    
                    mp.put("postItemList", postItemList);//발령항목
                    dao.update("updateOrgAppmtMgrTab2User2", mp);
                }else{                  
                    //입력전 중복확인체크                    
                    mp.put("postItemList", postItemList);//발령항목
                    
                    Log.Debug("55번");
                    
                    Map<String, Object> maxSeq = (Map<String, Object>) dao.getMap("getOrgAppmtMgrTab2MaxApplySeq", mp);
                    if(maxSeq != null) {
                    	int dupCnt = ((BigDecimal) maxSeq.get("dupCnt")).intValue();
                    	
                    	Log.Debug("66번");
                    	
                    	if(dupCnt>0){
                    		errorList.add(maxSeq);
                    	}else{
                    		
                    		//입력
                    		cnt += dao.create("insertOrgAppmtMgrTab2a", maxSeq);
                    		Log.Debug("1번");
                    		Log.Debug("1번 리스트 : " + postItemList);
                    		for(Map<String,Object> postItem : postItemList){
                    			String ckey = StringUtil.getCamelize((String)postItem.get("columnCd"));
                    			Log.Debug("2번");
                    			if(maxSeq.get(ckey)==null) postItem.put("value191", "");//조회된 값이 없으면 ""으로 put 해줌
                    			else postItem.put("value191", maxSeq.get(ckey));
                    			if("P".equals(postItem.get("cType")) || "C".equals(postItem.get("cType"))){
                    				Log.Debug("3번");
                    				postItem.put("nmValue191", maxSeq.get(StringUtil.getCamelize((String)postItem.get("nmColumnCd"))));
                    			}
                    		}
                    		
                    		maxSeq.put("postItemList", postItemList);//발령항목
                    		dao.create("insertOrgAppmtMgrTab2b", maxSeq);
                    		Log.Debug("4번");
                    	}
                    }
                }
                //cnt += dao.create("insertLargeAppmtMgr", mp);
                //dao.update("updateLargeAppmtMgr", mp);
            }
        }
        returnMap.put("successCnt", cnt);
        returnMap.put("errorList", errorList);
        Log.Debug();
        return returnMap;
    }
	
	
	
}