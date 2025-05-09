<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>계약서관리</title>
<%-- <link rel="stylesheet" href="/common/${theme}/css/style.css" /> --%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script type="text/javascript">
	$(function() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",		Type:"Image",		Hidden:0,	Width:30,	Align:"Center",	ColMerge:1,	SaveName:"detail",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='2017082800789' mdef='계약서 유형'/>",	Type:"Combo",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:1,	SaveName:"contType",	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",				Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",				Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='path' mdef='PATH'/>",				Type:"Text",		Hidden:0,	Width:170,	Align:"Left",	ColMerge:1,	SaveName:"path",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='fileNm' mdef='파일명'/>",				Type:"Text",		Hidden:0,	Width:130,	Align:"Left",	ColMerge:1,	SaveName:"fileNm",		KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='mailcont' mdef='내용'/>1",			Type:"Text",		Hidden:1,	Width:130,	Align:"Left",	ColMerge:1,	SaveName:"contents",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:0 },
			{Header:"<sht:txt mid='mailcont' mdef='내용'/>2",			Type:"Text",		Hidden:1,	Width:130,	Align:"Left",	ColMerge:1,	SaveName:"contents2",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:0 },
			{Header:"서명 사용여부",										Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"signUseYn",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" ,HeaderCheck:0},
		] ; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

		// 계약서 유형

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail",1);
		sheet1.SetDataLinkMouse("detail2",1);

		$("#searchStdDate").datepicker2();
		doAction("Search");

		$(window).smartresize(sheetResize); sheetInit();
	});

	function getCommonCodeList() {
		var contTypeList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","Z00001", $("#searchStdDate").val()), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("contType", 			{ComboText:"|"+contTypeList[0], ComboCode:"|"+contTypeList[1]} );
	}

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			getCommonCodeList();
			sheet1.DoSearch( "${ctx}/EmpContractMgr.do?cmd=getEmpContractMgrList", $("#sheetForm").serialize() ); break;
		case "Save":
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/EmpContractMgr.do?cmd=saveEmpContractMgr", $("#sheetForm").serialize()); break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Copy":
			sheet1.SelectCell(sheet1.DataCopy(), 4);
			break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); break;
		case "LoadExcel":
			// 업로드
			var params = {};
			sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:"5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28"});
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { alert(Msg); } 
			if( Code > -1 ) doAction("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(sheet1.ColSaveName(Col) == "detail"	&& Row >= sheet1.HeaderRows()){
				gPRow = Row;
				var url ="/EmpContractMgr.do?cmd=viewEmpContractMgrLayer";
				// var args    = new Array();
				// args["contType"] = sheet1.GetCellValue(Row, "contType");
				// args["sdate"] = sheet1.GetCellValue(Row, "sdate");
				// args["contents"] = sheet1.GetCellValue(Row, "contents");
				// var result = openPopup(url,args,900,600);
				var p = {
					contType : sheet1.GetCellValue(Row, "contType"),
					sdate : sheet1.GetCellValue(Row, "sdate"),
					contents : sheet1.GetCellValue(Row, "contents"),
				};
				var empContractMgrLayer = new window.top.document.LayerModal({
					id: 'empContractMgrLayer',
					url: url,
					parameters: p,
					width: 900,
					height: 800,
					title: '계약서 상세',
					trigger: [
						{
							name: 'empContractMgrTrigger',
							callback: function(rv) {
								getReturnValue(rv);
							}
						}
					]
				});
				empContractMgrLayer.show();
				//window.top.openLayer(url, p, 900, 600, 'empContractMgrLayerInit');
			}
		}catch(ex){
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value) {
		try{
			if(sheet1.GetCellValue(Row,"sdate") != "" && sheet1.GetCellValue(Row,"edate") != "") {
				if(sheet1.GetCellValue(Row,"sdate") > sheet1.GetCellValue(Row,"edate")) {
					alert("<msg:txt mid='109513' mdef='시작일은 종료일보다 작거나 같아야합니다.'/>");
					doAction("Search");
					return;
				}
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	function getReturnValue(returnValue) {
		//var rv = $.parseJSON('{' + returnValue+ '}');
		doAction("Search");
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='103906' mdef='기준일자 '/></th>
						<td>  <input type="text" id="searchStdDate" name="searchStdDate" class="date" value="${curSysYyyyMMddHyphen}" /> </td>
						<td><btn:a href="javascript:doAction('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='2017082800790' mdef='계약서관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction('Down2Excel')" css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
								<btn:a href="javascript:doAction('Copy')" 	css="btn outline_gray authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction('Insert')" css="btn outline_gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
