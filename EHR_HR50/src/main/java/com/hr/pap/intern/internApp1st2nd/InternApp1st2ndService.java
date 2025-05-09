package com.hr.pap.intern.internApp1st2nd;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 수습1차,2차평가 Service
 * 
 * @author JCY
 *
 */
@Service("InternApp1st2ndService")  
public class InternApp1st2ndService{
 
	@Inject
	@Named("Dao")
	private Dao dao;

	
	/**
	 * 수습1차,2차평가 팝업 단건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getInternApp1st2ndPopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getInternApp1st2ndPopMap", paramMap);
	}
	
	/**
	 * 수습1차,2차평가 저장(리스트) Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternApp1st2ndPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveInternApp1st2ndPop", convertMap);
		}
		Log.Debug();
		
		return cnt;
	}
	
	/**
	 * 수습1차,2차평가 저장(합계) Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcInternApp1st2ndPopTotal(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcInternApp1st2ndPopTotal", convertMap);
	}
	
	/**
	 * 수습1차,2차평가 저장(의견) Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternApp1st2ndPopMemo(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		cnt += dao.update("saveInternApp1st2ndPopMemo", convertMap);
		
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 수습1차,2차평가 평가완료 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternApp1st2ndPopAppYn(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		cnt += dao.update("saveInternApp1st2ndPopAppYn", convertMap);
		
		Log.Debug();
		return cnt;
	}
}