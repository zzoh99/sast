<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>리조트관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {


	    $("#searchAreaCd, #searchCompanyCd").bind("change",function(event){
			doAction1("Search");
		});
	    $("#searchResortNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		
		//Sheet 초기화
		init_sheet1();//init_sheet2();
		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");


	});
	
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:0,		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:0,		Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:0,		Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"리조트명",	Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"companyCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"지점명",		Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"resortNm",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"지역",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"areaCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"리조트 주소",	Type:"Text",		Hidden:1,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"addr",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"홈페이지주소",	Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"homePage",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"사용유무",	Type:"CheckBox",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y",	FalseValue:"N" },
			{Header:"비고",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			
			{Header:"SEQ",	Type:"Text", Hidden:1, SaveName:"seq"}
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//지역콤보
		var areaCdList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B49510"), "<tit:txt mid='103895' mdef='전체' />");
		sheet1.SetColProperty("areaCd", {ComboText:areaCdList[0], ComboCode:areaCdList[1]});
		$("#searchAreaCd").html(areaCdList[2]);

		//리조트콤보
		var companyCdList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B49530"), "<tit:txt mid='103895' mdef='전체' />");
		sheet1.SetColProperty("companyCd", {ComboText:companyCdList[0], ComboCode:companyCdList[1]});
		$("#searchCompanyCd").html(companyCdList[2]);

	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				sheet1.DoSearch( "${ctx}/ResortMgr.do?cmd=getResortMgrList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/ResortMgr.do?cmd=saveResortMgr", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet1.DataInsert(0);
				sheet1.SetCellValue(row, "useYn", "Y");
				break;
			case "Copy":
				var row = sheet1.DataCopy();
				sheet1.SetCellValue(row, "seq", "");
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
		}
	}


	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------

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
	
	function sheet1_OnPopupClick(Row, Col){
		var	args	= new Array();
		try{
			if(Row > 0 &&  sheet1.ColSaveName(Col) == "languageNm" ){
				lanuagePopup(Row, "sheet1", "tben495", "languageCd", "languageNm", "resortName");
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sheet1Form" id="sheet1Form" method="post">
	<input type="hidden" id="searchResortSeq" name="searchResortSeq" />
	<div class="sheet_search outer">
		<table>
		<tr>
			<th><tit:txt mid="112352" mdef="지역구분" /></th>
			<td>
				<select id="searchAreaCd" name="searchAreaCd"></select>
			</td>
			<th><tit:txt mid='104371' mdef='리조트명' /></th>
			<td>
				<select id="searchCompanyCd" name="searchCompanyCd" ></select>
			</td>
			<th><tit:txt mid="L19080500065" mdef="지점명" /></th>
			<td>
				<input id="searchResortNm" name="searchResortNm" type="text" class="text" style="ime-mode:active;" />
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" mid="search" mdef="조회" css="btn dark"/>
			</td>
		</tr>
		</table>
	</div>
</form>
		<div class="sheet_title inner">
		<ul>
			<li class="txt"><tit:txt mid="L19080500066" mdef="리조트관리" /></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" 	css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
				<btn:a href="javascript:doAction1('Copy')" 			css="btn outline-gray authA" mid='copy' mdef="복사"/>
				<btn:a href="javascript:doAction1('Insert')" 		css="btn outline-gray authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Save');" 		css="btn filled authA" mid='save' mdef="저장"/>
			</li>
		</ul>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	

</div>
</body>
</html>
