<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='114687' mdef='퇴직처리담당자관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [		
			{Header:"<sht:txt mid='sNoV1' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDeleteV1' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatusV1' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"<sht:txt mid='chkItem' mdef='항목'/>",		Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"chkItem",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000,Wrap:1, MultiLineText:1 },
			{Header:"<sht:txt mid='orgNm' mdef='소속'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikweeNm' mdef='직위'/>",		Type:"Text",		Hidden:Number("${jwHdn}") ,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
			{Header:"<sht:txt mid='sabun' mdef='사번'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
			{Header:"<sht:txt mid='name' mdef='성명'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
			{Header:"<sht:txt mid='orderSeq' mdef='순서'/>",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"orderSeq",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='seq' mdef='seq'/>",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			
			{Header:"<sht:txt mid='rmk' mdef='비고'/>",			Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"rmk",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000, Wrap:1, MultiLineText:1 }
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4); 
		
		$(sheet1).sheetAutocomplete({
		  	Columns: [{ ColSaveName : "name" }]
		}); 	
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param ="";
			sheet1.DoSearch( "${ctx}/RetireJobMgr.do?cmd=getRetireJobMgrList",param );
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1); 
			sheet1.DoSave( "${ctx}/RetireJobMgr.do?cmd=saveRetireJobMgr", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row,"seq","");
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row,"seq","");
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
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

	 
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		
	 	if(pGubun == "sheetAutocomplete"){
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"] );
			sheet1.SetCellValue(gPRow, "name", rv["name"] );
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"] );
			sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"] );
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
			<li class="txt"><tit:txt mid='113617' mdef='퇴직업무담당자관리'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
				<btn:a href="javascript:doAction1('Copy');" css="btn outline-gray authA" mid='copy' mdef="복사"/>
				<btn:a href="javascript:doAction1('Insert');" css="btn outline-gray authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Search');" css="btn dark authA" mid='search' mdef="조회"/>
			</li>
		</ul>
		</div>
	</div>
	
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
