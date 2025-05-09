<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112145' mdef='결재선 경로 변경'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var applList 	= null;
var referOriList= null;
var referNewList= null;
var applCdList 	= null;
var parentSabun = null;
var referOriStr	= "";
var referNewStr	= "";
//var da = dialogArguments;
var da			= null;
var agreeSeq 	= null;
var p = eval("${popUpStatus}");
	$(function() {
		//var da = dialogArguments;
		da = p.popDialogArgumentAll();
		if(da) da = p.opener;

		var rt = da.getApplHtmlToPaser();
		applList 	= rt[1];

		referOriList= rt[2];
		referOriStr = rt[5];
		referNewList= rt[10];
		referNewStr = rt[9];

		//parentSabun = rt[7];//신청입력자사번
		parentSabun = rt[11];//신청자사번

		agreeSeq	= rt[8];
	    var applCdList 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10052"), "",-1);

	    var initdata = {};
	    //###########################조직도
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0, ChildPage:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:0,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
	       	{Header:"<sht:txt mid='orgChartNmV1' mdef='조직도명'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"orgChartNm",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='priorOrgCdV1' mdef='상위조직코드'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"priorOrgCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='orgNmV6' mdef='조직도'/>",		Type:"Text",	Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,    TreeCol:1 },
			{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable(false);sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		//###########################결재자
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='check' mdef='선택'/>",		Type:"CheckBox", 	Hidden:0,  Width:30,	Align:"Center",  ColMerge:0,   SaveName:"chkbox", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",      	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"sabun",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",      	Hidden:0,  Width:40,  	Align:"Center",  ColMerge:0,   SaveName:"name",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='departmentV1' mdef='부서'/>",		Type:"Text",     	Hidden:0,  Width:120,   Align:"Center",  ColMerge:0,   SaveName:"orgNm",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgCdV8' mdef='부서코드'/>",	Type:"Text",  		Hidden:1,  Width:120,   Align:"Center",  ColMerge:0,   SaveName:"orgCd",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",      	Hidden:0,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",      	Hidden:0,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikchakCdV2' mdef='직책코드'/>",	Type:"Text", 		Hidden:1,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"jikchakCd",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikweeCdV2' mdef='직위코드'/>",	Type:"Text",  		Hidden:1,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			]; IBS_InitSheet(sheet3, initdata); sheet3.SetEditable(true);sheet3.SetCountPosition(4);sheet3.SetVisible(true);
		//###########################결재선내역
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:1,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:0,  Width:"${sDelWdt}", 	Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",	Type:"Text",		Hidden:0,  Width:20,  			Align:"Center",  ColMerge:0,   SaveName:"agreeSeq",      KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", 	Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
	       	{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",	Hidden:0,  Width:40,   	Align:"Center",  ColMerge:0,   SaveName:"name",       	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",  	Hidden:0,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"agreeSabun",  	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",	Hidden:0,  Width:50, 	Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikchakCdV2' mdef='직책코드'/>",	Type:"Text",	Hidden:1,  Width:50, 	Align:"Center",  ColMerge:0,   SaveName:"jikchakCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikweeCdV2' mdef='직위코드'/>",	Type:"Text",	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgNmV9' mdef='부서명'/>",	Type:"Text",	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"orgNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgCdV8' mdef='부서코드'/>",	Type:"Text",	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"orgCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applTypeCd' mdef='결재구분'/>",	Type:"Combo",	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"applTypeCd",	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='applTypeCdNm' mdef='결재구분명'/>",Type:"Text",	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"applTypeCdNm",	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreeYmdA' mdef='결재일'/>",	Type:"Text",	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"date",	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='hmsV5' mdef='결재시'/>",	Type:"Text",	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"hms",	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		]; IBS_InitSheet(sheet4, initdata); sheet4.SetEditable(true);sheet4.SetVisible(true);
		sheet4.SetColProperty("applTypeCd", 		{ComboText:applCdList[0], 	ComboCode:applCdList[1]} );
		//sheet4.ColumnSort("agreeSeq");
		//###########################수신참조내역
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:1,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:0,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
	       	{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",	Type:"Text",     	Hidden:0,  Width:40,   	Align:"Center",  ColMerge:0,   SaveName:"name",		KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",	Type:"Text",      	Hidden:0,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"ccSabun", 	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",	Type:"Text",      	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",	Type:"Text",      	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikchakCdV2' mdef='직책코드'/>",	Type:"Text", 	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikchakCd",KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikweeCdV2' mdef='직위코드'/>",	Type:"Text",   	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgNmV9' mdef='부서명'/>",	Type:"Text",   	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"orgNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgCdV8' mdef='부서코드'/>",	Type:"Text",    Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"orgCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='addYn' mdef='추가여부'/>",	Type:"Text",    Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"addYn",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },

		]; IBS_InitSheet(sheet5, initdata); sheet5.SetEditable(true);sheet5.SetVisible(true);

		$(window).smartresize(sheetResize); sheetInit();

		$("input[name=radio]").change(function() {
	    	var radioValue = $(this).val();
	    	if( radioValue == "Y" ) {
	    		$("#orgMain").addClass("hide");
	    		$("#listMain").removeClass("w25p");
	    		$("#listMain").addClass("w50p");
	    		$("#name").attr("disabled",false);
	    		$("#orgNm").attr("disabled",false);
	    		$("#btnOrg").attr("disabled",false);
	    	}
	    	else {
	    		$("#orgMain").removeClass("hide");
	    		$("#listMain").removeClass("w50p");
	    		$("#listMain").addClass("w25p");
	    		$("#name").val("").attr("disabled",true);
	    		$("#orgNm").val("").attr("disabled",true);
	    		$("#btnOrg").attr("disabled",true);
	    	}
	    	sheetResize();
	    });

		$("#name, #orgNm").bind("keyup",function(event){
			if( event.keyCode == 13){orgList(); $(this).focus(); }
		});
		$(".close").click(function() { p.self.close(); });

// 		$("#sabun").val("${ssnSabun}");
// 		$("#sabun").val("P10062");
		$("#sabun").val(parentSabun);
		doAction2("Search");
		doAction3("Search");
		doAction4("Search");
		doAction5("Search");
		$("#sabun").val("");
	});

    function doAction2(sAction) {
		switch (sAction) { case "Search":  sheet2.DoSearch( "${ctx}/AppPathReg.do?cmd=getAppPathOrgList", $("#sheetForm").serialize()); break; }
    }
	function doAction3(sAction) {
		switch (sAction) { case "Search":  sheet3.DoSearch( "${ctx}/AppPathReg.do?cmd=getAppPathRegOrgUserList", $("#sheetForm").serialize()); break; }
	}
    function doAction4(sAction) {
		switch (sAction) {
		case "Search":
// 			sheet4.DoSearch( "${ctx}/GetDataList.do?cmd=getAppPathRegApplList", $("#sheetForm").serialize());
				var Row 	= "";
				var RowData = null;
				for(var i=0; i<applList.length; i++){
					Row 	= sheet4.DataInsert(sheet4.LastRow()+1);
					RowData = applList[i].split(",");
					sheet4.SetCellValue(Row,"agreeSeq", 	RowData[0]);
					sheet4.SetCellValue(Row,"name", 		RowData[5]);
					sheet4.SetCellValue(Row,"agreeSabun",	RowData[6]);
					sheet4.SetCellValue(Row,"jikchakNm",	RowData[10]);
					sheet4.SetCellValue(Row,"jikchakCd",	RowData[9]);
					sheet4.SetCellValue(Row,"jikweeNm",		RowData[8]);
					sheet4.SetCellValue(Row,"jikweeCd",		RowData[7]);
					sheet4.SetCellValue(Row,"applTypeCd",	RowData[2]);
					sheet4.SetCellValue(Row,"orgNm",		RowData[3]);
					sheet4.SetCellValue(Row,"orgCd",		RowData[4]);
					sheet4.SetCellValue(Row,"date",			RowData[11]);
					sheet4.SetCellValue(Row,"hms",			RowData[12]);

					if ( RowData[2] == "30" ){
						sheet4.SetRowEditable(Row, 0);
					}

/* 					if( Number(agreeSeq) >= Number(RowData[0]) ){
						if( RowData[2] == "10") {
							sheet4.InitCellProperty(Row, "applTypeCd", {Type: "Text", Align: "Center", Edit:0});
							sheet4.SetCellValue(Row,"applTypeCd","결재");
							sheet4.SetCellValue(Row,"applTypeCdNm","10");
							sheet4.SetRowEditable(Row, 0);
						}else if( RowData[2] == "20") {
							sheet4.InitCellProperty(Row, "applTypeCd", {Type: "Text", Align: "Center", Edit:0});
							sheet4.SetCellValue(Row,"applTypeCd","합의");
							sheet4.SetCellValue(Row,"applTypeCdNm","20");
							sheet4.SetRowEditable(Row, 0);
						}else if( RowData[2] == "30") {
							sheet4.InitCellProperty(Row, "applTypeCd", {Type: "Text", Align: "Center", Edit:0});
							sheet4.SetCellValue(Row,"applTypeCd","기안");
							sheet4.SetCellValue(Row,"applTypeCdNm","30");
							sheet4.SetRowEditable(Row, 0);
							alert(1);
						}else if( RowData[2] == "40") {
							sheet4.InitCellProperty(Row, "applTypeCd", {Type: "Text", Align: "Center", Edit:0});
							sheet4.SetCellValue(Row,"applTypeCd","접수");
							sheet4.SetCellValue(Row,"applTypeCdNm","40");
							sheet4.SetRowEditable(Row, 0);
						}
					} */
				}
			break;
		case "Save":
			if(sheet4.FindStatusRow("I") != ""){
			    if(!dupChk(sheet4,"agreeSabun", true, true)){break;}
			}
			if(confirm("저장 하시겠습니까?"))delMakeNo();
			else return;
			IBS_SaveName(document.sheetForm,sheet4);
			sheet4.DoSave("${ctx}/AppPathReg.do?cmd=saveAppPathRegAppl", $("#sheetForm").serialize(), -1,0 );
			break;
		}
    }
    function doAction5(sAction) {
		switch (sAction) {
		case "Search":
			var Row 	= "";
			var RowData = null;
			if(referOriStr != ""){
				for(var i=0; i<referOriList.length; i++){
					Row 	= sheet5.DataInsert(sheet5.LastRow()+1);
					RowData = referOriList[i].split(",");
					sheet5.SetCellValue(Row,"name", 		RowData[2]);
					sheet5.SetCellValue(Row,"ccSabun",		RowData[3]);
					sheet5.SetCellValue(Row,"jikchakNm",	RowData[7]);
					sheet5.SetCellValue(Row,"jikchakCd",	RowData[6]);
					sheet5.SetCellValue(Row,"jikweeNm",		RowData[5]);
					sheet5.SetCellValue(Row,"jikweeCd",		RowData[4]);
					sheet5.SetCellValue(Row,"orgNm",		RowData[0]);
					sheet5.SetCellValue(Row,"orgCd",		RowData[1]);
					sheet5.SetCellValue(Row,"addYn",		"N");
					//sheet5.SetRowEditable(Row, 0);
				}
			}
			if(referNewStr != ""){
				for(var i=0; i<referNewList.length; i++){
					Row 	= sheet5.DataInsert(sheet5.LastRow()+1);
					RowData = referNewList[i].split(",");
					sheet5.SetCellValue(Row,"name", 		RowData[2]);
					sheet5.SetCellValue(Row,"ccSabun",		RowData[3]);
					sheet5.SetCellValue(Row,"jikchakNm",	RowData[7]);
					sheet5.SetCellValue(Row,"jikchakCd",	RowData[6]);
					sheet5.SetCellValue(Row,"jikweeNm",		RowData[5]);
					sheet5.SetCellValue(Row,"jikweeCd",		RowData[4]);
					sheet5.SetCellValue(Row,"orgNm",		RowData[0]);
					sheet5.SetCellValue(Row,"orgCd",		RowData[1]);
					sheet5.SetCellValue(Row,"addYn",		"Y");
					sheet5.SetRowBackColor(Row,"#6FD0FF");
				}
			}
			break;
		case "Save":
			if(sheet5.FindStatusRow("I") != ""){
			    if(!dupChk(sheet5,"ccSabun", true, true)){break;}
			}
			IBS_SaveName(document.sheetForm,sheet5);
			sheet5.DoSave("${ctx}/AppPathReg.do?cmd=saveAppPathRegRefer", $("#sheetForm").serialize() );
			break;
		}
    }

	function sheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg);
		} catch (ex) { alert("OnSaveEnd Event Error : " + ex); }
	}
	function sheet5_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg);
		} catch (ex) { alert("OnSaveEnd Event Error : " + ex); }
	}

	function sheet2_OnClick(Row, Col, Value) {
		try{
			if(Row > 0) {
				$("#orgCd").val(sheet2.GetCellValue(Row,"orgCd"));
				$("#name").val("");
				$("#orgNm").val("");
				doAction3("Search");
			}
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	function sheet4_OnClick(Row, Col, Value) {
		if(Col == sheet4.SaveNameCol("sDelete")) {
			makeNo();
		}
	}
	function toggleSheet() {
		if( $("#toggleBtn").text() == "접기" ) hideSheet();
		else showSheet();
	}
	function mvAppl(){
		var chkRow = sheet3.FindCheckedRow("chkbox");
		if(chkRow == ""){ alert("<msg:txt mid='109886' mdef='결재자를 선택 하세요!'/>");return; }
		var chkArry = chkRow.split("|");
		var chkdupTxt = null;
		var dupText  = "";
		var cnt = 1;
		for(var i=0; i<chkArry.length; i++){
			chkdupTxt = sheet4.FindText("agreeSabun",sheet3.GetCellValue(chkArry[i],"sabun"));
			if(chkdupTxt == -1){
				var Row = sheet4.DataInsert(sheet4.LastRow()+1); sheet4.SelectCell(Row, 2);
				sheet4.SetCellValue(Row,"name",sheet3.GetCellValue(chkArry[i],"name") );
				sheet4.SetCellValue(Row,"agreeSabun",	sheet3.GetCellValue(chkArry[i],"sabun") );
				sheet4.SetCellValue(Row,"orgNm",		sheet3.GetCellValue(chkArry[i],"orgNm") );
				sheet4.SetCellValue(Row,"orgCd",		sheet3.GetCellValue(chkArry[i],"orgCd") );
				sheet4.SetCellValue(Row,"jikchakNm",	sheet3.GetCellValue(chkArry[i],"jikchakNm") );
				sheet4.SetCellValue(Row,"jikweeNm",		sheet3.GetCellValue(chkArry[i],"jikweeNm") );
				sheet4.SetCellValue(Row,"jikchakCd",	sheet3.GetCellValue(chkArry[i],"jikchakCd") );
				sheet4.SetCellValue(Row,"jikweeCd",		sheet3.GetCellValue(chkArry[i],"jikweeCd") );
			}else{
				dupText+= cnt+"."+sheet3.GetCellValue(chkArry[i],"sabun")+"\n";
				cnt++;
			}
		}
// 		if(dupText != "") alert("중복된 사번 제외 복사\n"+dupText);
		if(dupText != "") alert("<msg:txt mid='alertExistsEmpIdV1' mdef='중복된 사번이 존재 합니다.'/>");
		makeNo();
		sheet3.CheckAll("chkbox", 0);
	}
	function mvRefer(){
		var chkRow = sheet3.FindCheckedRow("chkbox");
		if(chkRow == ""){ alert("<msg:txt mid='110029' mdef='참조자를 선택 하세요!'/>");return; }
		var chkArry = chkRow.split("|");

		var chkdupTxt = "";
		var dupText  = "";
		var cnt = 1;
		for(var i=0; i<chkArry.length; i++){
			chkdupTxt = sheet5.FindText("ccSabun",sheet3.GetCellValue(chkArry[i],"sabun"));
			if(chkdupTxt == -1){
				var Row = sheet5.DataInsert(sheet5.LastRow()+1); sheet5.SelectCell(Row, 2);
				sheet5.SetCellValue(Row,"name",		sheet3.GetCellValue(chkArry[i],"name") );
				sheet5.SetCellValue(Row,"ccSabun",	sheet3.GetCellValue(chkArry[i],"sabun") );
				sheet5.SetCellValue(Row,"orgCd",	sheet3.GetCellValue(chkArry[i],"orgCd") );
				sheet5.SetCellValue(Row,"orgNm",	sheet3.GetCellValue(chkArry[i],"orgNm") );
				sheet5.SetCellValue(Row,"jikchakNm",sheet3.GetCellValue(chkArry[i],"jikchakNm") );
				sheet5.SetCellValue(Row,"jikweeNm",	sheet3.GetCellValue(chkArry[i],"jikweeNm") );
				sheet5.SetCellValue(Row,"jikchakCd",sheet3.GetCellValue(chkArry[i],"jikchakCd") );
				sheet5.SetCellValue(Row,"jikweeCd",	sheet3.GetCellValue(chkArry[i],"jikweeCd") );
				sheet5.SetCellValue(Row,"addYn",	"Y");
				sheet5.SetRowBackColor(Row,"#6FD0FF");
			}else{
				dupText+= cnt+"."+sheet3.GetCellValue(chkArry[i],"sabun")+"\n";
				cnt++;
			}
		}
// 		if(dupText != "") alert("중복된 사번 제외 복사\n"+dupText);
		if(dupText != "") alert("<msg:txt mid='alertExistsEmpIdV1' mdef='중복된 사번이 존재 합니다.'/>");
		sheet3.CheckAll("chkbox", 0);
	}

	function orgList(){
		 if( $(".radio:checked").val()=="Y"){
			 $("#orgCd").val("");
			 doAction3("Search");
		 } else {
			 doAction2("Search");
		 }
	}
	function makeNo(){
		for(var i=1; i<sheet4.LastRow()+1; i++){
			sheet4.SetCellValue(i,"agreeSeq",i);
		}
	}
	function delMakeNo(){
		for(var i=1; i<sheet4.LastRow()+1; i++){
			if(sheet4.GetCellValue(i,"sDelete") == "0" ){
				sheet4.SetCellValue(i,"agreeSeq",i);
			}else{
				sheet4.SetCellValue(i,"agreeSeq","");
			}
		}
	}
	function sheet4RowSwap(f){
		var lRow = sheet4.LastRow();
		var oRow = sheet4.GetSelectRow();

		var nRow = null;

		if( f == "Up") nRow = oRow -1;
		else nRow = oRow +1;
		if( f == "Up"	&& nRow == "0") return;
		else if(	f == "Down"	&& lRow < nRow) return;
		
		var oSdelete	= sheet4.GetCellValue(oRow, "sDelete");
		var oSstatus	= sheet4.GetCellValue(oRow, "sStatus");
		var oName		= sheet4.GetCellValue(oRow, "name");
		var oAgreeSabun	= sheet4.GetCellValue(oRow, "agreeSabun");
		var oJikchakNm	= sheet4.GetCellValue(oRow, "jikchakNm");
		var oJikweeNm	= sheet4.GetCellValue(oRow, "jikweeNm");
		
		var oJikchakCd		= sheet4.GetCellValue(oRow, "jikchakCd");      //adding
		var oJikweeCd		= sheet4.GetCellValue(oRow, "jikweeCd");       //adding
		var oOrgNm			= sheet4.GetCellValue(oRow, "orgNm");          //adding
		var oOrgCd			= sheet4.GetCellValue(oRow, "orgCd");          //adding
		var oApplTypeCdNm	= sheet4.GetCellValue(oRow, "applTypeCdNm");   //adding
		var oDate			= sheet4.GetCellValue(oRow, "date");           //adding
		var oHms			= sheet4.GetCellValue(oRow, "hms");            //adding
		
		var oApplTypeCd	= sheet4.GetCellValue(oRow, "applTypeCd");
		var oAgreeSeq	= sheet4.GetCellValue(oRow, "agreeSeq");
		
		var nAgreeSeq	= sheet4.GetCellValue(nRow, "agreeSeq");

		if( oApplTypeCd == "30" || sheet4.GetCellValue(nRow, "applTypeCd") == "30") {
			return alert("<msg:txt mid='109731' mdef='기안자는 이동 할수 없습니다!'/>");
		}

		if(agreeSeq >= oAgreeSeq || agreeSeq >= nAgreeSeq){
			return alert("<msg:txt mid='alertApplSabunMoveV1' mdef='결재가 진행중 또는 완료인 결재자는 이동할수 없습니다.'/>");
		}
		sheet4.SetCellValue(oRow, "sDelete", 	sheet4.GetCellValue(nRow, "sDelete"));
		sheet4.SetCellValue(oRow, "sStatus", 	sheet4.GetCellValue(nRow, "sStatus"));
		sheet4.SetCellValue(oRow, "name", 		sheet4.GetCellValue(nRow, "name"));
		sheet4.SetCellValue(oRow, "agreeSabun", sheet4.GetCellValue(nRow, "agreeSabun"));
		sheet4.SetCellValue(oRow, "jikchakNm", 	sheet4.GetCellValue(nRow, "jikchakNm"));
		sheet4.SetCellValue(oRow, "jikweeNm", 	sheet4.GetCellValue(nRow, "jikweeNm"));
		
		sheet4.SetCellValue(oRow, "jikchakCd", 	sheet4.GetCellValue(nRow, "jikchakCd"));          //adding
		sheet4.SetCellValue(oRow, "jikweeCd", 	sheet4.GetCellValue(nRow, "jikweeCd"));           //adding
		sheet4.SetCellValue(oRow, "orgNm", 		sheet4.GetCellValue(nRow, "orgNm"));              //adding
		sheet4.SetCellValue(oRow, "orgCd", 		sheet4.GetCellValue(nRow, "orgCd"));              //adding
		sheet4.SetCellValue(oRow, "applTypeCdNm", 	sheet4.GetCellValue(nRow, "applTypeCdNm"));   //adding
		sheet4.SetCellValue(oRow, "date", 		sheet4.GetCellValue(nRow, "date"));               //adding
		sheet4.SetCellValue(oRow, "hms", 		sheet4.GetCellValue(nRow, "hms"));                //adding
		
		sheet4.SetCellValue(oRow, "applTypeCd", sheet4.GetCellValue(nRow, "applTypeCd"));

		sheet4.SetCellValue(nRow, "sDelete", 	oSdelete);
		sheet4.SetCellValue(nRow, "sStatus", 	oSstatus);
		sheet4.SetCellValue(nRow, "name", 		oName);
		sheet4.SetCellValue(nRow, "agreeSabun", oAgreeSabun);
		sheet4.SetCellValue(nRow, "jikchakNm", 	oJikchakNm);
		sheet4.SetCellValue(nRow, "jikweeNm", 	oJikweeNm);
		
		sheet4.SetCellValue(nRow, "jikchakCd", 	oJikchakCd		);                                 //adding
		sheet4.SetCellValue(nRow, "jikweeCd", 	oJikweeCd		);                                 //adding
		sheet4.SetCellValue(nRow, "orgNm", 		oOrgNm			);                                 //adding
		sheet4.SetCellValue(nRow, "orgCd", 		oOrgCd			);                                 //adding
		sheet4.SetCellValue(nRow, "applTypeCdNm", 	oApplTypeCdNm	);                             //adding
		sheet4.SetCellValue(nRow, "date", 		oDate			);                                 //adding
		sheet4.SetCellValue(nRow, "hms", 		oHms			);                                 //adding
		
		sheet4.SetCellValue(nRow, "applTypeCd", oApplTypeCd);
		makeNo();
		sheet4.SelectCell(nRow,1);
	}

	function returnChgList(){
		var agreeUserStr = "";
		var sheetApplTypeCd30 = 0;
		for(var i=1; i<sheet4.LastRow()+1;i++){
			agreeUserStr+=sheet4.GetCellValue(i,"agreeSabun")+",";
			if ( sheet4.GetCellValue( i, "applTypeCd" ) == "30" ){
				sheetApplTypeCd30++;
			}
		}
		if ( sheetApplTypeCd30 == 0 ){
			alert("기안자가 없습니다.");
			return;
		}

		if ( sheetApplTypeCd30 > 1 ){
			alert("기안자는 1명만 선택하시기 바랍니다.");
			return;
		}
		$("#agreeSabun").val(agreeUserStr.substring(0, agreeUserStr.length-1));
		var debutyUserList = null;//ajaxCall("${ctx}/ApprovalMgr.do?cmd=getApprovalMgrDeputyUserChgList",$("#sheetForm").serialize(),false).DATA;
		if(da.chApplPopupRetrunPrc(sheet4,sheet5,debutyUserList,applCdList)){
			//alert("TRUE");
		}
		p.self.close();
	}

</script>

</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='appPathReg' mdef='결재 경로 변경'/></li>
		<li class="close"></li>
	</ul>
	</div>
	<div class="popup_main">
		<div class="outer">
		</div>

		<div id="gap" class="h15 outer"></div>

		<div class="sheet_search outer">
			<form id="sheetForm" name="sheetForm">
				<input id="orgCd" 		name="orgCd" 		type="hidden" />
				<input id="sabun" 		name="sabun" 		type="hidden" />
				<input id="agreeSabun" 	name="agreeSabun"	type="hidden" />
				<div>
				<table>
				<tr>
					<th><tit:txt mid='103880' mdef='성명'/></th>
					<td>
						<input id="name" name="name" type="text" class="text" />
					</td>
					<th><tit:txt mid='104279' mdef='소속'/></th>
					<td>
						<input id="orgNm" name="orgNm" type="text" class="text" />
					</td>
					<td>
						<input id="radio" name="radio" type="radio" class="radio" value="Y" checked/> 리스트
						<input id="radio" name="radio" type="radio" class="radio" value="N"/> 조직도
					</td>
					<td id="btnOrg"  class="">
						<a href="javascript:orgList();" class="button"><tit:txt mid='104081' mdef='조회'/></a>
					</td>
				</tr>
				</table>
				</div>
			</form>
		</div>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td id="orgMain" class="sheet_left w25p hide">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='orgSchemeMgr' mdef='조직도'/></li>
						<li class="btn">
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "25%", "100%"); </script>
			</td>
			<td id="listMain" class="sheet_left w50p">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='schAppSabun' mdef='결재자 검색'/></li>
						<li class="btn">
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet3", "25%", "100%"); </script>
			</td>
			<td class="sheet_arrow"></td>
			<td class="sheet_right w50p">
				<div class="sheet_button2">
					<div class="arrow_button">
						<a href="javascript:mvAppl();" class="pink"><tit:txt mid='114240' mdef='결재&gt;'/></a>
					</div>

					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='schAppLine' mdef='결재선 내역'/></li>
							<li class="btn">
								<a href="javascript:sheet4RowSwap('Up');" class="basic"><tit:txt mid='112476' mdef='위'/></a>
								<a href="javascript:sheet4RowSwap('Down');" class="basic"><tit:txt mid='112141' mdef='아래'/></a>
<!-- 								<a href="javascript:doAction4('Save');" class="basic"><tit:txt mid='104476' mdef='저장'/></a> -->
	<!-- 							<a href="javascript:delMakeNo();" class="basic"><tit:txt mid='113548' mdef='체크로우'/></a> -->
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet4", "50%", "50%"); </script>
				</div>

				<div class="sheet_button2">
					<div class="arrow_button">
						<a href="javascript:mvRefer();"	class="pink"><tit:txt mid='114241' mdef='참조&gt;'/></a>
					</div>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='schRefDetail' mdef='참조 내역'/></li>
							<li class="btn">
<!-- 								<a href="javascript:doAction5('Save');" class="basic"><tit:txt mid='104476' mdef='저장'/></a> -->
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet5", "50%", "50%"); </script>
				</div>

			</td>
		</tr>
		</table>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:returnChgList();" class="pink large"><tit:txt mid='113749' mdef='적용'/></a>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
