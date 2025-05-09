<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근무코드관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<!-- ColorPicker Plugin -->
<link href="/common/plugin/ColorPicker/evol-colorpicker.css" rel="stylesheet" />
<script src="/common/js/ui/1.12.1/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/common/plugin/ColorPicker/evol-colorpicker.js" type="text/javascript"></script>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	

	$(function() {

		//ColorPicker
	    init_ColorPicker(function(evt, color){
			if(color){
				sheet1.SetCellValue(gPRow, "rgbCd", color);
			}
		});
	
	    $("#searchWorkNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	    $("#searchDayType, #searchWorkCdType").bind("change",function(event){
			doAction1("Search");
		});
	    
	    
	    init_sheet1();
	    
		doAction1("Search");
	});

	function init_sheet1() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"근무코드",			Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"workCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"근무명",				Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"workNm",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"근무약어명",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workSNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"차감여부",			Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"subtractYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"근무시간\n(52시간체크)",Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workCdType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"근무종류",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"dayType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"차감여부",			Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"exemptionYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"기본근무\n적용시간",	Type:"Float",		Hidden:1,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"stdApplyHour",	KeyField:0,	Format:"NullFloat", PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:18 },
			{Header:"일일근무신\n청사용여부",Type:"Combo",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"requestUseYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"근태자동\n생성여부",	Type:"Combo",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"autoGntCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:18 },
			{Header:"순서",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"Number",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"비고",				Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note1",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"Color\nRGB",		Type:"Text",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"rgbCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var workCdType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T10005"), "전체	");
		var dayType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T10017"), "전체");
		var autoGntCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCpnGntCdList"), "");

		sheet1.SetColProperty("workCdType", 		{ComboText:"|"+workCdType[0], ComboCode:"|"+workCdType[1]} );
		sheet1.SetColProperty("dayType", 			{ComboText:"|"+dayType[0], ComboCode:"|"+dayType[1]} );
		sheet1.SetColProperty("autoGntCd", 			{ComboText:"|"+autoGntCd[0], ComboCode:"|"+autoGntCd[1]} );
		sheet1.SetColProperty("subtractYn", 		{ComboText:"|실근무시간과 관계없음|실근무시간에서 차감을 표시", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("requestUseYn", 		{ComboText:"|사용|사용안함", ComboCode:"|Y|N"} );

		$("#searchDayType").html(dayType[2]);
		$("#searchWorkCdType").html(workCdType[2]);

		$(window).smartresize(sheetResize); sheetInit();
	}


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/WorkCdMgr.do?cmd=getWorkCdMgrList",$("#sheet1Form").serialize() );
			break;
		case "Save":

			if(!dupChk(sheet1,"workCd", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/WorkCdMgr.do?cmd=saveWorkCdMgr", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for (var i=1; i<=sheet1.LastRow(); i++){
				sheet1.SetCellBackColor(i, "rgbCd", sheet1.GetCellValue(i, "rgbCd"));
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
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value) {
		try{
			if( sheet1.ColSaveName(Col) == "rgbCd" ) {
				sheet1.SetCellBackColor(Row, Col, Value);
		    }
		}catch(ex){
			alert("sheet1 OnChange Event Error : " + ex);
		}
	}
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
	
			$(".cp-Div").hide();
			if( sheet1.ColSaveName(Col) == "rgbCd" ){
				gPRow = Row;
				fnSheetDivPopup(sheet1, Row, Col);
				
			}
		}catch(ex){
			alert("sheet1 OnClick Event Error : " + ex);
		}
	}
	
	
    

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
 
	<form id="sheet1Form" name="sheet1Form">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th>근무명</th>
			<td>
				<input id="searchWorkNm" name="searchWorkNm" type="text" class="text"/>
			</td>
			<th>근무종류</th>
			<td>
				<select id="searchDayType" name="searchDayType">
				</select>
			</td>
			<th>근무시간</th>
			<td>
				<select id="searchWorkCdType" name="searchWorkCdType">
				</select>
			</td>
			<td>
				<a href="javascript:doAction1('Search');" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
		</div>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">근무코드관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Insert');" class="btn outline_gray authA">입력</a>
				<a href="javascript:doAction1('Copy');" class="btn outline_gray authA">복사</a>
				<a href="javascript:doAction1('Save');" class="btn filled authA">저장</a>
				<a href="javascript:doAction1('Down2Excel');" class="btn outline_gray authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "kr"); </script>
</div>
</body>
</html>