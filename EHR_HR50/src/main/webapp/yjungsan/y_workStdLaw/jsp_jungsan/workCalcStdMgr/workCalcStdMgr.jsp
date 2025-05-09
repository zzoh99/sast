<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head><title>근태/근무산정기준관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var tc10010 = "";
tc10010 = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+<%=curSysYear%>, "TC10010"), "선택");
var tc10020 = "";
tc10020 = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+<%=curSysYear%>, "TC10020"), "선택");

$(function(){
	$("#searchSYm").datepicker2({ymonly:true});
	$("#searchEYm").datepicker2({ymonly:true});
	
	var initdata = {};	
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata.Cols = [
		{Header:"No",		Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
		{Header:"삭제",		Type:"<%=sDelTy%>", Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
		{Header:"상태",		Type:"<%=sSttTy%>", Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0}, 
		{Header:"구분", 		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"type_cd", 			KeyField:1,	Format:"", CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
		{Header:"구분명", 	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"type_nm", 			KeyField:0,	Format:"", CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
		{Header:"세부구분", 	Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"type_detail_cd", 		KeyField:1,	Format:"", CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500 },
		{Header:"세부구분명", 	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"type_detail_nm", 		KeyField:0,	Format:"", CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
		{Header:"기준값", 	Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"col_value", 		KeyField:0,	Format:"", CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"범위구분", 	Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"scope_gubun", 		KeyField:0,	Format:"", CalcLogic:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"팝업",		Type:"Image",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"scope",			Cursor:"Pointer", UpdateEdit:1,	InsertEdit:1 },
		{Header:"범위항목", 	Type:"Text",		Hidden:0,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"note", 			KeyField:0,	Format:"", CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"시작년월", 	Type:"Date",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"s_ym", 			KeyField:1,	Format:"Ym", CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
		{Header:"종료년월", 	Type:"Date",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"e_ym", 			KeyField:0,	Format:"Ym", CalcLogic:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
		{Header:"비고", 		Type:"Text",		Hidden:0,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"memo", 			KeyField:0,	Format:"", CalcLogic:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1, EditLen:100 }
	]; IBS_InitSheet(mySheet, initdata);mySheet.SetEditable("<%=editable%>");mySheet.SetVisible(true); mySheet.SetImageList(0,"<%=imagePath%>/icon/icon_popup.png");
	mySheet.SetColProperty("type_cd",    {ComboText:"|근무일기준|근로시간기준", ComboCode:"''|TC10010|TC10020"} );
	mySheet.SetColProperty("scope_gubun",    {ComboText:"전체|해당직무|범위적용", ComboCode:"A|J|O"} );
	mySheet.SetCountPosition(4); 
	
	$(window).smartresize(sheetResize); sheetInit();
	
	doAction1("Search");
});

/**
 * Sheet CRUD 유형 별 처리
 */
function doAction1(sAction){
	switch(sAction){
		case "Search" :	//조회
			mySheet.DoSearch("<%=jspPath%>/workCalcStdMgr/workCalcStdMgrRst.jsp?cmd=selectWorkCalcStdMgrList", $("#sheetForm").serialize());
			break;
		case "Insert" :	//입력(신규)
			var Row = mySheet.DataInsert(0);
			break;
		case "Save"	  : //저장
			if(!dupChk(mySheet, "type_cd|type_detail_cd|s_ym", true, true)) break;
			
			//IBS_SaveName(document.sheetForm, mySheet);
			mySheet.DoSave("<%=jspPath%>/workCalcStdMgr/workCalcStdMgrRst.jsp?cmd=saveWorkCalcStdMgr", $("#sheetForm").serialize());
			break;
	}
}

//조회 후 에러 메시지
function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { 
		if (Msg != "") {
			alert(Msg);
		}

		for(var i = mySheet.HeaderRows(); i < mySheet.RowCount() + mySheet.HeaderRows(); i++){ 
			var typeCd = mySheet.GetCellValue(i, "type_cd");

			if(typeCd == "TC10010"){
				//mySheet.CellComboItem(Row,"type_detail_cd", {Type:"Combo", ComboCode:"|"+tc10010[1], ComboText:"|"+tc10010[0]});
				mySheet.CellComboItem(i,"type_detail_cd", {"ComboCode":tc10010[1],"ComboText":tc10010[0]});
			} else if(typeCd == "TC10020") {
				mySheet.CellComboItem(i,"type_detail_cd", {"ComboCode":tc10020[1],"ComboText":tc10020[0]});
			} else {
				mySheet.CellComboItem(i,"type_detail_cd", {"ComboCode":"","ComboText":""});
			}
			
			//회사기준이라면
			if(typeCd == "TC10020" && mySheet.GetCellValue(i, "type_detail_cd") == "02") {
				mySheet.SetCellEditable(i, "col_value", true);	
			}

        }
		sheetResize();
	} catch (ex) { 
		alert("OnSearchEnd Event Error : " + ex);
	}
}


//저장 후 메시지
function mySheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
    try {
        alertMessage(Code, Msg, StCode, StMsg);
        if(Code == 1) {
            doAction1("Search");
        }
    } catch(ex) {
        alert("OnSaveEnd Event Error " + ex);
    }
}

//시트 CELL 클릭
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH){
	try {
		if(mySheet.ColSaveName(Col) == "scope")	{
			if(!isPopup()) return;

			if(mySheet.GetCellValue(Row, "sStatus") == "I") {
				alert("입력 상태에서는 범위구분을 설정할 수 없습니다. \n저장 한 후 설정하시기 바랍니다.");
				return;
			}

			if(mySheet.GetCellValue(Row, "scope_gubun") != "O") {
				alert("범위구분이 범위적용을 선택 후 설정 가능합니다.");
				return;
			}

			var args = new Array();
			var s_ym = mySheet.GetCellValue(Row,"s_ym");

	        args["searchUseGubun"] = "T01";
	        args["searchItemValue1"] = mySheet.GetCellValue(Row,"type_cd");
	        args["searchItemValue2"] = mySheet.GetCellValue(Row,"type_detail_cd");
	        args["searchItemValue3"] = s_ym;
	        args["searchItemNm"] = mySheet.GetCellValue(Row,"type_nm") + " - " + mySheet.GetCellValue(Row,"type_detail_nm") + "("+ s_ym.substring(0, 4) + "-" + s_ym.substring(4, 6) +") "; 
	        //args["searchItemNm"] = sheet1.GetCellValue(Row,"appGroupNm");

			openPopup("<%=jspPath%>/workCalcStdMgr/workCalcStdMgrRngPop.jsp?authPg=<%=authPg%>", args,"740","700");
		}
	} catch(ex) {
		alert("OnClick Event Error " + ex);
	}
}


function mySheet_OnChange(Row, Col, Value, OldValue) {
	try {
		if(mySheet.ColSaveName(Col) == "type_cd" && mySheet.GetCellValue(Row, "type_cd") != "")	{
			var typeCd = mySheet.GetCellValue(Row, "type_cd");
			if(typeCd == "TC10010"){
				mySheet.CellComboItem(Row,"type_detail_cd", {"ComboCode":tc10010[1],"ComboText":tc10010[0]});
			} else if(typeCd == "TC10020") {
				mySheet.CellComboItem(Row,"type_detail_cd", {"ComboCode":tc10020[1],"ComboText":tc10020[0]});
			} else {
				mySheet.CellComboItem(Row,"type_detail_cd", {"ComboCode":"","ComboText":""});
				
			}
			sheetResize();
		}
		if (mySheet.ColSaveName(Col) == "type_cd" || mySheet.ColSaveName(Col) == "type_detail_cd") {
			if (mySheet.GetCellValue(Row, "type_cd") == "TC10020" && mySheet.GetCellValue(Row, "type_detail_cd") == "02") {
				mySheet.SetCellEditable(Row, "col_value", true);
			} else {
				mySheet.SetCellValue(Row, "col_value", "");
				mySheet.SetCellEditable(Row, "col_value", false);
			}
		}
	} catch(ex) {
		alert("OnChange Event Error " + ex);
	}
}

</script>

</head>


<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					
					<tr>
						<td>
							<span>대상년월</span>
							<input id="searchSYm" name ="searchSYm" type="text" class="text" value="" style="text-align:center;"/>
							&nbsp; ~ &nbsp;
							<input id="searchEYm" name ="searchEYm" type="text" class="text" value="" style="text-align:center;"/>
						</td>
						<td>
							<span>범위구분</span>
							<select id="searchScopeGubun" name ="searchScopeGubun" class="box">
								<option value="">선택</option>
								<option value="A">전체</option>
								<option value="J">해당직무</option>
								<option value="O">범위적용</option>
							</select>
						</td>
						
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
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
							<li id="txt" class="txt">근태/근무산정기준관리</li>
							<li class="btn">
								<a href="javascript:doAction1('Insert')" class="basic authA ">입력</a>
								<a href="javascript:doAction1('Save')"   class="basic authA ">저장</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("mySheet", "100%", "100%"); </script>
			</td>
		</tr>
	</table>

</div>
</body>
</html>