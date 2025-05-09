<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>신용카드</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ include file="yeaDataCommon.jsp"%>

<%String orgAuthPg = request.getParameter("orgAuthPg");%>
<%String buttonColor1 = "pink";%>
<%String buttonColor2 = "button";%>
<%String buttonColor3 = "button";%>

<script type="text/javascript">
	var orgAuthPg = "<%=removeXSS(orgAuthPg, '1')%>";

	//도움말
	var helpText;
	//기준년도
	var systemYY;
	//총급여 확인 버튼 유무
	var yeaMonShowYn ;
	//신용,직/선불카드 - 개인별 총급여
	var paytotMonStr ;
	//본인 코드
	var gOwnFamCd;

	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";

	//대상자 전부 조회
	var famAllList;

	//공제대상자만 조회
	var famList;
	var adjInputTypeList;
	var feedbackTypeList;

	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		/*필수 기본 세팅*/
		$("#searchWorkYy").val(	 $("#searchWorkYy", parent.document).val()	   ) ;
		$("#searchAdjustType").val( $("#searchAdjustType", parent.document).val()   ) ;
		$("#searchSabun").val(	  $("#searchSabun", parent.document).val()		) ;
		systemYY = $("#searchWorkYy", parent.document).val();

		$("#viewHtml").hide() ;
	    $('#debitMon').mask('000,000,000,000,000', {reverse: true});
	    $('#cashMon').mask('000,000,000,000,000', {reverse: true});
	    $('#cardMon').mask('000,000,000,000,000', {reverse: true});

        $("#ntsIn").mask('000,000,000,000,000', {reverse: true});
        $("#ntsMn").mask('000,000,000,000,000', {reverse: true});
        $("#etcSum").mask('000,000,000,000,000', {reverse: true});

		$("#adminYnText").html( "담당자 입력 적용" ) ;

		//$("#debitMon").addClass("transparent").attr("readonly", true) ;
		//$("#cashMon").addClass("transparent").attr("readonly", true) ;
		//$("#cardMon").addClass("transparent").attr("readonly", true) ;
		$("#debitMon").attr("readonly", false) ;
		$("#cashMon").attr("readonly", false) ;
		$("#cardMon").attr("readonly", false) ;

		/*코드 조회*/
		//대상자 전부 조회
		$("#searchFamCd_s").val("");
		famAllList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getFamCodeList&queryId=getFamCodeList",$("#sheetForm").serialize(),false).codeList, "");

		//공제대상자만 조회
		$("#searchFamCd_s").val(",'6','7','8'");
		famList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getFamCodeCardList&queryId=getFamCodeCardList",$("#sheetForm").serialize(),false).codeList, "");
		adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "");
		feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00329"), "");

		//기본정보 조회(도움말 등등).
		initDefaultData() ;
<%--
		if(orgAuthPg == "A") {
			$("#copyBtn").show() ;
		} else {
			$("#copyBtn").hide() ;
		}
