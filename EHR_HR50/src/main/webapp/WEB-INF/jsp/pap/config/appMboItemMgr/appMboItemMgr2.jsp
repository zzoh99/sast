<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
    		{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"삭제|삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"세부\n내역|세부\n내역",Type:"Image", Hidden:0,  	Width:40,  	Align:"Center",	ColMerge:0,   SaveName:"detail",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
   			{Header:"순서|순서",			Type:"Int",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orderSeq",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
   			{Header:"구분|구분",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appIndexGubunCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
   			{Header:"목표명|목표명",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mboTarget",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000},
   			{Header:"KPI|지표명",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"kpiNm",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000},
   			{Header:"KPI|산출근거",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"formula",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000},
   			{Header:"기준치|기준치",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"baselineData",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:300},
   			{Header:"평가등급기준|S등급",	Type:"Text", 	Hidden:0, 	Width:100, 	Align:"Center", ColMerge:0, SaveName:"sGradeBase", KeyField:1, UpdateEdit:1, InsertEdit:1, MultiLineText:1, EditLen:300},
			{Header:"평가등급기준|A등급",	Type:"Text", 	Hidden:0, 	Width:100, 	Align:"Center", ColMerge:0, SaveName:"aGradeBase", KeyField:1, UpdateEdit:1, InsertEdit:1, MultiLineText:1, EditLen:300},
			{Header:"평가등급기준|B등급",	Type:"Text", 	Hidden:0, 	Width:100, 	Align:"Center", ColMerge:0, SaveName:"bGradeBase", KeyField:1, UpdateEdit:1, InsertEdit:1, MultiLineText:1, EditLen:300},
			{Header:"평가등급기준|C등급",	Type:"Text", 	Hidden:0, 	Width:100, 	Align:"Center", ColMerge:0, SaveName:"cGradeBase", KeyField:1, UpdateEdit:1, InsertEdit:1, MultiLineText:1, EditLen:300},
			{Header:"평가등급기준|D등급",	Type:"Text", 	Hidden:0, 	Width:100, 	Align:"Center", ColMerge:0, SaveName:"dGradeBase", KeyField:1, UpdateEdit:1, InsertEdit:1, MultiLineText:1, EditLen:300},
   			{Header:"가중치|가중치",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"weight",	KeyField:1,	Format:"",	PointCount:1,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
   			{Header:"비고|비고",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"note",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500},
   			{Header:"항목코드|항목코드",	Type:"Int",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seq",	KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
            {Header:"평가ID|평가ID",		Type:"Text",    Hidden:1,  	Width:100,  Align:"Center",	ColMerge:0, SaveName:"appraisalCd",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);
		sheet1.SetUnicodeByte(3);
		sheet1.SetEditEnterBehavior("newline");

		var comboList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00011"), ""); // 평가지표구분(P00011)
		sheet1.SetColProperty("appIndexGubunCd", {ComboText:comboList1[0], ComboCode:comboList1[1]} );

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail",1);

		sheet1.SetEditEnterBehavior("newline");
		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList&searchAppTypeCd=A,B,C",false).codeList, ""); // 평가명
		$("#searchAppraisalCd").html(appraisalCdList[2]); //평가명


        $("#searchAppraisalCd").bind("change",function(event){
        	setAppClassCd();
    		clearSheetSize( sheet1 );sheetInit();
			doAction1("Search");
		});


		$(window).smartresize(sheetResize);

		$("#searchAppraisalCd").change();
	});


	function setAppClassCd(){
		//평가등급기준 -- 평가종류에 따라 다른 등급을 가져옴.
		var saveNameLst = ["sGradeBase", "aGradeBase", "bGradeBase", "cGradeBase", "dGradeBase"];
		var classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCdList&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, ""); // 평가등급
		var clsLst = classCdList[0].split("|");

		for( var i=0; i<clsLst.length ; i++){
			sheet1.SetColHidden(saveNameLst[i], 0 );
			sheet1.SetCellValue(1, saveNameLst[i], clsLst[i] );
		}
		var len = clsLst.length;
		if(classCdList[0] == "" ) len = 0;
		for( var i=len; i<saveNameLst.length ; i++){
			sheet1.SetColHidden(saveNameLst[i], 1 );
		}
	}
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppMboItemCreateMgr.do?cmd=getAppMboItemCreateMgrList", $("#sheetForm").serialize(),1 ); break;
		case "Save":
							IBS_SaveName(document.sheetForm,sheet1);
							sheet1.DoSave( "${ctx}/SaveData.do?cmd=saveAppMboItemCreateMgr", $("#sheetForm").serialize()); break;
		case "Insert":		var Row = sheet1.DataInsert(0);
							sheet1.SetCellValue(Row, "appraisalCd",$("#searchAppraisalCd").val());
							showDetailPopupA("A", Row);
							break;
		case "Copy":		var Row = sheet1.DataCopy();
							sheet1.SetCellValue(Row, "seq", "");
							break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1}); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			if ( Code != "-1" ) doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(sheet1.ColSaveName(Col) == "detail"){
				showDetailPopupA("A", Row);
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
	var showDetailPopupA = function (authPg,Row) {
		if(!isPopup()) {return;}

		var url = "/AppMboItemCreateMgr.do?cmd=viewAppMboItemCreateMgrPopup";
		var args	= new Array();
		args["authPg"] = authPg;
		args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
		args["orderSeq"] = sheet1.GetCellValue(Row, "orderSeq");
		args["appIndexGubunCd"] = sheet1.GetCellValue(Row, "appIndexGubunCd");
		args["mboTarget"] = sheet1.GetCellValue(Row, "mboTarget");
		args["kpiNm"] = sheet1.GetCellValue(Row, "kpiNm");
		args["formula"] = sheet1.GetCellValue(Row, "formula");
		args["baselineData"] = sheet1.GetCellValue(Row, "baselineData");
		args["sGradeBase"] = sheet1.GetCellValue(Row, "sGradeBase");
		args["aGradeBase"] = sheet1.GetCellValue(Row, "aGradeBase");
		args["bGradeBase"] = sheet1.GetCellValue(Row, "bGradeBase");
		args["cGradeBase"] = sheet1.GetCellValue(Row, "cGradeBase");
		args["dGradeBase"] = sheet1.GetCellValue(Row, "dGradeBase");
		args["weight"] = sheet1.GetCellValue(Row, "weight");
		args["note"] = sheet1.GetCellValue(Row, "note");
		args["seq"] = sheet1.GetCellValue(Row, "seq");

		gPRow = Row;
		pGubun = "appMboItemCreateMgrPopup";

		openPopup(url,args,800,670);
	};

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "appMboItemCreateMgrPopup"){
			sheet1.SetCellValue(gPRow, "orderSeq", rv["orderSeq"]);
			sheet1.SetCellValue(gPRow, "appIndexGubunCd", rv["appIndexGubunCd"]);
			sheet1.SetCellValue(gPRow, "mboTarget", rv["mboTarget"]);
			sheet1.SetCellValue(gPRow, "kpiNm", rv["kpiNm"]);
			sheet1.SetCellValue(gPRow, "formula", rv["formula"]);
			sheet1.SetCellValue(gPRow, "baselineData", rv["baselineData"]);
			sheet1.SetCellValue(gPRow, "sGradeBase", rv["sGradeBase"]);
			sheet1.SetCellValue(gPRow, "aGradeBase", rv["aGradeBase"]);
			sheet1.SetCellValue(gPRow, "bGradeBase", rv["bGradeBase"]);
			sheet1.SetCellValue(gPRow, "cGradeBase", rv["cGradeBase"]);
			sheet1.SetCellValue(gPRow, "dGradeBase", rv["dGradeBase"]);
			sheet1.SetCellValue(gPRow, "weight", rv["weight"]);
			sheet1.SetCellValue(gPRow, "note", rv["note"]);
        }
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<input type="hidden" id="searchSabun" name="searchSabun" value="">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd" onChange="javascript:doAction1('Search');">
							</select>
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
					</tr>
				</table>

			</div>
		</div>
	</form>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">업적평가항목정의</li>
			<li class="btn">
				<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
				<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
			</li>

		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>