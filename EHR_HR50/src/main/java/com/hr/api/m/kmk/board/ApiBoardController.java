package com.hr.api.m.kmk.board;

import com.hr.api.m.main.main.ApiMainService;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.kms.board.BoardService;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping(value="/api/v5/board")
public class ApiBoardController {

    @Inject
    @Named("BoardService")
    private BoardService boardService;

    @Inject
    @Named("ApiMainService")
    private ApiMainService apiMainService;

    @Inject
    @Named("SecurityMgrService")
    private SecurityMgrService securityMgrService;

    /**
     * 공지사항 정보를 전달한다.
     * @param paramMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getBoardList")
    public Map<String, Object> getBoardList(
            @RequestBody Map<String, Object> paramMap, HttpSession session) throws Exception {
        Map<String, Object> result = new HashMap<>();
        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{

            String searchTitle      = "";
            String searchName       = "";
            String searchContents   = "";

            Log.Debug("getBoardList =====");
            Log.Debug(":"+paramMap.toString());
            Log.Debug(":"+session.toString());

            String skey = session.getAttribute("ssnEncodedKey") == null ? "":String.valueOf(session.getAttribute("ssnEncodedKey"));

            Log.Debug(":"+skey);

            paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
            paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
            paramMap.put("searchTitle", searchTitle);
            paramMap.put("searchName", searchName);
            paramMap.put("searchContents", searchContents);

            Map<String, Object> map = (Map<String, Object>) boardService.boardInfoMap(paramMap);
            Log.Debug(map.toString());

            paramMap.put("searchYn", map.get("searchYn")== null ? "" : String.valueOf(map.get("searchYn")));
            paramMap.put("adminYn", map.get("adminYn")== null ? "" : String.valueOf(map.get("adminYn")));
            paramMap.put("bbsSort", map.get("bbsSort")== null ? "" : String.valueOf(map.get("bbsSort")));
            paramMap.put("ssnEncodedKey", skey);

            //페이징 설정
            int totalPage = apiMainService.getBoardListCnt(paramMap);
            Log.Debug("totalPage:"+totalPage);

            int divPage = 10;
            Log.Debug(paramMap.get("searchPage").toString());
            int page = paramMap.get("searchPage") == null? 1: Integer.valueOf(paramMap.get("searchPage").toString());
            int stNum = (page -1) * divPage + 1;
            int edNum = page * divPage;
            int lastPage = (totalPage / 10) + 1;

            paramMap.put("stNum", stNum);
            paramMap.put("edNum", edNum);

            list = apiMainService.getBoardListPaging(paramMap);
            Log.Debug(list.toString());

            if(list != null) {
                result.put("list", list);
                result.put("lastPage", lastPage);
            }else{
                result.put("list", "");
            }

        }catch(Exception e){
            Message="조회에 실패하였습니다.";
            Log.Debug(e.getMessage());
            result.put("Message", Message);
        }

        return result;
    }

    /**
     * 게시물 가져오기  (읽기 전용)
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(value = "/getBoardContent")
    public Map<String, Object> getBoardContent(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {


        //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
        //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
        HashMap<String, Object> mapBurl = (HashMap<String, Object>) boardBurlChk(session, request, paramMap);
        String urlChk = mapBurl.get("urlChk")	== null ? "" : String.valueOf(mapBurl.get("urlChk"));


        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));


        HashMap<String, Object> map = new HashMap<String, Object>();
        map = (HashMap<String, Object>) boardInfo(session, request,paramMap);

        paramMap.put("searchYn", map.get("searchYn")== null ? "" : String.valueOf(map.get("searchYn")));
        paramMap.put("adminYn", map.get("adminYn")== null ? "" : String.valueOf(map.get("adminYn")));
        paramMap.put("bbsSort", map.get("bbsSort")== null ? "" : String.valueOf(map.get("bbsSort")));

        Map<?, ?> boMap = boardService.tsys710SelectBoardMap(paramMap);
        Map<?, ?> pnMap = boardService.tsys710SelectPrevNext(paramMap);

        HashMap<String, Object> result = new HashMap<>();
        result.put("boMap", boMap);
        result.put("pnMap", pnMap);
        Log.DebugEnd();
        return result;

    }

    public Map<String, Object> boardBurlChk(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap
    ) throws Exception{

        Map<String, Object> urlParam = new HashMap<String, Object>();
        String burl = paramMap.get("burl") ==null ? "" :String.valueOf(paramMap.get("burl"));
        String bbsCd = paramMap.get("bbsCd") ==null ? "" :String.valueOf(paramMap.get("bbsCd"));
        String bbsSeq = paramMap.get("bbsSeq") ==null ? "" :String.valueOf(paramMap.get("bbsSeq"));

        String skey = session.getAttribute("ssnEncodedKey") == null ? "":String.valueOf(session.getAttribute("ssnEncodedKey"));

        Log.Debug(skey);

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

    public Map<String, Object> boardInfo(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap
    ) throws Exception{
        Map<String, Object> map = (Map<String,Object>)boardService.boardInfoMap(paramMap);
        Log.Debug("==============================================>>>>"+ map.toString());
        Log.Debug("==============================================>>>>"+ paramMap.toString());

        return map;
    }
}
