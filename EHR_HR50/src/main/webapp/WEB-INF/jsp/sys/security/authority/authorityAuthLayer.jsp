<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='prgMng' mdef='프로그램관리'/></title>
<!-- ajax error -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>


<script type="text/javascript">
	var authorityAuthLayer = { id: 'authorityAuthLayer' };
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal(authorityAuthLayer.id);
		var { athGrpCd } = modal.parameters;
		$("#athGrpCd").val(athGrpCd);

		createIBSheet3(document.getElementById('authScopeSheet_wrap'), "authScopeSheet", "100%", "100%", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('authSelectSheet_wrap'), "authSelectSheet", "100%", "100%", "${ssnLocaleCd}");

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",					Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",					Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='authScopeCdV1' mdef='범위항목코드'/>",			Type:"Text",		Hidden:1,					Width:0,			Align:"Left",	ColMerge:0,	SaveName:"authScopeCd",	UpdateEdit:0 },
			{Header:"<sht:txt mid='authScopeNmV1' mdef='[ 등록 범위항목 ]'/>",	Type:"Text",		Hidden:0,					Width:165,			Align:"Left",	ColMerge:0,	SaveName:"authScopeNm",	UpdateEdit:0,	ImgAlign:"Right"},
			{Header:"<sht:txt mid='sqlSyntaxV3' mdef='SQL_SYNTAX'/>",			Type:"Text",		Hidden:1,					Width:165,			Align:"Left",	ColMerge:0,	SaveName:"sqlSyntax",	UpdateEdit:0 }
		];IBS_InitSheet(authScopeSheet, initdata);authScopeSheet.SetCountPosition(4); authScopeSheet.SetImageList(0,"${ctx}/common/images/icon/icon_quest.png");authScopeSheet.SetEditableColorDiff (0);
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",					Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='authScopeCdV1' mdef='범위항목코드'/>",			Type:"Text",		Hidden:1,					Width:0,			Align:"Left",	ColMerge:0,	SaveName:"authScopeCd",	UpdateEdit:0 },
			{Header:"<sht:txt mid='authScopeNm_V517' mdef='[ 등록가능범위항목 ]'/>",Type:"Text",		Hidden:0,					Width:165,			Align:"Left",	ColMerge:0,	SaveName:"authScopeNm",	UpdateEdit:0,	ImgAlign:"Right" },
			{Header:"<sht:txt mid='sqlSyntaxV3' mdef='SQL_SYNTAX'/>",			Type:"Text",		Hidden:1,					Width:165,			Align:"Left",	ColMerge:0,	SaveName:"sqlSyntax",	UpdateEdit:0,	ImgAlign:"Right" },
			{Header:"<sht:txt mid='chkV1' mdef='등록'/>",					Type:"${sDelTy}",	Hidden:0,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" }

		];IBS_InitSheet(authSelectSheet, initdata);authSelectSheet.SetCountPosition(4); authSelectSheet.SetImageList(0,"${ctx}/common/images/icon/icon_quest.png");authSelectSheet.SetEditableColorDiff (0);

