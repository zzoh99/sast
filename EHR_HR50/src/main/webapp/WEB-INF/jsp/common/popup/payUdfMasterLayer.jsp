<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='payUdfMasterPop' mdef='사용자정의 함수 조회'/></title>

<script type="text/javascript">
	$(function(){

		createIBSheet3(document.getElementById('mySheet-wrap'), "mySheet", "100%", "100%","${ssnLocaleCd}");

		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" },
            {Header:"<sht:txt mid='sStatus' mdef='상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
            {Header:"<sht:txt mid='udfCd' mdef='함수코드'/>",  Type:"Text",      Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"udfCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='udfNm' mdef='함수명'/>",    Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"udfNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='udfNm' mdef='짧은설명'/>",    Type:"Text",      Hidden:0,  Width:70,  Align:"Left",    ColMerge:0,   SaveName:"udfName",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='dataTypeV4' mdef='DATA_TYPE'/>", Type:"Combo",     Hidden:0,  Width:60,   Align:"Left",    ColMerge:0,   SaveName:"dataType",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
            {Header:"<sht:txt mid='description' mdef='설명'/>",      Type:"Text",      Hidden:0,  Width:130,  Align:"Left",    ColMerge:0,   SaveName:"description",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",      Type:"Combo",     Hidden:0,  Width:50,   Align:"Left",    ColMerge:0,   SaveName:"udfGubunCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 }  ];
		IBS_InitSheet(mySheet, initdata); mySheet.SetEditable("${editable}");

		// DATA_TYPE Datatype
        dataTypeList   = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00025"), "");
        mySheet.SetColProperty("dataType",         {ComboText:dataTypeList[0],    ComboCode:dataTypeList[1]} );

		// 구분
		udfGubunCdList   = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S99001"), "");
        mySheet.SetColProperty("udfGubunCd",         {ComboText:udfGubunCdList[0],    ComboCode:udfGubunCdList[1]} );

        mySheet.SetVisible(true);
		mySheet.SetCountPosition(4);

	    $(window).smartresize(sheetResize); sheetInit();

		$("#searchUdfMasterNm").on("keyup", function(event) {
			if (event.keyCode === 13) {
				doAction("Search");
				$(this).focus();
			}
		})

	    doAction("Search");
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			mySheet.DoSearch( "${ctx}/PayUdfMasterPopup.do?cmd=getPayUdfMasterList", $("#mySheetForm").serialize() );
			break;
		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(mySheet);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			mySheet.Down2Excel(param);
			break;
		}
    }

	// 	조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		const modal = window.top.document.LayerModalUtility.getModal('udfMasterLayer');
		modal.fire('udfMasterTrigger', {
			udfCd : mySheet.GetCellValue(Row, "udfCd")
			, description : mySheet.GetCellValue(Row, "description")
		}).hide();
	}

	function setClear() {
		const modal = window.top.document.LayerModalUtility.getModal('udfMasterLayer');
		modal.fire('udfMasterTrigger', {
			udfCd : ""
			, description : ""
		}).hide();
	}
</script>


</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="mySheetForm" name="mySheetForm">
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='112381' mdef='함수설명'/></th>
							<td>
								<input id="searchUdfMasterNm" name ="searchUdfMasterNm" type="text" class="text" style="ime-mode:active;"/>
							</td>
							<td> <btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td>
						</tr>
					</table>
				</div>
			</div>
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td class="top">
					<div class="outer">
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt"><tit:txt mid='112721' mdef='사용자정의 함수 조회 '/></li>
								<li class="btn">
									<btn:a href="javascript:doAction('Down2Excel')"	css="basic authR" mid='110698' mdef="다운로드"/>
								</li>
							</ul>
						</div>
					</div>
					<div id="mySheet-wrap"></div>
				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<ul>
			<li>
				<a href="javascript:setClear();" class="button large"><tit:txt mid='112391' mdef='초기화'/></a>
				<btn:a href="javascript:closeCommonLayer('udfMasterLayer');" css="basic large" mid='110881' mdef="닫기"/>
			</li>
		</ul>
	</div>
</div>
</body>
</html>
