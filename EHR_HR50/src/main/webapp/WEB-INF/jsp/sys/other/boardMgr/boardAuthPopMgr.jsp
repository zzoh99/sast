<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var p = eval("${popUpStatus}");
var arg = p.window.dialogArguments;
var searchBbsCd ;
var searchGbCd;
	/*Sheet 기본 설정 */
	$(function() {
		if( arg != undefined ) {
			searchBbsCd = arg["bbsCd"] ;
			searchGbCd = arg["gbCd"];
		}
	    $(".close").click(function() {
	    	p.self.close();
	    });		//배열 선언		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly,ChildPage:5};
		initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
		initdata.Cols = [
		                 
    		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"<sht:txt mid='authScopeNmV3' mdef='범위'/>",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"key",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
   			{Header:"<sht:txt mid='authScopeCd' mdef='코드'/>",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"value" ,	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
   			{Header:"<sht:txt mid='valueNm' mdef='적용값'/>",		Type:"Popup",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"valueNm", KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",		Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",		Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='gbCd' mdef='GB_CD'/>",		Type:"Text",		Hidden:0,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"gbCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"BBS_CD",		Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"bbsCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
			
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		
		sheet1.SetColProperty("key", {ComboText:"|조직|직군|직책", ComboCode:"|ORG_CD|WORK_TYPE|JIKCHAK_CD"});
		
		/*
		var jikweeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");
		sheet1.SetColProperty("jikweeCd", 			{ComboText:jikweeCdList[0], ComboCode:jikweeCdList[1]} );
		*/
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	    
	    $(".close").click(function() {
	    	self.close();
	    });
	});
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		
		case "Search": 	 	sheet1.DoSearch( "${ctx}/BoardMgr.do?cmd=getBoardAuthPopMgr&searchBbsCd="+searchBbsCd+"&searchGbCd="+searchGbCd, "" ); break;
		
		case "Save": 		
							IBS_SaveName(document.sheet1Form,sheet1);
							sheet1.DoSave( "${ctx}/BoardMgr.do?cmd=saveBoardAuthPopMgr", $("#sheet1Form").serialize() ); break;
		
		case "Insert":		var Row = sheet1.DataInsert(0);
							sheet1.SetCellValue(Row, "gbCd", searchGbCd);
							sheet1.SetCellValue(Row, "bbsCd", searchBbsCd);
							break;
		case "Copy":		sheet1.DataCopy(); break;
		
		case "Clear":		sheet1.RemoveAll(); break;
		
		case "Down2Excel":	sheet1.Down2Excel(); break;
		
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 	if (Msg != "") { alert(Msg); } 
		  sheetResize(); 
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search") ; } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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
	
	function sheet1_OnPopupClick(Row, Col) {
		try{
			var colName = sheet1.ColSaveName(Col);
			if (Row > 0) {
				if(colName == "valueNm") {
					switch(sheet1.GetCellValue(Row, "key")){
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
		var url		= "/Popup.do?cmd=orgBasicPopup";
		var args	= new Array();

		var result = openPopup(url+"&authPg=R", args, w, h);

		if (result) {
			var orgCd	= result["orgCd"];
			var orgNm	= result["orgNm"];

			sheet1.SetCellValue(Row, "value", orgCd);
			sheet1.SetCellValue(Row, "valueNm", orgNm);
		}
	}
	
	
	//소속 팝입
	function orgComCodePopup(Row, Col, grpCd) {
		var w		= 680;
		var h		= 520;
		var url		= "/Popup.do?cmd=commonCodePopup";
		var args	= new Array();
		args["grpCd"] = grpCd;
		var result = openPopup(url+"&authPg=R", args, w, h);

		if (result) {
			var cmpCd	= result["code"];
			var cmpNm	= result["codeNm"];

			sheet1.SetCellValue(Row, "value", cmpCd);
			sheet1.SetCellValue(Row, "valueNm", cmpNm);
		}
	}
	
	
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='boardAdminMgr' mdef='게시판관리자'/></li>
		<li class="close"></li>
	</ul>
	</div>
	
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
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
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