--%>
		//총급여 옵션이 Y이면 총급여 버튼 보여준다.
		if( yeaMonShowYn == "Y"){
			$("#paytotMonViewYn").show() ;
		}else if(yeaMonShowYn == "A"){
			if(orgAuthPg == "A") {
				$("#paytotMonViewYn").show() ;
			}else{
				$("#paytotMonViewYn").hide() ;
			}

		}else{
			$("#paytotMonViewYn").hide() ;
		}

		$("#searchYyType").bind("change", function(){
			if( $(this).val() == "0" || $(this).val() == "-99") {
				sheet2.SetColEditable("famres",	1);
			} else {
				sheet2.SetColEditable("famres",	0);
			}

			// 반기구분 코드 조회
			var halfGubunList = stfConvCode(ajaxCall("<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectYeaDataCardsHalfGubun", "searchYyType="+ $(this).val(), false).codeList, "");
			//신용카드구분 코드 조회
			var cardTypeList = stfConvCode(ajaxCall("<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectYeaDataCardCardType", "searchYyType="+ $(this).val(), false).codeList, "");

			sheet2.SetColProperty("half_gubun",	 {ComboText:"|"+halfGubunList[0], ComboCode:"|"+halfGubunList[1]} );
			sheet2.SetColProperty("card_type",	  {ComboText:"|"+cardTypeList[0], ComboCode:"|"+cardTypeList[1]} );

			//양식다운로드 title 정의
			templeteTitle2 = "업로드시 이 행은 삭제 합니다\n\n";
			var codeCdNm = "", codeCd = "", codeNm = "";

			codeCdNm = "";
			codeNm = halfGubunList[0].split("|"); codeCd = halfGubunList[1].split("|");
			for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
			templeteTitle2 += "반기구분 : " + codeCdNm + "\n";

			codeCdNm = "";
			codeNm = cardTypeList[0].split("|"); codeCd = cardTypeList[1].split("|");
			for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
			templeteTitle2 += "카드구분 : " + codeCdNm + "\n";

			templeteTitle2 += "국세청 자료여부 : Y, N \n";

			codeCdNm = "";
			codeNm = feedbackTypeList[0].split("|"); codeCd = feedbackTypeList[1].split("|");
			for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
			templeteTitle2 += "담당자확인 : " + codeCdNm + "\n";

			doAction2("Search");
		});
		$("#searchYyType").html("<option value='0'>"+ systemYY +"년도</option>"
			+ "<option value='-1'>"+ (systemYY * 1 - 1) +"년도</option>"
			+ "<option value='-2'>"+ (systemYY * 1 - 2) +"년도</option>"
			+ "<option value='-99'>전체</option>"
		);

	});

	$(function() {
<%--
		var inputEdit = 0 ;
		var applEdit = 0 ;
		if( orgAuthPg == "A") {
			inputEdit = 0 ;
			applEdit = 1 ;
		} else {
			inputEdit = 1 ;
			applEdit = 0 ;
		}
--%>
<%
String inputEdit = "0", applEdit = "0";
if( "Y".equals(adminYn) ) {
	inputEdit = "0";
	applEdit = "1";
} else{
	inputEdit = "1";
	applEdit = "0";
}
%>
		load_sheet1();
		load_sheet2();
		load_sheet3();

		$(window).smartresize(sheetResize);
		sheetInit();
		//2020-12-23. 담당자 마감일때 수정 불가 처리
		var empStatus = $("#tdStatusView>font:first", parent.document).attr("class");
		if(orgAuthPg == "A" && (empStatus == "close_3" || empStatus == "close_4")) {
			$("#btnDisplayYn01").hide() ;
            sheet1.SetEditable(false) ;
            sheet2.SetEditable(false) ;
            sheet3.SetEditable(false) ;
		}
		parent.doSearchCommonSheet();
		doAction1("Search");
		doAction2("Search");
	});

	//본인 정보 조회
	function getOwnDataInfo() {

		var ownDataInfo = ajaxCall("<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectOwnDataInfo", $("#sheetForm").serialize(),false);

		gOwnFamCd = nvl(ownDataInfo.Data.own_fam_cd,"");
	}

	//전년도 합계 정보 조회
	function getPreYeaDataInfo_2014() {

		var preyeaInfo = ajaxCall("<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectPreYeaDataInfo_2014", $("#sheetForm").serialize(),false);

		$("#preTotSum_2014").val(nvl(preyeaInfo.Data.pre_tot_sum,"0"));
		$("#billSum_2014").val(nvl(preyeaInfo.Data.bill_sum,"0"));
		$("#checkSum_2014").val(nvl(preyeaInfo.Data.check_sum,"0")) ;
		$("#marketSum_2014").val(nvl(preyeaInfo.Data.market_sum,"0")) ;
		$("#busSum_2014").val(nvl(preyeaInfo.Data.bus_sum,"0")) ;
		$("#checkBillSum_2014").val(nvl(preyeaInfo.Data.check_bill_sum,"0")) ;
	}

	//전전년도 합계 정보 조회
	function getPreYeaDataInfo_2013() {

		var preyeaInfo = ajaxCall("<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectPreYeaDataInfo_2013", $("#sheetForm").serialize(),false);

		$("#preTotSum_2013").val(nvl(preyeaInfo.Data.pre_tot_sum,"0"));
		$("#billSum_2013").val(nvl(preyeaInfo.Data.bill_sum,"0"));
		$("#checkSum_2013").val(nvl(preyeaInfo.Data.check_sum,"0")) ;
		$("#marketSum_2013").val(nvl(preyeaInfo.Data.market_sum,"0")) ;
		$("#busSum_2013").val(nvl(preyeaInfo.Data.bus_sum,"0")) ;
		$("#checkBillSum_2013").val(nvl(preyeaInfo.Data.check_bill_sum,"0")) ;
	}


	function validate_chk(shtObj) {

		try{
			for ( var i = shtObj.HeaderRows(); i <= shtObj.LastRow(); i++ ) {
				if ( shtObj.GetCellValue(i, "sStatus") == "I" || shtObj.GetCellValue(i, "sStatus") == "U" ) {
					//명의인
					if ( !famres_chk(shtObj, i, "Save") ) return false;
					//반기구분
					if ( !half_gubun_chk(shtObj, i, "Save") ) return false;
					//신용카드구분
					if ( !card_type_chk(shtObj, i, "Save") ) return false;
				}
			}

		} catch(ex){
			alert("validate_chk Event Error : " + ex);
			return false;
		}

		return true;
	}

	function famres_chk(shtObj, Row, gubun) {

		// 신용카드구분이 2014 일 경우, 명의인이 본인이 아닌경우
		var cardType = shtObj.GetCellText(Row, "card_type");
		if( (typeof cardType === "string" && cardType.indexOf("2014") > -1)
			&& (shtObj.GetCellValue(Row, "famres") != gOwnFamCd) ) {

			alert("2014(본인) 신용카드구분의 대상은 다음과 같습니다.\n카드 탭의 입력 내역을 확인하여 주십시오."
					+ "\n 1. 명의인 : 본인"
					+ "\n 2. 반기구분 : 2014 전체");
			shtObj.SetCellValue(Row, "card_type", "");
			return false;

		} else if( (typeof cardType === "string" && cardType.indexOf("2015") > -1)
			&& (shtObj.GetCellValue(Row, "famres") != gOwnFamCd) ) {
			// 신용카드구분이 2015 일 경우, 명의인이 본인이 아닌경우
			alert("2015(본인) 신용카드구분의 대상은 다음과 같습니다.\n카드 탭의 입력 내역을 확인하여 주십시오."
					+ "\n 1. 명의인 : 본인"
					+ "\n 2. 반기구분 : 2015 전체");
			shtObj.SetCellValue(Row, "card_type", "");
			return false;
/*
		} else if( (shtObj.GetCellValue(Row, "card_type") == "35" )
			&& (shtObj.GetCellValue(Row, "famres") != gOwnFamCd) ) {
			//당해전체30 / 근로기간제외 총사용분35
			alert("근로제공기간 이외 (본인) 신용카드등 사용액의 대상은"
					+ "\n다음과 같습니다."
					+ "\n 1. 명의인 : 본인"
					+ "\n 2. 반기구분 : 당해 전체"
					+ "\n * 종전근무지를 포함하여 2016.1.1 ~ 2016.12.31 기간중 "
					+ "\n   근로하지 아니한 기간에 사용한 본인 신용카드등 사용액");
			shtObj.SetCellValue(Row, "card_type", "");
			return false;
*/
		} else if( (shtObj.GetCellValue(Row, "card_type") == "37" )
			&& (shtObj.GetCellValue(Row, "famres") != gOwnFamCd) ) {
			//당해하반기20 /근로기간제외 추가공제율사용분37
			alert("근로제공기간 이외 (본인) 추가공제율 사용분의 대상은"
					+ "\n다음과 같습니다."
					+ "\n 1. 명의인 : 본인"
					+ "\n 2. 반기구분 : 당해 상반기, 당해 하반기"
					+ "\n * 종전근무지를 포함하여 2016.1.1 ~ 2016.12.31 기간중 "
					+ "\n   근로하지 아니한 기간에 사용한 본인 추가공제율 사용분");
			shtObj.SetCellValue(Row, "card_type", "");
			return false;
		}
		return true;
	}

	function half_gubun_chk(shtObj, Row, gubun) {
		var cardType = shtObj.GetCellText(Row, "card_type");
		if( (typeof cardType === "string" && cardType.indexOf("2014") > -1)
				&& (shtObj.GetCellValue(Row, "half_gubun") != "2014") ) {
		   // 신용카드구분이 2013 일 경우, 반기구분이 2013이 아닐경우

			alert("2013(본인) 신용카드구분의 대상은 다음과 같습니다.\n카드 탭의 입력 내역을 확인하여 주십시오."
					+ "\n 1. 명의인 : 본인"
					+ "\n 2. 반기구분 : 2014 전체");
			shtObj.SetCellValue(Row, "card_type", "");
			return false;

		} else if( (nvl(cardType, "") != "")
				&& (typeof cardType === "string" && cardType.indexOf("2014") == -1)
				&& (shtObj.GetCellValue(Row, "half_gubun") == "2014") ) {
			// 신용카드구분이 2013이 아닐 경우, 반기구분이 2013일 경우

				alert("2013(본인) 신용카드구분의 대상은 다음과 같습니다.\n카드 탭의 입력 내역을 확인하여 주십시오."
					+ "\n 1. 명의인 : 본인"
					+ "\n 2. 반기구분 : 2014 전체");
				shtObj.SetCellValue(Row, "card_type", "") ;
				return false;

		} else if( (typeof cardType === "string" && cardType.indexOf("2015") > -1)
				&& (shtObj.GetCellValue(Row, "half_gubun") != "2015") ) {
			// 신용카드구분이 2014 일 경우, 반기구분이 2014이 아닐경우

			 alert("2014(본인) 신용카드구분의 대상은 다음과 같습니다.\n카드 탭의 입력 내역을 확인하여 주십시오."
					 + "\n 1. 명의인 : 본인"
					 + "\n 2. 반기구분 : 2015 전체");
			 shtObj.SetCellValue(Row, "card_type", "");
			 return false;

		 } else if( (nvl(cardType, "") != "")
				 && (typeof cardType === "string" && cardType.indexOf("2015") == -1)
				 && (shtObj.GetCellValue(Row, "half_gubun") == "2015") ) {
			 // 신용카드구분이 2014이 아닐 경우, 반기구분이 2014일 경우

				 alert("2014(본인) 신용카드구분의 대상은 다음과 같습니다.\n카드 탭의 입력 내역을 확인하여 주십시오."
					 + "\n 1. 명의인 : 본인"
					 + "\n 2. 반기구분 : 2015 전체");
				 shtObj.SetCellValue(Row, "card_type", "") ;
				 return false;
/*
		} else if( (shtObj.GetCellValue(Row, "card_type") == "35" )
				&& (shtObj.GetCellValue(Row, "half_gubun") != "30") ) {
			// 신용카드구분이  근로기간제외 총사용분이 아닐 경우, 반기구분이 당해 전체일 경우

				alert("근로제공기간 이외 (본인) 신용카드등 사용액의 대상은"
					+ "\n다음과 같습니다."
					+ "\n 1. 명의인 : 본인"
					+ "\n 2. 반기구분 : 당해 전체"
					+ "\n * 종전근무지를 포함하여 2016.1.1 ~ 2016.12.31 기간중 "
					+ "\n   근로하지 아니한 기간에 사용한 본인 신용카드등 사용액");
				shtObj.SetCellValue(Row, "card_type", "");
				return false;
*/
		} else if( (nvl(shtObj.GetCellValue(Row, "card_type"), "") != "")
				&& (shtObj.GetCellValue(Row, "card_type") != "35" )
				&& (shtObj.GetCellValue(Row, "half_gubun") == "30") ) {
			// 신용카드구분이  근로기간제외 총사용분이 아닐 경우, 반기구분이 당해 전체일 경우

				alert("근로제공기간 이외 (본인) 신용카드등 사용액의 대상은"
					+ "\n다음과 같습니다."
					+ "\n 1. 명의인 : 본인"
					+ "\n 2. 반기구분 : 당해 전체"
					+ "\n * 종전근무지를 포함하여 2016.1.1 ~ 2016.12.31 기간중 "
					+ "\n   근로하지 아니한 기간에 사용한 본인 신용카드등 사용액");
				shtObj.SetCellValue(Row, "card_type", "") ;
				return false;


		} else if( (shtObj.GetCellValue(Row, "card_type") == "37" )
				&& !(shtObj.GetCellValue(Row, "half_gubun") == "" ||
						shtObj.GetCellValue(Row, "half_gubun") == "10" ||
							shtObj.GetCellValue(Row, "half_gubun") == "20") ) {
			// 신용카드구분이  근로기간제외 추가공제율사용분이 아닐 경우, 반기구분이 당해하반기일 경우
			//당해하반기20 /근로기간제외 추가공제율사용분37
				alert("근로제공기간 이외 (본인) 추가공제율 사용분의 대상은"
					+ "\n다음과 같습니다."
					+ "\n 1. 명의인 : 본인"
					+ "\n 2. 반기구분 : 당해 상반기, 당해 하반기"
					+ "\n * 종전근무지를 포함하여 2016.1.1 ~ 2016.12.31 기간중 "
					+ "\n   근로하지 아니한 기간에 사용한 본인 추가공제율 사용분");
				shtObj.SetCellValue(Row, "card_type", "") ;
				return false;

		}
		return true;
	}

	function card_type_chk(shtObj, Row, gubun) {

		if( shtObj.GetCellValue(Row, "card_type") == "7") { // 현금영수증 선택시 국세청 자료여부 선택 불가(자료여부 : Y)
			shtObj.SetCellValue(Row, "nts_yn", "Y") ;
			shtObj.SetCellEditable(Row, "nts_yn", 0) ;

		} else if( shtObj.GetCellValue(Row, "card_type") == "23") { // 2013년(본인) 현금영수증 선택시 국세청 자료여부 선택 불가
			shtObj.SetCellValue(Row, "nts_yn", "Y") ;
			shtObj.SetCellEditable(Row, "nts_yn", 0) ;

		} else if( shtObj.GetCellValue(Row, "card_type") == "43") { // 2014년(본인) 현금영수증 선택시 국세청 자료여부 선택 불가
			shtObj.SetCellValue(Row, "nts_yn", "Y") ;
			shtObj.SetCellEditable(Row, "nts_yn", 0) ;

		} else {
			shtObj.SetCellEditable(Row, "nts_yn", 1) ;
		}

		var cardType = shtObj.GetCellText(Row, "card_type");
		if( typeof cardType === "string" && cardType.indexOf("2014") > -1) {
		// 신용카드구분이 2013 일 경우(명의인:본인, 반기구분:2013 전체)

	   		if ( shtObj.GetCellValue(Row, "famres") != gOwnFamCd
	   			|| shtObj.GetCellValue(Row, "half_gubun") != "2014") {

				alert("2013(본인) 신용카드구분의 대상은 다음과 같습니다.\n카드 탭의 입력 내역을 확인하여 주십시오."
						+ "\n 1. 명의인 : 본인"
						+ "\n 2. 반기구분 : 2014 전체");

				if ( gubun == "OnChange" ) {
					shtObj.SetCellValue(Row, "famres", gOwnFamCd) ;
					shtObj.SetCellValue(Row, "half_gubun", "2014") ;
				}
				return false;
			}
			return true;

		} else if( typeof cardType === "string" && cardType.indexOf("2015") > -1) {
			// 신용카드구분이 2014 일 경우(명의인:본인, 반기구분:2014 전체)

		   	if ( shtObj.GetCellValue(Row, "famres") != gOwnFamCd
		   		|| shtObj.GetCellValue(Row, "half_gubun") != "2015") {

		   		alert("2014(본인) 신용카드구분의 대상은 다음과 같습니다.\n카드 탭의 입력 내역을 확인하여 주십시오."
   						+ "\n 1. 명의인 : 본인"
   						+ "\n 2. 반기구분 : 2014 전체");

		   		if ( gubun == "OnChange" ) {
	   				shtObj.SetCellValue(Row, "famres", gOwnFamCd) ;
	   				shtObj.SetCellValue(Row, "half_gubun", "2015") ;
		   		}
   				return false;
		   	}
		   	return true;

		} else if ( shtObj.GetCellValue(Row, "card_type") == "35" ) {
			if ($("#searchWorkYy").val() != shtObj.GetCellValue(Row, "use_yyyy")) {

				alert("근로제공기간 이외 신용카드등 사용액의 대상은"
						+ "\n다음과 같습니다."
						+ "\n * 종전근무지를 포함하여 2021.1.1 ~ 2021.12.31 기간중 "
						+ "\n   근로하지 아니한 기간에 사용한 본인 신용카드등 사용액");

				if ( gubun == "OnChange" ) {
					shtObj.SetCellValue(Row, "use_yyyy", $("#searchWorkYy").val()) ;
				}
				return false;
			}
			return true;

		} else if ( shtObj.GetCellValue(Row, "card_type") == "37" ) {
			// 신용카드구분이 근로기간제외 추가공제율사용분일 경우(명의인:본인, 반기구분:당해하반기)
			//당해하반기20 /근로기간제외 추가공제율사용분37
		   	if ( shtObj.GetCellValue(Row, "famres") != gOwnFamCd
		   			|| !(shtObj.GetCellValue(Row, "half_gubun")=="" ||
		   					shtObj.GetCellValue(Row, "half_gubun") == "10"||
		   						 shtObj.GetCellValue(Row, "half_gubun") == "20")) {

				alert("근로제공기간 이외 (본인) 추가공제율 사용분의 대상은"
						+ "\n다음과 같습니다."
						+ "\n 1. 명의인 : 본인"
						+ "\n 2. 반기구분 : 당해 상반기, 당해 하반기"
						+ "\n * 종전근무지를 포함하여 2016.1.1 ~ 2016.12.31 기간중 "
						+ "\n   근로하지 아니한 기간에 사용한 본인 추가공제율 사용분");

				if ( gubun == "OnChange" ) {
					shtObj.SetCellValue(Row, "famres", gOwnFamCd) ;
					shtObj.SetCellValue(Row, "half_gubun", "") ;
				}
			   return false;
			}
			return true;

		} else {
			var halfGubun = shtObj.GetCellText(Row, "half_gubun");
			if ( (nvl(cardType, "") != "")
			  && ( typeof halfGubun === "string" && halfGubun.indexOf("2014") > -1 ) ) {

				shtObj.SetCellValue(Row, "half_gubun", "") ;
				return false;

			} else if ( (nvl(cardType, "") != "")
			  && ( typeof halfGubun === "string" && halfGubun.indexOf("2015") > -1 ) ) {

				shtObj.SetCellValue(Row, "half_gubun", "") ;
				return false;

			} else if ( (nvl(cardType, "") != "")
			  && ( shtObj.GetCellValue(Row, "half_gubun") == "30") ) {

				shtObj.SetCellValue(Row, "half_gubun", "") ;
				return false;

			}
		}
		return true;
	}

	//기본데이터 조회
	function initDefaultData() {
		//도움말 조회
		var param1 = "searchWorkYy="+$("#searchWorkYy").val();
		param1 += "&queryId=getYeaDataHelpText";

		var result1 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param1+"&adjProcessCd=A100",false);
		helpText = nvl(result1.Data.help_text1,"") + nvl(result1.Data.help_text2,"") + nvl(result1.Data.help_text3,"");

		//안내메세지
        $("#infoLayer").html(helpText).hide();

		//총급여 확인 버튼 유무
		var result2 = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_MON_SHOW_YN", "queryId=getSystemStdData",false).codeList;
		yeaMonShowYn = nvl(result2[0].code_nm,"");

		//신용,직/선불카드 - 개인별 총급여
		var param2 = "searchWorkYy="+$("#searchWorkYy").val();
		param2 += "&searchAdjustType="+$("#searchAdjustType").val();
		param2 += "&searchSabun="+$("#searchSabun").val();
		param2 += "&queryId=getYeaDataPayTotMon";

		var result3 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param2+"&searchNumber=0.25",false);
		paytotMonStr = nvl(result3.Data.paytot_mon,"");

	}

	//직원금액 입력시 담당자금액으로 셋팅 처리
	function inputChangeAppl(shtnm,colValue,rowValue){
		if(shtnm.ColSaveName(colValue) == "input_mon" || shtnm.ColSaveName(colValue) == "use_mon") {
			shtnm.SetCellValue(rowValue,"appl_mon", shtnm.GetCellValue(rowValue,colValue));
		}
	}

	//기본자료 설정.
	function sheetSet(){
		var comSheet = parent.commonSheet;

		if(comSheet.RowCount() > 0){
			$("#A100_13").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_13"),"input_mon"));
			$("#A100_14").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_14"),"input_mon"));
			$("#A100_15").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_15"),"input_mon"));
			$("#A100_16").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_16"),"input_mon"));
			$("#A100_17").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_17"),"input_mon"));
			$("#A100_22").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_22"),"input_mon"));
		} else {
			$("#A100_13").val("");
			$("#A100_14").val("");
			$("#A100_15").val("");
			$("#A100_16").val("");
			$("#A100_17").val("");
			$("#A100_22").val("");
		}
	}

	//연말정산 안내
	function yeaDataExpPopup(title, helpText, height, width){
		var url	 = "<%=jspPath%>/common/yeaDataExpPopup.jsp";
		openYeaDataExpPopup(url, width, height, title, helpText);
	}

	function paytotMonView(){
		if(paytotMonStr != ""){
            $("#span_paytotMonView").html("<span class='no-bold'>"+paytotMonStr+"원</span>&nbsp;<a class='under-line bold' href='javascript:paytotMonViewClose()'>닫기</a>");
		} else {
			alert("총급여 내역이 없습니다. 관리자에게 문의해 주십시요.");
			return;
		}
	}

	function paytotMonViewClose(){
		$("#span_paytotMonView").html("");
	}

	function sheetChangeCheck() {
		var iTemp = sheet1.RowCount("I") + sheet1.RowCount("U") + sheet1.RowCount("D");
		if ( 0 < iTemp ) return true;
		return false;
	}
