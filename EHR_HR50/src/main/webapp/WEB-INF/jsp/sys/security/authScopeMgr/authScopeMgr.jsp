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
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",			Type:"Image",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"detail",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1,	Cursor:"Pointer"},
			{Header:"<sht:txt mid='authScopeCd' mdef='코드'/>",				Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"authScopeCd",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='authScopeNm' mdef='권한범위\n항목명'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"authScopeNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='scopeType' mdef='범위적용\n구분'/>",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"scopeType",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='prgUrl' mdef='프로그램URL'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"prgUrl",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='sqlSyntaxV2' mdef='SQL구문'/>",			Type:"Text",	Hidden:0,	Width:350,	Align:"Left",	ColMerge:0,	SaveName:"sqlSyntax",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000,	MultiLineText:1},
			{Header:"<sht:txt mid='tableNm' mdef='사용테이블'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"tableNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"AUTH_SQL_SYNTAX",	Type:"Text",	Hidden:0,	Width:350,	Align:"Left",	ColMerge:0,	SaveName:"authSqlSyntax",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000,	MultiLineText:1}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetColProperty("scopeType", {ComboText:"PROGRAM|SQL", ComboCode:"PROGRAM|SQL"} );
		$("#searchAuchScopeNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AuthScopeMgr.do?cmd=getAuthScopeMgrList", $("#srchFrm").serialize() ); break;
		case "Save": 		
							IBS_SaveName(document.srchFrm,sheet1);
							console.log($("#srchFrm").serialize());
							sheet1.DoSave( "${ctx}/AuthScopeMgr.do?cmd=saveAuthScopeMgr", { "Param" : $("#srchFrm").serialize(), "UrlEncode" : true }); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "authScopeCd"); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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
		    if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
		    	authScopeMgrPopup(Row);    
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}		
	}
	
	/**
	 * 상세내역 window open event
	 */
	function authScopeMgrPopup(Row){
		if(!isPopup()) {return;}
  		var w 		= 640;
		var h 		= 620;
		var url 	= "${ctx}/AuthScopeMgr.do?cmd=viewAuthScopeMgrLayer&authPg=${authPg}";
		var param = {authScopeCd 	: sheet1.GetCellValue(Row, "authScopeCd"),
					 authScopeNm 	: sheet1.GetCellValue(Row, "authScopeNm"),
					 scopeType	 	: sheet1.GetCellValue(Row, "scopeType"),
					 prgUrl 		: sheet1.GetCellValue(Row, "prgUrl"),
					 sqlSyntax 		: sheet1.GetCellValue(Row, "sqlSyntax"),
					 tableNm 		: sheet1.GetCellValue(Row, "tableNm")};
		var layer = new window.top.document.LayerModal({
			id: 'authScopeMgrLayer',
			url: url,
			parameters: param,
			width: w,
			height: h,
			title: "<tit:txt mid='authScopeMgrPop' mdef='권한범위항목관리 세부내역'/>",
			trigger: [
				{
					name: 'authScopeMgrLayerTrigger',
					callback: function(rv) {
						sheet1.SetCellValue(Row, "authScopeCd", 	rv["authScopeCd"] );
						sheet1.SetCellValue(Row, "authScopeNm", 	rv["authScopeNm"] );
						sheet1.SetCellValue(Row, "scopeType", 		rv["scopeType"] );
						sheet1.SetCellValue(Row, "prgUrl", 			rv["prgUrl"] );
						sheet1.SetCellValue(Row, "sqlSyntax", 		rv["sqlSyntax"] );
						sheet1.SetCellValue(Row, "tableNm", 		rv["tableNm"] );
					}
				}
			]
		});
		layer.show();
	}
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='114205' mdef='항목명 '/></th>
						<td>  <input id="searchAuchScopeNm" name ="searchAuchScopeNm" type="text" class="text" /> </td>
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='authScopeMgr' mdef='권한범위항목관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Copy')" 	css="btn outline-gray authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
