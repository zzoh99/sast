<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<style>
/* modal의 z-index가 1001로 설정되어있음 */
.GridMain1 .GridMain2 .GMMenuMain {
    z-index: 1500 !important;
}
</style>
<script>
//조직도, 결재자, 결재선, 수신참조, 담당자 SHEET
var orgSheet, approvalSheet, approvalLineSheet, inchargeSheet, receivSheet;

var approvalChangeOption = { 
		id: 'changeApprovalLineLayer'
	  , orgCd: null
	  , pathSeq: null
	  , searchApplSabun: null
	  , appls: null
	  , deputys: null
	  , inusers: null
	  , refers: null 
	};

$(function() {
	const modal = window.top.document.LayerModalUtility.getModal('changeApprovalLineLayer');
	var parameters =  modal.parameters;
	
	approvalChangeOption = {
		id: 'changeApprovalLineLayer'
	  , orgCd: '${orgCd}'
	  , pathSeq: '${pathSeq}'
	  , searchApplSabun: '${searchApplSabun}'
	  , ...parameters.lines
	};

	//SHEET 생성
	createOrgSheet();
	createApprovalSheet();
	createApprovalLineSheet();
	createReceivSheet();
	createInchargeSheet();

	//EVENT 생성
	$('input[name=approvalLineChangeRadio]').change(function() {
		var radioValue = $(this).val();
    	if( radioValue == "Y" ) {
    		$("#orgMain").addClass("hide");
    		$("#listMain").removeClass("w30p");
    		$("#listMain").addClass("w65p");
    		$("#approvalLineChangeName").attr("disabled",false);
    		$("#approvalLineChangeOrgNm").attr("disabled",false);
    		$("#btnApprovalLineChangeOrg").attr("disabled",false);
    		approvalSheet.SetSheetWidth(658);
    	} else {
    		$("#orgMain").removeClass("hide");
    		$("#listMain").removeClass("w65p");
    		$("#listMain").addClass("w30p");
    		$("#approvalLineChangeName").attr("disabled",true);
    		$("#approvalLineChangeOrgNm").attr("disabled",true);
    		$("#approvalLineChangeName").val("");
			$("#approvalLineChangeOrgNm").val("");
    		$("#btnApprovalLineChangeOrg").attr("disabled",true);
    		approvalChangeOption.orgCd = orgSheet.GetCellValue(orgSheet.GetSelectRow(),"orgCd");
    		approvalSheet.SetSheetWidth(314);
			approvalAction("Search");
    	}
	});
	
	$('#approvalLineChangeName, #approvalLineChangeOrgNm').bind('keyup', function(e) {
		if (e.keyCode == 13) {
			approvalLineChangeSearch();
			$(this).focus(); 
		}
	});
});

function getReturnParam() {
	var appls = approvalLineSheet.GetSaveJson().data;

	appls = appls.map(a => ({
		...a
		, applTypeCdNm: approvalLineSheet.GetCellText(a.agreeSeq, 'applTypeCd')
	}));
	var inappls = inchargeSheet.GetSaveJson().data;
	inappls = inappls.map(a => ({
		...a
		, applTypeCdNm: inchargeSheet.GetCellText(a.sNo, 'applTypeCd')
	}));
	var referer = receivSheet.GetSaveJson().data;
	return { appls, inappls, referer };
}

function closeApprovalLineChangeLayer() {
	//sheet dispose
	orgSheet.DisposeSheet(1);
	approvalSheet.DisposeSheet(1); 
	approvalLineSheet.DisposeSheet(1);
	inchargeSheet.DisposeSheet(1);
	receivSheet.DisposeSheet(1);
	const modal = window.top.document.LayerModalUtility.getModal(approvalChangeOption.id);
	modal.hide();
}

function closeApprovalLineChangeLayerWithParam() {
	var param = getReturnParam();
	//sheet dispose
	orgSheet.DisposeSheet(1);
	approvalSheet.DisposeSheet(1); 
	approvalLineSheet.DisposeSheet(1);
	inchargeSheet.DisposeSheet(1);
	receivSheet.DisposeSheet(1);
	const modal = window.top.document.LayerModalUtility.getModal(approvalChangeOption.id);
	modal.fire('changeApprovalLineTrigger', param).hide();
}

function approvalLineChangeSearch() {
	var opt = $('input[name=approvalLineChangeRadio]:checked').val();
	if (opt == 'Y') {
		approvalChangeOption.orgCd = '';
		approvalAction('Search');
	} else {
		orgAction('Search');
	}
}