// 		$(window).smartresize(sheetResize);
		sheetInit();
		doAction("SearchLeft");
		doAction("SearchRight");
		$("#ibs").show();
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "SearchLeft":		authScopeSheet.DoSearch( "${ctx}/Authority.do?cmd=getAthRangeMgrLeftList", $("#mySheetForm").serialize() ); break;
		case "SearchRight":		authSelectSheet.DoSearch( "${ctx}/Authority.do?cmd=getAthRangeMgrRightList", $("#mySheetForm").serialize() ); break;
		case "Down2ExcelLeft":	authScopeSheet.Down2Excel(); break;
		case "Down2ExcelRight":	authSelectSheet.Down2Excel(); break;
		case "Reg":
					IBS_SaveName(document.mySheetForm,authSelectSheet);
					authSelectSheet.DoSave("${ctx}/Authority.do?cmd=insertAthRangeMgr",  $("#mySheetForm").serialize() ); break;
		case "Del":
					IBS_SaveName(document.mySheetForm,authScopeSheet);
					authScopeSheet.DoSave("${ctx}/Authority.do?cmd=deleteAthRangeMgr",  $("#mySheetForm").serialize() ); break;
		}
	}

	// authScopeSheet 조회 후 에러 메시지
	function authScopeSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	// authScopeSheet 저장 후 메시지
	function authScopeSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); doAction("SearchLeft");doAction("SearchRight");} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	function authScopeSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if(Row > 0 && authScopeSheet.ColSaveName(Col) == "detail"){
	    	detailLeftPopup("Left", Row);
	    }
	}

	function authScopeSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if(authScopeSheet.ColSaveName(Col)=="authScopeNm") {
			alert(authScopeSheet.GetCellValue(Row, "sqlSyntax"));
		}
	}

	// authSelectSheet 조회 후 에러 메시지
	function authSelectSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	// authSelectSheet 저장 후 메시지
	function authSelectSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); doAction("SearchLeft");doAction("SearchRight");} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	function authSelectSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if(Row > 0 && authSelectSheet.ColSaveName(Col) == "detail"){
			detailLeftPopup("Right", Row);
	    }
	}

	function authSelectSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if(authSelectSheet.ColSaveName(Col)=="authScopeNm") {
			alert(authSelectSheet.GetCellValue(Row, "sqlSyntax"));
		}
	}

	function detailLeftPopup(pos, Row){
		var args 	= new Array();
		args["athGrpCd"] 	= $("#athGrpCd").val();
		var url ="";
		if( pos == "Left"){
			args["mainMenuCd"] 	= authScopeSheet.GetCellValue(Row, "mainMenuCd");
			url 	= "${ctx}/AthGrpMenuMgr.do?cmd=athGrpMenuMgrRegPopup";
		}else{
			args["mainMenuCd"] 	= authSelectSheet.GetCellValue(Row, "mainMenuCd");
			url 	= "${ctx}/AthGrpMenuMgr.do?cmd=athGrpMenuMgrNoneRegPopup";
		}
		var rv = openPopup(url, args, "1200","800");
	}

</script>

</head>

<body class="bodywrap">

	<form id="mySheetForm" name="mySheetForm">
		<input id="athGrpCd" 	name="athGrpCd"		type="hidden"/>
	</form>

	<div class="wrapper modal_layer">
		<div class="modal_body">
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<colgroup>
					<col width="" />
					<col width="" />
					<col width="" />
				</colgroup>
				<tr>
					<td>
						<div class="inner">
							<div class="sheet_title">
							<ul>
								<li class="txt"><tit:txt mid='114358' mdef='등록범위항목 '/></li>
								<li class="btn">
								</li>
							</ul>
							</div>
						</div>
						<div id="authScopeSheet_wrap"></div>
						<!-- <script type="text/javascript"> createIBSheet("authScopeSheet", "50%", "100%", "${ssnLocaleCd}"); </script> -->
					</td>
					<td class="sheet_arrow">
						<a href="javascript:doAction('Del');" class="basic">&gt;</a><br/><br/>
						<a href="javascript:doAction('Reg');" class="basic">&lt;</a>
					</td>
					<td>
						<div class="inner">
							<div class="sheet_title">
							<ul>
								<li class="txt"><tit:txt mid='112928' mdef='등록가능범위항목 '/></li>
								<li class="btn">
								</li>
							</ul>
							</div>
						</div>
						<div id="authSelectSheet_wrap"></div>
						<!-- <script type="text/javascript"> createIBSheet("authSelectSheet", "50%", "100%", "${ssnLocaleCd}"); </script> -->
					</td>
				</tr>
			</table>
		</div>
		<div class="modal_footer">
				<btn:a href="javascript:closeCommonLayer('authorityAuthLayer')" css="btn outline_gray" mid='110881' mdef="닫기"/>
		</div>
	</div>
</body>
</html>