</script>

<!-- sheet1 -->
<script type="text/javascript">
	function load_sheet1() {
		//연말정산 신용카드 쉬트
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msAll};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"년도|년도",				    Type:"Text",	Hidden:0,   Width:60,   Align:"Center",   ColMerge:1, SaveName:"yy",			KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"반기구분|반기구분",			    Type:"Combo",	Hidden:1,   Width:60,   Align:"Center",   ColMerge:1, SaveName:"half_gubun",	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"구분|구분",				    Type:"Combo",	Hidden:0,   Width:60,   Align:"Center",   ColMerge:1, SaveName:"use_type",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사용자|사용자",			    	Type:"Text",	Hidden:0,   Width:60,   Align:"Center",   ColMerge:1, SaveName:"fam_nm",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			//{Header:"월구간|월구간",			    Type:"Combo",	Hidden:1,   Width:60,   Align:"Center",   ColMerge:1, SaveName:"period_type",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"신용카드|신용카드",			    Type:"AutoSum",	Hidden:0,   Width:60,   Align:"Center",   ColMerge:0, SaveName:"card_amt",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직불카드등|직불카드등",               Type:"AutoSum", Hidden:0,   Width:80,   Align:"Center",   ColMerge:0, SaveName:"tot_check_amt",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"현금영수증|현금영수증",				Type:"AutoSum",	Hidden:0,   Width:60,   Align:"Center",   ColMerge:0, SaveName:"cash_amt",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			//{Header:"도서공연등사용분|신용카드",			Type:"AutoSum",	Hidden:0,   Width:60,   Align:"Center",   ColMerge:1, SaveName:"bookcard_amt",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			//{Header:"도서공연등사용분|직불카드",			Type:"AutoSum",	Hidden:0,   Width:60,   Align:"Center",   ColMerge:1, SaveName:"bookcheck_amt",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			//{Header:"도서공연등사용분|현금영수증",			Type:"AutoSum",	Hidden:0,   Width:60,   Align:"Center",   ColMerge:1, SaveName:"bookchash_amt",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"도서공연등사용분|도서공연등사용분",			Type:"AutoSum",	Hidden:0,   Width:60,   Align:"Center",   ColMerge:0, SaveName:"tot_book_amt",	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"전통시장사용분|전통시장사용분",			Type:"AutoSum",	Hidden:0,   Width:80,   Align:"Center",   ColMerge:0, SaveName:"tot_market_amt",	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"대중교통이용분|대중교통이용분",			Type:"AutoSum",	Hidden:0,   Width:80,   Align:"Cen",   ColMerge:0, SaveName:"tot_bus_amt",	    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사업관련비용|사업관련비용",			Type:"AutoSum",	Hidden:0,   Width:60,	Align:"Center",   ColMerge:0, SaveName:"business_amt",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"2021 합계\n(사업관련비용제외)|2021 합계\n(사업관련비용제외)",				    Type:"AutoSum",	Hidden:0,   Width:60,	Align:"Center",   ColMerge:0, SaveName:"tot_amt",  		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"2020 합계\n(사업관련비용제외)|2020 합계\n(사업관련비용제외)",                 Type:"AutoSum", Hidden:0,   Width:60,   Align:"Center",   ColMerge:0, SaveName:"tot_amt_2020",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"추가공제율사용분",				Type:"Int",		Hidden:1,   Width:60,	Align:"Center",   ColMerge:0, SaveName:"add_amt",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"추가공제율사용분\n담당자 입력",		Type:"Int",		Hidden:1,   Width:60,	Align:"Center",   ColMerge:0, SaveName:"admin_add_mon", KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(0);

		// 반기구분 코드 조회
		var halfGubunList = stfConvCode(ajaxCall("<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectYeaDataCardsHalfGubun", "searchYyType=", false).codeList, "");

		sheet1.SetColProperty("half_gubun",	 {ComboText:"|"+halfGubunList[0], ComboCode:"|"+halfGubunList[1]} );
		sheet1.SetColProperty("use_type",		 {ComboText:"|본인|본인외", ComboCode:"|S|F"} );

		//월구간 조회
