<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='prgMng' mdef='프로그램관리'/></title>
<!-- 
include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
 -->

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var arg = null;
	$(function() {
		
        const modal = window.top.document.LayerModalUtility.getModal('prgMgrLayer');

        arg =  modal.parameters;
        
        createIBSheet3(document.getElementById('sheet1-wrap'), "sheet1", "100%", "100%", "${ssnLocaleCd}");
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, DataRowMerge:0, ChildPage:5, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
		  		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
				{Header:"<sht:txt mid='prgCdV2' mdef='프로그램'/>"      ,Type:"Text",	Hidden:0,	Width:140,	Align:"Left",   ColMerge:0,   SaveName:"prgCd",		UpdateEdit:0 },
				{Header:"<sht:txt mid='prgNmV1' mdef='프로그램명'/>"    ,Type:"Text",	Hidden:0,	Width:135,	Align:"Left",   ColMerge:0,   SaveName:"prgNm",		UpdateEdit:0 },
				{Header:"<sht:txt mid='prgEngNmV1' mdef='프로그램영문명'/>",Type:"Text",	Hidden:1,	Width:100,	Align:"Left",   ColMerge:0,   SaveName:"prgEngNm",	UpdateEdit:0 },
				{Header:"<sht:txt mid='path' mdef='PATH'/>"          ,Type:"Text",	Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,   SaveName:"prgPath",	UpdateEdit:0 },
				{Header:"<sht:txt mid='chk_V385' mdef='사용'/>"          ,Type:"Combo",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,   SaveName:"use",		UpdateEdit:0 },
				{Header:"<sht:txt mid='version' mdef='버전'/>"          ,Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,   SaveName:"version",	UpdateEdit:0 },
				{Header:"<sht:txt mid='memoV4' mdef='메모'/>"          ,Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,   SaveName:"memo",		UpdateEdit:0 },
				{Header:"<sht:txt mid='dateTrackYnV1' mdef='Track'/>"         ,Type:"Combo",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,   SaveName:"dateTrackYn",UpdateEdit:0 },
				{Header:"<sht:txt mid='logSaveYnV1' mdef='로그여부'/>"		,Type:"Combo",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,   SaveName:"logSaveYn",	UpdateEdit:0 }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);

		// sheet 높이 계산
		var sheetHeight = $(".modal_body").height() - $("#mySheetForm").height() - $(".sheet_title").height() - 2;
		sheet1.SetSheetHeight(sheetHeight);

		sheet1.SetColProperty("use", 			{ComboText:"사용|사용안함", ComboCode:"Y|N"} );
		sheet1.SetColProperty("dateTrackYn", 	{ComboText:"유|무", 	ComboCode:"Y|N"} );
		sheet1.SetColProperty("logSaveYn", 	{ComboText:"Y|N", ComboCode:"Y|N"} );
		
		$("#prgCd,#prgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search"); $(this).focus();
			}
		});
		$(window).smartresize(sheetResize); sheetInit();
	    doAction("Search");
	    
	    $(".close").click(function() {
	    	//p.self.close();
	    	closeCommonLayer('prgMgrLayer');
	    });
	});
	
	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/Popup.do?cmd=getPrgMgrPopupList", $("#mySheetForm").serialize() ); break;
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
	
	function sheet1_OnKeyUp(Row, Col, KeyCode, Shift) {
		try {
			if(KeyCode == 13) {
				retValue(Row);
			}
		} catch(ex) {
			alert("OnKeyUp Event Error : " + ex);
		}
	}
	
	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			retValue(Row);
		} catch (ex) {
			alert("OnDblClick Event Error : " + ex);
		}
	}
	
	function retValue(Row) {
        const modal = window.top.document.LayerModalUtility.getModal('prgMgrLayer');
        modal.fire('prgMgrTrigger', {
              prgCd : sheet1.GetCellValue(Row, "prgCd")
            , menuNm : sheet1.GetCellValue(Row, "prgNm")
        }).hide();
	}
	
</script>
</head>

<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="mySheetForm" name="mySheetForm" tabindex="1">
			<div class="sheet_search outer">
				<div>
				<table>
				<tr>
					<th><tit:txt mid='113444' mdef='프로그램명'/></th>
                       <td>  <input id="prgNm" name ="prgNm" type="text" class="text" style="ime-mode:active;" /> </td>
                       <th><tit:txt mid='program' mdef='프로그램'/></th>
					   <td>  <input id="prgCd" name ="prgCd" type="text" class="text" /> </td>
                       <td>
						<a href="javascript:doAction('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
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
							<li id="txt" class="txt"><tit:txt mid='program' mdef='프로그램'/></li>
							<li class="btn">
							</li>
						</ul>
						</div>
					</div>
					<div id="sheet1-wrap"></div>
					<!-- <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script> -->
				</td>
			</tr>
		</table>
	</div>


	<div class="modal_footer">
		<a href="javascript:closeCommonLayer('prgMgrLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	</div>
	
</div>
</body>
</html>
