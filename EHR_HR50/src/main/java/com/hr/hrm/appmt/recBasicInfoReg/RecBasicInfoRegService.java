package com.hr.hrm.appmt.recBasicInfoReg;
import java.io.File;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.fileupload.impl.FileUploadConfig;

/**
 * 채용기본사항등록 Service
 *
 * @author bckim
 *
 */
@Service("RecBasicInfoRegService")
public class RecBasicInfoRegService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/** 채용공고 직원이미지 원본 파일 위치 */
	@Value("${stf.filePath}")
	private String stfFilePath;

	/**
	 * 채용기본사항등록 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRecBasicInfoRegList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRecBasicInfoRegList", paramMap);
	}

	/**
	 * 채용기본사항등록(팝업) 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRecBasicInfoRegPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRecBasicInfoRegPopList", paramMap);
	}

	/**
	 * 채용기본사항등록(합격자정보I/F 팝업) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRecBasicInfoRegIfPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRecBasicInfoRegIfPopList", paramMap);
	}

	/**
	 * 채용기본사항등록 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRecBasicInfoReg(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRecBasicInfoReg901", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRecBasicInfoReg", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 채용기본사항등록(합격자정보I/F 팝업) 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRecBasicInfoRegIfPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			dao.delete("deleteRecBasicInfoReg903", convertMap);
			cnt += dao.delete("deleteRecBasicInfoReg901", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRecBasicInfoRegIfPop", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 발령처리 프로시저
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map prcSabunCreAppmtSave(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcSabunCreAppmtSave", paramMap);
	}
	
	/**
	 *  사번중복 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getSabunCreAppmtCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getSabunCreAppmtCnt", paramMap);
	}
	
	/**
	 * 휴복직 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTimeOffAppmt(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTimeOffAppmt", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 파견발령 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveDispatchAppmt(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveDispatchAppmt", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 퇴직발령 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetireAppmt(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetireAppmt", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 승진급대상자 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePromTargetAppmt(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePromTargetAppmt", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 채용공고 증명사진 이관 대상 목록 조회 Service
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRecBasicInfoRegListForMovePicture(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRecBasicInfoRegListForMovePicture", paramMap);
	}
	
	/**
	 * 채용공고에 등록된 직원 이미지 인사시스템 직원이미지 저장 경로에 복사 처리
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public int copyPictureFilesByRecServiceReg(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		int moveCnt = 0;
		
		// 대상자 조회 : 사번이 채번된 직원 조회
		List<?> list = getRecBasicInfoRegListForMovePicture(paramMap);
		if(list != null && list.size() > 0) {
			Map<String,Object> map = null;
			String enterCd  = null;
			String sabun    = null;
			String applKey  = null;
			
			// 파일업로드 설정
			FileUploadConfig fileUploadConfig = new FileUploadConfig("pht001");
			// 파일 저장 기본 위치 정보 조회 및 삽입
			String localRootPath = fileUploadConfig.getDiskPath();
			String storePath = fileUploadConfig.getProperty(FileUploadConfig.POSTFIX_STORE_PATH);
			
			for (Object obj : list) {
				map = (Map<String,Object>) obj;
				
				enterCd = (String) map.get("enterCd");
				sabun   = (String) map.get("sabun");
				applKey = (String) map.get("applKey");
				Log.Debug(String.format("enterCd : %s, sabun : %s, applKey : %s", enterCd, sabun, applKey));
				
				if( !StringUtils.isBlank(enterCd) && !StringUtils.isBlank(sabun) && !StringUtils.isBlank(applKey) ) {
					File srcFile = new File(stfFilePath, applKey);
					File destFile = new File(String.format("%s/%s%s/%s.jpg", localRootPath, enterCd, storePath, sabun));
					
					try {
						if( srcFile != null && srcFile.exists() ) {
							Log.Debug(String.format("execute file copy... srcFile : %s, destFile : %s", srcFile.getAbsolutePath(), destFile.getAbsolutePath()));
							// 복사
							FileUtils.copyFile(srcFile, destFile);
							moveCnt++;
						}
					} catch (Exception e) {
						Log.Error("Image Move Fail!! error message : " + e.getMessage());
						break;
					}
				}
			}
		}
		
		Log.Debug();
		return moveCnt;
	}
}