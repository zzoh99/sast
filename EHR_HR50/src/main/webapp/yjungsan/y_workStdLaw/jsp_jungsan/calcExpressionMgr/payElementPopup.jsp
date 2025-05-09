<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title><span id="titleText">수당,공제 항목</span></title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");
	
	$(function() {
		var callPage 	= "";
		var arg = p.window.dialogArguments;

		var searchElementLinkType1 = "";
		var searchElementLinkType2 = "";
		var elementType = "";
	    var isSep = ""; // 퇴직항목 여부

		if( arg != undefined ) {
			callPage 	= arg["callPage"];

			if (arg["searchElementLinkType"] != null && arg["searchElementLinkType"] != "") {
				searchElementLinkType1 = arg["searchElementLinkType"];
			}
			if (searchElementLinkType1 != "retro") { // 소급이 아닌경우
				if (arg["searchElementLinkType2"] != null && arg["searchElementLinkType2"] != "") {
					searchElementLinkType2 = arg["searchElementLinkType2"];
				} else {
					searchElementLinkType2 = searchElementLinkType1;
				}
			}
			elementType = arg["elementType"];
		    isSep = arg["isSep"];
		}else{
			if(p.popDialogArgument("callPage")!=null)		callPage  	= p.popDialogArgument("callPage");

			if (p.popDialogArgument("searchElementLinkType") != null && p.popDialogArgument("searchElementLinkType") != "") {
				searchElementLinkType1 = p.popDialogArgument("searchElementLinkType");
			}
			if (searchElementLinkType1 != "retro") { // 소급이 아닌경우
				if (p.popDialogArgument("searchElementLinkType2") != null && p.popDialogArgument("searchElementLinkType2") != "") {
					searchElementLinkType2 = p.popDialogArgument("searchElementLinkType2");
				} else {
					searchElementLinkType2 = searchElementLinkType1;
				}
			}
			if(p.popDialogArgument("elementType")!=null)		elementType  	= p.popDialogArgument("elementType");
			if(p.popDialogArgument("isSep")!=null)				isSep  			= p.popDialogArgument("isSep");
		}

		if (elementType == "A") {
        	$("#titleText").html("수당 항목");
        	$("#subTitle1Text").html("수당 항목");
        	$("#subTitle2Text").html("수당 항목");
		} else if (elementType == "D") {
        	$("#titleText").html("공제 항목");
        	$("#subTitle1Text").html("공제 항목");
        	$("#subTitle2Text").html("공제 항목");
		}

        $("#callPage").val(callPage);

        $("#searchElementLinkType1").val(searchElementLinkType1);
        $("#searchElementLinkType2").val(searchElementLinkType2);
        $("#elementType").val(elementType);
        $("#isSep").val(isSep);

		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
			{Header:"No",         	Type:"<%=sNoTy%>",    Hidden:0, Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"항목유형",		Type:"Combo",     Hidden:0,  Width:80,  Align:"Center",  ColMerge:0,   SaveName:"element_type",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"항목코드",		Type:"Text",      Hidden:0,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"element_cd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"항목명",			Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"element_nm",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
			{Header:"Report명",		Type:"Text",      Hidden:0,  Width:120,   Align:"Left",    ColMerge:0,   SaveName:"report_nm",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"절상/사\n구분",	Type:"Combo",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"updown_type",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"단위",			Type:"Combo",     Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"updown_unit",        KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"통화",			Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"currency_cd",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"항목Linkn유형",	Type:"Combo",     Hidden:0,  Width:70,   Align:"Left",    ColMerge:0,   SaveName:"element_link_type",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"시작일자",       Type:"Text",      Hidden:0,  Width:75,   Align:"Center",  ColMerge:0,   SaveName:"sdate",             KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
			{Header:"종료일자",       Type:"Text",      Hidden:0,  Width:75,   Align:"Center",  ColMerge:0,   SaveName:"edate",             KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
		];
		IBS_InitSheet(mySheet, initdata); mySheet.SetCountPosition(4);mySheet.SetEditableColorDiff (0);

		//절상/사\n구분 updownType
        updownTypeList   = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+<%=curSysYear%>,"C00005"), "");
        mySheet.SetColProperty("updown_type",         {ComboText:updownTypeList[0],    ComboCode:updownTypeList[1]} );

        // 단위 updownUnit
		updownUnitList   = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+<%=curSysYear%>,"C00006"), "");
        mySheet.SetColProperty("updown_unit",         {ComboText:updownUnitList[0],    ComboCode:updownUnitList[1]} );

		// 통화 currency
		currencyList   = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+<%=curSysYear%>,"S10030"), "");
        mySheet.SetColProperty("currency_cd",         {ComboText:currencyList[0],    ComboCode:currencyList[1]} );

        //퇴직항목의 경우
        if (isSep != null && (isSep == "Y" || isSep == "EY")) {

        	$("#titleText").html("퇴직 항목");
        	$("#subTitle1Text").html("퇴직 항목");
        	$("#subTitle2Text").html("퇴직 항목");

        	// 통화 숨김
			mySheet.SetColHidden("currency_cd",1);

    		// 항목유형 elementType
    		elementTypeList   = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+<%=curSysYear%>,"C00755"), "");
    		mySheet.SetColProperty("element_type", {ComboText:elementTypeList[0], ComboCode:elementTypeList[1]} );

    		// 항목Link\n유형 elementLinkType
    		elementLinkTypeList   = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+<%=curSysYear%>,"C00770"), "");
            mySheet.SetColProperty("element_link_type", {ComboText:elementLinkTypeList[0], ComboCode:elementLinkTypeList[1]} );

        } else {

        	// 항목유형 elementType
    		mySheet.SetColProperty("element_type", {ComboText:"수당|공제", ComboCode:"A|D"} );

    		// 항목Link\n유형 elementLinkType
    		elementLinkTypeList   = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+<%=curSysYear%>,"C00003"), "");
            mySheet.SetColProperty("element_link_type", {ComboText:elementLinkTypeList[0], ComboCode:elementLinkTypeList[1]} );
        }

		mySheet.SetCountPosition(4);

		$("#searchElemNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});

	    $(window).smartresize(sheetResize); sheetInit();

	    doAction("Search");
	    $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			mySheet.DoSearch( "<%=jspPath%>/calcExpressionMgr/payElementPopupRst.jsp?cmd=selectPayElementList", $("#mySheetForm").serialize() ); 
			break;
		}
    }

	// 	조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
			
			$("#searchElemNm").focus();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		var rv = new Array(5);
		
		rv["element_cd"] 			= mySheet.GetCellValue(Row, "element_cd");
		rv["element_nm"]			= mySheet.GetCellValue(Row, "element_nm");
        rv["sdate"]     			= mySheet.GetCellValue(Row, "sdate");
        rv["element_link_type"]   	= mySheet.GetCellText(Row, "element_link_type");
        rv["report_nm"]   			= mySheet.GetCellText(Row, "report_nm");
		if(p.popReturnValue) p.popReturnValue(rv);
		p.window.close();
	}
