<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.regex.Matcher"%>
<%@ page import="java.util.regex.Pattern"%>
<%@ page import="java.net.URLDecoder"%>

<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!

//xml 파서를 이용한 방법;
public Map setQueryMap(String path) {
	return XmlQueryParser.getQueryMap(path);
}

//주소변경 대상여부 조회
public Map getChkChgAddressMap(String path, Map paramMap) throws Exception {

	Map queryMap = XmlQueryParser.getQueryMap(path);

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getChkChgAddressMap",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return pm;
}

//변경대상 주소 조회
public List getChgAddressPopupList(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getChgAddressPopupList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}

//변경주소 저장
public int saveChgAddress(Map paramMap, Map queryMap) throws Exception {
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;

	if(list != null && list.size() > 0 && conn != null) {

		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);

		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");

				if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "saveChgAddress", mp);
				}
			}

			//커밋
			conn.commit();
		} catch(UserException e) {
			try {
				//롤백
				conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception(e.getMessage());
		} catch(Exception e) {
			try {
				//롤백
				conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception("저장에 실패하였습니다.");
		} finally {
			DBConn.closeConnection(conn, null, null);
		}
	}

	return rstCnt;
}

//변경주소 저장
public int saveAddressChgStatus(Map paramMap, Map queryMap) throws Exception {
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;

	if(list != null && list.size() > 0 && conn != null) {

		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);

		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");

				if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "saveAddressChgStatus", mp);
				}
			}

			//커밋
			conn.commit();
		} catch(UserException e) {
			try {
				//롤백
				conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception(e.getMessage());
		} catch(Exception e) {
			try {
				//롤백
				conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception("저장에 실패하였습니다.");
		} finally {
			DBConn.closeConnection(conn, null, null);
		}
	}

	return rstCnt;
}

//변경주소 저장
public int saveUploadAddressChgStatus(Map paramMap, Map queryMap) throws Exception {
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;

	if(list != null && list.size() > 0 && conn != null) {

		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);

		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);

				rstCnt += DBConn.executeUpdate(conn, queryMap, "saveUploadAddressChgStatus", mp);
			}

			//커밋
			conn.commit();
		} catch(UserException e) {
			try {
				//롤백
				conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception(e.getMessage());
		} catch(Exception e) {
			try {
				//롤백
				conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception("저장에 실패하였습니다.");
		} finally {
			DBConn.closeConnection(conn, null, null);
		}
	}

	return rstCnt;
}

//주소 조회
public List getAddressList(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getAddressList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}

