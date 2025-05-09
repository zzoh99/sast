<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var onLoad = false;
var orgCdUsrList;
	$(function() {
		orgCdUsrList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=N","W82020"), "");
	    var applCdList 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10052"), "",-1);
	    var orgCdList 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W82020"), "",-1);
		
	    var initdata = {};
	    //###########################결재선
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}", 	Hidden:0,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}", 	Hidden:0,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
	    	{Header:"<sht:txt mid='pathNm' mdef='경로명'/>"	,		Type:"Text",	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"pathNm",  		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='editable' mdef='수정가능여부'/>",	Type:"CheckBox",Hidden:1,  Width:40,   	Align:"Center",  ColMerge:0,   SaveName:"modifyYn",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='defaultYn' mdef='기본여부'/>",	Type:"CheckBox",Hidden:1,  Width:40,  	Align:"Center",  ColMerge:0,   SaveName:"defaultYn",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"결재선<sht:txt mid='keyLevel' mdef='레벨'/>",		Type:"Combo",	Hidden:0,  Width:0,		Align:"Center",  ColMerge:0,   SaveName:"orgLevelCd",	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='pathSeq' mdef='경로순서'/>",		Type:"Text",	Hidden:1,  Width:100,  	Align:"Center",  ColMerge:0,   SaveName:"pathSeq",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(true);sheet1.SetCountPosition(4);sheet1.SetVisible(true);
		sheet1.SetColProperty("orgLevelCd", 		{ComboText:"|"+orgCdList[0], 	ComboCode:"|"+orgCdList[1]} );
		//###########################조직도
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0, ChildPage:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",  	Hidden:0,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
	       	{Header:"<sht:txt mid='orgChartNmV1' mdef='조직도명'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"orgChartNm",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",				Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='priorOrgCdV1' mdef='상위조직코드'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"priorOrgCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='orgNmV6' mdef='조직도'/>",			Type:"Text",	Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,    TreeCol:1 },
			{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable(false);sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.SetFocusAfterProcess(false);
		//###########################결재자
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='check' mdef='선택'/>",	Type:"CheckBox", 	Hidden:0,  Width:30,  Align:"Center",  ColMerge:0,   SaveName:"chkbox", 	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",	Type:"Text",      	Hidden:1,  Width:50,  Align:"Center",  ColMerge:0,   SaveName:"sabun",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",	Type:"Text",      	Hidden:0,  Width:40,  Align:"Center",  ColMerge:0,   SaveName:"name",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",      	Hidden:Number("${aliasHdn}"),  Width:40,  Align:"Center",  ColMerge:0,   SaveName:"empAlias",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='departmentV1' mdef='부서'/>",		Type:"Text",     	Hidden:0,  Width:120,   Align:"Center",  ColMerge:0,   SaveName:"orgNm",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",	Type:"Text",      	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",	Type:"Text",      	Hidden:Number("${jgHdn}"),  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",      	Hidden:Number("${jwHdn}"),  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		]; IBS_InitSheet(sheet3, initdata); sheet3.SetEditable(true);sheet3.SetCountPosition(4);sheet3.SetVisible(true);
		sheet3.SetFocusAfterProcess(false);
		//###########################결재선내역
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",  	Hidden:1,  Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}", 	Hidden:0,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",		Type:"Text",		Hidden:0,  Width:20,  Align:"Center",  ColMerge:0,   SaveName:"agreeSeq",      KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",	Type:"Text",  		Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"agreeSabun",  	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	       	{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",	Type:"Text",		Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"name",       	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	       	{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",		Hidden:Number("${aliasHdn}"),  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"empAlias",       	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",	Type:"Text",		Hidden:0,  Width:50,  Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",      KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",	Type:"Text",		Hidden:Number("${jgHdn}"),  Width:50,  Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",      KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",		Hidden:Number("${jwHdn}"),  Width:50,  Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",      KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applTypeCd' mdef='결재구분'/>",	Type:"Combo",		Hidden:0,  Width:50,  Align:"Center",  ColMerge:0,   SaveName:"applTypeCd",    KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='pathSeq' mdef='경로순서'/>",	Type:"Text",		Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"pathSeq",  		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet4, initdata); sheet4.SetEditable(true);sheet4.SetVisible(true);
		sheet4.SetColProperty("applTypeCd", 		{ComboText:applCdList[0], 	ComboCode:applCdList[1]} );
		sheet4.ColumnSort("agreeSeq");
		sheet4.SetFocusAfterProcess(false);
		//###########################수신참조내역
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",  	Hidden:1,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}", 	Hidden:0,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",	Type:"Text",      	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"ccSabun", 	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	       	{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",	Type:"Text",     	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"name",		KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	       	{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",     	Hidden:Number("${aliasHdn}"),  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"empAlias",		KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",	Type:"Text",      	Hidden:1,  Width:50,  Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",	Type:"Text",      	Hidden:Number("${jgHdn}"),  Width:50,  Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",      	Hidden:Number("${jwHdn}"),  Width:50,  Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",			Type:"Text",      	Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"memo",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='pathSeq' mdef='경로순서'/>",	Type:"Text",	Hidden:1,  Width:0,  Align:"Center",  ColMerge:0,   SaveName:"pathSeq",  	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet5, initdata); sheet5.SetEditable(true);sheet5.SetVisible(true);
		sheet5.SetFocusAfterProcess(false);
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
			if( event.keyCode == 13){ orgList(); $(this).focus(); }
		});

		//$("#testsabun").val("10501610");
		$("#sabun").val("${ssnSabun}");
		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
		$("#sabun").val("");
	});
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":  sheet1.DoSearch( "${ctx}/AppPathReg.do?cmd=getAppPathRegList", $("#sheetForm").serialize()); break;
		case "Save":
			if(sheet1.FindStatusRow("I") != ""){
			    if(!dupChk(sheet1,"pathNm", true, true)){break;}
			    if(!dupChk(sheet1,"orgLevelCd", true, true)){break;}
			}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave("${ctx}/AppPathReg.do?cmd=saveAppPathReg", $("#sheetForm").serialize() );
			break;
        case "Insert":
        	var Row = sheet1.DataInsert(0);
        	sheet1.SelectCell(Row, 2);
        	sheet1.SetCellValue(Row,"modifyYn","Y");
        	
        	//결재선레벨 콤보 항목 바꾸기
        	var info = {ComboText:"|"+orgCdUsrList[0], ComboCode:"|"+orgCdUsrList[1]} ;
        	sheet1.CellComboItem(Row,"orgLevelCd",info);

        	sheet4.RemoveAll();
        	sheet5.RemoveAll();
        	break;
        case "Copy":
        	var Row = sheet1.DataCopy();
        	sheet1.SelectCell(Row, 2);
        	sheet1.SetCellValue(Row,"pathSeq","");
        	sheet1.SetCellValue(Row,"modifyYn","Y");
        	sheet1.SetCellValue(Row,"defaultYn","N");

        	break;
		}
    }
    function doAction2(sAction) {
		switch (sAction) { case "Search":  sheet2.DoSearch( "${ctx}/AppPathReg.do?cmd=getAppPathOrgList", $("#sheetForm").serialize()); break; }
    }
	function doAction3(sAction) {
		switch (sAction) { case "Search":  sheet3.DoSearch( "${ctx}/AppPathReg.do?cmd=getAppPathRegOrgUserList", $("#sheetForm").serialize()); break; }
	}
    function doAction4(sAction) {
		switch (sAction) {
		case "Search":
			sheet4.DoSearch( "${ctx}/AppPathReg.do?cmd=getAppPathRegApplList", $("#sheetForm").serialize());
			break;
		case "Save":
			var ps = sheet1.GetCellValue(sheet1.GetSelectRow(), "pathSeq");
			if(ps=="") { alert("<msg:txt mid='109572' mdef='결재 경로 저장후 시도 하십시오!'/>"); return;}
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
		case "Search":  sheet5.DoSearch( "${ctx}/AppPathReg.do?cmd=getAppPathRegReferList", $("#sheetForm").serialize()); break;
		case "Save":
			var ps = sheet1.GetCellValue(sheet1.GetSelectRow(), "pathSeq");
			if(ps=="") { alert("<msg:txt mid='109572' mdef='결재 경로 저장후 시도 하십시오!'/>"); return;}

			if(sheet5.FindStatusRow("I") != ""){
			    if(!dupChk(sheet5,"ccSabun", true, true)){break;}
			}
			IBS_SaveName(document.sheetForm,sheet5);
			sheet5.DoSave("${ctx}/AppPathReg.do?cmd=saveAppPathRegRefer", $("#sheetForm").serialize() );
			break;
		}
    }
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") {alert(Msg);}
			sheetResize();
			for(var row = 1 ; row <= sheet1.LastRow() ; row++){
		        if(    sheet1.GetCellValue(row, "modifyYn") != "Y"){
		        	sheet1.SetRowEditable(row,0);
// 		        	sheet1.SetCellEditable(row, "pathNm",0);
// 		        	sheet1.SetCellEditable(row, "defaultYn",0);
// 		        	sheet1.SetCellEditable(row, "sDelete",0);
		        }
			}
			var ps = sheet1.GetCellValue(1, "pathSeq");
			$("#pathSeq").val(ps);
			doAction4("Search");
			doAction5("Search");
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") {alert(Msg);}
			for(var i=1; i<sheet4.LastRow()+1; i++){
				if( sheet4.GetCellValue(i,"applTypeCd") == "30") {
					sheet4.InitCellProperty(i, "applTypeCd", {Type: "Text", Align: "Center", Edit:0});
					sheet4.SetCellValue(i,"applTypeCd","기안");
					sheet4.SetRowEditable(i, 0);
				}else if( sheet4.GetCellValue(i,"applTypeCd") == "40") {
					sheet4.InitCellProperty(i, "applTypeCd", {Type: "Text", Align: "Center", Edit:0});
					sheet4.SetCellValue(i,"applTypeCd","접수");
					sheet4.SetRowEditable(i, 0);
				}
			}
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); doAction1("Search");
		} catch (ex) { alert("OnSaveEnd Event Error : " + ex); }
	}
	function sheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); //doAction4("Search");
		} catch (ex) { alert("OnSaveEnd Event Error : " + ex); }
	}
	function sheet5_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); //doAction5("Search");
		} catch (ex) { alert("OnSaveEnd Event Error : " + ex); }
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{
			//modifyYn
			if(Col == sheet1.SaveNameCol("defaultYn") ){
				for(var r = 1 ; r < sheet1.LastRow()+1; r++){
					if( sheet1.GetCellValue(r,"modifyYn") == "Y"){
			        	sheet1.SetCellValue(r,"defaultYn",0);
					}
				}
				sheet1.SetCellValue(Row,"defaultYn",Value);
			}
			if(Row > 0) {
				if(sheet1.GetCellValue(Row,"sStatus") != "I"){
					var ps = sheet1.GetCellValue(Row, "pathSeq");
					$("#pathSeq").val(ps);
					doAction4("Search");
					doAction5("Search");
				}else{
					sheet4.RemoveAll();
		        	sheet5.RemoveAll();
				}
			}
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {

	}
	function sheet1_OnChange(Row,Col,Value){
		try{
			if(Col == sheet1.SaveNameCol("orgLevelCd")) {
				if(Value < 11) {
					alert("<msg:txt mid='109730' mdef='레벨0 ~ 레벨10 까지는 시스템에서 사용됩니다.'/>");
					sheet1.SetCellValue(Row, "orgLevelCd", "", false);
				}
			}
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
// 	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
// 		var row = sheet2.GetSelectRow();
// 		if(sheet2.GetSelectRow() > 0) {
// 			if(OldRow != NewRow) {
// 				$("#orgCd").val(sheet2.GetCellValue(row,"orgCd"));
// 				$("#name").val("");
// 				$("#orgNm").val("");
// 				doAction3("Search");
// 			}
// 			if(OldCol == NewCol){

// 			}
// 		}
// 	}

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

	function appCodeDetailPopup(Row){
		var url 	= "${ctx}/AppCodeMgr.do?cmd=viewAppCodeMgrDetailPopup";
		var args 	= new Array();
		args["sheet"] 	= sheet1;
		var rv = openPopup(url,args,740,520);
	}
	function appCodePopup(Row){
		var url 	= "${ctx}/AppCodeMgr.do?cmd=viewAppCodeMgrPopup";
		var args 	= new Array();
		args["applCd"] 	= sheet1.GetCellValue(Row,"applCd");
		var rv = openPopup(url,args,740,520);
	}
	function toggleSheet() {
		if( $("#toggleBtn").text() == "접기" ) hideSheet();
		else showSheet();
	}
	function showSheet() {
		$("#toggleBtn").text("접기");
		$("#DIV_"+sheet1.id).show();
		$("#gap").addClass("outer");
		$("#gap").show();
		sheetResize();
	}
	function hideSheet() {
		$("#toggleBtn").text("펴기");
		$("#DIV_"+sheet1.id).hide();
		$("#gap").removeClass("outer");
		$("#gap").hide();
		sheetResize();
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
				//결재순서 역순으로 조회 2022.03.15
				//var Row = sheet4.DataInsert(sheet4.LastRow()+1); sheet4.SelectCell(Row, 2);
				var Row = sheet4.DataInsert(0); sheet4.SelectCell(Row, 2);
				sheet4.SetCellValue(Row,"name",sheet3.GetCellValue(chkArry[i],"name") );
				sheet4.SetCellValue(Row,"empAlias",sheet3.GetCellValue(chkArry[i],"empAlias") );
				sheet4.SetCellValue(Row,"agreeSabun",sheet3.GetCellValue(chkArry[i],"sabun") );
				sheet4.SetCellValue(Row,"jikchakNm",sheet3.GetCellValue(chkArry[i],"jikchakNm") );
				sheet4.SetCellValue(Row,"jikgubNm",sheet3.GetCellValue(chkArry[i],"jikgubNm") );
				sheet4.SetCellValue(Row,"jikweeNm",sheet3.GetCellValue(chkArry[i],"jikweeNm") );
				sheet4.SetCellValue(Row,"pathSeq",sheet1.GetCellValue(sheet1.GetSelectRow(),"pathSeq") );
			}else{
				dupText+= cnt+"."+sheet3.GetCellValue(chkArry[i],"sabun")+"\n";
				cnt++;
			}
		}
// 		if(dupText != "") alert("중복된 사번 제외 복사\n"+dupText);
		if(dupText != "") alert("<msg:txt mid='alertExistsEmpIdV1' mdef='중복된 사번이 존재 합니다.'/>");
		makeNo();
	}
	function mvRefer(){
		var chkRow = sheet3.FindCheckedRow("chkbox");
		if(chkRow == ""){ alert("<msg:txt mid='110029' mdef='참조자를 선택 하세요!'/>");return; }
		var chkArry = chkRow.split("|");

		var chkdupTxt = "";
		var dupText  = "";
		var cnt = 1;
		for(i=0; i<chkArry.length; i++){
			chkdupTxt = sheet5.FindText("ccSabun",sheet3.GetCellValue(chkArry[i],"sabun"));
			if(chkdupTxt == -1){
				var Row = sheet5.DataInsert(sheet4.LastRow()+1); sheet4.SelectCell(Row, 2);
				sheet5.SetCellValue(Row,"name",sheet3.GetCellValue(chkArry[i],"name") );
				sheet5.SetCellValue(Row,"empAlias",sheet3.GetCellValue(chkArry[i],"empAlias") );
				sheet5.SetCellValue(Row,"ccSabun",sheet3.GetCellValue(chkArry[i],"sabun") );
				sheet5.SetCellValue(Row,"jikchakNm",sheet3.GetCellValue(chkArry[i],"jikchakNm") );
				sheet5.SetCellValue(Row,"jikgubNm",sheet3.GetCellValue(chkArry[i],"jikgubNm") );
				sheet5.SetCellValue(Row,"jikweeNm",sheet3.GetCellValue(chkArry[i],"jikweeNm") );
				sheet5.SetCellValue(Row,"pathSeq",sheet1.GetCellValue(sheet1.GetSelectRow(),"pathSeq") );
			}else{
				dupText+= cnt+"."+sheet3.GetCellValue(chkArry[i],"sabun")+"\n";
				cnt++;
			}
		}
// 		if(dupText != "") alert("중복된 사번 제외 복사\n"+dupText);
		if(dupText != "") alert("<msg:txt mid='alertExistsEmpIdV1' mdef='중복된 사번이 존재 합니다.'/>");
	}
	function orgList(){
		 if( $(".radio:checked").val()=="Y"){
			 $("#orgCd").val("");
			 doAction3("Search");
		 }
		 return;
	}
	function makeNo(){
		for(var i=1; i<sheet4.LastRow()+1; i++){
			//결재순서 역순으로 조회 2022.03.15
			//sheet4.SetCellValue(i,"agreeSeq",i);
			sheet4.SetCellValue(i,"agreeSeq",sheet4.LastRow()+1 - i);
		}
	}
	function delMakeNo(){
		var cnt = 1;
		for(var i=1; i<sheet4.LastRow()+1; i++){
			if(sheet4.GetCellValue(i,"sDelete") == "0" ){
				//결재순서 역순으로 조회 2022.03.15
				//sheet4.SetCellValue(i,"agreeSeq",cnt);
				sheet4.SetCellValue(i,"agreeSeq",sheet4.LastRow()+1 - i);
				cnt++;
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
		//alert(oRow+"_"+lRow+""+nRow);
		if( f == "Up"	&& nRow == "0") return;
		else if(	f == "Down"	&& lRow < nRow) return;

		var oSdelete	= sheet4.GetCellValue(oRow, "sDelete");
		var oSstatus	= sheet4.GetCellValue(oRow, "sStatus");
		var oName		= sheet4.GetCellValue(oRow, "name");
		var oAlias		= sheet4.GetCellValue(oRow, "empAlias");
		var oAgreeSabun	= sheet4.GetCellValue(oRow, "agreeSabun");
		var oJikchakNm	= sheet4.GetCellValue(oRow, "jikchakNm");
		var oJikgubNm	= sheet4.GetCellValue(oRow, "jikgubNm");
		var oJikweeNm	= sheet4.GetCellValue(oRow, "jikweeNm");
		var oApplTypeCd	= sheet4.GetCellValue(oRow, "applTypeCd");
		var oPathSeq	= sheet4.GetCellValue(oRow, "pathSeq");

		if(oApplTypeCd == "기안" || sheet4.GetCellValue(nRow, "applTypeCd") == "기안") {return alert("<msg:txt mid='109731' mdef='기안자는 이동 할수 없습니다!'/>");}
		if(oApplTypeCd == "접수" || sheet4.GetCellValue(nRow, "applTypeCd") == "접수") {return alert("<msg:txt mid='109573' mdef='접수자는 이동 할수 없습니다!'/>");}

		sheet4.SetCellValue(oRow, "sDelete", 	sheet4.GetCellValue(nRow, "sDelete"));
		sheet4.SetCellValue(oRow, "sStatus", 	sheet4.GetCellValue(nRow, "sStatus"));
		sheet4.SetCellValue(oRow, "name", 		sheet4.GetCellValue(nRow, "name"));
		sheet4.SetCellValue(oRow, "empAlias", 		sheet4.GetCellValue(nRow, "empAlias"));
		sheet4.SetCellValue(oRow, "agreeSabun", sheet4.GetCellValue(nRow, "agreeSabun"));
		sheet4.SetCellValue(oRow, "jikchakNm", 	sheet4.GetCellValue(nRow, "jikchakNm"));
		sheet4.SetCellValue(oRow, "jikgubNm", 	sheet4.GetCellValue(nRow, "jikgubNm"));
		sheet4.SetCellValue(oRow, "jikweeNm", 	sheet4.GetCellValue(nRow, "jikweeNm"));
		sheet4.SetCellValue(oRow, "applTypeCd", sheet4.GetCellValue(nRow, "applTypeCd"));
		sheet4.SetCellValue(oRow, "pathSeq", 	sheet4.GetCellValue(nRow, "pathSeq"));

		sheet4.SetCellValue(nRow, "sDelete", 	oSdelete);
		sheet4.SetCellValue(nRow, "sStatus", 	oSstatus);
		sheet4.SetCellValue(nRow, "name", 		oName);
		sheet4.SetCellValue(nRow, "empAlias", 		oAlias);
		sheet4.SetCellValue(nRow, "agreeSabun", oAgreeSabun);
		sheet4.SetCellValue(nRow, "jikchakNm", 	oJikchakNm);
		sheet4.SetCellValue(nRow, "jikgubNm", 	oJikgubNm);
		sheet4.SetCellValue(nRow, "jikweeNm", 	oJikweeNm);
		sheet4.SetCellValue(nRow, "applTypeCd", oApplTypeCd);
		sheet4.SetCellValue(nRow, "pathSeq", 	oPathSeq);

		makeNo();

		sheet4.SelectCell(nRow,1);
	}
</script>

</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">
				결재경로
			</li>
			<li class="btn">
				<btn:a id="toggleBtn" href="javascript:toggleSheet();" css="btn outline-gray" mid='111230' mdef="접기"/>
				<btn:a href="javascript:doAction1('Copy');" css="btn outline-gray" mid='110696' mdef="복사"/>
				<btn:a href="javascript:doAction1('Insert');" css="btn outline-gray" mid='110700' mdef="입력"/>
				<btn:a href="javascript:doAction1('Save');" css="btn filled" mid='110708' mdef="저장"/>
				<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='110697' mdef="조회"/>
			</li>
		</ul>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "200px", "${ssnLocaleCd}"); </script>
	</div>

	<div id="gap" class="h15 outer"></div>

	<div class="sheet_search sheet_search_s outer">
		<form id="sheetForm" name="sheetForm">
			<input id="pathSeq" 	name="pathSeq" 		type="hidden" />
			<input id="orgCd" 		name="orgCd" 		type="hidden" />
			<input id="sabun" 		name="sabun" 		type="hidden" />
			<div>
			<table>
               	<colgroup>
               		<col width="50px">
               		<col width="150px">
               		<col width="50px">
               		<col width="150px">
               		<col width="100px">
               		<col width>
               	</colgroup>
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
					<a href="javascript:orgList();" class="btn dark"><tit:txt mid='104081' mdef='조회'/></a>
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
			<script type="text/javascript"> createIBSheet("sheet2", "25%", "100%", "${ssnLocaleCd}"); </script>
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
			<script type="text/javascript"> createIBSheet("sheet3", "25%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_arrow"></td>
		<td class="sheet_right w50p">
			<div class="sheet_button2">
				<div class="arrow_button">
					<btn:a href="javascript:mvAppl();" css="pink" mid='111114' mdef="결재&gt;"/>
				</div>

				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='schAppLine' mdef='결재선 내역'/></li>
						<li class="btn">
							<btn:a href="javascript:sheet4RowSwap('Up');" css="btn outline-gray" mid='110755' mdef="위"/>
							<btn:a href="javascript:sheet4RowSwap('Down');" css="btn outline-gray" mid='111045' mdef="아래"/>
							<btn:a href="javascript:doAction4('Save');" css="btn filled" mid='110708' mdef="저장"/>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet4", "50%", "50%", "${ssnLocaleCd}"); </script>
			</div>

			<div class="sheet_button2">
				<div class="arrow_button">
					<btn:a href="javascript:mvRefer();"	css="pink" mid='110746' mdef="참조&gt;"/>
				</div>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='schRefDetail' mdef='참조 내역'/></li>
						<li class="btn">
							<a href="javascript:doAction5('Save');" class="btn filled"><tit:txt mid='104476' mdef='저장'/></a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet5", "50%", "50%", "${ssnLocaleCd}"); </script>
			</div>

		</td>
	</tr>
	</table>
</div>
</body>
</html>
