package com.hr.common.util.fileupload.jfileupload.imageUpload;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.Map;


@Service("ImageUploadService")
public class ImageUploadService{
  
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
	
	public int employeePhotoSave(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("thrm911ImageInsert2", paramMap);
	}
	
	public int companyPhotoSave(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("torg903ImageInsert2", paramMap);
	}
	
	public int businessPlaceSave(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("tcpn121ImageInsert2", paramMap);
	}
	
	/**
	 * 사진/서명 이미지 삭제 
	 */
	public int employeePhotoDelete(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("thrm911ImageDelete", paramMap);
	}
	
	/**
	 * 사원 이미지 파일 정보
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<?, ?> getEmployeePhotoInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getEmployeePhotoInfoMap", paramMap);
	}


	/**
	 * 사원 이미지 -> CLOB 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int employeePhotoClobUpdate(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.update("employeePhotoClobUpdate", paramMap);
		dao.update("employeePictureBlodUpdateClob", paramMap);
		return cnt;
	}
}