<%-- 		var periodType = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00314"), ""); --%>
// 		sheet1.SetColProperty("period_type",		 {ComboText:"|"+periodType[0], ComboCode:"|"+periodType[1]} );

	}

	//연말정산 신용카드
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			var params = "";
			params += "&searchWorkYy="    + $("#searchWorkYy").val();
			params += "&searchAdjustType="+ $("#searchAdjustType").val();
			params += "&searchSabun="     + $("#searchSabun").val();

			var monSum = ajaxCall("<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectYeaDataCard", params, false);

			var ntsIn  = monSum.sumList[0].nts_in;
			var nts_mn = monSum.sumList[0].nts_mn;
			var etcsum = monSum.sumList[0].etcsum;
            var be_ntsIn  = monSum.sumList[0].be_nts_in;
            var be_nts_mn = monSum.sumList[0].be_nts_mn;
            var be_etcsum = monSum.sumList[0].be_etcsum;

			$("#ntsIn").val(ntsIn);
            $("#ntsMn").val(nts_mn);
            $("#etcSum").val(etcsum);
            $("#be_ntsIn").val(be_ntsIn);
            $("#be_ntsMn").val(be_nts_mn);
            $("#be_etcSum").val(be_etcsum);

//             //월구간 조회 param 추가
//             var params2 = "&searchPeriodType1=" +$("#searchPeriodType1").val();
<%-- 			sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectYeaDataCardsInfo", $("#sheetForm").serialize()+params2 ); --%>

			sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectYeaDataCardsInfo", $("#sheetForm").serialize());
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if (Code == 1) {
				for(var i = 1; i < sheet1.RowCount()+1; i++) {

					if ( sheet1.GetCellValue(i, "yy") == systemYY+"_SUM" ) {
						sheet1.SetCellValue(i, "yy", systemYY+" 합계");
						sheet1.SetRowBackColor(i, "#FFFFEF");
					} else if ( sheet1.GetCellValue(i, "yy") == "SUM" ) {
						sheet1.SetCellValue(i, "yy", "합계");
						sheet1.SetRowBackColor(i, "#FAD5E6");
					}
				}
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
</script>

<!-- sheet2 -->
<script type="text/javascript">
	var templeteTitle2 = "업로드시 이 행은 삭제 합니다\n\n";

	function load_sheet2() {
		//연말정산 신용카드 쉬트
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msAll};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"No|No",						Type:"<%=sNoTy%>",  Hidden:<%=sNoHdn%>, Width:"<%=sNoWdt%>",	Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"삭제|삭제",					Type:"<%=sDelTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",   Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
			{Header:"상태|상태",					Type:"<%=sSttTy%>", Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",   Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			{Header:"DOC_SEQ|DOC_SEQ",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:0,	SaveName:"doc_seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"DOC_SEQ_DETAIL|DOC_SEQ_DETAIL",Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:0,	SaveName:"doc_seq_detail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"년도|년도",					Type:"Int",		    Hidden:1,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"work_yy",		    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
			{Header:"정산구분|정산구분",			Type:"Text",		Hidden:1,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"adjust_type",	    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"사번|사번",					Type:"Text",		Hidden:1,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"sabun",		    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
			{Header:"순서|순서",					Type:"Text",		Hidden:1,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"seq",			    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"명의인|명의인",				Type:"Combo",	    Hidden:0,   Width:80,  	Align:"Center", ColMerge:1, SaveName:"famres",		    KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:200 },
            {Header:"사용연도|사용연도",           Type:"Combo",      Hidden:0,  Width:60,    Align:"Center",  ColMerge:1,   SaveName:"use_yyyy",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
			{Header:"반기\n구분|반기\n구분",		Type:"Combo",	    Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"half_gubun",	    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
// 			{Header:"월구간|월구간",				Type:"Combo",	    Hidden:1,   Width:80,  	Align:"Center", ColMerge:0, SaveName:"period_type",		    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:200 },
			{Header:"신용카드\n구분|신용카드\n구분",Type:"Combo",	    Hidden:0,   Width:80,   Align:"Center", ColMerge:0, SaveName:"card_type",	    KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"카드명|카드명",				Type:"Text",		Hidden:0,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"card_enter_nm",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"금액자료|직원용",				Type:"AutoSum",	    Hidden:0,   Width:110,  Align:"Right",  ColMerge:0, SaveName:"use_mon",		    KeyField:0, Format:"#,###",  PointCount:0,   UpdateEdit:<%=inputEdit%>,   InsertEdit:<%=inputEdit%>,   EditLen:35 },
			{Header:"금액자료|담당자용",			Type:"AutoSum",	    Hidden:0,   Width:110,  Align:"Right",  ColMerge:0, SaveName:"appl_mon",		KeyField:1, Format:"#,###",  PointCount:0,   UpdateEdit:<%=applEdit%>,	InsertEdit:<%=applEdit%>,	EditLen:35 },
			{Header:"자료입력유형|자료입력유형",		  	Type:"Combo",	    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"adj_input_type",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"의료기관\n사용액|의료기관\n사용액",  	Type:"Text",		Hidden:1,   Width:60,   Align:"Right",  ColMerge:0, SaveName:"med_mon",		    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"회사지원금|회사지원금",			  	Type:"Text",		Hidden:1,   Width:60,   Align:"Right",  ColMerge:0, SaveName:"co_deduct_mon",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"국세청\n자료여부|국세청\n자료여부",  	Type:"CheckBox",	Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"nts_yn",		    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"담당자확인|담당자확인",			  	Type:"Combo",	    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"feedback_type",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		// 반기구분 코드 조회
		var halfGubunList = stfConvCode(ajaxCall("<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectYeaDataCardsHalfGubun", "searchYyType=0", false).codeList, "");
		//신용카드구분 코드 조회
		var cardTypeList = stfConvCode(ajaxCall("<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectYeaDataCardCardType", "searchYyType=0", false).codeList, "");

		var cardTypeList2 = stfConvCode(ajaxCall("<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectYeaDataCardCardType", "searchYyType=0", false).codeList, "전체");
		$("#inputCardType").html(cardTypeList2[2]).val("0");

		//월구간 조회
<%-- 		var periodType = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00314"), ""); --%>
// 		sheet2.SetColProperty("period_type",		 {ComboText:"|"+periodType[0], ComboCode:"|"+periodType[1]} );

		sheet2.SetColProperty("famres",		 {ComboText:"|"+famAllList[0], ComboCode:"|"+famAllList[1]} );
		sheet2.SetColProperty("half_gubun",	 {ComboText:"|"+halfGubunList[0], ComboCode:"|"+halfGubunList[1]} );
		sheet2.SetColProperty("card_type",	  {ComboText:"|"+cardTypeList[0], ComboCode:"|"+cardTypeList[1]} );
		sheet2.SetColProperty("adj_input_type", {ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
		sheet2.SetColProperty("feedback_type",  {ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
		sheet2.SetColProperty("use_yyyy", {ComboText:"2021|2020", ComboCode:"2021|2020"});
	  	//양식다운로드 title 정의
	  	templeteTitle2 = "업로드시 이 행은 삭제 합니다\n\n";
		var codeCdNm = "", codeCd = "", codeNm = "";

		codeCdNm = "";
		codeNm = halfGubunList[0].split("|"); codeCd = halfGubunList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle2 += "반기구분 : " + codeCdNm + "\n";

// 		codeCdNm = "";
// 		codeNm = periodType[0].split("|"); codeCd = periodType[1].split("|");
// 		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
// 		templeteTitle2 += "월구간 : " + codeCdNm + "\n";

		codeCdNm = "";
		codeNm = cardTypeList[0].split("|"); codeCd = cardTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle2 += "카드구분 : " + codeCdNm + "\n";

		templeteTitle2 += "국세청 자료여부 : Y, N \n";

		codeCdNm = "";
		codeNm = feedbackTypeList[0].split("|"); codeCd = feedbackTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle2 += "담당자확인 : " + codeCdNm + "\n";



	}

	function load_sheet3() {
		//연말정산 추가공제율 사용분 쉬트
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msAll};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"No|No",										 Type:"<%=sNoTy%>",  Hidden:<%=sNoHdn%>, Width:"<%=sNoWdt%>",	 Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"삭제|삭제",					   				 Type:"<%=sDelTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",   Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
			{Header:"상태|상태",					   				 Type:"<%=sSttTy%>", Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",   Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			{Header:"년도|년도",					   				 Type:"Int",		 Hidden:1,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"work_yy",		 KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
			{Header:"정산구분|정산구분",			   				 Type:"Text",		 Hidden:1,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"adjust_type",	 KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"사번|사번",					   				 Type:"Text",		 Hidden:1,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"sabun",		   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
			{Header:"금액자료|신용카드",			   				 Type:"AutoSum",	 Hidden:0,   Width:110,  Align:"Right",  ColMerge:0, SaveName:"add_card_mon",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:<%=applEdit%>,	InsertEdit:<%=applEdit%>,	EditLen:35 },
			{Header:"금액자료|현금영수증",			   				 Type:"AutoSum",	 Hidden:0,   Width:110,  Align:"Right",  ColMerge:0, SaveName:"add_cash_mon",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:<%=applEdit%>,	InsertEdit:<%=applEdit%>,	EditLen:35 },
			{Header:"금액자료|직불카드등",			   				 Type:"AutoSum",	 Hidden:0,   Width:110,  Align:"Right",  ColMerge:0, SaveName:"add_debit_mon",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:<%=applEdit%>,	InsertEdit:<%=applEdit%>,	EditLen:35 },
			{Header:"담당자입력여부|담당자입력여부",   				 Type:"Text",		 Hidden:0,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"admin_reg_yn",		   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
			{Header:"변경전_담당자입력여부|변경전_담당자입력여부",   Type:"Text",		 Hidden:0,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"origin_admin_reg_yn",		   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 }
		]; IBS_InitSheet(sheet3, initdata1);sheet3.SetEditable("<%=editable%>");sheet3.SetVisible(true);sheet3.SetCountPosition(4);

	}
	//연말정산 신용카드
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":

			/* 합산시 사업관련비용을 제외하기 위해 별도 처리 - 2020.02.14
			var sumColsInfo = "use_mon|appl_mon";
			//데이터가 너무 세분화 되어 반기로 구분함
			var info =[{StdCol:"famres", SumCols:sumColsInfo, ShowCumulate:0, CaptionCol:3}];
	//		 var info =[{StdCol:"card_type", SumCols:sumColsInfo, ShowCumulate:0, CaptionCol:3}];
			sheet2.ShowSubSum(info) ;
			*/

			sheet2.DoSearch( "<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectYeaDataCardsList", $("#sheetForm").serialize() +"&"+ $("#sheetForm2").serialize());

			//전년도 합계 정보 조회
			//getPreYeaDataInfo_2014();
		  	//전전년도 합계 정보 조회
			//getPreYeaDataInfo_2013();
			//본인 정보 조회
			getOwnDataInfo();

			break;
		case "Save":
			if(!parent.checkClose())return;

			tab_setAdjInputType(orgAuthPg, sheet2);

			//반기구분/신용카드구분 유효성 체크
			if ( validate_chk(sheet2) ) {
				sheet2.DoSave( "<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=saveYeaDataCards");
			}
			break;
		case "Insert":
			if(!parent.checkClose())return;

			var newRow = sheet2.DataInsert(0) ;
			if ( $("#searchYyType").val() == "0" || $("#searchYyType").val() == "-99" ) {
				sheet2.CellComboItem(newRow, "famres", {ComboText:"|"+famList[0], ComboCode:"|"+famList[1]});
			} else {
				sheet2.SetCellValue( newRow, "famres", gOwnFamCd );
			}
			sheet2.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() );
			sheet2.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() );
			sheet2.SetCellValue( newRow, "sabun", $("#searchSabun").val() );
			sheet2.SetCellValue( newRow, "use_yyyy", $("#searchUseYyyy").val() );
			sheet2.SetCellValue( newRow, "half_gubun", "20");

			tab_clickInsert(orgAuthPg, sheet2, newRow);

			break;
		case "Copy":
			var famresTemp = sheet2.GetCellValue(sheet2.GetSelectRow(), "famres");
			if(famresTemp == null || famresTemp == undefined || $.trim(famresTemp).length == 0) break;
			var newRow = sheet2.DataCopy();
			sheet2.SelectCell(newRow, 2);
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet2.Down2Excel(param);
			break;

		case "Down2Template":

			//금액자료 직원용(14)/담당자용(15)
			var monTmp	  = "|14";
			var feedbackTmp = "";
			if ( orgAuthPg=="A" ) {
				monTmp = "|15";
				feedbackTmp = "|20";
			} else {
				if ( templeteTitle2.indexOf("담당자확인 : ") > -1 ) {
					templeteTitle2.substring(0, templeteTitle2.indexOf("담당자확인 : "));
				}
			}

			// 전년도, 전전년도 인 경우 본인만 등록가능
			var DownCols = "";
			if ( $("#searchYyType").val() == "0" || $("#searchYyType").val() == "-99") {
				DownCols = "9|10|11|12|13"+monTmp+"|19"+feedbackTmp;
			}else{
				DownCols = "10|11|12|13"+monTmp+"|19"+feedbackTmp;
			}

            var param  = {DownCols:DownCols, SheetDesign:1,Merge:1,DownRows:'0|1',ExcelFontSize:"9"
                ,TitleText:templeteTitle2,UserMerge :"0,0,1,5",menuNm:$(document).find("title").text()};
			sheet2.Down2Excel(param);
			break;

		case "LoadExcel":
			//업로드 시  merge해제
			sheet2.SetMergeSheet( msHeaderOnly);

			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet2.LoadExcel(params);
			break;
		}
	}

	/*추가공제율 사용분 담당자입력 */
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
			sheet3.DoSearch( "<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectYeaDataAddCardsList", $("#sheetForm").serialize() +"&"+ $("#sheetForm2").serialize() );
			break;
		case "Save":
			if(!parent.checkClose())return;

			if(sheet3.RowCount() == 0) {
				var newRow = sheet3.DataInsert(0) ;
				sheet3.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() );
				sheet3.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() );
				sheet3.SetCellValue( newRow, "sabun", $("#searchSabun").val() );
				sheet3.SetCellValue( newRow, "add_debit_mon", $("#debitMon").val() );
				sheet3.SetCellValue( newRow, "add_cash_mon", $("#cashMon").val() );
				sheet3.SetCellValue( newRow, "add_card_mon", $("#cardMon").val() );
				sheet3.SetCellValue( newRow, "admin_reg_yn", sheet3.GetCellValue( newRow, "origin_admin_reg_yn") );

			} else {
				sheet3.SetCellValue( 2, "add_debit_mon", $("#debitMon").val() );
				sheet3.SetCellValue( 2, "add_cash_mon", $("#cashMon").val() );
				sheet3.SetCellValue( 2, "add_card_mon", $("#cardMon").val() );
				sheet3.SetCellValue( 2, "admin_reg_yn", sheet3.GetCellValue( 2, "origin_admin_reg_yn") );
			}
			sheet3.DoSave( "<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=saveYeaDataAddCards");
			break;
		case "Insert":
			if(!parent.checkClose())return;

			var newRow = sheet3.DataInsert(0) ;
			sheet3.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() );
			sheet3.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() );
			sheet3.SetCellValue( newRow, "sabun", $("#searchSabun").val() );

			tab_clickInsert(orgAuthPg, sheet3, newRow);

			break;
		}
	}


	//업로드 완료후 호출
	function sheet2_OnLoadExcel(result) {
		//업로드 시 소계 해제
		sheet2.HideSubSum();

		try {
			var msgSts = false;
			for(var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows(); i++){
				sheet2.SetCellValue( i, "work_yy", 		$("#searchWorkYy").val() );
				sheet2.SetCellValue( i, "adjust_type", 	$("#searchAdjustType").val() );
				sheet2.SetCellValue( i, "sabun", 		$("#searchSabun").val() );

				if ( orgAuthPg=="A" ) { //담당자용
					sheet2.SetCellValue( i, "adj_input_type", "02" );
					sheet2.SetCellEditable(i, "feedback_type", 1);

				} else {
					sheet2.SetCellValue( i, "adj_input_type", "01" );
					sheet2.SetCellValue( i, "appl_mon", sheet2.GetCellValue(i, "use_mon") );
					sheet2.SetCellEditable(i, "feedback_type", 0);
				}

				// 전년도, 전전년도 인 경우 본인만 등록가능
				if ( $("#searchYyType").val() != "0" && $("#searchYyType").val() != "-99" ) {
					sheet2.SetCellValue( i, "famres", 		gOwnFamCd );
				}

				sheet2.GetCellValue( i, "card_type"); //카드구분
				sheet2.GetCellValue( i, "use_mon");	  //금액자료(직원용)
				sheet2.GetCellValue( i, "appl_mon");  //금액자료(담당자용)

				if( sheet2.GetCellValue( i, "use_mon") < 0) {
					if(sheet2.GetCellValue( i, "card_type") == "3" || sheet2.GetCellValue( i, "card_type") == "4"){
						sheet2.SetCellValue( i, "use_mon","0");
						msgSts = true;
					}
				}
				if( sheet2.GetCellValue( i, "appl_mon") < 0) {
					if(sheet2.GetCellValue( i, "card_type") == "3" || sheet2.GetCellValue( i, "card_type") == "4"){
						sheet2.SetCellValue( i, "appl_mon","0");
						msgSts = true;
					}
				}
			}
			if(msgSts == true ){
				alert("사업관련비용일 경우에는 양수로 기입해주십시오.");
			}
		} catch(ex) {
			alert("OnLoadExcel Event Error " + ex);
		}
	}

	//조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if (Code == 1) {

				var totMon1 = 0; //금액자료-직원용 합계
				var totMon2 = 0; //금액자료-담당자용 합계
				var totMonSub1 = 0; //금액자료-직원용 소계
				var totMonSub2 = 0; //금액자료-담당자용 소계
				var totBusinessAmt1 = 0; //금액자료-직원용 사업관련비용 합계
				var totBusinessAmt2 = 0; //금액자료-직원용 사업관련비용 합계
				var totBusinessSubAmt1 = 0; //금액자료-직원용 사업관련비용 소계
				var totBusinessSubAmt2 = 0; //금액자료-직원용 사업관련비용 소계

				var famres = "";
				var idx = 0;
			    var use_yyyy = $("#searchUseYyyy").val();

				for ( var i = sheet2.HeaderRows(); i <= sheet2.LastRow(); i++ ) {

					if(idx == 0) famres = sheet2.GetCellValue(i, "famres");

					if(idx != sheet2.RowCount() && famres == sheet2.GetCellValue(i, "famres")) {

						var useMon = sheet2.GetCellValue(i, "use_mon");
						var applMon = sheet2.GetCellValue(i, "appl_mon");

						if(useMon == null || useMon == undefined || $.trim(useMon).length == 0) useMon = 0;
						if(applMon == null || applMon == undefined || $.trim(useMon).length == 0) applMon = 0;

						if(sheet2.GetCellValue(i, "card_type") == "3" || sheet2.GetCellValue(i, "card_type") == "4") {
							totBusinessAmt1 = totBusinessAmt1 + useMon;
							totBusinessAmt2 = totBusinessAmt2 + applMon;

							totBusinessSubAmt1 = totBusinessSubAmt1 + useMon;
							totBusinessSubAmt2 = totBusinessSubAmt2 + applMon;
						} else {
							totMon1 = totMon1 + useMon;
							totMon2 = totMon2 + applMon;

							totMonSub1 = totMonSub1 + useMon;
							totMonSub2 = totMonSub2 + applMon;
						}
					} else {
						famres = sheet2.GetCellValue(i, "famres");

						//소계 행 추가
// 						var Row_3 = sheet2.DataInsert(i);
// 						sheet2.SetCellValue(Row_3, "use_mon", (totMonSub1 - totBusinessSubAmt1));
// 						sheet2.SetCellValue(Row_3, "appl_mon", (totMonSub2 - totBusinessSubAmt2));
// 						sheet2.SetRowBackColor(Row_3, "#FCFC37");
// 						sheet2.SetCellValue(Row_3, "use_yyyy", use_yyyy);
						totMonSub1 = 0;
						totMonSub2 = 0;
						totBusinessSubAmt1 = 0;
						totBusinessSubAmt2 = 0;

					}
					idx++;

					if ( !tab_setAuthEdtitable(orgAuthPg, sheet2, i) ) continue;

					if( sheet2.GetCellValue(i, "adj_input_type") == "02" ) {
						if(orgAuthPg == "A") {
							sheet2.SetCellEditable(i, "use_mon", 0) ;
							sheet2.SetCellEditable(i, "half_gubun", 0) ;
							sheet2.SetCellEditable(i, "card_type", 0) ;
							sheet2.SetCellEditable(i, "card_enter_nm", 0) ;
						} else {
							sheet2.SetCellEditable(i, "use_mon", 0) ;
							sheet2.SetCellEditable(i, "half_gubun", 0) ;
							sheet2.SetCellEditable(i, "card_type", 0) ;
							sheet2.SetCellEditable(i, "card_enter_nm", 0) ;
						}
					}

					if( sheet2.GetCellValue(i, "card_type") == "7") { /* 현금영수증 선택시 국세청 자료여부 선택 불가 */
						sheet2.SetCellEditable(i, "nts_yn", 0) ;

					} else if( sheet2.GetCellValue(i, "card_type") == "23") { /* 2013년(본인) 현금영수증 선택시 국세청 자료여부 선택 불가 */
						sheet2.SetCellEditable(i, "nts_yn", 0) ;
					}

				}

				if(sheet2.RowCount() > 0) {
					// 마지막 소계 행 추가
// 					var Row_2 = sheet2.DataInsert(-1);
// 					sheet2.SetCellValue(Row_2, "use_mon", (totMonSub1 - totBusinessSubAmt1));
// 					sheet2.SetCellValue(Row_2, "appl_mon", (totMonSub2 - totBusinessSubAmt2));
// 					sheet2.SetCellValue(Row_2, "use_yyyy", use_yyyy);
// 					sheet2.SetRowBackColor(Row_2, "#FCFC37");

					//합계 행 추가
// 					var Row_1 = sheet2.DataInsert(0);
// 					sheet2.SetCellValue(Row_1, "use_mon", (totMon1 - totBusinessAmt1));
// 					sheet2.SetCellValue(Row_1, "appl_mon", (totMon2 - totBusinessAmt2));
// 					sheet2.SetRowBackColor(Row_1, "#FDD7E4");
// 					sheet2.SetCellValue(Row_1, "use_yyyy", use_yyyy);
					for ( var i = sheet2.HeaderRows(); i <= sheet2.LastRow(); i++ ) {

						if(sheet2.GetCellValue(i, "famres") == "") {
							sheet2.InitCellProperty(i, "nts_yn", {Type: "Text", Edit:0});
							sheet2.SetCellValue(i, "nts_yn", "");
							//sheet2.SetCellValue(i, "sStatus", "R");
							sheet2.SetRowEditable(i, 0);
						}
					}
				}
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			parent.getYearDefaultInfoObj();
			if(Code == 1) {
				parent.doSearchCommonSheet();

				//저장 후 merge
				sheet2.SetMergeSheet(msAll);

				doAction1("Search");
				doAction2("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}


	//값 변경시 발생
	function sheet2_OnChange(Row, Col, Value) {

		try{
			//명의인
			if( sheet2.ColSaveName(Col) == "famres" ) {
				famres_chk(sheet2, Row, "OnChange");
			}

			//반기구분
			if( sheet2.ColSaveName(Col) == "half_gubun" ) {
				half_gubun_chk(sheet2, Row, "OnChange");
			}

			if( sheet2.ColSaveName(Col) == "use_yyyy" ) {
				if( (sheet2.GetCellValue(Row, "use_yyyy") != $("#searchWorkYy").val()) && (sheet2.GetCellValue(Row, "card_type") == "35") ) {
					alert("근로제공기간 이외 신용카드등 사용액의 대상은"
							+ "\n다음과 같습니다."
							+ "\n * 종전근무지를 포함하여 2021.1.1 ~ 2021.12.31 기간중 "
							+ "\n   근로하지 아니한 기간에 사용한 본인 신용카드등 사용액");
					sheet2.SetCellValue(Row, "use_yyyy", $("#searchWorkYy").val());

					return false;
				}
			}


			//신용카드구분
			if( sheet2.ColSaveName(Col) == "card_type" ) {
				if(sheet2.GetCellValue(Row, "use_mon") < 0 || sheet2.GetCellValue(Row, "appl_mon") < 0){
					if(sheet2.GetCellValue(Row, "card_type") == "3" ||sheet2.GetCellValue(Row, "card_type") == "4"){
						alert("사업관련비용일 경우에는 양수로 기입해주십시오.");
						if(orgAuthPg == "A"){
							sheet2.SetCellValue(Row, "appl_mon","0");
						}else{
							sheet2.SetCellValue(Row, "use_mon","0");
							sheet2.SetCellValue(Row, "appl_mon","0");
						}
					}
				}
				card_type_chk(sheet2, Row, "OnChange");
			}
			//금액자료
			if( sheet2.ColSaveName(Col) == "use_mon" || sheet2.ColSaveName(Col) == "appl_mon") {
				if(sheet2.GetCellValue(Row, "use_mon") < 0 || sheet2.GetCellValue(Row, "appl_mon") < 0){
					if(sheet2.GetCellValue(Row, "card_type") == "3" ||sheet2.GetCellValue(Row, "card_type") == "4"){
						alert("사업관련비용일 경우에는 양수로 기입해주십시오.");
						if(orgAuthPg == "A"){
							sheet2.SetCellValue(Row, "appl_mon","0");
						}else{
							sheet2.SetCellValue(Row, "use_mon","0");
							sheet2.SetCellValue(Row, "appl_mon","0");
						}
					}
				}
			}

			inputChangeAppl(sheet2,Col,Row);

		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function sheet2_OnClick(Row, Col, Value) {
		try{
			if(sheet2.ColSaveName(Col) == "sDelete" ) {
				tab_clickDelete(sheet2, Row);

				/* 금액 및 국세청 자료여부 Editable 풀림 방지*/
				if( sheet2.GetCellValue(Row, "adj_input_type") == "07" ) {
					sheet2.SetCellEditable(Row, "card_enter_nm", 0);
					sheet2.SetCellEditable(Row, "input_mon", 0);
					sheet2.SetCellEditable(Row, "appl_mon", 0);
					sheet2.SetCellEditable(Row, "nts_yn", 0);
					sheet2.SetCellEditable(Row, "card_type", 0);
				}
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}


	//조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if (Code == 1) {
				if(sheet3.RowCount() == 1) {
					if(sheet3.GetCellText(2, "admin_reg_yn") == "Y") {
						$("#debitMon").addClass("transparent").attr("readonly", true) ;
						$("#cashMon").addClass("transparent").attr("readonly", true) ;
						$("#cardMon").addClass("transparent").attr("readonly", true) ;
						$("#adminYnText").html( "담당자 입력 적용 취소" ) ;
					} else {
						$("#debitMon").removeClass("transparent").attr("readonly", false) ;
						$("#cashMon").removeClass("transparent").attr("readonly", false) ;
						$("#cardMon").removeClass("transparent").attr("readonly", false) ;
						$("#adminYnText").html( "담당자 입력 적용" ) ;
					}
					$("#debitMon").val(sheet3.GetCellText(2, "add_debit_mon") ) ;
					$("#cashMon").val( sheet3.GetCellText(2, "add_cash_mon") ) ;
					$("#cardMon").val( sheet3.GetCellText(2, "add_card_mon") ) ;
				}
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction1("Search");
				doAction3("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function chagneSearchYyType(value) {
		$('#searchYyType').val(value);
		setBtnColor(value) ;

		if(value == "add") {//추가공제율 사용분(담당자 강제입력 하는 부분, 본인은 수정불가)
			$("#viewSheet").hide() ;
			$("#sheet2Btn").hide() ;
			$("#viewHtml").show() ;
			doAction3("Search");

			return ;//하단로직은 추가공제율 사용분 탭(화면)에 해당되지 않기 때문에 return
		} else {
			$("#viewSheet").show() ;
			$("#sheet2Btn").show() ;
			$("#viewHtml").hide() ;
		}

		/*searchYyType의 OnChange이벤트 강제 적용*/
		if( $("#searchYyType").val() == "0" || $("#searchYyType").val() == "-99") {
			sheet2.SetColEditable("famres",	1);
		} else {
			sheet2.SetColEditable("famres",	0);
		}

		// 반기구분 코드 조회
		var halfGubunList = stfConvCode(ajaxCall("<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectYeaDataCardsHalfGubun", "searchYyType="+ $("#searchYyType").val(), false).codeList, "");
		//신용카드구분 코드 조회
		var cardTypeList = stfConvCode(ajaxCall("<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectYeaDataCardCardType", "searchYyType="+ $("#searchYyType").val(), false).codeList, "");

		sheet2.SetColProperty("half_gubun",	 {ComboText:"|"+halfGubunList[0], ComboCode:"|"+halfGubunList[1]} );
		sheet2.SetColProperty("card_type",	  {ComboText:"|"+cardTypeList[0], ComboCode:"|"+cardTypeList[1]} );

		//양식다운로드 title 정의
		templeteTitle2 = "업로드시 이 행은 삭제 합니다\n\n";
		var codeCdNm = "", codeCd = "", codeNm = "";

		codeCdNm = "";
		codeNm = halfGubunList[0].split("|"); codeCd = halfGubunList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle2 += "반기구분 : " + codeCdNm + "\n";

// 		codeCdNm = "";
// 		codeNm = periodType[0].split("|"); codeCd = periodType[1].split("|");
// 		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
// 		templeteTitle2 += "월구간 : " + codeCdNm + "\n";

		codeCdNm = "";
		codeNm = cardTypeList[0].split("|"); codeCd = cardTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle2 += "카드구분 : " + codeCdNm + "\n";

		templeteTitle2 += "국세청 자료여부 : Y, N \n";

		codeCdNm = "";
		codeNm = feedbackTypeList[0].split("|"); codeCd = feedbackTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle2 += "담당자확인 : " + codeCdNm + "\n";


		doAction2("Search");

	}

	function setBtnColor(value) {
		if(value == "0") {
			$("#yyBtn01").removeClass("button") ;
			$("#yyBtn01").addClass("pink") ;
			$("#yyBtn02").removeClass("pink") ;
			$("#yyBtn02").addClass("button") ;
			$("#yyBtn03").removeClass("pink") ;
			$("#yyBtn03").addClass("button") ;
			$("#yyBtn04").removeClass("pink") ;
			$("#yyBtn04").addClass("button") ;
			$("#yyBtn05").removeClass("pink") ;
			$("#yyBtn05").addClass("button") ;
		} else if(value == "-1") {
			$("#yyBtn01").removeClass("pink") ;
			$("#yyBtn01").addClass("button") ;
			$("#yyBtn02").removeClass("button") ;
			$("#yyBtn02").addClass("pink") ;
			$("#yyBtn03").removeClass("pink") ;
			$("#yyBtn03").addClass("button") ;
			$("#yyBtn04").removeClass("pink") ;
			$("#yyBtn04").addClass("button") ;
			$("#yyBtn05").removeClass("pink") ;
			$("#yyBtn05").addClass("button") ;
		} else if(value == "-2") {
			$("#yyBtn01").removeClass("pink") ;
			$("#yyBtn01").addClass("button") ;
			$("#yyBtn02").removeClass("pink") ;
			$("#yyBtn02").addClass("button") ;
			$("#yyBtn03").removeClass("button") ;
			$("#yyBtn03").addClass("pink") ;
			$("#yyBtn04").removeClass("pink") ;
			$("#yyBtn04").addClass("button") ;
			$("#yyBtn05").removeClass("pink") ;
			$("#yyBtn05").addClass("button") ;
		} else if(value == "-99") {
			$("#yyBtn01").removeClass("pink") ;
			$("#yyBtn01").addClass("button") ;
			$("#yyBtn02").removeClass("pink") ;
			$("#yyBtn02").addClass("button") ;
			$("#yyBtn03").removeClass("pink") ;
			$("#yyBtn03").addClass("button") ;
			$("#yyBtn04").removeClass("button") ;
			$("#yyBtn04").addClass("pink") ;
			$("#yyBtn05").removeClass("pink") ;
			$("#yyBtn05").addClass("button") ;
		} else if(value == "add") {
			$("#yyBtn01").removeClass("pink") ;
			$("#yyBtn01").addClass("button") ;
			$("#yyBtn02").removeClass("pink") ;
			$("#yyBtn02").addClass("button") ;
			$("#yyBtn03").removeClass("pink") ;
			$("#yyBtn03").addClass("button") ;
			$("#yyBtn04").removeClass("pink") ;
			$("#yyBtn04").addClass("button") ;
			$("#yyBtn05").removeClass("button") ;
			$("#yyBtn05").addClass("pink") ;
		}
	}

	function setAdminRegYn() {

		if(sheet3.RowCount() == 0) {
			alert("담당자 입력 금액이 존재하지 않습니다.") ;
		} else {
			if( sheet3.GetCellValue( 2, "admin_reg_yn" ) == "Y" ) {
				sheet3.SetCellValue( 2, "admin_reg_yn", "N" );
			} else {
				sheet3.SetCellValue( 2, "admin_reg_yn", "Y" );
			}
		}

		sheet3.DoSave( "<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=saveYeaDataAddCards");
	}

	$(function() {
        $('#cute_gray_authA').tooltip({
           items: '*',
           content: helpText,
           show: "slideDown", //show immediately
           open: function(event, ui) {
        	  var $element = $(event.target);
        	  ui.tooltip.click(function () {
                  $element.tooltip('close');
              });
        	  ui.tooltip.css("max-width", "1000px");
        	  ui.tooltip( "open" );
           }
        });

        //클릭시 툴팁 실행
        $('#cute_gray_authA').tooltip({
            disabled: true,
            close: function(event, ui) { $(this).tooltip('disable'); }
        });

      	//클릭시 툴팁 실행
        $('#cute_gray_authA').on('click', function() {
            $(this).tooltip('enable').tooltip('open');
        });
    })

    $(document).ready(function(){

    	$("#InfoMinus").hide();

    	/* 보험료안내 버튼 기능 Start */
    	//안내+ 버튼 선택시 안내- 버튼 호출
    	$("#InfoPlus").live("click",function(){
	    		var btnId = $(this).attr('id');
	    		if(btnId == "InfoPlus"){
	    			$("#InfoMinus").show();
	    			$("#InfoPlus").hide();
	    		}
    	});

    	//안내- 버튼 선택시 안내+ 버튼 호출
    	$("#InfoMinus").live("click",function(){
    			var btnId = $(this).attr('id');
	    		if(btnId == "InfoMinus"){
	    			$("#InfoPlus").show();
	    			$("#InfoMinus").hide();
	    		}
		});

    	//안내+ 선택시 화면 호출
    	$("#InfoPlus").click(function(){
    		$("#infoLayer").show("fast");
    		$("#infoLayerMain").show("fast");
        });

    	//안내- 선택시 화면 숨김
    	$("#InfoMinus").click(function(){
    		$("#infoLayer").hide("fast");
    		$("#infoLayerMain").hide("fast");
        });
    	/* 보험료안내 버튼 기능 End */
    });

  //기본공제안내 안내 팝업 실행후 클릭시 창 닫음
    $(document).mouseup(function(e){
    	if(!$("#infoLayer div").is(e.target)&&$("#infoLayer div").has(e.target).length==0){
    		$("#infoLayer").fadeOut();
    		$("#infoLayerMain").fadeOut();
    		$("#InfoMinus").hide();
    		$("#InfoPlus").show();
    	}
    });
</script>
</head>
<body  style="overflow-x:hidden;overflow-y:auto;">
<div class="wrapper">

	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	<input type="hidden" id="searchDpndntYn" name="searchDpndntYn" value="" />
	<input type="hidden" id="menuNm" name="menuNm" value="" />
	</form>

	<div id="infoLayer" class="new" style="display:none"></div>

	<!-- Sample Ex&Image End -->
    <table class="default line outer" style="margin-top:10px !important;">
        <colgroup>
            <col width="20%" />
            <col width="20%" />
            <col width="20%" />
            <col width="20%" />
            <col width="" />
        </colgroup>
        <tr>
            <th class="center">자료유형</th>
            <th class="center">국세청(PDF 업로드)</th>
            <th class="center">국세청(입력)</th>
            <th class="center">기타</th>
        </tr>
        <tr>
            <th class="center">2021년 금액</th>
            <td class="right">
                <input id="ntsIn" name="ntsIn" type="text" class="text w50p right transparent" readOnly /> 원
            </td>
            <td class="right">
                <input id="ntsMn" name="ntsMn" type="text" class="text w50p right transparent" readOnly /> 원
            </td>
            <td class="right">
                <input id="etcSum" name="etcSum" type="text" class="text w50p right transparent" readOnly /> 원
            </td>
        </tr>
        <tr>
            <th class="center">2020년 금액</th>
            <td class="right">
                <input id="be_ntsIn" name="be_ntsIn" type="text" class="text w50p right transparent" readOnly /> 원
            </td>
            <td class="right">
                <input id="be_ntsMn" name="be_ntsMn" type="text" class="text w50p right transparent" readOnly /> 원
            </td>
            <td class="right">
                <input id="be_etcSum" name="be_etcSum" type="text" class="text w50p right transparent" readOnly /> 원
            </td>
        </tr>
    </table>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><span name="toYear" style="font-weight:bold;"></span> 신용카드<span class="txt"> ※ 총급여 25% 미만의 연간 총액은 공제금액이 발생하지 않습니다.(도서공연등사용분은 총급여 7천 이하자만 별도공제됨)</span>
			<span id="paytotMonViewYn">
               	<a href="javascript:paytotMonView();" class="basic btn-red-outline authA">총급여 25%확인</a>
			</span>
			<span id="span_paytotMonView" ></span>
			<!-- <a href="javascript:yeaDataExpPopup('신용카드', helpText, 500, 770)" class="cute_gray authA">신용카드 안내</a> -->
			<!-- <a href = "#" class="cute_gray" id="cute_gray_authA" >신용카드 안내</a> -->
			<a href="#layerPopup" class="basic btn-white ico-question" id="InfoPlus"><b>신용카드 안내+</b></a>
	        <a href="#layerPopup" class="basic btn-white ico-question" id="InfoMinus" style="display:none"><b>신용카드 안내-</b></a>
			</li>
		</ul>
		<ul>
			<li class="btn">
			<span id="sheet1Btn" name="sheet1Btn">
<!-- 				<span>월구간</span> -->
<!-- 				<select id="searchPeriodType1" name="searchPeriodType1" onchange="javascript:doAction1('Search');"> -->
<!-- 					<option value="" selected="selected">전체</option> -->
<!-- 					<option value="1">3월</option> -->
<!-- 					<option value="2">4월~7월</option> -->
<!-- 					<option value="3">그 외</option> -->
<!-- 				</select> -->
				<a href="javascript:doAction1('Search');" 		class="basic authR">조회</a>
			</span>

		</li>
		</ul>
		</div>
		<div style="height:250px;">
			<script type="text/javascript">createIBSheet("sheet1", "100%", "250px"); </script>
		</div>
	</div>

	<form id="sheetForm2" name="sheetForm2" >
	<div class="sheet_title outer">
		<ul>
			<li class="txt"> <select id="searchYyType" name="searchYyType" class="hide"></select>
<!-- 			<a id="yyBtn01" name ="yyBtn01" href="javascript:chagneSearchYyType('0');" 		class="pink authR">2016</a> -->
<!-- 			<a id="yyBtn02" name ="yyBtn02" href="javascript:chagneSearchYyType('-1');" 		class="button authR">2015</a> -->
<!-- 			<a id="yyBtn03" name ="yyBtn03" href="javascript:chagneSearchYyType('-2');" 		class="button authR">2014</a> -->
<!-- 			<a id="yyBtn04" name ="yyBtn04" href="javascript:chagneSearchYyType('-99');" 		class="button authR">전체</a> -->
<!-- 			<a id="yyBtn05" name ="yyBtn05" href="javascript:chagneSearchYyType('add');" 		class="button authR">추가공제율 사용분</a> -->
<!-- 				<span class="txt hide"> ※ [반기구분=당해 전체]는 [신용카드구분=근로제공기간 이외 (본인) 신용카드등 사용액]의 경우에만 선택가능합니다.</span> -->
			</li>
			<li class="btn">
			<span id="sheet2Btn" name="sheet2Btn">
<!-- 				<span>월구간</span> -->
<!-- 				<select id="searchPeriodType" name="searchPeriodType" onchange="javascript:doAction2('Search');"> -->
<!-- 					<option value="" selected="selected">전체</option> -->
<!-- 					<option value="1">3월</option> -->
<!-- 					<option value="2">4월~7월</option> -->
<!-- 					<option value="3">그 외</option> -->
<!-- 				</select> -->
                <!-- 사용연도 추가 (2021.11.12) -->
                <span>사용연도</span>
                <select id="searchUseYyyy" name="searchUseYyyy" onchange="javascript:doAction2('Search');">
                    <option value="2021" selected="selected">2021</option>
                    <option value="2020">2020</option>
                </select>
				<span>&nbsp;&nbsp;신용카드 구분</span>
				<select id="inputCardType" name ="inputCardType" onChange="javascript:doAction2('Search')" class="box">
					<option value="" selected="selected">전체</option>
				</select>
				<a href="javascript:doAction2('Search');" 		class="basic authR">조회</a>
				<span id="btnDisplayYn01">
<%if("Y".equals(adminYn)) {%>
				<span id="copyBtn">
				 <a href="javascript:doAction2('Down2Template')"	class="basic btn-download authA">양식 다운로드</a>
			   	<a href="javascript:doAction2('LoadExcel')"   	class="basic btn-upload authA">업로드</a>
				 <a href="javascript:doAction2('Copy');" 		class="basic authA">복사</a>
				</span>
<%} %>
					<a href="javascript:doAction2('Insert');" 		class="basic authA">입력</a>
					<a href="javascript:doAction2('Save');" 		class="basic btn-save authA">저장</a>
				</span>
				<a href="javascript:doAction2('Down2Excel');" 	class="basic btn-download authR">다운로드</a>
			</span>
		</li>
		</ul>
	</div>
	</form>
	<!-- 시트표시 -->
	<span id="viewSheet" name="viewSheet">
		<div style="height:300px" >
			<script type="text/javascript">createIBSheet("sheet2", "100%", "280px"); </script>
		</div>
	</span>
	<!-- html 태그 표시 -->
	<span id="viewHtml" name="viewHtml">
		<div style="height:250px" >
			<div class="outer">
		    <div class="sheet_title">
		        <ul>
		            <li class="txt"> 추가공제율 사용분 담당자 입력
		            </li>
		            <li class="btn right">
<!--             		<a href="javascript:doAction3('Search');" 		class="basic authR">조회</a> -->
            			<a href="javascript:setAdminRegYn();" 		class="basic authA"><span id="adminYnText" name="adminYnText"> </span></a>
            			<a href="javascript:doAction3('Save');" 		class="basic btn-save authA">저장</a>
		    		</li>
		        </ul>
		    </div>
		    </div>
		    <table border="0" cellpadding="0" cellspacing="0" class="default line outer">
			<colgroup>
				<col width="20%" />
				<col width="10%" />
				<col width="20%" />
				<col width="10%" />
				<col width="20%" />
				<col width="10%" />
				<col width="" />
			</colgroup>
			<tr>
				<th class="left">신용카드</th>
				<td class="right">
					<input id="cardMon" name="cardMon"  type="text" class="text w150 right" /> 원
				</td>
				<th class="left">현금영수증</th>
				<td class="right">
					<input id="cashMon" name="cashMon"  type="text" class="text w150 right" /> 원
				</td>
				<th class="left">직불카드등</th>
				<td class="right">
					<input id="debitMon" name="debitMon"  type="text" class="text w150 right" /> 원
				</td>
			</tr>
			</table>
		</div>
		<span class="hide">
			<script type="text/javascript">createIBSheet("sheet3", "100%", "300px"); </script>
		</span>
	</span>

</div>
</body>
</html>