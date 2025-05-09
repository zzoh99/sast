<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>

<script type="text/javascript">
var boardAdminMgrLayer = { id: 'boardAdminMgrLayer' };
var searchBbsCd = '';
/*Sheet 기본 설정 */
$(function() {
	createIBSheet3(document.getElementById('bbssheet_wrap'), "bbssheet", "100%", "100%", "${ssnLocaleCd}");
	const modal = window.top.document.LayerModalUtility.getModal(boardAdminMgrLayer.id);
	searchBbsCd = modal.parameters.bbsCd;
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly,ChildPage:5, AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata.Cols = [
   		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Popup",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name" ,	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='gbCd' mdef='GB_CD'/>",		Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"gbCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"BBS_CD",		Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"bbsCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='key' mdef='KEY'/>",			Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"key",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		
	]; IBS_InitSheet(bbssheet, initdata);bbssheet.SetEditable("${editable}");bbssheet.SetVisible(true);bbssheet.SetCountPosition(4);
	bbssheet.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
	var jikweeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");
	bbssheet.SetColProperty("jikweeCd", {ComboText:jikweeCdList[0], ComboCode:jikweeCdList[1]} );
	$(window).smartresize(sheetResize); sheetInit();


	var sheetHeight = $(".modal_body").height() - $(".sheet_title").height() - 2;
	bbssheet.SetSheetHeight(sheetHeight);

	doAction1("Search");
});
//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {
	
	case "Search": 	 	bbssheet.DoSearch( "${ctx}/BoardMgr.do?cmd=getBoardAdminPopMgr&searchBbsCd="+searchBbsCd, "" ); break;
	
	case "Save": 		
						IBS_SaveName(document.bbssheetForm,bbssheet);
						bbssheet.DoSave( "${ctx}/BoardMgr.do?cmd=saveBoardAdminPopMgr", $("#bbssheetForm").serialize() ); break;
	
	case "Insert":		var Row = bbssheet.DataInsert(0);
						bbssheet.SetCellValue(Row, "gbCd", "A001");
						bbssheet.SetCellValue(Row, "bbsCd", searchBbsCd);
						bbssheet.SetCellValue(Row, "key", "SABUN");
						break;
	case "Copy":		bbssheet.DataCopy(); break;
	
	case "Clear":		bbssheet.RemoveAll(); break;
	
	case "Down2Excel":	bbssheet.Down2Excel(); break;
	
	case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; bbssheet.LoadExcel(params); break;
	}
}

// 조회 후 에러 메시지
function bbssheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { 	if (Msg != "") { alert(Msg); } 
	  sheetResize(); 
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function bbssheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } doAction1("Search") ; } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

// 셀에서 키보드가 눌렀을때 발생하는 이벤트
function bbssheet_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		// Insert KEY
		if (Shift == 1 && KeyCode == 45) {
			doAction("Insert");
		}
		//Delete KEY
		if (Shift == 1 && KeyCode == 46 && bbssheet.GetCellValue(Row, "sStatus") == "I") {
			bbssheet.SetCellValue(Row, "sStatus", "D");
		}
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}

function bbssheet_OnPopupClick(Row, Col) {
	try{
		var colName = bbssheet.ColSaveName(Col);
		if (Row > 0) {
			if(colName == "name") {
				// 사원검색 팝업
				empSearchPopup(Row, Col);
			}
		}
	}catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

// 사원검색 팝업
function empSearchPopup(Row, Col) {
	if(!isPopup()) {return;}
	var w		= 840;
	var h		= 520;
	var url		= "/Popup.do?cmd=viewEmployeeLayer";
	//var result = openPopup(url+"&authPg=R", args, w, h);
	var layerModal = new window.top.document.LayerModal({
		  id : 'employeeLayer', 
		  url : url,
		  width : w, 
		  height : h,
		  title : '사원조회',
		  trigger: [
			  {
				  name: 'employeeTrigger',
				  callback: function(rv) {
					  bbssheet.SetCellValue(Row, "sabun",    rv["sabun"]);
					  bbssheet.SetCellValue(Row, "name",     rv["name"]);
					  bbssheet.SetCellValue(Row, "jikweeCd", rv["jikweeCd"]);
				  }
			  }
		  ]
	});
	layerModal.show();
}
</script>
</head>
<body class="bodywrap">
<form id="bbssheetForm" name="bbssheetForm"></form>
<div class="wrapper modal_layer">
	<div class="modal_body">
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='boardAdminMgr' mdef='게시판관리자'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction1('Copy')" css="btn outline-gray authA" mid='110696' mdef="복사"/>
							<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
							<btn:a href="javascript:doAction1('Save')" css="btn filled authA" mid='110708' mdef="저장"/>
							<btn:a href="javascript:doAction1('Search')" css="btn dark authR" mid='110697' mdef="조회"/>
						</li>
					</ul>
					</div>
				</div>
				<div id="bbssheet_wrap"></div>
			</td>
		</tr>
		</table>
	</div>
	<div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('boardAdminMgrLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
	</div>
</div>

</body>
</html>