private Map parseAddressList(String fullAddress){
	Map cm = new HashMap();
	fullAddress = fullAddress.trim();
	//의미없는 값 공백으로 치환
	fullAddress = fullAddress.replaceAll("호 ", " ");
	fullAddress = fullAddress.replaceAll("번지의 ","-");
	fullAddress = fullAddress.replaceAll("번지 "," ");
	fullAddress = fullAddress.replaceAll("의 ","-");
	fullAddress = fullAddress.replaceAll("   "," ");
	fullAddress = fullAddress.replaceAll("  "," ");
	if(fullAddress.endsWith("번지")) fullAddress = fullAddress.substring(0,fullAddress.length()-2);

	//주소정보 파싱
	String sido = "";//시도
	String[] search_sido = {"강원도","강원"
						   ,"경기도","경기"
						   ,"서울특별시","서울시","서울"
						   ,"세종특별자치시","세종시","세종"
						   ,"제주특별자치도","제주도","제주 "
						   ,"대전광역시","대전시","대전"
						   ,"대구광역시","대구시","대구"
						   ,"인천광역시","인천시","인천"
						   ,"광주광역시","광주시","광주"
						   ,"부산광역시","부산시","부산"
						   ,"울산광역시","울산시","울산"
						   ,"경상남도","경남"
						   ,"경상북도","경북"
						   ,"전라남도","전남"
						   ,"전라북도","전북"
						   ,"충청남도","충남"
						   ,"충청북도","충북"
						   };
	String[] convert_sido = {"강원도","강원도"
						   ,"경기도","경기도"
						   ,"서울특별시","서울특별시","서울특별시"
						   ,"세종특별자치시","세종특별자치시","세종특별자치시"
						   ,"제주특별자치도","제주특별자치도","제주특별자치도"
						   ,"대전광역시","대전광역시","대전광역시"
						   ,"대구광역시","대구광역시","대구광역시"
						   ,"인천광역시","인천광역시","인천광역시"
						   ,"광주광역시","광주광역시","광주광역시"
						   ,"부산광역시","부산광역시","부산광역시"
						   ,"울산광역시","울산광역시","울산광역시"
						   ,"경상남도","경상남도"
						   ,"경상북도","경상북도"
						   ,"전라남도","전라남도"
						   ,"전라북도","전라북도"
						   ,"충청남도","충청남도"
						   ,"충청북도","충청북도"
						   };
	for(int i = 0 ; i<search_sido.length ; i++){
		if(fullAddress.contains(search_sido[i])){
			sido = convert_sido[i];
			fullAddress = fullAddress.replace(search_sido[i],"");
			fullAddress = fullAddress.trim();
			break;
		}
	}

	String sigungu = ""; //시군구

	if(fullAddress.contains("시 ")){
		sigungu = sigungu + fullAddress.substring(0,fullAddress.indexOf("시 ")+1);
		fullAddress = fullAddress.substring(fullAddress.indexOf("시 ")+2,fullAddress.length());
		fullAddress = fullAddress.trim();
	}
	if(fullAddress.contains("군 ")){
		sigungu = sigungu + fullAddress.substring(0,fullAddress.indexOf("군 ")+1);
		fullAddress = fullAddress.substring(fullAddress.indexOf("군 ")+2,fullAddress.length());
		fullAddress = fullAddress.trim();
	}
	if(fullAddress.contains("구 ")){
		if(!sigungu.equals("")) sigungu = sigungu + " " + fullAddress.substring(0,fullAddress.indexOf("구 ")+1);
		else sigungu = sigungu + fullAddress.substring(0,fullAddress.indexOf("구 ")+1);
		fullAddress = fullAddress.substring(fullAddress.indexOf("구 ")+2,fullAddress.length());
		fullAddress = fullAddress.trim();
	}

	String upmyon = ""; //읍면
	if(fullAddress.contains("읍 ")){
		upmyon = upmyon + fullAddress.substring(0,fullAddress.indexOf("읍 ")+1);
		fullAddress = fullAddress.substring(fullAddress.indexOf("읍 ")+2,fullAddress.length());
		fullAddress = fullAddress.trim();
	}
	if(fullAddress.contains("면 ")){
		upmyon = upmyon + fullAddress.substring(0,fullAddress.indexOf("면 ")+1);
		fullAddress = fullAddress.substring(fullAddress.indexOf("면 ")+2,fullAddress.length());
		fullAddress = fullAddress.trim();
	}

	String road_name = ""; //도로명
	if(fullAddress.contains("로 ")){
		road_name = road_name + fullAddress.substring(0,fullAddress.indexOf("로 ")+1);
		fullAddress = fullAddress.substring(fullAddress.indexOf("로 ")+2,fullAddress.length());
		fullAddress = fullAddress.trim();
	}
	if(fullAddress.contains("길 ")){
		road_name = road_name + fullAddress.substring(0,fullAddress.indexOf("길 ")+1);
		fullAddress = fullAddress.substring(fullAddress.indexOf("길 ")+2,fullAddress.length());
		fullAddress = fullAddress.trim();
	}
	if(fullAddress.contains("거리 ")){
		road_name = road_name + fullAddress.substring(0,fullAddress.indexOf("거리 ")+1);
		fullAddress = fullAddress.substring(fullAddress.indexOf("거리 ")+2,fullAddress.length());
		fullAddress = fullAddress.trim();
	}
	if(fullAddress.contains("고개 ")){
		road_name = road_name + fullAddress.substring(0,fullAddress.indexOf("고개 ")+1);
		fullAddress = fullAddress.substring(fullAddress.indexOf("고개 ")+2,fullAddress.length());
		fullAddress = fullAddress.trim();
	}

	//공백없앰
	road_name = road_name.replace(" ","");

	String dong = ""; //동
	if(road_name == ""){
		if(fullAddress.contains("동 ")){
			dong = dong + fullAddress.substring(0,fullAddress.indexOf("동 ")+1);
			fullAddress = fullAddress.substring(fullAddress.indexOf("동 ")+2,fullAddress.length());
			fullAddress = fullAddress.trim();
		}
		if(fullAddress.contains("가 ")){
			dong = dong + fullAddress.substring(0,fullAddress.indexOf("가 ")+1);
			fullAddress = fullAddress.substring(fullAddress.indexOf("가 ")+2,fullAddress.length());
			fullAddress = fullAddress.trim();
		}
	}

	String ri = ""; //리
	if(fullAddress.contains("리 ")){
		ri = ri + fullAddress.substring(0,fullAddress.indexOf("리 ")+1);
		fullAddress = fullAddress.substring(fullAddress.indexOf("리 ")+2,fullAddress.length());
		fullAddress = fullAddress.trim();
	}

	String number_mapping = "";
	String jibun = ""; //지번
	String bdno = ""; //건물번호

	//우선적으로 필요없는 주소정보 삭제
	String regex = "( |^)[0-9]{1,}( |)~( |)[0-9]{1,} ";
	Pattern pattern = Pattern.compile(regex);
	Matcher match = pattern.matcher(fullAddress);

    if ( match.find() ) {
    	fullAddress = fullAddress.replace(match.group(),"");
		fullAddress = fullAddress.trim();
    }

    regex = "^[0-9]{1,}-[0-9]{1,}( |,|$)";
    pattern = Pattern.compile(regex);
    match = pattern.matcher(fullAddress);
	// 일치하는 값을 찾을 경우 true 반환
    if ( match.find() ) {
    	number_mapping = match.group();
    	number_mapping = number_mapping.trim();
    	number_mapping = number_mapping.replace(",","");
    	fullAddress = fullAddress.replace(match.group(),"");
		fullAddress = fullAddress.trim();
    }

	regex = "^[0-9]{1,}의[0-9]{1,}( |,|$)";
    pattern = Pattern.compile(regex);
    match = pattern.matcher(fullAddress);
	// 일치하는 값을 찾을 경우 true 반환
    if ( match.find() ) {
    	number_mapping = match.group();
    	number_mapping = number_mapping.trim();
    	number_mapping = number_mapping.replace("의","-");
    	number_mapping = number_mapping.replace(",","");
    	fullAddress = fullAddress.replace(match.group(),"");
		fullAddress = fullAddress.trim();
    }

    regex = "[0-9]{1,}( |,|$)";
    pattern = Pattern.compile(regex);
    match = pattern.matcher(fullAddress);
	// 일치하는 값을 찾을 경우 true 반환
    if ( match.find() ) {
    	number_mapping = match.group();
    	number_mapping = number_mapping.trim();
    	number_mapping = number_mapping.replace(",","");
    	fullAddress = fullAddress.replace(match.group(),"");
		fullAddress = fullAddress.trim();
    }

	if(road_name.equals("")){
		jibun = number_mapping;
	}else{
		bdno = number_mapping;
	}

	String dongho = "";
    regex = "( |,)[0-9가-힣A-Za-z]{1,}동( |)[0-9]{1,}호$";
    pattern = Pattern.compile(regex);
    match = pattern.matcher(fullAddress);
	// 일치하는 값을 찾을 경우 true 반환
    if ( match.find() ) {
    	dongho = match.group().replace(",","");
    	dongho = dongho.trim();
    	fullAddress = fullAddress.replace(match.group(),"");
    	fullAddress = fullAddress.trim();
    }

    regex = "( |,)[0-9가-힣A-Za-z]{1,}-[0-9]{1,}(호|)$";
    pattern = Pattern.compile(regex);
    match = pattern.matcher(fullAddress);
	// 일치하는 값을 찾을 경우 true 반환
    if ( match.find() ) {
    	dongho = match.group();
    	dongho = dongho.trim();
    	fullAddress = fullAddress.replace(match.group(),"");
		fullAddress = fullAddress.trim();
    }

    regex = "(^| |,)[0-9]{1,}층$";
    pattern = Pattern.compile(regex);
    match = pattern.matcher(fullAddress);
	// 일치하는 값을 찾을 경우 true 반환
    if ( match.find() ) {
    	dongho = match.group();
    	dongho = dongho.trim();
    	fullAddress = fullAddress.replace(match.group(),"");
		fullAddress = fullAddress.trim();
    }

	regex = "(^| |,|)[0-9A-Za-z]{1,}호$";
    pattern = Pattern.compile(regex);
    match = pattern.matcher(fullAddress);
	// 일치하는 값을 찾을 경우 true 반환
    if ( match.find() ) {
    	dongho = match.group();
    	dongho = dongho.trim();
    	fullAddress = fullAddress.replace(match.group(),"");
		fullAddress = fullAddress.trim();
    }

	String add_info = "";
    //도로명주소의 괄호안
    regex = "\\(.*\\)";
    pattern = Pattern.compile(regex);
    match = pattern.matcher(fullAddress);
	// 일치하는 값을 찾을 경우 true 반환
    if ( match.find() ) {
    	add_info = match.group();
    	add_info = add_info.trim();
    	add_info = add_info.replace("(","").replace(")","");
    	fullAddress = fullAddress.replace(match.group(),"");
		fullAddress = fullAddress.trim();
    }

    regex = "^.*(동|가|로|읍|면)(| |,)(,|)";
    pattern = Pattern.compile(regex);
    match = pattern.matcher(add_info);
	// 일치하는 값을 찾을 경우 true 반환
    if ( match.find() ) {
    	if(dong == ""){
        	dong = match.group();
        	dong = dong.trim();
        	dong = dong.replace(",","");
        	add_info = add_info.replace(match.group(),"");
        	add_info = add_info.trim();
    	}
    }

	fullAddress += add_info;

	String jibun_m = "";
	String jibun_s = "";
	if(jibun != ""){
		if(jibun.contains("-")){
			jibun_m = jibun.substring(0,jibun.indexOf("-"));
			jibun_s = jibun.substring(jibun.indexOf("-")+1,jibun.length());
		}else{
			jibun_m = jibun;
		}
	}

	String bdno_m = "";
	String bdno_s = "";
	if(bdno != ""){
		if(bdno.contains("-")){
			bdno_m = bdno.substring(0,bdno.indexOf("-"));
			bdno_s = bdno.substring(bdno.indexOf("-")+1,bdno.length());
		}else{
			bdno_m = bdno;
		}

	}

	//공백없앰
	fullAddress = fullAddress.replace(" ","");

	cm.put("sido",sido);
	cm.put("sigungu",sigungu);
	cm.put("upmyon",upmyon);
	cm.put("road_name",road_name);
	cm.put("bdno_m",bdno_m);
	cm.put("bdno_s",bdno_s);
	cm.put("dong",dong);
	cm.put("ri",ri);
	cm.put("jibun_m",jibun_m);
	cm.put("jibun_s",jibun_s);
	cm.put("dongho",dongho);
	cm.put("remain_address",fullAddress);

	return cm;
}
//변환주소 조회
public List getAddressMappingList(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);

	String fullAddress = pm.get("selectAddr").toString();

	Map cm = parseAddressList(fullAddress);
	pm.put("sido",cm.get("sido"));
	pm.put("sigungu",cm.get("sigungu"));
	pm.put("upmyon",cm.get("upmyon"));
	pm.put("road_name",cm.get("road_name"));
	pm.put("bdno_m",cm.get("bdno_m"));
	pm.put("bdno_s",cm.get("bdno_s"));
	pm.put("dong",cm.get("dong"));
	pm.put("ri",cm.get("ri"));
	pm.put("jibun_m",cm.get("jibun_m"));
	pm.put("jibun_s",cm.get("jibun_s"));
	pm.put("dongho",cm.get("dongho"));
	pm.put("remain_address",cm.get("remain_address"));

	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getAddressMappingList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}
