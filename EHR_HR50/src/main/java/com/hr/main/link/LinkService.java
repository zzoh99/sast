package com.hr.main.link;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 로그인 서비스
 * 
 * @author ParkMoohun
 *
 */
@Service("LinkService") 
public class LinkService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 회사 조회
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLoginEnterList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getLInkEnterList", paramMap);
	}

	/**
	 *  getDirectLinkMap
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getDirectLinkMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getDirectLinkMap", paramMap);
	}
	
	/**
	 * 사진 View Service
	 * 
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> ComFaceImageLoad(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getComFaceImageLoadMap", paramMap);
	}		
	
}