package com.hr.common.upload.imageUpload;

import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("_ImageUploadService")
public class ImageUploadService{

	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * 사용기준 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEmpImgStdCdValue(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getEmpImgStdCdValue", paramMap);
	}

	/**
	 * 사진 입력 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int thrm911ImageInsert(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("thrm911ImageInsert", paramMap);
	}


	/**
	 * 사인 입력 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int thrm911SignImageInsert(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("thrm911SignImageInsert", paramMap);
	}


	/**
	 * 사진 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> thrm911ImageSelect(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("thrm911ImageSelect", paramMap);
	}

	/**
	 * 사진 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> imageExistYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("imageExistYn", paramMap);
	}


	/**
	 * 서명사진 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> imageSignExistYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("imageSignExistYn", paramMap);
	}

}