<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>저축내역관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%

	String ssnSearchType = (String)session.getAttribute("ssnSearchType");
	Date today = new Date();
	SimpleDateFormat date = new SimpleDateFormat("yyyy");
	//이번년도
	String toYear = date.format(today);

	//3년전
	Calendar mon = Calendar.getInstance();
	mon.add(Calendar.YEAR , -3);
	String beforeYear = new java.text.SimpleDateFormat("yyyy").format(mon.getTime());

%>
<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";

  	//3년전
    var beforeYear = "<%=beforeYear%>";
  	//이번년도
    var toYear = "<%=toYear%>";
    //기준년도
    var systemYY;
    //중소기업창업투자조합 체크여부
    var smallCompYn = "N";

	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchYear").val("<%=yeaYear%>") ;
		$("#searchYmd1").mask("1111-11-11") ;	$("#searchYmd1").datepicker2({startdate:"searchYmd2"});
		$("#searchYmd2").mask("1111-11-11") ;	$("#searchYmd2").datepicker2({enddate:"searchYmd1"});
		systemYY = $("#searchYear").val();
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
   			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
   			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
	        {Header:"대상년도",		Type:"Text",      Hidden:0,  Width:60,    Align:"Center",  ColMerge:1,   SaveName:"work_yy",			KeyField:1,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
	        {Header:"정산구분",		Type:"Combo",     Hidden:0,  Width:70,    Align:"Center",  ColMerge:1,   SaveName:"adjust_type",		KeyField:1,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	        {Header:"부서명",			Type:"Text",      Hidden:0,  Width:90,    Align:"Left",    ColMerge:1,   SaveName:"org_nm",				KeyField:0,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	        {Header:"성명",			Type:"Popup",	  Hidden:0,  Width:60,    Align:"Center",  ColMerge:1,   SaveName:"name",				KeyField:0,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
	        {Header:"사번",			Type:"Text",      Hidden:0,  Width:60,    Align:"Center",  ColMerge:1,   SaveName:"sabun",				KeyField:1,		CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"저축구분",		Type:"Combo",     Hidden:0,  Width:100,   Align:"Left",   ColMerge:1, SaveName:"saving_deduct_type",  KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"금융기관",		Type:"Combo",     Hidden:0,  Width:90,   Align:"Left",   ColMerge:1, SaveName:"finance_org_cd",      KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"가입일자",       Type:"Date",      Hidden:0,  Width:60,   Align:"Center",   ColMerge:1, SaveName:"reg_dt",      KeyField:1, Format:"Ymd",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"가입일자",		Type:"Text",      Hidden:1,  Width:60,   Align:"Center",   ColMerge:1, SaveName:"reg_dt2",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 },
            {Header:"납입횟수",       Type:"Text",      Hidden:1,  Width:60,   Align:"Left",   ColMerge:1, SaveName:"paying_num_cd",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"계좌번호\n(또는증권번호)",	Type:"Text",      Hidden:0, Width:90,   Align:"Center", ColMerge:1, SaveName:"account_no",          KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:200 },
			{Header:"금액자료(직원용)",			Type:"AutoSum",	  Hidden:1,	Width:90,	Align:"Right",	 ColMerge:1,	SaveName:"input_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"금액(담당자용)",			Type:"AutoSum",	  Hidden:0,	Width:90,	Align:"Right",	 ColMerge:1,	SaveName:"appl_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
            {Header:"공제금액",               Type:"AutoSum",         Hidden:1,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"ded_mon",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"자료입력유형",		Type:"Combo",	  Hidden:0,	Width:60,	Align:"Right",	 ColMerge:1,	SaveName:"adj_input_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"국세청\n자료여부",	Type:"CheckBox",  Hidden:0,	Width:60,	Align:"Center",	 ColMerge:1,	SaveName:"nts_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"DOC_SEQ",		Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
            {Header:"DOC_SEQ_DETAIL",Type:"Text",       Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"doc_seq_detail",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:40 },
            {Header:"담당자확인",            Type:"Text",    Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"feedback_type",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }

			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00303"), "전체" );
		var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "");
        var financeOrgCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&orderBy=code_nm","C00319"), "");
        var savingDeductTypeList = stfConvCode( ajaxCall("<%=jspPath%>/savHisMgr/savHisMgrRst.jsp?cmd=selectSavHisMgrSavingDeductType","",false).codeList, "");

        sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
        sheet1.SetColProperty("adj_input_type",     {ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
        sheet1.SetColProperty("finance_org_cd",     {ComboText:"|"+financeOrgCdList[0], ComboCode:"|"+financeOrgCdList[1]} );
        sheet1.SetColProperty("saving_deduct_type", {ComboText:"|"+savingDeductTypeList[0], ComboCode:"|"+savingDeductTypeList[1]} );

		$("#searchAdjustType").html(adjustTypeList[2]).val("1");
		$("#searchInputType").html("<option value=''>전체</option>"+adjInputTypeList[2]);
		$("#searchSavingDeductType").html("<option value=''>전체</option>"+savingDeductTypeList[2]);

		//담당자확인(2021.10.25)
        var feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00329"), "전체");
        sheet1.SetColProperty("feedback_type",  {ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
        $("#searchFeedBackType").html(feedbackTypeList[2]);

        // 사업장(권한 구분)
		var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";
		var bizPlaceCdList = "";

		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);

        $(window).smartresize(sheetResize); sheetInit();

		//doAction1("Search");

		//양식다운로드 title 정의
		var codeCdNm = "", codeCd = "", codeNm = "";

		codeCdNm = "";
		codeNm = adjustTypeList[0].split("|"); codeCd = adjustTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "정산구분 : " + codeCdNm + "\n";

		codeCdNm = "";
		codeNm = savingDeductTypeList[0].split("|"); codeCd = savingDeductTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "연금저축구분 : " + codeCdNm + "\n";

		codeCdNm = "";
		codeNm = financeOrgCdList[0].split("|"); codeCd = financeOrgCdList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "금융기관 : " + codeCdNm + "\n";

		codeCdNm = "";
		codeNm = adjInputTypeList[0].split("|"); codeCd = adjInputTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "자료입력유형 : " + codeCdNm + "\n";

		templeteTitle1 += "국세청 자료여부 : Y, N \n";
	});

	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/savHisMgr/savHisMgrRst.jsp?cmd=selectSavHisMgrList", $("#sheetForm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1, "work_yy|adjust_type|sabun|saving_deduct_type|finance_org_cd|account_no", true, true)) {break;}

			for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
				if( sheet1.GetCellValue(i, "sStatus") == "U" ||
					sheet1.GetCellValue(i, "sStatus") == "I" ||
					sheet1.GetCellValue(i, "sStatus") == "S"
				) {
					if(sheet1.GetCellValue(i,"adj_input_type")=="07") {
						alert('PDF업로드는 선택할 수 없습니다.');
						sheet1.SelectCell(i, "adj_input_type");
						return;
					}

					if( sheet1.GetCellValue(i, "saving_deduct_type") == "21") {
						if( sheet1.GetCellValue(i, "reg_dt") == "") {
							alert("개인연금저축일때 가입일자는 필수입력입니다.");
							sheet1.SelectCell(i, "reg_dt");
							return;
						}

						if ( sheet1.GetCellValue(i, "reg_dt").length == 8 && "20001231" < sheet1.GetCellValue(i, "reg_dt") ) {
							alert("개인연금저축일때 가입일자는 2000년 12월 31일 이전이어야 합니다.");
							sheet1.SelectCell(i, "reg_dt");
							return;
						}
					}
				}
			}
			var vsInsertCheck = sheet1.FindStatusRow("I|U");
			var insertArray    = vsInsertCheck.split(";");

			if(vsInsertCheck != "" && vsInsertCheck != null){

				var yearPattern = /^(19[7-9][0-9]|20\d{2})$/;

				for(var j = 0; j < insertArray.length; j++){

					//중소기업창업투자조합(벤처등) 또는 중소기업창업투자조합(조합등) 선택시
					if(sheet1.GetCellValue(insertArray[j],"saving_deduct_type")=='55' || sheet1.GetCellValue(insertArray[j],"saving_deduct_type")=='60'){

						if((sheet1.GetCellValue(insertArray[j], "reg_dt") < beforeYear) || (sheet1.GetCellValue(insertArray[j], "reg_dt") > toYear) ){
							alert("귀속년도부터 3년전까지만 입력할수 있습니다. ex)2019 ~ 2021");
			                sheet1.SetCellValue(insertArray[j],"reg_dt", "");
			                return;
						}

						if(!yearPattern.test(sheet1.GetCellValue(insertArray[j], "reg_dt"))) {
							alert("년도 형식이 다릅니다. ex)2019 ~ 2021");
							sheet1.SetCellValue(insertArray[j],"reg_dt", "");
							return;
						}
					}
				}
			}
			sheet1.DoSave( "<%=jspPath%>/savHisMgr/savHisMgrRst.jsp?cmd=saveSavHisMgr");
			break;
		case "Insert":

			if(chkRqr()){
                break;
           	}
			var Row = sheet1.DataInsert(0) ;
			sheet1.SetCellValue(Row, "work_yy", $("#searchYear").val() ) ;
			sheet1.SetCellValue(Row, "adjust_type", $("#searchAdjustType").val() ) ;
			break;
		case "Copy":
			if (sheet1.GetCellValue(sheet1.GetSelectRow(), "adj_input_type") == "07") {
				alert("PDF업로드 자료는 복사할 수 없습니다.");
				return;
			}

			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
			case "Down2Excel":
			// 2024.10.02
			// reg_dt컬럼에 Date, Text타입이 둘 다 있을경우 엑셀에서 데이터가 이상하게 보이는 문제가 있어
			// 엑셀 다운시에는 Text타입으로만 받기위해 SetColHidden() 세팅
			// 주의: reg_dt2 는 날짜를 계산하는 부분이 있음으로 Format 변경하면 안됨
			sheet1.SetColHidden("reg_dt", 1);
			sheet1.SetColHidden("reg_dt2", 0);

			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N",menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);

			sheet1.SetColHidden("reg_dt", 0);
			sheet1.SetColHidden("reg_dt2", 1);
			break;
		case "Down2Template":
			var param  = {DownCols:"3|4|7|8|9|10|12|14|16|17",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
				,TitleText:templeteTitle1,UserMerge :"",menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
        case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		}
	}

	function chkRqr(){

        var chkSearchAdjustType    = $("#searchAdjustType").val();

        var chkValue = false;

        if(chkSearchAdjustType == ''){
            alert("정산구분을 선택 후 입력 할 수 있습니다.");
            chkValue = true;
        }

        return chkValue;
    }

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if (Code == 1) {
				for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){

					//중소기업창업투자조합(벤처등) 또는 중소기업창업투자조합(조합등) 로드시
					 if(sheet1.GetCellValue(i,"saving_deduct_type")=='55' || sheet1.GetCellValue(i,"saving_deduct_type")=='60'){
						//텍스트타입
						var info = {Type: "Text", Align: "Center", Edit: 0};
					    sheet1.InitCellProperty(i, "reg_dt", info);

					    var vsHvalue= sheet1.GetCellValue(i, "reg_dt2");
					    sheet1.SetCellValue(i,"reg_dt", vsHvalue);
					    sheet1.SetCellValue(i,"sStatus", "R");
					}
					if (sheet1.GetCellValue(i, "adj_input_type") == "07") { //PDF
						sheet1.SetRowEditable(i, 0);
					}
				}
			}

			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction1('Search');
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	var gPRow  = "";
	var pGubun = "";

	//팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				openEmployeePopup(Row) ;
			}
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	//클릭시 발생
	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "sDelete" ) {
				if(sheet1.GetCellValue(Row,"sStatus") != "I" && sheet1.GetCellValue(Row,"adj_input_type")=="07") {
					alert('PDF업로드자료는 PDF등록 탭에서 반영제외하면 현재 화면에서 삭제됩니다.');
					sheet1.SetCellValue(Row,"sDelete", "0");
				}
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	//값이 바뀔때 발생
	function sheet1_OnChange(Row, Col, Value, OldValue) {
		try{
			// 자료입력유형
			if( sheet1.ColSaveName(Col) == "adj_input_type" ) {
				if(sheet1.GetCellValue(Row,"adj_input_type")=="07") {
					alert("PDF업로드는 선택할 수 없습니다.");
					sheet1.SetCellValue(Row,"adj_input_type",OldValue);
				}
			}
			//저축구분 변경시 타십 변경
			if(sheet1.ColSaveName(Col) == "saving_deduct_type"){
				if(sheet1.GetCellValue(Row,"saving_deduct_type")=='21' || sheet1.GetCellValue(Row,"saving_deduct_type")=='50'){
					//달력타입
					var info = {Type: "Date", Align: "Center", Edit: 1};
				    sheet1.InitCellProperty(Row, "reg_dt", info);
				}else if(sheet1.GetCellValue(Row,"saving_deduct_type")=='55' || sheet1.GetCellValue(Row,"saving_deduct_type")=='60'){
					//텍스트타입
					var info = {Type: "Text", Align: "Center", Edit: 1};
				    sheet1.InitCellProperty(Row, "reg_dt", info);
				}else{
					var info = {Type: "Date", Align: "Center", Edit: 1};
				    sheet1.InitCellProperty(Row, "reg_dt", info);
				}
			}
		} catch(ex) {
			alert("OnChange Event Error : " + ex);
		}
	}

	//사원 조회
	function openEmployeePopup(Row){
	    try{
		    var args    = new Array();

		    if(!isPopup()) {return;}
		    gPRow = Row;
		    pGubun = "employeePopup";

		    var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");
	     /*
	        if(rv!=null){
				sheet1.SetCellValue(Row, "name", 		rv["name"] );
				sheet1.SetCellValue(Row, "sabun", 		rv["sabun"] );
				sheet1.SetCellValue(Row, "org_nm", 		rv["org_nm"] );
	        }
	     */
	    } catch(ex) {
	    	alert("Open Popup Event Error : " + ex);
	    }
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "employeePopup" ){
			//사원조회
			sheet1.SetCellValue(gPRow, "name", 		rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"] );
			sheet1.SetCellValue(gPRow, "org_nm", 	rv["org_nm"] );
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="menuNm" name="menuNm" value="" />
    <div class="sheet_search outer">
        <div>
        <table>
			<tr>
			    <td><span>년도</span>
				<%
				if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
				%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%}else{%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%}%>
				</td>
				<td><span>작업구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
				</td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')"></select>
                </td>
				<td><span>자료입력유형</span>
					<select id="searchInputType" name ="searchInputType" onChange="javascript:doAction1('Search')" class="box"></select>
				</td>
			</tr>
			<tr>
                <td>
                    <span>담당자확인</span>
                    <select id="searchFeedBackType" name ="searchFeedBackType" class="box" onChange="javascript:doAction1('Search')"></select>
                </td>
                <td><span>저축구분</span>
                    <select id="searchSavingDeductType" name ="searchSavingDeductType" onChange="javascript:doAction1('Search')" class="box"></select>
                </td>
			</tr>
        </table>
        <table>
			<tr>
				<td><span>가입일자</span>
					<input name="searchYmd1" id="searchYmd1" type="text" class="date2" onFocus="this.select()" value="" maxlength="20" />
					~
					<input name="searchYmd2" id="searchYmd2" type="text" class="date2" onFocus="this.select()" value="" maxlength="20" />
				</td>
                <td><span>사번/성명</span>
                <input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
				<td colspan="3"> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
			</tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">저축내역관리</li>
            <li class="btn">
            	<a href="javascript:doAction1('Down2Template')" class="basic btn-download authA">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')" 	class="basic btn-upload authA">업로드</a>
				<a href="javascript:doAction1('Insert')" 		class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')" 			class="basic authA">복사</a>
				<a href="javascript:doAction1('Save')" 			class="basic btn-save authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')" 	class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>