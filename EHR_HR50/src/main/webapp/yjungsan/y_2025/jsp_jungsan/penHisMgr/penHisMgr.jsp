<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>개인연금등내역관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	//작업구분
    var adjustTypeList = null;
  	//자료입력유형
    var inputTypeList = null;
  	//금융기관구분
    var financeOrgCdList = null;
  //연금저축구분
    var savingDeductTypeList = null;
  //퇴직연금구분
    var retPenTypeList = null;
  //담당자확인(2021.10.25)
    var feedbackTypeList = null;  	

	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchYear").val("<%=yeaYear%>") ;

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
   			{Header:"삭제|삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
   			{Header:"상태|상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			{Header:"DOC_SEQ|DOC_SEQ",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"DOC_SEQ_DETAIL|DOC_SEQ_DETAIL",Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq_detail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
	          <%// 20250502. 시트 7.0.0.0-20131223-17 버전에서는 SetColProperty 로 DefaultValue가 지원되지 않음. => initdata 세팅으로 조정
	            // 20250418. OnLoadExcel 이벤트에서 RowCount 반복 수행으로 인한 성능저하. case "LoadExcel"의 디폴트 값 세팅으로 개선.%>
   			{Header:"대상년도|대상년도",			Type:"Text",      Hidden:0,  Width:60,    Align:"Center",  ColMerge:1,   SaveName:"work_yy",			KeyField:1,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4, DefaultValue:"<%=yeaYear%>" },
	        {Header:"정산구분|정산구분",			Type:"Combo",     Hidden:0,  Width:120,    Align:"Center",  ColMerge:1,   SaveName:"adjust_type",		KeyField:1,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	        {Header:"부서명|부서명",			Type:"Text",      Hidden:0,  Width:90,    Align:"Left",    ColMerge:1,   SaveName:"org_nm",				KeyField:0,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	        {Header:"성명|성명",			Type:"Popup",	  Hidden:0,  Width:70,    Align:"Center",  ColMerge:1,   SaveName:"name",				KeyField:0,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
	        {Header:"사번|사번",			Type:"Text",      Hidden:0,  Width:80,    Align:"Center",  ColMerge:1,   SaveName:"sabun",				KeyField:1,		CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
	        {Header:"연금저축구분|연금저축구분",		Type:"Combo",     Hidden:0,  Width:102,   Align:"Left",    ColMerge:1,   SaveName:"saving_deduct_type",	KeyField:1,		CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	        {Header:"퇴직연금\n구분|퇴직연금\n구분",	Type:"Combo", 	  Hidden:0,  Width:68,	Align:"Left",	ColMerge:1,	SaveName:"ret_pen_type",	KeyField:0,	    CalcLogic:"",   Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
	        {Header:"금융기관|금융기관",			Type:"Combo",     Hidden:0,  Width:110,   Align:"Left",    ColMerge:1,   SaveName:"finance_org_cd",		KeyField:1,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	        {Header:"계좌번호|계좌번호",			Type:"Text",      Hidden:0,  Width:120,   Align:"Center",  ColMerge:1,   SaveName:"account_no",			KeyField:1,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:200 },
	        {Header:"금액 (ISA계좌 포함)|직원용",	Type:"AutoSum",       Hidden:1,  Width:80,    Align:"Right",   ColMerge:1,   SaveName:"input_mon",			KeyField:0,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        {Header:"금액 (ISA계좌 포함)|담당자용",	Type:"AutoSum",		  Hidden:0,  Width:90,    Align:"Right",   ColMerge:1,   SaveName:"appl_mon",			KeyField:1,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        {Header:"공제 (ISA계좌 포함)|공제금액",			Type:"Text",      Hidden:1,  Width:70,    Align:"Left",    ColMerge:1,   SaveName:"ded_mon",			KeyField:0,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        {Header:"ISA계좌 금액| 직원용",	Type:"AutoSum",       Hidden:1,  Width:80,    Align:"Right",   ColMerge:1,   SaveName:"input_mon_isa",			KeyField:0,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        {Header:"ISA계좌 금액| 담당자용",	Type:"AutoSum",		  Hidden:0,  Width:90,    Align:"Right",   ColMerge:1,   SaveName:"appl_mon_isa",			KeyField:0,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        {Header:"ISA계좌 금액| 공제금액",			Type:"Text",      Hidden:1,  Width:70,    Align:"Left",    ColMerge:1,   SaveName:"ded_mon_isa",			KeyField:0,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        {Header:"자료입력유형|자료입력유형",		Type:"Combo",     Hidden:0,  Width:90,    Align:"Center",  ColMerge:1,   SaveName:"adj_input_type",		KeyField:1,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
	       // {Header:"국세청\n자료여부",	Type:"CheckBox",  Hidden:0,  Width:70,    Align:"Center",  ColMerge:1,   SaveName:"nts_yn",				KeyField:0,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
	        {Header:"납입횟수|납입횟수",			Type:"Text",      Hidden:1,  Width:10,    Align:"Left",    ColMerge:1,   SaveName:"paying_num_cd",		KeyField:0,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"REG_DT|REG_DT",Type:"Text",       Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"reg_dt",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:40 },
            {Header:"담당자확인|담당자확인",          Type:"Combo",       Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"feedback_type",       KeyField:0, Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }
	       ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	        //20250414 대량데이터 저장 시, 50건 단위로 분할 처리하도록 사이즈 지정
	        try { IBS_setChunkedOnSave("sheet1", { chunkSize : 50 });  } catch(e) { console.info("info", e + ". chunkSize 기능은 [ibsheetinfo.js]의 DoSave 오버라이딩이 필요합니다." ); }     try { sheet1.SetLoadExcelConfig({ "MaxFileSize": 1 /* 1MB */ }); } catch(e) { console.info("info", e + ". MaxFileSize 옵션은 7.0.13.27 버전부터 제공됩니다." ); }
	        
		//작업구분
        adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );
		//자료입력유형
        inputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00325"), "전체" );
		//금융기관구분
        financeOrgCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00319"), "" );
		//연금저축구분
        savingDeductTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&note1='2'&queryId=getCommonCodeNote1List&searchYear=<%=yeaYear%>", "C00317"), "" );
		//퇴직연금구분
        retPenTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00318"), "");
		
		sheet1.SetColProperty("adj_input_type", {ComboText:inputTypeList[0], ComboCode:inputTypeList[1]});
		sheet1.SetColProperty("finance_org_cd", {ComboText:financeOrgCdList[0], ComboCode:financeOrgCdList[1]});
		sheet1.SetColProperty("saving_deduct_type", {ComboText:savingDeductTypeList[0], ComboCode:savingDeductTypeList[1]});
		sheet1.SetColProperty("ret_pen_type",		{ComboText:"|"+retPenTypeList[0], ComboCode:"|"+retPenTypeList[1]} );

		$("#searchAdjustType").html(adjustTypeList[2]).val("1");
		$("#searchInputType").html(inputTypeList[2]);

		//담당자확인(2021.10.25)
        feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00329"), "전체");
        sheet1.SetColProperty("feedback_type",  {ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
        $("#searchFeedBackType").html(feedbackTypeList[2]);

        // 사업장(권한 구분)
		var ssnSearchType  = "<%=ssnSearchType%>";
		var bizPlaceCdList = "";

		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);

        $(window).smartresize(sheetResize); sheetInit();

        getCprBtnChk();
        
		//doAction1("Search");
		
		//양식다운로드 title 정의
		var codeCdNm = "", codeCd = "", codeNm = "";

		codeCdNm = "";
		codeNm = savingDeductTypeList[0].split("|"); codeCd = savingDeductTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "연금저축구분 : " + codeCdNm + "\n";

		codeCdNm = "";
		codeNm = financeOrgCdList[0].split("|"); codeCd = financeOrgCdList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "금융기관 : " + codeCdNm + "\n";

		codeCdNm = "";
		codeNm = inputTypeList[0].split("|"); codeCd = inputTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "자료입력유형 : " + codeCdNm + "\n";
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
			sheet1.DoSearch( "<%=jspPath%>/penHisMgr/penHisMgrRst.jsp?cmd=selectPenHisMgrList", $("#sheetForm").serialize() );
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
					/*
 					if( (sheet1.GetCellValue(i, "saving_deduct_type") == "11" || sheet1.GetCellValue(i, "saving_deduct_type") == "12")
 							&& sheet1.GetCellValue(i, "ret_pen_type") == "") {
 						alert("퇴직연금일때 퇴직연금 구분을 반드시 선택해 주시기 바랍니다.");
 						sheet1.SelectCell(i, "ret_pen_type");
 						return;
 					}
					*/
				}
			}

			sheet1.DoSave( "<%=jspPath%>/penHisMgr/penHisMgrRst.jsp?cmd=savePenHisMgr");
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
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N",menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
		case "Down2Template":
			var param  = {DownCols:"adjust_type"
                                    +"|sabun|saving_deduct_type|ret_pen_type|finance_org_cd|account_no|appl_mon|appl_mon_isa|adj_input_type",SheetDesign:1,Merge:1,DownRows:"0|1",ExcelFontSize:"9"
				,TitleText:templeteTitle1,UserMerge :"0,0,1,8",menuNm:$(document).find("title").text()
                ,HiddenColumn:1 //  열숨김 반영 여부 (Default: 0)
                };
			sheet1.Down2Excel(param);
			break;
        case "LoadExcel":
			if(chkRqr()){
                break;
           	}

            // 20250418. OnLoadExcel 이벤트에서 RowCount 반복 수행으로 인한 성능저하. case "LoadExcel"의 디폴트 값 세팅으로 개선.
            // 20250502. 시트 7.0.0.0-20131223-17 버전에서는 SetColProperty 로 DefaultValue가 지원되지 않음. 
            //              work_yy     => initdata 세팅으로 조정 
            //              adjust_type => 엑셀 양식에서 key-in으로 조정
            //sheet1.SetColProperty(0, "work_yy", { DefaultValue: $("#searchYear").val() } );
            //sheet1.SetColProperty(0, "adjust_type", { DefaultValue: $("#searchAdjustType").val() } );
            
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
			// 연금구분이 퇴직연금 일때만 퇴직연금구분 항목 활성화
			if(sheet1.GetCellValue(Row, "saving_deduct_type") == "11" || sheet1.GetCellValue(Row, "saving_deduct_type") == "12") {
				sheet1.SetCellEditable(Row, "ret_pen_type", true);
			} else {
				sheet1.SetCellValue(Row, "ret_pen_type", "");
				sheet1.SetCellEditable(Row, "ret_pen_type", false);
			}

			// 자료입력유형
			if( sheet1.ColSaveName(Col) == "adj_input_type" ) {
				if(sheet1.GetCellValue(Row,"adj_input_type")=="07") {
					alert("PDF업로드는 선택할 수 없습니다.");
					sheet1.SetCellValue(Row,"adj_input_type",OldValue);
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
	
	//수정(이력) 관련 세팅
	function getCprBtnChk(){
        var params = "&cmbMode=all"
                   + "&searchWorkYy=" + $("#searchYear").val() 
                   + "&searchAdjustType="
                   + "&searchSabun=" ;
		
        //재계산 차수 값 조회
		var strUrl = "<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getReCalcSeq884" + params ;
		var searchReCalcSeq = stfConvCode( codeList(strUrl,"") , "");
		
		if(searchReCalcSeq == null || searchReCalcSeq == "" || searchReCalcSeq[0] == "") {
			$("#searchAdjustType").html("");
		} else {
   			$("#searchAdjustType").html("<option value=''>전체</option>" + searchReCalcSeq[2].replace(/<option value='1'>/g, "<option value='1' selected>"));
   			sheet1.SetColProperty("adjust_type", {ComboText:"|"+searchReCalcSeq[0], ComboCode:"|"+searchReCalcSeq[1]});
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
				<%-- 무의미한 분기문 주석 처리 20240919
				if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
				--%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%-- 무의미한 분기문 주석 처리 20240919}else{%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%}--%>
				</td>
				<td><span>정산구분</span>
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

				<td><span>사번/성명</span>
				<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
				<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
			</tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">개인연금등내역관리</li>
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