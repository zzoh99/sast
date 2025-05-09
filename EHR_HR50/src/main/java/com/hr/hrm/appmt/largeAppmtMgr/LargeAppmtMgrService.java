package com.hr.hrm.appmt.largeAppmtMgr;
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
import org.springframework.web.util.HtmlUtils;

/**
 * 대량발령 Service
 *
 * @author 이름
 *
 */
@SuppressWarnings("unchecked")
@Service("LargeAppmtMgrService")
public class LargeAppmtMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getExectedDContent(Map<String,Object> paramMap) throws Exception {
		Log.Debug();
		paramMap = (Map<String, Object>) dao.getMap("getThrm200DContent", paramMap);
		if(paramMap != null && paramMap.containsKey("dContent") && !"".equals(paramMap.get("dContent"))) {
			try {
				String dContent = HtmlUtils.htmlUnescape(StringUtil.stringValueOf(paramMap.get("dContent")));
				paramMap.put("selectViewQuery", dContent);
				return (List<?>) dao.getList("getExectedDContent", paramMap);
			} catch (Exception e) {
				Log.Error(e.getLocalizedMessage());
				return new ArrayList<>();
			}
		} else {
			return new ArrayList<>();
		}
	}
	
	public List<?> getLargeAppmtMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLargeAppmtMgrList", paramMap);
	}

	/**
	 * 대량발령 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public Map<String,Object> saveLargeAppmtMgrExec(Map<?, ?> convertMap, Map<?, ?> convertMap2) throws Exception {
		Map<String,Object> returnMap = new HashMap<String, Object>();
		List<Map<String,Object>> errorList = new ArrayList<Map<String,Object>>();
		//convertMap2 의 키는 enterCd+ordDetailCd+sabun+ordYmd 의 조합임.
		Log.Debug();
		int cnt = 0;
		/*List<Map<String,Object>> insertRows = new ArrayList<Map<String,Object>>();
		List<Map<String,Object>> updateRows = new ArrayList<Map<String,Object>>();*/
		List<Map<String,Object>> mergeRows = (List<Map<String,Object>>)convertMap.get("mergeRows");
		//List<Map<String,Object>> deleteRows = (List<Map<String,Object>>)convertMap.get("deleteRows");
		//삭제		
		cnt += dao.delete("deleteLargeAppmtMgrExec", convertMap);
		dao.delete("deleteLargeAppmtMgrExec2", convertMap);
		//입력, 수정 분리( apply_seq의 유무에 따라 분리됨 ( apply_seq : 유 -> update, 무->insert)
		if( mergeRows.size() > 0){
			for(Map<String,Object> mp : mergeRows) {
				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
				mp.put("ssnSabun", convertMap.get("ssnSabun") );
				mp.put("processNo", convertMap.get("processNo") );
				
				String key = convertMap.get("ssnEnterCd")+(String)mp.get("ordTypeCd")+(String)mp.get("ordDetailCd")+(String)mp.get("sabun")+(String)mp.get("ordYmd");
				List<Map<String,Object>> postItemList =  (List<Map<String, Object>>) convertMap2.get(key);
				
				if(mp.get("applySeq")!=null && !"".equals((String)mp.get("applySeq"))){
					//수정
					cnt += dao.update("updateLargeAppmtMgr", mp);
					mp.put("postItemList", postItemList);//발령항목
					dao.update("updateLargeAppmtMgr2", mp);
				}else{					
					//입력전 중복확인체크					
					mp.put("postItemList", postItemList);//발령항목
					Map<String, Object> maxSeq = (Map<String, Object>) dao.getMap("getLargeAppmtMgrMaxApplySeq", mp);
					if(maxSeq != null) {
						int dupCnt = ((BigDecimal) maxSeq.get("dupCnt")).intValue();
						if(dupCnt > 0) {
							errorList.add(maxSeq);
						} else{
							//입력
							cnt += dao.create("insertLargeAppmtMgr", maxSeq);
							for(Map<String,Object> postItem : postItemList){
								String ckey = StringUtil.getCamelize((String)postItem.get("columnCd"));
								if(maxSeq.get(ckey)==null) postItem.put("value191", "");//조회된 값이 없으면 ""으로 put 해줌
								else postItem.put("value191", maxSeq.get(ckey));
								if("P".equals(postItem.get("cType")) || "C".equals(postItem.get("cType"))){
									postItem.put("nmValue191", maxSeq.get(StringUtil.getCamelize((String)postItem.get("nmColumnCd"))));
								}
							}
							
							maxSeq.put("postItemList", postItemList);//발령항목
							dao.create("insertLargeAppmtMgr2", maxSeq);
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
	
	/**
     * 대량발령 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public Map<String,Object> saveLargeAppmtMgrExecNew(Map<?, ?> convertMap, Map<?, ?> convertMap2) throws Exception {
        Map<String,Object> returnMap = new HashMap<String, Object>();
        List<Map<String,Object>> errorList = new ArrayList<Map<String,Object>>();
        //convertMap2 의 키는 enterCd+ordDetailCd+sabun+ordYmd 의 조합임.
        Log.Debug();
        int cnt=0;
        /*List<Map<String,Object>> insertRows = new ArrayList<Map<String,Object>>();
        List<Map<String,Object>> updateRows = new ArrayList<Map<String,Object>>();*/
        List<Map<String,Object>> mergeRows = (List<Map<String,Object>>)convertMap.get("mergeRows");
        //List<Map<String,Object>> deleteRows = (List<Map<String,Object>>)convertMap.get("deleteRows");
        //삭제        
        cnt += dao.delete("deleteLargeAppmtMgrExec", convertMap);
        dao.delete("deleteLargeAppmtMgrExec2", convertMap);
        //입력, 수정 분리( apply_seq의 유무에 따라 분리됨 ( apply_seq : 유 -> update, 무->insert)
        if( mergeRows.size() > 0){
            for(Map<String,Object> mp : mergeRows) {
                mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
                mp.put("ssnSabun", convertMap.get("ssnSabun") );
                
                String key = convertMap.get("ssnEnterCd")+(String)mp.get("ordTypeCd")+(String)mp.get("ordDetailCd")+(String)mp.get("sabun")+(String)mp.get("ordYmd");
                
                List<Map<String,Object>> postItemList =  (List<Map<String, Object>>) convertMap2.get(key);
                
                if(mp.get("applySeq")!=null && !"".equals((String)mp.get("applySeq"))){
                    //수정
                    cnt += dao.update("updateLargeAppmtMgr", mp);
                    mp.put("postItemList", postItemList);//발령항목
                    dao.update("updateLargeAppmtMgr2", mp);
                }else{                  
                    //입력전 중복확인체크                    
                    mp.put("postItemList", postItemList);//발령항목
                    Map<String, Object> maxSeq = (Map<String, Object>) dao.getMap("getLargeAppmtMgrMaxApplySeq", mp);
                    if( maxSeq != null) {
                    	int dupCnt = ((BigDecimal)maxSeq.get("dupCnt")).intValue();
                    	if(dupCnt>0) {
                    		errorList.add(maxSeq);
                    	} else {
                    		//입력
                    		cnt += dao.create("insertLargeAppmtMgr", maxSeq);
                    		for(Map<String,Object> postItem : postItemList){
                    			String ckey = StringUtil.getCamelize((String)postItem.get("columnCd"));
                    			if(maxSeq.get(ckey)==null) postItem.put("value191", "");//조회된 값이 없으면 ""으로 put 해줌
                    			else postItem.put("value191", maxSeq.get(ckey));
                    			if("P".equals(postItem.get("cType")) || "C".equals(postItem.get("cType"))){
                    				postItem.put("nmValue191", maxSeq.get(StringUtil.getCamelize((String)postItem.get("nmColumnCd"))));
                    			}
                    		}
                    		
                    		maxSeq.put("postItemList", postItemList);//발령항목
                    		dao.create("insertLargeAppmtMgr2", maxSeq);
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