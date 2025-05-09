<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var openSheet 	= null;
	var openRow 	= null;
	var selectSheet = null;
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var arg = p.popDialogArgumentAll();

		if( arg != undefined ) {
			openSheet 	= p.popDialogSheet(arg["openSheet"]);
		}

		//openSheet = dialogArguments["openSheet"];
		openRow = openSheet.GetSelectRow();
		srchSeq = openSheet.GetCellValue( openRow, "searchSeq" ) ;
		$("#srchSeq").val(srchSeq);
		$("#viewCd").val(openSheet.GetCellValue( openRow, "viewCd" ) 		);
		$("#viewNm").val(openSheet.GetCellValue( openRow, "viewNm" ) 		);
		$("#viewDesc").val(openSheet.GetCellValue( openRow, "viewDesc" ) 	);
		$("#srchDesc").val(openSheet.GetCellValue( openRow, "searchDesc" ) 	);

		var inqTypeCd 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20020"), "<tit:txt mid='103895' mdef='전체'/>",-1);
		var valueTypeCd	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20030"), "<tit:txt mid='103895' mdef='전체'/>",-1);
		var operTypeCd 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S50020"), "<tit:txt mid='103895' mdef='전체'/>",-1);

		var initdata = {};
////////////////////////////// 조건업무Viwe
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:"${dataReadCnt}", FrozenCol:0, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),  	Width:"${sNoWdt}",	Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",			Type:"Text",     	Hidden:0,  			Width:170,   		Align:"Left", 	ColMerge:0,   SaveName:"columnNm",      KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='check' mdef='선택'/>",			Type:"CheckBox",   	Hidden:0,  			Width:50,    		Align:"Center",	ColMerge:0,   SaveName:"sCheck",    	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='valueType' mdef='조건입력방법'/>",	Type:"Text",      	Hidden:1,  			Width:0,  			Align:"Center",	ColMerge:0,   SaveName:"valueType",    	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",		Type:"Text",      	Hidden:1,  			Width:0,  			Align:"Center",	ColMerge:0,   SaveName:"searchItemCd",	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='elementNmV6' mdef='항목'/>",			Type:"Text",      	Hidden:1,  			Width:0,			Align:"Center",	ColMerge:0,   SaveName:"searchItemNm",  KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='itemMapType' mdef='항목맵핑구분'/>",	Type:"Text",     	Hidden:1,  			Width:0,  			Align:"Center",	ColMerge:0,   SaveName:"itemMapType", 	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='prgUrl' mdef='프로그램URL'/>", 	Type:"Text",      	Hidden:1,  			Width:0,  			Align:"Center",	ColMerge:0,   SaveName:"prgUrl",       	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='sqlSyntax' mdef='SQL문'/>", 		Type:"Text",  		Hidden:1,  			Width:0,  			Align:"Center",	ColMerge:0,   SaveName:"sqlSyntax",   	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50 }
		];IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}"); sheet1.SetVisible(true);//초기화
///////////////////////////// 조건항목 설정 자료
		var inqTypeCmbList 	= convCode( codeList("<c:url value='/CommonCode.do?cmd=getCommonCodeList'/>","R20020"), "");
		initdata.Cfg = {SearchMode:smLazyLoad,Page:"${dataReadCnt}"};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), 	Width:"${sNoWdt}",  Align:"Center",	ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:0,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",   Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",	Type:"Text",    	Hidden:1,	Width:0,   			Align:"Left",  	ColMerge:0,   SaveName:"searchSeq", 	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",		Type:"Text",    	Hidden:0,	Width:130,  		Align:"Left", 	ColMerge:0,   SaveName:"columnNm",    	KeyField:0,   CalcLogic:"",   Format:"", 			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",		Type:"Float",    	Hidden:0, 	Width:50,   		Align:"Center",	ColMerge:0,   SaveName:"seq",       	KeyField:0,   CalcLogic:"",   Format:"NullFloat", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='orderBySeq' mdef='정렬순서'/>",	Type:"Float",    	Hidden:0, 	Width:50,			Align:"Center",	ColMerge:0,   SaveName:"orderBySeq",  	KeyField:0,   CalcLogic:"",   Format:"NullFloat",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='ascDesc' mdef='정렬구분'/>",	Type:"Combo",    	Hidden:0, 	Width:80,			Align:"Center",	ColMerge:0,   SaveName:"ascDesc",  		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='inqType' mdef='조회형태'/>",	Type:"Combo",    	Hidden:0, 	Width:100,			Align:"Center",	ColMerge:0,   SaveName:"inqType",  		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='mergeYn' mdef='병합여부'/>",	Type:"Combo",    	Hidden:0, 	Width:70,			Align:"Center",	ColMerge:0,   SaveName:"mergeYn",  		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 }
		];IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}"); sheet2.SetVisible(true);
		sheet2.SetColProperty("ascDesc", 	{ComboText:"|"+"올림차순|내림차순", 	ComboCode:"|ASC|DESC"} );
		sheet2.SetColProperty("inqType", 	{ComboText:inqTypeCd[0], 			ComboCode:inqTypeCd[1]} );
		sheet2.SetColProperty("mergeYn", 	{ComboText:"|N|Y", 	ComboCode:"|N|Y"} );
