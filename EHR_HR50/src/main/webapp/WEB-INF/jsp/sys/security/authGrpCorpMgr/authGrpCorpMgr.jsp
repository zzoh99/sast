<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>권한별회사관리</title>
<link rel="stylesheet" href="/common/${theme}/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var grpCdList = '';

	$(function() {
		grpCdList = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getGrpNmAllList",false).codeList;
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0,	HeaderCheck:1 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
			{Header:"회사",				Type:"Combo",		Hidden:0,					Width:200,			Align:"Left",	ColMerge:0,	SaveName:"enterCd",		KeyField:1,		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"권한그룹코드",		Type:"Combo",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"grpCd",		KeyField:1,		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"권한그룹코드1",		Type:"Text",		Hidden:1,					Width:0,			Align:"Center",	ColMerge:0,	SaveName:"grpCd1",		KeyField:1,		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"권한그룹",			Type:"Text",		Hidden:1,					Width:130,			Align:"Left",	ColMerge:0,	SaveName:"grpNm",		KeyField:0,		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"그룹사\n조회여부",	Type:"Combo",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"enterAllYn",	KeyField:0,		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"그룹사\n조회여부",	Type:"Text",		Hidden:1,					Width:0,			Align:"Center",	ColMerge:0,	SaveName:"enterAllYn1",	KeyField:0,		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			//{Header:"그룹사\n조회여부",	Type:"Popup",		Hidden:1,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"enterAllYnNm",	KeyField:0,		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"계열사",			Type:"Combo",		Hidden:0,					Width:200,			Align:"Center",	ColMerge:0,	SaveName:"authEnterCd",	KeyField:1,		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"계열사명",			Type:"Combo",		Hidden:1,					Width:200,			Align:"Left",	ColMerge:0,	SaveName:"authEnterNm",	KeyField:0,		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"순서",				Type:"Int",			Hidden:1,					Width:40,			Align:"Right",	ColMerge:0,	SaveName:"seq",			KeyField:0,		CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 }
		]; IBS_InitSheet(mySheet, initdata); mySheet.SetCountPosition(4);

		mySheet.SetEditable("${editable}");

		var enterCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getEnterCdAllListMSsnEnterCd&useYn=Y",false).codeList, "전체");
		mySheet.SetColProperty("enterCd", {ComboText: "|"+enterCdList[0], ComboCode: "|"+enterCdList[1]});
		mySheet.SetColProperty("authEnterCd", {ComboText: "|"+enterCdList[0], ComboCode: "|"+enterCdList[1]});
		
		$("#searchEnterCd").html(enterCdList[2]);
		$("#searchAuthEnterCd").html(enterCdList[2]);

		$("#searchEnterCd").bind("change",function(event){
			var enterCd = $(this).val();
			
			var optionStr = "<option value=''>전체</option>";
			for (i = 0; i < grpCdList.length; i++) {
				if ( grpCdList[i].enterCd != enterCd ) continue;
				optionStr += "<option value='" + grpCdList[i].code + "'>" + grpCdList[i].codeNm + "</option>";
			}
			$("#searchGrpCd").html(optionStr);
			
			doAction('Search');
		});
		
		$(window).smartresize(sheetResize); sheetInit();
		
		//doAction("Search");
		$("#searchEnterCd").change();
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	mySheet.DoSearch( "${ctx}/GetDataList.do?cmd=getAuthGrpCorpMgrList", $("#mySheetForm").serialize() ); break;
		case "Save":
							if(!dupChk(mySheet,"enterCd|grpCd|authEnterCd", false, true)){break;}
							IBS_SaveName(document.mySheetForm,mySheet);
							mySheet.DoSave( "${ctx}/AuthGrpCorpMgr.do?cmd=saveAuthGrpCorpMgr", $("#mySheetForm").serialize()); break;
		case "Insert":
			mySheet.SelectCell(mySheet.DataInsert(0), "column1");
			mySheet.SetColProperty("grpCd", {"ComboCode": "","ComboText": ""});
			mySheet.SetColProperty("enterAllYn", {"ComboCode": "","ComboText": ""});
			break;
		case "Copy":		mySheet.SelectCell(mySheet.DataCopy(), "column1"); break;
		case "Clear":		mySheet.RemoveAll(); break;
		case "Down2Excel":	mySheet.Down2Excel(); break;
		case "LoadExcel":
			if($("#searchEnterCd").val() === '') {
				alert("회사를 선택하세요.");
				$("#searchEnterCd").focus();
				return;
			}

			var enterCd = $("#searchEnterCd").val();
			var grpCd = "";
			var grpNm = "";
			var enterAllYn = "";

			for (i = 0; i < grpCdList.length; i++) {
				if ( grpCdList[i].enterCd != enterCd ) continue;
				grpCd += grpCdList[i].code + "|";
				grpNm += grpCdList[i].codeNm + "|";
				enterAllYn += grpCdList[i].enterAllYn + "|";
			}

			grpCd = grpCd.substr(0, grpCd.length - 1);
			grpNm = grpNm.substr(0, grpNm.length - 1);
			enterAllYn = enterAllYn.substr(0, enterAllYn.length - 1);

			mySheet.SetColProperty("grpCd", {"ComboCode": grpCd,"ComboText": grpNm});
			mySheet.SetColProperty("enterAllYn", {"ComboCode": grpCd,"ComboText": enterAllYn});

			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; mySheet.LoadExcel(params); break;
		case "Down2Template":
							var downCols = "grpCd|authEnterCd";
							var param  = {DownCols:downCols,SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"};
							mySheet.Down2Excel(param);
							break;
		}
	}

	function mySheet_OnChange(Row, Col, Value){
		try{
			/*
			if(mySheet.ColSaveName(Col) == "authEnterNm"){
				mySheet.SetCellValue(Row, "authEnterCd", mySheet.GetCellValue(Row, "authEnterNm"));
			}
			
			
			if(mySheet.ColSaveName(Col) == "grpNm"){
				mySheet.SetCellValue(Row, "grpCd", mySheet.GetCellValue(Row, "grpNm"));
				mySheet.SetCellValue(Row, "enterAllYn", mySheet.GetCellValue(Row, "grpNm"));
			}
			*/
			if(mySheet.ColSaveName(Col) == "grpCd"){
				mySheet.SetCellValue(Row, "enterAllYn", mySheet.GetCellValue(Row, "grpCd"));
			}
			
			if(mySheet.ColSaveName(Col) == "enterCd"){
				var enterCd = mySheet.GetCellValue(Row, "enterCd");
				var grpCd = "";
				var grpNm = "";
				var enterAllYn = "";
				
				for (i = 0; i < grpCdList.length; i++) {
					if ( grpCdList[i].enterCd != enterCd ) continue;
					grpCd += grpCdList[i].code + "|";
					grpNm += grpCdList[i].codeNm + "|";
					enterAllYn += grpCdList[i].enterAllYn + "|";
				}
				
				grpCd = grpCd.substr(0, grpCd.length - 1);
				grpNm = grpNm.substr(0, grpNm.length - 1);
				enterAllYn = enterAllYn.substr(0, enterAllYn.length - 1);
				
				mySheet.CellComboItem(Row, "grpCd", {"ComboCode": grpCd,"ComboText": grpNm});
				mySheet.CellComboItem(Row, "enterAllYn", {"ComboCode": grpCd,"ComboText": enterAllYn});
			}
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}

	// 조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { alert(Msg); } sheetResize();
			
			if (Code != "-1") {
				for(var Row = mySheet.HeaderRows(); Row <= mySheet.LastRow(); Row++) {
					var enterCd = mySheet.GetCellValue(Row, "enterCd");
					var grpCd = "";
					var grpNm = "";
					var enterAllYn = "";
					
					for (i = 0; i < grpCdList.length; i++) {
						if ( grpCdList[i].enterCd != enterCd ) continue;
						grpCd += grpCdList[i].code + "|";
						grpNm += grpCdList[i].codeNm + "|";
						enterAllYn += grpCdList[i].enterAllYn + "|";
					}
					
					grpCd = grpCd.substr(0, grpCd.length - 1);
					grpNm = grpNm.substr(0, grpNm.length - 1);
					enterAllYn = enterAllYn.substr(0, enterAllYn.length - 1);
					
					mySheet.CellComboItem(Row, "grpCd", {"ComboCode": grpCd,"ComboText": grpNm});
					mySheet.CellComboItem(Row, "enterAllYn", {"ComboCode": grpCd,"ComboText": enterAllYn});
					
					mySheet.SetCellValue( Row , "grpCd" , mySheet.GetCellValue(Row, "grpCd1") , false );
					mySheet.SetCellValue( Row , "enterAllYn" , mySheet.GetCellValue(Row, "enterAllYn1") , false );
					mySheet.SetCellValue( Row, "sStatus", "" );
				}
			}
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function mySheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function mySheet_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && mySheet.GetCellValue(Row, "sStatus") == "I") {
				mySheet.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function mySheet_OnLoadExcel() {
		for(var i = 1; i <= mySheet.RowCount(); i++){
			mySheet.SetCellValue(i, "enterCd", $("#searchEnterCd").val());
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
 		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>회사 </th>
						<td>  <select id="searchEnterCd" name ="searchEnterCd" class="box" class="w250"></select> </td>
						<th>권한그룹 </th>
						<td>  <select id="searchGrpCd" name ="searchGrpCd" class="box" onchange="javascript:doAction('Search');" class="w100"></select> </td>
						<th>계열사명 </th>
						<td>  <select id="searchAuthEnterCd" name ="searchAuthEnterCd" class="box" onchange="javascript:doAction('Search');" class="w250"></select> </td>
						<td> <a href="javascript:doAction('Search')" id="btnSearch" class="btn dark">조회</a> </td>
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
							<li id="txt" class="txt">권한별회사관리<b style="color:#FF4040;">&nbsp;&nbsp;&nbsp;&nbsp;그룹사조회여부가 ‘예’인 권한그룹에 한해 해당 계열사를 조회할 수 있습니다.</b></li>
							<li class="btn">
								<a href="javascript:doAction('Down2Excel')" 	class="btn outline-gray authA">다운로드</a>
								<a href="javascript:doAction('Down2Template')"	class="btn outline-gray authA">양식다운로드</a>
								<a href="javascript:doAction('LoadExcel')"		class="btn outline-gray authA">업로드</a>
								<a href="javascript:doAction('Copy')"			class="btn outline-gray authA">복사</a>
								<a href="javascript:doAction('Insert')"			class="btn outline-gray authA">입력</a>
								<a href="javascript:doAction('Save')"			class="btn filled authA">저장</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("mySheet", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>