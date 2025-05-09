<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><tit:txt mid='104252' mdef='조건 검색 관리(Admin)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style type="text/css">
#popupWrap {
	WIDTH: 100%;
	HEIGHT: 100%;
}

TABLE.popupMain {
	WIDTH: 100%;
	HEIGHT: 100%;
}

TABLE.popupMain TD.header {
	HEIGHT: 50px;
	VERTICAL-ALIGN: top;
}

TABLE.popupMain TD.header TABLE {
	MARGIN-TOP: 17px;
	WIDTH: 100%;
}

TABLE.popupMain TD.header TABLE TH {
	TEXT-ALIGN: left;
	PADDING-LEFT: 28px;
	COLOR: #666666;
	FONT-SIZE: 14px;
	VERTICAL-ALIGN: top;
}

TABLE.popupMain TD.header TABLE TD {
	WIDTH: 100%;
	HEIGHT: 100%;
	TEXT-ALIGN: right;
	PADDING-RIGHT: 18px;
	VERTICAL-ALIGN: top;
}

TABLE.popupMain TD.header TABLE TD IMG {
	CURSOR: pointer;
}

TABLE.popupMain TD.popupContent {
	TEXT-ALIGN: center;
	PADDING-BOTTOM: 15px;
	PADDING-LEFT: 15px;
	PADDING-RIGHT: 15px;
	VERTICAL-ALIGN: top;
	PADDING-TOP: 13px;
}

TABLE.popupMain TD.footer {
	TEXT-ALIGN: center;
	HEIGHT: 40px;
}

.sheet {
	BORDER-BOTTOM: #ebeef0 1px solid;
	BORDER-LEFT: #ebeef0 1px solid;
	VERTICAL-ALIGN: top;
	BORDER-TOP: #ebeef0 1px solid;
	BORDER-RIGHT: #ebeef0 1px solid;
}
</style>
<script language="javascript">
	$(function(){
		var initdata = {};
////////////////////////////// 조건업무Viwe
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:"${dataReadCnt}", FrozenCol:5, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",  	Hidden:${sNoHdn},  	Width:"${sNoWdt}",	Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",		Type:"Text",     	Hidden:0,  			Width:180,   		Align:"Left", 	ColMerge:0,   SaveName:"columnNm",      KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='check' mdef='선택'/>",			Type:"CheckBox",   	Hidden:0,  			Width:50,    		Align:"Center",	ColMerge:0,   SaveName:"sCheck",    	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='valueType' mdef='조건입력방법'/>",	Type:"Text",      	Hidden:1,  			Width:0,  			Align:"Center",	ColMerge:0,   SaveName:"valueType",    	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",		Type:"Text",      	Hidden:1,  			Width:0,  			Align:"Center",	ColMerge:0,   SaveName:"searchItemCd",	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='elementNmV6' mdef='항목'/>",			Type:"Text",      	Hidden:1,  			Width:0,			Align:"Center",	ColMerge:0,   SaveName:"searchItemNm",  KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='itemMapType' mdef='항목맵핑구분'/>",	Type:"Text",     	Hidden:1,  			Width:0,  			Align:"Center",	ColMerge:0,   SaveName:"itemMapType", 	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='prgUrl' mdef='프로그램URL'/>", 	Type:"Text",      	Hidden:1,  			Width:0,  			Align:"Center",	ColMerge:0,   SaveName:"prgUrl",       	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='sqlSyntax' mdef='SQL문'/>", 		Type:"Text",  		Hidden:1,  			Width:0,  			Align:"Center",	ColMerge:0,   SaveName:"sqlSyntax",   	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50 }
		];IBS_InitSheet(sht1, initdata);//초기화
		sht1.FitColWidth(); sht1.SetEditable("${editable}"); sht1.SetVisible(true);
///////////////////////////// 조건항목 설정 자료
		var inqTypeCmbList 	= convCode( codeList("<c:url value='/CommonCode.do?cmd=getCommonCodeList'/>","R20020"), "");
		initdata.Cfg = {SearchMode:smLazyLoad,Page:"${dataReadCnt}"};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",    Hidden:${sNoHdn}, 	Width:"${sNoWdt}",  Align:"Center",	ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:${sDelHdn},	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='resultV2' mdef='결과'/>",		Type:"${sRstTy}",   Hidden:${sRstHdn},	Width:"${sRstWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sResult" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",   Hidden:${sSttHdn},	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",	Type:"Text",    	Hidden:1,   		Width:0,   			Align:"Left",  	ColMerge:0,   SaveName:"searchSeq", 	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",	Type:"Text",    	Hidden:0,   		Width:195,  		Align:"Left", 	ColMerge:0,   SaveName:"columnNm",    	KeyField:0,   CalcLogic:"",   Format:"", 			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",		Type:"Float",    	Hidden:0,   		Width:80,   		Align:"Center",	ColMerge:0,   SaveName:"seq",       	KeyField:0,   CalcLogic:"",   Format:"NullFloat", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='orderBySeq' mdef='정렬순서'/>",	Type:"Float",    	Hidden:0,   		Width:80,			Align:"Center",	ColMerge:0,   SaveName:"orderBySeq",  	KeyField:0,   CalcLogic:"",   Format:"NullFloat",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='ascDesc' mdef='정렬구분'/>",	Type:"Combo",    	Hidden:0,   		Width:80,			Align:"Center",	ColMerge:0,   SaveName:"adcDesc",  		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='inqType' mdef='조회형태'/>",	Type:"Combo",    	Hidden:0,   		Width:100,			Align:"Center",	ColMerge:0,   SaveName:"inqType",  		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 }
		];IBS_InitSheet(sht2, initdata);
		sht2.SetColProperty("ascDesc", 	{ComboText:"|올림차순|내림차순", 	ComboCode:"|ASC|DESC"} );
		sht2.SetColProperty("inqType", 	{ComboText:inqTypeCmbList[0], 		ComboCode:inqTypeCmbList[1]} );
		sht2.FitColWidth(); sht2.SetEditable("${editable}"); sht2.SetVisible(true);
