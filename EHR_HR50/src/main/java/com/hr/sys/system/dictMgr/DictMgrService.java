package com.hr.sys.system.dictMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 언어관리 Service
 *
 * @author CBS
 *
 */
@Service("DictMgrService")
public class DictMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 사전관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */

	public List<?> getDictMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug("getDictMgrList ");
		return (List<?>) dao.getList((String)paramMap.get("queryId"), paramMap);
		
	}


	public int getDictMgrSave(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		
		
		if(convertMap.get("sheetId").equals("Sheet1")){
			
			if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
				cnt += dao.delete("getDictMgrDel1Sheet1", convertMap);
				cnt += dao.delete("getDictMgrDel2Sheet1", convertMap);
				cnt += dao.delete("getDictMgrDel3Sheet1", convertMap);
			}

			if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
				cnt += dao.update("getDictMgrSaveSheet1", convertMap);
			}
			
		}
		else if(convertMap.get("sheetId").equals("Sheet2")){
			
			
			if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
				cnt += dao.delete("getDictMgrDelSheet2", convertMap);
			}
			
			if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
				cnt += dao.update("getDictMgrSaveSheet2", convertMap);
			}

			
			
		}
		else if(convertMap.get("sheetId").equals("Sheet3")){
			
			if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
				cnt += dao.delete("getDictMgrDelSheet3", convertMap);
			}
			
			if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
				cnt += dao.update("getDictMgrSaveSheet3", convertMap);
			}
			
		}
		
		return cnt;
	}
}