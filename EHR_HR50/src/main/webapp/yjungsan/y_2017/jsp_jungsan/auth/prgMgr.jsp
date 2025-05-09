<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>프로그램관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
			{Header:"삭제",		Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
			{Header:"상태",		Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
			{Header:"프로그램",		Type:"Text",	Hidden:0,	Width:140,	Align:"Left",   ColMerge:0,   SaveName:"prg_cd",		KeyField:1,   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"프로그램명",	Type:"Text",	Hidden:0,	Width:135,	Align:"Left",   ColMerge:0,   SaveName:"prg_nm",		KeyField:0,   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"프로그램영문명",	Type:"Text",	Hidden:1,	Width:100,	Align:"Left",   ColMerge:0,   SaveName:"prg_eng_nm",	KeyField:0,   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"PATH",		Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,   SaveName:"prg_path",		KeyField:0,   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"사용",		Type:"Combo",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,   SaveName:"use",			KeyField:0,   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"버전",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,   SaveName:"version",		KeyField:0,   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"메모",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,   SaveName:"memo",			KeyField:0,   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"Track",	Type:"Combo",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,   SaveName:"date_track_yn",	KeyField:0,   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"로그여부",		Type:"Combo",	Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,   SaveName:"log_save_yn",	KeyField:0,   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);
	
		sheet1.SetColProperty("use", 			{ComboText:"사용|사용안함", ComboCode:"Y|N"} );
		sheet1.SetColProperty("date_track_n", 	{ComboText:"유|무", 	ComboCode:"Y|N"} );
		sheet1.SetColProperty("log_save_yn", 	{ComboText:"Y|N", ComboCode:"Y|N"} );
		
		$("#srchPrgCd,#srchPrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});
		
		$(window).smartresize(sheetResize); sheetInit();
	    doAction1("Search");
	});
	
	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/auth/prgMgrRst.jsp?cmd=selectPrgMgr", $("#sheet1Form").serialize() );
			break;
		case "Save"	:	
			if(!dupChk(sheet1,"prg_cd", true, true)){break;}
			sheet1.DoSave( "<%=jspPath%>/auth/prgMgrRst.jsp?cmd=savePrgMgr"); 
			break;
		case "Insert":
			sheet1.SelectCell(sheet1.DataInsert(0)); 
			break;
		case "Copy":
			sheet1.SelectCell(sheet1.DataCopy());
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			sheet1.Down2Excel();
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>프로그램명</span>
							<input id="srchPrgNm" name ="srchPrgNm" type="text" class="text" />
						</td>
						<td>
							<span>프로그램</span>
							<input id="srchPrgCd" name ="srchPrgCd" type="text" class="text" />
						</td>
						<td>
							<span>사용유무</span>
							<select id="srchUse" name ="srchUse">
								<option value="">전체</option>
								<option value="Y">사용</option>
								<option value="N">사용안함</option>
							</select>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">프로그램관리</li>
							<li class="btn">
								<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>