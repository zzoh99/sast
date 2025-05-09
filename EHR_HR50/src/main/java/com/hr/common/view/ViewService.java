package com.hr.common.view;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * View Service
 *
 * @author RYU SIOONG
 *
 */
@Service("ViewService")
public class ViewService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * View 디렉토리 경로 조회 Service
	 *
	 * @param paramMap
	 * @return String
	 * @throws Exception
	 */
	public String getDirectoryPath(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		//Log.Debug( "----------------------------------------service" );
		//Log.Debug( "paramMap ="+paramMap);
		//Log.Debug( "----------------------------------------" );
		
		String directoryPath = null;
		Map<?,?> map = dao.getMap("getDirectoryPathMap", paramMap );
		if(map != null && map.containsKey("directoryPath")) {
			directoryPath = map.get("directoryPath").toString();
		}
		return directoryPath;
	}
	
	/**
	 * 지정 PRG_CD 로 시작하는 프로그램 목록 조회 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getDirectoryPathListByStartWithPrgCd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<Map<String,String>>) dao.getList("getDirectoryPathListByStartWithPrgCd", paramMap);
	}
}