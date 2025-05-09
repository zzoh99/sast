<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		$("#searchStdCd, #searchStdNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		
		init_sheet1();
		

		doAction1("Search");
		
	});
	function init_sheet1(){
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

		    {Header:"기준코드",	Type:"Text",     Hidden:0,  Width:150, 	Align:"Left",  	ColMerge:0,   SaveName:"stdCd",   		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"기준코드명",	Type:"Text",     Hidden:0,  Width:150,	Align:"Left",  	ColMerge:0,   SaveName:"stdNm",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"설명",		Type:"Text",     Hidden:1,  Width:50,   Align:"Center", ColMerge:0,   SaveName:"stdCdDesc", 	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
            {Header:"데이터타입",	Type:"Combo",    Hidden:0,  Width:60, 	Align:"Center", ColMerge:0,   SaveName:"dataType",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"기준값",		Type:"Text",     Hidden:0,  Width:80,   Align:"Center", ColMerge:0,   SaveName:"stdCdValue",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"수정일시",	Type:"Text",     Hidden:0,  Width:120,  Align:"Center", ColMerge:0,   SaveName:"chkdate",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },

            //Hidden
            {Header:"bizCd",	Type:"Text",    Hidden:1, SaveName:"bizCd"},
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var dataType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00025"), "");	//DATA_TYPE
		sheet1.SetColProperty("dataType", 			{ComboText:dataType[0], ComboCode:dataType[1]} ) ;

		$(window).smartresize(sheetResize); sheetInit();
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/TimUsingMgr.do?cmd=getTimUsingMgrList", $("#sheet1Form").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/TimUsingMgr.do?cmd=saveTimUsingMgr", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "bizCd", "08");
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}


	
	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			} 
			if( Code > -1 ) doAction1("Search"); 
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}

	// 값 변경 시 이벤트
	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
		const isDisableNumberType = (_Row) => {
			// Type 이 숫자인데 코드값이 숫자가 아닌 경우를 체크
			return sheet1.GetCellValue(_Row, "dataType") === "N"
					&& sheet1.GetCellValue(_Row, "stdCdValue")
					&& /[^0-9.\-]/.test(sheet1.GetCellValue(_Row, "stdCdValue"));
		}

		try {
			if (sheet1.ColSaveName(Col) === "stdCdValue" || sheet1.ColSaveName(Col) === "dataType") {
				if (isDisableNumberType(Row)) {
					alert("데이터타입이 숫자일 경우 숫자만 입력 가능합니다.");
					sheet1.SetCellValue(Row, Col, OldValue);
				}
			}
		} catch (ex) {
			alert("OnChange Event Error : " + ex);
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="searchBizCd" name="searchBizCd" value="08" /><!-- 근태 -->
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>기준코드 </th>
					    <td>  <input id="searchStdCd" name ="searchStdCd" type="text" class="text w150" /> </td>
					    <th>기준코드명 </th>
						<td>  <input id="searchStdNm" name ="searchStdNm" type="text" class="text w150" /> </td>
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">근태 기타사용기준관리</li>
				<li class="btn">
					<btn:a href="javascript:doAction1('Insert')" css="btn outline_gray authA" mid='insert' mdef="입력"/>
					<btn:a href="javascript:doAction1('Copy')" 	css="btn outline_gray authA" mid='copy' mdef="복사"/>
					<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
					<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline_gray authR" mid='down2excel' mdef="다운로드"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			
</div>
</body>
</html>
