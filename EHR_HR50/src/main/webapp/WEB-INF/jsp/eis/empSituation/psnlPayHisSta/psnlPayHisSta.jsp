<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='timeCdMgr' mdef='근태코드관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include 
file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msNone,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='appOrgCdV5' mdef='소속코드'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikweeCdV2' mdef='직위코드'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applJikchakNmV1' mdef='직책'/>",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"year",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"year",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"titleMon1",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"titleMon1",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"titleMon2",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"titleMon2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"titleMon3",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"titleMon3",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"titleMon4",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"titleMon4",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"mon1",			Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"mon1",		KeyField:0,	Format:"Integer",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"mon2",			Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"mon2",		KeyField:0,	Format:"Integer",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"mon3",			Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"mon3",		KeyField:0,	Format:"Integer",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"mon4",			Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"mon4",		KeyField:0,	Format:"Integer",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");
	});

	$(function() {

		$("#searchYear").val("${curSysYear}") ;
		$("#searchYear").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		var tempYear = $("#searchYear").val();
		var i;
		for(i=1;i<5;i++){
			sheet1.SetCellValue(0, "mon"+i, (tempYear-4+parseInt(i)));
		}
		$("#searchOrgCd").val("0") ;

		//직위
		var searchJikweeCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");
		$("#searchJikweeCd").html(searchJikweeCd[2]);
		$("#searchJikweeCd").select2({
			placeholder: "<tit:txt mid='103895' mdef='전체'/>"
			, maximumSelectionSize:100
		});
		
		//직책
		var searchJikchakCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), "");
		$("#searchJikchakCd").html(searchJikchakCd[2]);
		$("#searchJikchakCd").select2({
			placeholder: "<tit:txt mid='103895' mdef='전체'/>"
			, maximumSelectionSize:100
		});

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			$("#jikweeCd").val(($("#searchJikweeCd").val()==null?"":getMultiSelect($("#searchJikweeCd").val())));
			$("#jikchakCd").val(($("#searchJikchakCd").val()==null?"":getMultiSelect($("#searchJikchakCd").val())));

			sheet1.DoSearch( "${ctx}/PsnlPayHisSta.do?cmd=getPsnlPayHisStaList", $("#sheet1Form").serialize() );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
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

			sheetResize();

			 //소속/직위 row 강제 merge
			 /* var oldOrgCd ;
			 var orgCd;
			 var oldJikweeCd;
			 var jikweeCd;

			 var orgFirstRow    = 0;
			 var jikweeFirstRow = 0;
			 for (var i=1; i<=sheet1.LastRow(); i++){
				 if (i == 1){
					 sheet1.SetCellValue(0, "mon1", sheet1.GetCellValue(1,"titleMon1"));
					 sheet1.SetCellValue(0, "mon2", sheet1.GetCellValue(1,"titleMon2"));
					 sheet1.SetCellValue(0, "mon3", sheet1.GetCellValue(1,"titleMon3"));
					 sheet1.SetCellValue(0, "mon4", sheet1.GetCellValue(1,"titleMon4"));
				 }
				 orgCd    = sheet1.GetCellValue(i, "orgCd");
				 jikweeCd = sheet1.GetCellValue(i, "jikweeCd");

				 if (oldOrgCd != orgCd){
					 if (orgFirstRow > 0){
						 sheet1.SetMergeCell(orgFirstRow,    sheet1.SaveNameCol("orgNm"),    i-orgFirstRow,    1);
						 sheet1.SetMergeCell(jikweeFirstRow, sheet1.SaveNameCol("jikweeNm"), i-jikweeFirstRow, 1);
					 }
					 oldOrgCd       = orgCd;
					 oldJikweeCd    = jikweeCd;
					 orgFirstRow    = i;
					 jikweeFirstRow = i;
				 } else if (oldJikweeCd != jikweeCd){
					 if (jikweeFirstRow > 0){
						 sheet1.SetMergeCell(jikweeFirstRow, sheet1.SaveNameCol("jikweeNm"), i-jikweeFirstRow, 1);
					 }
					 oldJikweeCd    = jikweeCd;
					 jikweeFirstRow = i;
				 } else if (i == sheet1.LastRow()){
					 sheet1.SetMergeCell(orgFirstRow,    sheet1.SaveNameCol("orgNm"),    i-orgFirstRow+1,    1);
					 sheet1.SetMergeCell(jikweeFirstRow, sheet1.SaveNameCol("jikweeNm"), i-jikweeFirstRow+1, 1);
				 }
			 } */

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	var pGubun;
	var gPRow;
/* 	function sheet1_OnClick(Row, Col, Value) {
		try {

			if(!isPopup()) {return;}

			pGubun = "chart";
			gPRow    = Row;

			var url = "${ctx}/PsnlPayHisSta.do?cmd=viewPsnlPayHisStaPopup";

    		var args 	= new Array();
    		args["sheet1"] 	= sheet1;
    		openPopup(url, args, 1200, 700);

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	} */

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form id="sheet1Form" name="sheet1Form">
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<th><tit:txt mid='103774' mdef='기준년도'/></th>
		        <td>
		             <input class="text w70 center" type="text" id="searchYear" name="searchYear" size="8" maxlength="4">
		        </td>
		        <th><tit:txt mid='104295' mdef='소속'/></th>
				<td>   <input id="searchOrgNm" name="searchOrgNm" type="text" class="text w150" /> </td>
				<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark"><tit:txt mid='104081' mdef='조회'/></a> </td>
			</tr>
			<tr>
				<th><tit:txt mid='104104' mdef='직위'/></th>
				<td>
					<select id="searchJikweeCd" name="searchJikweeCd" multiple ></select>
					<input type="hidden" id="jikweeCd" name="jikweeCd" value=""/>
				</td>
				<th><tit:txt mid='103785' mdef='직책'/></th>
				<td>
					<select id="searchJikchakCd" name="searchJikchakCd" multiple ></select>
					<input type="hidden" id="jikchakCd" name="jikchakCd" value=""/>
				</td>
			</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">개인별연봉 변동추이&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="blue">각 년도별 12월 31일 기준 조회.</font></li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
