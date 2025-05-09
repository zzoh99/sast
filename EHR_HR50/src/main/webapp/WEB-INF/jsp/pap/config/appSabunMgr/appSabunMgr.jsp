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
	         {Header:"성명"			,Type:"Text",  	Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"name",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
	         {Header:"사번"			,Type:"Text",       Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"sabun",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	         {Header:"호칭"			,Type:"Text",       Hidden:Number("${aliasHdn}"),  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"alias",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	         {Header:"소속"			,Type:"Text",       Hidden:0,  Width:130,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	         {Header:"직급"			,Type:"Text",       Hidden:Number("${jgHdn}"),  Width:90,   Align:"Left",    ColMerge:0,   SaveName:"jikgubNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	         {Header:"직위"			,Type:"Text",       Hidden:Number("${jwHdn}"),  Width:90,   Align:"Left",    ColMerge:0,   SaveName:"jikweeNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	         {Header:"직책"			,Type:"Text",       Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	         {Header:"직무"			,Type:"Text",       Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"jobNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	         {Header:"비고"			,Type:"Text",       Hidden:0,  Width:110,  Align:"Left",    ColMerge:0,   SaveName:"note",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//Autocomplete	
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow,"name", rv["name"]);
						sheet1.SetCellValue(gPRow,"alias", rv["empAlias"]);
						sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow,"orgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow,"orgCd", rv["orgCd"]);
						sheet1.SetCellValue(gPRow,"jikchakCd", rv["jikchakCd"]);
						sheet1.SetCellValue(gPRow,"jikchakNm", rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow,"jikweeCd", rv["jikweeCd"]);
						sheet1.SetCellValue(gPRow,"jikweeNm", rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow,"jikgubCd", rv["jikgubCd"]);
						sheet1.SetCellValue(gPRow,"jikgubNm", rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow,"jobNm", rv["jobNm"]);
					}
				}
			]
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppSabunMgr.do?cmd=getAppSabunMgrList" ); break;
		case "Save":
							if(!dupChk(sheet1,"sabun", true, true)){break;}
							IBS_SaveName(document.sheet1Form,sheet1);
							sheet1.DoSave( "${ctx}/AppSabunMgr.do?cmd=saveAppSabunMgr", $("#sheet1Form").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "name"); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
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
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
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

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "employeePopup"){
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "alias", rv["alias"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
			sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
			sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
		}
	}

</script>
</head>
<body class="hidden">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">평가담당자관리</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
								<a href="javascript:doAction1('Insert')" class="btn outline-gray authA">입력</a>
								<a href="javascript:doAction1('Save')" 	class="btn filled authA">저장</a>
								<a href="javascript:doAction1('Search')" class="btn dark authR">조회</a>
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