///////////////////////////// 고정 조건항목 설정 자료
		var operTypeCmbList 	= convCode( codeList("<c:url value='/CommonCode.do?cmd=getCommonCodeList'/>","S50020"), "");
		var valueTypeCmbList 	= convCode( codeList("<c:url value='/CommonCode.do?cmd=getCommonCodeList'/>","R20030"), "");
		initdata.Cfg = {SearchMode:smLazyLoad,Page:"${dataReadCnt}"};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), 	Width:"${sNoWdt}",  Align:"Center",	ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='resultV2' mdef='결과'/>",			Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),	Width:"${sRstWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sResult" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",   Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",		Type:"Text",    	Hidden:1,   		Width:0,   			Align:"Left",  	ColMerge:0,   SaveName:"searchSeq", 	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",			Type:"Text",    	Hidden:0,   		Width:80,  			Align:"Left", 	ColMerge:0,   SaveName:"columnNm",    	KeyField:0,   CalcLogic:"",   Format:"", 			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='itemMapType' mdef='항목맵핑구분'/>",	Type:"Text",    	Hidden:1,   		Width:0,   			Align:"Left",	ColMerge:0,   SaveName:"itemMapType",	KeyField:0,   CalcLogic:"",   Format:"", 			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='prgUrl' mdef='프로그램URL'/>",	Type:"Text",    	Hidden:1,   		Width:0,			Align:"Left",	ColMerge:0,   SaveName:"prgUrl",  		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='sqlSyntax' mdef='SQL문'/>",			Type:"Text",    	Hidden:1,   		Width:0,			Align:"Left",	ColMerge:0,   SaveName:"sqlSyntax",  	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='operator' mdef='연산자'/>",			Type:"Combo",    	Hidden:0,   		Width:40,			Align:"Center",	ColMerge:0,   SaveName:"operator",  	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='valueType' mdef='조건입력방법'/>",	Type:"Combo",    	Hidden:0,   		Width:100,			Align:"Center",	ColMerge:0,   SaveName:"valueType",  	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='searchItemCdV1' mdef='코드항목CD'/>",		Type:"Text",    	Hidden:1,   		Width:0,			Align:"Left",	ColMerge:0,   SaveName:"searchItemCd",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='searchItemNmV1' mdef='코드선택'/>",		Type:"Popup",    	Hidden:0,   		Width:80,			Align:"Left",	ColMerge:0,   SaveName:"searchItemNm",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='inputValue' mdef='조건값'/>",			Type:"Text",    	Hidden:1,   		Width:0,			Align:"Left",	ColMerge:0,   SaveName:"inputValue", 	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"<sht:txt mid='inputValue' mdef='조건값'/>",			Type:"Popup",    	Hidden:0,   		Width:120,			Align:"Left",	ColMerge:0,   SaveName:"inputValueDesc",KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4000 },
			{Header:"ANDn/OR",		Type:"Combo",    	Hidden:0,   		Width:50,			Align:"Center",	ColMerge:0,   SaveName:"andOr",  		KeyField:0,   CalcLogic:"",   Format:"NullFloat",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Float",    	Hidden:0,   		Width:30,			Align:"Center",	ColMerge:0,   SaveName:"seq",  			KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='condType' mdef='조건항목구분'/>",	Type:"Text",		Hidden:1,			Width:0,			Align:"Left",	ColMerge:0,   SaveName:"condType", 		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 }
		];IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}"); sheet3.SetVisible(true);
		sheet3.SetColProperty("andOr", 		{ComboText:"AND|OR", 			ComboCode:"AND|OR"} );
		sheet3.SetColProperty("operator", 	{ComboText:operTypeCd[0],	ComboCode:operTypeCd[1]} );
		sheet3.SetColProperty("valueType", 	{ComboText:"|"+valueTypeCd[0], 	ComboCode:"|"+valueTypeCd[1]} );
///////////////////////////// 사용자입력 조건항목설정 자료
		var operTypeCmbList 	= convCode( codeList("<c:url value='/CommonCode.do?cmd=getCommonCodeList'/>","S50020"), "");
		var valueTypeCmbList 	= convCode( codeList("<c:url value='/CommonCode.do?cmd=getCommonCodeList'/>","R20030"), "");
		initdata.Cfg = {SearchMode:smLazyLoad,Page:"${dataReadCnt}"};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), 	Width:"${sNoWdt}",  Align:"Center",	ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='resultV2' mdef='결과'/>",			Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),	Width:"${sRstWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sResult" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",   Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",		Type:"Text",    	Hidden:1,   		Width:0,   			Align:"Left",  	ColMerge:0,   SaveName:"searchSeq", 	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",			Type:"Text",    	Hidden:0,   		Width:80,  			Align:"Left", 	ColMerge:0,   SaveName:"columnNm",    	KeyField:0,   CalcLogic:"",   Format:"", 			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='itemMapType' mdef='항목맵핑구분'/>",	Type:"Text",    	Hidden:1,   		Width:0,   			Align:"Left",	ColMerge:0,   SaveName:"itemMapType",	KeyField:0,   CalcLogic:"",   Format:"", 			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='prgUrl' mdef='프로그램URL'/>",	Type:"Text",    	Hidden:1,   		Width:0,			Align:"Left",	ColMerge:0,   SaveName:"prgUrl",  		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='sqlSyntax' mdef='SQL문'/>",			Type:"Text",    	Hidden:1,   		Width:0,			Align:"Left",	ColMerge:0,   SaveName:"sqlSyntax",  	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='operator' mdef='연산자'/>",			Type:"Combo",    	Hidden:0,   		Width:50,			Align:"Center",	ColMerge:0,   SaveName:"operator",  	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='valueType' mdef='조건입력방법'/>",	Type:"Combo",    	Hidden:0,   		Width:100,			Align:"Center",	ColMerge:0,   SaveName:"valueType",  	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='searchItemCdV1' mdef='코드항목CD'/>",		Type:"Text",    	Hidden:1,   		Width:0,			Align:"Left",	ColMerge:0,   SaveName:"searchItemCd",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='searchItemNmV1' mdef='코드선택'/>",		Type:"Popup",    	Hidden:0,   		Width:80,			Align:"Left",	ColMerge:0,   SaveName:"searchItemNm",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='inputValue' mdef='조건값'/>",			Type:"Text",    	Hidden:1,   		Width:0,			Align:"Left",	ColMerge:0,   SaveName:"inputValue", 	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"<sht:txt mid='inputValue' mdef='조건값'/>",			Type:"Popup",    	Hidden:0,   		Width:120,			Align:"Left",	ColMerge:0,   SaveName:"inputValueDesc",KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4000 },
			{Header:"ANDn/OR",		Type:"Combo",    	Hidden:0,   		Width:50,			Align:"Center",	ColMerge:0,   SaveName:"andOr",  		KeyField:0,   CalcLogic:"",   Format:"NullFloat",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Float",    	Hidden:0,   		Width:30,			Align:"Center",	ColMerge:0,   SaveName:"seq",  			KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='condType' mdef='조건항목구분'/>",	Type:"Text",		Hidden:1,			Width:0,			Align:"Left",	ColMerge:0,   SaveName:"condType", 		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 }
		];IBS_InitSheet(sheet4, initdata);sheet4.SetEditable("${editable}"); sheet4.SetVisible(true);
		sheet4.SetColProperty("andOr", 		{ComboText:"AND|OR", 			ComboCode:"AND|OR"} );
		sheet4.SetColProperty("operator", 	{ComboText:operTypeCd[0],	ComboCode:operTypeCd[1]} );
		sheet4.SetColProperty("valueType", 	{ComboText:"|"+valueTypeCd[0], 	ComboCode:"|"+valueTypeCd[1]} );
