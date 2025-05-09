<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수세액조회</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	
	$(function() {
		$("#searchYear").val("<%=yeaYear%>") ;
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center", ColMerge:0,	SaveName:"sNo" },	

			{Header:"대상년도",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"work_yy",			KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분",		Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"adjust_type",		KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"부서명",		Type:"Text",	Hidden:0,	Width:90,	Align:"Left",	ColMerge:1,	SaveName:"org_nm",			KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성명",			Type:"Popup",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"name",			KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"사번",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"sabun",			KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			
			{Header:"분납신청여부",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1, SaveName:"tax_ins_yn",	KeyField:0, Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"원천징수\n세액선택",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1, SaveName:"tax_rate",	KeyField:0, Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00303"), "" );		
		
		sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
		sheet1.SetColProperty("tax_ins_yn",	{ComboText:"|미신청|신청", ComboCode:"|N|Y"} );
		sheet1.SetColProperty("tax_rate",	{ComboText:"|120|100|80", ComboCode:"|120|100|80"} );
		
		$("#searchAdjustType").html(adjustTypeList[2]);
		
		$(window).smartresize(sheetResize); sheetInit();
		
		//doAction1("Search");
	});
	
	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search"); 
				$(this).focus(); 
			}
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/taxHisMgr/taxHisMgrRst.jsp?cmd=selectTaxHisMgrList", $("#sheetForm").serialize() ); 
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param	= {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize(); 
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	//사원 조회
	function openEmployeePopup(Row){
		try{
			var args	= new Array();
			
			if(!isPopup()) {return;}
			gPRow = Row;
			pGubun = "employeePopup";
			
			var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");
		/*
			if(rv!=null){
				sheet1.SetCellValue(Row, "name",		rv["name"] );
				sheet1.SetCellValue(Row, "sabun",		rv["sabun"] );
				sheet1.SetCellValue(Row, "org_nm",		rv["org_nm"] );
			}
		*/
		} catch(ex) {
			alert("Open Popup Event Error : " + ex);
		}
	}
	
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "employeePopup" ){
			//사원조회
			sheet1.SetCellValue(gPRow, "name",		rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun",	rv["sabun"] );
			sheet1.SetCellValue(gPRow, "org_nm",	rv["org_nm"] );
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<td><span>년도</span>
				<input id="searchYear" name ="searchYear" type="text" class="text readonly" maxlength="4" style="width:35px" readonly/> </td>
				
				<td><span>작업구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select> 
				</td>
				<td><span>사번/성명</span>
				<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
				<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
			</tr>
		</table>
		</div>
	</div>
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">원천징수세액조회</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>