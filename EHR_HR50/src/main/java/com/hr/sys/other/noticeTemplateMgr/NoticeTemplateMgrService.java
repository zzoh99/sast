package com.hr.sys.other.noticeTemplateMgr;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 알림 서식 관리 Service
 * @author P19246
 *
 */
@Service("NoticeTemplateMgrService")
public class NoticeTemplateMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;
	
	public int saveNoticeTemplateMgr(Map<?,?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		
		// 삭제 대상 업무 코드가 있는 경우
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteNoticeTemplateMgrTSYS969", convertMap);
			cnt += dao.delete("deleteNoticeTemplateMgrTSYS968", convertMap);
			cnt += dao.delete("deleteNoticeTemplateMgrTSYS967", convertMap);
		}
		
		// 신규 등록 업무 코드가 있는 경우
		if( ((List<?>)convertMap.get("insertRows")).size() > 0){
			cnt += dao.update("saveNoticeTemplateMgrTSYS967", convertMap);
		}

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveNoticeTemplateMgrTSYS968", convertMap);
		}
		
		return cnt;
	}

	/**
	 * 서식 데이타 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int saveNoticeTemplateData(Map<?,?> paramMap) throws Exception {
		Log.Debug();

		// 알림서식이 저장 되어있는지 먼저 확인
		List<Map<String, Object>> bizCdList = (List<Map<String, Object>>) dao.getList("getNoticeTemplateBizCdListForCombo", paramMap);
		boolean isExist = bizCdList.stream()
				.anyMatch(bizCd -> bizCd.get("code").equals(paramMap.get("bizCd")));

		// 알림서식이 저장되어있지 않다면, 알림서식 저장 작업 시작
		if(!isExist) {
			// TSYS967 에서 해당 알림에 대한 정보를 가져온다.
			Map bizInfo = (Map) dao.getMap("getNoticeTemplateBizCdMap", paramMap);
			Map convertMap = (Map) new HashMap();
			// 초기화된 Map 리스트
			List mergeRows = new ArrayList<>();

			// Map을 Serializable 리스트에 추가
			mergeRows.add(bizInfo);
			convertMap.put("mergeRows", mergeRows);
			convertMap.put("ssnSabun", paramMap.get("ssnSabun"));
			convertMap.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			dao.update("saveNoticeTemplateMgrTSYS968", convertMap);
		}

		int cnt = dao.update("saveNoticeTemplateData", paramMap);
		if( cnt > 0 ) {
			dao.updateClob("saveNoticeTemplateDataContent", paramMap);
		}
		return cnt;
	}
	
	/**
	 * 서식 데이터 전체 회사 동일 적용
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int saveNoticeTemplateDeployAll(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("saveNoticeTemplateDeployAllTSYS968", paramMap);
		cnt += dao.update("saveNoticeTemplateDeployAllTSYS969", paramMap);
		return cnt;
	}
	
	/**
	 * 지정 업무코드의 일림 유형별 사용 여부 맵객체로 조회
	 * @param enterCd
	 * @param bizCd
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String,Object> getNoticeTemplateUseInfoMap(String enterCd, String bizCd) throws Exception {
		Map<String,Object> paramMap = new HashMap<String, Object>();
		paramMap.put("enterCd", enterCd);
		paramMap.put("bizCd", bizCd);
		List<Map<?,?>> list = (List<Map<?,?>>) getNoticeTemplateUseInfoByBizCd(paramMap);
		
		Map<String,Object> resultMap = null;
		if(list != null && list.size() > 0) {
			resultMap = new HashMap<String, Object>();
			for (Map<?, ?> map : list) {
				resultMap.put((String) map.get("noticeTypeCd"), map.get("useYn"));
			}
		}
		return resultMap;
	}
	
	/**
	 * 지정 업무코드의 일림 유형 사용 여부 목록으로 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getNoticeTemplateUseInfoByBizCd(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getNoticeTemplateUseInfoByBizCd", paramMap);
	}
	
	/**
	 * 지정 업무코드에 해당하는 서식 데이터 목록을 알림 유형을 키명으로 한 맵객체로 변환하여 반환
	 * @param enterCd
	 * @param bizCd
	 * @param languageCd
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Map<String, Object>> getTemplateMapByBizCd(String enterCd, String bizCd, String languageCd) throws Exception {
		Log.Debug();
		
		Map<String, Map<String, Object>> resultMap = null;
		
		// languageCd가 [ko_KR] 형식으로 전달된 경우
		if( !StringUtils.isBlank(languageCd) && languageCd.contains("_") ) {
			languageCd = languageCd.substring(languageCd.indexOf("_") + 1, languageCd.length());
		}
		
		Map<String,Object> paramMap = new HashMap<String, Object>();
		paramMap.put("enterCd", enterCd);
		paramMap.put("bizCd", bizCd);
		paramMap.put("languageCd", StringUtils.defaultIfBlank(languageCd, "KR"));
		
		List<Map<String, Object>> list = (List<Map<String, Object>>) dao.getList("getNoticeTemplateDataListByBizCd", paramMap);
		if( list != null && list.size() > 0 ) {
			resultMap = new HashMap<String, Map<String, Object>>();
			for (Map<String, Object> map : list) {
				resultMap.put((String) map.get("noticeTypeCd"), map);
			}
		}
		
		return resultMap;
	}

    public List<?> getNoticeTemplateBizCdList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getNoticeTemplateBizCdList", paramMap);
    }

    public Map<?, ?> getNoticeTemplateData(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getNoticeTemplateData", paramMap);
        Log.Debug();
        return resultMap;
    }
}
