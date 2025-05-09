package com.hr.common.popup.zipCodePopup;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("ZipCodePopupService")
public class ZipCodePopupService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 우편번호 지번 리스트 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getZipCodePopupBungiList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getZipCodePopupBungiList", paramMap);
	}
	/**
	 * 우편번호 도로명 시도 코드 리스트 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getZipCodePopupSidoCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getZipCodePopupSidoCodeList", paramMap);
	}
	/**
	 * 우편번호 도로명 구군 코드 리스트 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getZipCodePopupGugunCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getZipCodePopupGugunCodeList", paramMap);
	}
	/**
	 * 우편번호 도로명 리스트 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getZipCodePopupDoroList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getZipCodePopupDoroList", paramMap);
	}
	
	/**
	 *  우편번호 도로명 리스트 Count 조회 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getZipCodePopupDoroListCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getZipCodePopupDoroListCnt", paramMap);
	}
	
	/**
	 *  우편번호 팝업 타입 조회
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getZipCodeRefYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getSystemStdData", paramMap);
	}

}