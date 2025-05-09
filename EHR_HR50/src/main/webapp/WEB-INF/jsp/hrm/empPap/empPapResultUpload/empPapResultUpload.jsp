<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='112882' mdef='고과업로드'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='appraisalYy_v' mdef='년도'/>",	Type:"Int",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalYy",		KeyField:1,	Format:"####",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4 },
			{Header:"<sht:txt mid='sabun_v' mdef='사번'/>",			Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
			{Header:"<sht:txt mid='name_v' mdef='성명'/>",			Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='finalClassCd_v' mdef='고과'/>",	Type:"Combo",   Hidden:0,   Width:80,   Align:"Center", ColMerge:0, SaveName:"finalClassCd",    KeyField:0, Format:"", 		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"<sht:txt mid='mboPoint_v' mdef='업적'/>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"mboPoint",		KeyField:0,	Format:"####",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3 },
			{Header:"<sht:txt mid='compPoint_v' mdef='역량'/>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compPoint",		KeyField:0,	Format:"####",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3 }
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// 성명 입력시 자동완성 처리
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
					}
				}
			]
		});

		var finalClassCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("finalClassCd", 		{ComboText:"|"+finalClassCd[0], ComboCode:"|"+finalClassCd[1]} );

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

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search") ;

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var sXml = sheet1.GetSearchData("${ctx}/EmpPapResultUpload.do?cmd=getEmpPapResultUploadList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml);
        	break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SelectCell(row, 'name');
			break;
		case "Save":
			if(!dupChk(sheet1,"appraisalYy|sabun", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/EmpPapResultUpload.do?cmd=saveEmpPapResultUpload" ,$("#sheet1Form").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SelectCell(row, 'name');
			break;
		case "DownTemplate":
			// 양식다운로드
			var d = new Date();
			var fName = "고과업로드(업로드양식)_" + d.getTime();
			sheet1.Down2Excel({ FileName:fName, SheetDesign:1, Merge:1, DownRows:"0", DownCols:"3|4|6|7|8"});
			break;
		case "LoadExcel":
			// 업로드
			var params = {};
			sheet1.LoadExcel(params);
			break;
		}
	}

	function sheet1_OnLoadExcel() {
		sheet1.SetRangeValue("20", sheet1.HeaderRows(), 14, sheet1.LastRow(), 14);
	}

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

	function sheet1_OnChange(Row, Col, Value) {
		try{
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	var gPRow = "";
    var pGubun = "";
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function getReturnValue(rv) {

	}

	function sheet1_OnClick(Row, Col, Value) {
		try{
		} catch(ex){alert("OnClick Event Error : " + ex);}
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
				<btn:a href="javascript:doAction1('DownTemplate')" 	css="btn outline-gray authR" mid='110702' mdef="양식다운로드"/>
				<btn:a href="javascript:doAction1('LoadExcel')" 	css="btn outline-gray authR" mid='110703' mdef="업로드"/>
				<btn:a href="javascript:doAction1('Copy');" 		css="btn outline-gray authA" mid='110696' mdef="복사"/>
				<btn:a href="javascript:doAction1('Insert');" 		css="btn outline-gray authA" mid='110700' mdef="입력"/>
				<btn:a href="javascript:doAction1('Save');" 		css="btn filled authA" mid='110708' mdef="저장"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