///////////////////////////// 고정 조건항목 설정 자료
		var operTypeCmbList 	= convCode( codeList("<c:url value='/CommonCode.do?cmd=getCommonCodeList'/>","S50020"), "");
		var valueTypeCmbList 	= convCode( codeList("<c:url value='/CommonCode.do?cmd=getCommonCodeList'/>","R20030"), "");
		initdata.Cfg = {SearchMode:smLazyLoad,Page:"${dataReadCnt}"};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",    Hidden:${sNoHdn}, 	Width:"${sNoWdt}",  Align:"Center",	ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='resultV2' mdef='결과'/>",			Type:"${sRstTy}",   Hidden:${sRstHdn},	Width:"${sRstWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sResult" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",   Hidden:${sSttHdn},	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",		Type:"Text",    	Hidden:1,   		Width:0,   			Align:"Left",  	ColMerge:0,   SaveName:"searchSeq", 	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",		Type:"Text",    	Hidden:0,   		Width:80,  			Align:"Left", 	ColMerge:0,   SaveName:"columnNm",    	KeyField:0,   CalcLogic:"",   Format:"", 			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='itemMapType' mdef='항목맵핑구분'/>",	Type:"Text",    	Hidden:1,   		Width:0,   			Align:"Left",	ColMerge:0,   SaveName:"itemMapType",	KeyField:0,   CalcLogic:"",   Format:"", 			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='prgUrl' mdef='프로그램URL'/>",	Type:"Text",    	Hidden:1,   		Width:0,			Align:"Left",	ColMerge:0,   SaveName:"prgUrl",  		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='sqlSyntax' mdef='SQL문'/>",			Type:"Text",    	Hidden:1,   		Width:0,			Align:"Left",	ColMerge:0,   SaveName:"sqlSyntax",  	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='operator' mdef='연산자'/>",		Type:"Combo",    	Hidden:0,   		Width:60,			Align:"Center",	ColMerge:0,   SaveName:"operator",  	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='valueType' mdef='조건입력방법'/>",	Type:"Combo",    	Hidden:0,   		Width:90,			Align:"Center",	ColMerge:0,   SaveName:"valueType",  	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='searchItemCdV1' mdef='코드항목CD'/>",	Type:"Text",    	Hidden:1,   		Width:0,			Align:"Left",	ColMerge:0,   SaveName:"searchItemCd",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='searchItemNmV1' mdef='코드선택'/>",		Type:"Popup",    	Hidden:0,   		Width:80,			Align:"Left",	ColMerge:0,   SaveName:"searchItemNm",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='inputValue' mdef='조건값'/>",		Type:"Text",    	Hidden:1,   		Width:0,			Align:"Left",	ColMerge:0,   SaveName:"inputValue", 	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"<sht:txt mid='inputValue' mdef='조건값'/>",		Type:"Popup",    	Hidden:0,   		Width:180,			Align:"Left",	ColMerge:0,   SaveName:"inputValueDesc",KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4000 },
			{Header:"AND\nOR",		Type:"Combo",    	Hidden:0,   		Width:40,			Align:"Center",	ColMerge:0,   SaveName:"andOr",  		KeyField:0,   CalcLogic:"",   Format:"NullFloat",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Float",    	Hidden:0,   		Width:40,			Align:"Center",	ColMerge:0,   SaveName:"seq",  			KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='condType' mdef='조건항목구분'/>",	Type:"Text",		Hidden:1,			Width:0,			Align:"Left",	ColMerge:0,   SaveName:"condType", 		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:${sDelHdn},	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sDelete" }
		];IBS_InitSheet(sht3, initdata);
		sht3.SetColProperty("andOr", 		{ComboText:"AND|OR", 			ComboCode:"AND|OR"} );
		sht3.SetColProperty("operator", 	{ComboText:operTypeCmbList[0],	ComboCode:operTypeCmbList[1]} );
		sht3.SetColProperty("valueType", 	{ComboText:valueTypeCmbList[0], ComboCode:valueTypeCmbList[1]} );
		sht3.FitColWidth(); sht3.SetEditable("${editable}"); sht3.SetVisible(true);
