<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='orgMapItemMgr' mdef='조직구분항목'/></title>
<link rel="stylesheet" href="/common/${theme}/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"Seq",       Hidden:0,  Width:40,  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"DelCheck",  Hidden:0,  Width:40,	Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='resultV2' mdef='결과'/>",			Type:"Result",    Hidden:1,  Width:40,	Align:"Center",  ColMerge:0,   SaveName:"sResult" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"Status",    Hidden:0,  Width:40,	Align:"Center",  ColMerge:0,   SaveName:"sStatus" },

			{Header:"<sht:txt mid='mapTypeCd' mdef='조직맵핑구분'/>",		Type:"Combo",     Hidden:0,  Width:100, Align:"Center",  ColMerge:0,   SaveName:"mapTypeCd",  keyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='mapCd' mdef='조직맵핑코드'/>",		Type:"Text",      Hidden:0,  Width:80, Align:"Center",  ColMerge:0,   SaveName:"mapCd",       keyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='mapCdV2' mdef='조직맵핑명'/>",		Type:"Text",      Hidden:0,  Width:200, Align:"Left",    ColMerge:0,   SaveName:"mapNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>", 		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",         	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1, EndDateCol: "edate"},
            {Header:"<sht:txt mid='eYmd' mdef='종료일자'/>", 		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",         	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1, StartDateCol: "sdate"},
			{Header:"<sht:txt mid='ccType' mdef='원가판관구분'/>",		Type:"Combo",     Hidden:0,  Width:60,  Align:"Center",  ColMerge:0,   SaveName:"ccType",   keyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='erpEmpCd' mdef='ERP사원구분'/>",		Type:"Combo",     Hidden:1,  Width:60,  Align:"Center",  ColMerge:0,   SaveName:"erpEmpCd",   keyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"순서",			Type:"Text",   Hidden:0,  Width:40,  Align:"Center",    ColMerge:0,   SaveName:"sort",         KeyField:0,   CalcLogic:"",   Format:"Integer",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",			Type:"Text",      Hidden:0,  Width:200, Align:"Left",    ColMerge:0,   SaveName:"note",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		]; IBS_InitSheet(mySheet, initdata); mySheet.SetCountPosition(4);

		$("#searchMapTypeCd").change(function(){
			doAction("Search");
		});

		$("#searchMapNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();

		$("#searchYmd").datepicker2({
			onReturn:function(date){
				// doAction("Search"); 기준일자에 따른 조직맵핑구분을 다시 조회해야 하기 때문에 바로 조회 X
				getMapTypeCd();
			}
		});
		$("#searchYmd").val("${curSysYyyyMMddHyphen}");

		$("#searchYmd").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
		getMapTypeCd();
		doAction("Search");
	});

	function getMapTypeCd() {
		var W20020 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20020", $("#searchYmd").val()), ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));
		$("#searchMapTypeCd").html(W20020[2]);
	}

	function getCommonCodeList() {
		let baseYmd = $("#searchYmd").val();
		var W20020 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20020", baseYmd), ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));
		mySheet.SetColProperty("mapTypeCd", {ComboText:W20020[0], ComboCode:W20020[1]} );

		var C14050 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C14050", baseYmd), "");
		mySheet.SetColProperty("erpEmpCd",  {ComboText:C14050[0], ComboCode:C14050[1]} );

		var C14150 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y&visualYn=Y","C14150", baseYmd), "");
		mySheet.SetColProperty("ccType", 	{ComboText:"|"+C14150[0], ComboCode:"|"+C14150[1]} );
	}

	function chkInVal() {
		// 시작일자와 종료일자 체크
		var rowCnt = mySheet.RowCount();
		for (var i=1; i<=rowCnt; i++) {
			if (mySheet.GetCellValue(i, "sStatus") == "I" || mySheet.GetCellValue(i, "sStatus") == "U") {
				if (mySheet.GetCellValue(i, "edate") != null && mySheet.GetCellValue(i, "edate") != "") {
					var sdate = mySheet.GetCellValue(i, "sdate");
					var edate = mySheet.GetCellValue(i, "edate");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						mySheet.SelectCell(i, "edate");
						return false;
					}
				}
			}
		}

		return true;
	}


	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 				// 필수값/유효성 체크
/* 			if (!chkInVal(sAction)) {
				break;
			}; */
			getCommonCodeList();
			mySheet.DoSearch( "${ctx}/OrgMappingItemMngr.do?cmd=getOrgMappingItemMngrList", $("#mySheetForm").serialize() ); break;
		case "Save":
			if (!chkInVal()) {
				break;
			}
			IBS_SaveName(document.mySheetForm,mySheet);
			mySheet.DoSave( "${ctx}/OrgMappingItemMngr.do?cmd=saveOrgMappingItemMngr", $("#mySheetForm").serialize()); break;
		case "Insert":		mySheet.SelectCell(mySheet.DataInsert(0), "column1"); break;
		case "Copy":
			var Row = mySheet.DataCopy();
			mySheet.SetCellValue(Row, "sdate", "");
			mySheet.SetCellValue(Row, "edate", "");
			mySheet.SelectCell(Row, "column1");
			break;
		case "Clear":		mySheet.RemoveAll(); break;
		case "Down2Excel":	mySheet.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; mySheet.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function mySheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }  
			if( Code > -1 ) doAction('Search'); 
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function mySheet_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && mySheet.GetCellValue(Row, "sStatus") == "I") {
				mySheet.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	}

	function mySheet_OnPopupClick(Row, Col){
		try{
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104352' mdef='기준일자'/></th>
						<td>  <input type="text" id="searchYmd" name="searchYmd" class="date2" /></td>
						<th><tit:txt mid='113963' mdef='조직맵핑구분'/>  </th>
						<td>  <SELECT id="searchMapTypeCd" name="searchMapTypeCd"></SELECT></td>
						<th><tit:txt mid='113436' mdef='조직맵핑명'/>  </th>
						<td>  <input id="searchMapNm" name ="searchMapNm" type="text" class="text" /> </td>
						<td> <btn:a href="javascript:doAction('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>  </td>
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
							<li id="txt" class="txt"><tit:txt mid='orgMapItemMgr' mdef='조직구분항목'/></li>
							<li class="btn">
								<a href="javascript:doAction('Down2Excel')" class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
								<btn:a href="javascript:doAction('Copy')" 	css="btn outline-gray authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>

							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("mySheet", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
