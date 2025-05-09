<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="yjungsan.util.DBConn"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="com.hr.common.logger.Log" %>
<%
//	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
//	setYeaLogYn(ssnYeaLogYn);
%>
<%!
//String ssnYeaLogYn = "";
//로그사용여부값 세팅
//public void setYeaLogYn(String param){
//	ssnYeaLogYn = param;
//}
// param null check
public int chkNull(String param) throws Exception{
	int cnt = 0;
    if(param != null && param.length() > 0){
    	cnt = 1;
    }
    return cnt;
}
// 로그 저장
public void saveLog(Connection con, Map mp, String ssnYeaLogYn) throws Exception{
	Map<String, String> mp2 = new HashMap<String, String>(mp);

    PreparedStatement ps = null;
    ResultSet rs = null;
    Boolean conFlag = false;

    int chkCnt = 0;
    String logYn = "";
    String sStatus    = "";
    String menuNm     = "";
    String workYy     = "";
    String ssnGrpNm   = "";
    String SearchType = "";
    String sabunStr   = "";

	if(con == null){
		//조회
	    con = DBConn.getConnection();
	    conFlag = true;
	}else{
		conFlag = false;
	}

    //사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기(조회)
    if(chkCnt == 0 && con != null){
		chkCnt++;
	    try{
		    if("Y".equals(ssnYeaLogYn) &&  ssnYeaLogYn.length() > 0 && chkCnt > 0){
			    //화면명 조회
			    menuNm = mp2.get("menuNm");
			    mp2.remove("menuNm");
		        //대상년월
		        String pWorkYy    = "";
		        if(mp2.containsKey("srchYear")     || mp2.containsKey("searchYear")      || mp2.containsKey("srchWorkYy")
		        || mp2.containsKey("searchWorkYy") || mp2.containsKey("searchStdWorkYy") || mp2.containsKey("searchWorkYear")
		        || mp2.containsKey("srchYm")       || mp2.containsKey("work_yy")         || mp2.containsKey("pay_ym")){

		            if(chkNull(mp2.get("srchYear")       ) > 0) pWorkYy = mp2.get("srchYear");
		            if(chkNull(mp2.get("searchYear")     ) > 0) pWorkYy = mp2.get("searchYear");
		            if(chkNull(mp2.get("srchWorkYy")     ) > 0) pWorkYy = mp2.get("srchWorkYy");
		            if(chkNull(mp2.get("searchWorkYy")   ) > 0) pWorkYy = mp2.get("searchWorkYy");
		            if(chkNull(mp2.get("searchStdWorkYy")) > 0) pWorkYy = mp2.get("searchStdWorkYy");
		            if(chkNull(mp2.get("searchWorkYear") ) > 0) pWorkYy = mp2.get("searchWorkYear");
		            if(chkNull(mp2.get("srchYm")         ) > 0) pWorkYy = mp2.get("srchYm");
		            if(chkNull(mp2.get("work_yy")        ) > 0) pWorkYy = mp2.get("work_yy");
		            if(chkNull(mp2.get("pay_ym")         ) > 0) pWorkYy = mp2.get("pay_ym");
		            pWorkYy = pWorkYy.substring(0, 4);
		        }

		        //권한그룹,범위 조회
		        if(chkNull(mp2.get("ssnGrpCd")) > 0 || chkNull(mp2.get("ssnSearchType")) > 0){
		            try{
		                ps = con.prepareStatement("SELECT GRP_CD, GRP_NM"
		                                       + " FROM TSYS307"
		                                       + " WHERE ENTER_CD = '"+mp2.get("ssnEnterCd")+"'"
		                                       + "   AND GRP_CD = '"+mp2.get("ssnGrpCd")+"'"
		                                       + "   AND SEARCH_TYPE = '"+mp2.get("ssnSearchType")+"'" );
		                rs = ps.executeQuery();
		                while(rs.next()) {
		                    ssnGrpNm = rs.getString(2);
		                }
		                if(ssnGrpNm != null && ssnGrpNm.length() > 0){
		                    if(mp2.containsKey("ssnGrpCd")){
		                        mp2.put("권한그룹", ssnGrpNm);
		                    }
		                }
		            } catch(Exception e){
		                throw new Exception();
		            } finally {
		                DBConn.closeConnection(null, ps, rs);
		            }
		        }
		        mp2.remove("ssnGrpCd");

		        //전사:A, 자신만조회:P, 권한범위적용:O
		        if(chkNull(mp2.get("ssnSearchType")) > 0) {
		            if(mp2.get("ssnSearchType").equals("A")){
		                mp2.put("권한범위" ,"전사");
		            }else if(mp2.get("ssnSearchType").equals("O")){
		                mp2.put("권한범위" ,"권한범위적용");
		            }else{
		                mp2.put("권한범위" ,"자신만조회");
		            }
		        }
		        mp2.remove("ssnSearchType");

			   //사업장
			   String bizPlaceCd = "";
			   String bizPlaceNm = "";
			   if(mp2.containsKey("srchBizPlaceCd")    || mp2.containsKey("searchBizPlaceCd")      || mp2.containsKey("searchStdBpCd") || mp2.containsKey("biz_place_cd")
		        || mp2.containsKey("searchBusinessCd") || mp2.containsKey("std_bp_cd")             || mp2.containsKey("chg_bp_cd")
			    || mp2.containsKey("searchChgBpCd")    || mp2.containsKey("searchBusinessPlaceCd") || mp2.containsKey("business_place_cd")){

			    	if(chkNull(mp2.get("srchBizPlaceCd"))        > 0) bizPlaceCd = mp2.get("srchBizPlaceCd");
			        if(chkNull(mp2.get("searchBizPlaceCd"))      > 0) bizPlaceCd = mp2.get("searchBizPlaceCd");
			        if(chkNull(mp2.get("searchStdBpCd"))         > 0) bizPlaceCd = mp2.get("searchStdBpCd");
			        if(chkNull(mp2.get("searchChgBpCd"))         > 0) bizPlaceCd = mp2.get("searchChgBpCd");
			        if(chkNull(mp2.get("searchBusinessPlaceCd")) > 0) bizPlaceCd = mp2.get("searchBusinessPlaceCd");
			        if(chkNull(mp2.get("business_place_cd"))     > 0) bizPlaceCd = mp2.get("business_place_cd");
			        if(chkNull(mp2.get("searchBusinessCd"))      > 0) bizPlaceCd = mp2.get("searchBusinessCd");
			        if(chkNull(mp2.get("std_bp_cd"))             > 0) bizPlaceCd = mp2.get("std_bp_cd");
			        if(chkNull(mp2.get("chg_bp_cd"))             > 0) bizPlaceCd = mp2.get("chg_bp_cd");
			        if(chkNull(mp2.get("biz_place_cd"))          > 0) bizPlaceCd = mp2.get("biz_place_cd");

			        if(chkNull(bizPlaceCd) > 0){
				        try{
					        ps = con.prepareStatement("SELECT X.BUSINESS_PLACE_CD AS CODE, X.BUSINESS_PLACE_NM AS CODE_NM"
					                               + " FROM TCPN121 X"
					                               + " WHERE X.ENTER_CD = '"+mp2.get("ssnEnterCd")+"'"
					                               + "   AND X.BUSINESS_PLACE_CD = '"+bizPlaceCd+"'"
					                               + "   AND X.SDATE = (SELECT MAX(Y.SDATE) FROM TCPN121 Y"
					                               + "                  WHERE Y.ENTER_CD = X.ENTER_CD"
					                               + "                    AND Y.BUSINESS_PLACE_CD = X.BUSINESS_PLACE_CD"
					                               + "                    AND "+pWorkYy+"1231"+" BETWEEN Y.SDATE AND NVL(Y.EDATE,'99991231')) ORDER BY 1");
					        rs = ps.executeQuery();
					        while(rs.next()) {
					        	bizPlaceCd = rs.getString(1);
					        	bizPlaceNm = rs.getString(2);
					        }
					        if(bizPlaceNm != null && bizPlaceNm.length() > 0){
					            if(mp2.containsKey("srchBizPlaceCd"))          mp2.put("사업장"   , bizPlaceNm);
				                if(mp2.containsKey("searchBizPlaceCd"))        mp2.put("사업장"   , bizPlaceNm);
				                if(mp2.containsKey("searchBusinessPlaceCd"))   mp2.put("사업장"   , bizPlaceNm);
				                if(mp2.containsKey("business_place_cd"))       mp2.put("사업장"   , bizPlaceNm);
				                if(mp2.containsKey("searchStdBpCd"))           mp2.put("기존사업장", bizPlaceNm);
				                if(mp2.containsKey("searchChgBpCd"))           mp2.put("변경사업장", bizPlaceNm);
			                    if(mp2.containsKey("searchBusinessCd"))        mp2.put("사업장"   , bizPlaceNm);
			                    if(mp2.containsKey("std_bp_cd"))               mp2.put("기존사업장", bizPlaceNm);
			                    if(mp2.containsKey("chg_bp_cd"))               mp2.put("변경사업장", bizPlaceNm);
			                    if(mp2.containsKey("biz_place_cd"))            mp2.put("사업장"   , bizPlaceNm);
					        }else{
					            if(mp2.containsKey("srchBizPlaceCd"))          mp2.put("사업장"   , "전체");
					            if(mp2.containsKey("searchBizPlaceCd"))        mp2.put("사업장"   , "전체");
					            if(mp2.containsKey("searchBusinessPlaceCd"))   mp2.put("사업장"   , "전체");
					            if(mp2.containsKey("business_place_cd"))       mp2.put("사업장"   , "전체");
					            if(mp2.containsKey("searchStdBpCd"))           mp2.put("기존사업장", "전체");
					            if(mp2.containsKey("searchChgBpCd"))           mp2.put("변경사업장", "전체");
					            if(mp2.containsKey("searchBusinessCd"))        mp2.put("사업장"   , "전체");
					            if(mp2.containsKey("std_bp_cd"))               mp2.put("기존사업장", "전체");
			                    if(mp2.containsKey("chg_bp_cd"))               mp2.put("변경사업장", "전체");
			                    if(mp2.containsKey("biz_place_cd"))            mp2.put("사업장"   , "전체");
					        }
					    } catch(Exception e){
					        throw new Exception();
					    } finally {
					        DBConn.closeConnection(null, ps, rs);
					    }
			        }
			    }
			    mp2.remove("srchBizPlaceCd");
			    mp2.remove("searchBizPlaceCd");
			    mp2.remove("searchBusinessPlaceCd");
			    mp2.remove("business_place_cd");
			    mp2.remove("searchStdBpCd");
			    mp2.remove("searchChgBpCd");
			    mp2.remove("searchBusinessCd");
			    mp2.remove("chg_bp_cd");
			    mp2.remove("std_bp_cd");
			    mp2.remove("biz_place_cd");

			    //정산항목,소득구분코드
			    String adjElCd = "";
			    String adjElNm = "";

			    if(mp2.containsKey("adj_element_cd") || mp2.containsKey("srchIncomeType") || mp2.containsKey("searchAdjElementCd")){
	                if(chkNull(mp2.get("adj_element_cd"))     > 0) adjElCd = mp2.get("adj_element_cd");
	                if(chkNull(mp2.get("srchIncomeType"))     > 0) adjElCd = mp2.get("srchIncomeType");
	                if(chkNull(mp2.get("searchAdjElementCd")) > 0) adjElCd = mp2.get("searchAdjElementCd");

	                if(chkNull(adjElCd) > 0){
				    	try{
				            ps = con.prepareStatement("SELECT ADJ_ELEMENT_CD,ADJ_ELEMENT_NM"
				                                   + " FROM TCPN803"
				                                   + " WHERE ENTER_CD = '"+mp.get("ssnEnterCd")+"'"
				                                   + "   AND WORK_YY  = '"+pWorkYy+"'"
				                                   + "   AND ADJ_ELEMENT_CD = '"+adjElCd+"'");
				            rs = ps.executeQuery();

				            while(rs.next()) {
				            	adjElNm = rs.getString(2);
				            }
				            if(adjElNm != null && adjElNm.length() > 0){
					            if(mp2.containsKey("adj_element_cd"))     mp2.put("정산항목", adjElNm);
					            if(mp2.containsKey("srchIncomeType"))     mp2.put("소득구분", adjElNm);
				                if(mp2.containsKey("searchAdjElementCd")) mp2.put("소득구분", adjElNm);
				            }
				        } catch(Exception e){
				            throw new Exception();
				        } finally {
				            DBConn.closeConnection(null, ps, rs);
				        }
	                }
			    }
			    mp2.remove("adj_element_cd");
			    mp2.remove("srchIncomeType");
			    mp2.remove("searchAdjElementCd");

			    //기부금종류
			    String contrbtCd = "";
			    String contrbtNm = "";
			    if(mp2.containsKey("contribution_cd")){
			        try{
			            if(chkNull(mp2.get("contribution_cd")) > 0) contrbtCd = mp2.get("contribution_cd");

			            ps = con.prepareStatement("SELECT CODE, CODE_NM"
			                                   + " FROM TSYS005"
			                                   + " WHERE ENTER_CD = '"+mp2.get("ssnEnterCd")+"'"
			                                   + "   AND CODE     = '" + contrbtCd+"'"
			                                   + "   AND GRCODE_CD = trim( 'C00307') "
			                                   + "   AND "+pWorkYy+"1231"+" BETWEEN S_YMD AND E_YMD ");
			            rs = ps.executeQuery();

			            while(rs.next()) {
			            	contrbtNm = rs.getString(2);
			            }
			            if(contrbtNm != null && contrbtNm.length() > 0){
			                if(mp2.containsKey("contribution_cd")) mp2.put("기부금종류", contrbtNm);
			            }
			        } catch(Exception e){
			            throw new Exception();
			        } finally {
			            DBConn.closeConnection(null, ps, rs);
			        }
			    }
			    mp2.remove("contribution_cd");

			    //자료입력유형
			    String inputTyCd = "";
			    String inputTyNm = "";
			    if(mp2.containsKey("searchInputType")){
			        try{
			            if(chkNull(mp2.get("searchInputType")) > 0) inputTyCd = mp2.get("searchInputType");

			            ps = con.prepareStatement("SELECT CODE, CODE_NM"
			                                   + " FROM TSYS005"
			                                   + " WHERE ENTER_CD = '"+mp2.get("ssnEnterCd")+"'"
			                                   + "   AND CODE = '"+ inputTyCd+ "'"
			                                   + "   AND GRCODE_CD = trim( 'C00325') "
			                                   + "   AND "+pWorkYy+"1231"+" BETWEEN S_YMD AND E_YMD ");
			            rs = ps.executeQuery();

			            while(rs.next()) {
			            	inputTyNm = rs.getString(2);
			            }
			            if(inputTyNm != null && inputTyNm.length() > 0){
			                if(mp2.containsKey("searchInputType")) mp2.put("자료입력유형", inputTyNm);
			            }
			        } catch(Exception e){
			            throw new Exception();
			        } finally {
			            DBConn.closeConnection(null, ps, rs);
			        }
			    } mp2.remove("searchInputType");

			    //저축구분
			    String saveDcTyCd = "";
			    String saveDcTyNm = "";
			    if(mp2.containsKey("searchSavingDeductType")){
			        try{
			            if(chkNull(mp2.get("searchSavingDeductType")) > 0) saveDcTyCd = mp2.get("searchSavingDeductType");

			            ps = con.prepareStatement("SELECT CODE, CODE_NM"
			                                   + " FROM TSYS005"
			                                   + " WHERE ENTER_CD = '"+mp2.get("ssnEnterCd")+"'"
			                                   + "   AND NOTE1 IN ('3', '4')"
			                                   + "   AND CODE = '"+ saveDcTyCd+ "'"
			                                   + "   AND GRCODE_CD = trim( 'C00317') "
			                                   + "   AND "+pWorkYy+"1231"+" BETWEEN S_YMD AND E_YMD ");
			            rs = ps.executeQuery();

			            while(rs.next()) {
			            	saveDcTyNm = rs.getString(2);
			            }
			            if(saveDcTyNm != null && saveDcTyNm.length() > 0){
			                if(mp2.containsKey("searchSavingDeductType")){
			                    mp2.put("저축구분", saveDcTyNm);
			                }
			            }
			        } catch(Exception e){
			            throw new Exception();
			        } finally {
			            DBConn.closeConnection(null, ps, rs);
			        }
			    } mp2.remove("searchSavingDeductType");

			    //담당자확인
			    String successTyCd = "";
			    String successTyNm = "";
			    if(mp2.containsKey("searchSuccessType") || mp2.containsKey("searchFeedBackType")){
	                if(chkNull(mp2.get("searchSuccessType")) > 0)  successTyCd = mp2.get("searchSuccessType");
	                if(chkNull(mp2.get("searchFeedBackType")) > 0) successTyCd = mp2.get("searchFeedBackType");

	                if(chkNull(successTyCd) > 0){
				    	try{
				            ps = con.prepareStatement("SELECT CODE, CODE_NM"
				                                   + " FROM TSYS005"
				                                   + " WHERE ENTER_CD = '"+mp2.get("ssnEnterCd")+"'"
				                                   + "   AND CODE = '"+ successTyCd+ "'"
				                                   + "   AND GRCODE_CD = trim( 'C00329') "
				                                   + "   AND "+pWorkYy+"1231"+" BETWEEN S_YMD AND E_YMD ");
				            rs = ps.executeQuery();

				            while(rs.next()) {
				            	successTyNm = rs.getString(2);
				            }
				            if(successTyNm != null && successTyNm.length() > 0){
				                if(mp2.containsKey("searchSuccessType")) mp2.put("담당자확인", successTyNm);
				                if(mp2.containsKey("searchFeedBackType")) mp2.put("담당자확인", successTyNm);
				            }
				        } catch(Exception e){
				            throw new Exception();
				        } finally {
				            DBConn.closeConnection(null, ps, rs);
				        }
	                }
			    } mp2.remove("searchSuccessType");mp2.remove("searchFeedBackType");

			    //파일구분
			    String fileTyCd = "";
			    String fileTyNm = "";
			    if(mp2.containsKey("searchFileType") || mp2.containsKey("searchFileType1")){
	                if(chkNull(mp2.get("searchFileType"))  > 0) fileTyCd = mp2.get("searchFileType");
	                if(chkNull(mp2.get("searchFileType1")) > 0) fileTyCd = mp2.get("searchFileType1");

	                if(chkNull(fileTyCd) > 0){
				    	try{
				            ps = con.prepareStatement("SELECT CODE, CODE_NM"
				                                   + " FROM TSYS005"
				                                   + " WHERE ENTER_CD = '"+mp2.get("ssnEnterCd")+"'"
				                                   + "   AND CODE = '"+ fileTyCd+ "'"
				                                   + "   AND GRCODE_CD = trim( 'YEA001') "
				                                   + "   AND "+pWorkYy+"1231"+" BETWEEN S_YMD AND E_YMD ");
				            rs = ps.executeQuery();

				            while(rs.next()) {
				            	fileTyNm = rs.getString(2);
				            }
				            if(fileTyNm != null && fileTyNm.length() > 0){
				                if(mp2.containsKey("searchFileType"))  mp2.put("파일구분", fileTyNm);
				                if(mp2.containsKey("searchFileType1")) mp2.put("파일구분", fileTyNm);
				            }
				        } catch(Exception e){
				            throw new Exception();
				        } finally {
				            DBConn.closeConnection(null, ps, rs);
				        }
	                }
			    }
			    mp2.remove("searchFileType");
			    mp2.remove("searchFileType1");

			    //교육대상구분
			    String srhWorkTyCd = "";
			    String srhWorkTyNm = "";
			    if(mp2.containsKey("searchWorkType")){
	                if(chkNull(mp2.get("searchWorkType")) > 0) srhWorkTyCd = mp2.get("searchWorkType");
			    	try{
			            ps = con.prepareStatement("SELECT CODE, CODE_NM"
			                                   + " FROM TSYS005"
			                                   + " WHERE ENTER_CD = '"+mp2.get("ssnEnterCd")+"'"
			                                   + "   AND CODE = '"+ srhWorkTyCd+ "'"
			                                   + "   AND GRCODE_CD = trim( 'C00313') "
			                                   + "   AND "+pWorkYy+"1231"+" BETWEEN S_YMD AND E_YMD ");
			            rs = ps.executeQuery();

			            while(rs.next()) {
			            	srhWorkTyNm = rs.getString(2);
			            }
			            if(srhWorkTyNm != null && srhWorkTyNm.length() > 0){
			                if(mp2.containsKey("searchWorkType")) mp2.put("교육대상구분", srhWorkTyNm);
			            }
			        } catch(Exception e){
			            throw new Exception();
			        } finally {
			            DBConn.closeConnection(null, ps, rs);
			        }
			    } mp2.remove("searchWorkType");

			    // 세율 코드 tax_rate_cd
		        String srhTaxRateCd = "";
		        String srhTaxRateNm = "";
		        if(mp2.containsKey("tax_rate_cd")){
	                if(chkNull(mp2.get("tax_rate_cd")) > 0) srhTaxRateCd = mp2.get("tax_rate_cd");
		        	try{
		                ps = con.prepareStatement("SELECT TAX_RATE_CD AS CODE, TAX_RATE_NM AS CODE_NM"
		                                       + " FROM TCPN501"
		                                       + " WHERE ENTER_CD = '"+mp2.get("ssnEnterCd")+"'"
		                                       + "   AND WORK_YY  = '"+pWorkYy+"'"
		                                       + "   AND TAX_RATE_CD = '"+ srhTaxRateCd+ "'");
		                rs = ps.executeQuery();

		                while(rs.next()) {
		                	srhTaxRateNm = rs.getString(2);
		                }
		                if(srhTaxRateNm != null && srhTaxRateNm.length() > 0){
		                    if(mp2.containsKey("tax_rate_cd")) mp2.put("세율", srhTaxRateNm);
		                }
		            } catch(Exception e){
		                throw new Exception();
		            } finally {
		                DBConn.closeConnection(null, ps, rs);
		            }
		        } mp2.remove("tax_rate_cd");

			    //거주지국코드
			    String residencyCd = "";
			    String residencyNm = "";
			    String residencyCd2 = "";
			    String residencyNm2 = "";
			    if(mp2.containsKey("residency_cd") || mp2.containsKey("national_cd")){
			        try{
			            if(chkNull(mp2.get("residency_cd")) > 0){
			            	residencyCd = mp2.get("residency_cd");

			                ps = con.prepareStatement("SELECT CODE, CODE_NM"
			                                       + " FROM TSYS005"
			                                       + " WHERE ENTER_CD = '"+mp2.get("ssnEnterCd")+"'"
			                                       + "   AND CODE = '"+ residencyCd+ "'"
			                                       + "   AND GRCODE_CD = trim( 'H20295') "
			                                       + "   AND "+pWorkYy+"1231"+" BETWEEN S_YMD AND E_YMD ");
			                rs = ps.executeQuery();

			                while(rs.next()) {
			                    residencyNm = rs.getString(2);
			                }
			                if(residencyNm != null && residencyNm.length() > 0){
			                    if(mp2.containsKey("residency_cd")) mp2.put("거주지국코드", residencyNm);
			                }
			            }
			            if(chkNull(mp2.get("national_cd")) > 0){
			                residencyCd2 = mp2.get("national_cd");

			                ps = con.prepareStatement("SELECT CODE, CODE_NM"
			                                       + " FROM TSYS005"
			                                       + " WHERE ENTER_CD = '"+mp2.get("ssnEnterCd")+"'"
			                                       + "   AND CODE = '"+ residencyCd2+ "'"
			                                       + "   AND GRCODE_CD = trim( 'H20295') "
			                                       + "   AND "+pWorkYy+"1231"+" BETWEEN S_YMD AND E_YMD ");
			                rs = ps.executeQuery();

			                while(rs.next()) {
			                    residencyNm2 = rs.getString(2);
			                }
			                if(residencyNm2 != null && residencyNm2.length() > 0){
			                    if(mp2.containsKey("national_cd")) mp2.put("국적코드", residencyNm2);
			                }
			            }

			        } catch(Exception e){
			            throw new Exception();
			        } finally {
			            DBConn.closeConnection(null, ps, rs);
			        }
			    }
			    mp2.remove("residency_cd");
			    mp2.remove("national_cd");

			    // 주택자금공제구분코드
		        String houseDecCd = "";
		        String houseDecNm = "";
		        if(mp2.containsKey("house_dec_cd")){
		            try{
		                if(chkNull(mp2.get("house_dec_cd")) > 0) houseDecCd = mp2.get("house_dec_cd");

		                ps = con.prepareStatement("SELECT CODE, CODE_NM"
		                                       + " FROM TSYS005"
		                                       + " WHERE ENTER_CD = '"+mp2.get("ssnEnterCd")+"'"
		                                       + "  AND CODE = '"+houseDecCd+"'"
		                                       + "  AND GRCODE_CD = trim( 'C00344') "
		                                       + "   AND "+pWorkYy+"1231"+" BETWEEN S_YMD AND E_YMD ");
		                rs = ps.executeQuery();

		                while(rs.next()) {
		                	houseDecNm = rs.getString(2);
		                }
		                if(houseDecNm != null && houseDecNm.length() > 0){
		                    if(mp2.containsKey("house_dec_cd")) mp2.put("주택자금공제구분", houseDecNm);
		                }
		            } catch(Exception e){
		                throw new Exception();
		            } finally {
		                DBConn.closeConnection(null, ps, rs);
		            }
		        }
		        mp2.remove("codeType");
		        mp2.remove("house_dec_cd");

		        // 급여구분
		        String srchPayCd = "";
		        String srchPayNm = "";
		        if(mp2.containsKey("searchPayCd") || mp2.containsKey("pay_cd")){
	                if(chkNull(mp2.get("searchPayCd"))  > 0) srchPayCd = mp2.get("searchPayCd");
	                if(chkNull(mp2.get("pay_cd"))       > 0) srchPayCd = mp2.get("pay_cd");

	                if(srchPayCd.indexOf(",") < 0) srchPayCd = "'"+srchPayCd+"'";

	                if(chkNull(srchPayCd) > 0){
			        	try{
			                ps = con.prepareStatement("SELECT DISTINCT  PAY_CD AS CODE, PAY_NM AS CODE_NM"
			                                       + " FROM TCPN051"
			                                       + " WHERE ENTER_CD = '"+mp2.get("ssnEnterCd")+"'"
			                                       + "  AND F_CPN_YEA_PAY_CD('"+mp2.get("ssnEnterCd")+"', PAY_CD) IN ("+srchPayCd+")");
			                rs = ps.executeQuery();

			                while(rs.next()) {
			                	srchPayNm = rs.getString(2);
			                }
			                if(srchPayNm != null && srchPayNm.length() > 0){
			                    if(mp2.containsKey("searchPayCd"))  mp2.put("급여구분", srchPayNm);
			                    if(mp2.containsKey("pay_cd"))       mp2.put("급여구분", srchPayNm);
			                }
			            } catch(Exception e){
			                throw new Exception();
			            } finally {
			                DBConn.closeConnection(null, ps, rs);
			            }
	                }
		        }
		        mp2.remove("searchPayCd");
		        mp2.remove("pay_cd");

		        //연말정산 항목 작업구분
		        String eleWorkType = "";
		        if(mp2.containsKey("ele_work_type")){
		            if(chkNull(mp2.get("ele_work_type"))  > 0){
			        	try{
			                ps = con.prepareStatement("SELECT CODE, CODE_NM"
			                                       + " FROM TSYS005"
			                                       + " WHERE ENTER_CD = '"+mp2.get("ssnEnterCd")+"'"
			                                       + "  AND GRCODE_CD = trim( 'C00301') "
			                                       + "  AND CODE = '"+mp2.get("ele_work_type")+"'"
			                                       + "  AND "+pWorkYy+"1231"+" BETWEEN S_YMD AND E_YMD ");
			                rs = ps.executeQuery();
			                while(rs.next()) {
			                	eleWorkType = rs.getString(2);
			                }
			                if(eleWorkType != null && eleWorkType.length() > 0){
			                    if(mp2.containsKey("ele_work_type")) mp2.put("작업구분", eleWorkType);
			                }
			        	} catch(Exception e){
			                throw new Exception();
			            } finally {
			                DBConn.closeConnection(null, ps, rs);
			            }
		            }
		        }
		        mp2.remove("ele_work_type");

		        //주민번호
		        String resNo= "";
		        if(mp2.containsKey("searchRegNo") || mp2.containsKey("res_no")){
		        	if(chkNull(mp2.get("searchRegNo")) > 0) {
		        		resNo = mp2.get("searchRegNo");
		        		resNo = resNo.toString();
		        		resNo = resNo.substring(0, 6)+"******";
		                mp2.put("주민번호",resNo);
		        	}
		        	if(chkNull(mp2.get("res_no")) > 0) {
		        		resNo = mp2.get("res_no");
		                resNo = resNo.toString();
		                resNo = resNo.substring(0, 6)+"******";
		                mp2.put("본인주민번호",resNo);
		        	}
		        }
		        mp2.remove("searchRegNo");
		        mp2.remove("res_no");

		        //작업구분  (연말정산 :1, 퇴직정산: 3, 원천징수부: 9 -연간소득개별)
		        if(mp2.containsKey("srchAdjustType") || mp2.containsKey("searchAdjustType") || mp2.containsKey("adjust_type") ){

		        	if(chkNull(mp2.get("srchAdjustType")) > 0){
		        		if("1".equals(mp2.get("srchAdjustType"))) mp2.put("업무구분" , "연말정산");
		        		if("3".equals(mp2.get("srchAdjustType"))) mp2.put("업무구분" , "퇴직정산");
		        		if("9".equals(mp2.get("srchAdjustType"))) mp2.put("업무구분" , "원천징수부");
		        	}
		            if(chkNull(mp2.get("searchAdjustType")) > 0){
		                if("1".equals(mp2.get("searchAdjustType"))) mp2.put("업무구분" , "연말정산");
		                if("3".equals(mp2.get("searchAdjustType"))) mp2.put("업무구분" , "퇴직정산");
		                if("9".equals(mp2.get("searchAdjustType"))) mp2.put("업무구분" , "원천징수부");
		            }
		            if(chkNull(mp2.get("adjust_type")) > 0){
		                if("1".equals(mp2.get("adjust_type"))) mp2.put("업무구분" , "연말정산");
		                if("3".equals(mp2.get("adjust_type"))) mp2.put("업무구분" , "퇴직정산");
		                if("9".equals(mp2.get("adjust_type"))) mp2.put("업무구분" , "원천징수부");
		            }
		        }
		        mp2.remove("srchAdjustType"); mp2.remove("searchAdjustType"); mp2.remove("adjust_type");

			    //업무구분(PDF)
			    String formCd  = "";
			    if(mp2.containsKey("searchFormCd")){
			        if(chkNull(mp2.get("searchFormCd")) > 0) {
			        	formCd = mp2.get("searchFormCd");
			            if(formCd.equals("A102Y"))                    mp2.put("업무구분" , "보험료");
			            if(formCd.equals("B101Y"))                    mp2.put("업무구분" , "의료비");
			            if(formCd.equals("C102Y,C202Y,C301Y,C401Y"))  mp2.put("업무구분" , "교육비");
			            if(formCd.equals("G107Y"))                    mp2.put("업무구분" , "신용카드");
			            if(formCd.equals("G307Y"))                    mp2.put("업무구분" , "직불카드");
			            if(formCd.equals("G207M"))                    mp2.put("업무구분" , "현금영수증");
			            if(formCd.equals("G407Y"))                    mp2.put("업무구분" , "제로페이");
			            if(formCd.equals("E102Y,E101Y,F101Y,F102Y"))  mp2.put("업무구분" , "연금계좌");
			            if(formCd.equals("J101Y,J203Y,J401Y"))        mp2.put("업무구분" , "주택자금");
			            if(formCd.equals("D101Y,J301Y"))              mp2.put("업무구분" , "저축");
			            if(formCd.equals("N102Y,Q101Y,Q201Y"))        mp2.put("업무구분" , "장기집합투자증권저축/벤처기업투자신탁");
			            if(formCd.equals("K101M"))                    mp2.put("업무구분" , "소기업/소상공인 공제부금");
			            if(formCd.equals("L102Y"))                    mp2.put("업무구분" , "기부금");
			            if(formCd.equals("E103Y"))                    mp2.put("업무구분" , "연금저축");
			            if(formCd.equals("F103Y"))                    mp2.put("업무구분" , "퇴직연금");
                        if(formCd.equals("G112Y"))                    mp2.put("업무구분" , "신용카드");
                        if(formCd.equals("G212M"))                    mp2.put("업무구분" , "현금영수증");
                        if(formCd.equals("G312Y"))                    mp2.put("업무구분" , "직불카드");
                        if(formCd.equals("G412Y"))                    mp2.put("업무구분" , "제로페이");
                        if(formCd.equals("J501Y"))                    mp2.put("업무구분" , "월세액");
                        if(formCd.equals("O101M"))                    mp2.put("업무구분" , "건강보험료");
                        if(formCd.equals("P102M"))                    mp2.put("업무구분" , "국민연금보험료");
                        if(formCd.equals("Q301Y"))                    mp2.put("업무구분" , "벤처기업투자신탁");
                        if(formCd.equals("R101M"))                    mp2.put("업무구분" , "장애인 증명서");
                        if(formCd.equals("T101M"))                    mp2.put("업무구분" , "소득기준 초과 부양가족");
			        }
			    } mp2.remove("searchFormCd");

			    //신용카드구분
		        String cardType  = "";
		        if(mp2.containsKey("inputCardType")){
		            if(chkNull(mp2.get("inputCardType")) > 0) {
		            	cardType = mp2.get("inputCardType");
		            	if(cardType.equals("1"))                    mp2.put("신용카드 구분" , "신용카드");
		            	if(cardType.equals("2"))                    mp2.put("신용카드 구분" , "직불.기명식선불카드");
		            	if(cardType.equals("6"))                    mp2.put("신용카드 구분" , "직불.기명식선불카드(제로페이)");
		            	if(cardType.equals("7"))                    mp2.put("신용카드 구분" , "현금영수증");
		            	if(cardType.equals("61"))                   mp2.put("신용카드 구분" , "도서공연등사용분(신용카드)");
		            	if(cardType.equals("63"))                   mp2.put("신용카드 구분" , "도서공연등사용분(직불카드 등)");
		            	if(cardType.equals("65"))                   mp2.put("신용카드 구분" , "도서공연등사용분(현금영수증)");
		            	if(cardType.equals("67"))                   mp2.put("신용카드 구분" , "도서공연등사용분(제로페이)");
		            	if(cardType.equals("11"))                   mp2.put("신용카드 구분" , "전통시장사용분(신용카드)");
		            	if(cardType.equals("13"))                   mp2.put("신용카드 구분" , "전통시장사용분(직불카드,현금영수증)");
		            	if(cardType.equals("14"))                   mp2.put("신용카드 구분" , "전통시장사용분(제로페이)");
		                if(cardType.equals("15"))                   mp2.put("신용카드 구분" , "대중교통이용분(신용카드)");
		                if(cardType.equals("18"))                   mp2.put("신용카드 구분" , "대중교통이용분(제로페이)");
		                if(cardType.equals("17"))                   mp2.put("신용카드 구분" , "대중교통이용분(직불카드,현금영수증)");
		                if(cardType.equals("3"))                    mp2.put("신용카드 구분" , "사업관련비용(신용카드)");
		                if(cardType.equals("4"))                    mp2.put("신용카드 구분" , "사업관련비용(직불/선불카드)");
		                if(cardType.equals("35"))                   mp2.put("신용카드 구분" , "근로제공기간 이외 (본인) 신용카드등 사용액");
		            }
		        } mp2.remove("inputCardType");

		        //출력순서
		        String srchSort  = "";
		        if(mp2.containsKey("searchSort")){
		            if(chkNull(mp2.get("searchSort")) > 0) {
		            	srchSort = mp2.get("searchSort");
		                if(srchSort.equals("1"))                 mp2.put("출력순서" , "성명순");
		                if(srchSort.equals("2"))                 mp2.put("출력순서" , "사번순");
		                if(srchSort.equals("3"))                 mp2.put("출력순서" , "부서순");
		            }
		        } mp2.remove("searchSort");

		        //출력종류
		        String mrdType  = "";
		        if(mp2.containsKey("searchMrdType")){
		            if(chkNull(mp2.get("searchMrdType")) > 0) {
		            	mrdType = mp2.get("searchMrdType");
		                if(mrdType.equals("INCOME"))               mp2.put("출력종류" , "소득공제서");
		                if(mrdType.equals("CARD"))                 mp2.put("출력종류" , "신용카드등");
		                if(mrdType.equals("DONATION"))             mp2.put("출력종류" , "기부금명세서");
		                if(mrdType.equals("MEDICAL"))              mp2.put("출력종류" , "의료비명세서");
		            }
		        } mp2.remove("searchMrdType");

		        //자료구분(담당자feedback)
		        String inputCardType  = "";
		        if(mp2.containsKey("searchGubunCd")){
		            if(chkNull(mp2.get("searchGubunCd")) > 0) {
		            	inputCardType = mp2.get("searchGubunCd");
		                if(inputCardType.equals("COMM"))                 mp2.put("자료구분" , "일반");
		                if(inputCardType.equals("PENS"))                 mp2.put("자료구분" , "연금보험료");
		                if(inputCardType.equals("INSU"))                 mp2.put("자료구분" , "보험료");
		                if(inputCardType.equals("MEDI"))                 mp2.put("자료구분" , "의료비");
		                if(inputCardType.equals("EDUC"))                 mp2.put("자료구분" , "교육비");
		                if(inputCardType.equals("RENT"))                 mp2.put("자료구분" , "주택자금");
		                if(inputCardType.equals("DONA"))                 mp2.put("자료구분" , "기부금");
		                if(inputCardType.equals("SAVE"))                 mp2.put("자료구분" , "개인연금저축");
		                if(inputCardType.equals("HOUS"))                 mp2.put("자료구분" , "주택마련저축");
		                if(inputCardType.equals("CARD"))                 mp2.put("자료구분" , "신용카드");
		                if(inputCardType.equals("ETCC"))                 mp2.put("자료구분" , "기타");
		            }
		        } mp2.remove("searchGubunCd");

		        //상태값
		        String inputStsCd  = "";
		        if(mp2.containsKey("searchStatusCd") || mp2.containsKey("status_cd") ){

		            if(chkNull(mp2.get("searchStatusCd")) > 0) inputStsCd = mp2.get("searchStatusCd");
		            if(chkNull(mp2.get("status_cd"))      > 0) inputStsCd = mp2.get("status_cd");

		            if(inputStsCd.equals("S"))                 mp2.put("자료구분" , "반영");
		            if(inputStsCd.equals("N"))                 mp2.put("자료구분" , "미반영");
		            if(inputStsCd.equals("E"))                 mp2.put("자료구분" , "오류");
		            if(inputStsCd.equals("D"))                 mp2.put("자료구분" , "반영제외");
		            if(inputStsCd.equals("0"))                 mp2.put("자료구분" , "적용전");
		            if(inputStsCd.equals("1"))                 mp2.put("자료구분" , "변경완료");
		            if(inputStsCd.equals("2"))                 mp2.put("자료구분" , "취소완료");
		        }
		        mp2.remove("searchStatusCd");
		        mp2.remove("status_cd");

			    //거주자구분
			    String resTy  = "";
			    if(mp2.containsKey("residency_type")){
			        if(chkNull(mp2.get("residency_type")) > 0) {
			        	resTy = mp2.get("residency_type");
			            if("1".equals(resTy)) mp2.put("거주자구분" , "거주자");
			            if("2".equals(resTy)) mp2.put("거주자구분" , "비거주자");
			        }
			    } mp2.remove("residency_type");


			    //내외국인구분
		        String citizenType  = "";
		        if(mp2.containsKey("citizen_type")){
		            if(chkNull(mp2.get("citizen_type")) > 0) {
		            	citizenType = mp2.get("citizen_type");
		                if("1".equals(citizenType)) mp2.put("내외국인구분" , "내국인");
		                if("9".equals(citizenType)) mp2.put("내외국인구분" , "외국인");
		            }
		        } mp2.remove("citizen_type");

		        //결과유형
		        if(mp2.containsKey("searchResultType")){
		            if(chkNull(mp2.get("searchResultType")) > 0) {
		                if("W".equals(mp2.get("searchResultType"))) mp2.put("결과유형" , "경고");
		                if("E".equals(mp2.get("searchResultType"))) mp2.put("결과유형" , "오류");
		                if("L".equals(mp2.get("searchResultType"))) mp2.put("결과유형" , "확인");
		            }
		        } mp2.remove("searchResultType");

			    //외국인단일세율 적용여부
			    if(mp2.containsKey("foreign_tax_type")){
			        if(chkNull(mp2.get("foreign_tax_type")) > 0) {
			            if("3".equals(mp2.get("foreign_tax_type"))){
			            	mp2.put("외국인단일세율 적용여부","적용안함");
			            }else {
			            	mp2.put("외국인단일세율 적용여부","19%단일세율");
			            }
			        }
			    } mp2.remove("foreign_tax_type");

			    //출력용도
		        if(mp2.containsKey("searchPurposeCd")){
		            if(chkNull(mp2.get("searchPurposeCd")) > 0) {
		                if("A".equals(mp2.get("searchPurposeCd"))) mp2.put("출력용도","발행자 보관용");
		                if("C".equals(mp2.get("searchPurposeCd"))) mp2.put("출력용도","소득자 보관용");
		                if("D".equals(mp2.get("searchPurposeCd"))) mp2.put("출력용도","발행자 보관용");
		                if("E".equals(mp2.get("searchPurposeCd"))) mp2.put("출력용도","과세이연계좌취급 연금사업자 보관용");
		            }
		        } mp2.remove("searchPurposeCd");

			    mp2.put("세션사번", mp2.remove("ssnSabun"));
			    mp2.put("회사구분", mp2.remove("ssnEnterCd"));
			    mp2.remove("searchPayCd");
			    mp2.remove("cmd");
			    mp2.remove("srchSeq");
			    mp2.remove("srchOrgCd");
			    mp2.remove("query");
			    mp2.remove("query2");
			    mp2.remove("searchPage");
			    mp2.remove("hangle_giha");
			    mp2.remove("hangle_san");
			    mp2.remove("sNo");
			    mp2.remove("sDelete");
			    mp2.remove("detail");
			    mp2.remove("grpCd");
			    mp2.remove("adjElementNm");
			    mp2.remove("queryId");
			    mp2.remove("ibs");
			    mp2.remove("queryA");
			    mp2.remove("queryB");
			    mp2.remove("queryG");
			    mp2.remove("queryH");
			    mp2.remove("searchTable");
			    mp2.remove("searchValue");
			    mp2.remove("searchCdValue");
			    mp2.remove("btn_link");
			    mp2.remove("searchTemp");
			    mp2.remove("popFlag");
			    mp2.remove("searchFormCd0");
			    mp2.remove("searchFormCd1");
			    mp2.remove("searchFormCd2");
			    mp2.remove("searchFormCd3");
			    mp2.remove("searchFormCd4");
			    mp2.remove("searchFormCd5");
			    mp2.remove("searchFormCd6");
			    mp2.remove("searchFormCd7");
			    mp2.remove("searchFormCd8");
			    mp2.remove("searchFormCd9");
			    mp2.remove("tabName");
			    mp2.remove("searchA1");
			    mp2.remove("a1");
			    mp2.remove("seq");
			    mp2.remove("input_status");
			    mp2.remove("inputStatus");
			    mp2.remove("searchGubun");
			    mp2.remove("help_pic");
			    mp2.remove("searchYyType");
			    mp2.remove("inputCdType");

			    mp2.remove("del_btn");
			    mp2.remove("down_btn");

			    if(chkNull(mp2.get("sStatus"))  > 0){
			        sStatus = mp2.get("sStatus");
			    }else {
			        sStatus = "R";
			    }
			    mp2.remove("sStatus");
			    if(chkNull(mp2.get("stNum")) > 0 && chkNull(mp2.get("edNum")) > 0){
			        mp2.put("조회페이징수" ,mp2.remove("stNum")+"~"+mp2.remove("edNum"));
			    }else {
			        mp2.remove("stNum");
			        mp2.remove("edNum");
			    }

			    if(chkNull(mp2.get("srchYear"))               > 0) mp2.put("대상년도"                      ,mp2.remove("srchYear"                 ));else mp2.remove("srchYear");
			    if(chkNull(mp2.get("searchYear"))             > 0) mp2.put("대상년도"                      ,mp2.remove("searchYear"               ));else mp2.remove("searchYear");
			    if(chkNull(mp2.get("srchWorkYy"))             > 0) mp2.put("대상년도"                      ,mp2.remove("srchWorkYy"               ));else mp2.remove("srchWorkYy");
			    if(chkNull(mp2.get("searchWorkYy"))           > 0) mp2.put("대상년도"                      ,mp2.remove("searchWorkYy"             ));else mp2.remove("searchWorkYy");
			    if(chkNull(mp2.get("searchStdWorkYy"))        > 0) mp2.put("기준년도"                      ,mp2.remove("searchStdWorkYy"          ));else mp2.remove("searchStdWorkYy");
			    if(chkNull(mp2.get("searchWorkYear"))         > 0) mp2.put("대상년도"                      ,mp2.remove("searchWorkYear"           ));else mp2.remove("searchWorkYear");
			    if(chkNull(mp2.get("searchBfYear"))           > 0) mp2.put("전년도"                        ,mp2.remove("searchBfYear"             ));else mp2.remove("searchBfYear");
			    if(chkNull(mp2.get("searchPaySym"))           > 0) mp2.put("귀속시작월"                     ,mp2.remove("searchPaySym"             ));else mp2.remove("searchPaySym");
			    if(chkNull(mp2.get("searchPayEym"))           > 0) mp2.put("귀속종료월"                     ,mp2.remove("searchPayEym"             ));else mp2.remove("searchPayEym");
			    if(chkNull(mp2.get("searchPaymentSymd"))      > 0) mp2.put("시작지급일"                     ,mp2.remove("searchPaymentSymd"        ));else mp2.remove("searchPaymentSymd");
			    if(chkNull(mp2.get("searchPaymentEymd"))      > 0) mp2.put("종료지급일"                     ,mp2.remove("searchPaymentEymd"        ));else mp2.remove("searchPaymentEymd");
			    if(chkNull(mp2.get("srchYm"))                 > 0) mp2.put("대상년월"                       ,mp2.remove("srchYm"                  ));else mp2.remove("srchYm");
			    if(chkNull(mp2.get("searchFromYmd"))          > 0) mp2.put("작업일자"                       ,mp2.remove("searchFromYmd"           ));else mp2.remove("searchFromYmd");
			    if(chkNull(mp2.get("searchToYmd"))            > 0) mp2.put("작업일자"                       ,mp2.remove("searchToYmd"             ));else mp2.remove("searchToYmd");

			    if(chkNull(mp2.get("srchSabun")) > 0){
			    	sabunStr = "'"+mp2.get("srchSabun")+"'";
			    	mp2.put("사번",mp2.remove("srchSabun"));
			    }else{
			    	mp2.remove("srchSabun");
			    }
			    if(chkNull(mp2.get("sabun")) > 0){
			    	sabunStr = "'"+mp2.get("sabun")+"'";
			    	mp2.put("사번",mp2.remove("sabun"));
			    }else{
			    	mp2.remove("sabun");
			    }
			    if(sabunStr == null || sabunStr == "") sabunStr = "''";

			    if(chkNull(mp2.get("searchSabun"))            > 0) mp2.put("사번"                          ,mp2.remove("searchSabun"             ));else mp2.remove("searchSabun");
			    if(chkNull(mp2.get("searchSb"))               > 0) mp2.put("사번"                          ,mp2.remove("searchSb"                ));else mp2.remove("searchSb");
			    if(chkNull(mp2.get("srchSbNm"))               > 0) mp2.put("사번/성명"                      ,mp2.remove("srchSbNm"                ));else mp2.remove("srchSbNm");
			    if(chkNull(mp2.get("srchChkNm"))              > 0) mp2.put("작업자사번/성명"                  ,mp2.remove("srchChkNm"                ));else mp2.remove("srchChkNm");
			    if(chkNull(mp2.get("searchSbNm"))             > 0) mp2.put("사번/성명"                      ,mp2.remove("searchSbNm"              ));else mp2.remove("searchSbNm");
			    if(chkNull(mp2.get("searchNm"))               > 0) mp2.put("사번/성명"                      ,mp2.remove("searchNm"                ));else mp2.remove("searchNm");
			    if(chkNull(mp2.get("searchSabunNameAlias"))   > 0) mp2.put("사번/성명"                      ,mp2.remove("searchSabunNameAlias"    ));else mp2.remove("searchSabunNameAlias");
			    if(chkNull(mp2.get("searchOrgNm"))            > 0) mp2.put("부서명"                        ,mp2.remove("searchOrgNm"              ));else mp2.remove("searchOrgNm");
			    if(chkNull(mp2.get("searchContents"))         > 0) mp2.put("내용"                          ,mp2.remove("searchContents"          ));else mp2.remove("searchContents");
			    if(chkNull(mp2.get("searchMonthSeq"))         > 0) mp2.put("분납반영"                       ,mp2.remove("searchMonthSeq"          ));else mp2.remove("searchMonthSeq");
			    if(chkNull(mp2.get("searchRtrApplyCd"))       > 0) mp2.put("퇴직정산일자코드"                 ,mp2.remove("searchRtrApplyCd"        ));else mp2.remove("searchRtrApplyCd");
			    if(chkNull(mp2.get("searchRtrApplyNm"))       > 0) mp2.put("퇴직정산일자"                    ,mp2.remove("searchRtrApplyNm"        ));else mp2.remove("searchRtrApplyNm");
			    if(chkNull(mp2.get("searchPayApplyCd"))       > 0) mp2.put("급여반영일자코드"                 ,mp2.remove("searchPayApplyCd"        ));else mp2.remove("searchPayApplyCd");
			    if(chkNull(mp2.get("searchPayApplyNm"))       > 0) mp2.put("급여반영일자"                    ,mp2.remove("searchPayApplyNm"        ));else mp2.remove("searchPayApplyNm");
			    if(chkNull(mp2.get("searchPageLimit"))        > 0) mp2.put("조회페이지수"                    ,mp2.remove("searchPageLimit"         ));else mp2.remove("searchPageLimit");
			    if(chkNull(mp2.get("adj_sabun"))              > 0) mp2.put("연말정산계산결과사번"              ,mp2.remove("adj_sabun"                ));else mp2.remove("adj_sabun");
			    if(chkNull(mp2.get("pay_people_status"))      > 0) mp2.put("작업대상_실제값"                 ,mp2.remove("pay_people_status"        ));else mp2.remove("pay_people_status");
			    if(chkNull(mp2.get("pay_people_status_view")) > 0) mp2.put("작업대상"                      ,mp2.remove("pay_people_status_view"   ));else mp2.remove("pay_people_status_view");
			    if(chkNull(mp2.get("adj_e_ymd"))              > 0) mp2.put("귀속종료일"                     ,mp2.remove("adj_e_ymd"                ));else mp2.remove("adj_e_ymd");
			    if(chkNull(mp2.get("adj_s_ymd"))              > 0) mp2.put("귀속시작일"                     ,mp2.remove("adj_s_ymd"                ));else mp2.remove("adj_s_ymd");
			    if(chkNull(mp2.get("tax_type"))               > 0) mp2.put("세액계산방식"                    ,mp2.remove("tax_type"                 ));else mp2.remove("tax_type");
			    if(chkNull(mp2.get("temp"))                   > 0) mp2.put("작업"                          ,mp2.remove("temp"                     ));else mp2.remove("temp");
			    if(chkNull(mp2.get("org_cd"))                 > 0) mp2.put("조직코드명"                      ,mp2.remove("org_cd"                   ));else mp2.remove("org_cd");
			    if(chkNull(mp2.get("searchYmd1"))             > 0) mp2.put("가입일자 from"                      ,mp2.remove("searchYmd1"             ));else mp2.remove("searchYmd1");
			    if(chkNull(mp2.get("searchYmd2"))             > 0) mp2.put("가입일자 to"                      ,mp2.remove("searchYmd2"             ));else mp2.remove("searchYmd2");
			    if(chkNull(mp2.get("searchMon"))              > 0) mp2.put("이월금액 발생자"                   ,mp2.remove("searchMon"              ));else mp2.remove("searchMon");
			    if(chkNull(mp2.get("searchDpndntYn"))         > 0) mp2.put("공제여부"                        ,mp2.remove("searchDpndntYn"         ));else mp2.remove("searchDpndntYn");
			    if(chkNull(mp2.get("srhEvidYn"))              > 0) mp2.put("증빙자료등록여부"                  ,mp2.remove("srhEvidYn"              ));else mp2.remove("srhEvidYn");
			    if(chkNull(mp2.get("srhSelfInputYn"))         > 0) mp2.put("수기자료등록여부"                  ,mp2.remove("srhSelfInputYn"         ));else mp2.remove("srhSelfInputYn");
			    if(chkNull(mp2.get("searchStatusCd"))         > 0) mp2.put("처리상태"                        ,mp2.remove("searchStatusCd"         ));else mp2.remove("searchStatusCd");
			    if(chkNull(mp2.get("searchTaxInsYn"))         > 0) mp2.put("신청여부"                        ,mp2.remove("searchTaxInsYn"         ));else mp2.remove("searchTaxInsYn");
			    if(chkNull(mp2.get("searchTaxInsYnMonth"))    > 0) mp2.put("개월수"                         ,mp2.remove("searchTaxInsYnMonth"    ));else mp2.remove("searchTaxInsYnMonth");
			    if(chkNull(mp2.get("searchTaxRate"))          > 0) mp2.put("원천징수세액"                     ,mp2.remove("searchTaxRate"          ));else mp2.remove("searchTaxRate");
			    if(chkNull(mp2.get("searchClearYn"))          > 0) mp2.put("Clear여부"                      ,mp2.remove("searchClearYn"          ));else mp2.remove("searchClearYn");
			    if(chkNull(mp2.get("searchReplyYn"))          > 0) mp2.put("답변여부"                        ,mp2.remove("searchReplyYn"          ));else mp2.remove("searchReplyYn");
			    if(chkNull(mp2.get("searchAuthPg"))           > 0) mp2.put("조회권한"                        ,mp2.remove("searchAuthPg"           ));else mp2.remove("searchAuthPg");
			    if(chkNull(mp2.get("orgAuthPg"))              > 0) mp2.put("조회권한"                           ,mp2.remove("orgAuthPg"               ));else mp2.remove("orgAuthPg");
			    if(chkNull(mp2.get("searchClosedType"))       > 0) mp2.put("마감여부"                        ,mp2.remove("searchClosedType"       ));else mp2.remove("searchClosedType");
			    if(chkNull(mp2.get("searchPayActionCd"))      > 0) mp2.put("급여코드"                        ,mp2.remove("searchPayActionCd"      ));else mp2.remove("searchPayActionCd");
			    if(chkNull(mp2.get("searchPayActionCdNm"))    > 0) mp2.put("급여코드명"                       ,mp2.remove("searchPayActionCdNm"      ));else mp2.remove("searchPayActionCdNm");
			    if(chkNull(mp2.get("input_close_yn"))         > 0) mp2.put("본인마감"                        ,mp2.remove("input_close_yn"         ));else mp2.remove("input_close_yn");
			    if(chkNull(mp2.get("searchDivPage"))          > 0) mp2.put("페이징단위"                       ,mp2.remove("searchDivPage"          ));else mp2.remove("searchDivPage");
			    if(chkNull(mp2.get("chg_chk"))                > 0) mp2.put("변경대상"                       ,mp2.remove("chg_chk"                ));else mp2.remove("chg_chk");
			    if(chkNull(mp2.get("cancel_chk"))             > 0) mp2.put("취소대상"                       ,mp2.remove("cancel_chk"             ));else mp2.remove("cancel_chk");
			    if(chkNull(mp2.get("status_cdnm"))            > 0) mp2.put("상태"                          ,mp2.remove("status_cdnm"            ));else mp2.remove("status_cdnm");
			    if(chkNull(mp2.get("emp_ymd"))                > 0) mp2.put("입사일"                         ,mp2.remove("emp_ymd"                ));else mp2.remove("emp_ymd");
			    if(chkNull(mp2.get("ret_ymd"))                > 0) mp2.put("퇴사일"                         ,mp2.remove("ret_ymd"                ));else mp2.remove("ret_ymd");
			    if(chkNull(mp2.get("searchCancleType"))       > 0) mp2.put("취소대상"                        ,mp2.remove("searchCancleType"       ));else mp2.remove("searchCancleType");
			    if(chkNull(mp2.get("searchChgType"))          > 0) mp2.put("변경대상"                        ,mp2.remove("searchChgType"          ));else mp2.remove("searchChgType");
			    if(chkNull(mp2.get("searchWorkMm"))           > 0) mp2.put("귀속월"                         ,mp2.remove("searchWorkMm"           ));else mp2.remove("searchWorkMm");
			    if(chkNull(mp2.get("searchPrintYMD"))         > 0) mp2.put("출력일자"                        ,mp2.remove("searchPrintYMD"         ));else mp2.remove("searchPrintYMD");
			    if(chkNull(mp2.get("result_open_yn"))         > 0) mp2.put("본인마감"                        ,mp2.remove("result_open_yn"         ));else mp2.remove("result_open_yn");
			    if(chkNull(mp2.get("apprv_yn"))               > 0) mp2.put("본인마감2"                       ,mp2.remove("apprv_yn"               ));else mp2.remove("apprv_yn");
			    if(chkNull(mp2.get("result_confirm_yn"))      > 0) mp2.put("담당자마감"                      ,mp2.remove("result_confirm_yn"      ));else mp2.remove("result_confirm_yn");
			    if(chkNull(mp2.get("input_close_yn_src"))     > 0) mp2.put("최종마감여부"                     ,mp2.remove("input_close_yn_src"     ));else mp2.remove("input_close_yn_src");
			    if(chkNull(mp2.get("searchPatchSeq"))         > 0) mp2.put("패치차수"                        ,mp2.remove("searchPatchSeq"         ));else mp2.remove("searchPatchSeq");
			    if(chkNull(mp2.get("pay_nm"))                 > 0) mp2.put("급여구분코드명"                    ,mp2.remove("pay_nm"                 ));else mp2.remove("pay_nm");
			    if(chkNull(mp2.get("inputType"))              > 0) mp2.put("검색타입"                        ,mp2.remove("inputType"              ));else mp2.remove("inputType");
			    if(chkNull(mp2.get("searchPatchDesc"))        > 0) mp2.put("패치내역"                        ,mp2.remove("searchPatchDesc"        ));else mp2.remove("searchPatchDesc");
			    if(chkNull(mp2.get("searchKeyword"))          > 0) mp2.put("검색어"                        ,mp2.remove("searchKeyword"            ));else mp2.remove("searchKeyword");
			    if(chkNull(mp2.get("findName"))               > 0) mp2.put("사번/이름"                       ,mp2.remove("findName"                ));else mp2.remove("findName");
			    if(chkNull(mp2.get("searchPayActionNm"))      > 0) mp2.put("작업일자"                        ,mp2.remove("searchPayActionNm"       ));else mp2.remove("searchPayActionNm");
			    if(chkNull(mp2.get("final_close_yn"))         > 0) mp2.put("본인결과확인여부"                  ,mp2.remove("final_close_yn"         ));else mp2.remove("final_close_yn");
			    if(chkNull(mp2.get("zip"))                    > 0) mp2.put("우편번호"                       ,mp2.remove("zip"                     ));else mp2.remove("zip");
			    if(chkNull(mp2.get("addr1"))                  > 0) mp2.put("주소"                          ,mp2.remove("addr1"                   ));else mp2.remove("addr1");
			    if(chkNull(mp2.get("addr2"))                  > 0) mp2.put("상세주소"                       ,mp2.remove("addr2"                   ));else mp2.remove("addr2");
			    if(chkNull(mp2.get("national_nm"))            > 0) mp2.put("국적코드명"                      ,mp2.remove("national_nm"             ));else mp2.remove("national_nm");
			    if(chkNull(mp2.get("house_owner_yn"))         > 0) mp2.put("세대주여부"                      ,mp2.remove("house_owner_yn"          ));else mp2.remove("house_owner_yn");
			    if(chkNull(mp2.get("house_get_ymd"))          > 0) mp2.put("주택취득일"                      ,mp2.remove("house_get_ymd"           ));else mp2.remove("house_get_ymd");
			    if(chkNull(mp2.get("house_cnt"))              > 0) mp2.put("주택소유수"                      ,mp2.remove("house_cnt"               ));else mp2.remove("house_cnt");
			    if(chkNull(mp2.get("house_area"))             > 0) mp2.put("전용면적"                       ,mp2.remove("house_area"               ));else mp2.remove("house_area");
			    if(chkNull(mp2.get("official_price"))         > 0) mp2.put("공시지가"                       ,mp2.remove("official_price"           ));else mp2.remove("official_price");
			    if(chkNull(mp2.get("foreign_emp_type"))       > 0) mp2.put("외국법인소속 파견근로자여부"         ,mp2.remove("foreign_emp_type"          ));else mp2.remove("foreign_emp_type");
			    if(chkNull(mp2.get("admin_yn"))               > 0) mp2.put("관리자여부"                      ,mp2.remove("admin_yn"                 ));else mp2.remove("admin_yn");
			    if(chkNull(mp2.get("next_work_yy"))           > 0) mp2.put("다음년도"                       ,mp2.remove("next_work_yy"             ));else mp2.remove("next_work_yy");
			    if(chkNull(mp2.get("paytotMonTemp"))          > 0) mp2.put("총급여"                        ,mp2.remove("paytotMonTemp"             ));else mp2.remove("paytotMonTemp");
			    if(chkNull(mp2.get("idx"))                    > 0) mp2.put("seq"                          ,mp2.remove("idx"                      ));else mp2.remove("idx");
			    if(chkNull(mp2.get("zipcode"))                > 0) mp2.put("우편번호"                       ,mp2.remove("zipcode"                  ));else mp2.remove("zipcode");
			    if(chkNull(mp2.get("zipCode"))                > 0) mp2.put("우편번호"                       ,mp2.remove("zipCode"                  ));else mp2.remove("zipCode");
			    if(chkNull(mp2.get("juso"))                   > 0) mp2.put("도로명주소"                      ,mp2.remove("juso"                     ));else mp2.remove("juso");
			    if(chkNull(mp2.get("juso_s"))                 > 0) mp2.put("신주소"                         ,mp2.remove("juso_s"                  ));else mp2.remove("juso_s");
			    if(chkNull(mp2.get("juso_g"))                 > 0) mp2.put("지번주소"                       ,mp2.remove("juso_g"                   ));else mp2.remove("juso_g");
			    if(chkNull(mp2.get("juso_e"))                 > 0) mp2.put("영문주소"                       ,mp2.remove("juso_e"                   ));else mp2.remove("juso_e");
			    if(chkNull(mp2.get("sido"))                   > 0) mp2.put("시도"                         ,mp2.remove("sido"                      ));else mp2.remove("sido");
			    if(chkNull(mp2.get("sido_e"))                 > 0) mp2.put("시도영문"                      ,mp2.remove("sido_e"                    ));else mp2.remove("sido_e");
			    if(chkNull(mp2.get("sigungu"))                > 0) mp2.put("시군구"                       ,mp2.remove("sigungu"                    ));else mp2.remove("sigungu");
			    if(chkNull(mp2.get("sigungu_e"))              > 0) mp2.put("시군구영문"                    ,mp2.remove("sigungu_e"                  ));else mp2.remove("sigungu_e");
			    if(chkNull(mp2.get("upmyon"))                 > 0) mp2.put("읍면"                         ,mp2.remove("upmyon"                    ));else mp2.remove("upmyon");
			    if(chkNull(mp2.get("upmyon_e"))               > 0) mp2.put("읍면영문"                      ,mp2.remove("upmyon_e"                  ));else mp2.remove("upmyon_e");
			    if(chkNull(mp2.get("road_code"))              > 0) mp2.put("도로명코드"                     ,mp2.remove("road_code"                 ));else mp2.remove("road_code");
			    if(chkNull(mp2.get("road_name"))              > 0) mp2.put("도로명"                         ,mp2.remove("road_name"                ));else mp2.remove("road_name");
			    if(chkNull(mp2.get("road_name_e"))            > 0) mp2.put("도로명영문"                     ,mp2.remove("road_name_e"               ));else mp2.remove("road_name_e");
			    if(chkNull(mp2.get("isUnder"))                > 0) mp2.put("지하여부"                       ,mp2.remove("isUnder"                   ));else mp2.remove("isUnder");
			    if(chkNull(mp2.get("bdno_m"))                 > 0) mp2.put("건물번호본번"                    ,mp2.remove("bdno_m"                    ));else mp2.remove("bdno_m");
			    if(chkNull(mp2.get("bdno_s"))                 > 0) mp2.put("건물번호부번"                    ,mp2.remove("bdno_s"                    ));else mp2.remove("bdno_s");
			    if(chkNull(mp2.get("bdno_d"))                 > 0) mp2.put("건물관리번호"                    ,mp2.remove("bdno_d"                    ));else mp2.remove("bdno_d");
			    if(chkNull(mp2.get("mass_delevery"))          > 0) mp2.put("다량배달처명"                    ,mp2.remove("mass_delevery"             ));else mp2.remove("mass_delevery");
			    if(chkNull(mp2.get("sigungubd_name"))         > 0) mp2.put("시군구용건물명"                    ,mp2.remove("sigungubd_name"           ));else mp2.remove("sigungubd_name");
			    if(chkNull(mp2.get("law_dong_code"))          > 0) mp2.put("법정동코드"                      ,mp2.remove("law_dong_code"             ));else mp2.remove("law_dong_code");
			    if(chkNull(mp2.get("law_dong_name"))          > 0) mp2.put("법정동명"                       ,mp2.remove("law_dong_name"             ));else mp2.remove("law_dong_name");
			    if(chkNull(mp2.get("ri"))                     > 0) mp2.put("리명"                          ,mp2.remove("ri"                        ));else mp2.remove("ri");
			    if(chkNull(mp2.get("gov_dong_name"))          > 0) mp2.put("행정동명"                       ,mp2.remove("gov_dong_name"             ));else mp2.remove("gov_dong_name");
			    if(chkNull(mp2.get("is_mountin"))             > 0) mp2.put("산여부"                         ,mp2.remove("is_mountin"               ));else mp2.remove("is_mountin");
			    if(chkNull(mp2.get("jibun_m"))                > 0) mp2.put("지번본번"                       ,mp2.remove("jibun_m"                   ));else mp2.remove("jibun_m");
			    if(chkNull(mp2.get("jibun_s"))                > 0) mp2.put("지번부번"                       ,mp2.remove("jibun_s"                   ));else mp2.remove("jibun_s");
			    if(chkNull(mp2.get("upmyundong_no"))          > 0) mp2.put("을면동일련번호"                   ,mp2.remove("upmyundong_no"             ));else mp2.remove("upmyundong_no");
			    if(chkNull(mp2.get("old_zipcode"))            > 0) mp2.put("우편번호6"                      ,mp2.remove("old_zipcode"               ));else mp2.remove("old_zipcode");
			    if(chkNull(mp2.get("old_zipcodeNo"))          > 0) mp2.put("우편번호일련번호6"                ,mp2.remove("old_zipcodeNo"              ));else mp2.remove("old_zipcodeNo");
			    if(chkNull(mp2.get("addrNote"))               > 0) mp2.put("법정동시군구용건물명"               ,mp2.remove("addrNote"                  ));else mp2.remove("addrNote");
			    if(chkNull(mp2.get("zipCodeResult"))          > 0) mp2.put("우편번호"                       ,mp2.remove("zipCodeResult"              ));else mp2.remove("zipCodeResult");
			    if(chkNull(mp2.get("doroFullAddr"))           > 0) mp2.put("도로명주소"                      ,mp2.remove("doroFullAddr"              ));else mp2.remove("doroFullAddr");
			    if(chkNull(mp2.get("taxRateOld"))             > 0) mp2.put("원천징수세액율old"                ,mp2.remove("taxRateOld"                ));else mp2.remove("taxRateOld");
			    if(chkNull(mp2.get("searchWord"))             > 0) mp2.put("검색어"                         ,mp2.remove("searchWord"                ));else mp2.remove("searchWord");
			    if(chkNull(mp2.get("dtlAddr"))                > 0) mp2.put("상세주소"                       ,mp2.remove("dtlAddr"                    ));else mp2.remove("dtlAddr");
			    if(chkNull(mp2.get("doroAddr"))               > 0) mp2.put("주소"                          ,mp2.remove("doroAddr"                   ));else mp2.remove("doroAddr");
			    if(chkNull(mp2.get("hndcp_type"))             > 0) mp2.put("장애구분"                       ,mp2.remove("hndcp_type"                 ));else mp2.remove("hndcp_type");
			    if(chkNull(mp2.get("fam_nm"))                 > 0) mp2.put("성명"                          ,mp2.remove("fam_nm"                     ));else mp2.remove("fam_nm");
			    if(chkNull(mp2.get("famres"))                 > 0) mp2.put("주민등록번호"                    ,mp2.remove("famres"                      ));else mp2.remove("famres");
			    if(chkNull(mp2.get("famresChk"))              > 0) mp2.put("주민등록번호체크"                 ,mp2.remove("famresChk"                   ));else mp2.remove("famresChk");
			    if(chkNull(mp2.get("sdate"))                  > 0) mp2.put("적용기간시작일"                   ,mp2.remove("sdate"                      ));else mp2.remove("sdate");
			    if(chkNull(mp2.get("edate"))                  > 0) mp2.put("적용기간종료일"                   ,mp2.remove("edate"                      ));else mp2.remove("edate");
			    if(chkNull(mp2.get("bigo"))                   > 0) mp2.put("비고"                          ,mp2.remove("bigo"                       ));else mp2.remove("bigo");
			    if(chkNull(mp2.get("A010_03"))                > 0) mp2.put("배우자 공제 여부"                  ,mp2.remove("A010_03"                    ));else mp2.remove("A010_03");
			    if(chkNull(mp2.get("A010_05"))                > 0) mp2.put("직계존속"                       ,mp2.remove("A010_05"                    ));else mp2.remove("A010_05");
			    if(chkNull(mp2.get("A010_07"))                > 0) mp2.put("직계비속,입양자,위탁아동,수급자"      ,mp2.remove("A010_07"                    ));else mp2.remove("A010_07");
			    if(chkNull(mp2.get("A010_09"))                > 0) mp2.put("형제자매"                       ,mp2.remove("A010_09"                    ));else mp2.remove("A010_09");
			    if(chkNull(mp2.get("A020_03"))                > 0) mp2.put("경로우대공제"                    ,mp2.remove("A020_03"                    ));else mp2.remove("A020_03");
			    if(chkNull(mp2.get("A020_05"))                > 0) mp2.put("장애인공제"                     ,mp2.remove("A020_05"                     ));else mp2.remove("A020_05");
			    if(chkNull(mp2.get("A020_07"))                > 0) mp2.put("부녀자공제여부"                  ,mp2.remove("A020_07"                     ));else mp2.remove("A020_07");
			    if(chkNull(mp2.get("A020_14"))                > 0) mp2.put("한부모공제여부"                   ,mp2.remove("A020_14"                    ));else mp2.remove("A020_14");
			    if(chkNull(mp2.get("B000_10"))                > 0) mp2.put("자녀세액공제"                    ,mp2.remove("B000_10"                     ));else mp2.remove("B000_10");
			    if(chkNull(mp2.get("B001_30"))                > 0) mp2.put("출산입양세액공제"                 ,mp2.remove("B001_30"                     ));else mp2.remove("B001_30");
			    if(chkNull(mp2.get("age_type"))               > 0) mp2.put("연령대"                        ,mp2.remove("age_type"                    ));else mp2.remove("age_type");
			    if(chkNull(mp2.get("senior_yn"))              > 0) mp2.put("경로우대"                       ,mp2.remove("senior_yn"                   ));else mp2.remove("senior_yn");
			    if(chkNull(mp2.get("aca_cd"))                 > 0) mp2.put("학력"                          ,mp2.remove("aca_cd"                      ));else mp2.remove("aca_cd");
			    if(chkNull(mp2.get("chkdate"))                > 0) mp2.put("갱신일시"                        ,mp2.remove("chkdate"                    ));else mp2.remove("chkdate");
			    if(chkNull(mp2.get("pre_equals_yn"))          > 0) mp2.put("전년도대상여부"                    ,mp2.remove("pre_equals_yn"              ));else mp2.remove("pre_equals_yn");
			    if(chkNull(mp2.get("adopt_born_yn"))          > 0) mp2.put("출산입양공제"                     ,mp2.remove("adopt_born_yn"              ));else mp2.remove("adopt_born_yn");
			    if(chkNull(mp2.get("add_child_yn"))           > 0) mp2.put("자녀세액공제"                     ,mp2.remove("add_child_yn"               ));else mp2.remove("add_child_yn");
			    if(chkNull(mp2.get("education_yn"))           > 0) mp2.put("교육비"                         ,mp2.remove("education_yn"               ));else mp2.remove("education_yn");
			    if(chkNull(mp2.get("insurance_yn"))           > 0) mp2.put("전체내역"                        ,mp2.remove("insurance_yn"               ));else mp2.remove("insurance_yn");
			    if(chkNull(mp2.get("incnt"))                  > 0) mp2.put("다른곳에 등록된 수"                 ,mp2.remove("incnt"                      ));else mp2.remove("incnt");
			    if(chkNull(mp2.get("child_order"))            > 0) mp2.put("자녀순서"                        ,mp2.remove("child_order"                ));else mp2.remove("child_order");
			    if(chkNull(mp2.get("medical_yn"))             > 0) mp2.put("의료비"                         ,mp2.remove("medical_yn"                  ));else mp2.remove("medical_yn");
			    if(chkNull(mp2.get("dpndnt_sts"))             > 0) mp2.put("기본공제"                        ,mp2.remove("dpndnt_sts"                 ));else mp2.remove("dpndnt_sts");
			    if(chkNull(mp2.get("credit_yn"))              > 0) mp2.put("신용카드등"                       ,mp2.remove("credit_yn"                  ));else mp2.remove("credit_yn");
			    if(chkNull(mp2.get("fam_cd"))                 > 0) mp2.put("관계"                           ,mp2.remove("fam_cd"                      ));else mp2.remove("fam_cd");
			    if(chkNull(mp2.get("one_parent_yn"))          > 0) mp2.put("한부모공제"                       ,mp2.remove("one_parent_yn"               ));else mp2.remove("one_parent_yn");
			    if(chkNull(mp2.get("woman_yn"))               > 0) mp2.put("부녀자공제"                       ,mp2.remove("woman_yn"                    ));else mp2.remove("woman_yn");
			    if(chkNull(mp2.get("dpndnt_yn"))              > 0) mp2.put("기본공제"                         ,mp2.remove("dpndnt_yn"                  ));else mp2.remove("dpndnt_yn");
			    if(chkNull(mp2.get("hndcp_yn"))               > 0) mp2.put("장애인공제"                        ,mp2.remove("hndcp_yn"                   ));else mp2.remove("hndcp_yn");
			    if(chkNull(mp2.get("age"))                    > 0) mp2.put("나이"                            ,mp2.remove("age"                        ));else mp2.remove("age");
			    if(chkNull(mp2.get("spouse_yn"))              > 0) mp2.put("배우자공제"                        ,mp2.remove("spouse_yn"                  ));else mp2.remove("spouse_yn");
			    if(chkNull(mp2.get("detail_popup"))           > 0) mp2.put("전체내역"                         ,mp2.remove("detail_popup"                ));else mp2.remove("detail_popup");
			    if(chkNull(mp2.get("gubun_cd"))               > 0) mp2.put("구분"                            ,mp2.remove("gubun_cd"                    ));else mp2.remove("gubun_cd");
			    if(chkNull(mp2.get("gubun_nm"))               > 0) mp2.put("구문명"                           ,mp2.remove("gubun_nm"                   ));else mp2.remove("gubun_nm");
			    if(chkNull(mp2.get("input_close_yn_src"))     > 0) mp2.put("본인마감2"                        ,mp2.remove("input_close_yn_src"          ));else mp2.remove("input_close_yn_src");
			    if(chkNull(mp2.get("cnt_0"))                  > 0) mp2.put("미선택"                           ,mp2.remove("cnt_0"                      ));else mp2.remove("cnt_0");
			    if(chkNull(mp2.get("cnt_1"))                  > 0) mp2.put("확인완료"                          ,mp2.remove("cnt_1"                      ));else mp2.remove("cnt_1");
			    if(chkNull(mp2.get("cnt_2"))                  > 0) mp2.put("확인중"                           ,mp2.remove("cnt_2"                       ));else mp2.remove("cnt_2");
			    if(chkNull(mp2.get("cnt_3"))                  > 0) mp2.put("서류미비"                          ,mp2.remove("cnt_3"                      ));else mp2.remove("cnt_3");
			    if(chkNull(mp2.get("cnt_4"))                  > 0) mp2.put("공제대상아님"                       ,mp2.remove("cnt_4"                      ));else mp2.remove("cnt_4");
			    if(chkNull(mp2.get("cnt_5"))                  > 0) mp2.put("입력오류"                          ,mp2.remove("cnt_5"                      ));else mp2.remove("cnt_5");
			    if(chkNull(mp2.get("cnt_6"))                  > 0) mp2.put("기타"                             ,mp2.remove("cnt_6"                      ));else mp2.remove("cnt_6");
			    if(chkNull(mp2.get("reply_yn"))               > 0) mp2.put("답변여부"                          ,mp2.remove("reply_yn"                   ));else mp2.remove("reply_yn");
			    if(chkNull(mp2.get("manager_note"))           > 0) mp2.put("담당자멘트"                         ,mp2.remove("manager_note"               ));else mp2.remove("manager_note");
			    if(chkNull(mp2.get("employee_note"))          > 0) mp2.put("직원멘트"                           ,mp2.remove("employee_note"              ));else mp2.remove("employee_note");
			    if(chkNull(mp2.get("tip_text"))               > 0) mp2.put("Tip 내용"                          ,mp2.remove("tip_text"                   ));else mp2.remove("tip_text");
			    if(chkNull(mp2.get("clear_yn"))               > 0) mp2.put("Clear여부"                         ,mp2.remove("clear_yn"                   ));else mp2.remove("clear_yn");
			    if(chkNull(mp2.get("pay_action_cd"))          > 0) mp2.put("급여코드"                           ,mp2.remove("pay_action_cd"              ));else mp2.remove("pay_action_cd");
			    if(chkNull(mp2.get("pay_action_nm"))          > 0) mp2.put("급여코드명"                          ,mp2.remove("pay_action_nm"              ));else mp2.remove("pay_action_nm");
			    if(chkNull(mp2.get("tax_rate"))               > 0) mp2.put("원천징수세액"                         ,mp2.remove("tax_rate"                  ));else mp2.remove("tax_rate");
			    if(chkNull(mp2.get("tax_ins_yn"))             > 0) mp2.put("분납신청여부"                         ,mp2.remove("tax_ins_yn"                ));else mp2.remove("tax_ins_yn");
			    if(chkNull(mp2.get("tot_mon_s"))              > 0) mp2.put("분납신청확정금액소득세"                  ,mp2.remove("tot_mon_s"                 ));else mp2.remove("tot_mon_s");
			    if(chkNull(mp2.get("tot_mon_j"))              > 0) mp2.put("분납신청확정금액주민세"                  ,mp2.remove("tot_mon_j"                 ));else mp2.remove("tot_mon_j");
			    if(chkNull(mp2.get("tax_ins_yn_month"))       > 0) mp2.put("분납신청개월수"                        ,mp2.remove("tax_ins_yn_month"          ));else mp2.remove("tax_ins_yn_month");
			    if(chkNull(mp2.get("tax_ins_mon_1"))          > 0) mp2.put("분납신청1회차소득세"                    ,mp2.remove("tax_ins_mon_1"             ));else mp2.remove("tax_ins_mon_1");
			    if(chkNull(mp2.get("tax_ins_mon_11"))         > 0) mp2.put("분납신청1회차주민세"                    ,mp2.remove("tax_ins_mon_11"            ));else mp2.remove("tax_ins_mon_11");
			    if(chkNull(mp2.get("tax_ins_mon_2"))          > 0) mp2.put("분납신청2회차소득세"                    ,mp2.remove("tax_ins_mon_2"             ));else mp2.remove("tax_ins_mon_2");
			    if(chkNull(mp2.get("tax_ins_mon_22"))         > 0) mp2.put("분납신청2회차주민세"                    ,mp2.remove("tax_ins_mon_22"            ));else mp2.remove("tax_ins_mon_22");
			    if(chkNull(mp2.get("tax_ins_mon_3"))          > 0) mp2.put("분납신청3회차소득세"                    ,mp2.remove("tax_ins_mon_3"             ));else mp2.remove("tax_ins_mon_3");
			    if(chkNull(mp2.get("tax_ins_mon_33"))         > 0) mp2.put("분납신청3회차주민세"                    ,mp2.remove("tax_ins_mon_33"            ));else mp2.remove("tax_ins_mon_33");
			    if(chkNull(mp2.get("name"))                   > 0) mp2.put("성명"                               ,mp2.remove("name"                      ));else mp2.remove("name");
			    if(chkNull(mp2.get("select_img"))             > 0) mp2.put("세부내역"                            ,mp2.remove("select_img"                ));else mp2.remove("select_img");
			    if(chkNull(mp2.get("work_yy"))                > 0) mp2.put("대상년도"                            ,mp2.remove("work_yy"                   ));else mp2.remove("work_yy");
			    if(chkNull(mp2.get("enter_nm"))               > 0) mp2.put("근무처명"                            ,mp2.remove("enter_nm"                  ));else mp2.remove("enter_nm");
			    if(chkNull(mp2.get("napse_yn"))               > 0) mp2.put("납세조합구분"                         ,mp2.remove("napse_yn"                  ));else mp2.remove("napse_yn");
			    if(chkNull(mp2.get("enter_no"))               > 0) mp2.put("사업자등록번호"                       ,mp2.remove("enter_no"                   ));else mp2.remove("enter_no");
			    if(chkNull(mp2.get("work_s_ymd"))             > 0) mp2.put("근무기간시작일"                       ,mp2.remove("work_s_ymd"                 ));else mp2.remove("work_s_ymd");
			    if(chkNull(mp2.get("work_e_ymd"))             > 0) mp2.put("근무기간종료일"                       ,mp2.remove("work_e_ymd"                 ));else mp2.remove("work_e_ymd");
			    if(chkNull(mp2.get("reduce_s_ymd"))           > 0) mp2.put("감면기간시작일"                       ,mp2.remove("reduce_s_ymd"               ));else mp2.remove("reduce_s_ymd");
			    if(chkNull(mp2.get("reduce_e_ymd"))           > 0) mp2.put("감면기간종료일"                       ,mp2.remove("reduce_e_ymd"               ));else mp2.remove("reduce_e_ymd");
                if(chkNull(mp2.get("reduceSymd"))             > 0) mp2.put("감면기간시작일"                       ,mp2.remove("reduceSymd"               ));else mp2.remove("reduceSymd");
                if(chkNull(mp2.get("reduceEymd"))             > 0) mp2.put("감면기간종료일"                       ,mp2.remove("reduceEymd"               ));else mp2.remove("reduceEymd");
			    if(chkNull(mp2.get("pay_mon"))                > 0) mp2.put("급여액"                             ,mp2.remove("pay_mon"                    ));else mp2.remove("pay_mon");
			    if(chkNull(mp2.get("bonus_mon"))              > 0) mp2.put("상여액"                             ,mp2.remove("bonus_mon"                  ));else mp2.remove("bonus_mon");
			    if(chkNull(mp2.get("etc_bonus_mon"))          > 0) mp2.put("인정상여"                            ,mp2.remove("etc_bonus_mon"              ));else mp2.remove("etc_bonus_mon");
			    if(chkNull(mp2.get("stock_buy_mon"))          > 0) mp2.put("주식매수선택권행사이익"                  ,mp2.remove("stock_buy_mon"              ));else mp2.remove("stock_buy_mon");
			    if(chkNull(mp2.get("stock_union_mon"))        > 0) mp2.put("우리사주조합인출금"                     ,mp2.remove("stock_union_mon"            ));else mp2.remove("stock_union_mon");
			    if(chkNull(mp2.get("imwon_ret_over_mon"))     > 0) mp2.put("임원퇴직소득금액한도초과액"               ,mp2.remove("imwon_ret_over_mon"         ));else mp2.remove("imwon_ret_over_mon");
			    if(chkNull(mp2.get("income_tax_mon"))         > 0) mp2.put("소득세"                             ,mp2.remove("income_tax_mon"             ));else mp2.remove("income_tax_mon");
			    if(chkNull(mp2.get("inhbt_tax_mon"))          > 0) mp2.put("지방소득세"                          ,mp2.remove("inhbt_tax_mon"              ));else mp2.remove("inhbt_tax_mon");
			    if(chkNull(mp2.get("rural_tax_mon"))          > 0) mp2.put("농특세"                             ,mp2.remove("rural_tax_mon"              ));else mp2.remove("rural_tax_mon");
			    if(chkNull(mp2.get("pen_mon"))                > 0) mp2.put("국민연금"                            ,mp2.remove("pen_mon"                    ));else mp2.remove("pen_mon");
			    if(chkNull(mp2.get("etc_mon1"))               > 0) mp2.put("사립학교교직원연금"                     ,mp2.remove("etc_mon1"                   ));else mp2.remove("etc_mon1");
			    if(chkNull(mp2.get("etc_mon2"))               > 0) mp2.put("공무원연금"                           ,mp2.remove("etc_mon2"                   ));else mp2.remove("etc_mon2");
			    if(chkNull(mp2.get("etc_mon3"))               > 0) mp2.put("군인연금"                            ,mp2.remove("etc_mon3"                   ));else mp2.remove("etc_mon3");
			    if(chkNull(mp2.get("etc_mon4"))               > 0) mp2.put("별정우체국연금"                        ,mp2.remove("etc_mon4"                   ));else mp2.remove("etc_mon4");
			    if(chkNull(mp2.get("hel_mon"))                > 0) mp2.put("건강보험"                            ,mp2.remove("hel_mon"                    ));else mp2.remove("hel_mon");
			    if(chkNull(mp2.get("emp_mon"))                > 0) mp2.put("고용보험"                            ,mp2.remove("emp_mon"                    ));else mp2.remove("emp_mon");
			    if(chkNull(mp2.get("notax_abroad_mon"))       > 0) mp2.put("국외비과세"                           ,mp2.remove("notax_abroad_mon"          ));else mp2.remove("notax_abroad_mon");
			    if(chkNull(mp2.get("notax_work_mon"))         > 0) mp2.put("생산직비과세"                          ,mp2.remove("notax_work_mon"            ));else mp2.remove("notax_work_mon");
			    if(chkNull(mp2.get("notax_baby_mon"))         > 0) mp2.put("보육비과세"                        ,mp2.remove("notax_baby_mon"             ));else mp2.remove("notax_baby_mon");
			    if(chkNull(mp2.get("notax_research_mon"))     > 0) mp2.put("연구보조비과세"                        ,mp2.remove("notax_research_mon"         ));else mp2.remove("notax_research_mon");
			    if(chkNull(mp2.get("notax_forn_mon"))         > 0) mp2.put("외국인비과세"                         ,mp2.remove("notax_forn_mon"             ));else mp2.remove("notax_forn_mon");
			    if(chkNull(mp2.get("notax_reporter_mon"))     > 0) mp2.put("취재수당비과세"                        ,mp2.remove("notax_reporter_mon"         ));else mp2.remove("notax_reporter_mon");
			    if(chkNull(mp2.get("notax_train_mon"))        > 0) mp2.put("수련보조수당비과세"                     ,mp2.remove("notax_train_mon"            ));else mp2.remove("notax_train_mon");
			    if(chkNull(mp2.get("notax_etc_mon"))          > 0) mp2.put("기타비과세"                           ,mp2.remove("notax_etc_mon"              ));else mp2.remove("notax_etc_mon");
			    if(chkNull(mp2.get("mon"))                    > 0) mp2.put("금액"                               ,mp2.remove("mon"                        ));else mp2.remove("mon");
			    if(chkNull(mp2.get("tax_mon"))                > 0) mp2.put("과세금액"                            ,mp2.remove("tax_mon"                    ));else mp2.remove("tax_mon");
			    if(chkNull(mp2.get("notax_mon"))              > 0) mp2.put("비과세금액"                           ,mp2.remove("notax_mon"                  ));else mp2.remove("notax_mon");
			    if(chkNull(mp2.get("org_nm"))                 > 0) mp2.put("소속"                               ,mp2.remove("org_nm"                     ));else mp2.remove("org_nm");
			    if(chkNull(mp2.get("total"))                  > 0) mp2.put("총급여"                              ,mp2.remove("total"                      ));else mp2.remove("total");
			    if(chkNull(mp2.get("notax_food_mon"))         > 0) mp2.put("식대비과세"                           ,mp2.remove("notax_food_mon"             ));else mp2.remove("notax_food_mon");
			    if(chkNull(mp2.get("notax_car_mon"))          > 0) mp2.put("차량비과세"                           ,mp2.remove("notax_car_mon"              ));else mp2.remove("notax_car_mon");
			    if(chkNull(mp2.get("notax_nightduty_mon"))    > 0) mp2.put("일직료비과세"                          ,mp2.remove("notax_nightduty_mon"        ));else mp2.remove("notax_nightduty_mon");
			    if(chkNull(mp2.get("notax_total"))            > 0) mp2.put("비과세계"                             ,mp2.remove("notax_total"                ));else mp2.remove("notax_total");
			    if(chkNull(mp2.get("exmpt_tax_mon"))          > 0) mp2.put("감면세액"                             ,mp2.remove("exmpt_tax_mon"              ));else mp2.remove("exmpt_tax_mon");
			    if(chkNull(mp2.get("frgn_tax_plus_mon"))      > 0) mp2.put("외국인납세보전"                         ,mp2.remove("frgn_tax_plus_mon"          ));else mp2.remove("frgn_tax_plus_mon");
			    if(chkNull(mp2.get("frgn_pay_ymd"))           > 0) mp2.put("국외지급일자"                          ,mp2.remove("frgn_pay_ymd"               ));else mp2.remove("frgn_pay_ymd");
			    if(chkNull(mp2.get("frgn_mon"))               > 0) mp2.put("외화"                                ,mp2.remove("frgn_mon"                   ));else mp2.remove("frgn_mon");
			    if(chkNull(mp2.get("frgn_ntax_mon"))          > 0) mp2.put("원화"                                ,mp2.remove("frgn_ntax_mon"              ));else mp2.remove("frgn_ntax_mon");
			    if(chkNull(mp2.get("labor_mon"))              > 0) mp2.put("기부금"                               ,mp2.remove("labor_mon"                  ));else mp2.remove("labor_mon");
			    if(chkNull(mp2.get("ym"))                     > 0) mp2.put("지급월"                               ,mp2.remove("ym"                         ));else mp2.remove("ym");
			    if(chkNull(mp2.get("memo"))                   > 0) mp2.put("비고"                                ,mp2.remove("memo"                        ));else mp2.remove("memo");
			    if(chkNull(mp2.get("donation_yy"))            > 0) mp2.put("기부연도"                             ,mp2.remove("donation_yy"                ));else mp2.remove("donation_yy");
			    if(chkNull(mp2.get("donation_mon"))           > 0) mp2.put("기부금액"                             ,mp2.remove("donation_mon"               ));else mp2.remove("donation_mon");
			    if(chkNull(mp2.get("prev_ded_mon"))           > 0) mp2.put("전년까지 공제된금액"                     ,mp2.remove("prev_ded_mon"               ));else mp2.remove("prev_ded_mon");
			    if(chkNull(mp2.get("cur_ded_mon"))            > 0) mp2.put("공제대상금액"                          ,mp2.remove("cur_ded_mon"                ));else mp2.remove("cur_ded_mon");
			    if(chkNull(mp2.get("ded_mon"))                > 0) mp2.put("해당연도금액"                          ,mp2.remove("ded_mon"                    ));else mp2.remove("ded_mon");
			    if(chkNull(mp2.get("extinction_mon"))         > 0) mp2.put("소멸금액"                             ,mp2.remove("extinction_mon"             ));else mp2.remove("extinction_mon");
			    if(chkNull(mp2.get("carried_mon"))            > 0) mp2.put("이월금액"                             ,mp2.remove("carried_mon"                ));else mp2.remove("carried_mon");
			    if(chkNull(mp2.get("chg_yn"))                 > 0) mp2.put("금액값에디트여부"                       ,mp2.remove("chg_yn"                     ));else mp2.remove("chg_yn");
			    if(chkNull(mp2.get("input_mon"))              > 0) mp2.put("금액"                                ,mp2.remove("input_mon"                  ));else mp2.remove("input_mon");
			    if(chkNull(mp2.get("searchPeriodType"))       > 0) mp2.put("월구간"                               ,mp2.remove("searchPeriodType"           ));else mp2.remove("searchPeriodType");
			    if(chkNull(mp2.get("searchPeriodType1"))      > 0) mp2.put("월구간"                               ,mp2.remove("searchPeriodType1"           ));else mp2.remove("searchPeriodType1");
			    if(chkNull(mp2.get("data_yn"))                > 0) mp2.put("자료여부"                             ,mp2.remove("data_yn"                     ));else mp2.remove("data_yn");
			    if(chkNull(mp2.get("data_mon"))               > 0) mp2.put("자료금액"                             ,mp2.remove("data_mon"                    ));else mp2.remove("data_mon");
			    if(chkNull(mp2.get("data_cnt"))               > 0) mp2.put("자료인원"                             ,mp2.remove("data_cnt"                    ));else mp2.remove("data_cnt");
			    if(chkNull(mp2.get("searchAgeChk"))           > 0) mp2.put("50세이상확인유무"                       ,mp2.remove("searchAgeChk"               ));else mp2.remove("searchAgeChk");
			    if(chkNull(mp2.get("cpn_yea_paytot_yn"))      > 0) mp2.put("연간소득 탭 사용 여부"                     ,mp2.remove("cpn_yea_paytot_yn"            ));else mp2.remove("cpn_yea_paytot_yn");
			    if(chkNull(mp2.get("cpn_yea_paytax_ins_yn"))  > 0) mp2.put("원천징수세액등 조정 신청 사용 여부"            ,mp2.remove("cpn_yea_paytax_ins_yn"        ));else mp2.remove("cpn_yea_paytax_ins_yn");
			    if(chkNull(mp2.get("cpn_yea_paytax_yn"))      > 0) mp2.put("원천징수세액등 분납 신청사용 여부"             ,mp2.remove("cpn_yea_paytax_yn"            ));else mp2.remove("cpn_yea_paytax_yn");
			    if(chkNull(mp2.get("cpn_work_income_print_button")) > 0) mp2.put("개인 원천징수영수증 출력버튼 표시여부"     ,mp2.remove("cpn_work_income_print_button" ));else mp2.remove("cpn_work_income_print_button");
			    if(chkNull(mp2.get("cpn_yea_jingsuja_type"))  > 0) mp2.put("원천징수영수증 징수의무자 구분"               ,mp2.remove("cpn_yea_jingsuja_type"        ));else mp2.remove("cpn_yea_jingsuja_type");
			    if(chkNull(mp2.get("cpn_yea_mon_show_yn"))    > 0) mp2.put("연말정산 총급여 확인 버튼 보여주기 유무"         ,mp2.remove("cpn_yea_mon_show_yn"          ));else mp2.remove("cpn_yea_mon_show_yn");
			    if(chkNull(mp2.get("cpn_yea_pdf_yn"))         > 0) mp2.put("pdf 업로드 탭 보여주기 유무"                ,mp2.remove("cpn_yea_pdf_yn"               ));else mp2.remove("cpn_yea_pdf_yn");
			    if(chkNull(mp2.get("cpn_monpay_return_yn"))   > 0) mp2.put("연간급여재생성 여부"                       ,mp2.remove("cpn_monpay_return_yn"         ));else mp2.remove("cpn_monpay_return_yn");
			    if(chkNull(mp2.get("cpn_yea_retro_yn"))       > 0) mp2.put("연말정산 총급여 합산시 소급포함 여부"           ,mp2.remove("cpn_yea_retro_yn"             ));else mp2.remove("cpn_yea_retro_yn");
			    if(chkNull(mp2.get("cpn_yea_add_file_yn"))    > 0) mp2.put("파일첨부탭 사용 여부"                      ,mp2.remove("cpn_yea_add_file_yn"           ));else mp2.remove("cpn_yea_add_file_yn");
			    if(chkNull(mp2.get("cpn_yea_ded_print_yn"))   > 0) mp2.put("연말정산 소득공제서 작성방법 출력여부"          ,mp2.remove("cpn_yea_ded_print_yn"          ));else mp2.remove("cpn_yea_ded_print_yn");
			    if(chkNull(mp2.get("cpn_yea_dojang_type"))    > 0) mp2.put("원천징수영수증 도장 종류"                   ,mp2.remove("cpn_yea_dojang_type"           ));else mp2.remove("cpn_yea_dojang_type");
			    if(chkNull(mp2.get("cpn_yea_hou_info_yn"))    > 0) mp2.put("1주택 추가정보 사용 여부"                   ,mp2.remove("cpn_yea_hou_info_yn"           ));else mp2.remove("cpn_yea_hou_info_yn");
			    if(chkNull(mp2.get("yeacalclst_stamp_yn"))    > 0) mp2.put("계산내역 도장 출력 여부"                    ,mp2.remove("yeacalclst_stamp_yn"           ));else mp2.remove("yeacalclst_stamp_yn");
			    if(chkNull(mp2.get("cpn_tax_cutval_button"))  > 0) mp2.put("연말정산결정세액절사구분"                   ,mp2.remove("cpn_tax_cutval_button"         ));else mp2.remove("cpn_tax_cutval_button");
			    if(chkNull(mp2.get("cpn_yea_prework_yn"))     > 0) mp2.put("종전근무지 탭 사용 여부"                    ,mp2.remove("cpn_yea_prework_yn"            ));else mp2.remove("cpn_yea_prework_yn");
			    if(chkNull(mp2.get("cpn_family_yn"))          > 0) mp2.put("연말정산가족사항추출"                      ,mp2.remove("cpn_family_yn"                 ));else mp2.remove("cpn_family_yn");
			    if(chkNull(mp2.get("cpn_yea_sim_yn"))         > 0) mp2.put("연말정산 개인 시뮬레이션 기능사용여부"          ,mp2.remove("cpn_yea_sim_yn"                ));else mp2.remove("cpn_yea_sim_yn");
			    if(chkNull(mp2.get("cpn_yea_feedback_yn"))    > 0) mp2.put("연말정산 피드백 버튼 보여주기 유무"            ,mp2.remove("cpn_yea_feedback_yn"            ));else mp2.remove("cpn_yea_feedback_yn");
			    if(chkNull(mp2.get("sht2_CurrPayMon"))        > 0) mp2.put("주(현)급여"                           ,mp2.remove("sht2_CurrPayMon"             ));else mp2.remove("sht2_CurrPayMon");
			    if(chkNull(mp2.get("sht2_CurrBonusMon"))      > 0) mp2.put("주(현)상여"                           ,mp2.remove("sht2_CurrBonusMon"           ));else mp2.remove("sht2_CurrBonusMon");
			    if(chkNull(mp2.get("sht2_CurrEtcBonusMon"))   > 0) mp2.put("주(현)인정상여"                        ,mp2.remove("sht2_CurrEtcBonusMon"        ));else mp2.remove("sht2_CurrEtcBonusMon");
			    if(chkNull(mp2.get("sht2_CurrStockBuyMon"))   > 0) mp2.put("주(현)주식매수선택권행사이익"              ,mp2.remove("sht2_CurrStockBuyMon"        ));else mp2.remove("sht2_CurrStockBuyMon");
			    if(chkNull(mp2.get("sht2_CurrStockSnionMon")) > 0) mp2.put("주(현)우리사주조합인출금"                 ,mp2.remove("sht2_CurrStockSnionMon"      ));else mp2.remove("sht2_CurrStockSnionMon");
			    if(chkNull(mp2.get("sht2_CurrImwonRetOverMon")) > 0) mp2.put("주(현)임원퇴직소득금액한도초과액"          ,mp2.remove("sht2_CurrImwonRetOverMon"    ));else mp2.remove("sht2_CurrImwonRetOverMon");
			    if(chkNull(mp2.get("sht2_CurrTotMon"))        > 0) mp2.put("주(현) 계"                           ,mp2.remove("sht2_CurrTotMon"              ));else mp2.remove("sht2_CurrTotMon");
			    if(chkNull(mp2.get("sht2_PrePayMon"))         > 0) mp2.put("종(전)급여"                           ,mp2.remove("sht2_PrePayMon"               ));else mp2.remove("sht2_PrePayMon");
			    if(chkNull(mp2.get("sht2_PreBonusMon"))       > 0) mp2.put("종(전)상여"                           ,mp2.remove("sht2_PreBonusMon"             ));else mp2.remove("sht2_PreBonusMon");
			    if(chkNull(mp2.get("sht2_PreEtcBonusMon"))    > 0) mp2.put("종(전)인정상여"                        ,mp2.remove("sht2_PreEtcBonusMon"          ));else mp2.remove("sht2_PreEtcBonusMon");
			    if(chkNull(mp2.get("sht2_PreStockBuyMon"))    > 0) mp2.put("종(전)주식매수선택권행사이익"              ,mp2.remove("sht2_PreStockBuyMon"          ));else mp2.remove("sht2_PreStockBuyMon");
			    if(chkNull(mp2.get("sht2_PreStockSnionMon"))  > 0) mp2.put("종(전)우리사주조합인출금"                 ,mp2.remove("sht2_PreStockSnionMon"        ));else mp2.remove("sht2_PreStockSnionMon");
			    if(chkNull(mp2.get("sht2_PreImwonRetOverMon"))> 0) mp2.put("종(전)임원퇴직소득금액한도초과액"           ,mp2.remove("sht2_PreImwonRetOverMon"      ));else mp2.remove("sht2_PreImwonRetOverMon");
			    if(chkNull(mp2.get("sht2_PreTotMon"))         > 0) mp2.put("종(전) 계"                           ,mp2.remove("sht2_PreTotMon"               ));else mp2.remove("sht2_PreTotMon");
			    if(chkNull(mp2.get("sumPayMon"))              > 0) mp2.put("합계 급여"                            ,mp2.remove("sumPayMon"                    ));else mp2.remove("sumPayMon");
			    if(chkNull(mp2.get("sumBonusMon"))            > 0) mp2.put("합계 상여"                            ,mp2.remove("sumBonusMon"                  ));else mp2.remove("sumBonusMon");
			    if(chkNull(mp2.get("sumEtcBonusMon"))         > 0) mp2.put("합계 인정상여"                         ,mp2.remove("sumEtcBonusMon"               ));else mp2.remove("sumEtcBonusMon");
			    if(chkNull(mp2.get("sumStockBuyMon"))         > 0) mp2.put("합계 주식매수선택권행사이익"               ,mp2.remove("sumStockBuyMon"               ));else mp2.remove("sumStockBuyMon");
			    if(chkNull(mp2.get("sumStockSnionMon"))       > 0) mp2.put("합계 우리사주조합인출금"                  ,mp2.remove("sumStockSnionMon"             ));else mp2.remove("sumStockSnionMon");
			    if(chkNull(mp2.get("sumImwonRetOverMon"))     > 0) mp2.put("합계 임원퇴직소득금액한도초과액"            ,mp2.remove("sumImwonRetOverMon"           ));else mp2.remove("sumImwonRetOverMon");
			    if(chkNull(mp2.get("sumTotMon"))              > 0) mp2.put("합계 계"                                   ,mp2.remove("sumTotMon"                     ));else mp2.remove("sumTotMon");
			    if(chkNull(mp2.get("sht2_CurrNotaxAbroadMon"))> 0) mp2.put("주(현) 국외근로"                           ,mp2.remove("sht2_CurrNotaxAbroadMon"       ));else mp2.remove("sht2_CurrNotaxAbroadMon");
			    if(chkNull(mp2.get("sht2_CurrNotaxBabyMon"))  > 0) mp2.put("주(현) 보육"                           ,mp2.remove("sht2_CurrNotaxBabyMon"         ));else mp2.remove("sht2_CurrNotaxBabyMon");
			    if(chkNull(mp2.get("sht2_CurrNotaxWorkMon"))  > 0) mp2.put("주(현) 생산(야간근로)"                     ,mp2.remove("sht2_CurrNotaxWorkMon"         ));else mp2.remove("sht2_CurrNotaxWorkMon");
			    if(chkNull(mp2.get("sht2_CurrNotaxFornMon"))  > 0) mp2.put("주(현) 외국인"                             ,mp2.remove("sht2_CurrNotaxFornMon"         ));else mp2.remove("sht2_CurrNotaxFornMon");
			    if(chkNull(mp2.get("sht2_CurrNotaxResMon"))   > 0) mp2.put("주(현) 연구보조비"                         ,mp2.remove("sht2_CurrNotaxResMon"          ));else mp2.remove("sht2_CurrNotaxResMon");
			    if(chkNull(mp2.get("sht2_CurrNotaxEtcMon"))   > 0) mp2.put("주(현) 수련보조수당"                       ,mp2.remove("sht2_CurrNotaxEtcMon"          ));else mp2.remove("sht2_CurrNotaxEtcMon");
			    if(chkNull(mp2.get("sht2_CurrNotaxExtMon"))   > 0) mp2.put("주(현) 그밖의비과세"                       ,mp2.remove("sht2_CurrNotaxExtMon"          ));else mp2.remove("sht2_CurrNotaxExtMon");
			    if(chkNull(mp2.get("sht2_CurrNotaxTotMon"))   > 0) mp2.put("주(현) 계"                                 ,mp2.remove("sht2_CurrNotaxTotMon"          ));else mp2.remove("sht2_CurrNotaxTotMon");
			    if(chkNull(mp2.get("sht2_PreNotaxAbroadMon")) > 0) mp2.put("종(전) 국외근로"                           ,mp2.remove("sht2_PreNotaxAbroadMon"        ));else mp2.remove("sht2_PreNotaxAbroadMon");
			    if(chkNull(mp2.get("sht2_PreNotaxBabyMon"))   > 0) mp2.put("종(전) 보육"                           ,mp2.remove("sht2_PreNotaxBabyMon"          ));else mp2.remove("sht2_PreNotaxBabyMon");
			    if(chkNull(mp2.get("sht2_PreNotaxWorkMon"))   > 0) mp2.put("종(전) 생산(야간근로)"                     ,mp2.remove("sht2_PreNotaxWorkMon"          ));else mp2.remove("sht2_PreNotaxWorkMon");
			    if(chkNull(mp2.get("sht2_PreNotaxFornMon"))   > 0) mp2.put("종(전) 외국인"                             ,mp2.remove("sht2_PreNotaxFornMon"          ));else mp2.remove("sht2_PreNotaxFornMon");
			    if(chkNull(mp2.get("sht2_PreNotaxResMon"))    > 0) mp2.put("종(전) 연구보조비"                         ,mp2.remove("sht2_PreNotaxResMon"           ));else mp2.remove("sht2_PreNotaxResMon");
			    if(chkNull(mp2.get("sht2_PreNotaxEtcMon"))    > 0) mp2.put("종(전) 수련보조수당"                       ,mp2.remove("sht2_PreNotaxEtcMon"           ));else mp2.remove("sht2_PreNotaxEtcMon");
			    if(chkNull(mp2.get("sht2_PreNotaxExtMon"))    > 0) mp2.put("종(전) 그밖의비과세"                       ,mp2.remove("sht2_PreNotaxExtMon"           ));else mp2.remove("sht2_PreNotaxExtMon");
			    if(chkNull(mp2.get("sht2_PreNotaxTotMon"))    > 0) mp2.put("종(전) 계"                                 ,mp2.remove("sht2_PreNotaxTotMon"           ));else mp2.remove("sht2_PreNotaxTotMon");
			    if(chkNull(mp2.get("sht2_NotaxTotMon"))       > 0) mp2.put("비과세총계"                                ,mp2.remove("sht2_NotaxTotMon"              ));else mp2.remove("sht2_NotaxTotMon");
			    if(chkNull(mp2.get("sht2_FinIncomeTax"))      > 0) mp2.put("결정세액 소득세"                           ,mp2.remove("sht2_FinIncomeTax"             ));else mp2.remove("sht2_FinIncomeTax");
			    if(chkNull(mp2.get("sht2_FinInbitTaxMon"))    > 0) mp2.put("결정세액 지방소득세"                       ,mp2.remove("sht2_FinInbitTaxMon"           ));else mp2.remove("sht2_FinInbitTaxMon");
			    if(chkNull(mp2.get("sht2_FinAgrclTaxMon"))    > 0) mp2.put("결정세액 농어촌특별세"                     ,mp2.remove("sht2_FinAgrclTaxMon"           ));else mp2.remove("sht2_FinAgrclTaxMon");
			    if(chkNull(mp2.get("sht2_FinSum"))            > 0) mp2.put("결정세액 계"                               ,mp2.remove("sht2_FinSum"                   ));else mp2.remove("sht2_FinSum");
			    if(chkNull(mp2.get("sht2_PreIncomeTax"))      > 0) mp2.put("종(전)근무지 소득세"                       ,mp2.remove("sht2_PreIncomeTax"             ));else mp2.remove("sht2_PreIncomeTax");
			    if(chkNull(mp2.get("sht2_PreInbitTaxMon"))    > 0) mp2.put("종(전)근무지 지방소득세"                   ,mp2.remove("sht2_PreInbitTaxMon"           ));else mp2.remove("sht2_PreInbitTaxMon");
			    if(chkNull(mp2.get("sht2_PreAgrclTaxMon"))    > 0) mp2.put("종(전)근무지 농어촌특별세"                 ,mp2.remove("sht2_PreAgrclTaxMon"           ));else mp2.remove("sht2_PreAgrclTaxMon");
			    if(chkNull(mp2.get("sht2_PreSum"))            > 0) mp2.put("종(전)근무지 계"                           ,mp2.remove("sht2_PreSum"                   ));else mp2.remove("sht2_PreSum");
			    if(chkNull(mp2.get("sht2_CurrIncomeTax"))     > 0) mp2.put("주(현)근무지 소득세"                       ,mp2.remove("sht2_CurrIncomeTax"            ));else mp2.remove("sht2_CurrIncomeTax");
			    if(chkNull(mp2.get("sht2_CurrInbitTaxMon"))   > 0) mp2.put("주(현)근무지 지방소득세"                   ,mp2.remove("sht2_CurrInbitTaxMon"          ));else mp2.remove("sht2_CurrInbitTaxMon");
			    if(chkNull(mp2.get("sht2_CurrAgrclTaxMon"))   > 0) mp2.put("주(현)근무지 농어촌특별세"                 ,mp2.remove("sht2_CurrAgrclTaxMon"          ));else mp2.remove("sht2_CurrAgrclTaxMon");
			    if(chkNull(mp2.get("sht2_CurrSum"))           > 0) mp2.put("주(현)근무지 계"                           ,mp2.remove("sht2_CurrSum"                  ));else mp2.remove("sht2_CurrSum");
			    if(chkNull(mp2.get("sht2_SpcIncomeTaxMon"))   > 0) mp2.put("납부특례세액 소득세"                       ,mp2.remove("sht2_SpcIncomeTaxMon"          ));else mp2.remove("sht2_SpcIncomeTaxMon");
			    if(chkNull(mp2.get("sht2_SpcInbitTaxMon"))    > 0) mp2.put("납부특례세액 지방소득세"                   ,mp2.remove("sht2_SpcInbitTaxMon"           ));else mp2.remove("sht2_SpcInbitTaxMon");
			    if(chkNull(mp2.get("sht2_SpcAgrclTaxMon"))    > 0) mp2.put("납부특례세액 농어촌특별세"                 ,mp2.remove("sht2_SpcAgrclTaxMon"           ));else mp2.remove("sht2_SpcAgrclTaxMon");
			    if(chkNull(mp2.get("sht2_SpcSum"))            > 0) mp2.put("납부특례세액 계"                           ,mp2.remove("sht2_SpcSum"                   ));else mp2.remove("sht2_SpcSum");
			    if(chkNull(mp2.get("sht2_BlcIncomeTax"))      > 0) mp2.put("차감징수세액 소득세"                       ,mp2.remove("sht2_BlcIncomeTax"             ));else mp2.remove("sht2_BlcIncomeTax");
			    if(chkNull(mp2.get("sht2_BlcInbitTaxMon"))    > 0) mp2.put("차감징수세액 지방소득세"                   ,mp2.remove("sht2_BlcInbitTaxMon"           ));else mp2.remove("sht2_BlcInbitTaxMon");
			    if(chkNull(mp2.get("sht2_BlcAgrclTaxMon"))    > 0) mp2.put("차감징수세액 농어촌특별세"                 ,mp2.remove("sht2_BlcAgrclTaxMon"           ));else mp2.remove("sht2_BlcAgrclTaxMon");
			    if(chkNull(mp2.get("sht2_BlcSum"))            > 0) mp2.put("차감징수세액 계"                           ,mp2.remove("sht2_BlcSum"                   ));else mp2.remove("sht2_BlcSum");
			    if(chkNull(mp2.get("sht2_TaxablePayMon"))     > 0) mp2.put("총 급 여( 과세대상급여 )"                  ,mp2.remove("sht2_TaxablePayMon"            ));else mp2.remove("sht2_TaxablePayMon");
			    if(chkNull(mp2.get("sht5_A000_01"))           > 0) mp2.put("근로소득공제"                              ,mp2.remove("sht5_A000_01"                  ));else mp2.remove("sht5_A000_01");
			    if(chkNull(mp2.get("sht2_IncomeMon"))         > 0) mp2.put("근로소득금액"                              ,mp2.remove("sht2_IncomeMon"                ));else mp2.remove("sht2_IncomeMon");
			    if(chkNull(mp2.get("sht5_A010_01"))           > 0) mp2.put("기본공제 본인(공제)"                       ,mp2.remove("sht5_A010_01"                  ));else mp2.remove("sht5_A010_01");
			    if(chkNull(mp2.get("sht5_A010_03"))           > 0) mp2.put("기본공제 배우자(공제)"                     ,mp2.remove("sht5_A010_03"                  ));else mp2.remove("sht5_A010_03");
			    if(chkNull(mp2.get("sht5_A010_11_CNT"))       > 0) mp2.put("기본공제 부양가족"                         ,mp2.remove("sht5_A010_11_CNT"              ));else mp2.remove("sht5_A010_11_CNT");
			    if(chkNull(mp2.get("sht5_A010_11"))           > 0) mp2.put("기본공제 부양가족(공제)"                   ,mp2.remove("sht5_A010_11"                  ));else mp2.remove("sht5_A010_11");
			    if(chkNull(mp2.get("sht5_A020_03_CNT"))       > 0) mp2.put("기본공제 경로우대"                         ,mp2.remove("sht5_A020_03_CNT"              ));else mp2.remove("sht5_A020_03_CNT");
			    if(chkNull(mp2.get("sht5_A020_04"))           > 0) mp2.put("추가공제 경로우대(공제)"                   ,mp2.remove("sht5_A020_04"                  ));else mp2.remove("sht5_A020_04");
			    if(chkNull(mp2.get("sht5_A020_05_CNT"))       > 0) mp2.put("추가공제  장애인"                          ,mp2.remove("sht5_A020_05_CNT"              ));else mp2.remove("sht5_A020_05_CNT");
			    if(chkNull(mp2.get("sht5_A020_05"))           > 0) mp2.put("추가공제  장애인(공제)"                    ,mp2.remove("sht5_A020_05"                  ));else mp2.remove("sht5_A020_05");
			    if(chkNull(mp2.get("sht5_A020_07"))           > 0) mp2.put("추가공제 부녀자(공제)"                     ,mp2.remove("sht5_A020_07"                  ));else mp2.remove("sht5_A020_07");
			    if(chkNull(mp2.get("sht5_A020_14"))           > 0) mp2.put("추가공제 한부모가족(공제)"                 ,mp2.remove("sht5_A020_14"                  ));else mp2.remove("sht5_A020_14");
			    if(chkNull(mp2.get("sht5_A030_01_INP"))       > 0) mp2.put("국민연금보험료(입력)"                      ,mp2.remove("sht5_A030_01_INP"              ));else mp2.remove("sht5_A030_01_INP");
			    if(chkNull(mp2.get("sht5_A030_01"))           > 0) mp2.put("국민연금보험료(공제)"                      ,mp2.remove("sht5_A030_01"                  ));else mp2.remove("sht5_A030_01");
			    if(chkNull(mp2.get("sht5_A030_11_INP"))       > 0) mp2.put("공무원연금(입력)"                          ,mp2.remove("sht5_A030_11_INP"              ));else mp2.remove("sht5_A030_11_INP");
			    if(chkNull(mp2.get("sht5_A030_11"))           > 0) mp2.put("공무원연금(공제)"                          ,mp2.remove("sht5_A030_11"                  ));else mp2.remove("sht5_A030_11");
			    if(chkNull(mp2.get("sht5_A030_12_INP"))       > 0) mp2.put("군인연금(입력)"                            ,mp2.remove("sht5_A030_12_INP"              ));else mp2.remove("sht5_A030_12_INP");
			    if(chkNull(mp2.get("sht5_A030_12"))           > 0) mp2.put("군인연금(공제)"                            ,mp2.remove("sht5_A030_12"                  ));else mp2.remove("sht5_A030_12");
			    if(chkNull(mp2.get("sht5_A030_02_INP"))       > 0) mp2.put("사립학교교직원연금(입력)"                  ,mp2.remove("sht5_A030_02_INP"              ));else mp2.remove("sht5_A030_02_INP");
			    if(chkNull(mp2.get("sht5_A030_02"))           > 0) mp2.put("사립학교교직원연금(공제)"                  ,mp2.remove("sht5_A030_02"                  ));else mp2.remove("sht5_A030_02");
			    if(chkNull(mp2.get("sht5_A030_13_INP"))       > 0) mp2.put("별정우체국연금(입력)"                      ,mp2.remove("sht5_A030_13_INP"              ));else mp2.remove("sht5_A030_13_INP");
			    if(chkNull(mp2.get("sht5_A030_13"))           > 0) mp2.put("별정우체국연금(공제)"                      ,mp2.remove("sht5_A030_13"                  ));else mp2.remove("sht5_A030_13");
			    if(chkNull(mp2.get("sht5_A040_03_INP"))       > 0) mp2.put("건강보험료(입력)"                          ,mp2.remove("sht5_A040_03_INP"              ));else mp2.remove("sht5_A040_03_INP");
			    if(chkNull(mp2.get("sht5_A040_03"))           > 0) mp2.put("건강보험료(공제)"                          ,mp2.remove("sht5_A040_03"                  ));else mp2.remove("sht5_A040_03");
			    if(chkNull(mp2.get("sht5_A040_04_INP"))       > 0) mp2.put("고용보험료(입력)"                          ,mp2.remove("sht5_A040_04_INP"              ));else mp2.remove("sht5_A040_04_INP");
			    if(chkNull(mp2.get("sht5_A040_04"))           > 0) mp2.put("고용보험료(공제)"                          ,mp2.remove("sht5_A040_04"                  ));else mp2.remove("sht5_A040_04");
			    if(chkNull(mp2.get("sht5_A070_13"))           > 0) mp2.put("원리금상환액(대출기관)(입력)"              ,mp2.remove("sht5_A070_13"                  ));else mp2.remove("sht5_A070_13");
			    if(chkNull(mp2.get("sht5_A070_14"))           > 0) mp2.put("원리금상환액(대출기관)(공제)"              ,mp2.remove("sht5_A070_14"                  ));else mp2.remove("sht5_A070_14");
			    if(chkNull(mp2.get("sht5_A070_19"))           > 0) mp2.put("원리금상환액(거주자)(입력)"                ,mp2.remove("sht5_A070_19"                  ));else mp2.remove("sht5_A070_19");
			    if(chkNull(mp2.get("sht5_A070_21"))           > 0) mp2.put("원리금상환액(거주자)(공제)"                ,mp2.remove("sht5_A070_21"                  ));else mp2.remove("sht5_A070_21");
			    if(chkNull(mp2.get("sht5_A070_17_INP"))       > 0) mp2.put("2011년 이전(15년미만)(입력)"                        ,mp2.remove("sht5_A070_17_INP"             ));else mp2.remove("sht5_A070_17_INP");
			    if(chkNull(mp2.get("sht5_A070_17"))           > 0) mp2.put("2011년 이전(15년미만)(공제)"                        ,mp2.remove("sht5_A070_17"                 ));else mp2.remove("sht5_A070_17");
				if(chkNull(mp2.get("sht5_A070_15_INP"))       > 0) mp2.put("2011년 이전(15년이상)(입력)"                       ,mp2.remove("sht5_A070_15_INP"             ));else mp2.remove("sht5_A070_15_INP");
				if(chkNull(mp2.get("sht5_A070_15"))           > 0) mp2.put("2011년 이전(15년이상)(공제)"                       ,mp2.remove("sht5_A070_15"                 ));else mp2.remove("sht5_A070_15");
				if(chkNull(mp2.get("sht5_A070_16_INP"))       > 0) mp2.put("2011년 이전(30년이상)(입력)"                        ,mp2.remove("sht5_A070_16_INP"             ));else mp2.remove("sht5_A070_16_INP");
				if(chkNull(mp2.get("sht5_A070_16"))           > 0) mp2.put("2011년 이전(30년이상)(공제)"                        ,mp2.remove("sht5_A070_16"                 ));else mp2.remove("sht5_A070_16");
				if(chkNull(mp2.get("sht5_A070_22_INP"))       > 0) mp2.put("2011년 이후(고정금리&비거치상환)(입력)"             ,mp2.remove("sht5_A070_22_INP"             ));else mp2.remove("sht5_A070_22_INP");
				if(chkNull(mp2.get("sht5_A070_22"))           > 0) mp2.put("2011년 이후(고정금리&비거치상환)(공제)"             ,mp2.remove("sht5_A070_22"                 ));else mp2.remove("sht5_A070_22");
				if(chkNull(mp2.get("sht5_A070_23_INP"))       > 0) mp2.put("2011년 이후(고정금리/비거치상환)(입력)"                       ,mp2.remove("sht5_A070_23_INP"             ));else mp2.remove("sht5_A070_23_INP");
				if(chkNull(mp2.get("sht5_A070_23"))           > 0) mp2.put("2011년 이후(고정금리/비거치상환)(입력)"                       ,mp2.remove("sht5_A070_23"                 ));else mp2.remove("sht5_A070_23");
				if(chkNull(mp2.get("sht5_A070_24_INP"))       > 0) mp2.put("2012년 이후(15년이상 고정&비거치 상환)(입력)"       ,mp2.remove("sht5_A070_24_INP"             ));else mp2.remove("sht5_A070_24_INP");
				if(chkNull(mp2.get("sht5_A070_24"))           > 0) mp2.put("2012년 이후(15년이상 고정&비거치 상환)(공제)"       ,mp2.remove("sht5_A070_24"                 ));else mp2.remove("sht5_A070_24");
				if(chkNull(mp2.get("sht5_A070_25_INP"))       > 0) mp2.put("2012년 이후(15년이상 고정/비거치 상환)(입력)"       ,mp2.remove("sht5_A070_25_INP"             ));else mp2.remove("sht5_A070_25_INP");
				if(chkNull(mp2.get("sht5_A070_25"))           > 0) mp2.put("2012년 이후(15년이상 고정/비거치 상환)(공제)"       ,mp2.remove("sht5_A070_25"                 ));else mp2.remove("sht5_A070_25");
				if(chkNull(mp2.get("sht5_A070_26_INP"))       > 0) mp2.put("2012년 이후(15년이상 기타대출)(입력)"               ,mp2.remove("sht5_A070_26_INP"             ));else mp2.remove("sht5_A070_26_INP");
				if(chkNull(mp2.get("sht5_A070_26"))           > 0) mp2.put("2012년 이후(15년이상 기타대출)(공제)"               ,mp2.remove("sht5_A070_26"                 ));else mp2.remove("sht5_A070_26");
				if(chkNull(mp2.get("sht5_A070_27_INP"))       > 0) mp2.put("2012년 이후(10년이상 고정/비거치 상환)(입력)"       ,mp2.remove("sht5_A070_27_INP"             ));else mp2.remove("sht5_A070_27_INP");
				if(chkNull(mp2.get("sht5_A070_27"))           > 0) mp2.put("2012년 이후(10년이상 고정/비거치 상환)(공제)"       ,mp2.remove("sht5_A070_27"                 ));else mp2.remove("sht5_A070_27");
			    if(chkNull(mp2.get("sht5_A099_02"))           > 0) mp2.put("계"                                        ,mp2.remove("sht5_A099_02"                  ));else mp2.remove("sht5_A099_02");
			    if(chkNull(mp2.get("sht2_BlnceIncomeMon"))    > 0) mp2.put("차감소득금액"                              ,mp2.remove("sht2_BlnceIncomeMon"           ));else mp2.remove("sht2_BlnceIncomeMon");
			    if(chkNull(mp2.get("sht5_A100_03_INP"))       > 0) mp2.put("개인연금저축(입력)"                        ,mp2.remove("sht5_A100_03_INP"              ));else mp2.remove("sht5_A100_03_INP");
			    if(chkNull(mp2.get("sht5_A100_03"))           > 0) mp2.put("개인연금저축(공제)"                        ,mp2.remove("sht5_A100_03"                  ));else mp2.remove("sht5_A100_03");
			    if(chkNull(mp2.get("sht5_A100_30_INP"))       > 0) mp2.put("소기업ㆍ소상공인 공제부금 소득공제(입력)"  ,mp2.remove("sht5_A100_30_INP"              ));else mp2.remove("sht5_A100_30_INP");
			    if(chkNull(mp2.get("sht5_A100_30"))           > 0) mp2.put("소기업ㆍ소상공인 공제부금 소득공제(공제)"  ,mp2.remove("sht5_A100_30"                  ));else mp2.remove("sht5_A100_30");
			    if(chkNull(mp2.get("sht5_A100_34_INP"))       > 0) mp2.put("주택마련저축(입력)"                        ,mp2.remove("sht5_A100_34_INP"              ));else mp2.remove("sht5_A100_34_INP");
			    if(chkNull(mp2.get("sht5_A100_34"))           > 0) mp2.put("주택마련저축(공제)"                        ,mp2.remove("sht5_A100_34"                  ));else mp2.remove("sht5_A100_34");
			    if(chkNull(mp2.get("sht5_A100_31_INP"))       > 0) mp2.put("주택청약종합저축(입력)"                    ,mp2.remove("sht5_A100_31_INP"              ));else mp2.remove("sht5_A100_31_INP");
			    if(chkNull(mp2.get("sht5_A100_31"))           > 0) mp2.put("주택청약종합저축(공제)"                    ,mp2.remove("sht5_A100_31"                  ));else mp2.remove("sht5_A100_31");
			    if(chkNull(mp2.get("sht5_A100_33_INP"))       > 0) mp2.put("근로자주택마련저축(입력)"                  ,mp2.remove("sht5_A100_33_INP"              ));else mp2.remove("sht5_A100_33_INP");
			    if(chkNull(mp2.get("sht5_A100_33"))           > 0) mp2.put("근로자주택마련저축(공제)"                  ,mp2.remove("sht5_A100_33"                  ));else mp2.remove("sht5_A100_33");
			    if(chkNull(mp2.get("sht5_A100_73"))           > 0) mp2.put("투자조합(2018.1.1 ~ 2018.12.31)간접출자"   ,mp2.remove("sht5_A100_73"                  ));else mp2.remove("sht5_A100_73");
			    if(chkNull(mp2.get("sht5_A100_74"))           > 0) mp2.put("투자조합(2018.1.1 ~ 2018.12.31)직접출자"   ,mp2.remove("sht5_A100_74"                  ));else mp2.remove("sht5_A100_74");
			    if(chkNull(mp2.get("sht5_A100_07"))           > 0) mp2.put("투자조합 출자공제"                         ,mp2.remove("sht5_A100_07"                  ));else mp2.remove("sht5_A100_07");
			    if(chkNull(mp2.get("sht5_A100_75"))           > 0) mp2.put("투자조합(2019.1.1 ~ 2019.12.31)간접출자 조합1"      ,mp2.remove("sht5_A100_75"                 ));else mp2.remove("sht5_A100_75");
			    if(chkNull(mp2.get("sht5_A100_79"))           > 0) mp2.put("투자조합(2019.1.1 ~ 2019.12.31)간접출자 조합2"      ,mp2.remove("sht5_A100_79"                 ));else mp2.remove("sht5_A100_79");
			    if(chkNull(mp2.get("sht5_A100_76"))           > 0) mp2.put("투자조합(2019.1.1 ~ 2019.12.31)직접출자 벤처등"     ,mp2.remove("sht5_A100_76"                 ));else mp2.remove("sht5_A100_76");
			    if(chkNull(mp2.get("sht5_A100_77"))           > 0) mp2.put("투자조합(2020.1.1 ~ 2020.12.31)간접출자 조합1"      ,mp2.remove("sht5_A100_77"                 ));else mp2.remove("sht5_A100_77");
			    if(chkNull(mp2.get("sht5_A100_80"))           > 0) mp2.put("투자조합(2020.1.1 ~ 2020.12.31)간접출자 조합2"      ,mp2.remove("sht5_A100_80"                 ));else mp2.remove("sht5_A100_80");
			    if(chkNull(mp2.get("sht5_A100_78"))           > 0) mp2.put("투자조합(2020.1.1 ~ 2020.12.31)직접출자 벤처등"     ,mp2.remove("sht5_A100_78"                 ));else mp2.remove("sht5_A100_78");
                if(chkNull(mp2.get("sht5_A100_81"))           > 0) mp2.put("투자조합(2021.1.1 ~ 2021.12.31)간접출자 조합1"      ,mp2.remove("sht5_A100_81"                 ));else mp2.remove("sht5_A100_81");
                if(chkNull(mp2.get("sht5_A100_82"))           > 0) mp2.put("투자조합(2021.1.1 ~ 2021.12.31)간접출자 조합2"      ,mp2.remove("sht5_A100_82"                 ));else mp2.remove("sht5_A100_82");
                if(chkNull(mp2.get("sht5_A100_83"))           > 0) mp2.put("투자조합(2021.1.1 ~ 2021.12.31)직접출자 벤처등"     ,mp2.remove("sht5_A100_83"                 ));else mp2.remove("sht5_A100_83");

			    if(chkNull(mp2.get("sht5_A100_15"))           > 0) mp2.put("신용카드 등"                               ,mp2.remove("sht5_A100_15"                  ));else mp2.remove("sht5_A100_15");
			    if(chkNull(mp2.get("sht5_A100_23"))           > 0) mp2.put("신용카드등사용액소득공제"                  ,mp2.remove("sht5_A100_23"                  ));else mp2.remove("sht5_A100_23");
			    if(chkNull(mp2.get("sht5_A100_13"))           > 0) mp2.put("현금영수증"                                ,mp2.remove("sht5_A100_13"                  ));else mp2.remove("sht5_A100_13");
			    if(chkNull(mp2.get("sht5_A100_22"))           > 0) mp2.put("직불카드 등"                               ,mp2.remove("sht5_A100_22"                  ));else mp2.remove("sht5_A100_22");
			    if(chkNull(mp2.get("sht5_A100_42"))           > 0) mp2.put("도서공연등사용분"                          ,mp2.remove("sht5_A100_42"                  ));else mp2.remove("sht5_A100_42");
			    if(chkNull(mp2.get("sht5_A100_14"))           > 0) mp2.put("전통시장사용분"                            ,mp2.remove("sht5_A100_14"                  ));else mp2.remove("sht5_A100_14");
			    if(chkNull(mp2.get("sht5_A100_16"))           > 0) mp2.put("대중교통이용분"                            ,mp2.remove("sht5_A100_16"                  ));else mp2.remove("sht5_A100_16");
			    if(chkNull(mp2.get("sht5_A100_17"))           > 0) mp2.put("사업관련비용"                              ,mp2.remove("sht5_A100_17"                  ));else mp2.remove("sht5_A100_17");
			    if(chkNull(mp2.get("sht5_A100_21_INP"))       > 0) mp2.put("우리사주조합 출연금(입력)"                 ,mp2.remove("sht5_A100_21_INP"              ));else mp2.remove("sht5_A100_21_INP");
			    if(chkNull(mp2.get("sht5_A100_21"))           > 0) mp2.put("우리사주조합 출연금(공제)"                 ,mp2.remove("sht5_A100_21"                  ));else mp2.remove("sht5_A100_21");
			    if(chkNull(mp2.get("sht5_A100_37_INP"))       > 0) mp2.put("고용유지 중소기업 근로자 소득공제(입력)"   ,mp2.remove("sht5_A100_37_INP"              ));else mp2.remove("sht5_A100_37_INP");
			    if(chkNull(mp2.get("sht5_A100_37"))           > 0) mp2.put("고용유지 중소기업 근로자 소득공제(공제)"   ,mp2.remove("sht5_A100_37"                  ));else mp2.remove("sht5_A100_37");
			    if(chkNull(mp2.get("sht5_A100_38_INP"))       > 0) mp2.put("목돈 안드는 전세 이자상환액(입력)"         ,mp2.remove("sht5_A100_38_INP"              ));else mp2.remove("sht5_A100_38_INP");
			    if(chkNull(mp2.get("sht5_A100_38"))           > 0) mp2.put("목돈 안드는 전세 이자상환액(공제)"         ,mp2.remove("sht5_A100_38"                  ));else mp2.remove("sht5_A100_38");
			    if(chkNull(mp2.get("sht5_A100_40_INP"))       > 0) mp2.put("장기집합투자증권저축(입력)"                ,mp2.remove("sht5_A100_40_INP"              ));else mp2.remove("sht5_A100_40_INP");
			    if(chkNull(mp2.get("sht5_A100_40"))           > 0) mp2.put("장기집합투자증권저축(공제)"                ,mp2.remove("sht5_A100_40"                  ));else mp2.remove("sht5_A100_40");
			    if(chkNull(mp2.get("sht5_A100_99"))           > 0) mp2.put("그 밖의 소득공제 계"                       ,mp2.remove("sht5_A100_99"                  ));else mp2.remove("sht5_A100_99");
			    if(chkNull(mp2.get("sht2_LIMIT_OVER_MON"))    > 0) mp2.put("특별공제 종합한도 초과액"                  ,mp2.remove("sht2_LIMIT_OVER_MON"           ));else mp2.remove("sht2_LIMIT_OVER_MON");
			    if(chkNull(mp2.get("sht2_TaxBaseMon"))        > 0) mp2.put("종합소득 과세표준"                         ,mp2.remove("sht2_TaxBaseMon"               ));else mp2.remove("sht2_TaxBaseMon");
			    if(chkNull(mp2.get("sht2_ClclteTaxMon"))      > 0) mp2.put("산출세액"                                  ,mp2.remove("sht2_ClclteTaxMon"             ));else mp2.remove("sht2_ClclteTaxMon");
			    if(chkNull(mp2.get("sht5_B010_14"))           > 0) mp2.put("소득세법"                                  ,mp2.remove("sht5_B010_14"                  ));else mp2.remove("sht5_B010_14");
			    if(chkNull(mp2.get("sht5_EX_B010_16"))        > 0) mp2.put("조세특례제한법(제30조 제외)"               ,mp2.remove("sht5_EX_B010_16"               ));else mp2.remove("sht5_EX_B010_16");
			    if(chkNull(mp2.get("sht5_B010_30_31_INP"))    > 0) mp2.put("조세특례제한법 제30조(입력)"               ,mp2.remove("sht5_B010_30_31_INP"           ));else mp2.remove("sht5_B010_30_31_INP");
			    if(chkNull(mp2.get("sht5_B010_16"))           > 0) mp2.put("조세특례제한법 제30조(공제)"               ,mp2.remove("sht5_B010_16"                  ));else mp2.remove("sht5_B010_16");
			    if(chkNull(mp2.get("sht5_B010_17"))           > 0) mp2.put("조세조약"                                  ,mp2.remove("sht5_B010_17"                  ));else mp2.remove("sht5_B010_17");
			    if(chkNull(mp2.get("sht5_B010_13"))           > 0) mp2.put("세액감면 계"                               ,mp2.remove("sht5_B010_13"                  ));else mp2.remove("sht5_B010_13");
			    if(chkNull(mp2.get("sht5_B000_01"))           > 0) mp2.put("근로소득"                                  ,mp2.remove("sht5_B000_01"                  ));else mp2.remove("sht5_B000_01");
			    if(chkNull(mp2.get("sht5_B000_10"))           > 0) mp2.put("자녀 세액공제"                             ,mp2.remove("sht5_B000_10"                  ));else mp2.remove("sht5_B000_10");
			    if(chkNull(mp2.get("sht5_B001_30_CNT"))       > 0) mp2.put("출산입양공제"                              ,mp2.remove("sht5_B001_30_CNT"              ));else mp2.remove("sht5_B001_30_CNT");
			    if(chkNull(mp2.get("sht5_B001_30"))           > 0) mp2.put("출산입양공제"                              ,mp2.remove("sht5_B001_30"                  ));else mp2.remove("sht5_B001_30");
			    if(chkNull(mp2.get("sht5_A030_04_INP"))       > 0) mp2.put("과학기술인공제 "                           ,mp2.remove("sht5_A030_04_INP"              ));else mp2.remove("sht5_A030_04_INP");
			    if(chkNull(mp2.get("sht5_A030_04_STD"))       > 0) mp2.put("과학기술인공제 공제대상금액"               ,mp2.remove("sht5_A030_04_STD"              ));else mp2.remove("sht5_A030_04_STD");
			    if(chkNull(mp2.get("sht5_A030_04"))           > 0) mp2.put("과학기술인공제 세액공제액"                 ,mp2.remove("sht5_A030_04"                  ));else mp2.remove("sht5_A030_04");
			    if(chkNull(mp2.get("sht5_A030_03_INP"))       > 0) mp2.put("근로자퇴직급여 보장법에따른 퇴직연금"               ,mp2.remove("sht5_A030_03_INP"             ));else mp2.remove("sht5_A030_03_INP");
			    if(chkNull(mp2.get("sht5_A030_03_STD"))       > 0) mp2.put("근로자퇴직급여 보장법에따른 퇴직연금 공제대상금액"  ,mp2.remove("sht5_A030_03_STD"             ));else mp2.remove("sht5_A030_03_STD");
			    if(chkNull(mp2.get("sht5_A030_03"))           > 0) mp2.put("근로자퇴직급여 보장법에따른 퇴직연금 세액공제액"    ,mp2.remove("sht5_A030_03"                 ));else mp2.remove("sht5_A030_03");
			    if(chkNull(mp2.get("sht5_A100_05_INP"))       > 0) mp2.put("연금저축"                                  ,mp2.remove("sht5_A100_05_INP"              ));else mp2.remove("sht5_A100_05_INP");
			    if(chkNull(mp2.get("sht5_A100_05_STD"))       > 0) mp2.put("연금저축 공제대상금액"                     ,mp2.remove("sht5_A100_05_STD"              ));else mp2.remove("sht5_A100_05_STD");
			    if(chkNull(mp2.get("sht5_A100_05"))           > 0) mp2.put("연금저축 세액공제액"                       ,mp2.remove("sht5_A100_05"                  ));else mp2.remove("sht5_A100_05");
			    if(chkNull(mp2.get("sht5_A040_05_INP"))       > 0) mp2.put("보장성보험료"                              ,mp2.remove("sht5_A040_05_INP"              ));else mp2.remove("sht5_A040_05_INP");
			    if(chkNull(mp2.get("sht5_A040_05_STD"))       > 0) mp2.put("보장성보험료 공제대상금액"                 ,mp2.remove("sht5_A040_05_STD"              ));else mp2.remove("sht5_A040_05_STD");
			    if(chkNull(mp2.get("sht5_A040_05"))           > 0) mp2.put("보장성보험료 세액공제액"                   ,mp2.remove("sht5_A040_05"                  ));else mp2.remove("sht5_A040_05");
			    if(chkNull(mp2.get("sht5_A040_07_INP"))       > 0) mp2.put("장애인 전용보장성보험료"                   ,mp2.remove("sht5_A040_07_INP"              ));else mp2.remove("sht5_A040_07_INP");
			    if(chkNull(mp2.get("sht5_A040_07_STD"))       > 0) mp2.put("장애인 전용보장성보험료 공제대상금액"      ,mp2.remove("sht5_A040_07_STD"              ));else mp2.remove("sht5_A040_07_STD");
			    if(chkNull(mp2.get("sht5_A040_07"))           > 0) mp2.put("장애인 전용보장성보험료 세액공제액"        ,mp2.remove("sht5_A040_07"                  ));else mp2.remove("sht5_A040_07");
			    if(chkNull(mp2.get("sht5_A050_01_INP"))       > 0) mp2.put("의료비"                                    ,mp2.remove("sht5_A050_01_INP"              ));else mp2.remove("sht5_A050_01_INP");
			    if(chkNull(mp2.get("sht5_A050_01_STD"))       > 0) mp2.put("의료비 공제대상금액"                       ,mp2.remove("sht5_A050_01_STD"              ));else mp2.remove("sht5_A050_01_STD");
			    if(chkNull(mp2.get("sht5_A050_01"))           > 0) mp2.put("의료비 세액공제액"                         ,mp2.remove("sht5_A050_01"                  ));else mp2.remove("sht5_A050_01");
			    if(chkNull(mp2.get("sht5_A060_01_INP"))       > 0) mp2.put("교육비"                                    ,mp2.remove("sht5_A060_01_INP"              ));else mp2.remove("sht5_A060_01_INP");
			    if(chkNull(mp2.get("sht5_A060_01_STD"))       > 0) mp2.put("교육비 공제대상금액"                       ,mp2.remove("sht5_A060_01_STD"              ));else mp2.remove("sht5_A060_01_STD");
			    if(chkNull(mp2.get("sht5_A060_01"))           > 0) mp2.put("교육비 세액공제액"                         ,mp2.remove("sht5_A060_01"                  ));else mp2.remove("sht5_A060_01");
			    if(chkNull(mp2.get("sht5_A080_05_INP"))       > 0) mp2.put("정치자금기부금 (10만원이하)"               ,mp2.remove("sht5_A080_05_INP"              ));else mp2.remove("sht5_A080_05_INP");
			    if(chkNull(mp2.get("sht5_B010_05_STD"))       > 0) mp2.put("정치자금기부금 (10만원이하) 공제대상금액"  ,mp2.remove("sht5_B010_05_STD"              ));else mp2.remove("sht5_B010_05_STD");
			    if(chkNull(mp2.get("sht5_B010_05"))           > 0) mp2.put("정치자금기부금 (10만원이하) 세액공제액"    ,mp2.remove("sht5_B010_05"                  ));else mp2.remove("sht5_B010_05");
			    if(chkNull(mp2.get("sht5_A080_05_STD"))       > 0) mp2.put("정치자금기부금 (10만원초과) 공제대상금액"  ,mp2.remove("sht5_A080_05_STD"              ));else mp2.remove("sht5_A080_05_STD");
			    if(chkNull(mp2.get("sht5_A080_05"))           > 0) mp2.put("정치자금기부금 (10만원초과) 세액공제액"    ,mp2.remove("sht5_A080_05"                  ));else mp2.remove("sht5_A080_05");
			    if(chkNull(mp2.get("sht5_A080_03_INP"))       > 0) mp2.put("법정기부금"                                ,mp2.remove("sht5_A080_03_INP"              ));else mp2.remove("sht5_A080_03_INP");
			    if(chkNull(mp2.get("sht5_A080_03_STD"))       > 0) mp2.put("법정기부금 공제대상금액"                   ,mp2.remove("sht5_A080_03_STD"              ));else mp2.remove("sht5_A080_03_STD");
			    if(chkNull(mp2.get("sht5_A080_03"))           > 0) mp2.put("법정기부금 세액공제액"                     ,mp2.remove("sht5_A080_03"                  ));else mp2.remove("sht5_A080_03");
			    if(chkNull(mp2.get("sht5_A080_09_INP"))       > 0) mp2.put("우리사주조합 기부금"                       ,mp2.remove("sht5_A080_09_INP"              ));else mp2.remove("sht5_A080_09_INP");
			    if(chkNull(mp2.get("sht5_A080_09_STD"))       > 0) mp2.put("우리사주조합 기부금 공제대상금액"          ,mp2.remove("sht5_A080_09_STD"              ));else mp2.remove("sht5_A080_09_STD");
			    if(chkNull(mp2.get("sht5_A080_09"))           > 0) mp2.put("우리사주조합 기부금 세액공제액"            ,mp2.remove("sht5_A080_09"                  ));else mp2.remove("sht5_A080_09");
			    if(chkNull(mp2.get("sht5_A080_10_11_INP"))    > 0) mp2.put("지정기부금"                                ,mp2.remove("sht5_A080_10_11_INP"           ));else mp2.remove("sht5_A080_10_11_INP");
			    if(chkNull(mp2.get("sht5_A080_13_STD"))       > 0) mp2.put("지정기부금 공제대상금액"                   ,mp2.remove("sht5_A080_13_STD"              ));else mp2.remove("sht5_A080_13_STD");
			    if(chkNull(mp2.get("sht5_A080_13"))           > 0) mp2.put("지정기부금 세액공제액"                     ,mp2.remove("sht5_A080_13"                  ));else mp2.remove("sht5_A080_13");
			    if(chkNull(mp2.get("sht5_B013_01"))           > 0) mp2.put("특별세액공제 계"                           ,mp2.remove("sht5_B013_01"                  ));else mp2.remove("sht5_B013_01");
			    if(chkNull(mp2.get("sht5_A099_01"))           > 0) mp2.put("표준세액공제"                              ,mp2.remove("sht5_A099_01"                  ));else mp2.remove("sht5_A099_01");
			    if(chkNull(mp2.get("sht5_B010_01_INP"))       > 0) mp2.put("납세조합공제 공제대상금액"                 ,mp2.remove("sht5_B010_01_INP"              ));else mp2.remove("sht5_B010_01_INP");
			    if(chkNull(mp2.get("sht5_B010_01"))           > 0) mp2.put("납세조합공제 세액공제액"                   ,mp2.remove("sht5_B010_01"                  ));else mp2.remove("sht5_B010_01");
			    if(chkNull(mp2.get("sht5_B010_03_INP"))       > 0) mp2.put("주택차입금 공제대상금액"                   ,mp2.remove("sht5_B010_03_INP"              ));else mp2.remove("sht5_B010_03_INP");
			    if(chkNull(mp2.get("sht5_B010_03"))           > 0) mp2.put("주택차입금 세액공제액"                     ,mp2.remove("sht5_B010_03"                  ));else mp2.remove("sht5_B010_03");
			    if(chkNull(mp2.get("sht5_B010_09"))           > 0) mp2.put("외국납부"                                  ,mp2.remove("sht5_B010_09"                  ));else mp2.remove("sht5_B010_09");
			    if(chkNull(mp2.get("sht5_B010_07"))           > 0) mp2.put("외국납부 공제대상금액"                     ,mp2.remove("sht5_B010_07"                  ));else mp2.remove("sht5_B010_07");
			    if(chkNull(mp2.get("sht5_B010_11"))           > 0) mp2.put("외국납부 세액공제액"                       ,mp2.remove("sht5_B010_11"                  ));else mp2.remove("sht5_B010_11");
			    if(chkNull(mp2.get("sht5_A070_10_INP"))       > 0) mp2.put("월세"                                      ,mp2.remove("sht5_A070_10_INP"              ));else mp2.remove("sht5_A070_10_INP");
			    if(chkNull(mp2.get("sht5_A070_10_STD"))       > 0) mp2.put("월세 공제대상금액"                         ,mp2.remove("sht5_A070_10_STD"              ));else mp2.remove("sht5_A070_10_STD");
			    if(chkNull(mp2.get("sht5_A070_10"))           > 0) mp2.put("월세 세액공제액"                           ,mp2.remove("sht5_A070_10"                  ));else mp2.remove("sht5_A070_10");
			    if(chkNull(mp2.get("sht2_TotTaxDeductMon"))   > 0) mp2.put("세액공제 계"                               ,mp2.remove("sht2_TotTaxDeductMon"          ));else mp2.remove("sht2_TotTaxDeductMon");
			    if(chkNull(mp2.get("sht2_FinIncomeTax2"))     > 0) mp2.put("결정세액"                                  ,mp2.remove("sht2_FinIncomeTax2"            ));else mp2.remove("sht2_FinIncomeTax2");
			    if(chkNull(mp2.get("sht2_EffTaxRate"))        > 0) mp2.put("실효세율"                                  ,mp2.remove("sht2_EffTaxRate"               ));else mp2.remove("sht2_EffTaxRate");
			    if(chkNull(mp2.get("check_nm"))               > 0) mp2.put("재계산"                                    ,mp2.remove("check_nm"                      ));else mp2.remove("check_nm");
			    if(chkNull(mp2.get("searchYMD"))              > 0) mp2.put("기준일자"                                  ,mp2.remove("searchYMD"                     ));else mp2.remove("searchYMD");
			    if(chkNull(mp2.get("tax_grp_yn"))             > 0) mp2.put("단위과세여부"                              ,mp2.remove("tax_grp_yn"                    ));else mp2.remove("tax_grp_yn");
			    if(chkNull(mp2.get("sub_regino"))             > 0) mp2.put("종사업자일련번호"                          ,mp2.remove("sub_regino"                    ));else mp2.remove("sub_regino");
			    if(chkNull(mp2.get("regino"))                 > 0) mp2.put("주사업장등록번호"                          ,mp2.remove("regino"                        ));else mp2.remove("regino");
			    if(chkNull(mp2.get("business_place_nm"))      > 0) mp2.put("사업장명"                                  ,mp2.remove("business_place_nm"             ));else mp2.remove("business_place_nm");
			    if(chkNull(mp2.get("searchFinalCloseYN"))     > 0) mp2.put("마감여부"                                  ,mp2.remove("searchFinalCloseYN"            ));else mp2.remove("searchFinalCloseYN");
			    if(chkNull(mp2.get("searchMonthFrom"))        > 0) mp2.put("대상년월 From"                             ,mp2.remove("searchMonthFrom"               ));else mp2.remove("searchMonthFrom");
			    if(chkNull(mp2.get("searchMonthTo"))          > 0) mp2.put("대상년월 To"                               ,mp2.remove("searchMonthTo"                 ));else mp2.remove("searchMonthTo");
			    if(chkNull(mp2.get("pay_ym"))                 > 0) mp2.put("대상년월"                                  ,mp2.remove("pay_ym"                        ));else mp2.remove("pay_ym");
			    if(chkNull(mp2.get("ord_symd"))               > 0) mp2.put("발령기준일 시작일"                         ,mp2.remove("ord_symd"                      ));else mp2.remove("ord_symd");
			    if(chkNull(mp2.get("ord_eymd"))               > 0) mp2.put("발령기준일 종료일"                         ,mp2.remove("ord_eymd"                      ));else mp2.remove("ord_eymd");
			    if(chkNull(mp2.get("payment_ymd"))            > 0) mp2.put("지급일자"                                  ,mp2.remove("payment_ymd"                   ));else mp2.remove("payment_ymd");
			    if(chkNull(mp2.get("addType"))                > 0) mp2.put("주소구분"                                  ,mp2.remove("addType"                       ));else mp2.remove("addType");
			    if(chkNull(mp2.get("chk"))                    > 0) mp2.put("선택"                                      ,mp2.remove("chk"                           ));else mp2.remove("chk");
			    if(chkNull(mp2.get("detail_cnt"))             > 0) mp2.put("확인필요건수"                              ,mp2.remove("detail_cnt"                    ));else mp2.remove("detail_cnt");
			    if(chkNull(mp2.get("searchOption"))           > 0) mp2.put("사대보험출력여부"                          ,mp2.remove("searchOption"                  ));else mp2.remove("searchOption");
			    if(chkNull(mp2.get("searchReCalcSeq"))        > 0) mp2.put("재계산 차수 값"                            ,mp2.remove("searchReCalcSeq"               ));else mp2.remove("searchReCalcSeq");
			    if(chkNull(mp2.get("tipText"))                > 0) mp2.put("TIP내용"                                   ,mp2.remove("tipText"                       ));else mp2.remove("tipText");
			    if(chkNull(mp2.get("searchPayPeopleStatus"))  > 0) mp2.put("급여대상자상태"                            ,mp2.remove("searchPayPeopleStatus"         ));else mp2.remove("searchPayPeopleStatus");
			    if(chkNull(mp2.get("searchFamCd_s"))          > 0) mp2.put("가족관계코드"                              ,mp2.remove("searchFamCd_s"                 ));else mp2.remove("searchFamCd_s");
			    if(chkNull(mp2.get("searchNote1"))            > 0) mp2.put("비고"                                      ,mp2.remove("searchNote1"                   ));else mp2.remove("searchNote1");
			    if(chkNull(mp2.get("stdCd"))                  > 0) mp2.put("기준코드"                                  ,mp2.remove("stdCd"                         ));else mp2.remove("stdCd");
			    if(chkNull(mp2.get("stdNm"))                  > 0) mp2.put("기준코드명"                                ,mp2.remove("stdNm"                         ));else mp2.remove("stdNm");
			    if(chkNull(mp2.get("std_cd"))                 > 0) mp2.put("기준코드"                                  ,mp2.remove("std_cd"                        ));else mp2.remove("std_cd");
			    if(chkNull(mp2.get("std_nm"))                 > 0) mp2.put("기준코드명"                                ,mp2.remove("std_nm"                        ));else mp2.remove("std_nm");
			    if(chkNull(mp2.get("stdCdValue"))             > 0) mp2.put("기준코드값"                                ,mp2.remove("stdCdValue"                    ));else mp2.remove("stdCdValue");
			    if(chkNull(mp2.get("std_cd_value"))           > 0) mp2.put("기준코드값"                                ,mp2.remove("std_cd_value"                  ));else mp2.remove("std_cd_value");
			    if(chkNull(mp2.get("searchHalfGubun"))        > 0) mp2.put("반기구분"                                  ,mp2.remove("searchHalfGubun"               ));else mp2.remove("searchHalfGubun");
			    if(chkNull(mp2.get("searchCardType"))         > 0) mp2.put("카드구분"                                  ,mp2.remove("searchCardType"                ));else mp2.remove("searchCardType");
			    if(chkNull(mp2.get("searchAdjElNm"))          > 0) mp2.put("항목명"                                    ,mp2.remove("searchAdjElNm"                 ));else mp2.remove("searchAdjElNm");
			    if(chkNull(mp2.get("searchMenuNm"))           > 0) mp2.put("메뉴명"                                    ,mp2.remove("searchMenuNm"                  ));else mp2.remove("searchMenuNm");
			    if(chkNull(mp2.get("searchServiceNm"))        > 0) mp2.put("서비스명"                                  ,mp2.remove("searchServiceNm"               ));else mp2.remove("searchServiceNm");
			    if(chkNull(mp2.get("srchAdjProcessCd"))       > 0) mp2.put("프로세스코드"                              ,mp2.remove("srchAdjProcessCd"              ));else mp2.remove("srchAdjProcessCd");
			    if(chkNull(mp2.get("adj_process_cd"))         > 0) mp2.put("프로세스코드"                              ,mp2.remove("adj_process_cd"                ));else mp2.remove("adj_process_cd");
			    if(chkNull(mp2.get("adj_process_nm"))         > 0) mp2.put("프로세스명"                                ,mp2.remove("adj_process_nm"                ));else mp2.remove("adj_process_nm");
		        if(chkNull(mp2.get("help_text1"))             > 0) mp2.put("도움말1"                                   ,mp2.remove("help_text1"                    ));else mp2.remove("help_text1");
		        if(chkNull(mp2.get("help_text2"))             > 0) mp2.put("도움말2"                                   ,mp2.remove("help_text2"                    ));else mp2.remove("help_text2");
		        if(chkNull(mp2.get("help_text3"))             > 0) mp2.put("도움말3"                                   ,mp2.remove("help_text3"                    ));else mp2.remove("help_text3");
		        if(chkNull(mp2.get("adj_element_nm"))         > 0) mp2.put("항목명"                                    ,mp2.remove("adj_element_nm"                ));else mp2.remove("adj_element_nm");
		        if(chkNull(mp2.get("income_data_yn"))         > 0) mp2.put("소득자료여부"                              ,mp2.remove("income_data_yn"                ));else mp2.remove("income_data_yn");
		        if(chkNull(mp2.get("adj_data_yn"))            > 0) mp2.put("정산자료여부"                              ,mp2.remove("adj_data_yn"                   ));else mp2.remove("adj_data_yn");
		        if(chkNull(mp2.get("ded_data_yn"))            > 0) mp2.put("공제자료여부"                              ,mp2.remove("ded_data_yn"                   ));else mp2.remove("ded_data_yn");
		        if(chkNull(mp2.get("tax_rate_cd"))            > 0) mp2.put("세율"                                      ,mp2.remove("tax_rate_cd"                   ));else mp2.remove("tax_rate_cd");
			    if(chkNull(mp2.get("attr1"))                  > 0) mp2.put("attr1"                                     ,mp2.remove("attr1"                         ));else mp2.remove("attr1");
			    if(chkNull(mp2.get("attr2"))                  > 0) mp2.put("attr2"                                     ,mp2.remove("attr2"                         ));else mp2.remove("attr2");
			    if(chkNull(mp2.get("attr3"))                  > 0) mp2.put("attr3"                                     ,mp2.remove("attr3"                         ));else mp2.remove("attr3");
			    if(chkNull(mp2.get("attr4"))                  > 0) mp2.put("attr4"                                     ,mp2.remove("attr4"                         ));else mp2.remove("attr4");
		        if(chkNull(mp2.get("srchIncomeTypeTxt"))      > 0) mp2.put("소득구분명"                                ,mp2.remove("srchIncomeTypeTxt"             ));else mp2.remove("srchIncomeTypeTxt");
		        if(chkNull(mp2.get("searchElemNm"))           > 0) mp2.put("항목코드/명"                               ,mp2.remove("searchElemNm"                  ));else mp2.remove("searchElemNm");
		        if(chkNull(mp2.get("searchYn"))               > 0) mp2.put("여부값"                                    ,mp2.remove("searchYn"                      ));else mp2.remove("searchYn");
		        if(chkNull(mp2.get("element_cd1"))            > 0) mp2.put("항목코드"                                  ,mp2.remove("element_cd1"                   ));else mp2.remove("element_cd1");
		        if(chkNull(mp2.get("element_cd2"))            > 0) mp2.put("항목코드"                                  ,mp2.remove("element_cd2"                   ));else mp2.remove("element_cd2");
		        if(chkNull(mp2.get("element_cd3"))            > 0) mp2.put("항목코드"                                  ,mp2.remove("element_cd3"                   ));else mp2.remove("element_cd3");
		        if(chkNull(mp2.get("element_nm1"))            > 0) mp2.put("항목명"                                    ,mp2.remove("element_nm1"                   ));else mp2.remove("element_nm1");
		        if(chkNull(mp2.get("element_nm2"))            > 0) mp2.put("항목명"                                    ,mp2.remove("element_nm2"                   ));else mp2.remove("element_nm2");
		        if(chkNull(mp2.get("element_nm3"))            > 0) mp2.put("항목명"                                    ,mp2.remove("element_nm3"                   ));else mp2.remove("element_nm3");
		        if(chkNull(mp2.get("searchUseYyyy"))          > 0) mp2.put("사용연도"                                  ,mp2.remove("searchUseYyyy"                 ));else mp2.remove("searchUseYyyy");

		        if(chkNull(mp2.get("cpn_yea_add_file_del"))   > 0) mp2.put("파일삭제 오픈여부"                         ,mp2.remove("cpn_yea_add_file_del"          ));else mp2.remove("cpn_yea_add_file_del");
		        if(chkNull(mp2.get("cpn_yea_add_file_down"))  > 0) mp2.put("파일삭제 다운로드여부"                     ,mp2.remove("cpn_yea_add_file_down"         ));else mp2.remove("cpn_yea_add_file_down");
		        if(chkNull(mp2.get("cpn_yea_add_file_upload"))> 0) mp2.put("파일삭제 업로드여부"                       ,mp2.remove("cpn_yea_add_file_upload"       ));else mp2.remove("cpn_yea_add_file_upload");
		        if(chkNull(mp2.get("file_path"))              > 0) mp2.put("파일경로"                                  ,mp2.remove("file_path"                     ));else mp2.remove("file_path");
		        if(chkNull(mp2.get("fileSeq"))                > 0) mp2.put("파일시퀀스"                                ,mp2.remove("fileSeq"                       ));else mp2.remove("fileSeq");
		        if(chkNull(mp2.get("file_seq"))               > 0) mp2.put("파일시퀀스"                                ,mp2.remove("file_seq"                      ));else mp2.remove("file_seq");
		        if(chkNull(mp2.get("fileType"))               > 0) mp2.put("파일타입"                                  ,mp2.remove("fileType"                      ));else mp2.remove("fileType");
		        if(chkNull(mp2.get("file_type"))              > 0) mp2.put("파일타입"                                  ,mp2.remove("file_type"                     ));else mp2.remove("file_type");
                if(chkNull(mp2.get("file_name"))              > 0) mp2.put("파일명"                                    ,mp2.remove("file_name"                     ));else mp2.remove("file_name");
                if(chkNull(mp2.get("feedback"))               > 0) mp2.put("피드백"                                    ,mp2.remove("feedback"                      ));else mp2.remove("feedback");
                if(chkNull(mp2.get("nm_txt"))                 > 0) mp2.put("대상자성명"                                ,mp2.remove("nm_txt"                        ));else mp2.remove("nm_txt");
                if(chkNull(mp2.get("searchNmTxt"))            > 0) mp2.put("대상자성명"                                ,mp2.remove("searchNmTxt"                   ));else mp2.remove("searchNmTxt");
                if(chkNull(mp2.get("status_cd"))              > 0) mp2.put("상태값"                                    ,mp2.remove("status_cd"                     ));else mp2.remove("status_cd");
                if(chkNull(mp2.get("upload_date"))            > 0) mp2.put("수정날짜"                                  ,mp2.remove("upload_date"                   ));else mp2.remove("upload_date");
                if(chkNull(mp2.get("attr1"))                  > 0) mp2.put("파일명"                                    ,mp2.remove("attr1"                         ));else mp2.remove("attr1");

			    if(chkNull(mp2.get("sht5_ISA_MON_INP"))       > 0) mp2.put("ISA 추가납입액"                            ,mp2.remove("sht5_ISA_MON_INP"              ));else mp2.remove("sht5_ISA_MON_INP");
			    if(chkNull(mp2.get("sht5_ISA_MON_STD"))       > 0) mp2.put("ISA 추가납입액 공제대상금액"               ,mp2.remove("sht5_ISA_MON_STD"                  ));else mp2.remove("sht5_ISA_MON_STD");
			    if(chkNull(mp2.get("sht5_ISA_MON"))           > 0) mp2.put("ISA 추가납입액 세액공제액"                 ,mp2.remove("sht5_ISA_MON"                      ));else mp2.remove("sht5_ISA_MON");
			    if(chkNull(mp2.get("searchPenAcctYn"))        > 0) mp2.put("연금계좌건수여부"                        ,mp2.remove("searchPenAcctYn"                   ));else mp2.remove("searchPenAcctYn");
                if(chkNull(mp2.get("searchPenAcctChk"))       > 0) mp2.put("연금계좌확인"                           ,mp2.remove("searchPenAcctChk"                  ));else mp2.remove("searchPenAcctChk");
                if(chkNull(mp2.get("searchExceptYn"))         > 0) mp2.put("신고제외여부"                           ,mp2.remove("searchExceptYn"                  ));else mp2.remove("searchExceptYn");
                mp2.remove("ibsCheck");
                mp2.remove("reduceChk");

			    //사용자가 직접 트랜젝션 관리(조회)
			    if(conFlag) con.setAutoCommit(false);

			    //param 글자수 제한
			    String mpStr = mp2.toString();
			    if(mpStr.length() > 1500) mpStr = mpStr.substring(0, 1500)+"...";
			    try{
	                con.prepareStatement( "INSERT INTO TYEA993(ENTER_CD, WORK_YY, SEQ, SABUN, LOG_TYPE, MENU_NM, LOG_MEMO, CHKID) VALUES("
	                        + "'"+ mp.get("ssnEnterCd") +"'"
	                        + ",'"+ pWorkYy +"'"
	                        + ", (SELECT NVL(MAX(SEQ),0)+1 FROM TYEA993 WHERE ENTER_CD = '"+ mp.get("ssnEnterCd") +"' AND WORK_YY='"+ pWorkYy +"')"
	                        + ", NVL("+sabunStr+",'"+mp.get("ssnSabun") + "')"
	                        + ", '"+sStatus +"'"
	                        + ", '"+menuNm+"'"
	                        + ", '"+mpStr.replaceAll("'", "''")+"'"
	                        + ", '"+mp.get("ssnSabun") + "'"
	                        + ")" ).executeUpdate();
		            con.commit();
			    } catch(Exception e) {
			        try{
			            con.rollback();
			        }catch (Exception e1){
			            throw new Exception();
			        }
			    } finally {
			    	DBConn.closeConnection(null, ps, rs);
			    }
			}
	    } catch(Exception e){
	        throw new Exception();
	    } finally {
	        //사용자가 직접 트랜젝션 관리(조회)
	        if(conFlag) DBConn.closeConnection(con, null, null);
	    }
    }
}
%>