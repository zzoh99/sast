<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='112192' mdef='승진년차'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No|No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제|삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태|상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='pmtCd_V1' mdef='승진명부코드|승진명부코드'/>",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"pmtCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:15 },
			
			{Header:"<sht:txt mid='baseJikweeCd' mdef='원직위|원직위'/>",				Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"baseJikweeCd",KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='tarJikweeCd' mdef='승진직위|승진직위'/>",				Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"tarJikweeCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='tarJikgubCd' mdef='승진직급|승진직급'/>",				Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"tarJikgubCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:15 },
			{Header:"<sht:txt mid='pmtYear' mdef='승진년한|승진년한'/>",					Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pmtYear",		KeyField:1,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"직종유형|직종유형",													Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"pmtPositionType",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"SPA 기준점수|SPA 기준점수",											Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"spaPoint",	KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"평가반영비율(%)|업적비율",											Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"mboRate",		KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"평가반영비율(%)|역량비율",											Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compRate",	KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"평가적용년한|평가적용년한",											Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adtYyCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"년차별 평가반영비율(%)|1년차",										Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"papRate1",	KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"년차별 평가반영비율(%)|2년차",										Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"papRate2",	KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"년차별 평가반영비율(%)|3년차",										Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"papRate3",	KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"년차별 평가반영비율(%)|4년차",										Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"papRate4",	KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"년차별 평가반영비율(%)|5년차",										Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"papRate5",	KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"년차별 평가반영비율(%)|6년차",										Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"papRate6",	KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"기준포인트|기준포인트",											Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appPoint",	KeyField:1,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
				
		//승진직급
		var userCd1 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "");
		sheet1.SetColProperty("tarJikgubCd", 		{ComboText:userCd1[0], ComboCode:userCd1[1]} );
		
		//원직위, 승진직위
		var userCd3 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");
		sheet1.SetColProperty("baseJikweeCd", 			{ComboText:userCd3[0], ComboCode:userCd3[1]} );
		sheet1.SetColProperty("tarJikweeCd", 			{ComboText:userCd3[0], ComboCode:userCd3[1]} );
		
		//평가적용연한
		var userCd2 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20650"), "");
		sheet1.SetColProperty("adtYyCd", 				{ComboText:userCd2[0], ComboCode:userCd2[1]} );
		
		sheet1.SetFocusAfterProcess(0);
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var pmtCd = parent.sheet1.GetCellValue(parent.sheet1.GetSelectRow(),"pmtCd");
			if( pmtCd && pmtCd != null && pmtCd == "-1" ) pmtCd = "";
			sheet1.DoSearch( "${ctx}/PromStdMgr.do?cmd=getPromStdStayList", "pmtCd="+pmtCd );
			break;
		case "Save":

			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/PromStdMgr.do?cmd=savePromStdStay", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var pmtCd = parent.sheet1.GetCellValue(parent.sheet1.GetSelectRow(),"pmtCd");
			
			if(pmtCd == "") {
				alert("<msg:txt mid='110176' mdef='[승진기준]을 선택하여 주십시오.'/>");
				return;
			}
			
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row,"pmtCd",pmtCd);
			break;
		case "Copy":
			sheet1.DataCopy(); 
			break;
		case "Clear":		
			sheet1.RemoveAll(); 
			break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "승진년차_" + d.getTime();
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			}
			
			sheetResize();

		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") {
				alert(Msg); 
			}
			
			doAction1("Search");
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
	<div class="wrapper">
	
		<div class="inner">
			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='112192' mdef='승진년차'/></li>
				<li class="btn">
					<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
					<btn:a href="javascript:doAction1('Copy');" css="btn outline-gray authA" mid='copy' mdef="복사"/>
					<btn:a href="javascript:doAction1('Insert');" css="btn outline-gray authA" mid='insert' mdef="입력"/>
					<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
				</li>
			</ul>
			</div>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	</div>
</body>
</html>
