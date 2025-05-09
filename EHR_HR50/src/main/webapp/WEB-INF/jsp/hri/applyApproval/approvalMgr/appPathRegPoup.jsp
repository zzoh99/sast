<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112145' mdef='결재선 경로 변경'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
//20220527. 부서명 등에 ,@등의 특수문자가 포함된 경우 문자열 split이 정상 동작하지 않음. 구분자의 복잡도를 올려서 해결함.
//var deli		= ",";
//var deli2		= "@";
var deli		= ",,,,,";
var deli2		= "@@@@@";

var pathSeq 	= "";
var applList 	= null;
var referList 	= null;
var inApplList 	= null;
var applCdList 	= null;
var applCdList40 	= null;
var parentSabun = null;
var da 			= null;
var orgCd 	 	= null;
var p = eval("${popUpStatus}");

	$(function() {
		orgCd = p.popDialogArgument("orgCd");

		da = p.popDialogArgumentAll();
		if(da) da = p.opener;
		var rt1 = da.getApplHtmlToPaser();
		var rt2 = da.getInUserHtmlToPaser();
		pathSeq 	= rt1[0];
		applList 	= rt1[1];
		referList 	= rt1[2];
		referStr 	= rt1[5];
		inApplList 	= rt2[1];

		//parentSabun = rt[7];//신청입력자사번
		parentSabun = rt1[11];//신청자사번

		$("#pathSeq").val(pathSeq);
	    applCdList 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&notCode=40","R10052"), "",-1);
	    applCdList40 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&notCode=30","R10052"), "",-1);

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
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",      	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   SaveName:"sabun",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",      	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   SaveName:"name",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",      	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   SaveName:"empAlias", 	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='departmentV1' mdef='부서'/>",		Type:"Text",     	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"orgNm",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgCdV8' mdef='부서코드'/>",	Type:"Text",  		Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"orgCd",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",      	Hidden:0,  Width:50,   	Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",      	Hidden:0,  Width:50,   	Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
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
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",	Type:"Text",		Hidden:1,  Width:20,  			Align:"Center",  ColMerge:0,   SaveName:"agreeSeq",      KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", 	Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",  	Hidden:0,  Width:50,   	Align:"Center",  ColMerge:0,   SaveName:"agreeSabun",  	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	       	{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",	Hidden:0,  Width:40,   	Align:"Center",  ColMerge:0,   SaveName:"name",       	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	       	{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",	Hidden:0,  Width:40,   	Align:"Center",  ColMerge:0,   SaveName:"empAlias",    	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",	Hidden:0,  Width:50, 	Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikchakCdV2' mdef='직책코드'/>",	Type:"Text",	Hidden:1,  Width:50, 	Align:"Center",  ColMerge:0,   SaveName:"jikchakCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikweeCdV2' mdef='직위코드'/>",	Type:"Text",	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgNmV9' mdef='부서명'/>",	Type:"Text",	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"orgNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgCdV8' mdef='부서코드'/>",	Type:"Text",	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"orgCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applTypeCd' mdef='결재구분'/>",	Type:"Combo",	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"applTypeCd",	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='pathSeq' mdef='경로순서'/>",	Type:"Text",	Hidden:1,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"pathSeq",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
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
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",	Type:"Text",      	Hidden:0,  Width:50,   	Align:"Center",  ColMerge:0,   SaveName:"ccSabun", 	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	       	{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",	Type:"Text",     	Hidden:0,  Width:40,   	Align:"Center",  ColMerge:0,   SaveName:"name",		KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	       	{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",Type:"Text",     	Hidden:0,  Width:40,   	Align:"Center",  ColMerge:0,   SaveName:"empAlias",	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",	Type:"Text",      	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",	Type:"Text",      	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikchakCdV2' mdef='직책코드'/>",	Type:"Text", 	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikchakCd",KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikweeCdV2' mdef='직위코드'/>",	Type:"Text",   	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgNmV9' mdef='부서명'/>",	Type:"Text",   	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"orgNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgCdV8' mdef='부서코드'/>",	Type:"Text",    Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"orgCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='pathSeq' mdef='경로순서'/>",	Type:"Text",	Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   SaveName:"pathSeq", 	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet5, initdata); sheet5.SetEditable(true);sheet5.SetVisible(true);

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:1,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:0,  Width:"${sDelWdt}", 	Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",	Type:"Text",		Hidden:1,  Width:20,  			Align:"Center",  ColMerge:0,   SaveName:"agreeSeq",      KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", 	Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",  	Hidden:0,  Width:50,   	Align:"Center",  ColMerge:0,   SaveName:"agreeSabun",  	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	       	{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",	Hidden:0,  Width:40,   	Align:"Center",  ColMerge:0,   SaveName:"name",       	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",  	Hidden:0,  Width:50,   	Align:"Center",  ColMerge:0,   SaveName:"empAlias",  	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",	Hidden:0,  Width:50, 	Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikchakCdV2' mdef='직책코드'/>",	Type:"Text",	Hidden:1,  Width:50, 	Align:"Center",  ColMerge:0,   SaveName:"jikchakCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikweeCdV2' mdef='직위코드'/>",	Type:"Text",	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgNmV9' mdef='부서명'/>",	Type:"Text",	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"orgNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgCdV8' mdef='부서코드'/>",	Type:"Text",	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"orgCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applTypeCd' mdef='결재구분'/>",	Type:"Combo",	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"applTypeCd",	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='pathSeq' mdef='경로순서'/>",	Type:"Text",	Hidden:1,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"pathSeq",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet6, initdata); sheet6.SetEditable(true);sheet6.SetVisible(true);
		sheet6.SetColProperty("applTypeCd", 		{ComboText:applCdList40[0], 	ComboCode:applCdList40[1]} );

		$(window).smartresize(sheetResize); sheetInit();

		$("input[name=radio]").change(function() {
	    	var radioValue = $(this).val();
	    	if( radioValue == "Y" ) {
	    		$("#orgMain").addClass("hide");
	    		$("#listMain").removeClass("w30p");
	    		$("#listMain").addClass("w65p");
	    		$("#name").attr("disabled",false);
	    		$("#orgNm").attr("disabled",false);
	    		$("#btnOrg").attr("disabled",false);
	    	}
	    	else {
	    		$("#orgMain").removeClass("hide");
	    		$("#listMain").removeClass("w65p");
	    		$("#listMain").addClass("w30p");
	    		$("#name").val("").attr("disabled",true);
	    		$("#orgNm").val("").attr("disabled",true);
	    		$("#btnOrg").attr("disabled",true);
				$("#orgCd").val(sheet2.GetCellValue(sheet2.GetSelectRow(),"orgCd"));
				$("#name").val("");
				$("#orgNm").val("");
	    		doAction3("Search");
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
		doAction4("Search");
		doAction5("Search");
		doAction6("Search");
		$("#sabun").val("");
	});

    function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch( "${ctx}/AppPathReg.do?cmd=getAppPathOrgList", $("#sheetForm").serialize());
			break;
		}
    }
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
			sheet3.DoSearch( "${ctx}/AppPathReg.do?cmd=getAppPathRegOrgUserList", $("#sheetForm").serialize());
			break;
		}
	}
    function doAction4(sAction) {
		switch (sAction) {
		case "Search":
// 			sheet4.DoSearch( "${ctx}/AppPathReg.do?cmd=getAppPathRegApplList", $("#sheetForm").serialize());
				var Row 	= "";
				var RowData = null;
				//결재순서역순처리 2022.03.14
				//for(var i=0; i<applList.length; i++){
				for(var i=applList.length - 1; i>=0 ; i--){
					Row 	= sheet4.DataInsert(sheet4.LastRow()+1);
					RowData = applList[i].split(deli);
					sheet4.SetCellValue(Row,"agreeSeq", 	RowData[0]);
					sheet4.SetCellValue(Row,"name", 		RowData[5]);
					sheet4.SetCellValue(Row,"empAlias",		RowData[11]);
					sheet4.SetCellValue(Row,"agreeSabun",	RowData[6]);
					sheet4.SetCellValue(Row,"jikchakNm",	RowData[10]);
					sheet4.SetCellValue(Row,"jikchakCd",	RowData[9]);
					sheet4.SetCellValue(Row,"jikweeNm",		RowData[8]);
					sheet4.SetCellValue(Row,"jikweeCd",		RowData[7]);
					sheet4.SetCellValue(Row,"applTypeCd",	RowData[2]);
					sheet4.SetCellValue(Row,"orgNm",		RowData[3]);
					sheet4.SetCellValue(Row,"orgCd",		RowData[4]);
					//결재순서역순처리 2022.03.14
					/*if( RowData[2] == "30") {
						sheet4.SetRowEditable(Row, 0);
					}*/
					//첫번재결재는 본인이고 삭제 못하도록 한다
					if(RowData[6] == "${ssnSabun}" && RowData[0] == '1'){
						if( RowData[2] == "30") {
	 						sheet4.SetRowEditable(Row, 0);
	 					}
					}
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
// 			sheet5.DoSearch( "${ctx}/AppPathReg.do?cmd=getAppPathRegReferList", $("#sheetForm").serialize()); break;
			var Row 	= "";
			var RowData = null;

			if(referStr == "") break;
			for(var i=0; i<referList.length; i++){
				RowData = referList[i].split(deli);
				Row 	= sheet5.DataInsert(sheet5.LastRow()+1);
				if(typeof RowData[3] != "undefined" && RowData[3] != "") {
					sheet5.SetCellValue(Row,"name", 		RowData[2]);
					sheet5.SetCellValue(Row,"ccSabun",		RowData[3]);
					sheet5.SetCellValue(Row,"jikchakNm",	RowData[7]);
					sheet5.SetCellValue(Row,"jikchakCd",	RowData[6]);
					sheet5.SetCellValue(Row,"jikweeNm",		RowData[5]);
					sheet5.SetCellValue(Row,"jikweeCd",		RowData[4]);
					sheet5.SetCellValue(Row,"orgNm",		RowData[0]);
					sheet5.SetCellValue(Row,"orgCd",		RowData[1]);
					sheet5.SetCellValue(Row,"empAlias",		RowData[8]);
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

    function doAction6(sAction) {
		switch (sAction) {
		case "Search":
			var Row 	= "";
			var RowData = null;
			//결재순서역순처리 2022.03.14
			//for(var i = 0; i < inApplList.length; i++){
			for(var i=inApplList.length - 1; i>=0 ; i--){				
			
				RowData = inApplList[i].split(deli);
				if(typeof RowData[6] != "undefined" && RowData[6] != "") {
					Row 	= sheet6.DataInsert(sheet6.LastRow()+1);
					sheet6.SetCellValue(Row,"agreeSeq", 	i+1);
					sheet6.SetCellValue(Row,"name", 		RowData[5]);
					sheet6.SetCellValue(Row,"empAlias",		RowData[11]);
					sheet6.SetCellValue(Row,"agreeSabun",	RowData[6]);
					sheet6.SetCellValue(Row,"jikchakNm",	RowData[10]);
					sheet6.SetCellValue(Row,"jikchakCd",	RowData[9]);
					sheet6.SetCellValue(Row,"jikweeNm",		RowData[8]);
					sheet6.SetCellValue(Row,"jikweeCd",		RowData[7]);
					sheet6.SetCellValue(Row,"applTypeCd",	RowData[2]);
					sheet6.SetCellValue(Row,"orgNm",		RowData[3]);
					sheet6.SetCellValue(Row,"orgCd",		RowData[4]);
				}
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

	function sheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg);
		} catch (ex) { alert("OnSaveEnd Event Error : " + ex); }
	}
	function sheet5_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg);
		} catch (ex) { alert("OnSaveEnd Event Error : " + ex); }
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			var Row = 1;
			if(orgCd != null && orgCd != "") {
				for( var i = 1; i < sheet2.RowCount()+1; i++) {
					if(orgCd == sheet2.GetCellValue(i, "orgCd")) {
						sheet2.SelectCell(i,"sNo");
						Row = i;
						break;
					}
				}
			}

			$("#orgCd").val(sheet2.GetCellValue(Row,"orgCd"));
			$("#name").val("");
			$("#orgNm").val("");

			doAction3("Search");

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
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
		if(chkRow == ""){ alert("<msg:txt mid='109886' mdef='결재자를 선택 하세요!'/>"); return; }
		var chkArry = chkRow.split("|");
		var chkdupTxt = null;
		var dupText  = "";
		var cnt = 1;
		for(var i=0; i<chkArry.length; i++){
			chkdupTxt = sheet4.FindText("agreeSabun",sheet3.GetCellValue(chkArry[i],"sabun"));
			if(chkdupTxt == -1){
				//결재순서역순처리 2022.03.14
				//var Row = sheet4.DataInsert(sheet4.LastRow()+1); sheet4.SelectCell(Row, 2);
				var Row = sheet4.DataInsert(0); sheet4.SelectCell(Row, 2);
				sheet4.SetCellValue(Row,"name",			sheet3.GetCellValue(chkArry[i],"name") );
				sheet4.SetCellValue(Row,"empAlias",		sheet3.GetCellValue(chkArry[i],"empAlias") );
				sheet4.SetCellValue(Row,"agreeSabun",	sheet3.GetCellValue(chkArry[i],"sabun") );
				sheet4.SetCellValue(Row,"orgNm",		sheet3.GetCellValue(chkArry[i],"orgNm") );
				sheet4.SetCellValue(Row,"orgCd",		sheet3.GetCellValue(chkArry[i],"orgCd") );
				sheet4.SetCellValue(Row,"jikchakNm",	sheet3.GetCellValue(chkArry[i],"jikchakNm") );
				sheet4.SetCellValue(Row,"jikweeNm",		sheet3.GetCellValue(chkArry[i],"jikweeNm") );
				sheet4.SetCellValue(Row,"jikchakCd",	sheet3.GetCellValue(chkArry[i],"jikchakCd") );
				sheet4.SetCellValue(Row,"jikweeCd",		sheet3.GetCellValue(chkArry[i],"jikweeCd") );
				sheet4.SetCellValue(Row,"pathSeq",pathSeq );
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
				//결재순서역순처리 2022.03.14
				//var Row = sheet5.DataInsert(sheet5.LastRow()+1); sheet5.SelectCell(Row, 2);
				var Row = sheet5.DataInsert(0); sheet5.SelectCell(Row, 2);
				sheet5.SetCellValue(Row,"name",		sheet3.GetCellValue(chkArry[i],"name") );
				sheet5.SetCellValue(Row,"empAlias",	sheet3.GetCellValue(chkArry[i],"empAlias") );
				sheet5.SetCellValue(Row,"ccSabun",	sheet3.GetCellValue(chkArry[i],"sabun") );
				sheet5.SetCellValue(Row,"orgCd",	sheet3.GetCellValue(chkArry[i],"orgCd") );
				sheet5.SetCellValue(Row,"orgNm",	sheet3.GetCellValue(chkArry[i],"orgNm") );
				sheet5.SetCellValue(Row,"jikchakNm",sheet3.GetCellValue(chkArry[i],"jikchakNm") );
				sheet5.SetCellValue(Row,"jikweeNm",	sheet3.GetCellValue(chkArry[i],"jikweeNm") );
				sheet5.SetCellValue(Row,"jikchakCd",sheet3.GetCellValue(chkArry[i],"jikchakCd") );
				sheet5.SetCellValue(Row,"jikweeCd",	sheet3.GetCellValue(chkArry[i],"jikweeCd") );
				sheet5.SetCellValue(Row,"pathSeq",	pathSeq );
			}else{
				dupText+= cnt+"."+sheet3.GetCellValue(chkArry[i],"sabun")+"\n";
				cnt++;
			}
		}
// 		if(dupText != "") alert("중복된 사번 제외 복사\n"+dupText);
		if(dupText != "") alert("<msg:txt mid='alertExistsEmpIdV1' mdef='중복된 사번이 존재 합니다.'/>");
		sheet3.CheckAll("chkbox", 0);
	}

	function mvInAppl(){
		var chkRow = sheet3.FindCheckedRow("chkbox");
		if(chkRow == ""){ alert("<msg:txt mid='110030' mdef='담당자를 선택 하세요!'/>");return; }
		var chkArry = chkRow.split("|");
		var chkdupTxt = null;
		var dupText  = "";
		var cnt = 1;
		for(var i=0; i<chkArry.length; i++){
			chkdupTxt = sheet6.FindText("agreeSabun",sheet3.GetCellValue(chkArry[i],"sabun"));
			if(chkdupTxt == -1){
				//결재순서역순처리 2022.03.14
				//var Row = sheet6.DataInsert(sheet6.LastRow()+1); sheet6.SelectCell(Row, 2);
				var Row = sheet6.DataInsert(0); sheet6.SelectCell(Row, 2);
				sheet6.SetCellValue(Row,"name",sheet3.GetCellValue(chkArry[i],"name") );
				sheet6.SetCellValue(Row,"empAlias",sheet3.GetCellValue(chkArry[i],"empAlias") );
				sheet6.SetCellValue(Row,"agreeSabun",	sheet3.GetCellValue(chkArry[i],"sabun") );
				sheet6.SetCellValue(Row,"orgNm",		sheet3.GetCellValue(chkArry[i],"orgNm") );
				sheet6.SetCellValue(Row,"orgCd",		sheet3.GetCellValue(chkArry[i],"orgCd") );
				sheet6.SetCellValue(Row,"jikchakNm",	sheet3.GetCellValue(chkArry[i],"jikchakNm") );
				sheet6.SetCellValue(Row,"jikweeNm",		sheet3.GetCellValue(chkArry[i],"jikweeNm") );
				sheet6.SetCellValue(Row,"jikchakCd",	sheet3.GetCellValue(chkArry[i],"jikchakCd") );
				sheet6.SetCellValue(Row,"jikweeCd",		sheet3.GetCellValue(chkArry[i],"jikweeCd") );
				sheet6.SetCellValue(Row,"pathSeq",		pathSeq );
				//결재순서역순처리 2022.03.14
				if(Row == sheet6.LastRow()) {
					sheet6.SetCellValue(Row,"applTypeCd",	'40' );
				} else {
					sheet6.SetCellValue(Row,"applTypeCd",	'10' );
				}
			}else{
				dupText+= cnt+"."+sheet3.GetCellValue(chkArry[i],"sabun")+"\n";
				cnt++;
			}
		}
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
			
		//결재순서역순처리 2022.03.14
		/*for(var i=1; i<sheet4.LastRow()+1; i++){
			sheet4.SetCellValue(i,"agreeSeq",i);
		}*/
		for(var i=1; i<sheet4.LastRow()+1; i++){
			sheet4.SetCellValue(i,"agreeSeq",sheet4.LastRow() +1 - i);
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
		//alert(oRow+"_"+lRow+""+nRow);
		if( f == "Up"	&& nRow == "0") return;
		else if(	f == "Down"	&& lRow < nRow) return;

		var oSdelete	= sheet4.GetCellValue(oRow, "sDelete");
		var oSstatus	= sheet4.GetCellValue(oRow, "sStatus");
		var oName		= sheet4.GetCellValue(oRow, "name");
		var oEmpAlias	= sheet4.GetCellValue(oRow, "empAlias");
		var oAgreeSabun	= sheet4.GetCellValue(oRow, "agreeSabun");
		var oJikchakCd	= sheet4.GetCellValue(oRow, "jikchakCd");
		var oJikchakNm	= sheet4.GetCellValue(oRow, "jikchakNm");
		var oJikweeCd	= sheet4.GetCellValue(oRow, "jikweeCd");
		var oJikweeNm	= sheet4.GetCellValue(oRow, "jikweeNm");
		var oOrgCd		= sheet4.GetCellValue(oRow, "orgCd");
		var oOrgNm		= sheet4.GetCellValue(oRow, "orgNm");
		var oApplTypeCd	= sheet4.GetCellValue(oRow, "applTypeCd");
		var oPathSeq	= sheet4.GetCellValue(oRow, "pathSeq");
		
		if(oApplTypeCd == "30" || sheet4.GetCellValue(nRow, "applTypeCd") == "30") {return alert("<msg:txt mid='109731' mdef='기안자는 이동 할수 없습니다!'/>");}
		//if(oApplTypeCd == "접수" || sheet4.GetCellValue(nRow, "applTypeCd") == "접수") {return alert("<msg:txt mid='109573' mdef='접수자는 이동 할수 없습니다!'/>");}

		sheet4.SetCellValue(oRow, "sDelete", 	sheet4.GetCellValue(nRow, "sDelete"));
		sheet4.SetCellValue(oRow, "sStatus", 	sheet4.GetCellValue(nRow, "sStatus"));
		sheet4.SetCellValue(oRow, "name", 		sheet4.GetCellValue(nRow, "name"));
		sheet4.SetCellValue(oRow, "empAlias", 	sheet4.GetCellValue(nRow, "empAlias"));
		sheet4.SetCellValue(oRow, "agreeSabun", sheet4.GetCellValue(nRow, "agreeSabun"));
		sheet4.SetCellValue(oRow, "jikchakCd", 	sheet4.GetCellValue(nRow, "jikchakCd"));
		sheet4.SetCellValue(oRow, "jikchakNm", 	sheet4.GetCellValue(nRow, "jikchakNm"));
		sheet4.SetCellValue(oRow, "jikweeCd", 	sheet4.GetCellValue(nRow, "jikweeCd"));
		sheet4.SetCellValue(oRow, "jikweeNm", 	sheet4.GetCellValue(nRow, "jikweeNm"));
		sheet4.SetCellValue(oRow, "orgCd", 		sheet4.GetCellValue(nRow, "orgCd"));
		sheet4.SetCellValue(oRow, "orgNm", 		sheet4.GetCellValue(nRow, "orgNm"));
		sheet4.SetCellValue(oRow, "applTypeCd", sheet4.GetCellValue(nRow, "applTypeCd"));
		sheet4.SetCellValue(oRow, "pathSeq", 	sheet4.GetCellValue(nRow, "pathSeq"));

		sheet4.SetCellValue(nRow, "sDelete", 	oSdelete);
		sheet4.SetCellValue(nRow, "sStatus", 	oSstatus);
		sheet4.SetCellValue(nRow, "name", 		oName);
		sheet4.SetCellValue(nRow, "empAlias", 	oEmpAlias);
		sheet4.SetCellValue(nRow, "agreeSabun", oAgreeSabun);
		sheet4.SetCellValue(nRow, "jikchakCd", 	oJikchakCd);
		sheet4.SetCellValue(nRow, "jikchakNm", 	oJikchakNm);
		sheet4.SetCellValue(nRow, "jikweeCd", 	oJikweeCd);
		sheet4.SetCellValue(nRow, "jikweeNm", 	oJikweeNm);
		sheet4.SetCellValue(nRow, "orgCd", 		oOrgCd);
		sheet4.SetCellValue(nRow, "orgNm", 		oOrgNm);
		sheet4.SetCellValue(nRow, "applTypeCd", oApplTypeCd);
		sheet4.SetCellValue(nRow, "pathSeq", 	oPathSeq);
		makeNo();
		sheet4.SelectCell(nRow,1);
	}

	function sheet6RowSwap(f){
		var lRow = sheet6.LastRow();
		var oRow = sheet6.GetSelectRow();

		var nRow = null;

		if( f == "Up") nRow = oRow -1;
		else nRow = oRow +1;

		if( f == "Up"	&& nRow == "0") return;
		else if(	f == "Down"	&& lRow < nRow) return;

		var oSdelete	= sheet6.GetCellValue(oRow, "sDelete");
		var oSstatus	= sheet6.GetCellValue(oRow, "sStatus");
		var oName		= sheet6.GetCellValue(oRow, "name");
		var oEmpAlias	= sheet6.GetCellValue(oRow, "empAlias");
		var oAgreeSabun	= sheet6.GetCellValue(oRow, "agreeSabun");
		var oJikchakCd	= sheet6.GetCellValue(oRow, "jikchakCd");
		var oJikchakNm	= sheet6.GetCellValue(oRow, "jikchakNm");
		var oJikweeCd	= sheet6.GetCellValue(oRow, "jikweeCd");
		var oJikweeNm	= sheet6.GetCellValue(oRow, "jikweeNm");
		var oOrgCd		= sheet6.GetCellValue(oRow, "orgCd");
		var oOrgNm		= sheet6.GetCellValue(oRow, "orgNm");
		var oApplTypeCd	= sheet6.GetCellValue(oRow, "applTypeCd");
		var oPathSeq	= sheet6.GetCellValue(oRow, "pathSeq");

		sheet6.SetCellValue(oRow, "sDelete", 	sheet6.GetCellValue(nRow, "sDelete"));
		sheet6.SetCellValue(oRow, "sStatus", 	sheet6.GetCellValue(nRow, "sStatus"));
		sheet6.SetCellValue(oRow, "name", 		sheet6.GetCellValue(nRow, "name"));
		sheet6.SetCellValue(oRow, "empAlias", 	sheet6.GetCellValue(nRow, "empAlias"));
		sheet6.SetCellValue(oRow, "agreeSabun", sheet6.GetCellValue(nRow, "agreeSabun"));
		sheet6.SetCellValue(oRow, "jikchakCd", 	sheet6.GetCellValue(nRow, "jikchakCd"));
		sheet6.SetCellValue(oRow, "jikchakNm", 	sheet6.GetCellValue(nRow, "jikchakNm"));
		sheet6.SetCellValue(oRow, "jikweeCd", 	sheet6.GetCellValue(nRow, "jikweeCd"));
		sheet6.SetCellValue(oRow, "jikweeNm", 	sheet6.GetCellValue(nRow, "jikweeNm"));
		sheet6.SetCellValue(oRow, "orgCd", 		sheet6.GetCellValue(nRow, "orgCd"));
		sheet6.SetCellValue(oRow, "orgNm", 		sheet6.GetCellValue(nRow, "orgNm"));
		sheet6.SetCellValue(oRow, "applTypeCd", sheet6.GetCellValue(nRow, "applTypeCd"));
		sheet6.SetCellValue(oRow, "pathSeq", 	sheet6.GetCellValue(nRow, "pathSeq"));

		sheet6.SetCellValue(nRow, "sDelete", 	oSdelete);
		sheet6.SetCellValue(nRow, "sStatus", 	oSstatus);
		sheet6.SetCellValue(nRow, "name", 		oName);
		sheet6.SetCellValue(nRow, "empAlias", 	oEmpAlias);
		sheet6.SetCellValue(nRow, "agreeSabun", oAgreeSabun);
		sheet6.SetCellValue(nRow, "jikchakCd", 	oJikchakCd);
		sheet6.SetCellValue(nRow, "jikchakNm", 	oJikchakNm);
		sheet6.SetCellValue(nRow, "jikweeCd", 	oJikweeCd);
		sheet6.SetCellValue(nRow, "jikweeNm", 	oJikweeNm);
		sheet6.SetCellValue(nRow, "orgCd", 		oOrgCd);
		sheet6.SetCellValue(nRow, "orgNm", 		oOrgNm);
		sheet6.SetCellValue(nRow, "applTypeCd", oApplTypeCd);
		sheet6.SetCellValue(nRow, "pathSeq", 	oPathSeq);
		sheet6.SelectCell(nRow,1);
	}

	function returnChgList(){
		var agreeUserStr = "";
		for(var i=1; i<sheet4.LastRow()+1;i++){
			agreeUserStr+=sheet4.GetCellValue(i,"agreeSabun")+deli;
		}
		$("#agreeSabun").val(agreeUserStr.substring(0, agreeUserStr.length-1));
		var debutyUserList = null;//ajaxCall("${ctx}/ApprovalMgr.do?cmd=getApprovalMgrDeputyUserChgList",$("#sheetForm").serialize(),false).DATA;
		if(da.chApplPopupRetrunPrc(sheet4,sheet5,sheet6,debutyUserList,applCdList)){
			//alert("TRUE");
		}
		p.window.close();
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
				<input id="pathSeq" 	name="pathSeq" 		type="hidden" />
				<input id="orgCd" 		name="orgCd" 		type="hidden" />
				<input id="sabun" 		name="sabun" 		type="hidden" />
				<input id="agreeSabun" 	name="agreeSabun"	type="hidden" />
				<div>
				<table>
				<tr>
					<th><tit:txt mid='103880' mdef='성명'/></th>
					<td>
						<input id="name" name="name" type="text" class="text" disabled/>
					</td>
					<th><tit:txt mid='104279' mdef='소속'/></th>
					<td>
						<input id="orgNm" name="orgNm" type="text" class="text" disabled/>
					</td>
					<td>
						<input id="radio" name="radio" type="radio" class="radio" value="Y" /> 리스트
						<input id="radio" name="radio" type="radio" class="radio" value="N" checked/> 조직도
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
				<script type="text/javascript"> createIBSheet("sheet2", "30%", "100%", "${ssnLocaleCd}"); </script>
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
				<script type="text/javascript"> createIBSheet("sheet3", "30%", "100%", "${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_arrow"></td>
			<td class="sheet_right w40p">
				<div class="sheet_button2">
					<div class="arrow_button">
						<btn:a href="javascript:mvAppl();" css="pink" mid='111114' mdef="결재&gt;"/>
					</div>

					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='schAppLine' mdef='결재선 내역'/></li>
							<li class="btn">
								<btn:a href="javascript:sheet4RowSwap('Up');" css="basic" mid='110755' mdef="위"/>
								<btn:a href="javascript:sheet4RowSwap('Down');" css="basic" mid='111045' mdef="아래"/>
<!-- 								<btn:a href="javascript:doAction4('Save');" css="basic" mid='110708' mdef="저장"/> -->
	<!-- 							<a href="javascript:delMakeNo();" class="basic"><tit:txt mid='113548' mdef='체크로우'/></a> -->
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet4", "40%", "33%", "${ssnLocaleCd}"); </script>
				</div>

				<div class="sheet_button2">
					<div class="arrow_button outer">
						<btn:a href="javascript:mvInAppl();" css="pink" mid='110915' mdef="담당&gt;"/>
					</div>

					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='112478' mdef='담당 내역'/></li>
							<li class="btn">
								<btn:a href="javascript:sheet6RowSwap('Up');" css="basic" mid='110755' mdef="위"/>
								<a href="javascript:sheet6RowSwap('Down');" class="basic"><tit:txt mid='112141' mdef='아래'/></a>
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet6", "40%", "33%", "${ssnLocaleCd}"); </script>
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
<!-- 								<a href="javascript:doAction5('Save');" class="basic"><tit:txt mid='104476' mdef='저장'/></a> -->
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet5", "40%", "30%", "${ssnLocaleCd}"); </script>
				</div>

			</td>
		</tr>
		</table>
		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:returnChgList();" css="pink large" mid='110729' mdef="적용"/>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
