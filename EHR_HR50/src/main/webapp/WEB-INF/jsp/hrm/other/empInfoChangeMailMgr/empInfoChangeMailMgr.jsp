<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			 {Header:"No"			,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,  SaveName:"sNo" },
			 {Header:"삭제"			,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,  SaveName:"sDelete" },
			 {Header:"상태"			,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,  SaveName:"sStatus" },
			 {Header:"소속"			,Type:"Text",       Hidden:0,  Width:100,  Align:"Center",    ColMerge:0,   SaveName:"orgNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			 {Header:"사번"			,Type:"Text",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"sabun",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			 {Header:"성명"			,Type:"Text",  	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"name",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			 {Header:"직책"			,Type:"Text",       Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			 {Header:"직위"			,Type:"Text",       Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			 {Header:"직급"			,Type:"Text",       Hidden:0,  Width:70,  Align:"Center",    ColMerge:0,   SaveName:"jikgubNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			 {Header:"담당업무"		,Type:"Combo",   Hidden:0,  Width:80,  Align:"Center",    ColMerge:0,   SaveName:"empTable",     KeyField:1,   CalcLogic:"",   Format:"", TrueValue:"Y",FalseValue:"N", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:1 },
			 {Header:"휴대폰"		,Type:"Text",       Hidden:0,  Width:140,  Align:"Left",    ColMerge:0,   SaveName:"handPhone",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
	         {Header:"이메일"		,Type:"Text",       Hidden:0,  Width:140,  Align:"Left",    ColMerge:0,   SaveName:"mailId",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
	         {Header:"메일\n수신여부"	,Type:"CheckBox",   Hidden:0,  Width:80,  Align:"Left",    ColMerge:0,   SaveName:"mailYn",     KeyField:0,   CalcLogic:"",   Format:"", TrueValue:"Y",FalseValue:"N", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
	         {Header:"비고"			,Type:"Text",       Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"note",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
	         
	         {Header:"회사"			,Type:"Text",  		Hidden:1,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"enterNm",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	         {Header:"신청상태",		Type:"Combo",		Hidden:1, 	Width:60,	 Align:"Center", SaveName:"applStatusCd",	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,	Edit:0 },
	         {Header:"SMS\n수신여부"	,Type:"CheckBox",   Hidden:1,  Width:80,  Align:"Left",    ColMerge:0,   SaveName:"smsYn",      KeyField:0,   CalcLogic:"",   Format:"", TrueValue:"Y",FalseValue:"N", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
	         {Header:"그룹웨어\n알림여부",Type:"CheckBox",Hidden:1,  Width:80,  Align:"Left",    ColMerge:0,   SaveName:"gwYn",       KeyField:0,   CalcLogic:"",   Format:"", TrueValue:"Y",FalseValue:"N", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
	         {Header:"회사"			,Type:"Text",  		Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"enterCd",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	         {Header:"jikgubCd"		,Type:"Text",  		Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"jikgubCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	         {Header:"jikchackCd"	,Type:"Text",  		Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"jikchakCd", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	         {Header:"orgCd"		,Type:"Text",  		Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"orgCd", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var param = "&searchCodeNm=1";
		var codeLists = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getEmpInfoChangeTableMgrCodeList"+param, false).codeList, "code,codeNm", " ");
		sheet1.SetColProperty("empTable",  	{ComboText:"|"+codeLists[0], ComboCode:"|"+codeLists[1]} ); //담당자
		
		$(window).smartresize(sheetResize); sheetInit();
		
		$("#searchName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		
		doAction1("Search");
		
		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
						sheet1.SetCellValue(gPRow, "jikchakNm",	rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "handPhone",	rv["handPhone"]);
						sheet1.SetCellValue(gPRow, "mailId",	rv["mailId"]);
						sheet1.SetCellValue(gPRow, "enterCd",	rv["enterCd"]);
					}
				}
			]
		});		
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	
							sheet1.DoSearch( "${ctx}/EmpInfoChangeMailMgr.do?cmd=getEmpInfoChangeMailMgrList", $("#sheetForm").serialize()); break;
		case "Save": 		
							if(!dupChk(sheet1,"sabun|name|empTable", true, true)){break;}
							IBS_SaveName(document.sheet1Form,sheet1);
							sheet1.DoSave( "${ctx}/EmpInfoChangeMailMgr.do?cmd=saveEmpInfoChangeMailMgr", $("#sheet1Form").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "name"); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 })); 
		break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}
	

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{ 
			if (Msg != ""){ 
				alert(Msg); 
			} 
			sheetResize(); 
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{ 
			if(Msg != ""){ 
				alert(Msg); 
			} 
			if( Code > -1 ) doAction1("Search");
		}catch(ex){ 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	}
	
	function sheet1_OnPopupClick(Row, Col) {
		try{
		
			var colName = sheet1.ColSaveName(Col);
			if (Row >= sheet1.HeaderRows()) {
				if (colName == "name") {
					// 사원검색 팝입
					empSearchPopup(Row, Col);
				}
			}
		} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
	}
	
	var gPRow = "";
	// 사원검색 팝입
	function empSearchPopup(Row, Col) {
		if(!isPopup()) {return;}

		var w		= 840;
		var h		= 520;
		var url		= "/Popup.do?cmd=employeePopup";
		var args	= new Array();
		args["sType"] = "G";

		gPRow = Row;
		pGubun = "employeePopup";

		openPopup(url+"&authPg=R", args, w, h);
	}
	
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');
		if (rv) {
			sheet1.SetCellValue(gPRow, "enterCd", rv["enterCd"]);
			sheet1.SetCellValue(gPRow, "enterNm", rv["enterNm"]);
			
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "orgCd", rv["orgCd"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			
			sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
			sheet1.SetCellValue(gPRow, "jikgubCd", rv["jikgubCd"]);
			sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
			sheet1.SetCellValue(gPRow, "jikchakCd", rv["jikchakCd"]);
			sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
			sheet1.SetCellValue(gPRow, "jikweeCd", rv["jikweeCd"]);
			
			sheet1.SetCellValue(gPRow, "handPhone", rv["handPhone"]);
			sheet1.SetCellValue(gPRow, "mailId", rv["mailId"]);
			
		}

	}
	
</script>
</head>
<body class="hidden">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>성명</th>
						<td>  <input id="searchName" name ="searchName" type="text" class="text" /> </td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a> </td>
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
							<li id="txt" class="txt">담당자관리</li>
							<li class="btn">
								<a href="javascript:doAction1('Search')" 	class="btn dark authR">조회</a>
								<a href="javascript:doAction1('Insert')" class="btn outline_gray authA">입력</a>
								<a href="javascript:doAction1('Save')" 	class="btn filled authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>