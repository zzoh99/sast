<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>평가차수반영비율</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
//선택된 탭
var newIframe;
var oldIframe;
var iframeIdx;

	$(function() {
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No"				,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제"				,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete" },
			{Header:"상태"				,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
			
			{Header:"년도",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"yyyy",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"KPI코드",			Type:"Int",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"kpiCd",	KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"KPI명",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"kpiNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"평가방법\n척도유형",	Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"measureTypeCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"평가지표\n구분코드",	Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appIndexGubunCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"KPI정의",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"kpiDefNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500},
			{Header:"평가지표\n유형코드",	Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appIndexTypeCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"KPI산식",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"kpiFormulaNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"균형성과\n지표코드",	Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appIndexCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"데이터출처",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"kpiDataSourceNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"단위척도\n범위유형",	Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"measureScopeCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"KPI최소보고주기",Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"kpiMinReportCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"사용\n여부",			Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"useYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1}

		];IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}"); sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);
		
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		
		//var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList",false).codeList, ""); //평가명
		
		var comboList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S20030"),""); // 평가방법_척도유형
		var comboList2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00011"),""); // 평가지표구분코드
		var comboList3 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00013"),""); // 평가지표유형코드
		var comboList4 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00009"),""); // 균형성과지표코드
		var comboList5 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S20050"),""); // 단위_척도범위유형
		var comboList6 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00015"),""); // KPI최소보고주기코드
	
		sheet1.SetColProperty("measureTypeCd", 	{ComboText:comboList1[0], ComboCode:comboList1[1]} );// 평가방법_척도유형
		sheet1.SetColProperty("appIndexGubunCd", 	{ComboText:comboList2[0], ComboCode:comboList2[1]} );// 평가지표구분코드
		sheet1.SetColProperty("appIndexTypeCd", {ComboText:comboList3[0], ComboCode:comboList3[1]} );
		sheet1.SetColProperty("appIndexCd", 	{ComboText:comboList4[0], ComboCode:comboList4[1]} );
		sheet1.SetColProperty("measureScopeCd", {ComboText:comboList5[0], ComboCode:comboList5[1]} );
		sheet1.SetColProperty("kpiMinReportCd", {ComboText:comboList6[0], ComboCode:comboList6[1]} );
		sheet1.SetColProperty("useYn", {ComboText:"|사용|미사용", ComboCode:"|Y|N"} );
		$("#appraisalYy").html(comboList2[2]);
		
		var sOption = "";
		var nowYY = parseInt("${curSysYear}", 10);
		for(var i = nowYY-5 ; i < nowYY+5; i++) {
			if ( i == nowYY ) sOption += "<option value='"+ i +"' selected>"+ i +"</option>";
			else sOption += "<option value='"+ i +"'>"+ i +"</option>";
		}
		$("#appraisalYy").html(sOption);
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
		
	});	
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			//doAction2("Clear");
			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getAppKpiDicMgrList", $("#srchFrm").serialize() );
			break;
			
		case "Save":
			if(sheet1.FindStatusRow("I") != ""){
				if(!dupChk(sheet1,"appraisalCd", true, true)){break;}
			}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/SaveData.do?cmd=saveAppKpiDicMgr", $("#srchFrm").serialize());
			break;
			
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "yyyy", $("#appraisalYy").val());
			sheet1.SelectCell(row, "kpiNm");
			break;
			
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row,"kpiCd","");
			
			break;
			
		case "Clear":
			sheet1.RemoveAll();
			break;
			
		case "Down2Excel":
			sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
			break;
			
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"3|5|8|10"});
			break;
		}
	}
	


	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);
			
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			if ( Code != "-1" ) doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
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

	}
</script>


</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가년도</span>
							<select name="appraisalYy" id="appraisalYy" onChange="javascript:doAction1('Search');">
							</select>
						</td>
						<td>
							<span>KPI명</span>
							<input type="text" id="searchKpiNm" name="searchKpiNm" class="text" />
						</td>
						<td>
							<span>사용여부</span>
							<select name="searchUseYn" id="searchUseYn" onChange="javascript:doAction1('Search');">
								<option value="Y">사용</option>
								<option value="N">미사용</option>
							</select>
							
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
						</td>
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
							<li id="txt" class="txt">년도별KPI사전</li>
							<li class="btn">
								<a href="javascript:doAction1('DownTemplate')" class="basic authA">양식다운로드</a>
								<a href="javascript:doAction1('LoadExcel')" class="basic authA">업로드</a>
								<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>