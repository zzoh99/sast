<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

<script type="text/javascript">
var boardAuthMgrLayer = { id: 'boardAuthMgrLayer' };
var searchBbsCd;
var searchGbCd;
/*Sheet 기본 설정 */
$(function() {
	createIBSheet3(document.getElementById('bbssheet_wrap'), "bbssheet", "100%", "100%", "${ssnLocaleCd}");
	const modal = window.top.document.LayerModalUtility.getModal(boardAuthMgrLayer.id);
	searchBbsCd = modal.parameters.bbsCd;
	searchGbCd = modal.parameters.gbCd;
	
   //배열 선언		
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly,ChildPage:5,AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata.Cols = [
   		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"<sht:txt mid='authScopeNmV3' mdef='범위'/>",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"key",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
		{Header:"<sht:txt mid='authScopeCd' mdef='코드'/>",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"value" ,	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
		{Header:"<sht:txt mid='valueNm' mdef='적용값'/>",		Type:"Popup",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"valueNm", KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",		Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",		Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='gbCd' mdef='GB_CD'/>",		Type:"Text",		Hidden:0,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"gbCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"BBS_CD",		Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"bbsCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		
	]; IBS_InitSheet(bbssheet, initdata);bbssheet.SetEditable("${editable}");bbssheet.SetVisible(true);bbssheet.SetCountPosition(4);
	bbssheet.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
	bbssheet.SetColProperty("key", {ComboText:"|조직|직군|직책", ComboCode:"|ORG_CD|WORK_TYPE|JIKCHAK_CD"});
	$(window).smartresize(sheetResize); sheetInit();
	doAction1("Search");
});

//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {
	case "Search": 	 	bbssheet.DoSearch( "${ctx}/BoardMgr.do?cmd=getBoardAuthPopMgr&searchBbsCd="+searchBbsCd+"&searchGbCd="+searchGbCd, "" ); break;
	case "Save": 		IBS_SaveName(document.bbssheetForm, bbssheet);
						bbssheet.DoSave( "${ctx}/BoardMgr.do?cmd=saveBoardAuthPopMgr", $("#bbssheetForm").serialize() ); break;
	case "Insert":		var Row = bbssheet.DataInsert(0);
						bbssheet.SetCellValue(Row, "gbCd", searchGbCd);
						bbssheet.SetCellValue(Row, "bbsCd", searchBbsCd);
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
			if(colName == "valueNm") {
				switch(bbssheet.GetCellValue(Row, "key")){
				case "ORG_CD":
					// 조직검색
					orgSearchPopup(Row, Col);
					break;
				case "WORK_TYPE":
					orgComCodePopup(Row, Col, "H10050");
					break;
				case "JIKCHAK_CD":
					orgComCodePopup(Row, Col, "H20020");
					break;
					
				}
			}
		}
	}catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}


//소속 팝입
function orgSearchPopup(Row, Col) {
	var w		= 680;
	var h		= 520;
	//var result = openPopup(url+"&authPg=R", args, w, h);
	let layerModal = new window.top.document.LayerModal({
		id : 'orgLayer', 
		url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=R', 
		width : w, 
		height : h, 
		title : "<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>", 
		trigger :[
			{
				name : 'orgTrigger', 
				callback : function(result){
					if(!result.length) return;
					var orgCd	= result[0]["orgCd"];
					var orgNm	= result[0]["orgNm"];
					bbssheet.SetCellValue(Row, "value", orgCd);
					bbssheet.SetCellValue(Row, "valueNm", orgNm);
				}
			}
		]
	});
	layerModal.show();
}


//소속 팝입
function orgComCodePopup(Row, Col, grpCd) {
	var w		= 680;
	var h		= 520;
	var url		= "/Popup.do?cmd=viewCommonCodeLayer";
	var args	= {grpCd: grpCd};
	//var result = openPopup(url+"&authPg=R", args, w, h);
	let layerModal = new window.top.document.LayerModal({
		id : 'commonCodeLayer', 
		url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=R',
		parameters: args,
		width : w, 
		height : h, 
		title : "코드검색", 
		trigger :[
			{
				name : 'commonCodeTrigger', 
				callback : function(result){
					if(!result.length) return;
					var cmpCd	= result["code"];
					var cmpNm	= result["codeNm"];
					bbssheet.SetCellValue(Row, "value", cmpCd);
					bbssheet.SetCellValue(Row, "valueNm", cmpNm);
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
<div class="wrapper">
	<div class="popup_main">
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='boardAdminMgr' mdef='게시판관리자'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction1('Search')" css="button" mid='110697' mdef="조회"/>
							<btn:a href="javascript:doAction1('Insert')" css="basic" mid='110700' mdef="입력"/>
							<btn:a href="javascript:doAction1('Copy')" css="basic" mid='110696' mdef="복사"/>
							<btn:a href="javascript:doAction1('Save')" css="basic" mid='110708' mdef="저장"/>
						</li>
					</ul>
					</div>
				</div>
				<div id="bbssheet_wrap"></div>
			</td>
		</tr>
		</table>
		
		<div class="popup_button outer">
		<ul>
			<li>
				<btn:a href="javascript:closeCommonLayer('boardAuthMgrLayer');" css="gray large" mid='110881' mdef="닫기"/>
			</li>
		</ul>
		</div>
	</div>
</div>

</body>
</html>
