package com.hr.cpn.personalPay.perPayYearMgr;

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.Serializable;
import java.net.URLDecoder;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 연봉관리 Controller
 *
 * @author JSG
 *
 */
@Controller
//@SuppressWarnings("unchecked")
@RequestMapping({"/PerPayYearMgr.do", "/PerPayYearLst.do", "/PerPayMasterMgr.do"})
public class PerPayYearMgrController extends ComController {
	/**
	 * 연봉관리 서비스
	 */
	@Inject
	@Named("PerPayYearMgrService")
	private PerPayYearMgrService perPayYearMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;

	/**
	 * 월별급여지급현황 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayYearMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayYearMgr() throws Exception {
		return "cpn/personalPay/perPayYearMgr/perPayYearMgr";
	}
	/**
	 *  다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayYearMgrTitleList", method = RequestMethod.POST )
	public ModelAndView getPerPayYearMgrTitleList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 발령구분(부서전배, 조직개편) 발령종류코드(ORD_TYPE_CD 콤보로 사용할때) 조회 
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayYearEleGroupCodeList", method = RequestMethod.POST )
	public ModelAndView getPerPayYearEleGroupCodeList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> result = perPayYearMgrService.getPerPayYearEleGroupCodeList
				(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(params="cmd=getPerPayYearMgrList", method = RequestMethod.POST )
	public ModelAndView getPerPayYearMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
//		paramMap.put("columnInfo", URLDecoder.decode(paramMap.get("columnInfo").toString().replaceAll("&#39;", "'"), "UTF-8"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			List<Map> columnInfo = (List<Map>) perPayYearMgrService.getPerPayYearMgrTitleList(paramMap);
			List<String> elementCd = Arrays.asList(columnInfo.get(0).get("elementCd").toString().split("\\|"));
			List<String> elementAlias = elementCd.stream()
					.map(element -> "ELE_" + element)
					.collect(Collectors.toList());

			paramMap.put("elementCd", elementCd);
			paramMap.put("elementAlias", elementAlias);

			list = perPayYearMgrService.getPerPayYearMgrList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 연봉관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePerPayYearMgr", method = RequestMethod.POST )
	public ModelAndView savePerPayYearMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {


		Log.DebugStart();

		List<?> list  = new ArrayList<Object>();
		Map<String, Object> mp =new HashMap<String, Object>();

		mp.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		mp.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		
		mp.put("searchPayGroupCd", paramMap.get("searchPayGroupCd").toString());
		mp.put("searchSDate", 	paramMap.get("searchSDate").toString());

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		list = perPayYearMgrService.getPerPayYearMgrTitleList(mp);

		Map<String,Object> tempMp = (Map<String,Object>)list.get(0);

		String values =  (String)tempMp.get("eleValues");
		String values2 = (String)tempMp.get("realValues");

		Map<String, Object> convertMapDetail = requestInParamsRowToIndex(request,paramMap.get("s_SAVENAME").toString(),values, values2);
		convertMapDetail.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMapDetail.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		Map<String, Object> convertMapMaster = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(), "");
		convertMapMaster.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMapMaster.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =perPayYearMgrService.savePerPayYearMgr(convertMapDetail, convertMapMaster);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	public static synchronized  HashMap<String, Object> requestInParamsRowToIndex( HttpServletRequest request, String paramNames, String paramValues, String paramValues2 ) {
		String[] exCols 					= null;
		HashMap<String, Object> returnMap 	= new HashMap<String, Object>();
		HashMap<String, String> map 		= null;
		// COLS LIST
		List<Serializable>  mergeRows		= new ArrayList<Serializable>();
		List<Serializable>  insertRows		= new ArrayList<Serializable>();
		List<Serializable>  updateRows 		= new ArrayList<Serializable>();
		List<Serializable>  deleteRows 		= new ArrayList<Serializable>();
		List<Serializable>  subTempList		= new ArrayList<Serializable>();
		int rowSize 				= 0;
		int colSize 				= 0;
		int colSize2 				= 0;
		String paramName 			= "";
		Boolean CheckAdd			= false;

		if(paramNames != null){
			//String[] colNames  = (paramNames+paramValues).split(",");
			String[] colNames  = paramNames.split(",");
			String[] cols      = null;
			String[] cols2      = null;
			if(paramValues != null && !paramValues.equals("")){
				//cols = (paramNames+paramValues).split(",");
				cols = paramNames.split(",");
				cols2 = paramValues2.split(",");
			}else{
				cols = paramNames.split(",");
			}
			Map<?, ?> paramMap 		= request.getParameterMap();

			if(paramMap.get(cols[0]) != null){
				rowSize = ((String[]) paramMap.get( cols[0]) ).length;
				colSize = cols != null ? cols.length:0;
				colSize2 = cols2 != null ? cols2.length:0;
				// COLS 인것
				if ( null != cols || cols.length > 0 )  {
					// ROW 형식
					for ( int i = 0; i < rowSize; i++ )  {
						for ( int k = 0; k < colSize2; k++ )  {
							map = new HashMap<String, String>();
							CheckAdd = false;
							for ( int j = 0; j < colSize; j++ )  {
								if(paramMap.get(cols[j]) == null) {
									Log.Debug(cols[j]+" ================ null value");
								}
								if (cols[j] != null && cols[j].indexOf("ele") > -1){
									if ( StringUtil.upperCase(StringUtil.convertToUnderScore(colNames[j].replace("ele", ""))).equals(cols2[k])){
										map.put( "elementCd" , StringUtil.upperCase(cols2[k]));
										map.put( "elementMon" ,  StringUtil.replaceSingleQuot( ((String[]) paramMap.get(cols[j]) )[i] ) );
										CheckAdd = true;
									}
								}else{
									map.put( colNames[j] , StringUtil.replaceSingleQuot( ((String[]) paramMap.get(cols[j]) )[i] ) );
								}
							}
							if(CheckAdd){
								if( 	map.get("sStatus").equals("I") ){ insertRows.add(map); mergeRows.add(map);}
								else if(map.get("sStatus").equals("U") ){ updateRows.add(map); mergeRows.add(map);}
								else if(map.get("sStatus").equals("D") ){ deleteRows.add(map); }
							}
						}
					}
					returnMap.put( "mergeRows" , mergeRows );
					returnMap.put( "insertRows" , insertRows );
					returnMap.put( "updateRows" , updateRows );
					returnMap.put( "deleteRows" , deleteRows );
				}
				Enumeration<?> enumeration = request.getParameterNames();

				// COLS 이외의 것들
				for ( int i = 0; i < paramMap.size(); i++ )
				{
					paramName = ( String ) enumeration.nextElement();
					if ( existCols( cols, paramName ) ) { continue; }
					exCols = (String[]) paramMap.get( paramName );
					if ( exCols.length > 1)
					{
						subTempList = new ArrayList<Serializable>();
						for ( int j = 0; j < exCols.length; j++ )
						{
							subTempList.add( exCols[j] );
						}
						returnMap.put( paramName, subTempList );
					} else {
						returnMap.put( paramName, exCols[0] );
					}
				}
			}
		}
		Log.Debug("###################################################returnMap=>"+returnMap);
		return returnMap;
	}

	public static synchronized boolean existCols(String[] cols, String paramName) {
		for (int i = 0; i < cols.length; i++) {
			if (paramName.equals(cols[i])) { return true; }
		}
		return false;
	}
	
	/**
	 * 연봉관리종료일자 UPDATE
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN403_EDATE_UPDATE", method = RequestMethod.POST )
	public ModelAndView prcP_CPN403_EDATE_UPDATE(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<?, ?> map = perPayYearMgrService.prcP_CPN403_EDATE_UPDATE(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));

			if (map.get("sqlcode") == null) {
				resultMap.put("Code", "0");
			} else {
				resultMap.put("Code", map.get("sqlcode").toString());
			}
			if (!("0").equals(resultMap.get("Code").toString())) {
				if (map.get("sqlerrm") != null) {
					resultMap.put("Message", map.get("sqlerrm").toString());
				} else {
					resultMap.put("Message", "자료생성 오류입니다.");
				}
			} else {
				resultMap.put("Message", "정상처리 되었습니다.");
			}
		}

		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}
}