//일괄변환주소 조회
public Map getSelectAddressMapping(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map map = null;

	String fullAddress = (String)pm.get("addr1");

	Map cm = parseAddressList(fullAddress);
	pm.put("sido",cm.get("sido"));
	pm.put("sigungu",cm.get("sigungu"));
	pm.put("upmyon",cm.get("upmyon"));
	pm.put("road_name",cm.get("road_name"));
	pm.put("bdno_m",cm.get("bdno_m"));
	pm.put("bdno_s",cm.get("bdno_s"));
	pm.put("dong",cm.get("dong"));
	pm.put("ri",cm.get("ri"));
	pm.put("jibun_m",cm.get("jibun_m"));
	pm.put("jibun_s",cm.get("jibun_s"));
	pm.put("dongho",cm.get("dongho"));
	pm.put("remain_address",cm.get("remain_address"));

	try{
		//쿼리 실행및 결과 받기.
		map  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getSelectAddressMapping",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return map;
}
%>

<%
	//쿼리 맵 셋팅
	Map queryMap = setQueryMap(xmlPath+"/address.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("getChkChgAddressMap".equals(cmd)) {
		//주소변경 대상여부 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = getChkChgAddressMap(xmlPath+"/address.xml", mp);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (Map)mapData);
		out.print((new org.json.JSONObject(rstMap)).toString() );

	} else 	if("getChgAddressPopupList".equals(cmd)) {
		//변경대상 주소 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = getChgAddressPopupList(mp, queryMap);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString() );

	} else 	if("getAddressList".equals(cmd)) {
		//주소 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = getAddressList(mp, queryMap);

		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString() );


	} else 	if("getAddressMappingList".equals(cmd)) {
		//주소 조회

		Map mp = StringUtil.getRequestMap(request);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = getAddressMappingList(mp, queryMap);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString() );
	} else if("saveChgAddress".equals(cmd)) {
		//임직원 주소변경 저장

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);

		String message = "";
		String code = "1";

		try {

			int cnt = saveChgAddress(mp, queryMap);

			if(cnt > 0) {
				message = "저장되었습니다.";
			} else {
				code = "-1";
				message = "저장된 내용이 없습니다.";
			}

		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);

		out.print((new org.json.JSONObject(rstMap)).toString() );
	} else if("saveAddressChgStatus".equals(cmd)) {
		//주소변경관리 저장

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);

		String message = "";
		String code = "1";

		try {

			int cnt = saveAddressChgStatus(mp, queryMap);

			if(cnt > 0) {
				message = "저장되었습니다.";
			} else {
				code = "-1";
				message = "저장된 내용이 없습니다.";
			}

		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);

		out.print((new org.json.JSONObject(rstMap)).toString() );
	} else if("saveUploadAddressChgStatus".equals(cmd)) {
		//업로드 주소변경관리 저장

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);

		String message = "";
		String code = "1";

		try {

			int cnt = saveUploadAddressChgStatus(mp, queryMap);

			if(cnt > 0) {
				message = "반영되었습니다.";
			} else {
				code = "-1";
				message = "반영된 내용이 없습니다.";
			}

		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);

		out.print((new org.json.JSONObject(rstMap)).toString() );
	} else if("getSelectAddressMapping".equals(cmd)) {
		//주소변경 대상여부 조회
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);

		Map cm =  StringUtil.getParamMapData(mp);
		String selectRow = cm.get("selectRow").toString();

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = getSelectAddressMapping(mp, queryMap);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (Map)mapData);
		rstMap.put("selectRow", selectRow);

		out.print((new org.json.JSONObject(rstMap)).toString() );

	}
%>