///////////////////////////// 조건항목 설정 자료
		var inqTypeCmbList 	= convCode( codeList("<c:url value='/CommonCode.do?cmd=getCommonCodeList'/>","R20020"), "");
		initdata.Cfg = {SearchMode:smLazyLoad,Page:"${dataReadCnt}"};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",    Hidden:0, 	Width:"${sNoWdt}",  Align:"Center",	ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",   Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",	Type:"Text",    	Hidden:0,	Width:0,   			Align:"Left",  	ColMerge:0,   SaveName:"searchSeq", 	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='viewCdV1' mdef='뷰코드'/>",		Type:"Text",    	Hidden:0,	Width:0,  			Align:"Left", 	ColMerge:0,   SaveName:"viewCd",    	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
			{Header:"<sht:txt mid='adminSqlSyntax' mdef='Admin쿼리'/>",	Type:"Text",    	Hidden:0,	Width:0,   			Align:"Left",	ColMerge:0,   SaveName:"adminSqlSyntax",KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"<sht:txt mid='sqlSyntaxV1' mdef='쿼리'/>",		Type:"Text",    	Hidden:0,	Width:0,			Align:"Left",	ColMerge:0,   SaveName:"sqlSyntax",  	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:0,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sDelete" }
		];IBS_InitSheet(sheet5, initdata); sheet5.SetEditable("${editable}"); sheet5.SetVisible(true);

	    $(window).smartresize(sheetResize);

	    sheetInit();

	    $(".close").click(function() {
	    	p.self.close();
	    });
	    doAction1("Search");
	    doAction2("Search");
	    doAction3("Search");
	    doAction4("Search");
	});

	function doAction1(sAction) {
		switch (sAction) {
		case "Search":	sheet1.DoSearch( "${ctx}/PwrSrchBizPopup.do?cmd=getPwrSrchBizPopupViewElemList", $("#sheetForm").serialize() ); break;
		}
	}
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":	sheet2.DoSearch( "${ctx}/PwrSrchBizPopup.do?cmd=getPwrSrchBizPopupElemList", $("#sheetForm").serialize() ); break;
		case "Save":
			/*if(sheet2.FindStatusRow("I|U") == ""){
			    break;
			}*/
			IBS_SaveName(document.sheetForm,sheet2);
			sheet2.DoSave("${ctx}/PwrSrchBizPopup.do?cmd=savePwrSrchBizPopupElem", $("#sheetForm").serialize(), -1, 0);  break;
			//sheet5.doAction5("Save");

		}
	}
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
			$("#condTYpe").val("F");
			sheet3.DoSearch( "${ctx}/PwrSrchBizPopup.do?cmd=getPwrSrchBizPopupConditionList", $("#sheetForm").serialize() ); break;
		case "Save":
			if(sheet3.FindStatusRow("I|U") != ""){
			    if(!dupChk(sheet3,"columnNm", true, true)){break;}
			}
			IBS_SaveName(document.sheetForm,sheet3);
			sheet3.DoSave("${ctx}/PwrSrchBizPopup.do?cmd=savePwrSrchBizPopupCondition", $("#sheetForm").serialize(), -1, 0);
			//sheet5.doAction5("Save");

			break;
		}
	}
	function doAction4(sAction) {
		switch (sAction) {
		case "Search":
			$("#condTYpe").val("U");
			sheet4.DoSearch( "${ctx}/PwrSrchBizPopup.do?cmd=getPwrSrchBizPopupConditionList", $("#sheetForm").serialize() ); break;
		case "Save":
			if(sheet4.FindStatusRow("I|U") != ""){
			    if(!dupChk(sheet4,"columnNm", true, true)){break;}
			}
			IBS_SaveName(document.sheetForm,sheet4);
			sheet4.DoSave("${ctx}/PwrSrchBizPopup.do?cmd=savePwrSrchBizPopupCondition", $("#sheetForm").serialize(), -1, 0);
			doAction5("Save");

			break;
		}
	}
	function doAction5(sAction) {
		switch (sAction) {
		case "Save":
			//doAction2("Save");
			//doAction3("Save");
			//doAction4("Save");

			sheet5.RemoveAll();

// 			alert( makeQuery() ) ;
// 			return ;

			var Row = sheet5.DataInsert(0);
            sheet5.SetCellValue(Row, "searchSeq",$("#srchSeq").val());
            sheet5.SetCellValue(Row, "sqlSyntax",makeQuery());
            IBS_SaveName(document.sheetForm,sheet5);
            sheet5.DoSave("${ctx}/PwrSrchBizPopup.do?cmd=updatePwrSrchBizPopupSql", $("#sheetForm").serialize(), -1, 0);
            break;
		}
	}
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		 	for(i = 1 ; i <= sheet3.LastRow() ; i++){
		        if(sheet3.GetCellValue(i,"valueType") == "dfCode"){
		            sheet3.SetCellEditable(i,"searchItemNm",true);
		        }
		        checkIsNull(sheet3, i, "operator");
		    }
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		 	for(i = 1 ; i <= sheet4.LastRow() ; i++){
		        if(sheet4.GetCellValue(i,"valueType") == "dfCode"){
		            sheet4.SetCellEditable(i,"searchItemNm",true);
		        }
		        checkIsNull(sheet4, i, "operator");
		    }
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet5_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
	  	try{ selectSheet = sheet1;
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
	  	try{ selectSheet = sheet2;
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	function sheet3_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
	  	try{ selectSheet = sheet3;
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	function sheet4_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
	  	try{ selectSheet = sheet4;
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

 	function sheet3_OnChange(Row, Col, Value){
		try{
		    if(Row > 0 && sheet3.ColSaveName(Col) == "operator"){
		        sheet3.SetCellValue(Row, "inputValue",checkLike(sheet3,''));
		        sheet3.SetCellValue(Row, "inputValueDesc","");
		        checkIsNull(sheet3, Row, Col);
		    }else if(Row > 0 && sheet3.ColSaveName(Col) == "valueType"){
		        if(Value == "dfCode"){
		            sheet3.SetCellEditable(Row,"searchItemNm",true);
		        }else{
		            sheet3.SetCellEditable(Row,"searchItemNm",false);
		            sheet3.SetCellValue(Row,"searchItemCd","");
		            sheet3.SetCellValue(Row,"searchItemNm","");
		        }
		        if(Value == "dfCompany"){
		            sheet3.SetCellValue(Row, "inputValue",'@@회사@@');
		            sheet3.SetCellValue(Row, "inputValueDesc","해당 회사");
		            sheet3.SetCellEditable(Row,"searchItemNm",false);
		            sheet3.SetCellEditable(Row,"inputValue",false);
		            sheet3.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfSabun"){
		            sheet3.SetCellValue(Row, "inputValue",'@@담당자@@');
		            sheet3.SetCellValue(Row, "inputValueDesc","해당 담당자");
		            sheet3.SetCellEditable(Row,"searchItemNm",false);
		            sheet3.SetCellEditable(Row,"inputValue",false);
		            sheet3.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfBaseDate"){
		            sheet3.SetCellValue(Row, "inputValue",'@@적용일자@@');
		            sheet3.SetCellValue(Row, "inputValueDesc","적용일자");
		            sheet3.SetCellEditable(Row,"searchItemNm",false);
		            sheet3.SetCellEditable(Row,"inputValue",false);
		            sheet3.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfToday"){
		            sheet3.SetCellValue(Row, "inputValue",'@@조회일자@@');
		            sheet3.SetCellValue(Row, "inputValueDesc","조회일자");
		            sheet3.SetCellEditable(Row,"searchItemNm",false);
		            sheet3.SetCellEditable(Row,"inputValue",false);
		            sheet3.SetCellEditable(Row,"inputValueDesc",false);
		        }else{
		            sheet3.SetCellValue(Row, "inputValue",checkLike(sheet3,''));
		            sheet3.SetCellValue(Row, "inputValueDesc","");
		        }
		    }else if(Row > 0 && sheet3.ColSaveName(Col) == "searchItemCd"){
		        sheet3.SetCellValue(Row, "inputValue",checkLike(sheet3,''));
		        sheet3.SetCellValue(Row, "inputValueDesc","");
		    }
		    if(sheet3.GetCellText(Row, "operator").indexOf("NULL") != -1){
		        sheet3.SetCellValue(Row, "inputValue","");
		        sheet3.SetCellValue(Row, "inputValueDesc","");
		    }
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
 	function sheet4_OnChange(Row, Col, Value){
		try{
		    if(Row > 0 && sheet4.ColSaveName(Col) == "operator"){
		        sheet4.SetCellValue(Row, "inputValue",checkLike(sheet4,''));
		        sheet4.SetCellValue(Row, "inputValueDesc","");
		        checkIsNull(sheet4, Row, Col);
		    }else if(Row > 0 && sheet4.ColSaveName(Col) == "valueType"){
		        if(Value == "dfCode"){
		            sheet4.SetCellEditable(Row,"searchItemNm",true);
		        }else{
		            sheet4.SetCellEditable(Row,"searchItemNm",false);
		            sheet4.SetCellValue(Row,"searchItemCd","");
		            sheet4.SetCellValue(Row,"searchItemNm","");
		        }
		        if(Value == "dfCompany"){
		            sheet4.SetCellValue(Row, "inputValue",'@@회사@@');
		            sheet4.SetCellValue(Row, "inputValueDesc","해당 회사");
		            sheet4.SetCellEditable(Row,"searchItemNm",false);
		            sheet4.SetCellEditable(Row,"inputValue",false);
		            sheet4.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfSabun"){
		            sheet4.SetCellValue(Row, "inputValue",'@@담당자@@');
		            sheet4.SetCellValue(Row, "inputValueDesc","해당 담당자");
		            sheet4.SetCellEditable(Row,"searchItemNm",false);
		            sheet4.SetCellEditable(Row,"inputValue",false);
		            sheet4.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfBaseDate"){
		            sheet4.SetCellValue(Row, "inputValue",'@@적용일자@@');
		            sheet4.SetCellValue(Row, "inputValueDesc","적용일자");
		            sheet4.SetCellEditable(Row,"searchItemNm",false);
		            sheet4.SetCellEditable(Row,"inputValue",false);
		            sheet4.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfToday"){
		            sheet4.SetCellValue(Row, "inputValue",'@@조회일자@@');
		            sheet4.SetCellValue(Row, "inputValueDesc","조회일자");
		            sheet4.SetCellEditable(Row,"searchItemNm",false);
		            sheet4.SetCellEditable(Row,"inputValue",false);
		            sheet4.SetCellEditable(Row,"inputValueDesc",false);
		        }else{
		            sheet4.SetCellValue(Row, "inputValue",checkLike(sheet4,''));
		            sheet4.SetCellValue(Row, "inputValueDesc","");
		        }
		    }else if(Row > 0 && sheet4.ColSaveName(Col) == "searchItemCd"){
		        sheet4.SetCellValue(Row, "inputValue",checkLike(sheet4,''));
		        sheet4.SetCellValue(Row, "inputValueDesc","");
		    }
		    if(sheet4.GetCellText(Row, "operator").indexOf("NULL") != -1){
		        sheet4.SetCellValue(Row, "inputValue","");
		        sheet4.SetCellValue(Row, "inputValueDesc","");
		    }
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}

	function sheet3_OnPopupClick(Row, Col){
		try{
		    if(Row > 0 && sheet3.ColSaveName(Col) == "searchItemNm"){
		    	if(!isPopup()) {return;}

		    	var gPRow = Row;
		    	var pGubun = "pwrSrchElemPopup1";

		    	var url 	= "${ctx}/PwrSrchElemPopup.do?cmd=pwrSrchElemPopup";
				var args 	= new Array();
				openPopup(url,args,640,580);
		    }
		    if(Row > 0 && sheet3.ColSaveName(Col) == "inputValueDesc"){
		    	if(!isPopup()) {return;}

		    	var gPRow = Row;
		    	var pGubun = "pwrSrchInputValuePopup1";

		    	var args 	= new Array();
				args["sheet"] 	= "sheet3";
				var url	= "${ctx}/PwrSrchInputValuePopup.do?cmd=pwrSrchInputValuePopup&authPg=${authPg}&adminFlag=no";
				openPopup(url, args, "840","680");
		    }

		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	function sheet4_OnPopupClick(Row, Col){
		try{
			if(Row > 0 && sheet4.ColSaveName(Col) == "searchItemNm"){
				if(!isPopup()) {return;}

		    	gPRow = Row;
		    	pGubun = "pwrSrchElemPopup2";

				var url 	= "${ctx}/PwrSrchElemPopup.do?cmd=pwrSrchElemPopup";
				var args 	= new Array();
				openPopup(url,args,640,580);
		    }
		    if(Row > 0 && sheet4.ColSaveName(Col) == "inputValueDesc"){
		    	if(!isPopup()) {return;}

		    	gPRow = Row;
		    	pGubun = "pwrSrchInputValuePopup2";

		    	var args 	= new Array();
				args["sheet"] 	= "sheet4";
				var url	= "${ctx}/PwrSrchInputValuePopup.do?cmd=pwrSrchInputValuePopup&authPg=${authPg}&adminFlag=no";
				openPopup(url, args, "840","680");
		    }
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg);
			doAction2("Search");
		} catch (ex) { alert("OnSaveEnd Event Error "+ex); }
	}
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg);
			doAction3("Search");
		} catch (ex) { alert("OnSaveEnd Event Error "+ex); }
	}
	function sheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg);
			doAction4("Search");
		} catch (ex) { alert("OnSaveEnd Event Error "+ex); }
	}
	function sheet5_OnSaveEnd(Code, Msg, StCode, StMsg) {
		//try { if(Msg != "") alert(Msg);
		//} catch (ex) { alert("OnSaveEnd Event Error "+ex); }
	}

	function openResult(){
//        if(sheet2.FindStatusRow("I|S|D|U") != ""){
//            doAction3('Save');
//        }
		if(!isPopup()) {return;}

		doAction5("Save");
 		var url	= "${ctx}/PwrSrchResultPopup.do?cmd=pwrSrchResultPopup&authPg=${authPg}";
		openPopup(url, "", "940","580");
 	}

	function checkIsNull(sht, Row, Col){
        if( sht.GetCellText(Row, Col).toUpperCase() == "IS NULL"
         || sht.GetCellText(Row, Col).toUpperCase() == "IS NOT NULL"){
             sht.SetCellEditable(Row,"valueType",false);
             sht.SetCellEditable(Row,"inputValue",false);
            sht.SetCellEditable(Row,"searchItemNm",false);
            sht.SetCellEditable(Row,"inputValueType",false);
        }else{
            sht.SetCellEditable(Row,"valutType",true);
            sht.SetCellEditable(Row,"inputValue",true);
            sht.SetCellEditable(Row,"searchItemNm",true);
            sht.SetCellEditable(Row,"inputValueDesc",true);
        }
    }
	function check_Enter(){
        if (event.keyCode==13){
            doAction1("Search");
            doAction2("Search");
            doAction3("Search");
            doAction4("Search");
        }
    }

	function makeQuery(){
        sendQuery = "SELECT ";
        sendQuery = sendQuery + selectElement();
        sendQuery = sendQuery + "  FROM " + "__EXCHANGE__VIEW__NM__ VTBL,  __EXCHANGE__AHTHTABLE__ ATBL \n";
        sendQuery = sendQuery + conditionStatement();
        sendQuery = sendQuery + orderStatement(sheet2, doSortColumn(sheet2, "orderBySeq"));
        return sendQuery;
    }

    function selectElement(){
        var element = "";
        loop = sheet2.LastRow()+1;
        for(i = 1 ; i < loop ; i++){
            element = element + sheet2.GetCellValue(i, "columnNm") + ",";
        }
        element = element.substring(0, element.length-1)+"\n";
        return element;
    }

    function conditionStatement(){
        var condition = "";
        if(sheet3.RowCount() > 0){
            loop = sheet3.LastRow()+1;
            condition = " WHERE " + "VTBL." + sheet3.GetCellValue(1, "columnNm") + " " +sheet3.GetCellText(1, "operator")+" " + sheet3.GetCellValue(1, "inputValue")+ "\n";
            for(i = 2 ; i < loop ; i++){
                condition = condition + "   "+sheet3.GetCellValue(i, "andOr")+" " + "VTBL." + sheet3.GetCellValue(i, "columnNm") + " " +sheet3.GetCellText(i, "operator")+" " +sheet3.GetCellValue(i, "inputValue")+ "\n";
            }
        }
/*
        if(sheet4.RowCount() > 0){
            loop = sheet4.LastRow()+1;
            if(condition.length == 0){
                condition = condition + " WHERE " +"VTBL." + sheet4.GetCellText(1, "columnNm") + " " +sheet4.GetCellText(1, "operator")+" " +sheet4.GetCellText(1, "inputValue")+ "\n";
            }else{
                condition = condition + "   "+sheet4.GetCellValue(1, "andOr")+" " + "VTBL." + sheet4.GetCellText(1, "columnNm") + " " +sheet4.GetCellText(1, "operator")+" " +sheet4.GetCellText(1, "inputValue")+ "\n";
            }
            for(i = 2 ; i < loop ; i++){
                condition = condition + "   "+sheet4.GetCellValue(i, "andOr")+" " + "VTBL." + sheet4.GetCellText(i, "columnNm") + " " +sheet4.GetCellText(i, "operator")+" " +sheet4.GetCellText(i, "inputValue")+ "\n";
            }
        }
*/

        if(sheet4.RowCount() > 0){
            loop = sheet4.LastRow()+1;
            if(condition.length == 0){
                condition = condition + " WHERE " +"VTBL." + sheet4.GetCellText(1, "columnNm") + " " +sheet4.GetCellText(1, "operator")+" &&" +sheet4.GetCellText(1, "columnNm")+"&&"+ "\n";
            }else{
            condition = condition + "   "+sheet4.GetCellValue(1, "andOr")+" " + "VTBL." + sheet4.GetCellText(1, "columnNm") + " " +sheet4.GetCellText(1, "operator")+" &&"+sheet4.GetCellText(1, "columnNm")+"&&"+ "\n";
            }
            for(i = 2 ; i < loop ; i++){
                condition = condition + "   "+sheet4.GetCellValue(i, "andOr")+" " + "VTBL." + sheet4.GetCellText(i, "columnNm") + " " +sheet4.GetCellText(i, "operator")+" &&" +sheet4.GetCellText(i, "columnNm")+"&&"+ "\n";
            }
        }
        

        if(condition.length == 0){
                condition = condition+" WHERE " +"VTBL.ENTER_CD = ATBL.ENTER_CD \n";
                condition = condition+"   AND "  +"VTBL.SABUN = ATBL.SABUN";
                condition = condition+" AND "  +"TO_CHAR(SYSDATE, 'YYYYMMDD') BETWEEN ATBL.SDATE AND NVL(ATBL.EDATE,'99991231')";

        }else{
                condition = condition+" AND " +"VTBL.ENTER_CD = ATBL.ENTER_CD \n";
                condition = condition+" AND "  +"VTBL.SABUN = ATBL.SABUN";
                condition = condition+" AND "  +"TO_CHAR(SYSDATE, 'YYYYMMDD') BETWEEN ATBL.SDATE AND NVL(ATBL.EDATE,'99991231')";
        }
        return condition;
    }

    function orderStatement(sht, srcRow){
        var orderString = "\n ORDER BY ";
        for(i = 0 ; i < srcRow.length ; i++){

            orderString = orderString + "VTBL." + sht.GetCellValue(srcRow[i], "columnNm").toUpperCase() + " " +
                                        sht.GetCellValue(srcRow[i], "ascDesc").toUpperCase() + ", ";
        }
        return orderString.substring(0, orderString.lastIndexOf(","));
    }
    function checkLike(selectSheet,str){
        var selectRow = selectSheet.GetSelectRow();
        if(selectSheet.GetCellText(selectRow, "operator").toUpperCase() == "LIKE"
           || selectSheet.GetCellText(selectRow, "operator").toUpperCase() == "NOT LIKE" ){
            str = "'%"+str+"%'";
        }else{
            str = "'"+str+"'";
        }
        return str;
    }
    function doSortColumn(sht, column){
        var srcRow		= new Array();
        var srcOrdSeq	= new Array();
        var inputNumbers= new Array();
        var srcCnt		= 0;

        for (var i = 1; i <= sht.LastRow() ; i++) {
            colValue = sht.GetCellValue(i, column);
            if(colValue != ""){
                inputNumbers[i] = parseInt(colValue);
                if (isNaN(inputNumbers[i])) {
                    alert("정렬 칼럼중에 문자가 있습니다.n확인하세요.");
                    return "";
                }else{
                    srcRow[srcCnt]         = i;
                    srcOrdSeq[srcCnt]    = sht.GetCellValue(i, "orderBySeq");
                    srcCnt++;
                }
            }
        }
        return rowSort(srcRow, srcOrdSeq, 0, srcRow.length - 1);
    }

    function rowSort(srcRow, srcOrdSeq, start, end) {
        for (var i = end - 1; i >= start;  i--) {
            for (var j = start; j <= i; j++) {
                if ( srcOrdSeq[j] > srcOrdSeq[j+1]) {
                    var tempRow		= srcRow[j];
                    var tempOrdSeq	= srcOrdSeq[j];
                    srcRow[j]   	= srcRow[j+1];
                    srcRow[j+1]		= tempRow;
                    srcOrdSeq[j]	= srcOrdSeq[j+1];
                    srcOrdSeq[j+1]	= tempOrdSeq;
                  }
            }
        }
        return srcRow;
    }

    function mvSearchElement(){
        for(row = 1 ; row <= sheet1.LastRow() ; row++){
        	if(sheet1.GetCellValue(row, "sCheck") == "1" && checkDup(sheet2, "columnNm", sheet1.GetCellValue(row, "columnNm"))){
            	var newRow = sheet2.DataInsert(0);
                sheet2.SetCellValue(newRow, "searchSeq",$("#srchSeq").val());
                sheet2.SetCellValue(newRow, "columnNm", sheet1.GetCellValue(row, "columnNm") );
                sheet2.SetCellValue(newRow, "seq", (parseInt(parseInt(getColMaxValue(sheet2, "seq"))/10)+1)*10 );
        	}
        }
        initCheck();
    }

    function mvConfitionElement(){
        for(row = 1 ; row <= sheet1.LastRow() ; row++){
            if(sheet1.GetCellValue(row, "sCheck") == "1" && checkDup(sheet3, "columnNm", sheet1.GetCellValue(row, "columnNm"))){
                if(checkDup(sheet4, "columnNm", sheet1.GetCellValue(row, "columnNm"))){
                    var newRow = sheet3.DataInsert(0);
                    sheet3.SetCellValue(newRow, "searchSeq", 	$("#srchSeq").val());
                    sheet3.SetCellValue(newRow, "columnNm", 	sheet1.GetCellValue(row, "columnNm") );
                    sheet3.SetCellValue(newRow, "condType", 	"F" );
                    sheet3.SetCellValue(newRow, "searchItemCd", sheet1.GetCellValue(row, "searchItemCd") );
                    sheet3.SetCellValue(newRow, "searchItemNm", sheet1.GetCellValue(row, "searchItemNm") );
                    sheet3.SetCellValue(newRow, "itemMapType", 	sheet1.GetCellValue(row, "itemMapType") );
                    sheet3.SetCellValue(newRow, "prgUrl", 		sheet1.GetCellValue(row, "prgUrl") );
                    sheet3.SetCellValue(newRow, "sqlSyntax", 	sheet1.GetCellValue(row, "sqlSyntax") );
                    sheet3.SetCellValue(newRow, "inputValue",	"''");
                    if( sheet1.GetCellValue(row, "searchItemCd")){
                        sheet3.SetCellValue(newRow, "valueType", sheet1.SetCellValue(row, "valueType", "dfCode") );
                    }
                }else{
                    alert("\""+sheet1.GetCellValue(row, "columnNm")+"\"가  사용자입력 조건항목에 존재합니다.");
                }
            }
        }
        initCheck();
    }

    function mvUserConfitionElement(){
        for(row = 1 ; row <= sheet1.LastRow() ; row++){
            if(sheet1.GetCellValue(row, "sCheck") == "1" && checkDup(sheet4, "columnNm", sheet1.GetCellValue(row, "columnNm"))){
                if(checkDup(sheet3, "columnNm", sheet1.GetCellValue(row, "columnNm"))){
                    var newRow = sheet4.DataInsert(0);
                    sheet4.SetCellValue(newRow, "searchSeq", 	$("#srchSeq").val() );
                    sheet4.SetCellValue(newRow, "columnNm", 	sheet1.GetCellValue(row, "columnNm") );
                    sheet4.SetCellValue(newRow, "condType", 	"U" );
                    sheet4.SetCellValue(newRow, "searchItemCd", sheet1.GetCellValue(row, "searchItemCd") );
                    sheet4.SetCellValue(newRow, "searchItemNm", sheet1.GetCellValue(row, "searchItemNm") );
                    sheet4.SetCellValue(newRow, "itemMapType", 	sheet1.GetCellValue(row, "itemMapType") );
                    sheet4.SetCellValue(newRow, "prgUrl", 		sheet1.GetCellValue(row, "prgUrl") );
                    sheet4.SetCellValue(newRow, "sqlSyntax", 	sheet1.GetCellValue(row, "sqlSyntax") );
                    sheet4.SetCellValue(newRow, "inputValue", 	"''" );
                    if( sheet1.GetCellValue(row, "searchItemCd")){
                        sheet4.SetCellValue(newRow, "valueType", sheet1.SetCellValue(row, "valueType", "dfCode") );
                    }
                }else{
                    alert("\""+sheet1.GetCellValue(row, "columnNm")+"\"가  고정조건항목에 존재합니다.");
                }
            }
        }
        initCheck();
    }

    function checkDup(targetSheet, col, value){
        var row = targetSheet.FindText(col, value);
        if(row == -1){ return true;
        }else{ return false; }
    }
    function initCheck(){
        for(i = 0 ; i <= sheet1.LastRow() ; i++){
            sheet1.GetCellValue(i, "sCheck",0);
            sheet1.GetCellText(i, "sCheck","<tit:txt mid='111914' mdef='선택'/>");
        }
    }

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "pwrSrchElemPopup1") {
			sheet3.SetCellValue(gPRow, "searchItemCd", 		rv["searchItemCd"] );
			sheet3.SetCellValue(gPRow, "searchItemNm", 		rv["searchItemNm"] );
			sheet3.SetCellValue(gPRow, "searchItemDesc",	rv["searchItemDesc"] );
			sheet3.SetCellValue(gPRow, "itemMapType", 		rv["itemMapType"] );
			sheet3.SetCellValue(gPRow, "prgUrl", 			rv["prgUrl"] );
			sheet3.SetCellValue(gPRow, "sqlSyntax", 		rv["sqlSyntax"] );
		} else if(pGubun == "pwrSrchElemPopup2") {
			sheet4.SetCellValue(gPRow, "searchItemCd", 		rv["searchItemCd"] );
			sheet4.SetCellValue(gPRow, "searchItemNm", 		rv["searchItemNm"] );
			sheet4.SetCellValue(gPRow, "searchItemDesc",	rv["searchItemDesc"] );
			sheet4.SetCellValue(gPRow, "itemMapType", 		rv["itemMapType"] );
			sheet4.SetCellValue(gPRow, "prgUrl", 			rv["prgUrl"] );
			sheet4.SetCellValue(gPRow, "sqlSyntax", 		rv["sqlSyntax"] );
        }
	}

