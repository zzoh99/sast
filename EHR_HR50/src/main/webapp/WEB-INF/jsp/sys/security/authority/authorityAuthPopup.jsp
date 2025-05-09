<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='prgMng' mdef='프로그램관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		var arg = p.window.dialogArguments;

		var athGrpCd = "";

		if( arg != undefined ){
			athGrpCd = arg["athGrpCd"];
		}else{
			if(p.popDialogArgument("athGrpCd")!=null)		athGrpCd  	= p.popDialogArgument("athGrpCd");
		}
		//sheet1.SetDataLinkMouse("detail", 1);
		$("#athGrpCd").val(athGrpCd);

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",					Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",					Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='authScopeCdV1' mdef='범위항목코드'/>",			Type:"Text",		Hidden:1,					Width:0,			Align:"Left",	ColMerge:0,	SaveName:"authScopeCd",	UpdateEdit:0 },
			{Header:"<sht:txt mid='authScopeNmV1' mdef='[ 등록 범위항목 ]'/>",	Type:"Text",		Hidden:0,					Width:165,			Align:"Left",	ColMerge:0,	SaveName:"authScopeNm",	UpdateEdit:0,	ImgAlign:"Right"},
			{Header:"<sht:txt mid='sqlSyntaxV3' mdef='SQL_SYNTAX'/>",			Type:"Text",		Hidden:1,					Width:165,			Align:"Left",	ColMerge:0,	SaveName:"sqlSyntax",	UpdateEdit:0 }
		];IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4); sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_quest.png");sheet1.SetEditableColorDiff (0);
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",					Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='authScopeCdV1' mdef='범위항목코드'/>",			Type:"Text",		Hidden:1,					Width:0,			Align:"Left",	ColMerge:0,	SaveName:"authScopeCd",	UpdateEdit:0 },
			{Header:"<sht:txt mid='authScopeNm_V517' mdef='[ 등록가능범위항목 ]'/>",Type:"Text",		Hidden:0,					Width:165,			Align:"Left",	ColMerge:0,	SaveName:"authScopeNm",	UpdateEdit:0,	ImgAlign:"Right" },
			{Header:"<sht:txt mid='sqlSyntaxV3' mdef='SQL_SYNTAX'/>",			Type:"Text",		Hidden:1,					Width:165,			Align:"Left",	ColMerge:0,	SaveName:"sqlSyntax",	UpdateEdit:0,	ImgAlign:"Right" },
			{Header:"<sht:txt mid='chkV1' mdef='등록'/>",					Type:"${sDelTy}",	Hidden:0,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" }

		];IBS_InitSheet(sheet2, initdata);sheet2.SetCountPosition(4); sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_quest.png");sheet2.SetEditableColorDiff (0);

// 		$(window).smartresize(sheetResize);
		sheetInit();
		doAction("SearchLeft");
		doAction("SearchRight");
		$("#ibs").show();

		$(".close").click(function() {
			p.self.close();
		});
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "SearchLeft":		sheet1.DoSearch( "${ctx}/Authority.do?cmd=getAthRangeMgrLeftList", $("#mySheetForm").serialize() ); break;
		case "SearchRight":		sheet2.DoSearch( "${ctx}/Authority.do?cmd=getAthRangeMgrRightList", $("#mySheetForm").serialize() ); break;
		case "Down2ExcelLeft":	sheet1.Down2Excel(); break;
		case "Down2ExcelRight":	sheet2.Down2Excel(); break;
		case "Reg":
					IBS_SaveName(document.mySheetForm,sheet2);
					sheet2.DoSave("${ctx}/Authority.do?cmd=insertAthRangeMgr",  $("#mySheetForm").serialize() ); break;
		case "Del":
					IBS_SaveName(document.mySheetForm,sheet1);
					sheet1.DoSave("${ctx}/Authority.do?cmd=deleteAthRangeMgr",  $("#mySheetForm").serialize() ); break;
		}
	}

	// sheet1 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	// sheet1 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); doAction("SearchLeft");doAction("SearchRight");} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
	    	detailLeftPopup("Left", Row);
	    }
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if(sheet1.ColSaveName(Col)=="authScopeNm") {
			alert(sheet1.GetCellValue(Row, "sqlSyntax"));
		}
	}

	// sheet2 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	// sheet2 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); doAction("SearchLeft");doAction("SearchRight");} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if(Row > 0 && sheet2.ColSaveName(Col) == "detail"){
			detailLeftPopup("Right", Row);
	    }
	}

	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if(sheet2.ColSaveName(Col)=="authScopeNm") {
			alert(sheet2.GetCellValue(Row, "sqlSyntax"));
		}
	}



	function detailLeftPopup(pos, Row){
		var args 	= new Array();
		args["athGrpCd"] 	= $("#athGrpCd").val();
		var url ="";
		if( pos == "Left"){
			args["mainMenuCd"] 	= sheet1.GetCellValue(Row, "mainMenuCd");
			url 	= "${ctx}/AthGrpMenuMgr.do?cmd=athGrpMenuMgrRegPopup";
		}else{
			args["mainMenuCd"] 	= sheet2.GetCellValue(Row, "mainMenuCd");
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

	<div class="wrapper">
		<div class="popup_title">
		<ul>
			<li><tit:txt mid='authorityAuthPop' mdef='권한범위설정'/></li>
			<li class="close"></li>
		</ul>
		</div>

		<div class="popup_main">


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
						<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
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
						<script type="text/javascript"> createIBSheet("sheet2", "50%", "100%", "${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>


			<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
			</div>
		</div>
	</div>
</body>
</html>
