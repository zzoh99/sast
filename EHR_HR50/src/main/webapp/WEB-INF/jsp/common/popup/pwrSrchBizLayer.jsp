<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>



<script type="text/javascript">
	var pwrSrchBizLayer = { id: 'pwrSrchBizLayer' };
	var selectSheet = null;
	var gPRow = null;
	var pGubun = null;
	$(function() {

		createIBSheet3(document.getElementById('pwrSrchBizLayerSheet1-wrap'), "pwrSrchBizLayerSheet1", "100%", "540px", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('pwrSrchBizLayerSheet2-wrap'), "pwrSrchBizLayerSheet2", "100%", "150px", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('pwrSrchBizLayerSheet3-wrap'), "pwrSrchBizLayerSheet3", "100%", "150px", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('pwrSrchBizLayerSheet4-wrap'), "pwrSrchBizLayerSheet4", "100%", "150px", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('pwrSrchBizLayerSheet5-wrap'), "pwrSrchBizLayerSheet5", "100%", "100%", "${ssnLocaleCd}");

		var modal = window.top.document.LayerModalUtility.getModal(pwrSrchBizLayer.id);
		var { srchSeq, viewCd, viewNm, viewDesc, srchDesc } = modal.parameters;
		$("#srchSeq").val(srchSeq);
		$("#viewCd").val(viewCd);
		$("#viewNm").val(viewNm);
		$("#viewDesc").val(viewDesc);
		$("#srchDesc").val(srchDesc);

		var inqTypeCd 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20020"), "<tit:txt mid='103895' mdef='전체'/>",-1);
		var valueTypeCd	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20030"), "<tit:txt mid='103895' mdef='전체'/>",-1);
		var operTypeCd 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S50020"), "<tit:txt mid='103895' mdef='전체'/>",-1);

		var initdata = {};
		////////////////////////////// 조건업무Viwe
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:"${dataReadCnt}", FrozenCol:0, DataRowMerge:0,AutoFitColWidth:'init|search|resize|rowtransaction'};
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
		];IBS_InitSheet(pwrSrchBizLayerSheet1, initdata);pwrSrchBizLayerSheet1.SetEditable("${editable}"); pwrSrchBizLayerSheet1.SetVisible(true);//초기화

		///////////////////////////// 조건항목 설정 자료
		initdata.Cfg = {SearchMode:smLazyLoad,Page:"${dataReadCnt}",AutoFitColWidth:'init|search|resize|rowtransaction'};
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
		];IBS_InitSheet(pwrSrchBizLayerSheet2, initdata);pwrSrchBizLayerSheet2.SetEditable("${editable}"); pwrSrchBizLayerSheet2.SetVisible(true);

		pwrSrchBizLayerSheet2.SetColProperty("ascDesc", 	{ComboText:"|"+"올림차순|내림차순", 	ComboCode:"|ASC|DESC"} );
		pwrSrchBizLayerSheet2.SetColProperty("inqType", 	{ComboText:inqTypeCd[0], 			ComboCode:inqTypeCd[1]} );
		pwrSrchBizLayerSheet2.SetColProperty("mergeYn", 	{ComboText:"|N|Y", 	ComboCode:"|N|Y"} );

		///////////////////////////// 고정 조건항목 설정 자료
		initdata.Cfg = {SearchMode:smLazyLoad,Page:"${dataReadCnt}",AutoFitColWidth:'init|search|resize|rowtransaction'};
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
		];IBS_InitSheet(pwrSrchBizLayerSheet3, initdata);pwrSrchBizLayerSheet3.SetEditable("${editable}"); pwrSrchBizLayerSheet3.SetVisible(true);

		pwrSrchBizLayerSheet3.SetColProperty("andOr", 		{ComboText:"AND|OR", 			ComboCode:"AND|OR"} );
		pwrSrchBizLayerSheet3.SetColProperty("operator", 	{ComboText:operTypeCd[0],	ComboCode:operTypeCd[1]} );
		pwrSrchBizLayerSheet3.SetColProperty("valueType", 	{ComboText:"|"+valueTypeCd[0], 	ComboCode:"|"+valueTypeCd[1]} );

		///////////////////////////// 사용자입력 조건항목설정 자료
		initdata.Cfg = {SearchMode:smLazyLoad,Page:"${dataReadCnt}",AutoFitColWidth:'init|search|resize|rowtransaction'};
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
		];IBS_InitSheet(pwrSrchBizLayerSheet4, initdata);pwrSrchBizLayerSheet4.SetEditable("${editable}"); pwrSrchBizLayerSheet4.SetVisible(true);

		pwrSrchBizLayerSheet4.SetColProperty("andOr", 		{ComboText:"AND|OR", 			ComboCode:"AND|OR"} );
		pwrSrchBizLayerSheet4.SetColProperty("operator", 	{ComboText:operTypeCd[0],	ComboCode:operTypeCd[1]} );
		pwrSrchBizLayerSheet4.SetColProperty("valueType", 	{ComboText:"|"+valueTypeCd[0], 	ComboCode:"|"+valueTypeCd[1]} );

		///////////////////////////// 조건항목 설정 자료
		initdata.Cfg = {SearchMode:smLazyLoad,Page:"${dataReadCnt}",AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",    Hidden:0, 	Width:"${sNoWdt}",  Align:"Center",	ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",   Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",	Type:"Text",    	Hidden:0,	Width:0,   			Align:"Left",  	ColMerge:0,   SaveName:"searchSeq", 	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='viewCdV1' mdef='뷰코드'/>",		Type:"Text",    	Hidden:0,	Width:0,  			Align:"Left", 	ColMerge:0,   SaveName:"viewCd",    	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
			{Header:"<sht:txt mid='adminSqlSyntax' mdef='Admin쿼리'/>",	Type:"Text",    	Hidden:0,	Width:0,   			Align:"Left",	ColMerge:0,   SaveName:"adminSqlSyntax",KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"<sht:txt mid='sqlSyntaxV1' mdef='쿼리'/>",		Type:"Text",    	Hidden:0,	Width:0,			Align:"Left",	ColMerge:0,   SaveName:"sqlSyntax",  	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:0,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,   SaveName:"sDelete" }
		];IBS_InitSheet(pwrSrchBizLayerSheet5, initdata); pwrSrchBizLayerSheet5.SetEditable("${editable}"); pwrSrchBizLayerSheet5.SetVisible(true);

	    $(window).smartresize(sheetResize);
	    sheetInit();

	    doAction1("Search");
	    doAction2("Search");
	    doAction3("Search");
	    doAction4("Search");
	});

	function doAction1(sAction) {
		switch (sAction) {
			case "Search":	pwrSrchBizLayerSheet1.DoSearch( "${ctx}/PwrSrchBizPopup.do?cmd=getPwrSrchBizPopupViewElemList", $("#sheetForm").serialize() ); break;
		}
	}
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":	pwrSrchBizLayerSheet2.DoSearch( "${ctx}/PwrSrchBizPopup.do?cmd=getPwrSrchBizPopupElemList", $("#sheetForm").serialize() ); break;
		case "Save":
			IBS_SaveName(document.sheetForm,pwrSrchBizLayerSheet2);
			pwrSrchBizLayerSheet2.DoSave("${ctx}/PwrSrchBizPopup.do?cmd=savePwrSrchBizPopupElem", $("#sheetForm").serialize(), -1, 0);  break;
		}
	}
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
			$("#condTYpe").val("F");
			pwrSrchBizLayerSheet3.DoSearch( "${ctx}/PwrSrchBizPopup.do?cmd=getPwrSrchBizPopupConditionList", $("#sheetForm").serialize() ); break;
		case "Save":
			if(pwrSrchBizLayerSheet3.FindStatusRow("I|U") != ""){
			    if(!dupChk(pwrSrchBizLayerSheet3,"columnNm", true, true)){break;}
			}
			IBS_SaveName(document.sheetForm,pwrSrchBizLayerSheet3);
			pwrSrchBizLayerSheet3.DoSave("${ctx}/PwrSrchBizPopup.do?cmd=savePwrSrchBizPopupCondition", $("#sheetForm").serialize(), -1, 0);
			break;
		}
	}
	function doAction4(sAction) {
		switch (sAction) {
		case "Search":
			$("#condTYpe").val("U");
			pwrSrchBizLayerSheet4.DoSearch( "${ctx}/PwrSrchBizPopup.do?cmd=getPwrSrchBizPopupConditionList", $("#sheetForm").serialize() ); break;
		case "Save":
			if(pwrSrchBizLayerSheet4.FindStatusRow("I|U") != ""){
			    if(!dupChk(pwrSrchBizLayerSheet4,"columnNm", true, true)){break;}
			}
			IBS_SaveName(document.sheetForm,pwrSrchBizLayerSheet4);
			pwrSrchBizLayerSheet4.DoSave("${ctx}/PwrSrchBizPopup.do?cmd=savePwrSrchBizPopupCondition", $("#sheetForm").serialize(), -1, 0);
			doAction5("Save");
			break;
		}
	}
	function doAction5(sAction) {
		switch (sAction) {
		case "Save":
			pwrSrchBizLayerSheet5.RemoveAll();
			var Row = pwrSrchBizLayerSheet5.DataInsert(0);
            pwrSrchBizLayerSheet5.SetCellValue(Row, "searchSeq",$("#srchSeq").val());
            pwrSrchBizLayerSheet5.SetCellValue(Row, "sqlSyntax",makeQuery());
            IBS_SaveName(document.sheetForm,pwrSrchBizLayerSheet5);
            pwrSrchBizLayerSheet5.DoSave("${ctx}/PwrSrchBizPopup.do?cmd=updatePwrSrchBizPopupSql", $("#sheetForm").serialize(), -1, 0);
            break;
		}
	}
	function pwrSrchBizLayerSheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function pwrSrchBizLayerSheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function pwrSrchBizLayerSheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		 	for(i = 1 ; i <= pwrSrchBizLayerSheet3.LastRow() ; i++){
		        if(pwrSrchBizLayerSheet3.GetCellValue(i,"valueType") == "dfCode"){
		            pwrSrchBizLayerSheet3.SetCellEditable(i,"searchItemNm",true);
		        }
		        checkIsNull(pwrSrchBizLayerSheet3, i, "operator");
		    }
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function pwrSrchBizLayerSheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		 	for(i = 1 ; i <= pwrSrchBizLayerSheet4.LastRow() ; i++){
		        if(pwrSrchBizLayerSheet4.GetCellValue(i,"valueType") == "dfCode"){
		            pwrSrchBizLayerSheet4.SetCellEditable(i,"searchItemNm",true);
		        }
		        checkIsNull(pwrSrchBizLayerSheet4, i, "operator");
		    }
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function pwrSrchBizLayerSheet5_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	function pwrSrchBizLayerSheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
	  	try{ selectSheet = pwrSrchBizLayerSheet1;
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	function pwrSrchBizLayerSheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
	  	try{ selectSheet = pwrSrchBizLayerSheet2;
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	function pwrSrchBizLayerSheet3_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
	  	try{ selectSheet = pwrSrchBizLayerSheet3;
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	function pwrSrchBizLayerSheet4_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
	  	try{ selectSheet = pwrSrchBizLayerSheet4;
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

 	function pwrSrchBizLayerSheet3_OnChange(Row, Col, Value){
		try{
		    if(Row > 0 && pwrSrchBizLayerSheet3.ColSaveName(Col) == "operator"){
		        pwrSrchBizLayerSheet3.SetCellValue(Row, "inputValue",pwrSrchBizLayerCheckLike(pwrSrchBizLayerSheet3,''));
		        pwrSrchBizLayerSheet3.SetCellValue(Row, "inputValueDesc","");
		        checkIsNull(pwrSrchBizLayerSheet3, Row, Col);
		    }else if(Row > 0 && pwrSrchBizLayerSheet3.ColSaveName(Col) == "valueType"){
		        if(Value == "dfCode"){
		            pwrSrchBizLayerSheet3.SetCellEditable(Row,"searchItemNm",true);
		        }else{
		            pwrSrchBizLayerSheet3.SetCellEditable(Row,"searchItemNm",false);
		            pwrSrchBizLayerSheet3.SetCellValue(Row,"searchItemCd","");
		            pwrSrchBizLayerSheet3.SetCellValue(Row,"searchItemNm","");
		        }
		        if(Value == "dfCompany"){
		            pwrSrchBizLayerSheet3.SetCellValue(Row, "inputValue",'@@회사@@');
		            pwrSrchBizLayerSheet3.SetCellValue(Row, "inputValueDesc","해당 회사");
		            pwrSrchBizLayerSheet3.SetCellEditable(Row,"searchItemNm",false);
		            pwrSrchBizLayerSheet3.SetCellEditable(Row,"inputValue",false);
		            pwrSrchBizLayerSheet3.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfSabun"){
		            pwrSrchBizLayerSheet3.SetCellValue(Row, "inputValue",'@@담당자@@');
		            pwrSrchBizLayerSheet3.SetCellValue(Row, "inputValueDesc","해당 담당자");
		            pwrSrchBizLayerSheet3.SetCellEditable(Row,"searchItemNm",false);
		            pwrSrchBizLayerSheet3.SetCellEditable(Row,"inputValue",false);
		            pwrSrchBizLayerSheet3.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfBaseDate"){
		            pwrSrchBizLayerSheet3.SetCellValue(Row, "inputValue",'@@적용일자@@');
		            pwrSrchBizLayerSheet3.SetCellValue(Row, "inputValueDesc","적용일자");
		            pwrSrchBizLayerSheet3.SetCellEditable(Row,"searchItemNm",false);
		            pwrSrchBizLayerSheet3.SetCellEditable(Row,"inputValue",false);
		            pwrSrchBizLayerSheet3.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfToday"){
		            pwrSrchBizLayerSheet3.SetCellValue(Row, "inputValue",'@@조회일자@@');
		            pwrSrchBizLayerSheet3.SetCellValue(Row, "inputValueDesc","조회일자");
		            pwrSrchBizLayerSheet3.SetCellEditable(Row,"searchItemNm",false);
		            pwrSrchBizLayerSheet3.SetCellEditable(Row,"inputValue",false);
		            pwrSrchBizLayerSheet3.SetCellEditable(Row,"inputValueDesc",false);
		        }else{
		            pwrSrchBizLayerSheet3.SetCellValue(Row, "inputValue",pwrSrchBizLayerCheckLike(pwrSrchBizLayerSheet3,''));
		            pwrSrchBizLayerSheet3.SetCellValue(Row, "inputValueDesc","");
		        }
		    }else if(Row > 0 && pwrSrchBizLayerSheet3.ColSaveName(Col) == "searchItemCd"){
		        pwrSrchBizLayerSheet3.SetCellValue(Row, "inputValue",pwrSrchBizLayerCheckLike(pwrSrchBizLayerSheet3,''));
		        pwrSrchBizLayerSheet3.SetCellValue(Row, "inputValueDesc","");
		    }
		    if(pwrSrchBizLayerSheet3.GetCellText(Row, "operator").indexOf("NULL") != -1){
		        pwrSrchBizLayerSheet3.SetCellValue(Row, "inputValue","");
		        pwrSrchBizLayerSheet3.SetCellValue(Row, "inputValueDesc","");
		    }
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
	
 	function pwrSrchBizLayerSheet4_OnChange(Row, Col, Value){
		try{
		    if(Row > 0 && pwrSrchBizLayerSheet4.ColSaveName(Col) == "operator"){
		        pwrSrchBizLayerSheet4.SetCellValue(Row, "inputValue",pwrSrchBizLayerCheckLike(pwrSrchBizLayerSheet4,''));
		        pwrSrchBizLayerSheet4.SetCellValue(Row, "inputValueDesc","");
		        checkIsNull(pwrSrchBizLayerSheet4, Row, Col);
		    }else if(Row > 0 && pwrSrchBizLayerSheet4.ColSaveName(Col) == "valueType"){
		        if(Value == "dfCode"){
		            pwrSrchBizLayerSheet4.SetCellEditable(Row,"searchItemNm",true);
		        }else{
		            pwrSrchBizLayerSheet4.SetCellEditable(Row,"searchItemNm",false);
		            pwrSrchBizLayerSheet4.SetCellValue(Row,"searchItemCd","");
		            pwrSrchBizLayerSheet4.SetCellValue(Row,"searchItemNm","");
		        }
		        if(Value == "dfCompany"){
		            pwrSrchBizLayerSheet4.SetCellValue(Row, "inputValue",'@@회사@@');
		            pwrSrchBizLayerSheet4.SetCellValue(Row, "inputValueDesc","해당 회사");
		            pwrSrchBizLayerSheet4.SetCellEditable(Row,"searchItemNm",false);
		            pwrSrchBizLayerSheet4.SetCellEditable(Row,"inputValue",false);
		            pwrSrchBizLayerSheet4.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfSabun"){
		            pwrSrchBizLayerSheet4.SetCellValue(Row, "inputValue",'@@담당자@@');
		            pwrSrchBizLayerSheet4.SetCellValue(Row, "inputValueDesc","해당 담당자");
		            pwrSrchBizLayerSheet4.SetCellEditable(Row,"searchItemNm",false);
		            pwrSrchBizLayerSheet4.SetCellEditable(Row,"inputValue",false);
		            pwrSrchBizLayerSheet4.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfBaseDate"){
		            pwrSrchBizLayerSheet4.SetCellValue(Row, "inputValue",'@@적용일자@@');
		            pwrSrchBizLayerSheet4.SetCellValue(Row, "inputValueDesc","적용일자");
		            pwrSrchBizLayerSheet4.SetCellEditable(Row,"searchItemNm",false);
		            pwrSrchBizLayerSheet4.SetCellEditable(Row,"inputValue",false);
		            pwrSrchBizLayerSheet4.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfToday"){
		            pwrSrchBizLayerSheet4.SetCellValue(Row, "inputValue",'@@조회일자@@');
		            pwrSrchBizLayerSheet4.SetCellValue(Row, "inputValueDesc","조회일자");
		            pwrSrchBizLayerSheet4.SetCellEditable(Row,"searchItemNm",false);
		            pwrSrchBizLayerSheet4.SetCellEditable(Row,"inputValue",false);
		            pwrSrchBizLayerSheet4.SetCellEditable(Row,"inputValueDesc",false);
		        }else{
		            pwrSrchBizLayerSheet4.SetCellValue(Row, "inputValue",pwrSrchBizLayerCheckLike(pwrSrchBizLayerSheet4,''));
		            pwrSrchBizLayerSheet4.SetCellValue(Row, "inputValueDesc","");
		        }
		    }else if(Row > 0 && pwrSrchBizLayerSheet4.ColSaveName(Col) == "searchItemCd"){
		        pwrSrchBizLayerSheet4.SetCellValue(Row, "inputValue",pwrSrchBizLayerCheckLike(pwrSrchBizLayerSheet4,''));
		        pwrSrchBizLayerSheet4.SetCellValue(Row, "inputValueDesc","");
		    }
		    if(pwrSrchBizLayerSheet4.GetCellText(Row, "operator").indexOf("NULL") != -1){
		        pwrSrchBizLayerSheet4.SetCellValue(Row, "inputValue","");
		        pwrSrchBizLayerSheet4.SetCellValue(Row, "inputValueDesc","");
		    }
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}

	function pwrSrchBizLayerSheet3_OnPopupClick(Row, Col){
		try{
		    if(Row > 0 && pwrSrchBizLayerSheet3.ColSaveName(Col) == "searchItemNm"){
		    	if(!isPopup()) {return;}
		    	gPRow = Row;
		    	pGubun = "pwrSrchElemPopup1";

				let layerModal = new window.top.document.LayerModal({
					id : 'pwrSrchElemLayer'
					, url : '/PwrSrchElemPopup.do?cmd=pwrSrchElemLayer'
					, parameters : {}
					, width : 640
					, height : 580
					, title : '조건검색 코드항목 조회'
					, trigger :[
						{
							name : 'pwrSrchElemLayerTrigger'
							, callback : function(result){
								pwrSrchBizLayerSheet3.SetCellValue(gPRow, "searchItemCd", 		result.searchItemCd );
								pwrSrchBizLayerSheet3.SetCellValue(gPRow, "searchItemNm", 		result.searchItemNm );
								pwrSrchBizLayerSheet3.SetCellValue(gPRow, "searchItemDesc",	result.searchItemDesc );
								pwrSrchBizLayerSheet3.SetCellValue(gPRow, "itemMapType", 		result.itemMapType );
								pwrSrchBizLayerSheet3.SetCellValue(gPRow, "prgUrl", 			result.prgUrl );
								pwrSrchBizLayerSheet3.SetCellValue(gPRow, "sqlSyntax", 		result.sqlSyntax );
							}
						}
					]
				});
				layerModal.show();

		    }
		    if(Row > 0 && pwrSrchBizLayerSheet3.ColSaveName(Col) == "inputValueDesc"){
		    	if(!isPopup()) {return;}

		    	gPRow = Row;
		    	pGubun = "pwrSrchInputValuePopup1";

		    	var args 	= new Array();
				args["operator"] = pwrSrchBizLayerSheet3.GetCellText(Row, "operator").toUpperCase();
				args["valueType"]    = pwrSrchBizLayerSheet3.GetCellValue(Row, "valueType");
				args["searchItemCd"]  = pwrSrchBizLayerSheet3.GetCellValue(Row, "searchItemCd");
				args["inputValue"]  = pwrSrchBizLayerSheet3.GetCellValue(Row, "inputValue");
				args["inputValueDesc"]  = pwrSrchBizLayerSheet3.GetCellValue(Row, "inputValueDesc");
				args["adminFlag"] 	= "no";

				<%--args["sheet"] 	= "pwrSrchBizLayerSheet3";--%>
				<%--var url	= "${ctx}/PwrSrchInputValuePopup.do?cmd=pwrSrchInputValuePopup&authPg=${authPg}&adminFlag=no";--%>
				<%--openPopup(url, args, "840","680");--%>

				let layerModal = new window.top.document.LayerModal({
					id : 'pwrSrchInputValueLayer'
					, url : '${ctx}/PwrSrchInputValuePopup.do?cmd=viewPwrSrchInputValueLayer&authPg=${authPg}'
					, parameters : args
					, width : 840
					, height : 680
					, title : '조회업무 조회'
					, trigger :[
						{
							name : 'pwrSrchInputValueTrigger'
							, callback : function(result){
								getReturnValue(result, pwrSrchBizLayerSheet3);
							}
						}
					]
				});
				layerModal.show();
		    }

		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	function pwrSrchBizLayerSheet4_OnPopupClick(Row, Col){
		try{
			if(Row > 0 && pwrSrchBizLayerSheet4.ColSaveName(Col) == "searchItemNm"){
				if(!isPopup()) {return;}

		    	gPRow = Row;
		    	pGubun = "pwrSrchElemPopup2";

				<%--var url 	= "${ctx}/PwrSrchElemPopup.do?cmd=pwrSrchElemPopup";--%>
				<%--var args 	= new Array();--%>
				<%--openPopup(url,args,640,580);--%>
				let layerModal = new window.top.document.LayerModal({
					id : 'pwrSrchElemLayer'
					, url : '/PwrSrchElemPopup.do?cmd=pwrSrchElemLayer'
					, parameters : {}
					, width : 640
					, height : 580
					, title : '조건검색 코드항목 조회'
					, trigger :[
						{
							name : 'pwrSrchElemLayerTrigger'
							, callback : function(result){
								pwrSrchBizLayerSheet4.SetCellValue(gPRow, "searchItemCd", 		result.searchItemCd );
								pwrSrchBizLayerSheet4.SetCellValue(gPRow, "searchItemNm", 		result.searchItemNm );
								pwrSrchBizLayerSheet4.SetCellValue(gPRow, "searchItemDesc",	result.searchItemDesc );
								pwrSrchBizLayerSheet4.SetCellValue(gPRow, "itemMapType", 		result.itemMapType );
								pwrSrchBizLayerSheet4.SetCellValue(gPRow, "prgUrl", 			result.prgUrl );
								pwrSrchBizLayerSheet4.SetCellValue(gPRow, "sqlSyntax", 		result.sqlSyntax );
							}
						}
					]
				});
				layerModal.show();

		    }
		    if(Row > 0 && pwrSrchBizLayerSheet4.ColSaveName(Col) == "inputValueDesc"){
		    	if(!isPopup()) {return;}

		    	gPRow = Row;
		    	pGubun = "pwrSrchInputValuePopup2";

		    	<%--var args 	= new Array();--%>
				<%--args["sheet"] 	= "pwrSrchBizLayerSheet4";--%>
				<%--var url	= "${ctx}/PwrSrchInputValuePopup.do?cmd=pwrSrchInputValuePopup&authPg=${authPg}&adminFlag=no";--%>
				<%--openPopup(url, args, "840","680");--%>

				var args 	= new Array();
				args["operator"] = pwrSrchBizLayerSheet4.GetCellText(Row, "operator").toUpperCase();
				args["valueType"]    = pwrSrchBizLayerSheet4.GetCellValue(Row, "valueType");
				args["searchItemCd"]  = pwrSrchBizLayerSheet4.GetCellValue(Row, "searchItemCd");
				args["inputValue"]  = pwrSrchBizLayerSheet4.GetCellValue(Row, "inputValue");
				args["inputValueDesc"]  = pwrSrchBizLayerSheet4.GetCellValue(Row, "inputValueDesc");
				args["adminFlag"] 	= "no";

				let layerModal = new window.top.document.LayerModal({
					id : 'pwrSrchInputValueLayer'
					, url : '${ctx}/PwrSrchInputValuePopup.do?cmd=viewPwrSrchInputValueLayer&authPg=${authPg}'
					, parameters : args
					, width : 840
					, height : 680
					, title : '조회업무 조회'
					, trigger :[
						{
							name : 'pwrSrchInputValueTrigger'
							, callback : function(result){
								getReturnValue(result, pwrSrchBizLayerSheet4);
							}
						}
					]
				});
				layerModal.show();
		    }
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	function pwrSrchBizLayerSheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg);
			doAction2("Search");
		} catch (ex) { alert("OnSaveEnd Event Error "+ex); }
	}
	
	function pwrSrchBizLayerSheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg);
			doAction3("Search");
		} catch (ex) { alert("OnSaveEnd Event Error "+ex); }
	}
	
	function pwrSrchBizLayerSheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg);
			doAction4("Search");
		} catch (ex) { alert("OnSaveEnd Event Error "+ex); }
	}
	

	function openResult(){
		if(!isPopup()) {return;}
		doAction5("Save");

		let url	= "${ctx}/PwrSrchResultPopup.do?cmd=viewPwrSrchResultLayer&authPg=${authPg}";
		let pwrResultLayer = new window.top.document.LayerModal({
			id: 'pwrResultLayer',
			url: url,
			parameters: { srchSeq: $("#srchSeq").val() },
			width: 940,
			height: 580,
			title: '검색결과 조회'
		});
		pwrResultLayer.show();
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
        sendQuery = sendQuery + orderStatement(pwrSrchBizLayerSheet2, doSortColumn(pwrSrchBizLayerSheet2, "orderBySeq"));
        return sendQuery;
    }

    function selectElement(){
        var element = "";
        loop = pwrSrchBizLayerSheet2.LastRow()+1;
        for(i = 1 ; i < loop ; i++){
            element = element + pwrSrchBizLayerSheet2.GetCellValue(i, "columnNm") + ",";
        }
        element = element.substring(0, element.length-1)+"\n";
        return element;
    }

    function conditionStatement(){
        var condition = "";
        if(pwrSrchBizLayerSheet3.RowCount() > 0){
            loop = pwrSrchBizLayerSheet3.LastRow()+1;
            condition = " WHERE " + "VTBL." + pwrSrchBizLayerSheet3.GetCellValue(1, "columnNm") + " " +pwrSrchBizLayerSheet3.GetCellText(1, "operator")+" " + pwrSrchBizLayerSheet3.GetCellValue(1, "inputValue")+ "\n";
            for(i = 2 ; i < loop ; i++){
                condition = condition + "   "+pwrSrchBizLayerSheet3.GetCellValue(i, "andOr")+" " + "VTBL." + pwrSrchBizLayerSheet3.GetCellValue(i, "columnNm") + " " +pwrSrchBizLayerSheet3.GetCellText(i, "operator")+" " +pwrSrchBizLayerSheet3.GetCellValue(i, "inputValue")+ "\n";
            }
        }

        if(pwrSrchBizLayerSheet4.RowCount() > 0){
            loop = pwrSrchBizLayerSheet4.LastRow()+1;
            if(condition.length == 0){
                condition = condition + " WHERE " +"VTBL." + pwrSrchBizLayerSheet4.GetCellText(1, "columnNm") + " " +pwrSrchBizLayerSheet4.GetCellText(1, "operator")+" &&" +pwrSrchBizLayerSheet4.GetCellText(1, "columnNm")+"&&"+ "\n";
            }else{
            condition = condition + "   "+pwrSrchBizLayerSheet4.GetCellValue(1, "andOr")+" " + "VTBL." + pwrSrchBizLayerSheet4.GetCellText(1, "columnNm") + " " +pwrSrchBizLayerSheet4.GetCellText(1, "operator")+" &&"+pwrSrchBizLayerSheet4.GetCellText(1, "columnNm")+"&&"+ "\n";
            }
            for(i = 2 ; i < loop ; i++){
                condition = condition + "   "+pwrSrchBizLayerSheet4.GetCellValue(i, "andOr")+" " + "VTBL." + pwrSrchBizLayerSheet4.GetCellText(i, "columnNm") + " " +pwrSrchBizLayerSheet4.GetCellText(i, "operator")+" &&" +pwrSrchBizLayerSheet4.GetCellText(i, "columnNm")+"&&"+ "\n";
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
    
    function pwrSrchBizLayerCheckLike(selectSheet,str){
        var selectRow = selectSheet.GetSelectRow();
        if(selectSheet.GetCellText(selectRow, "operator").toUpperCase() == "LIKE"
           || selectSheet.GetCellText(selectRow, "operator").toUpperCase() == "NOT LIKE" ){
            str = "'%"+str+"%'";
        }else{
            str = "'"+str+"'";
        }
        return str;
    }

	function pwrSrchBizLayerCheckLike2(str,opt){

		// var selectRow = sheet.GetSelectRow();
		if(operator == "LIKE"
				|| operator == "NOT LIKE" ){
			if(opt == "front"){
				str = "'"+str+"%'";
			}else if(opt == "rear"){
				str = "'%"+str+"'";
			}else{
				str = "'%"+str+"%'";
			}
		}else if(operator == "IN"
				|| operator == "NOT IN" ){
			if(str.substring(0,1).indexOf("(") == -1 && str.substring(str.length-1).indexOf(")") == -1){
				str = "'"+str+"'";
			}else{
				str = str;
			}
		}else{// LIKE, NOT LIKE, IN, NOT IN이 아닐 시
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
        for(row = 1 ; row <= pwrSrchBizLayerSheet1.LastRow() ; row++){
        	if(pwrSrchBizLayerSheet1.GetCellValue(row, "sCheck") == "1" && checkDup(pwrSrchBizLayerSheet2, "columnNm", pwrSrchBizLayerSheet1.GetCellValue(row, "columnNm"))){
            	var newRow = pwrSrchBizLayerSheet2.DataInsert(0);
                pwrSrchBizLayerSheet2.SetCellValue(newRow, "searchSeq",$("#srchSeq").val());
                pwrSrchBizLayerSheet2.SetCellValue(newRow, "columnNm", pwrSrchBizLayerSheet1.GetCellValue(row, "columnNm") );
                pwrSrchBizLayerSheet2.SetCellValue(newRow, "seq", (parseInt(parseInt(getColMaxValue(pwrSrchBizLayerSheet2, "seq"))/10)+1)*10 );
        	}
        }
        initCheck();
    }

    function mvConfitionElement(){
        for(row = 1 ; row <= pwrSrchBizLayerSheet1.LastRow() ; row++){
            if(pwrSrchBizLayerSheet1.GetCellValue(row, "sCheck") == "1" && checkDup(pwrSrchBizLayerSheet3, "columnNm", pwrSrchBizLayerSheet1.GetCellValue(row, "columnNm"))){
                if(checkDup(pwrSrchBizLayerSheet4, "columnNm", pwrSrchBizLayerSheet1.GetCellValue(row, "columnNm"))){
                    var newRow = pwrSrchBizLayerSheet3.DataInsert(0);
                    pwrSrchBizLayerSheet3.SetCellValue(newRow, "searchSeq", 	$("#srchSeq").val());
                    pwrSrchBizLayerSheet3.SetCellValue(newRow, "columnNm", 	pwrSrchBizLayerSheet1.GetCellValue(row, "columnNm") );
                    pwrSrchBizLayerSheet3.SetCellValue(newRow, "condType", 	"F" );
                    pwrSrchBizLayerSheet3.SetCellValue(newRow, "searchItemCd", pwrSrchBizLayerSheet1.GetCellValue(row, "searchItemCd") );
                    pwrSrchBizLayerSheet3.SetCellValue(newRow, "searchItemNm", pwrSrchBizLayerSheet1.GetCellValue(row, "searchItemNm") );
                    pwrSrchBizLayerSheet3.SetCellValue(newRow, "itemMapType", 	pwrSrchBizLayerSheet1.GetCellValue(row, "itemMapType") );
                    pwrSrchBizLayerSheet3.SetCellValue(newRow, "prgUrl", 		pwrSrchBizLayerSheet1.GetCellValue(row, "prgUrl") );
                    pwrSrchBizLayerSheet3.SetCellValue(newRow, "sqlSyntax", 	pwrSrchBizLayerSheet1.GetCellValue(row, "sqlSyntax") );
                    pwrSrchBizLayerSheet3.SetCellValue(newRow, "inputValue",	"''");
                    if( pwrSrchBizLayerSheet1.GetCellValue(row, "searchItemCd")){
                        pwrSrchBizLayerSheet3.SetCellValue(newRow, "valueType", pwrSrchBizLayerSheet1.SetCellValue(row, "valueType", "dfCode") );
                    }
                }else{
                    alert("\""+pwrSrchBizLayerSheet1.GetCellValue(row, "columnNm")+"\"가  사용자입력 조건항목에 존재합니다.");
                }
            }
        }
        initCheck();
    }

    function mvUserConfitionElement(){
        for(row = 1 ; row <= pwrSrchBizLayerSheet1.LastRow() ; row++){
            if(pwrSrchBizLayerSheet1.GetCellValue(row, "sCheck") == "1" && checkDup(pwrSrchBizLayerSheet4, "columnNm", pwrSrchBizLayerSheet1.GetCellValue(row, "columnNm"))){
                if(checkDup(pwrSrchBizLayerSheet3, "columnNm", pwrSrchBizLayerSheet1.GetCellValue(row, "columnNm"))){
                    var newRow = pwrSrchBizLayerSheet4.DataInsert(0);
                    pwrSrchBizLayerSheet4.SetCellValue(newRow, "searchSeq", 	$("#srchSeq").val() );
                    pwrSrchBizLayerSheet4.SetCellValue(newRow, "columnNm", 	pwrSrchBizLayerSheet1.GetCellValue(row, "columnNm") );
                    pwrSrchBizLayerSheet4.SetCellValue(newRow, "condType", 	"U" );
                    pwrSrchBizLayerSheet4.SetCellValue(newRow, "searchItemCd", pwrSrchBizLayerSheet1.GetCellValue(row, "searchItemCd") );
                    pwrSrchBizLayerSheet4.SetCellValue(newRow, "searchItemNm", pwrSrchBizLayerSheet1.GetCellValue(row, "searchItemNm") );
                    pwrSrchBizLayerSheet4.SetCellValue(newRow, "itemMapType", 	pwrSrchBizLayerSheet1.GetCellValue(row, "itemMapType") );
                    pwrSrchBizLayerSheet4.SetCellValue(newRow, "prgUrl", 		pwrSrchBizLayerSheet1.GetCellValue(row, "prgUrl") );
                    pwrSrchBizLayerSheet4.SetCellValue(newRow, "sqlSyntax", 	pwrSrchBizLayerSheet1.GetCellValue(row, "sqlSyntax") );
                    pwrSrchBizLayerSheet4.SetCellValue(newRow, "inputValue", 	"''" );
                    if( pwrSrchBizLayerSheet1.GetCellValue(row, "searchItemCd")){
                        pwrSrchBizLayerSheet4.SetCellValue(newRow, "valueType", pwrSrchBizLayerSheet1.SetCellValue(row, "valueType", "dfCode") );
                    }
                }else{
                    alert("\""+pwrSrchBizLayerSheet1.GetCellValue(row, "columnNm")+"\"가  고정조건항목에 존재합니다.");
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
        for(i = 0 ; i <= pwrSrchBizLayerSheet1.LastRow() ; i++){
            pwrSrchBizLayerSheet1.GetCellValue(i, "sCheck",0);
            pwrSrchBizLayerSheet1.GetCellText(i, "sCheck","<tit:txt mid='111914' mdef='선택'/>");
        }
    }

	//팝업 콜백 함수.
	function getReturnValue(result, sheet) {
		let ymd 		= result.ymd;
		let ym			= result.ym;
		let sYmd 		= result.sYmd;
		let eYmd 		= result.eYmd;
		let sYm 		= result.sYm;
		let eYm 		= result.eYm;
		let sVal 		= result.sVal;
		let eVal 		= result.eVal;
		let vall 		= result.vall;
		let valDesc 	= result.valDesc;
		let resNo		= result.resNo;
		let etcData 	= result.etcData;
		let likeOpt		= result.likeOpt;
debugger
		if(sheet.GetCellText(gPRow, "operator").toUpperCase() == "BETWEEN"){
			if(sheet.GetCellValue(gPRow, "valueType") == "dfDateYmd"){
				if(sYmd != "" && eYmd != ""){
					if(checkDateCtl("",sYmd, eYmd)){
						sheet.SetCellValue(gPRow, "inputValue","'"+sYmd.split("-").join("")+"'" + " AND " + "'"+eYmd.split("-").join("")+"'");
						sheet.SetCellValue(gPRow, "inputValueDesc",sYmd + "일에서 " + eYmd+"일까지");
					}else{
						return;
					}
				}else if(sYmd == "" && eYmd == ""){
					sheet.SetCellValue(gPRow, "inputValue",pwrSrchBizLayerCheckLike2('','all'));
					sheet.SetCellValue(gPRow, "inputValueDesc","");
				}else{
					alert("<msg:txt mid='alertInputSdateEdate' mdef='시작일과 종료일을 입력하세요.'/>");
					return;
				}
			}else if(sheet.GetCellValue(gPRow, "valueType") == "dfDateYm"){
				if(sYm != "" && eYm != ""){
					if(checkDateCtl("",sYm, eYm)){
						sheet.SetCellValue(gPRow, "inputValue","'"+sYm.split("-").join("")+"'" + " AND " + "'"+eYm.split("-").join("")+"'");
						sheet.SetCellValue(gPRow, "inputValueDesc",sYm + "월에서 " + eYm+"월까지");
					}else{
						return;
					}
				}else if(sYm == "" && eYm == ""){
					sheet.SetCellValue(gPRow, "inputValue",pwrSrchBizLayerCheckLike2('','all'));
					sheet.SetCellValue(gPRow, "inputValueDesc","");
				}else{
					alert("<msg:txt mid='alertInputSdateEdate' mdef='시작일과 종료일을 입력하세요.'/>");
					return;
				}
			}else{
				sheet.SetCellValue(gPRow, "inputValue","'"+sVal+"'" + " AND " + "'"+eVal+"'");
				sheet.SetCellValue(gPRow, "inputValueDesc",sVal + "에서 " + eVal+"까지");
			}
		}else{
			if(sheet.GetCellValue(gPRow, "searchItemCd") != ""){
				sheet.SetCellValue(gPRow, "inputValue",pwrSrchBizLayerCheckLike2(vall, likeOpt ));
				sheet.SetCellValue(gPRow, "inputValueDesc",valDesc);
			}else{
				if(sheet.GetCellValue(gPRow, "valueType") == "dfDateYmd"){
					sheet.SetCellValue(gPRow, "inputValue","'"+ymd.split("-").join("")+"'");
					sheet.SetCellValue(gPRow, "inputValueDesc",ymd);
				}else if(sheet.GetCellValue(gPRow, "valueType") == "dfDateYm"){
					sheet.SetCellValue(gPRow, "inputValue","'"+ym.split("-").join("")+"'");
					sheet.SetCellValue(gPRow, "inputValueDesc",ym);
				}else if(sheet.GetCellValue(gPRow, "valueType") == "dfIdNo"){
					sheet.SetCellValue(gPRow, "inputValue","'"+resNo+"'");
					sheet.SetCellValue(gPRow, "inputValueDesc",resNo);
				}else if(sheet.GetCellValue(gPRow, "valueType") == "dfNumber"){
					sheet.SetCellValue(gPRow, "inputValue",etcData);
					sheet.SetCellValue(gPRow, "inputValueDesc",etcData);
				}else{
					if(sheet.GetCellText(gPRow, "operator").toUpperCase() == "IN"
							|| sheet.GetCellText(gPRow, "operator").toUpperCase() == "NOT IN"){
						sheet.SetCellValue(gPRow, "inputValue","("+etcData+")");
					}else{
						sheet.SetCellValue(gPRow, "inputValue",pwrSrchBizLayerCheckLike2(etcData,  likeOpt));
					}
					sheet.SetCellValue(gPRow, "inputValueDesc",etcData);
				}
			}
		}
	}

</script>
</head>
<body class="bodywrap">

<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="sheetForm" name="sheetForm">
			<input id="srchSeq" 	name="srchSeq"  type="Hidden"/>
			<input id="viewCd" 		name="viewCd"  	type="Hidden"/>
			<input id="viewNm" 		name="viewNm"   type="Hidden"/>
			<input id="viewDesc" 	name="viewDesc" type="Hidden"/>
			<input id="srchDesc" 	name="srchDesc" type="Hidden"/>
			<input id="condTYpe"	name="condType" type="Hidden"/>
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="29%" />
			<col width="0px" />
			<col width="" />
			<col width="69%" />
		</colgroup>
		<tr>
			<td rowspan="3">
				<div class="sheet_title inner">
				<ul>
					<li class="txt"><tit:txt mid='pwrSrchAdminUser3' mdef='사용자입력 조건항목 설정'/></li>
				</ul>
				</div>
				<div id="pwrSrchBizLayerSheet1-wrap"></div>
				<!-- <script type="text/javascript"> createIBSheet("pwrSrchBizLayerSheet1", "30%", "100%", "${ssnLocaleCd}"); </script> -->
			</td>
			<td rowspan="3"></td>
			<td class="sheet_arrow">
				<div class="sheet_button">
					<a href="javascript:mvSearchElement();" class="btn outline_gray icon"><i class="mdi-ico">chevron_right</i></a>
				</div>
			</td>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='104254' mdef='조회항목 설정'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction2('Save');" css="btn filled authA" mid='110708' mdef="저장"/>
							<btn:a href="javascript:doAction2('Search');" css="btn dark authR" mid='110697' mdef="조회"/>
						</li>
					</ul>
					</div>
				</div>
				<div id="pwrSrchBizLayerSheet2-wrap"></div>
				<!-- <script type="text/javascript"> createIBSheet("pwrSrchBizLayerSheet2", "70%", "33%", "${ssnLocaleCd}"); </script> -->
			</td>
		</tr>

		<tr>
			<td class="sheet_arrow">
				<div class="sheet_button">
					<a href="javascript:mvConfitionElement()" 		class="btn outline_gray icon"><i class="mdi-ico">chevron_right</i></a>
				</div>
			</td>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='104055' mdef='고정 조건항목 설정'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction3('Save');" css="btn filled authA" mid='110708' mdef="저장"/>
							<btn:a href="javascript:doAction3('Search');" css="btn dark authR" mid='110697' mdef="조회"/>
						</li>
					</ul>
					</div>
				</div>
				<div id="pwrSrchBizLayerSheet3-wrap"></div>
				<!-- <script type="text/javascript"> createIBSheet("pwrSrchBizLayerSheet3", "70%", "33%", "${ssnLocaleCd}"); </script> -->
			</td>
		</tr>

		<tr>
			<td class="sheet_arrow">
				<div class="sheet_button">
					<a href="javascript:mvUserConfitionElement()" class="btn outline_gray icon"><i class="mdi-ico">chevron_right</i></a>
				</div>
			</td>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='pwrSrchAdminUser3' mdef='사용자입력 조건항목 설정'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction4('Save');" css="btn filled authA" mid='110708' mdef="저장"/>
							<btn:a href="javascript:doAction4('Search');" css="btn dark authR" mid='110697' mdef="조회"/>
						</li>
					</ul>
					</div>
				</div>
				<div id="pwrSrchBizLayerSheet4-wrap"></div>
				<!-- <script type="text/javascript"> createIBSheet("pwrSrchBizLayerSheet4", "70%", "33%", "${ssnLocaleCd}"); </script> -->
			</td>
		</tr>
		</table>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('pwrSrchBizLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
		<btn:a href="javascript:openResult();" css="btn filled" mid='110710' mdef="검색결과"/>
	</div>
</div>

<div id="tmpSave" class="hide">
	<div id="pwrSrchBizLayerSheet5-wrap"></div>
	<!-- <script type="text/javascript"> createIBSheet("pwrSrchBizLayerSheet5", "100%", "100%", "${ssnLocaleCd}"); </script> -->
</div>

</body>
</html>


