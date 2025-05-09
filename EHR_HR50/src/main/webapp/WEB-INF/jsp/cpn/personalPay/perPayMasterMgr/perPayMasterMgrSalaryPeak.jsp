<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>급여기본사항 지급/공제 예외사항</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 급여기본사항
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var actionGubun = "";
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:6};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"연차",       	Type:"Combo",       Hidden:0, 					 Width:70,   		Align:"Center",	ColMerge:0,	SaveName:"year",	KeyField:1,   CalcLogic:"", Format:"",   		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
		{Header:"지급율(%)",    Type:"Float",     	Hidden:0,  					Width:75,   		Align:"Center",	ColMerge:1,	SaveName:"rate",	KeyField:1,   CalcLogic:"", Format:"Float",     PointCount:5,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
		{Header:"시작월",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"sYm",		KeyField:1,					Format:"Ym",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"종료월",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"eYm",		KeyField:1,					Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"비고",			Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"bigo",	KeyField:0,					Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"선택",			Type:"DummyCheck",	Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"check",	KeyField:0,					Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);


	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 연차(TSYS006)
	var year = convCode( ajaxCall("${ctx}/PerPayMasterMgr.do?cmd=getYearCombo","",false).DATA, "선택");
	sheet1.SetColProperty("year", {ComboText:"선택|"+year[0], ComboCode:"|"+year[1]});
	
	//저장시 Code 대신 Text 값이 전달되도록 한다.
    sheet1.SetSendComboData(0,"year","Text");

	$(window).smartresize(sheetResize);
	sheetInit();
	
	$("#searchYm").datepicker2({ymonly:true});
	$("#searchYm").bind("keyup",function(event){
		if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
	});
	if (parent.$("#searchSabunRef").val() != null && parent.$("#searchSabunRef").val() != "") {
		$("#sabun").val(parent.$("#searchSabunRef").val());
		doAction1("Search");
	}
});

// 필수값/유효성 체크
function chkInVal(sAction, sheet) {
	if (sAction == "Search") {

		if(parent.$("#searchSabunRef").val() == "") {
			alert("대상자를 선택하십시오.");
			return false;
		}
	} else if (sAction == "Save" && sheet == "sheet1") {
		// 시작일자와 종료일자 체크
		var rowCnt = sheet1.RowCount();
		for (var i=1; i<=rowCnt; i++) {
			if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
				if (sheet1.GetCellValue(i, "sYm") != null && sheet1.GetCellValue(i, "eYm") != "") {
					var sdate = sheet1.GetCellValue(i, "sYm");
					var edate = sheet1.GetCellValue(i, "eYm");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("시작월이 종료월보다 큽니다.");
						sheet1.SelectCell(i, "eYm");
						return false;
					}
				}
			}
		}
	} 

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			actionGubun = "Search";
			// 필수값/유효성 체크
			if (!chkInVal(sAction, "sheet1")) {
				break;
			}

			$("#sabun").val(parent.$("#searchSabunRef").val());
			
			// 지급 조회
			sheet1.DoSearch("${ctx}/PerPayMasterMgr.do?cmd=getPerPayMasterMgrSalaryPeak", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal(sAction, "sheet1")) {
				break;
			}

			$("#sabun").val(parent.$("#searchSabunRef").val());

			// 중복체크
			if(!dupChk(sheet1, "sabun|year|sYm", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/PerPayMasterMgr.do?cmd=savePerPayMasterMgrSalaryPeak", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if (!chkInVal(sAction, "sheet1")) {
				break;
			}

			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "sabun", $("#sabun").val());
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SelectCell(Row, 2);
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
			
		case "edateUpdate":
			actionGubun = "edateUpdate";
			
			var checkedRow = sheet1.CheckedRows("check");
			
			if(checkedRow == 0){
				alert("기준연차 데이터를 선택한 후 생성해 주시기 바랍니다");
				return;
			}
			
			var sRow = sheet1.FindCheckedRow("check");
			var row = sRow.split("|")[0];
			
			showOverlay(0,"처리중입니다. 잠시만 기다려주세요.");
			setTimeout(function(){
				
				$("#searchYear").val(sheet1.GetCellText(row,"year"));
				
				sheet1.DoSearch("${ctx}/PerPayMasterMgr.do?cmd=getPerPayMasterMgrSalaryPeakCalc", $("#sheet1Form").serialize());
				hideOverlay();
			}, 100);
			break;
	}
}


// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); 
		} else {
			
			if(actionGubun == "edateUpdate") {
				var firstRow = sheet1.GetDataFirstRow();
				var lastRow	 = sheet1.GetDataLastRow();
				for (i=firstRow; i<=lastRow;i++) {
					if(Number(sheet1.GetCellText(i, "year")) > Number($("#searchYear").val())) {
						sheet1.SetCellValue(i, "sStatus", "I");
					}
				}
			}
			//초기화
			$("#searchYear").val("");
			sheetResize(); 
		}
	
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

// 셀에서 키보드가 눌렀을때 발생하는 이벤트
function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		var colName = sheet1.ColSaveName(Col);
		if (sheet1.GetCellEditable(Row, Col) == true) {
			if (colName == "elementNm" && KeyCode == 46) {
				// 항목코드 초기화
				sheet1.SetCellValue(Row,"elementCd","");
			}
		}
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}


function sheet1_OnChange(Row, Col, Value) {
	
    var sSaveName = sheet1.ColSaveName(Col);
	if(sSaveName == "year"){
		sheet1.SetCellValue(Row, "rate", Value);
	  }
}


function sheet1_OnBeforeCheck(Row, Col) {
	
	var saveName = sheet1.CellSaveName(Row, Col);
	if ("check"==saveName){
			
		var firstRow = sheet1.GetDataFirstRow();
		var lastRow	 = sheet1.GetDataLastRow();
		for (i=firstRow; i<=lastRow;i++) {
			if (sheet1.GetCellValue(i, "check")==1) {
				sheet1.SetCellValue(i, Col, 0, 0);
			}
		}
	}
	
	//$("#searchYear").val(sheet1.GetComboInfo(Row,"year", "Text"));
	
}


function setEmpPage() {
// 	if($("#searchYm").val() == "") {
// 		alert("기준년월을 입력하시기 바랍니다.");
// 		$("#searchYm").focus();
// 		return;
// 	}
	doAction1("Search");
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
	<input type="hidden" id="sabun" name="sabun" value="" />
	<input type="hidden" id="searchYear" name="searchYear" value="" />
	
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td class="top">
					<div class="outer">
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt">임금피크정보</li>
								<li class="btn">
									<a href="javascript:setEmpPage();"		class="button">조회</a>
									<a href="javascript:doAction1('edateUpdate')" 	class="button">1년차 기준 자동생성</a>
									<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
									<a href="javascript:doAction1('Copy')"			class="basic authA">복사</a>
									<a href="javascript:doAction1('Save')"			class="basic authA">저장</a>
									<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "kr"); </script>
				</td>
			</tr>
		</table>
	</form>
</div>
</body>
</html>
