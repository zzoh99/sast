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
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			 {Header:"No"			,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			 {Header:"삭제"			,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			 {Header:"상태"			,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },
			 {Header:"구분"			,Type:"Combo",    	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"benefitBizCd",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
	         {Header:"성명"			,Type:"Text",  		Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"name",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
	         {Header:"사번"			,Type:"Text",       Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"sabun",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	         {Header:"소속"			,Type:"Text",       Hidden:0,  Width:130,  Align:"Center",    ColMerge:0,   SaveName:"orgNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	         {Header:"직책"			,Type:"Text",       Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	         {Header:"직위"			,Type:"Text",       Hidden:Number("${jwHdn}"),  Width:100,   Align:"Center",    ColMerge:0,   SaveName:"jikweeNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	         {Header:"직무"			,Type:"Text",       Hidden:1,  Width:100,  Align:"Center",    ColMerge:0,   SaveName:"jobNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	         {Header:"비고"			,Type:"Text",       Hidden:0,  Width:110,  Align:"Left",    ColMerge:0,   SaveName:"note",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	   var benefitBizCd 			= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y","B10230"), "전체");//복리후생구분
		sheet1.SetColProperty("benefitBizCd", 						{ComboText:"|"+benefitBizCd[0], 			ComboCode:"|"+benefitBizCd[1]} 		);

		$("#searchBenefitBizCd").html(benefitBizCd[2]);

		$("#searchName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});

		$("#searchBenefitBizCd").bind("change",function(event){
			doAction1("Search");
			$(this).focus();
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
		
		//Autocomplete
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikchakNm",	rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "jobNm",	rv["jobNm"]);
					}
				}
			]
		});		
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/AppBenSabunMgr.do?cmd=getAppBenSabunMgrList", $("#sheet1Form").serialize()); break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/AppBenSabunMgr.do?cmd=saveAppBenSabunMgr", $("#sheet1Form").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "name"); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
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
			doAction1("Search");
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


	// 사원검색 팝입
	function empSearchPopup(Row, Col) {
		let layerModal = new window.top.document.LayerModal({
			id : 'employeeLayer'
			, url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
			, parameters : {}
			, width : 840
			, height : 520
			, title : '사원조회'
			, trigger :[
				{
					name : 'employeeTrigger'
					, callback : function(result){
						sheet1.SetCellValue(Row, "sabun",   result.sabun);
						sheet1.SetCellValue(Row, "name",   result.name);
						sheet1.SetCellValue(Row, "orgNm",   result.orgNm);
						sheet1.SetCellValue(Row, "jikchakNm", result.jikchakNm);
						sheet1.SetCellValue(Row, "jikweeNm",   result.jikweeNm);
					}
				}
			]
		});
		layerModal.show();
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
        if(pGubun == "employeePopup"){
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
			sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
        }
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">

	<form id='sheet1Form' name='sheet1Form' >

	<!-- 조회조건 -->
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>구분</th>
						<td>						
							<select id="searchBenefitBizCd" name ="searchBenefitBizCd" class="box" ></select>
						</td>
						<th>사번/성명 </th>
						<td>
							<input id="searchName" name ="searchName" type="text" class="text" />
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button" >조회</a>
						</td>
					</tr>
				</table>

			</div>
		</div>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt">복리후생담당자관리</li>
								<li class="btn">
									<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
									<a href="javascript:doAction1('Copy')" class="basic authA">복사</a>
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
	</form>
</div>
</body>
</html>
