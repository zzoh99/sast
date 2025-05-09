package com.hr.common.upload.fileUpload;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("UploadService")
public class UploadService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 업로드 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getUploadMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getUploadMgrList", paramMap);
	}	
	/**
	 * @return String
	 * @throws Exception
	 */
	public String getFileSequence() throws Exception {
		Log.Debug();
		Map<?, ?> fileseqmap = dao.getMap("getFileSequence", new HashMap<>());
		return fileseqmap != null && fileseqmap.get("seq") != null ? fileseqmap.get("seq").toString():null;
	}
	/**
	 * 파일업로드 생성 Service
	 * 
	 * @param li
	 * @return int
	 * @throws Exception
	 */
	public static int setFileData(List<?> li) throws Exception {
		Log.Debug();
		//return dao.create("insertUploadMgr", paramMap);
		
		//HashMap mp = new HashMap();
		Map<?, ?> mp = new HashMap<>();
		// TODO Auto-generated method stub
		try{
			for (Object obj : li) {
				mp = (Map<?, ?>)obj;
				if("I".equals(mp.get("sStatus"))){
					//sqlMapClientTemplate.insert("test.insertFile",mp);
				}else if("D".equals(mp.get("sStatus"))){
					//sqlMapClientTemplate.delete("test.deleteFile",mp);
				}
			}
		}catch(Exception ex){
			//ex.printStackTrace();
			throw ex;
		}
		
		return 0;
		
	}
	/**
	 * 업로드 FILE 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getFileList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getFileList", paramMap);
	}
	/**
	 * 업로드 조회 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePwrSrchCdElemtMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePwrSrchCdElemtMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePwrSrchCdElemtMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}	
	
	/**
	 * 파일 삭제 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteFile(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteFile", convertMap);
		}
		return cnt;
	}
	/**
	 * 파일 입력 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertUpload(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("insertUpload", paramMap);
	}
	
	
}