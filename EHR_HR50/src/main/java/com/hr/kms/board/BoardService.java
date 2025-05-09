package com.hr.kms.board;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import com.hr.common.exception.HrException;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 메뉴명 Service
 *
 * @author 이름
 *
 */
@Service("BoardService")
public class BoardService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 메뉴명 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getBoardList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getBoardList", paramMap);
	}

	
	/**
	 * 덧글 저장 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public String boardCdEncrypt(Map<?, ?> paramMap) throws Exception {
		Log.Debug("==============================================>>>>서비스" );

		Log.Debug();
		Map<String, Object> rtn = (Map<String, Object>) dao.getMap("boardCdEncrypt", paramMap);
		String burl = "";
		if(rtn != null) {
			burl = (String)rtn.get("burl");
		}
		return burl;
	}	
	
	
	/**
	 *  게시판 쓰기권한 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> writeYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("writeYn", paramMap);
	}

	/**
	 *  게시판 관리자 권한 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> adminYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("adminYn", paramMap);
	}

	/**
	 *  게시판 권한 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> checkYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("checkYn", paramMap);
	}



	/**
	 *  덧글여부 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> commentYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("commentYn", paramMap);
	}

	/**
	 *  게시판 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> tsys710SelectBoardMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("tsys710SelectBoardMap", paramMap);
	}


	/**
	 *  게시판 이전다음 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> tsys710SelectPrevNext(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("tsys710SelectPrevNext", paramMap);
	}

	/**
	 *  게시판 정보  단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> boardInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("boardInfoMap", paramMap);
	}

	/**
	 * 게시물 저장 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int tsys710SaveEmptyClob(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("tsys710SaveEmptyClob", paramMap);
	}

	/**
	 * 게시물 EmptyClob 수정 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int tsys710UpdateEmptyClob(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.updateClob("tsys710UpdateBoard", paramMap);
	}


	/**
	 * mileage 관리
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int tsys710UpdatemileageMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("tsys710UpdatemileageMgr", paramMap);
	}


	/**
	 * 게시물 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int tsys710DeleteBoardSeq(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("tsys710DeleteBoardSeq", paramMap);
	}

	/**
	 *  덧글 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCmtList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getCmtList", paramMap);
	}


	/**
	 * 덧글 저장 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int saveCmt(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if (isEnableWriteComment(paramMap)) {
			cnt = dao.update("saveCmt", paramMap);
		} else {
			throw new HrException("댓글 작성 권한이 없습니다. 관리자에게 문의 바랍니다.");
		}
		return cnt;
	}

	private boolean isEnableWriteComment(Map<String, Object> paramMap) throws Exception {
		Map<String, Object> map = (Map<String, Object>) dao.getMap("getEnableWriteComment", paramMap);
		return ("Y".equals(map.get("commentYn"))) ? true : false;
	}

	/**
	 * 덧글 저장 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int delCmt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("delCmt", paramMap);
	}

	/**
	 * 게시물  저장 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	/*
	public int tsys700SaveEmptyClob(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if(paramMap.get("saveType").equals("insert"))
			cnt = dao.update("tsys700InsertEmptyClob", paramMap);
		else if(paramMap.get("saveType").equals("update"))
			cnt = dao.update("tsys700UpdateEmptyClob", paramMap);
		return cnt;
	}
	*/






//	/**
//	 * 메뉴명 저장 Service
//	 *
//	 * @param convertMap
//	 * @return int
//	 * @throws Exception
//	 */
//	public int saveBoard(Map<?, ?> convertMap) throws Exception {
//		Log.Debug();
//		int cnt=0;
//		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
//			cnt += dao.delete("deleteBoard", convertMap);
//		}
//		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
//			cnt += dao.update("saveBoard", convertMap);
//		}
//		Log.Debug();
//		return cnt;
//	}
//	/**
//	 * 메뉴명 생성 Service
//	 *
//	 * @param paramMap
//	 * @return int
//	 * @throws Exception
//	 */
//	public int insertBoard(Map<?, ?> paramMap) throws Exception {
//		Log.Debug();
//		return dao.create("insertBoard", paramMap);
//	}
//	/**
//	 * 메뉴명 수정 Service
//	 *
//	 * @param paramMap
//	 * @return int
//	 * @throws Exception
//	 */
//	public int updateBoard(Map<?, ?> paramMap) throws Exception {
//		Log.Debug();
//		return dao.update("updateBoard", paramMap);
//	}
//	/**
//	 * 메뉴명 삭제 Service
//	 *
//	 * @param paramMap
//	 * @return int
//	 * @throws Exception
//	 */
//	public int deleteBoard(Map<?, ?> paramMap) throws Exception {
//		Log.Debug();
//		return dao.delete("deleteBoard", paramMap);
//	}
}