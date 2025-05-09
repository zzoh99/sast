<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113456' mdef='조건검색View Popup'/></title>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>



<script type="text/javascript">
	var pwrSrchVwLayer = {id:'pwrSrchVwLayer'};
	$(function() {
		createIBSheet3(document.getElementById('condsheet-wrap'), "condsheet", "100%", "100%", "${ssnLocaleCd}");
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
		  	{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus", Sort:0 },
        	{Header:"<sht:txt mid='viewCdV2' mdef='View코드'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"viewCd",	KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='viewNmV1' mdef='View명'/>",	Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"viewNm",	KeyField:1,	Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",		Type:"Text",	Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"seq",		KeyField:0,	Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='viewDescV1' mdef='View설명'/>",	Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"viewDesc",KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 }
		]; IBS_InitSheet(condsheet, initdata); condsheet.SetCountPosition(4);condsheet.SetEditable(false);condsheet.SetVisible(true);

		$("#viewNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search"); $(this).focus();
			}
		});
	    doAction("Search");
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			condsheet.DoSearch( "${ctx}/PwrSrchVwPopup.do?cmd=getPwrSrchVwPopupList", $("#sheetForm").serialize() );
			break;
		}
    }

	// 조회 후 에러 메시지
	function condsheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	// 저장 후 메시지
	function condsheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function condsheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {
		const p = {viewCd 	: condsheet.GetCellValue(Row,"viewCd"),
				   viewNm 	: condsheet.GetCellValue(Row,"viewNm"),
				   viewDesc : condsheet.GetCellValue(Row,"viewDesc")};
		const modal = window.top.document.LayerModalUtility.getModal(pwrSrchVwLayer.id);
		modal.fire(pwrSrchVwLayer.id + 'Trigger', p).hide();
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
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
				<div id="condsheet-wrap"></div>
				<!-- <script type="text/javascript">createIBSheet("condsheet", "100%", "100%", "${ssnLocaleCd}"); </script> -->
				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('pwrSrchVwLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
	</div>
</div>
</body>
</html>