///////////////////////////// 사용자입력 조건항목설정 자료
		var operTypeCmbList 	= convCode( codeList("<c:url value='/CommonCode.do?cmd=getCommonCodeList'/>","S50020"), "");
		var valueTypeCmbList 	= convCode( codeList("<c:url value='/CommonCode.do?cmd=getCommonCodeList'/>","R20030"), "");
		initdata.Cfg = {SearchMode:smLazyLoad,Page:"${dataReadCnt}"};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",    Hidden:${sNoHdn}, 	Width:"${sNoWdt}",  Align:"Center",	ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='resultV2' mdef='결과'/>",			Type:"${sRstTy}",   Hidden:${sRstHdn},	Width:"${sRstWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sResult" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",   Hidden:${sSttHdn},	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",		Type:"Text",    	Hidden:1,   		Width:0,   			Align:"Left",  	ColMerge:0,   SaveName:"searchSeq", 	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",		Type:"Text",    	Hidden:0,   		Width:80,  			Align:"Left", 	ColMerge:0,   SaveName:"columnNm",    	KeyField:0,   CalcLogic:"",   Format:"", 			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='itemMapType' mdef='항목맵핑구분'/>",	Type:"Text",    	Hidden:1,   		Width:0,   			Align:"Left",	ColMerge:0,   SaveName:"itemMapType",	KeyField:0,   CalcLogic:"",   Format:"", 			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='prgUrl' mdef='프로그램URL'/>",	Type:"Text",    	Hidden:1,   		Width:0,			Align:"Left",	ColMerge:0,   SaveName:"prgUrl",  		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='sqlSyntax' mdef='SQL문'/>",			Type:"Text",    	Hidden:1,   		Width:0,			Align:"Left",	ColMerge:0,   SaveName:"sqlSyntax",  	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='operator' mdef='연산자'/>",		Type:"Combo",    	Hidden:0,   		Width:60,			Align:"Center",	ColMerge:0,   SaveName:"operator",  	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='valueType' mdef='조건입력방법'/>",	Type:"Combo",    	Hidden:0,   		Width:90,			Align:"Center",	ColMerge:0,   SaveName:"valueType",  	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='searchItemCdV1' mdef='코드항목CD'/>",	Type:"Text",    	Hidden:1,   		Width:0,			Align:"Left",	ColMerge:0,   SaveName:"searchItemCd",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='searchItemNmV1' mdef='코드선택'/>",		Type:"Popup",    	Hidden:0,   		Width:80,			Align:"Left",	ColMerge:0,   SaveName:"searchItemNm",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='inputValue' mdef='조건값'/>",		Type:"Text",    	Hidden:1,   		Width:0,			Align:"Left",	ColMerge:0,   SaveName:"inputValue", 	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"<sht:txt mid='inputValue' mdef='조건값'/>",		Type:"Popup",    	Hidden:0,   		Width:180,			Align:"Left",	ColMerge:0,   SaveName:"inputValueDesc",KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4000 },
			{Header:"AND\nOR",		Type:"Combo",    	Hidden:0,   		Width:40,			Align:"Center",	ColMerge:0,   SaveName:"andOr",  		KeyField:0,   CalcLogic:"",   Format:"NullFloat",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Float",    	Hidden:0,   		Width:40,			Align:"Center",	ColMerge:0,   SaveName:"seq",  			KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='condType' mdef='조건항목구분'/>",	Type:"Text",		Hidden:1,			Width:0,			Align:"Left",	ColMerge:0,   SaveName:"condType", 		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:${sDelHdn},	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sDelete" }
		];IBS_InitSheet(sht4, initdata);
		sht4.SetColProperty("andOr", 		{ComboText:"AND|OR", 			ComboCode:"AND|OR"} );
		sht4.SetColProperty("operator", 	{ComboText:operTypeCmbList[0],	ComboCode:operTypeCmbList[1]} );
		sht4.SetColProperty("valueType", 	{ComboText:valueTypeCmbList[0], ComboCode:valueTypeCmbList[1]} );
		sht4.FitColWidth(); sht4.SetEditable("${editable}"); sht4.SetVisible(true);
