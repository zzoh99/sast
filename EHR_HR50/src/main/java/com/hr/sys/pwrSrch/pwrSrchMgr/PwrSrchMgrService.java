package com.hr.sys.pwrSrch.pwrSrchMgr;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("PwrSrchMgrService") 
public class PwrSrchMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	public List<?> getPwrSrchMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getPwrSrchMgrList", paramMap);
	}
	
	public int savePwrSrchMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePwrSrchMgr217", convertMap);
			cnt += dao.delete("deletePwrSrchMgr213", convertMap);
			cnt += dao.delete("deletePwrSrchMgr215", convertMap);
			//cnt += dao.delete("deletePwrSrchMgr211", convertMap);
			cnt += dao.delete("deletePwrSrchMgr201", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			List<Map> l 		= (List<Map>)convertMap.get("mergeRows");
			List nCopyList 		= new ArrayList();
			List<Map> copyList 	= new ArrayList();
			Map nCopyMap 		= new HashMap();
			Map copyMap 		= new HashMap();
			Map procCallRtn 	= new HashMap();
			String ssnEnterCd 	= convertMap.get("ssnEnterCd").toString();
			String ssnSabun 	= convertMap.get("ssnSabun").toString();
			for(Map m : l){
				if(m.get("copySearchSeq").toString().isEmpty()){
					nCopyList.add(m);
				}else{
					//Copy Row
					//procedure Call
					m.put("ssnEnterCd",ssnEnterCd);
					m.put("ssnSabun",ssnSabun);
					copyList.add(m);
				}
			}
			if(nCopyList.size() > 0){
				nCopyMap.put("ssnEnterCd",	ssnEnterCd);
				nCopyMap.put("ssnSabun",	ssnSabun);
				nCopyMap.put("mergeRows",	nCopyList);
				cnt += dao.update("savePwrSrchMgr", nCopyMap);
			}
			if(copyList.size() > 0 ){
				copyMap.put("ssnEnterCd",	ssnEnterCd);
				copyMap.put("ssnSabun",		ssnSabun);
				copyMap.put("mergeRows",	copyList);
				cnt += dao.update("savePwrSrchMgr", copyMap);
				for(Map m : copyList){
					if(m.get("searchSeq").equals("")) {
						// searchSeq 값 자동 생성
						Map seqMap = (Map)dao.getOne("getPwrSrchMgrSearchSeq", m);
						m.put("searchSeq", seqMap.get("searchSeq").toString());
					}
					procCallRtn = (Map)dao.excute("PwrSrchMgrCopyDataPrcCall", m);
					if(null != procCallRtn.get("sqlErrorMsg")){
						cnt++;
					}
				}
			}
			//cnt += dao.update("savePwrSrchMgr211", nCopyMap);
		}
		/* 일단 주석처리 왜있는지 모르겠음... 2013.12.19 by kosh
		if( ((List<?>)convertMap.get("updateRows")).size() > 0){
			cnt += dao.update("updatePwrSrchMgr211", convertMap);
		}
		*/
		Log.Debug();
		return cnt;
	}	
}