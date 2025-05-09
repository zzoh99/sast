package com.hr.sys.other.boardMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 게시판관리 Service
 * 
 * @author CBS
 *
 */
@Service("BoardMgrService")  
public class BoardMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	
	/**
	 * 게시판 관리자 Popup 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getBoardAdminPopMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getBoardAdminPopMgr", paramMap);
	}	
	/**
	 * 게시판 관리자 Popup저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveBoardAdminPopMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteBoardAdminPopMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveBoardAdminPopMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 게시판 권한 Popup저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveBoardAuthPopMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteBoardAuthPopMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveBoardAuthPopMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 게시판 작성/조회권한 Popup 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getBoardAuthPopMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getBoardAuthPopMgr", paramMap);
	}	
	
	/**
	 * 게시판관리 sheet1 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> tsys700SelectBoardList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("tsys700SelectBoardList", paramMap);
	}		
	/**
	 * 게시판관리 sheet1 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int tsys700SaveBoardMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("tsys700DeleteBoard", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("tsys700MergeBoardMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 게시판관리 sheet1 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteBoardMgrSheet1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteBoardMgrSheet1", paramMap);
	}

	/**
	 * 게시판관리 sheet2 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveBoardMgrSheet2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteBoardMgrSheet2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveBoardMgrSheet2", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 게시판관리 sheet2 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteBoardMgrSheet2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteBoardMgrSheet2", paramMap);
	}
	
	/**
	 * 직제 소팅을 위한 정렬 순서 생성
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map boardSortCreatePrcCall(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("prcOrgSchemeSortCreateCall", paramMap);
	}

	
}