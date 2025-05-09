package com.hr.hrm.certificate.certiAppDet;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 증명서신청 세부내역 Service
 *
 * @author bckim
 *
 */
@Service("CertiAppDetService")
public class CertiAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 증명서신청 세부내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCertiAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCertiAppDetList", paramMap);
	}

	/**
	 * 증명서신청(급여여부 체크) 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?,?> getCertiAppDetCheck(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>) dao.getMap("getCertiAppDetCheck", paramMap);
	}


	/**
	 * 증명서신청 세부내역 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCertiAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCertiAppDet", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCertiAppDet", convertMap);
		}
		Log.Debug();
		return cnt;
	}


	/**
	 * 증명서신청 출력 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int updateCertiAppDetPrint(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=dao.delete("updateCertiAppDetPrint", paramMap);
		Log.Debug();
		return cnt;
	}
	
	/**
	 * certiAppDet 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> prcP_BEN_REGNO_UPD(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.excute("prcP_BEN_REGNO_UPD", paramMap);
	}

	/**
	 * 근무처 코드로 근무처 주소 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?,?> getLocAddrByCd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>) dao.getMap("getLocAddrByCd", paramMap);
	}

	/**
	 * 원천징수영수증 PDF 존재 유무 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?,?> getCertiAppDetCheckPdfExist(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>) dao.getMap("getCertiAppDetCheckPdfExist", paramMap);
	}
	
	/**
	 * 원천징수영수증 PDF 파일 정보 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?,?> getCertiAppDetPdfDownloadFileMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>) dao.getMap("getCertiAppDetPdfDownloadFileMap", paramMap);
	}
}