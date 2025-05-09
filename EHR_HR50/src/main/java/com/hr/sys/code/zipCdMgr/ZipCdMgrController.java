package com.hr.sys.code.zipCdMgr;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
/**
 * 우편번호관리 Controller
 * @author 이름
 */
@Controller
@RequestMapping(value="/ZipCdMgr.do", method=RequestMethod.POST )
public class ZipCdMgrController {
	/**
	 * 우편번호관리 서비스
	 */
	@Inject
	@Named("ZipCdMgrService")
	private ZipCdMgrService zipCdMgrService;
	/**
	 * 우편번호관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewZipCdMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewZipCdMgr() throws Exception {
		return "sys/code/zipCdMgr/zipCdMgr";
	}
	/**
	 * 우편번호관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getZipCdMgrList", method = RequestMethod.POST )
	public ModelAndView getZipCdMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<>();
		Map<?, ?> map  = new HashMap<>();
		String message = "";


/*
		String searchWord	= paramMap.get("searchWord").toString();
		String searchWord1  = ""; //ROAD_NAME
		String searchWord2  = ""; //BDNO_M
		String searchWord3  = ""; //BDNO_S

		String[] arrNewWord = searchWord.split(" ");

			for (int i=0; i < arrNewWord.length; ++i) {
			if(i==0){
				searchWord1 = arrNewWord[i];
			}else if (i==1){
				String[] arrBdno = arrNewWord[i].split("-");
				searchWord2 = arrBdno[0];
				searchWord3 = (arrNewWord[i].indexOf("-") >= 0)? arrBdno[1]:"";
			}
		}

		paramMap.put("searchWord1", searchWord1);
		paramMap.put("searchWord2", searchWord2);
		paramMap.put("searchWord3", searchWord3);

*/

		String searchWord	= paramMap.get("searchWord").toString().replaceAll("-"," ");
		StringTokenizer st = new StringTokenizer(searchWord);
		List<Serializable> sword = new ArrayList<Serializable>();
		StringBuffer query = new StringBuffer();

		while(st.hasMoreTokens()) {
			String tocken = st.nextToken();
			sword.add(tocken);
		}

		for( int i = 0 ; i < sword.size() ; i ++ ){
			query.append(" AND "
						+ "("
						+ " SIDO LIKE '"+sword.get(i)+"%'"
						+ " OR SIGUNGU LIKE '"+sword.get(i)+"%'"
						+ " OR UPMYON LIKE '"+sword.get(i)+"%'"
						+ " OR ROAD_NAME LIKE '"+sword.get(i)+"%'"
						+ " OR SIGUNGUBD_NAME LIKE '"+sword.get(i)+"%'"
						+ " OR BDNO_M LIKE '"+sword.get(i)+"%'"
						+ " OR BDNO_S LIKE '"+sword.get(i)+"%'"
						+ " OR LAW_DONG_NAME LIKE '"+sword.get(i)+"%'"
						+ " OR GOV_DONG_NAME  LIKE '"+sword.get(i)+"%'"
						+ " OR JIBUN_M LIKE '"+sword.get(i)+"%'"
						+ " OR JIBUN_S LIKE '"+sword.get(i)+"%'"
						+ " )");
		}

		paramMap.put("query", query.toString());

		try{
			// 서비스 호출
			map = zipCdMgrService.getZipCdMgrCntMap(paramMap);
		}catch(Exception e){
			message="조회에 실패하였습니다.";
		}

		try{
			// 서비스 호출
			list = zipCdMgrService.getZipCdMgrList(paramMap);
		}catch(Exception e){
			message="조회에 실패하였습니다.";
		}

		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		// 그리드에 맵핑 되는 데이터 이면 DATA에 담아서 보냄
		mv.addObject("TOTAL",map.get("cnt"));
		mv.addObject("Botal","");
		mv.addObject("Message", message);
		mv.addObject("DATA", list);
		// comment 종료
		Log.DebugEnd();
		return mv;
	}
}
