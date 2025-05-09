package com.hr.org.organization.orgChangeSchemeMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 조직도관리 Service
 *
 * @author CBS
 *
 */
@Service("OrgChangeSchemeMgrService")
public class OrgChangeSchemeMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * 조직도시뮬레이션 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgChangeSchemeMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgChangeSchemeMgrList", paramMap);
	}

	/**
	 * 조직도시뮬레이션 가발령 적용 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgChangeSchemeMgrList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgChangeSchemeMgrList2", paramMap);
	}

	/**
	 * 조직도 시뮬레이션 정보 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSchemeSimulationInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getSchemeSimulationInfo", paramMap);
		Log.Debug();
		return resultMap;
	}

	/**
	 * 신규조직 중복체크 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSchemeSimulationOrgExistOrgCd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getSchemeSimulationOrgExistOrgCd", paramMap);
		Log.Debug();
		return resultMap;
	}

	/**
	 * 조직 목록 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSchemeSimulationEmpOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSchemeSimulationEmpOrgList", paramMap);
	}

	/**
	 * 소속조직원 목록 조회 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSchemeSimulationEmpMemberList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSchemeSimulationEmpMemberList", paramMap);
	}

	/**
	 * 조직이동대상자 목록 조회 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSchemeSimulationEmpIndependentMemberList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSchemeSimulationEmpIndependentMemberList", paramMap);
	}
	
	/**
	 * 검색 목록 조회 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSchemeSimulationEmpMemberSearchList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSchemeSimulationEmpMemberSearchList", paramMap);
	}

	/**
	 * 조직버전 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgVerComboList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgVerComboList", paramMap);
	}
	
	/**
	 * 조직도 데이터를 가져옴
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List getOrgView(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List) dao.getList("getOrgView", paramMap);
	}

	/**
	 * 최종확인 조직도 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSchemeSimulationOrgCurLastTreeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSchemeSimulationOrgCurLastTreeList", paramMap);
	}

	/**
	 * 확정존재여부 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> chkConfYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("chkConfYn", paramMap);
		Log.Debug();
		return resultMap;
	}

	/**
	 * 가발령적용 사용 유무 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> chkApplyYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("chkApplyYn", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * 조직변경 조직도 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSchemeSimulationReOrgList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSchemeSimulationReOrgList1", paramMap);
	}

	/**
	 * 조직장변경 조직도 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSchemeSimulationReOrgList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSchemeSimulationReOrgList2", paramMap);
	}

	/**
	 * 조직장변경 조직도 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSchemeSimulationReOrgList3(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSchemeSimulationReOrgList3", paramMap);
	}
	
	/**
	 * 조직콤보 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgComboList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgComboList", paramMap);
	}
	
	
	/**
	 * 조직개편 버전관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgChangeVerMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgChangeVerMgrList", paramMap);
	}	

	
	/**
	 * 조직개편관리 정보 저장
	 * @param convertMap
	 * @return
	 * @throws Exception
	 */
	public int saveOrgChangeSchemeMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			// 조직개편관리 데이터 삭제 [TORG701]
			cnt += dao.delete("deleteOrgChangeSchemeMgr", convertMap);
			// 삭제 조직개편관리에 해당하는 버전 데이터 삭제 [TORG703]
			cnt += dao.delete("deleteOrgChangeSchemeAllVersion", convertMap);
			// 삭제 조직개편관리에 해당하는 조직 데이터 삭제 [TORG705]
			cnt += dao.delete("deleteOrgChangeSchemeAllOrg", convertMap);
			// 삭제 조직개편관리에 해당하는 인사이동 데이터 삭제 [TORG707]
			cnt += dao.delete("deleteOrgChangeSchemeMgrAllMoveEmp", convertMap);
			// 삭제 조직도개편관리 가발령적용 항목
			cnt += dao.delete("deleteOrgChangeSchemeMgr2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgChangeSchemeMgr", convertMap);
		}
		return cnt;
	}
	

	/**
	 * 조직개편관리 가발령적용 정보 저장
	 * @param convertMap
	 * @return
	 * @throws Exception
	 */
	public int saveOrgChangeSchemeMgr2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOrgChangeSchemeMgr2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgChangeSchemeMgr2", convertMap);
		}
		return cnt;
	}

	/**
	 * 조직이동 대상자 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSchemeSimulationEmp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSchemeSimulationEmp", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSchemeSimulationEmp", convertMap);
		}

		return cnt;
	}
    
	
	/**
	 * 조직개편 버전 정보 저장
	 * @param convertMap
	 * @return
	 * @throws Exception
	 */
	public int saveOrgChangeVerMgrList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			// 버전 데이터 삭제 [TORG703]
			cnt += dao.delete("deleteOrgChangeVerMgrList", convertMap);
			// 삭제버전에 해당하는 조직 데이터 삭제 [TORG705]
			cnt += dao.delete("deleteOrgChangeVerMgrOrgList", convertMap);
			// 삭제버전에 해당하는 인사이동 데이터 삭제 [TORG707]
			cnt += dao.delete("deleteOrgChangeVerMgrMoveEmpList", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgChangeVerMgrList", convertMap);
		}
		return cnt;
	}
	
	/**
	 * 조직도 복사 호출
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map callPrcCopyOrgView(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("callPrcCopyOrgView", paramMap);
	}

	/**
	 * 조직 버전 복사 호출
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map callPrcCopyOrgVersion(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("callPrcCopyOrgVersion", paramMap);
	}

	/**
	 * 가발령적용 호출
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map callPrcOrgSimulAppmtApply(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("callPrcOrgSimulAppmtApply", paramMap);
	}

	/**
	 * 조직 최종확인 및 진행 호출
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map callPrcOrgApplyReorg(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("callPrcOrgApplyReorg", paramMap);
	}

	/**
	 * 조직도 확정
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public int compOrg(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

        int cnt=0;
            cnt += dao.update("compOrg", paramMap);
        return cnt;
	}

	/**
	 * 조직도 확정 취소
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public int cancelCompOrg(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

        int cnt=0;
            cnt += dao.update("cancelCompOrg", paramMap);
        return cnt;
	}

	/**
	 * 조직 버전 마감
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map callPrcChgConpVer(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("callPrcChgConpVer", paramMap);
	}
	
	/**
	 * 개편안작성[조직] > 초기화
	 * @param convertMap
	 * @return
	 * @throws Exception
	 */
	public int saveOrgChangeView(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOrgChangeView", convertMap);
			// 조직개편 시뮬레이션 삭제 조직의 조직이동대상자 정보 삭제 [TORG707]
			cnt += dao.delete("deleteSchemeSimulationEmpByDeleteOrg", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgChangeView", convertMap);
		}
		return cnt;
	}
	
	/**
	 * 개편안작성[인사] > 초기화
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteSchemeSimulationEmpAll(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;
			cnt += dao.delete("deleteSchemeSimulationEmpAll", paramMap);
		return cnt;
	}
}