</script>

</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><span id="subTitle1Text">수당,공제 항목</span></li>
			</ul>
		</div>
        <div class="popup_main">
		<form id="mySheetForm" name="mySheetForm">
			<input type="hidden" id="callPage" name="callPage" value="" />
			<input type="hidden" id="searchElementLinkType1" name="searchElementLinkType1" value="" />
			<input type="hidden" id="searchElementLinkType2" name="searchElementLinkType2" value="" />
			<input type="hidden" id="elementType" name="elementType" value="" />
			<input type="hidden" id="isSep" name="isSep" value="" />
				<div class="sheet_search outer">
					<div>
					<table>
					<tr>
                        <td> <span>항목명</span> <input id="searchElemNm" name ="searchElemNm" type="text" class="text" style="ime-mode:active;" /> </td>
						<td> <span>사용여부</span>
						     <select  name ="searchYn" />
						     	<option value="" >전체</option>
						     	<option value="Y" selected >사용</option>
						     	<option value="N" >미사용</option>
							 </select>
						</td>
                        <td>
                            <a href="javascript:doAction('Search')" id="btnSearch" class="button">조회</a>
                        </td>						
					</tr>
					</table>
					</div>
				</div>
		</form>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><span id="subTitle2Text">수당,공제 항목</span></li>
					</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("mySheet", "100%", "100%"); </script>
				</td>
			</tr>
		</table>
		<div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
	                </li>
	            </ul>
		</div>
       </div>
	</div>
</body>
</html>