<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='112882' mdef='고과업로드'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {

		var finalClassCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("finalClassCd", 		{ComboText:"|"+finalClassCd[0], ComboCode:"|"+finalClassCd[1]} );

		// 직군
   		var workTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), "전체");
   		$("#searchWorkType").html(workTypeList[2]);
		
		// 숫자만 입력가능
		$("#searchYear").keyup(function() {
			makeNumber(this,'A');
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		
        $("#searchSaNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchWorkType").bind("change",function(event){
			doAction1("Search");
		});
        
		initSheet();
		
		doAction1("Search") ;
	});
	
	
	function initSheet(){
		
		var year = Number($("#searchYear").val());
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:0, FrozenColRight:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
 
		initdata1.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

			{Header:"본부|본부",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"priorOrgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
			{Header:"부서|부서",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
			{Header:"직군|직군",	Type:"Text",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"workTypeNm", 	    KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"직급|직급",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
			{Header:"사번|사번",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
			{Header:"성명|성명",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
			
			{Header:year+"년|고과",	Type:"Combo",   Hidden:0,   Width:20,   Align:"Center", ColMerge:0, SaveName:"finalClassCd1",    KeyField:0, Format:"", 			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
			{Header:year+"년|업적",	Type:"Int",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"mboPoint1",		KeyField:0,	Format:"####",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 },
			{Header:year+"년|역량",	Type:"Int",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"compPoint1",		KeyField:0,	Format:"####",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 },
			
			{Header:(year-1)+"년|고과",	Type:"Combo",   Hidden:0,   Width:20,   Align:"Center", ColMerge:0, SaveName:"finalClassCd2",    KeyField:0, Format:"", 			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
			{Header:(year-1)+"년|업적",	Type:"Int",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"mboPoint2",		KeyField:0,	Format:"####",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 },
			{Header:(year-1)+"년|역량",	Type:"Int",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"compPoint2",		KeyField:0,	Format:"####",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 },
			
			{Header:(year-2)+"년|고과",	Type:"Combo",   Hidden:0,   Width:20,   Align:"Center", ColMerge:0, SaveName:"finalClassCd3",    KeyField:0, Format:"", 			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
			{Header:(year-2)+"년|업적",	Type:"Int",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"mboPoint3",		KeyField:0,	Format:"####",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 },
			{Header:(year-2)+"년|역량",	Type:"Int",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"compPoint3",		KeyField:0,	Format:"####",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 },
			
			{Header:(year-3)+"년|고과",	Type:"Combo",   Hidden:0,   Width:20,   Align:"Center", ColMerge:0, SaveName:"finalClassCd4",    KeyField:0, Format:"", 			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
			{Header:(year-3)+"년|업적",	Type:"Int",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"mboPoint4",		KeyField:0,	Format:"####",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 },
			{Header:(year-3)+"년|역량",	Type:"Int",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"compPoint4",		KeyField:0,	Format:"####",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 },
			
			{Header:(year-4)+"년|고과",	Type:"Combo",   Hidden:0,   Width:20,   Align:"Center", ColMerge:0, SaveName:"finalClassCd5",    KeyField:0, Format:"", 			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
			{Header:(year-4)+"년|업적",	Type:"Int",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"mboPoint5",		KeyField:0,	Format:"####",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 },
			{Header:(year-4)+"년|역량",	Type:"Int",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"compPoint5",		KeyField:0,	Format:"####",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 }
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var finalClassCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("finalClassCd1", 		{ComboText:"|"+finalClassCd[0], ComboCode:"|"+finalClassCd[1]} );
		sheet1.SetColProperty("finalClassCd2", 		{ComboText:"|"+finalClassCd[0], ComboCode:"|"+finalClassCd[1]} );
		sheet1.SetColProperty("finalClassCd3", 		{ComboText:"|"+finalClassCd[0], ComboCode:"|"+finalClassCd[1]} );
		sheet1.SetColProperty("finalClassCd4", 		{ComboText:"|"+finalClassCd[0], ComboCode:"|"+finalClassCd[1]} );
		sheet1.SetColProperty("finalClassCd5", 		{ComboText:"|"+finalClassCd[0], ComboCode:"|"+finalClassCd[1]} );
		
		$(window).smartresize(sheetResize); sheetInit();
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.Reset();
			initSheet();
			
			var sXml = sheet1.GetSearchData("${ctx}/EmpPapHistMgr.do?cmd=getEmpPapHistMgrList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml);
        	break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='112528' mdef='년도'/></th> 
			<td colspan="2"> 
				<input type="text" id="searchYear" name="searchYear" class="date2" value="${curSysYear}" maxlength="4"/>
			</td>
			<th>직군</th>
			<td>
				<select id="searchWorkType" name="searchWorkType" class="box"></select>
			</td>
			<th><tit:txt mid='104330' mdef='사번/성명'/></th>
			<td>
				<input id="searchSaNm" name="searchSaNm" type="text" class="text"/>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='110697' mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='112882' mdef='고과업로드'/></li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
