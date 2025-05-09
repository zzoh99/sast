<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>수습평가대상자관리</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No"		,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:1,   SaveName:"sNo" },
			{Header:"삭제|삭제"	,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:1,   SaveName:"sDelete" },
			{Header:"상태|상태"	,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:1,   SaveName:"sStatus" },

			{Header:"선택|선택"				,Type:"DummyCheck",	Hidden:0,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"chk",				KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"성명|성명"				,Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"name",				KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"사번|사번"				,Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"sabun",				KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"호칭|호칭"				,Type:"Text",		Hidden:Number("${aliasHdn}"),  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"alias",				KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"소속|소속"				,Type:"Text",		Hidden:0,  Width:150,  Align:"Left",    ColMerge:1,   SaveName:"orgNm",				KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위|직위"				,Type:"Text",		Hidden:Number("${jwHdn}"),  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"jikweeNm",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급|직급"				,Type:"Text",		Hidden:Number("${jgHdn}"),  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"jikgubNm",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"입사일|입사일"			,Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"gempYmd",			KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"근무지|근무지"			,Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"locationNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"수습만료일|수습만료일"		,Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"traYmd",			KeyField:1,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"최종평가상태|최종평가상태"	,Type:"Combo",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"holdOfficeCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"평가기간|시작일"			,Type:"Date",		Hidden:0,  Width:90,   Align:"Center",  ColMerge:1,   SaveName:"appAsYmd",			KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"평가기간|종료일"			,Type:"Date",		Hidden:0,  Width:90,   Align:"Center",  ColMerge:1,   SaveName:"appAeYmd",			KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"1차평가|성명"				,Type:"Popup",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"man1Name",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"1차평가|사번"				,Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"man1Sabun",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"1차평가|호칭"				,Type:"Text",		Hidden:Number("${aliasHdn}"),  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"man1Alias",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"1차평가|평가완료\n여부"		,Type:"CheckBox",	Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"appraisal1stYn",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"1차평가|평가점수"			,Type:"Text",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"app1stPoint",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"2차평가|성명"				,Type:"Popup",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"man2Name",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"2차평가|사번"				,Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"man2Sabun",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"2차평가|호칭"				,Type:"Text",		Hidden:Number("${aliasHdn}"),  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"man2Alias",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"2차평가|평가완료\n여부"		,Type:"CheckBox",	Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"appraisal2ndYn",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"2차평가|평가점수"			,Type:"Text",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"app2ndPoint",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"중간점수|중간점수"			,Type:"Text",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"middleAppPoint",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"최종점수|최종점수"			,Type:"Text",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"finalAppPoint",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"종합점수|종합점수"			,Type:"Text",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"totalAppPoint",		KeyField:0,   CalcLogic:"(|middleAppPoint|+|finalAppPoint|)/2",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"종합\n등급|종합\n등급"		,Type:"Combo",		Hidden:1,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"totalAppClassCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"비고|비고"				,Type:"Text",		Hidden:0,  Width:150,  Align:"Left",    ColMerge:1,   SaveName:"note",				KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },

			{Header:"소속코드|소속코드"			,Type:"Text",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"orgCd",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"직위코드|직위코드"			,Type:"Text",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"jikweeCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"직급코드|직급코드"			,Type:"Text",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"jikgubCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"직책코드|직책코드"			,Type:"Text",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"jikchakCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"직책|직책"				,Type:"Text",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"jikchakNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"근무지코드|근무지코드"		,Type:"Text",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"locationCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"mailId|mailId",		Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:0,   SaveName:"mailId",	KeyField:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"1차mailId|1차mailId",	Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:0,   SaveName:"man1MailId",	KeyField:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"2차mailId|2차mailId",	Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:0,   SaveName:"man2MailId",	KeyField:0,   UpdateEdit:0,   InsertEdit:0 }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}"); sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);

		var holdOfficeCdList 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20017"), ""); // 최종평가상태
		//var totalAppClassCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P90061"), ""); // 종합등급

		sheet1.SetColProperty("holdOfficeCd", {ComboText: "|"+holdOfficeCdList[0], ComboCode: "|"+holdOfficeCdList[1]} );
		//sheet1.SetColProperty("totalAppClassCd", {ComboText: "|"+totalAppClassCdList[0], ComboCode: "|"+totalAppClassCdList[1]} );

		//Autocomplete	
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow,"name", rv["name"]);
						sheet1.SetCellValue(gPRow,"alias", rv["name"]);
						sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow,"orgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow,"orgCd", rv["orgCd"]);
						sheet1.SetCellValue(gPRow,"appOrgCd", rv["orgCd"]);
						sheet1.SetCellValue(gPRow,"appOrgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow,"jikchakCd", rv["jikchakCd"]);
						sheet1.SetCellValue(gPRow,"jikchakNm", rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow,"jikweeCd", rv["jikweeCd"]);
						sheet1.SetCellValue(gPRow,"jikweeNm", rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow,"jikgubCd", rv["jikgubCd"]);
						sheet1.SetCellValue(gPRow,"jikgubNm", rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow,"gempYmd", rv["gempYmd"]);
						sheet1.SetCellValue(gPRow,"empYmd", rv["empYmd"]);
						sheet1.SetCellValue(gPRow,"workType", rv["workType"]);
						sheet1.SetCellValue(gPRow,"traYmd", rv["traYmd"]);
					}
				}
			]
		});
		
		$("#searchTraYmd1").datepicker2({startdate:"searchTraYmd2"});
		$("#searchTraYmd2").datepicker2({enddate:"searchTraYmd1"});

		$("#searchTraYmd1, #searchTraYmd2").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});

		$("#searchHoldOfficeCd").bind("change",function(event){
			doAction1("Search");
		});

		$("#searchHoldOfficeCd").html("<option value=''>전체</option>" + holdOfficeCdList[2]);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

	if ($("#searchTraYmd1").val() != ""
					&& $("#searchTraYmd2").val() == "") {
				alert("수습만료일을 입력해 주세요");
				$("#searchTraYmd2").focus();
				return;
			}

			if ($("#searchTraYmd2").val() != ""
					&& $("#searchTraYmd1").val() == "") {
				alert("수습만료일을 입력해 주세요");
				$("#searchTraYmd1").focus();
				return;
			}

			sheet1.DoSearch("${ctx}/InternAppPeopleMngr.do?cmd=getInternAppPeopleMngrList", $("#srchFrm").serialize());
			break;
		case "Save":
			IBS_SaveName(document.srchFrm, sheet1);
			sheet1.DoSave("${ctx}/InternAppPeopleMngr.do?cmd=saveInternAppPeopleMngr", $("#srchFrm").serialize());
			break;
		case "Insert":
			var Row = sheet1.DataInsert(0);
			break;
		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "appItemSeq", "");
			sheet1.SelectCell(Row, "appItemNm");
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {
				DownCols : downcol,
				SheetDesign : 1,
				Merge : 1
			};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			var params = {
				Mode : "HeaderMatch",
				WorkSheetNo : 1
			};
			sheet1.LoadExcel(params);
			break;
		case "Print":
			showRd();
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
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "")
				alert(Msg);
			if (Code != -1)
				doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 팝업클릭
	function sheet1_OnPopupClick(Row, Col) {
		try {

			var colName = sheet1.ColSaveName(Col);
			if (Row >= sheet1.HeaderRows()) {
				if (colName == "name" || colName == "man1Name"
						|| colName == "man2Name") {
					// 사원검색 팝입
					employeePopup(colName, Row);
				}
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	// 소속 팝업
	function orgSearchPopup() {
		if (!isPopup()) {
			return;
		}

		var args = {};
		args.baseDate = "${curSysYyyyMMddHyphen}";
		args.authPg = "R";

		gPRow = "";
		pGubun = "searchOrgBasicPopup";

		var layer = new window.top.document.LayerModal({
			id : 'searchOrgBasicPopupLayer'
			, url : "${ctx}/Popup.do?cmd=orgBasicPopup"
			, parameters: args
			, width : 680
			, height : 520
			, title : "조직 리스트 조회"
			, trigger :[
				{
					name : 'searchOrgBasicPopupTrigger'
					, callback : function(rv){
						getReturnValue(rv);
					}
				}
			]
		});
		layer.show();
	}

	//사원 팝업
	function employeePopup(pObjName, pRow) {
		try {
			if (!isPopup()) {
				return;
			}

			var args = new Array();

			gPRow = pRow;

			if (pObjName == "searchName") {
				pGubun = "employeePopup1";
			} else if (pObjName == "name") {
				pGubun = "employeePopup2";
			} else if (pObjName == "man1Name") {
				pGubun = "employeePopup3";
			} else if (pObjName == "man2Name") {
				pGubun = "employeePopup4";
			}

			var layer = new window.top.document.LayerModal({
				id : 'employeeLayer'
				, url : "${ctx}/Popup.do?cmd=employeePopup"
				, parameters: args
				, width : 740
				, height : 520
				, title : "사원조회"
				, trigger :[
					{
						name : 'employeeTrigger'
						, callback : function(rv){
							getReturnValue(rv);
						}
					}
				]
			});
			layer.show();

		} catch (ex) {
			alert("Open Popup Event Error : " + ex);
		}
	}

	function showRd() {
		if (!isPopup()) {
			return;
		}
		var selectChk = "N";

		for (var i = sheet1.HeaderRows(); i < sheet1.RowCount()
		+ sheet1.HeaderRows(); i++) {
			var chk = sheet1.GetCellValue(i, "chk");
			if (chk == 1) {
				selectChk = "Y";
			}
		}

		var sRow = sheet1.FindCheckedRow("chk");
		var arrRow = [];

		$(sRow.split("|")).each(
				function(index, value) {
					arrRow[index] = sheet1.GetCellValue(value, "sabun")
							+ sheet1.GetCellValue(value, "appAsYmd");
				});

		var searchSabun = "(";
		for (var i = 0; i < arrRow.length; i++) {
			if (i != 0)
				searchSabun += ",";
			searchSabun += "'" + arrRow[i] + "'";
		}
		searchSabun += ")";

		if (selectChk == 'Y') {

			var rdMrd = "";
			var rdTitle = "";
			var rdParam = "";

			rdMrd = "pap/internPapInfo/InternPAP.mrd";
			rdTitle = "수습평가표";

			rdParam = rdParam + "[" + '${ssnEnterCd}' + "]"; //회사코드
			rdParam = rdParam + "[" + searchSabun + "] "; //사번

			const data = {
				parameters : rdParam,
				mrdPath : rdMrd
			}

			window.top.showRdLayer('/InternAppPeopleMngr.do?cmd=getEncryptRd', data, null, rdTitle);
		} else {
			alert("대상자를 선택하세요");
			return;
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(rv) {
		if (pGubun == "searchOrgBasicPopup") {
			$("#searchOrgCd").val(rv["orgCd"]);
			$("#searchOrgNm").val(rv["orgNm"]);
			doAction1("Search");
		} else if (pGubun == "employeePopup1") {
			$("#searchName").val(rv["name"]);
			$("#searchSabun").val(rv["sabun"]);
			doAction1("Search");
		} else if (pGubun == "employeePopup2") {
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "orgCd", rv["orgCd"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "jikweeCd", rv["jikweeCd"]);
			sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
			sheet1.SetCellValue(gPRow, "jikgubCd", rv["jikgubCd"]);
			sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
			sheet1.SetCellValue(gPRow, "gempYmd", rv["gempYmd"]);
			sheet1.SetCellValue(gPRow, "locationCd", rv["locationCd"]);
			sheet1.SetCellValue(gPRow, "locationNm", rv["locationNm"]);
			sheet1.SetCellValue(gPRow, "traYmd", rv["traYmd"]);
			sheet1.SetCellValue(gPRow, "jikchakCd", rv["jikchakCd"]);
			sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
		} else if (pGubun == "employeePopup3") {
			sheet1.SetCellValue(gPRow, "man1Name", rv["name"]);
			sheet1.SetCellValue(gPRow, "man1Sabun", rv["sabun"]);
		} else if (pGubun == "employeePopup4") {
			sheet1.SetCellValue(gPRow, "man2Name", rv["name"]);
			sheet1.SetCellValue(gPRow, "man2Sabun", rv["sabun"]);
		}
	}

	function sendMail() {
		let sabuns = "";

		if (sheet1.RowCount() === 0) {
			alert("메일 발송 대상자를 조회 후 선택해주시기 바랍니다.");
			return;
		} else if (sheet1.CheckedRows("chk") === 0) {
			alert("메일 발송 대상자가 선택되지 않았습니다. 대상자를 선택해주세요.");
			return;
		}

		const sRow = sheet1.FindCheckedRow("chk");
		const arrRow = sRow.split("|");

		for (const row of arrRow) {
			if (row) {
				if (sheet1.GetCellValue(row, "appraisal1stYn") === "N"
						&& sheet1.GetCellValue(row, "man1MailId") !== "") {
					// 1차평가 전 상태.
					sabuns += sheet1.GetCellValue(row, "man1Sabun");
				} else if (sheet1.GetCellValue(row, "appraisal2ndYn") === "N"
						&& sheet1.GetCellValue(row, "man2MailId") !== "") {
					// 2차평가 전 상태.
					sabuns += sheet1.GetCellValue(row, "man2Sabun");
				}

				sabuns += ",";
			}
		}

		if (sabuns === "") {
			alert("전송 가능한 메일 대상자가 존재하지 않습니다. 선택된 대상자의 평가자에게 메일이 전달 가능한 상태인지 확인 바랍니다.");
			return;
		}

		$("#receiverSabuns").val(sabuns);

		// 발송대상
		const obj = ajaxCall("/SendMgr.do?cmd=getMailInfo", $("#srchFrm").serialize(), false).result;
		if (obj && obj.length <= 0) {
			alert("<msg:txt mid='errorMacUser' mdef='매칭되는 인원이 없습니다.'/>");
			return;
		}

		let names = "";
		let mailIds = "";
		for (let i = 0; i < obj.length; i++) {
			names += obj[i].name + "|";
			mailIds += obj[i].mailId + "|";
		}
		names = names.substr(0, names.length - 1);
		mailIds = mailIds.substr(0, mailIds.length - 1);

		fnSendMailPop(names,mailIds);
	}

	/**
	 * Mail 발송 팝업 창 호출
	 */
	function fnSendMailPop(names,mailIds) {
		if(!isPopup()) {return;}

		var args 	= new Array();

		args["saveType"] = "insert";
		args["names"] = names;
		args["mailIds"] = mailIds;
		args["sender"] = "${ssnName}";
		args["bizCd"] = "INTERN_REQ";  //기본적으로 ETC를 넘기면 됨[직접입력 서식]
		args["authPg"] = "${authPg}";

		let layerModal = new window.top.document.LayerModal({
			id : 'mailMgrLayer'
			, url : '${ctx}/SendPopup.do?cmd=viewMailMgrLayer'
			, parameters : args
			, width : 870
			, height : 780
			, title : 'MAIL 발신'
			, trigger :[
				{
					name : 'mailMgrTrigger'
					, callback : function(result){
						callBackFnSendMail(result);
					}
				}
			]
		});
		layerModal.show();
	}
</script>


</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchCloseYn" name="searchCloseYn" />

		<input type="hidden" name="mailReceiverNms" id="mailReceiverNms" 	value="">
		<input type="hidden" name="mailReceiverMails" id="mailReceiverMails"	value="">
		<input type="hidden" name="receiverSabuns" id="receiverSabuns">

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td><span>소속 </span>
							<input id="searchOrgCd" name ="searchOrgCd" type="hidden" class="text" readOnly />
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly w100" readOnly />
							<a onclick="javascript:orgSearchPopup('primary');" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
						</td>
						<td><span>성명 </span>
							<input id="searchSabun" name ="searchSabun" type="hidden" />
							<input id="searchName" name ="searchName" type="text" class="text readonly " readonly />
							<a onclick="javascript:employeePopup('searchName');" class="button6" id="btnSabunPop"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#searchSabun,#searchName').val('');" class="button7" id="btnSabunClear"><img src="/common/images/icon/icon_undo.png"/></a>
						</td>
						<td>
							<span>최종평가상태</span>
							<select name="searchHoldOfficeCd" id="searchHoldOfficeCd">
							</select>
						</td>
					</tr>
					<tr>
						<td colspan=2>
							<span>수습만료일</span>
							<input id="searchTraYmd1" name="searchTraYmd1" type="text" size="10" class="date2" value=""/> ~
							<input id="searchTraYmd2" name="searchTraYmd2" type="text" size="10" class="date2" value=""/>
						</td>
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
							<li id="txt" class="txt">수습평가대상자관리</li>
							<li class="btn">
								<!-- <a href="javascript:doAction1('Print')" class="basic authA">출력</a> -->
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
								<a href="javascript:doAction1('Copy')" 	class="btn outline_gray authA">복사</a>
								<a href="javascript:doAction1('Insert')" class="btn outline_gray authA">입력</a>
								<a href="javascript:sendMail();" class="btn soft authA">메일발송</a>
								<a href="javascript:showRd();" class="btn soft authA">수습평가표출력</a>
								<a href="javascript:doAction1('Save')" 	class="btn filled authA">저장</a>
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