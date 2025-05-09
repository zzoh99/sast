package com.hr.kms.board;

import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
import com.hr.common.security.SecurityMgrService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * 게시판 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/Board.do", method=RequestMethod.POST )
@SuppressWarnings("unchecked")
public class BoardController {
	/**
	 * 게시판 서비스
	 */

	@Inject
	@Named("BoardService")
	private BoardService boardService;

	@Inject
	@Named("OtherService")
	private OtherService otherService;

	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;


	/**
	 * 게시판 List
	 *
	 * @return String
	 * @throws Exception
	 */

	@RequestMapping(params="cmd=getListBoard", method = RequestMethod.POST )
	public ModelAndView listBoard(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		Log.Debug("==============================================>>>>리스트 시작" );
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		//Map<?, ?> map = boardService.boardInfoMap(paramMap);
		//Map<String, Object> map = (Map<String,Object>)boardService.boardInfoMap(paramMap);


		Map<String, Object> map = new HashMap<String, Object>();
		map = (Map<String, Object>) boardInfo(session, request,paramMap);

		paramMap.put("bbsPg", "W");
		Map<?, ?> wCheckYnmap = boardService.checkYn(paramMap);
		if(wCheckYnmap != null) {
			String checkYn = String.valueOf(wCheckYnmap.get("yn"));
			if("null".equals(checkYn)) {
				checkYn = "";
			}
			map.put("wCheckYn", checkYn);
		}

		paramMap.put("bbsPg", "L");
		Map<?, ?> checkYnmap = boardService.checkYn(paramMap);
		if(checkYnmap != null) {
			String checkYn = String.valueOf(checkYnmap.get("yn"));
			if("null".equals(checkYn)) {
				checkYn = "";
			}
			map.put("checkYn", checkYn);
		}

		ModelAndView mv = new ModelAndView();
//		mv.setViewName("kms/board/boardList");
		//회의록 등록화면에서 사용하기 위해 viewName 변경
		mv.setViewName("11000".equals(String.valueOf(map.get("bbsCd")))
				? "sys/project/meetingLogMgr/meetingLogMgr" : "kms/board/boardList");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;

	}

	public Map<String, Object> boardInfo(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap
			) throws Exception{
		Map<String, Object> map = (Map<String,Object>)boardService.boardInfoMap(paramMap);
		if(map != null) {
			Log.Debug("==============================================>>>>"+ map.toString());
		}
		Log.Debug("==============================================>>>>"+ paramMap.toString());

		return map;
	}

	public Map<String, Object> boardBurlChk(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap
			) throws Exception{

		Map<String, Object> urlParam = new HashMap<String, Object>();
		String burl =paramMap.get("burl") ==null ? "" :String.valueOf(paramMap.get("burl"));
		String bbsCd =paramMap.get("bbsCd") ==null ? "" :String.valueOf(paramMap.get("bbsCd"));
		String bbsSeq =paramMap.get("bbsSeq") ==null ? "" :String.valueOf(paramMap.get("bbsSeq"));

		String skey = session.getAttribute("ssnEncodedKey") == null ? "":String.valueOf(session.getAttribute("ssnEncodedKey"));

		Log.Debug("==■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■1■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■1--");
		if(burl.equals("")){
			Log.Debug("==■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■1■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■2--");



			paramMap.put("ssnEncodedKey", 	skey);
			burl = boardService.boardCdEncrypt(paramMap) ;
			urlParam.put("burl", burl);
			urlParam.put("urlChk", "Y");

			Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■1■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■3--"+ urlParam);

		}
		else{
			urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( burl, skey  );

			Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■k");
			Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■k");
			Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■k");


			if(! bbsCd.equals(urlParam.get("bbsCd"))){
				urlParam.put("urlChk", "N");
			}else if(! bbsSeq.equals(urlParam.get("bbsSeq"))){
				urlParam.put("urlChk", "N");
			}else {
				urlParam.put("urlChk", "Y");
			}
		}

		return urlParam;

	}

