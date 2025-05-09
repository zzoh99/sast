package com.hr.common.popup;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("PopupService")
public class PopupService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 헤더 메인 프로세스맵 조회
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public List<?> getMainSearchProcessMap(Map<?, ?> params) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainSearchProcessMap", params);
	}
	
	/**
	 * 공통코드 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppPeopleShowPopExList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppPeopleShowPopExList", paramMap);
	}
	/**
	 * 공통코드 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCommonCodePopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCommonCodePopupList", paramMap);
	}
	/**
	 * 공통팝업 PrgMgrPopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPrgMgrPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPrgMgrPopupList", paramMap);
	}
	/**
	 * 공통팝업 PwrSrchMgrPopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPwrSrchMgrPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPwrSrchMgrPopupList", paramMap);
	}
	/**
	 * 공통팝업 AthGrpMuRegPopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAthGrpMuRegPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAthGrpMuRegPopupList", paramMap);
	}
	/**
	 * 공통팝업 OrgBasicPopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgBasicPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgBasicPopupList", paramMap);
	}

	/**
	 * 공통팝업 OrgBasicPopupCheck 후  조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgBasicGrpUserPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		HashMap<String, Object> returnMap 	= new HashMap<String, Object>();
		returnMap.put("ssnEnterCd",(String) paramMap.get("ssnEnterCd"));
		returnMap.put("ssnSabun",(String) paramMap.get("ssnSabun"));
		returnMap.put("ssnGrpCd",(String) paramMap.get("ssnGrpCd"));

		returnMap.put("searchBaseDate",(String) paramMap.get("searchBaseDate"));
		returnMap.put("searchOrgNm",(String) paramMap.get("searchOrgNm"));


		Map<?, ?> map = dao.getMap("getOrgBasicGrpCdCheck", returnMap);
		String searchType = "";
		if(map != null) {
			searchType = (String) map.get("searchType");
		}

		List<?> list = null;

		if ( !"".equals(searchType)){
			if ( "O".equals(searchType)){
				Log.Debug("if : "+ searchType);
				list = (List<?>) dao.getList("getOrgBasicGrpUserPopupList", returnMap);
			}else{
				Log.Debug("else : "+ searchType);
				list = (List<?>) dao.getList("getOrgBasicPopupList", paramMap);
			}
		}

		return list;
	}

	/**
	 * 팝업 OrgBasicPapCreatePopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgBasicPopupList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgBasicPopupList2", paramMap);
	}

	public List<?> getEduPointPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduPointPopupList", paramMap);
	}

	public List<?> getAppPeopleShowPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppPeopleShowPopList", paramMap);
	}
	/**
	 * 공통팝업 OrgTreePopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgTreePopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgTreePopupList", paramMap);
	}
	/**
	 * 조직도 명칭 코드형태 리스트(부서 정보(트리형태) 팝업에서 사용)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgChartCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgChartCodeList", paramMap);
	}
	/**
	 * 공통팝업 OrgMappingItemPopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgMappingItemPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgMappingItemPopupList", paramMap);
	}
	/**
	 * 공통팝업 JobPopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJobPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobPopupList", paramMap);
	}
	/**
	 * 공통팝업 JobSchemePopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJobSchemePopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobSchemePopupList", paramMap);
	}
	/**
	 * 공통팝업 CompetencyPopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompetencyPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompetencyPopupList", paramMap);
	}
	/**
	 * 공통팝업 CompetencySchemePopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompetencySchemePopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompetencySchemePopupList", paramMap);
	}
	/**
	 * 공통팝업 MeasureCdPopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMeasureCdPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMeasureCdPopupList", paramMap);
	}
	/**
	 * 공통팝업 TaskCdPopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTaskPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTaskPopupList", paramMap);
	}

	/**
	 * 공통팝업 TaskCdPopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgEmpList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgEmpList", paramMap);
	}

	/**
	 * 사진등록  POPUP 조회
	 *
	 * @return String
	 * @throws Exception
	 */
	public Map<?, ?> getPhtRegPopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPhtRegPopupMap", paramMap);
	}

	/**
	 * 사진등록 채용사전 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePhtRegPopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		int cnt=0;
		cnt += dao.update("savePhtRegPopupMap", paramMap);

		return cnt;
	}

	/**
	 * 채용내용  POPUP 채용내용조회
	 *
	 * @return String
	 * @throws Exception
	 */
	public Map<?, ?> getRecBasisInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getRecBasisInfo", paramMap);
	}

	
	/**
	 * layerPopup공통 조직 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLayerOrgCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLayerOrgCodeList", paramMap);
	}


	/**
	 * layerPopup공통 직무 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLayerJobCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLayerJobCodeList", paramMap);
	}
	

	public String saveSignPadPopup(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		
		Map<?, ?> filemap = dao.getMap("jFileSequence", new HashMap<>() );

		String fileSeq =  filemap != null && filemap.get("seq") != null ? filemap.get("seq").toString():"-1";
		convertMap.put("fileSeq",  fileSeq);
		
		cnt = dao.update("tsys200save", convertMap);
		cnt += dao.update("tsys201save", convertMap);
		
		if( cnt <= 0 ) {
			fileSeq = "-1";
		}

		return fileSeq;
	}
	/**
	 * 키워드 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getKeywordEmpList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getKeywordEmpList", paramMap);
	}
	
	/**
	 * 공통팝업 JikgubBasicPopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJikgubBasicPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJikgubBasicPopupList", paramMap);
	}	
	

	/**
	 * 공통팝업 JikchakBasicPopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJikchakBasicPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJikchakBasicPopupList", paramMap);
	}
	
	/**
	 * 공통팝업 JikweeBasicPopup 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJikweeBasicPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJikweeBasicPopupList", paramMap);
	}

	/**
	 * 권한그룹 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAuthGrpPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAuthGrpPopupList", paramMap);
	}

	/**
	 * 교육만족도항목관리_회차별 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduServeryEventMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduServeryEventMgrList", paramMap);
	}

	/**
	 *  교육만족도항목관리 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduServeryItemMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduServeryItemMgrList", paramMap);
	}

	/**
	 * 교육만족도항목관리_회차별 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduServeryEventMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduServeryEventMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEduServeryEventMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}