function createOrgSheet() {
	createIBSheet3($('#orgSheetArea').get(0), "orgSheet", "100%", "100%", '${ssnLocaleCd}');
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0, ChildPage:5, AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:0,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
       	{Header:"<sht:txt mid='orgChartNmV1' mdef='조직도명'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"orgChartNm",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='priorOrgCdV1' mdef='상위조직코드'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"priorOrgCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='orgNmV6' mdef='조직도'/>",		Type:"Text",	Hidden:0,	Width:252,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,    TreeCol:1 },
		{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; 
	IBS_InitSheet(orgSheet, initdata);
	orgSheet.SetEditable(false);
	orgSheet.SetVisible(true);
	orgSheet.SetCountPosition(4);
	orgSheet.SetSheetHeight(440);
	orgAction('Search');
}

function orgSheet_OnSearchEnd(code, msg, st, stmsg) {
	try {
		if (msg != '') alert(msg);
		var row = 1;
		if (approvalChangeOption.orgCd != null && approvalChangeOption.orgCd != '') {
			for (var i = 1; i < orgSheet.RowCount() + 1; i++) {
				if (approvalChangeOption.orgCd == orgSheet.GetCellValue(i, 'orgCd')) {
					orgSheet.SelectCell(i, 'sNo');
					row = i;
					break;
				}
			}
		}

		approvalChangeOption.orgCd = orgSheet.GetCellValue(row, 'orgCd');
		$("#approvalLineChangeName").val("");
		$("#approvalLineChangeOrgNm").val("");
		approvalAction('Search');
	} catch (ex) {
		alert('OnSearchEnd Event Erorr : ' + ex);
	}
}

function orgSheet_OnClick(row, col, val) {
	try {
		if (row > 0) {
			approvalChangeOption.orgCd = orgSheet.GetCellValue(row, 'orgCd');
			$("#approvalLineChangeName").val("");
			$("#approvalLineChangeOrgNm").val("");
			approvalAction('Search');
		}
	} catch (ex) {
		alert('OnClick Event Erorr : ' + ex);
	}
}

function orgAction(action) {
	switch (action) {
	case 'Search':
		const p = { pathSeq: approvalChangeOption.pathSeq, sabun: approvalChangeOption.searchApplSabun };
		orgSheet.DoSearch('/AppPathReg.do?cmd=getAppPathOrgList', queryStringToJson(p));
		break;
	}
}

function createApprovalSheet() {
	createIBSheet3($('#approvalSheetArea').get(0), "approvalSheet", "100%", "100%", '${ssnLocaleCd}');
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
		{Header:"<sht:txt mid='check' mdef='선택'/>",		Type:"CheckBox", 	Hidden:0,  Width:30,	Align:"Center",  ColMerge:0,   SaveName:"chkbox", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",      	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   SaveName:"sabun",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",      	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   SaveName:"name",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",      	Hidden:Number("${aliasHdn}"),  Width:60,  	Align:"Center",  ColMerge:0,   SaveName:"empAlias", 	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='departmentV1' mdef='부서'/>",		Type:"Text",     	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"orgNm",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='orgCdV8' mdef='부서코드'/>",	Type:"Text",  		Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"orgCd",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",      	Hidden:0,  Width:50,   	Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",      	Hidden:0,  Width:50,   	Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='jikchakCdV2' mdef='직책코드'/>",	Type:"Text", 		Hidden:1,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"jikchakCd",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='jikweeCdV2' mdef='직위코드'/>",	Type:"Text",  		Hidden:1,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		];
	IBS_InitSheet(approvalSheet, initdata);
	approvalSheet.SetEditable(true);
	approvalSheet.SetCountPosition(4);
	approvalSheet.SetVisible(true);
	approvalSheet.SetSheetHeight(440);
}

function approvalAction(action) {
	switch (action) {
	case 'Search':
		var name = $("#approvalLineChangeName").val();
		var orgNm = $("#approvalLineChangeOrgNm").val();
		const p = { pathSeq: approvalChangeOption.pathSeq, 
					orgCd: approvalChangeOption.orgCd,
					name: name,
					orgNm: orgNm };
		approvalSheet.DoSearch('/AppPathReg.do?cmd=getAppPathRegOrgUserList', queryStringToJson(p));
		break;
	}
}

function createApprovalLineSheet() {
	createIBSheet3($('#approvalLineSheetArea').get(0), "approvalLineSheet", "100%", "100%", '${ssnLocaleCd}');
	var initdata = {};
	var applNot40Codes = convCodeIdx( codeList('/CommonCode.do?cmd=getCommonCodeList&notCode=40', 'R10052'), '',-1);
	initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:1,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:0,  Width:"${sDelWdt}", 	Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
		{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",	Type:"Text",		Hidden:1,  Width:20,  			Align:"Center",  ColMerge:0,   SaveName:"agreeSeq",      KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", 	Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",  	Hidden:1,  Width:50,   	Align:"Center",  ColMerge:0,   SaveName:"agreeSabun",  	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
       	{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",	Hidden:0,  Width:65,   	Align:"Center",  ColMerge:0,   SaveName:"name",       	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
       	{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",	Hidden:Number("${aliasHdn}"),  Width:65,   	Align:"Center",  ColMerge:0,   SaveName:"empAlias",    	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",	Hidden:0,  Width:65, 	Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",	Hidden:1,  Width:65,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='jikchakCdV2' mdef='직책코드'/>",	Type:"Text",	Hidden:1,  Width:65, 	Align:"Center",  ColMerge:0,   SaveName:"jikchakCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='jikweeCdV2' mdef='직위코드'/>",	Type:"Text",	Hidden:1,  Width:65,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='orgNmV9' mdef='부서명'/>",	Type:"Text",	Hidden:0,  Width:65,  	Align:"Center",  ColMerge:0,   SaveName:"orgNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='orgCdV8' mdef='부서코드'/>",	Type:"Text",	Hidden:1,  Width:65,  	Align:"Center",  ColMerge:0,   SaveName:"orgCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='applTypeCd' mdef='결재구분'/>",	Type:"Combo",	Hidden:0,  Width:80, ComboText:applNot40Codes[0], 	ComboCode:applNot40Codes[1],  	Align:"Center",  ColMerge:0,   SaveName:"applTypeCd",	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0},
		{Header:"<sht:txt mid='pathSeq' mdef='경로순서'/>",	Type:"Text",	Hidden:1,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"pathSeq",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
	]; 
	IBS_InitSheet(approvalLineSheet, initdata); 
	approvalLineSheet.SetEditable(true);
	approvalLineSheet.SetVisible(true);
	approvalLineSheet.SetSheetHeight(108);
	approvalLineAction('Search');
}

function approvalLineSheet_OnClick(row, col, val) {
	try {
		if (row > 0) {
			if( col == approvalLineSheet.SaveNameCol("sDelete") ) {
				approvalLineSetAgreeSeq();
			}
		}
	} catch (ex) {
		alert('OnClick Event Erorr : ' + ex);
	}
}

function approvalLineAction(action) {
	switch(action) {
	case 'Search':
		approvalChangeOption.appls.forEach(a => {
			var row = approvalLineSheet.DataInsert(approvalLineSheet.LastRow() + 1);
			approvalLineSheet.SetCellValue(row, 'agreeSeq', a.agreeSeq);
			approvalLineSheet.SetCellValue(row, 'name', a.name);
			approvalLineSheet.SetCellValue(row, 'agreeSabun', a.agreeSabun);
			approvalLineSheet.SetCellValue(row, 'empAlias', a.empAlias);
			approvalLineSheet.SetCellValue(row, 'jikchakNm', a.jikchak);
			approvalLineSheet.SetCellValue(row, 'jikchakCd', a.jikchakCd);
			approvalLineSheet.SetCellValue(row, 'jikweeNm', a.jikwee);
			approvalLineSheet.SetCellValue(row, 'jikweeCd', a.jikweeCd);
			approvalLineSheet.SetCellValue(row, 'applTypeCd', a.applTypeCd);
			approvalLineSheet.SetCellValue(row, 'orgNm', a.org);
			approvalLineSheet.SetCellValue(row, 'orgCd', a.orgCd);
			if (a.agreeSabun == '${ssnSabun}' && a.agreeSeq == '1' && a.applTypeCd == '30') {
				approvalLineSheet.SetRowEditable(row, 0);
			}
		});
		break;
	case 'Up':
		var lrow = approvalLineSheet.LastRow(), orow = approvalLineSheet.GetSelectRow(), nrow = orow - 1;
		if (nrow == 0) return;
		break;
	case 'Down':
		var lrow = approvalLineSheet.LastRow(), orow = approvalLineSheet.GetSelectRow(), nrow = orow + 1;
		if (lrow < nrow) return;
		
		break;
	}
}

function approvalLineSheetSwap(action) {
	var lrow = approvalLineSheet.LastRow(), orow = approvalLineSheet.GetSelectRow();
	var nrow = -1;
	
	if (action == 'Up') nrow = orow - 1;
	else nrow = orow + 1;

	if ((action == 'Up' && nrow == 0) || (action == 'Down' && lrow < nrow)) return;
	
	var oSdelete	= approvalLineSheet.GetCellValue(orow, "sDelete");
	var oSstatus	= approvalLineSheet.GetCellValue(orow, "sStatus");
	var oName		= approvalLineSheet.GetCellValue(orow, "name");
	var oEmpAlias	= approvalLineSheet.GetCellValue(orow, "empAlias");
	var oAgreeSabun	= approvalLineSheet.GetCellValue(orow, "agreeSabun");
	var oJikchakCd	= approvalLineSheet.GetCellValue(orow, "jikchakCd");
	var oJikchakNm	= approvalLineSheet.GetCellValue(orow, "jikchakNm");
	var oJikweeCd	= approvalLineSheet.GetCellValue(orow, "jikweeCd");
	var oJikweeNm	= approvalLineSheet.GetCellValue(orow, "jikweeNm");
	var oOrgCd		= approvalLineSheet.GetCellValue(orow, "orgCd");
	var oOrgNm		= approvalLineSheet.GetCellValue(orow, "orgNm");
	var oApplTypeCd	= approvalLineSheet.GetCellValue(orow, "applTypeCd");
	var oPathSeq	= approvalLineSheet.GetCellValue(orow, "pathSeq");

	if (oApplTypeCd == '30' || approvalLineSheet.GetCellValue(nrow, 'applTypeCd') == '30') {
		return alert("<msg:txt mid='109731' mdef='기안자는 이동 할수 없습니다!'/>");
	}

	approvalLineSheet.SetCellValue(orow, "sDelete", 	approvalLineSheet.GetCellValue(nrow, "sDelete"));
	approvalLineSheet.SetCellValue(orow, "sStatus", 	approvalLineSheet.GetCellValue(nrow, "sStatus"));
	approvalLineSheet.SetCellValue(orow, "name", 		approvalLineSheet.GetCellValue(nrow, "name"));
	approvalLineSheet.SetCellValue(orow, "empAlias", 	approvalLineSheet.GetCellValue(nrow, "empAlias"));
	approvalLineSheet.SetCellValue(orow, "agreeSabun",  approvalLineSheet.GetCellValue(nrow, "agreeSabun"));
	approvalLineSheet.SetCellValue(orow, "jikchakCd", 	approvalLineSheet.GetCellValue(nrow, "jikchakCd"));
	approvalLineSheet.SetCellValue(orow, "jikchakNm", 	approvalLineSheet.GetCellValue(nrow, "jikchakNm"));
	approvalLineSheet.SetCellValue(orow, "jikweeCd", 	approvalLineSheet.GetCellValue(nrow, "jikweeCd"));
	approvalLineSheet.SetCellValue(orow, "jikweeNm", 	approvalLineSheet.GetCellValue(nrow, "jikweeNm"));
	approvalLineSheet.SetCellValue(orow, "orgCd", 		approvalLineSheet.GetCellValue(nrow, "orgCd"));
	approvalLineSheet.SetCellValue(orow, "orgNm", 		approvalLineSheet.GetCellValue(nrow, "orgNm"));
	approvalLineSheet.SetCellValue(orow, "applTypeCd",  approvalLineSheet.GetCellValue(nrow, "applTypeCd"));
	approvalLineSheet.SetCellValue(orow, "pathSeq", 	approvalLineSheet.GetCellValue(nrow, "pathSeq"));
	approvalLineSheet.SetCellValue(nrow, "sDelete", 	oSdelete);
	approvalLineSheet.SetCellValue(nrow, "sStatus", 	oSstatus);
	approvalLineSheet.SetCellValue(nrow, "name", 		oName);
	approvalLineSheet.SetCellValue(nrow, "empAlias", 	oEmpAlias);
	approvalLineSheet.SetCellValue(nrow, "agreeSabun",  oAgreeSabun);
	approvalLineSheet.SetCellValue(nrow, "jikchakCd", 	oJikchakCd);
	approvalLineSheet.SetCellValue(nrow, "jikchakNm", 	oJikchakNm);
	approvalLineSheet.SetCellValue(nrow, "jikweeCd", 	oJikweeCd);
	approvalLineSheet.SetCellValue(nrow, "jikweeNm", 	oJikweeNm);
	approvalLineSheet.SetCellValue(nrow, "orgCd", 		oOrgCd);
	approvalLineSheet.SetCellValue(nrow, "orgNm", 		oOrgNm);
	approvalLineSheet.SetCellValue(nrow, "applTypeCd",  oApplTypeCd);
	approvalLineSheet.SetCellValue(nrow, "pathSeq", 	oPathSeq);

	approvalLineSetAgreeSeq();
	approvalLineSheet.SelectCell(nrow, 1);
}

function approvalLineSetAgreeSeq() {
	for (let i = 1; i < approvalLineSheet.LastRow() + 1; i++) {
		approvalLineSheet.SetCellValue(i, "agreeSeq", i);
	}
} 

function createInchargeSheet() {
	createIBSheet3($('#inchargeSheetArea').get(0), "inchargeSheet", "100%", "100%", '${ssnLocaleCd}');
	var applNot30Codes = convCodeIdx( codeList('/CommonCode.do?cmd=getCommonCodeList&notCode=30', 'R10052'), '',-1);
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:1,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:0,  Width:"${sDelWdt}", 	Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
		{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",	Type:"Text",		Hidden:1,  Width:20,  			Align:"Center",  ColMerge:0,   SaveName:"agreeSeq",      KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", 	Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",  	Hidden:1,  Width:55,   	Align:"Center",  ColMerge:0,   SaveName:"agreeSabun",  	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
       	{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",	Hidden:0,  Width:60,   	Align:"Center",  ColMerge:0,   SaveName:"name",       	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",  	Hidden:Number("${aliasHdn}"),  Width:65,   	Align:"Center",  ColMerge:0,   SaveName:"empAlias",  	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",	Hidden:0,  Width:65, 	Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",	Hidden:1,  Width:65,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='jikchakCdV2' mdef='직책코드'/>",	Type:"Text",	Hidden:1,  Width:65, 	Align:"Center",  ColMerge:0,   SaveName:"jikchakCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='jikweeCdV2' mdef='직위코드'/>",	Type:"Text",	Hidden:1,  Width:65,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='orgNmV9' mdef='부서명'/>",	Type:"Text",	Hidden:0,  Width:65,  	Align:"Center",  ColMerge:0,   SaveName:"orgNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='orgCdV8' mdef='부서코드'/>",	Type:"Text",	Hidden:1,  Width:65,  	Align:"Center",  ColMerge:0,   SaveName:"orgCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='applTypeCd' mdef='결재구분'/>",	Type:"Combo",	Hidden:0,  Width:80, ComboText:applNot30Codes[0], 	ComboCode:applNot30Codes[1],  	Align:"Center",  ColMerge:0,   SaveName:"applTypeCd",	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0},
		{Header:"<sht:txt mid='pathSeq' mdef='경로순서'/>",	Type:"Text",	Hidden:1,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"pathSeq",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
	]; 
	IBS_InitSheet(inchargeSheet, initdata); 
	inchargeSheet.SetEditable(true);
	inchargeSheet.SetVisible(true);
	inchargeSheet.SetSheetHeight(108);
	inchargeSheet.SetColProperty("applTypeCd", {ComboText:applNot30Codes[0], 	ComboCode:applNot30Codes[1]} );
	inchargeAction('Search');
}

function inchargeAction(action) {
	switch(action) {
	case 'Search':
		//배열 뒤집기
		//const tmpinusers = approvalChangeOption.inusers.slice().reverse();
		approvalChangeOption.inusers.filter(a => a.agreeSabun).forEach((a, i) => {
			var row = inchargeSheet.DataInsert(inchargeSheet.LastRow() + 1);
			inchargeSheet.SetCellValue(row,"agreeSeq", i + 1);
			inchargeSheet.SetCellValue(row,"name", a.agreeName);
			inchargeSheet.SetCellValue(row,"empAlias", a.empAlias);
			inchargeSheet.SetCellValue(row,"agreeSabun", a.agreeSabun);
			inchargeSheet.SetCellValue(row,"jikchakNm", a.jikchak);
			inchargeSheet.SetCellValue(row,"jikchakCd", a.jikchakCd);
			inchargeSheet.SetCellValue(row,"jikweeNm", a.jikwee);
			inchargeSheet.SetCellValue(row,"jikweeCd", a.jikweeCd);
			inchargeSheet.SetCellValue(row,"applTypeCd", a.applTypeCd);
			inchargeSheet.SetCellValue(row,"orgNm", a.org);
			inchargeSheet.SetCellValue(row,"orgCd", a.orgCd);
		});
		break;
	}
}

function inchargeSheetLineSwap(action) {
	var lrow = inchargeSheet.LastRow(), orow = inchargeSheet.GetSelectRow();
	var nrow = -1;
	
	if (action == 'Up') nrow = orow - 1;
	else nrow = orow + 1;

	if ((action == 'Up' && nrow == 0) || (action == 'Down' && lrow < nrow)) return;
	
	var oSdelete	= inchargeSheet.GetCellValue(orow, "sDelete");
	var oSstatus	= inchargeSheet.GetCellValue(orow, "sStatus");
	var oName		= inchargeSheet.GetCellValue(orow, "name");
	var oEmpAlias	= inchargeSheet.GetCellValue(orow, "empAlias");
	var oAgreeSabun	= inchargeSheet.GetCellValue(orow, "agreeSabun");
	var oJikchakCd	= inchargeSheet.GetCellValue(orow, "jikchakCd");
	var oJikchakNm	= inchargeSheet.GetCellValue(orow, "jikchakNm");
	var oJikweeCd	= inchargeSheet.GetCellValue(orow, "jikweeCd");
	var oJikweeNm	= inchargeSheet.GetCellValue(orow, "jikweeNm");
	var oOrgCd		= inchargeSheet.GetCellValue(orow, "orgCd");
	var oOrgNm		= inchargeSheet.GetCellValue(orow, "orgNm");
	var oApplTypeCd	= inchargeSheet.GetCellValue(orow, "applTypeCd");
	var oPathSeq	= inchargeSheet.GetCellValue(orow, "pathSeq");

	inchargeSheet.SetCellValue(orow, "sDelete", 	inchargeSheet.GetCellValue(nrow, "sDelete"));
	inchargeSheet.SetCellValue(orow, "sStatus", 	inchargeSheet.GetCellValue(nrow, "sStatus"));
	inchargeSheet.SetCellValue(orow, "name", 		inchargeSheet.GetCellValue(nrow, "name"));
	inchargeSheet.SetCellValue(orow, "empAlias", 	inchargeSheet.GetCellValue(nrow, "empAlias"));
	inchargeSheet.SetCellValue(orow, "agreeSabun",  inchargeSheet.GetCellValue(nrow, "agreeSabun"));
	inchargeSheet.SetCellValue(orow, "jikchakCd", 	inchargeSheet.GetCellValue(nrow, "jikchakCd"));
	inchargeSheet.SetCellValue(orow, "jikchakNm", 	inchargeSheet.GetCellValue(nrow, "jikchakNm"));
	inchargeSheet.SetCellValue(orow, "jikweeCd", 	inchargeSheet.GetCellValue(nrow, "jikweeCd"));
	inchargeSheet.SetCellValue(orow, "jikweeNm", 	inchargeSheet.GetCellValue(nrow, "jikweeNm"));
	inchargeSheet.SetCellValue(orow, "orgCd", 		inchargeSheet.GetCellValue(nrow, "orgCd"));
	inchargeSheet.SetCellValue(orow, "orgNm", 		inchargeSheet.GetCellValue(nrow, "orgNm"));
	inchargeSheet.SetCellValue(orow, "applTypeCd",  inchargeSheet.GetCellValue(nrow, "applTypeCd"));
	inchargeSheet.SetCellValue(orow, "pathSeq", 	inchargeSheet.GetCellValue(nrow, "pathSeq"));
	inchargeSheet.SetCellValue(nrow, "sDelete", 	oSdelete);
	inchargeSheet.SetCellValue(nrow, "sStatus", 	oSstatus);
	inchargeSheet.SetCellValue(nrow, "name", 		oName);
	inchargeSheet.SetCellValue(nrow, "empAlias", 	oEmpAlias);
	inchargeSheet.SetCellValue(nrow, "agreeSabun",  oAgreeSabun);
	inchargeSheet.SetCellValue(nrow, "jikchakCd", 	oJikchakCd);
	inchargeSheet.SetCellValue(nrow, "jikchakNm", 	oJikchakNm);
	inchargeSheet.SetCellValue(nrow, "jikweeCd", 	oJikweeCd);
	inchargeSheet.SetCellValue(nrow, "jikweeNm", 	oJikweeNm);
	inchargeSheet.SetCellValue(nrow, "orgCd", 		oOrgCd);
	inchargeSheet.SetCellValue(nrow, "orgNm", 		oOrgNm);
	inchargeSheet.SetCellValue(nrow, "applTypeCd",  oApplTypeCd);
	inchargeSheet.SetCellValue(nrow, "pathSeq", 	oPathSeq);
	inchargeSheet.SelectCell(nrow, 1);
}

function createReceivSheet() {
	createIBSheet3($('#receivSheetArea').get(0), "receivSheet", "100%", "100%", '${ssnLocaleCd}');
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:1,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:0,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",	Type:"Text",      	Hidden:1,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"ccSabun", 	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
       	{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",	Type:"Text",     	Hidden:0,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"name",		KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
       	{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",Type:"Text",     	Hidden:Number("${aliasHdn}"),  Width:65,   	Align:"Center",  ColMerge:0,   SaveName:"empAlias",	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",	Type:"Text",      	Hidden:0,  Width:65,  	Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",	Type:"Text",      	Hidden:1,  Width:70,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='jikchakCdV2' mdef='직책코드'/>",	Type:"Text", 	Hidden:1,  Width:65,  	Align:"Center",  ColMerge:0,   SaveName:"jikchakCd",KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='jikweeCdV2' mdef='직위코드'/>",	Type:"Text",   	Hidden:1,  Width:65,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='orgNmV9' mdef='부서명'/>",	Type:"Text",   	Hidden:0,  Width:100,  	Align:"Center",  ColMerge:0,   SaveName:"orgNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='orgCdV8' mdef='부서코드'/>",	Type:"Text",    Hidden:1,  Width:65,  	Align:"Center",  ColMerge:0,   SaveName:"orgCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"<sht:txt mid='pathSeq' mdef='경로순서'/>",	Type:"Text",	Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   SaveName:"pathSeq", 	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
	]; 
	IBS_InitSheet(receivSheet, initdata); 
	receivSheet.SetEditable(true);
	receivSheet.SetVisible(true);
	receivSheet.SetSheetHeight(108);
	receivAction('Search');
}

function receivAction(action) {
	switch(action) {
	case 'Search':
		approvalChangeOption.refers.filter(a => a.referSabun).forEach(a => {
			var row = receivSheet.DataInsert(receivSheet.LastRow() + 1);
			receivSheet.SetCellValue(row, 'name', a.referName);
			receivSheet.SetCellValue(row, 'ccSabun', a.referSabun);
			receivSheet.SetCellValue(row, 'jikchakNm', a.referJikchak);
			receivSheet.SetCellValue(row, 'jikchakCd', a.referJikchakCd);
			receivSheet.SetCellValue(row, 'jikweeNm', a.referJikwee);
			receivSheet.SetCellValue(row, 'jikweeCd', a.referJikweeCd);
			receivSheet.SetCellValue(row, 'orgNm', a.referOrg);
			receivSheet.SetCellValue(row, 'orgCd', a.referOrgCd);
			receivSheet.SetCellValue(row, 'empAlias', a.referEmpAlias);
		});
		break;
	}
}

function mvApprovalLine() {
	var chkrow = approvalSheet.FindCheckedRow('chkbox');
	if (chkrow == '') { alert("<msg:txt mid='109886' mdef='결재자를 선택 하세요!'/>"); return; }
	var chkArrays = chkrow.split('|');
	var chkdupTxt = null;
	var dupText = '';
	var cnt = 1;
	for (var i = 0; i < chkArrays.length; i++) {
		chkdupTxt = approvalLineSheet.FindText('agreeSabun', approvalSheet.GetCellValue(chkArrays[i], 'sabun'));
		if (chkdupTxt == -1) {
			var row = approvalLineSheet.DataInsert(approvalLineSheet.LastRow() + 1);
			approvalLineSheet.SelectCell(row, 2);
			approvalLineSheet.SetCellValue(row, "name",			approvalSheet.GetCellValue(chkArrays[i],"name") );
			approvalLineSheet.SetCellValue(row, "empAlias",		approvalSheet.GetCellValue(chkArrays[i],"empAlias") );
			approvalLineSheet.SetCellValue(row, "agreeSabun",	approvalSheet.GetCellValue(chkArrays[i],"sabun") );
			approvalLineSheet.SetCellValue(row, "orgNm",		approvalSheet.GetCellValue(chkArrays[i],"orgNm") );
			approvalLineSheet.SetCellValue(row, "orgCd",		approvalSheet.GetCellValue(chkArrays[i],"orgCd") );
			approvalLineSheet.SetCellValue(row, "jikchakNm",	approvalSheet.GetCellValue(chkArrays[i],"jikchakNm") );
			approvalLineSheet.SetCellValue(row, "jikweeNm",		approvalSheet.GetCellValue(chkArrays[i],"jikweeNm") );
			approvalLineSheet.SetCellValue(row, "jikchakCd",	approvalSheet.GetCellValue(chkArrays[i],"jikchakCd") );
			approvalLineSheet.SetCellValue(row, "jikweeCd",		approvalSheet.GetCellValue(chkArrays[i],"jikweeCd") );
			approvalLineSheet.SetCellValue(row, "pathSeq",		approvalChangeOption.pathSeq);
		} else {
			dupText += cnt + '.' + approvalSheet.GetCellValue(chkArrays[i], 'sabun') + '\n'; cnt++;
		}
	}
	if(dupText != "") alert("<msg:txt mid='alertExistsEmpIdV1' mdef='중복된 사번이 존재 합니다.'/>");
	approvalLineSetAgreeSeq();
	approvalSheet.CheckAll('chkbox', 0);
}

function mvInchargeLine() {
	var chkrow = approvalSheet.FindCheckedRow('chkbox');
	if(chkrow == ""){ alert("<msg:txt mid='110030' mdef='담당자를 선택 하세요!'/>"); return; }
	var chkArrays = chkrow.split('|');
	var chkdupTxt = null;
	var dupText = '';
	var cnt = 1;
	for (var i = 0; i < chkArrays.length; i++) {
		chkdupTxt = inchargeSheet.FindText('agreeSabun', approvalSheet.GetCellValue(chkArrays[i], 'sabun'));
		if (chkdupTxt == -1) {
			var row = inchargeSheet.DataInsert(inchargeSheet.LastRow() + 1);
			inchargeSheet.SelectCell(row, 2);
			inchargeSheet.SetCellValue(row, "name",			approvalSheet.GetCellValue(chkArrays[i],"name") );
			inchargeSheet.SetCellValue(row, "empAlias",		approvalSheet.GetCellValue(chkArrays[i],"empAlias") );
			inchargeSheet.SetCellValue(row, "agreeSabun",	approvalSheet.GetCellValue(chkArrays[i],"sabun") );
			inchargeSheet.SetCellValue(row, "orgNm",		approvalSheet.GetCellValue(chkArrays[i],"orgNm") );
			inchargeSheet.SetCellValue(row, "orgCd",		approvalSheet.GetCellValue(chkArrays[i],"orgCd") );
			inchargeSheet.SetCellValue(row, "jikchakNm",	approvalSheet.GetCellValue(chkArrays[i],"jikchakNm") );
			inchargeSheet.SetCellValue(row, "jikweeNm",		approvalSheet.GetCellValue(chkArrays[i],"jikweeNm") );
			inchargeSheet.SetCellValue(row, "jikchakCd",	approvalSheet.GetCellValue(chkArrays[i],"jikchakCd") );
			inchargeSheet.SetCellValue(row, "jikweeCd",		approvalSheet.GetCellValue(chkArrays[i],"jikweeCd") );
			inchargeSheet.SetCellValue(row, "pathSeq",		approvalChangeOption.pathSeq);
			if (row == inchargeSheet.LastRow()) {
				inchargeSheet.SetCellValue(row, 'applTypeCd', '40');
			} else {
				inchargeSheet.SetCellValue(row, 'applTypeCd', '10');
			}
		} else {
			dupText += cnt + '.' + approvalSheet.GetCellValue(chkArrays[i], 'sabun') + '\n'; cnt++;
		}
	}
	approvalSheet.CheckAll('chkbox', 0);
}

function mvReceivLine() {
	var chkrow = approvalSheet.FindCheckedRow('chkbox');
	if(chkrow == ""){ alert("<msg:txt mid='110029' mdef='참조자를 선택 하세요!'/>");return; }
	var chkArrays = chkrow.split('|');
	var chkdupTxt = null;
	var dupText = '';
	var cnt = 1;
	
	for (var i = 0; i < chkArrays.length; i++) {
		chkdupTxt = receivSheet.FindText('ccSabun', receivSheet.GetCellValue(chkArrays[i], 'sabun'));
		if (chkdupTxt == -1) {
			var row = receivSheet.DataInsert(receivSheet.LastRow() + 1);
			receivSheet.SelectCell(row, 2);
			receivSheet.SetCellValue(row, "name",			approvalSheet.GetCellValue(chkArrays[i],"name") );
			receivSheet.SetCellValue(row, "empAlias",		approvalSheet.GetCellValue(chkArrays[i],"empAlias") );
			receivSheet.SetCellValue(row, "ccSabun",		approvalSheet.GetCellValue(chkArrays[i],"sabun") );
			receivSheet.SetCellValue(row, "orgNm",			approvalSheet.GetCellValue(chkArrays[i],"orgNm") );
			receivSheet.SetCellValue(row, "orgCd",			approvalSheet.GetCellValue(chkArrays[i],"orgCd") );
			receivSheet.SetCellValue(row, "jikchakNm",		approvalSheet.GetCellValue(chkArrays[i],"jikchakNm") );
			receivSheet.SetCellValue(row, "jikweeNm",		approvalSheet.GetCellValue(chkArrays[i],"jikweeNm") );
			receivSheet.SetCellValue(row, "jikchakCd",		approvalSheet.GetCellValue(chkArrays[i],"jikchakCd") );
			receivSheet.SetCellValue(row, "jikweeCd",		approvalSheet.GetCellValue(chkArrays[i],"jikweeCd") );
			receivSheet.SetCellValue(row, "pathSeq",		approvalChangeOption.pathSeq);
		} else {
			dupText += cnt + '.' + approvalSheet.GetCellValue(chkArrays[i], 'sabun') + '\n'; cnt++;
		}
	}
	if(dupText != "") alert("<msg:txt mid='alertExistsEmpIdV1' mdef='중복된 사번이 존재 합니다.'/>");
	approvalSheet.CheckAll("chkbox", 0);
}

</script>
<div id="ApprovalLineChangeLayerBody" class="wrapper modal_layer">
	<div class="modal_body">
		<div class="outer"></div>
		<div id="gap" class="h15 outer"></div>
		<div class="sheet_search outer">
			<form id="sheetForm" name="sheetForm">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='103880' mdef='성명'/></th>
							<td>
								<input id="approvalLineChangeName" type="text" class="text" disabled/>
							</td>
							<th><tit:txt mid='104279' mdef='소속'/></th>
							<td>
								<input id="approvalLineChangeOrgNm" type="text" class="text" disabled/>
							</td>
							<td>
								<input id="approvalLineChangeRadio" name="approvalLineChangeRadio" type="radio" class="radio" value="Y" /> 리스트
								<input id="approvalLineChangeRadio" name="approvalLineChangeRadio" type="radio" class="radio" value="N" checked/> 조직도
							</td>
							<td id="btnApprovalLineChangeOrg">
								<a href="javascript:approvalLineChangeSearch();" class="button"><tit:txt mid='104081' mdef='조회'/></a>
							</td>
						</tr>
					</table>
				</div>
			</form>
		</div>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td id="orgMain" class="sheet_left w30p">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='orgSchemeMgr' mdef='조직도'/></li>
						<li class="btn">
						</li>
					</ul>
					</div>
				</div>
				<div id="orgSheetArea"></div>
			</td>
			<td id="listMain" class="sheet_left w30p">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='schAppSabun' mdef='결재자 검색'/></li>
						<li class="btn">
						</li>
					</ul>
					</div>
				</div>
				<div id="approvalSheetArea"></div>
			</td>
			<td class="sheet_arrow"></td>
			<td class="sheet_right w40p">
				<div class="sheet_button2">
					<div class="arrow_button">
						<btn:a href="javascript:mvApprovalLine();" css="pink" mid='111114' mdef="결재&gt;"/>
					</div>

					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='schAppLine' mdef='결재선 내역'/></li>
							<li class="btn">
								<btn:a href="javascript:approvalLineSheetSwap('Up');" css="basic" mid='110755' mdef="위"/>
								<btn:a href="javascript:approvalLineSheetSwap('Down');" css="basic" mid='111045' mdef="아래"/>
							</li>
						</ul>
						</div>
					</div>
					<div id="approvalLineSheetArea"></div>
				</div>

				<div class="sheet_button2">
					<div class="arrow_button outer">
						<btn:a href="javascript:mvInchargeLine();" css="pink" mid='110915' mdef="담당&gt;"/>
					</div>

					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='112478' mdef='담당 내역'/></li>
							<li class="btn">
								<btn:a href="javascript:inchargeSheetLineSwap('Up');" css="basic" mid='110755' mdef="위"/>
								<a href="javascript:inchargeSheetLineSwap('Down');" class="basic"><tit:txt mid='112141' mdef='아래'/></a>
							</li>
						</ul>
						</div>
					</div>
					<div id="inchargeSheetArea"></div>
				</div>

				<div class="sheet_button2">
					<div class="arrow_button">
						<btn:a href="javascript:mvReceivLine();" css="pink" mid='110746' mdef="참조&gt;"/>
					</div>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='schRefDetail' mdef='참조 내역'/></li>
							<li class="btn"></li>
						</ul>
						</div>
					</div>
					<div id="receivSheetArea"></div>
				</div>
			</td>
		</tr>
		</table>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeApprovalLineChangeLayer();" css="btn outline_gray" mid='110881' mdef="닫기" />
		<btn:a href="javascript:closeApprovalLineChangeLayerWithParam();" css="btn filled" mid='110729' mdef="적용" />
	</div>
</div>
