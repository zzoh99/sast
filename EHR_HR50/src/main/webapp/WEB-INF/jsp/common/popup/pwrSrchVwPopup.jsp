<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113456' mdef='조건검색View Popup'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var openSheet = null;

	$(function() {
		var arg = p.popDialogArgumentAll();

		if( arg != undefined ) {
			openSheet 	=  p.popDialogSheet(arg["openSheet"]);
		}

		//openSheet = dialogArguments["openSheet"];
		
		$(".close, #close").click(function() {
			p.self.close();
		});

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
		  	{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus", Sort:0 },
        	{Header:"<sht:txt mid='viewCdV2' mdef='View코드'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"viewCd",	KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='viewNmV1' mdef='View명'/>",	Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"viewNm",	KeyField:1,	Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",		Type:"Text",	Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"seq",		KeyField:0,	Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='viewDescV1' mdef='View설명'/>",	Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"viewDesc",KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetEditable(false);sheet1.SetVisible(true);

		$("#viewNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search"); $(this).focus();
			}
		});
		$(window).smartresize(sheetResize); sheetInit();
		//sheet1.SetVisible(1);
	    doAction("Search");
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			sheet1.DoSearch( "${ctx}/PwrSrchVwPopup.do?cmd=getPwrSrchVwPopupList", $("#sheetForm").serialize() );
			break;
		}
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {
		var returnValue = new Array(4);
		returnValue["viewCd"] 	= sheet1.GetCellValue(Row,"viewCd");
		returnValue["viewNm"] 	= sheet1.GetCellValue(Row,"viewNm");
		returnValue["viewDesc"] = sheet1.GetCellValue(Row,"viewDesc");

		p.popReturnValue(returnValue);
		p.window.close();
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='pwrSrchVwPop1' mdef='업무별 조건검색 뷰항목 조회'/></li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">
		<div class="sheet_search outer">
			<div>
				<form id="sheetForm" name="sheetForm" >
					<table>
						<tr>
							<th><tit:txt mid='113698' mdef='View 명'/></th>
							<td>
								<input id="viewNm" name ="viewNm" type="text" class="text" />
							</td>
							<td>
								<btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='pwrSrchVmMgr' mdef='조건검색View관리'/></li>
						<li class="btn">
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
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