</script>
</head>
<body class="bodywrap">

<div class="wrapper modal_layer">
	<div class="layerTitle-wrap">
		<div id="titleSearchDesc"><tit:txt mid='104342' mdef='조건 검색 설정'/></div>
		<div class="close"></div>
	</div>

	<div class="modal_body">
		<form id="sheetForm" name="sheetForm">
			<input id="srchSeq" 	name="srchSeq"  type="Hidden""/>
			<input id="viewCd" 		name="viewCd"  	type="Hidden""/>
			<input id="viewNm" 		name="viewNm"   type="Hidden"/>
			<input id="viewDesc" 	name="viewDesc" type="Hidden"/>
			<input id="srchDesc" 	name="srchDesc" type="Hidden"/>
			<input id="condTYpe"	name="condType" type="Hidden"/>
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="30%" />
			<col width="" />
			<col width="70%" />
		</colgroup>
		<tr>
			<td rowspan="3">
				<div class="sheet_title inner">
				<ul>
					<li class="txt"><tit:txt mid='pwrSrchAdminUser3' mdef='사용자입력 조건항목 설정'/></li>
<!-- 					<li class="btn"> -->
<!-- 						<a href="javascript:doAction5('Save');" class="basic authA"><tit:txt mid='104476' mdef='저장'/></a> -->
<!-- 					</li> -->
				</ul>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "30%", "100%", "${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_arrow">
				<div class="sheet_button">
					<a href="javascript:mvSearchElement();" 		class="basic">&gt;</a>
				</div>
			</td>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='104254' mdef='조회항목 설정'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction2('Search');" css="basic authR" mid='110697' mdef="조회"/>
							<btn:a href="javascript:doAction2('Save');" css="basic authA" mid='110708' mdef="저장"/>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "70%", "33%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>

		<tr>
			<td class="sheet_arrow">
				<div class="sheet_button">
					<a href="javascript:mvConfitionElement()" 		class="basic">&gt;</a>
				</div>
			</td>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='104055' mdef='고정 조건항목 설정'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction3('Search');" css="basic authR" mid='110697' mdef="조회"/>
							<btn:a href="javascript:doAction3('Save');" css="basic authA" mid='110708' mdef="저장"/>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet3", "70%", "33%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>

		<tr>
			<td class="sheet_arrow">
				<div class="sheet_button">
					<a href="javascript:mvUserConfitionElement()" 		class="basic">&gt;</a>
				</div>
			</td>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='pwrSrchAdminUser3' mdef='사용자입력 조건항목 설정'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction4('Search');" css="basic authR" mid='110697' mdef="조회"/>
							<btn:a href="javascript:doAction4('Save');" css="basic authA" mid='110708' mdef="저장"/>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet4", "70%", "33%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>

		</table>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:p.self.close();" css="btn outline_gray" mid='110881' mdef="닫기"/>
		<btn:a href="javascript:openResult();" css="btn filled" mid='110710' mdef="검색결과"/>
	</div>
</div>

<div id="tmpSave" class="hide">
	<script type="text/javascript"> createIBSheet("sheet5", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>

</body>
</html>


