package com.hr.common.upload.imageUploadTorg903;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("ImageUploadTorg903Service")
public class ImageUploadTorg903Service{
 
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 사진 입력 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int torg903ImageInsert(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("torg903ImageInsert", paramMap);
	}
	


	/**
	 * 사진 조회 Service
	 * 
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> torg903ImageSelect(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("torg903ImageSelect", paramMap);
	}
		
	
}