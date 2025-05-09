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
		var comboList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00011"), ""); // 평가지표구분(P00011)

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

            {Header:"성명|성명"		,Type:"Text",     	Hidden:0,  Width:70,  Align:"Center",	ColMerge:0,   SaveName:"name",				KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"사번|사번"		,Type:"Text",     	Hidden:0,  Width:60,  Align:"Center",	ColMerge:0,   SaveName:"sabun",				KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"평가소속|평가소속",Type:"Text",     	Hidden:0,  Width:150,  Align:"Center",	ColMerge:0,   SaveName:"appOrgNm",			KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"직급|직급"		,Type:"Text",     	Hidden:0,  Width:80,  Align:"Center",	ColMerge:0,   SaveName:"jikgubNm",			KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:0,   EditLen:100 },

            {Header:"구분|구분"		,Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appIndexGubunCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
   			{Header:"목표명|목표명"	,Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mboTarget",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000},
   			{Header:"KPI|지표명"		,Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"kpiNm",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000},
   			{Header:"KPI|산출근거"	,Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"formula",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000},
   			{Header:"기준치|기준치"	,Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"baselineData",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:300},
   			{Header:"평가등급기준|S"	,Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sGradeBase",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:300},
   			{Header:"평가등급기준|A"	,Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"aGradeBase",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:300},
   			{Header:"평가등급기준|B"	,Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"bGradeBase",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:300},
   			{Header:"평가등급기준|C"	,Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"cGradeBase",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:300},
   			{Header:"평가등급기준|D"	,Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"dGradeBase",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:300},
   			{Header:"가중치|가중치"	,Type:"Int",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"weight",	KeyField:1,	Format:"",	PointCount:1,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
            {Header:"평가ID"			,Type:"Text",	Hidden:1,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"appraisalCd",		KeyField:1,   CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"평가소속"		,Type:"Text",	Hidden:1,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"appOrgCd",			KeyField:1,   CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"seq"			,Type:"Text",	Hidden:1,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"seq",				KeyField:1,   CalcLogic:"",   Format:"Number",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.SetUnicodeByte(3);
		//sheet1.SetEditEnterBehavior("newline");

		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList&searchAppTypeCd=A,B,C",false).codeList, "");// 평가명
		$("#searchAppraisalCd").html(appraisalCdList[2]); //평가명

		sheet2.SetColProperty("appIndexGubunCd", {ComboText:comboList1[0], ComboCode:comboList1[1]} );

		$("#searchAppraisalCd").bind("change",function(event){
			doAction2("Search");
		});

        $("#searchAppStepCd").bind("change",function(event){
			doAction2("Search");
		});

        $("#searchNameSabun").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction2("Search"); $(this).focus();
			}
		});

		$(window).smartresize(sheetResize); sheetInit();

		doAction2("Search");
	});

	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/AppMboItemCreateMgr.do?cmd=getAppMboItemCreateMgrList1", $("#sheetForm").serialize(),1 ); break;
		case "Save":
							IBS_SaveName(document.sheetForm,sheet2);
							sheet2.DoSave( "${ctx}/AppMboItemCreateMgr.do?cmd=saveAppMboItemCreateMgr1", $("#sheetForm").serialize()); break;
		case "Insert":		var Row = sheet2.DataInsert(0);
							sheet2.SelectCell(Row, "name");
					        sheet2.SetCellValue(Row, "appraisalCd",$("#searchAppraisalCd").val());
							break;
		case "Copy":		sheet2.DataCopy(); break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":	sheet2.Down2Excel({DownCols:makeHiddenSkipCol(sheet2),SheetDesign:1,Merge:1}); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);

			doAction2("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet2_OnPopupClick(Row, Col){
		try{

			var colName = sheet2.ColSaveName(Col);
			var args    = new Array();
			var rv = null;

			if(colName == "competencyNm") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "papCptcPopup";

				openPopup("/PapCptcPopup.do?cmd=viewPapCptcPopup", args, "1000","700");
			} else if(colName == "name"){
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "employeePopup";

				openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	//사원 팝업
	function employeePopup(){
	    try{
	    	if(!isPopup()) {return;}

			var args    = new Array();

			gPRow = Row;
			pGubun = "searchEmployeePopup";

			openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
	    }catch(ex){alert("Open Popup Event Error : " + ex);}
	}

	function makeDic(){
		if(confirm("해당 평가대상자들의 업적평가표를 생성합니다\n 생성 시 목표합의서내용 항목이 생성됩니다. \n계속하시겠습니까?")){

	        var data = ajaxCall("/ExecPrc.do?cmd=prcAppMboItemCreateMgr",$("#sheetForm").serialize(),false);
			if(data.Result.Code == null) {
	    		alert("처리되었습니다.");
	    		doAction2("Search");
	    	} else {
		    	alert(data.Result.Message);
	    	}
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "papCptcPopup"){
			sheet2.SetCellValue(gPRow, "competencyCd",   rv["competencyCd"] );
			sheet2.SetCellValue(gPRow, "competencyNm",   rv["competencyNm"] );
			sheet2.SetCellValue(gPRow, "comGubunCd",   rv["mainAppType"] );
			sheet2.SetCellValue(gPRow, "memo",   rv["memo"] );
        } else if(pGubun == "employeePopup") {
            sheet2.SetCellValue(gPRow, "name",   rv["name"] );
            sheet2.SetCellValue(gPRow, "sabun",  rv["sabun"] );
            sheet2.SetCellValue(gPRow, "orgNm",  rv["orgNm"] );
            sheet2.SetCellValue(gPRow, "jikgubNm",  rv["jikgubNm"] );
            sheet2.SetCellValue(gPRow, "jikchakNm",  rv["jikchakNm"] );
            sheet2.SetCellValue(gPRow, "workTypeNm",  rv["workTypeNm"] );
            sheet2.SetCellValue(gPRow, "jobNm",  rv["jobNm"] );
        } else if(pGubun == "searchEmployeePopup") {
			$("#searchName").val(rv["name"]);
			$("#searchSabun").val(rv["sabun"]);
			doAction2("Search");
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
							<select name="searchAppraisalCd" id="searchAppraisalCd" onChange="javascript:doAction2('Search');">
							</select>
						</td>
						<td>
							<span>평가단계</span>
							<select name="searchAppStepCd" id="searchAppStepCd" onChange="javascript:doAction2('Search');">
							<option value="1">목표</option>
							<option value="3">중간점검</option>
							</select>
						</td>
						<td>
							<span>성명/사번</span>
							<input id="searchNameSabun" name ="searchNameSabun" type="text" class="text" />
						</td>
						<td> <a href="javascript:doAction2('Search')" id="btnSearch" class="button">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">업적평가표생성관리</li>
			<li class="btn">
				<a href="javascript:makeDic()" class="button authA">업적평가표생성</a>
				<a href="javascript:doAction2('Save')" 	class="basic authA">저장</a>
				<a href="javascript:doAction2('Down2Excel')" 	class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
</div>
</body>
</html>