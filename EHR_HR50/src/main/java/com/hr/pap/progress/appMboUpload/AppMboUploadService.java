package com.hr.pap.progress.appMboUpload;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 업적평가업로드 Service
 * 
 * @author JCY
 *
 */
@Service("AppMboUploadService")  
public class AppMboUploadService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 업적평가업로드 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppMboUploadList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppMboUploadList", paramMap);
	}	
	/**
	 *  업적평가업로드 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppMboUploadMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppMboUploadMap", paramMap);
	}
	/**
	 * 업적평가업로드 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppMboUpload(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppMboUpload", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppMboUpload", convertMap);
		}
		Log.Debug();
		return cnt;
	}



}