///////////////////////////// 조건항목 설정 자료
		var inqTypeCmbList 	= convCode( codeList("<c:url value='/CommonCode.do?cmd=getCommonCodeList'/>","R20020"), "");
		initdata.Cfg = {SearchMode:smLazyLoad,Page:"${dataReadCnt}"};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",    Hidden:0, 	Width:"${sNoWdt}",  Align:"Center",	ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='resultV2' mdef='결과'/>",		Type:"${sRstTy}",   Hidden:0,	Width:"${sRstWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sResult" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",   Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",	Type:"Text",    	Hidden:0,	Width:0,   			Align:"Left",  	ColMerge:0,   SaveName:"searchSeq", 	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='viewCdV1' mdef='뷰코드'/>",	Type:"Text",    	Hidden:0,	Width:0,  			Align:"Left", 	ColMerge:0,   SaveName:"viewCd",    	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
			{Header:"<sht:txt mid='adminSqlSyntax' mdef='Admin쿼리'/>",	Type:"Text",    	Hidden:0,	Width:0,   			Align:"Left",	ColMerge:0,   SaveName:"adminSqlSyntax",KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"<sht:txt mid='sqlSyntaxV1' mdef='쿼리'/>",		Type:"Text",    	Hidden:0,	Width:0,			Align:"Left",	ColMerge:0,   SaveName:"sqlSyntax",  	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:0,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sDelete" }
		];IBS_InitSheet(sht5, initdata);
		sht5.FitColWidth(); sht5.SetEditable("${editable}"); sht5.SetVisible(true);
	});