	@RequestMapping(params="cmd=viewBoardReadPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView boardReadPopup(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		Map<String, Object> map = (Map<String,Object>) boardService.boardInfoMap(paramMap);

		map.put("bbsCd",  paramMap.get("bbsCd"));
		map.put("bbsSeq", paramMap.get("bbsSeq"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("kms/board/boardReadPopup");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=viewBoardReadLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView boardReadLayer(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		Map<String, Object> map = (Map<String,Object>) boardService.boardInfoMap(paramMap);

		map.put("bbsCd",  paramMap.get("bbsCd"));
		map.put("bbsSeq", paramMap.get("bbsSeq"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("kms/board/boardReadLayer");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=viewBoardReadPopupEx", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView boardReadPopupEx(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map<String, Object> map = (Map<String,Object>)boardService.boardInfoMap(paramMap);

		map.put("bbsCd",  paramMap.get("bbsCd"));
		map.put("bbsSeq", paramMap.get("bbsSeq"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("kms/board/boardReadPopupEx");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;

	}


	/**
	 * 게시판 등록수정  페이지 이동
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewBoardWrite", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView writeBoard(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		String bbsSeq  	= paramMap.get("bbsSeq")== null ? "":String.valueOf(paramMap.get("bbsSeq"));
		String burl  	= paramMap.get("burl")== null ? "":String.valueOf(paramMap.get("burl"));


		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));



		int mh = 0;

		Map<String, Object> map = boardInfo(session, request,paramMap);
		if(map == null) {
			map = new HashMap<String, Object>();
		}
		paramMap.put("bbsPg", "W");
		Map<?, ?> checkYnmap = boardService.checkYn(paramMap);
		if(checkYnmap != null) {
			String checkYn = String.valueOf(checkYnmap.get("yn"));
			if("null".equals(checkYn)) {
				checkYn = "";
			}
			map.put("checkYn", checkYn);
		}

		ModelAndView mv = new ModelAndView();
		Map<String, Object> editorMap = new HashMap<String, Object>();
		editorMap.put("formNm", "srchFrm");
		editorMap.put("contentNm", "contents");

		if("Y".equals(map.get("headYn"))) mh = mh + 50;
		if("Y".equals(map.get("tagYn"))) mh = mh + 50;
		if("Y".equals(map.get("contactYn"))) mh = mh + 50;
		if("Y".equals(map.get("fileYn"))) mh = mh + 100;

		editorMap.put("minusHeight", (150+mh));

		mv.addObject("editor", editorMap);

		//String priorBbsSeq ="0";
		if(!paramMap.get("saveType").equals("update")){
			/*
			 * if(paramMap.get("saveType").equals("reply")){ priorBbsSeq = bbsSeq; }
			 */
			paramMap.put("seqId","BBS");
			Map<?, ?> sequenceMap = (Map<?, ?>)otherService.getSequence(paramMap);
			if(sequenceMap != null) {
				bbsSeq = String.valueOf(sequenceMap.get("getSeq"));
				if("null".equals(bbsSeq)) {
					bbsSeq = "";
				}
			}
			paramMap.put("bbsSeq", bbsSeq);
		}

		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		Map<String, Object> mapBurl = (Map<String, Object>) boardBurlChk(session, request,paramMap);

		String urlChk = mapBurl.get("urlChk")	== null ? "" : String.valueOf(mapBurl.get("urlChk"));

		if (!urlChk.equals("Y")){
			return new ModelAndView("redirect:/Info.do?code=999"); //잘못된 접근
  		}

		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

		//if none burl
		if(burl.equals("") ){
			paramMap.put("burl", mapBurl.get("burl")== null ? "":String.valueOf(mapBurl.get("burl")));

		}

		map.put("bbsSeq", 	bbsSeq	== null ? "":String.valueOf(bbsSeq));
		map.put("saveType", paramMap.get("saveType")== null ? "":String.valueOf(paramMap.get("saveType")));
		map.put("bbsCd", 	paramMap.get("bbsCd")	== null ? "":String.valueOf(paramMap.get("bbsCd")));
		map.put("burl", 	paramMap.get("burl")	== null ? "":String.valueOf(paramMap.get("burl")));

		mv.setViewName("kms/board/boardWrite");
		//mv.addObject("bbsSeq", bbsSeq);
		//mv.addObject("priorBbsSeq", priorBbsSeq);
		mv.addObject("map", map);
		return mv;


	}


	/**
	 * 게시물 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */

	@RequestMapping(params="cmd=viewBoardRead", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView ReadBoard(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		HashMap<String, Object> mapBurl = (HashMap<String, Object>) boardBurlChk(session, request,paramMap);
		String urlChk = mapBurl.get("urlChk")	== null ? "" : String.valueOf(mapBurl.get("urlChk"));

		if (!urlChk.equals("Y")){
			return new ModelAndView("redirect:/Info.do?code=999"); //잘못된 접근
  		}
		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■


		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		HashMap<String, Object> map = new HashMap<String, Object>();
		map = (HashMap<String, Object>) boardInfo(session, request,paramMap);
		
		if(map == null) {
			map = new HashMap<String, Object>();
		}

		paramMap.put("searchYn", 	map.get("searchYn")	== null ? "" : String.valueOf(map.get("searchYn")));
		paramMap.put("adminYn", 	map.get("adminYn")	== null ? "" : String.valueOf(map.get("adminYn")));
		paramMap.put("bbsSort", 	map.get("bbsSort")	== null ? "" : String.valueOf(map.get("bbsSort")));

		map.put("bbsSeq", 	paramMap.get("bbsSeq")	== null ? "":String.valueOf(paramMap.get("bbsSeq")));
		map.put("saveType", paramMap.get("saveType")== null ? "":String.valueOf(paramMap.get("saveType")));
		map.put("bbsCd", 	paramMap.get("bbsCd")	== null ? "":String.valueOf(paramMap.get("bbsCd")));
		map.put("burl", 	paramMap.get("burl")	== null ? "":String.valueOf(paramMap.get("burl")));


		int mh = 0;
		if("Y".equals(map.get("headYn"))) mh = mh + 50;
		if("Y".equals(map.get("tagYn"))) mh = mh + 50;
		if("Y".equals(map.get("contactYn"))) mh = mh + 50;
		if("Y".equals(map.get("fileYn"))) mh = mh + 100;
		if("Y".equals(map.get("commentYn"))) mh = mh + 120;

		String cReferer = request.getHeader("referer");
		if( cReferer.indexOf( "ListBoard" ) > -1 ||
			cReferer.indexOf( "BoardWrite" ) > -1 ||
			cReferer.indexOf( "delBoard" ) > -1 )
		{
			paramMap.put("bbsPg", "R");
			Map<?, ?> checkYnmap = boardService.checkYn(paramMap);
			map.put("minusHeight", (200+mh));
			map.put("referer", "List");
			map.put("checkYn", checkYnmap != null && checkYnmap.get("yn") != null ? checkYnmap.get("yn").toString():"N");
		}
		else{
			map.put("minusHeight", (100+mh));
			map.put("referer", "Other");
			map.put("checkYn", "N");
		}

		Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■map="+cReferer + map);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("kms/board/boardRead");
		mv.addObject("map", map);
		return mv;
	}



	/**
	 * 게시물 카운트뷰 증가=> 마이릴지 관리로빼야함
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */

	@RequestMapping(params="cmd=viewMileageMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView  mileageMgr(
		HttpSession session,  HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap ) throws Exception {
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		int cnt = boardService.tsys710UpdatemileageMgr(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", cnt);
		return mv;
	}


	/**
	 * 게시물 가져오기  (읽기 전용)
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBoardContent", method = RequestMethod.POST )
	public ModelAndView recNoticeMgrRegmailContent(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {


		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		HashMap<String, Object> mapBurl = (HashMap<String, Object>) boardBurlChk(session, request,paramMap);
		String urlChk = mapBurl.get("urlChk")	== null ? "" : String.valueOf(mapBurl.get("urlChk"));

		if (!urlChk.equals("Y")){
			return new ModelAndView("redirect:/Info.do?code=999"); //잘못된 접근
  		}
		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■



		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));


		HashMap<String, Object> map = (HashMap<String, Object>) boardInfo(session, request,paramMap);
		if(map == null) {
			map = new HashMap<String, Object>();
		}

		paramMap.put("searchYn", map.get("searchYn")== null ? "" : String.valueOf(map.get("searchYn")));
		paramMap.put("adminYn", map.get("adminYn")== null ? "" : String.valueOf(map.get("adminYn")));
		paramMap.put("bbsSort", map.get("bbsSort")== null ? "" : String.valueOf(map.get("bbsSort")));

		Map<?, ?> boMap = boardService.tsys710SelectBoardMap(paramMap);
		Map<?, ?> pnMap = boardService.tsys710SelectPrevNext(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("boMap", boMap);
		mv.addObject("pnMap", pnMap);
		//mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;

	}

	/**
	 * 쓰기권한 여부
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=writeYn", method = RequestMethod.POST )
	public ModelAndView writeYn(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map<?, ?> map = boardService.writeYn(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;

	}

	/**
	 * 관리자권한 여부
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=adminYn", method = RequestMethod.POST )
	public ModelAndView adminYn(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map<?, ?> map = boardService.adminYn(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;

	}

	/**
	 * 덧글여부 가져오기
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=commentYn", method = RequestMethod.POST )
	public ModelAndView commentYn(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map<?, ?> map = boardService.commentYn(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;

	}

	/**
	 * 게시물 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBoardList", method = RequestMethod.POST )
	public ModelAndView getBoardList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String message = "";
		String chkField = paramMap.get("chkField").toString() ;

		String searchTitle      = "";
		String searchName       = "";
		String searchContents   = "";


		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		//전체선택일때에는 모든조건이 ALL이다.
		if(chkField.indexOf("ALL") > -1){
			searchTitle      = "ALL";
			searchName       = "ALL";
			searchContents   = "ALL";
		}else{
			if ( chkField.indexOf("TITLE") > -1 ) {searchTitle = "TITLE";} //제목
			if ( chkField.indexOf("CONTENTS") > -1 ) {searchContents = "CONTENTS";} //내용
			if ( chkField.indexOf("NAME") > -1 ) {searchName = "NAME";} //작성자
		}

		paramMap.put("searchTitle", searchTitle);
		paramMap.put("searchName", searchName);
		paramMap.put("searchContents", searchContents);

		Map<String, Object> map = (Map<String, Object>) boardInfo(session, request,paramMap);
		if(map == null) {
			map = new HashMap<String, Object>();
		}

		paramMap.put("searchYn", map.get("searchYn")== null ? "" : String.valueOf(map.get("searchYn")));
		paramMap.put("adminYn", map.get("adminYn")== null ? "" : String.valueOf(map.get("adminYn")));
		paramMap.put("bbsSort", map.get("bbsSort")== null ? "" : String.valueOf(map.get("bbsSort")));
		paramMap.put("ssnEncodedKey", session.getAttribute("ssnEncodedKey")== null ? "" : String.valueOf(session.getAttribute("ssnEncodedKey")));

		try{
			list = boardService.getBoardList(paramMap);
		}catch(Exception e){
			message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}



	/**
	 * 게시물 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveBoard", method = RequestMethod.POST )
	public ModelAndView saveBoard(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작

		Log.Debug("==============================================>>>>저장 시작" + paramMap );
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));


		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

		HashMap<String, Object> mapBurl = (HashMap<String, Object>) boardBurlChk(session, request,paramMap);

		String urlChk = mapBurl.get("urlChk")	== null ? "" : String.valueOf(mapBurl.get("urlChk"));

		if (!"Y".equals(urlChk)){
			return new ModelAndView("redirect:/Info.do?code=999"); //잘못된 접근
  		}

		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■


		//String message = "";
		int resultCnt = -1;

		paramMap.put("bbsPg", "S");
		Map<?, ?> checkYnmap = boardService.checkYn(paramMap);

		if(checkYnmap.get("yn").equals("Y")){
			try{
				resultCnt = boardService.tsys710SaveEmptyClob(paramMap);
				//if(resultCnt < 1){ message="데이터 초기화에 실패하였습니다."; }
				if (resultCnt > 0) {
					resultCnt = boardService.tsys710UpdateEmptyClob(paramMap);
					//if(resultCnt > 0){ message="저장되었습니다."; }
					//else{ message="저장된  내용이 없습니다."; }
				}

			}catch(Exception e){
				resultCnt = -1;
				//message="저장에 실패하였습니다.";
			}
		}else{
			resultCnt = -1;
			//message="수정권한이 없습니다.";
		}

		//ModelAndView mv = new ModelAndView();
		//mv.setViewName("jsonView");


    	//관리자가 아니면
    	if( resultCnt > 0){
    		//return new ModelAndView("redirect:/Board.do?cmd=viewBoardRead");
    		return ReadBoard(session, request, paramMap);
    	}else{
    		//return chguser(session, paramMap, request);
    		return new ModelAndView("redirect:/Main.do");

    	}


		//mv.addObject("code", resultCnt);
		//mv.addObject("message", message);
		//mv.addObject("map", paramMap);
		//Log.DebugEnd();

		//return mv;
	}


	/**
	 * 게시물 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=delBoard", method = RequestMethod.POST )
	public ModelAndView delBoard(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작


		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		HashMap<String, Object> mapBurl = (HashMap<String, Object>) boardBurlChk(session, request,paramMap);

		String urlChk = mapBurl.get("urlChk")	== null ? "" : String.valueOf(mapBurl.get("urlChk"));

		if (!urlChk.equals("Y")){
			return new ModelAndView("redirect:/Info.do?code=999"); //잘못된 접근
  		}

		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■


		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = boardService.tsys710DeleteBoardSeq(paramMap);
			if(resultCnt < 1){ message="데이터 초기화에 실패하였습니다."; }
			else{
				if(resultCnt > 0){ message="저장되었습니다."; }
				else{ message="삭제된  내용이 없습니다."; }
			}

		}catch(Exception e){
			resultCnt = -1;
			message="삭제에 실패하였습니다.";
		}


		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);

		return listBoard(session, request, paramMap);


		//HashMap<String, Object> map = new HashMap<String, Object>();
		//map = (HashMap<String, Object>) boardInfo(session, request,paramMap);




		//ModelAndView mv = new ModelAndView();
		/*
		mv.setViewName("kms/board/boardList");
		mv.addObject("map", map);
		//mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
		*/
	}

	/**
	 * 덧글 가져오기
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveCmt", method = RequestMethod.POST )
	public ModelAndView saveCmt(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		// comment 시작

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = boardService.saveCmt(paramMap);
		} catch(HrException e) {
			message = e.getLocalizedMessage();
		} catch(Exception e){
			message="저장에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("code", resultCnt);
		mv.addObject("message", message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 덧글 저장하기
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCmtList", method = RequestMethod.POST )
	public ModelAndView getCmtList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = boardService.getCmtList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 덧글 가져오기
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=delCmt", method = RequestMethod.POST )
	public ModelAndView delCmt(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		// comment 시작

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = boardService.delCmt(paramMap);
		}catch(Exception e){
			resultCnt = -1;
			message="저장에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("code", resultCnt);
		mv.addObject("message", message);
		mv.addObject("map", paramMap);
		Log.DebugEnd();
		return mv;
	}


}
