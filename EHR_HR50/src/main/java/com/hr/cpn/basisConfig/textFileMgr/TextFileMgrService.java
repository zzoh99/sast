package com.hr.cpn.basisConfig.textFileMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 텍스트파일생성목록 Service
 * 
 * @author 이름
 *
 */
@Service("TextFileMgrService")  
public class TextFileMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 텍스트파일생성목록 다건 조회 Service First
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTextFileMgrListFirst(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTextFileMgrListFirst", paramMap);
	}	
	
	/**
	 * 텍스트파일생성목록 다건 조회 Service Second
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTextFileMgrListSecond(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTextFileMgrListSecond", paramMap);
	}
	/**
	 *  텍스트파일생성목록 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getTextFileMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getTextFileMgrMap", paramMap);
	}
	/**
	 * 텍스트파일생성목록 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTextFileMgrFirst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteTextFileMgrFirst", convertMap);
			
			cnt += dao.delete("deleteTextFileMgrSecond", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTextFileMgrFirst", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 텍스트파일생성목록 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTextFileMgrSecond(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteTextFileMgrSecond", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTextFileMgrSecond", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	

}