</script>
</head>
<body scroll="no">
	<!-- 컨텐츠 시작 -->
	<div id="popupWrap">
		<table class="popupMain">
			<tr>
				<td class="header">
					<table>
						<tr>
							<th>
								<span id=titleSearchDesc class="popuptitle"><tit:txt mid='104342' mdef='조건 검색 설정'/></span>
							</th>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="popupContent">
					<table class="wrap">
						<colgroup>
							<col width="30%" />
							<col width="" />
							<col width="70%" />
						</colgroup>
						<tr>
							<td colspan="3">
								<!-- 검색 영역 시작 -->
								<div class="searchMain">
									<div class="search">
										<table>
											<tr>
												<td>
													<!-- 항목명 시작 -->
													<form name="form">
														<input type="Hidden" name="searchSearchSeq"/>
														<input type="Hidden" name="searchViewCd"/>
														<input type="Hidden" name="searchCondType"/>
														<input type="Hidden" name="searchViewNm"/>
														<table class="searchTable">
															<tr>
																<td><tit:txt mid='srchDesc' mdef='조회업무'/></td>
																<td>
																	<input type="text" name="searchViewDesc" size="48" class="" style="ime-mode: active" onKeyUp="check_Enter();"/>
																</td>
															</tr>
														</table>
													</form> <!-- 항목명 종료 --></td>
												<td>
													<span class="button">
														<button type="button" onclick="doAction5('Save');">저장</button>
													</span>
													<span class="button">
														<button type="button" onclick="goDistribution();">조건배포</button>
													</span>
													<span class="button">
														<button type="button" onclick="openResult();">검색결과</button>
													</span>
												</td>
											</tr>
										</table>
									</div>
								</div> <!-- 검색 영역 종료 --></td>
						</tr>
						<tr>
							<td class="top" style="=height: 100%;">
								<table class="wrap">
									<tr>
										<td class="pt05 pb05">
											<span class="button">
												<button type="button" onclick="mvSearchElement();" style="width: 100%;">조회항목으로 이동</button>
											</span>
										</td>
									</tr>
									<tr>
										<td class="pb05">
											<span class="button">
												<button type="button" onclick="mvConfitionElement();" style="width: 100%;">조건항목으로 이동</button>
											</span>
										</td>
									</tr>
									<tr>
										<td class="pb05">
											<span class="button">
												<button type="button" onclick="mvUserConfitionElement();" style="width: 100%;">사용자입력 조건항목 이동</button>
											</span>
										</td>
									</tr>
									<tr>
										<td class="sheet" style="height: 100%;">
											<script language="javascript">createIBSheet("sht1", "100%", "100%", "${ssnLocaleCd}");</script>
										</td>
									</tr>
								</table>
							<td class="dragArea"></td>
							<td class="top" height: 100%;>
								<table class="wrap">
									<tr>
										<td>
											<!-- 타이틀 & 버튼 시작 -->
											<table class="contentTitle">
												<tr>
													<td class="left">
														<!-- 타이틀 시작 --> <span class="title01"><tit:txt mid='104254' mdef='조회항목 설정'/></span> <!-- 타이틀 종료 -->
													</td>
													<td class="right">
														<!-- 버튼 시작 -->
														<span class="button blue">
															<button type="button" onclick="doAction2('Search');">조회</button>
														</span>
														<span class="button">
															<button type="button" onclick="doAction5('Save');">저장</button>
														</span> <!-- 버튼 종료 -->
													</td>
												</tr>
											</table> <!-- 타이틀 & 버튼 종료 --></td>
									</tr>
									<tr>
										<td class="sheet" style="height: 33%;">
											<script language="javascript">createIBSheet("sht2", "100%", "100%", "${ssnLocaleCd}");</script>
										</td>
									</tr>
									<tr>
										<td>
											<!-- 타이틀 & 버튼 시작 -->
											<table class="contentTitle">
												<tr>
													<td class="left">
														<!-- 타이틀 시작 --> <span class="title01"><tit:txt mid='104055' mdef='고정 조건항목 설정'/></span> <!-- 타이틀 종료 -->
													</td>
													<td class="right">
														<!-- 버튼 시작 -->
														<span class="button blue">
															<button type="button" onclick="doAction3('Search');">조회</button>
														</span>
														<span class="button">
															<button type="button" onclick="doAction3('Save');">저장</button>
														</span> <!-- 버튼 종료 -->
													</td>
												</tr>
											</table> <!-- 타이틀 & 버튼 종료 -->
										</td>
									</tr>
									<tr>
										<td class="sheet" style="height: 33%;">
											<script language="javascript">createIBSheet("sht3", "100%", "100%", "${ssnLocaleCd}");</script>
										</td>
									</tr>
									<tr>
										<td>
											<!-- 타이틀 & 버튼 시작 -->
											<table class="contentTitle">
												<tr>
													<td class="left">
														<!-- 타이틀 시작 --> <span class="title01"><tit:txt mid='pwrSrchAdminUser3' mdef='사용자입력 조건항목 설정'/></span>
														<!-- 타이틀 종료 --></td>
													<td class="right">
														<!-- 버튼 시작 -->
														<span class="button blue">
															<button type="button" onclick="doAction4('Search');">조회</button>
														</span>
														<span class="button">
															<button type="button" onclick="doAction5('Save');">저장</button>
														</span> <!-- 버튼 종료 -->
													</td>
												</tr>
											</table> <!-- 타이틀 & 버튼 종료 --></td>
									</tr>
									<tr>
										<td class="sheet" style="height: 33%;">
											<script language="javascript">createIBSheet("sht4", "100%", "100%", "${ssnLocaleCd}");</script>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="footer">
					<span class="button">
						<button type="button" onclick="winClose();">닫기</button>
					</span>
				</td>
			</tr>
		</table>
	</div>

	<div id="tmpSave" style="display: none">
		<script language="javascript">createIBSheet("sht5", "100%", "100%", "${ssnLocaleCd}");</script>
	</div>
	<!-- 컨텐츠 종료 -->
</body>
</html>


