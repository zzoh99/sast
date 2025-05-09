<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='payCd' mdef='급여구분'/>",       Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"payCd",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",           Type:"Text",      Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"sabun",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",           Type:"Text", Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"name",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",         Type:"Text",		Hidden:Number("${aliasHdn}"),  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"alias",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",           Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"orgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",           Type:"Combo",      Hidden:Number("${jgHdn}"),  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikgubCd",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",           Type:"Combo",      Hidden:Number("${jwHdn}"),  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='updownType' mdef='절상/사\n구분'/>",  Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"updownType" ,  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='updownUnitV1' mdef='절상/사\n단위'/>",  Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"updownUnit" ,  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",           Type:"Combo",     Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"taxType",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='taxValue' mdef='세율/액'/>",        Type:"Float",     Hidden:0,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"taxValue",     KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",       Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"sdate",        KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",       Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"edate",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }  ];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// 급여코드
        var payCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList",false).codeList, "");
        sheet1.SetColProperty("payCd", {ComboText:"|"+payCdList[0], ComboCode:"|"+payCdList[1]} );

        // 절상 사 구분
        var updownTypeList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00005"), "");
        sheet1.SetColProperty("updownType", {ComboText:updownTypeList[0], ComboCode:updownTypeList[1]} );

        // 절상/사\n단위
        var updownUnitList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00006"), "");
        sheet1.SetColProperty("updownUnit", {ComboText:updownUnitList[0], ComboCode:updownUnitList[1]} );

		// 구분
		var taxTypeList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00019"), "");
        sheet1.SetColProperty("taxType", {ComboText:taxTypeList[0], ComboCode:taxTypeList[1]} );

	     // 직급
		var jikgubCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "");
        sheet1.SetColProperty("jikgubCd", {ComboText:jikgubCdList[0], ComboCode:jikgubCdList[1]} );

        // 직위
		var jikweeCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");
        sheet1.SetColProperty("jikweeCd", {ComboText:jikweeCdList[0], ComboCode:jikweeCdList[1]} );


		// 조회조건
		var searchPayCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchPayCd").html(searchPayCdList[2]);

		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "name", rv["name"]);
						sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
					}
				}
			]
		});

		$("#searchSabunName").on("keyup", function(e) {
			if (e.keyCode === 13)
				doAction1("Search");
		})
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/TaxRateExceMgr.do?cmd=getTaxRateExceMgrList", $("#sheetForm").serialize() ); break;
		case "Save":
			if(!dupChk(sheet1,"sabun|payCd|sdate", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/TaxRateExceMgr.do?cmd=saveTaxRateExceMgr", $("#sheetForm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), 4); break;
		case "Copy":
			var Row = sheet1.DataCopy();
            sheet1.SelectCell(Row, 5);
            break;
		case "Clear":		sheet1.RemoveAll(); break;
        case "Down2Excel":
					var downcol = makeHiddenSkipCol(sheet1);
					var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
					sheet1.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg !== "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg !== "") { alert(Msg); } doAction1('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift === 1 && KeyCode === 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift === 1 && KeyCode === 46) {
				if (sheet1.GetCellValue(Row, "sStatus") === "I")
					sheet1.RowDelete(Row, 0);
				else
					sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

    //  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
        try{

          var colName = sheet1.ColSaveName(Col);
          var args    = [];

          args["name"]   = sheet1.GetCellValue(Row, "name");
          args["sabun"]  = sheet1.GetCellValue(Row, "sabun");

          if(colName === "name") {
			  let layerModal = new window.top.document.LayerModal({
				  id : 'employeeLayer'
				  , url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
				  , parameters : {
					  name : sheet1.GetCellValue(Row, "name")
					  , sabun : sheet1.GetCellValue(Row, "sabun")
				  }
				  , width : 840
				  , height : 520
				  , title : '사원조회'
				  , trigger :[
					  {
						  name : 'employeeTrigger'
						  , callback : function(result){
							  sheet1.SetCellValue(Row, "name",   result.name );
							  sheet1.SetCellValue(Row, "alias",   result.alias );
							  sheet1.SetCellValue(Row, "sabun",  result.sabun );
							  sheet1.SetCellValue(Row, "orgNm",     result.orgNm );
							  sheet1.SetCellValue(Row, "jikgubCd",  result.jikgubCd);
							  sheet1.SetCellValue(Row, "jikgubNm",  result.jikgubNm);
							  sheet1.SetCellValue(Row, "jikweeCd",  result.jikweeCd);
							  sheet1.SetCellValue(Row, "jikweeNm",  result.jikweeNm);
						  }
					  }
				  ]
			  });
			  layerModal.show();
          }

        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun === "employeePopup2"){
            sheet1.SetCellValue(gPRow, "name",   rv["name"] );
            sheet1.SetCellValue(gPRow, "alias",   rv["alias"] );
            sheet1.SetCellValue(gPRow, "sabun",  rv["sabun"] );
            sheet1.SetCellValue(gPRow, "orgNm",     rv["orgNm"] );
            sheet1.SetCellValue(gPRow, "jikgubCd",  rv["jikgubNm"] );
            sheet1.SetCellValue(gPRow, "jikweeCd",  rv["jikweeNm"] );

	    }
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='114519' mdef='급여구분 '/></th>
						<td><select id="searchPayCd" name="searchPayCd" onchange="javascript:doAction1('Search')"></select></td>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>
							<input id="searchSabunName" name="searchSabunName" type="text" class="text" />
						</td>
						<td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/></td>
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
							<li id="txt" class="txt"><tit:txt mid='taxRateExceMgr' mdef='세율예외자관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>
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
