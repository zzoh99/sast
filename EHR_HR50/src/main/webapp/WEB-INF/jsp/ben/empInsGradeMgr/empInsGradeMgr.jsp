<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>고용보험등급변경관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

$(function() {

	$("input[type='text']").keydown(function(event){
		if(event.keyCode == 27){
			return false;
		}
	});

	$("#searchSdate").datepicker2({
		onReturn: getComboList
	});

	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
	initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

		{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",				Type:"Text",		Hidden:0,		Width:100,		Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='applJobJikgunNmV1' mdef='직군'/>",				Type:"Combo",		Hidden:0,		Width:100,		Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",				Type:"Combo",		Hidden:0,		Width:100,		Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",				Type:"Combo",		Hidden:0,		Width:100,		Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",				Type:"Text",		Hidden:0,		Width:80,		Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",				Type:"Text",	Hidden:0,		Width:80,		Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='manageCd' mdef='사원구분'/>",			Type:"Combo",		Hidden:0,		Width:100,		Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",			Type:"Combo",		Hidden:0,		Width:100,		Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",				Type:"Date",		Hidden:0,		Width:100,		Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",			Type:"Date",		Hidden:0,		Width:100,		Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='accResNoV1' mdef='주민번호'/>",			Type:"Text",		Hidden:0,		Width:120,		Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:1,	Format:"IdNo",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='benefitBizCd' mdef='복리후생업무구분코드'/>",		Type:"Text",		Hidden:1,		Width:100,		Align:"Center",	ColMerge:0,	SaveName:"benefitBizCd",KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='sdateV13' mdef='기준일'/>",				Type:"Date",		Hidden:0,		Width:100,		Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='mon1' mdef='기준소득월액'/>",			Type:"Int",			Hidden:0,		Width:100,		Align:"Right",	ColMerge:0,	SaveName:"mon1",		KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='eiEeMon' mdef='고용보험료'/>",		Type:"Int",			Hidden:0,		Width:100,		Align:"Right",	ColMerge:0,	SaveName:"mon6",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"회사부담보험료",		Type:"Int",			Hidden:1,		Width:100,		Align:"Right",	ColMerge:0,	SaveName:"etc6",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }

	]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	getComboList();

    $("#searchStatusCd").select2({placeholder:""});
    $("#searchStatusCd").val(["AA"]).trigger("change");

    $("#searchStatusCd").change(function(){
    	if($(this).val() == null){
    		 $(this).select2({placeholder:"<tit:txt mid='103895' mdef='전체'/>"});
    	}
    });

	$(window).smartresize(sheetResize); sheetInit();
	doAction1("Search");

	// 성명 입력시 자동완성 처리
	$(sheet1).sheetAutocomplete({
		Columns: [
			{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue){
					var rv = $.parseJSON('{' + returnValue+ '}');
					sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
					sheet1.SetCellValue(gPRow, "workType",	rv["workType"]);
					sheet1.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"]);
					sheet1.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"]);
					sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
					sheet1.SetCellValue(gPRow, "name",		rv["name"]);
					sheet1.SetCellValue(gPRow, "manageCd",	rv["manageCd"]);
					sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"]);
					sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
					sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"]);
					sheet1.SetCellValue(gPRow, "resNo",		rv["resNo"]);
				}
			}
		]
	});		

	$("#searchSdate,#searchNm").bind("keyup",function(event){
		if( event.keyCode == 13){
			doAction1("Search");
		}
	});

});

function getCommonCodeList() {
//------------------------------------- 그리드 콤보 -------------------------------------//
	let baseSYmd = $("#searchSdate").val();

	// 직군코드(H10050)
	const workType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050", baseSYmd), "");
	sheet1.SetColProperty("workType", {ComboText:"|"+workType[0], ComboCode:"|"+workType[1]});

	// 직책코드(H20020)
	const jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020", baseSYmd), "");
	sheet1.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});

	// 직위코드(H20030)
	const jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030", baseSYmd), "");
	sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});

	// 사원구분코드(H10030)
	const manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030", baseSYmd), "<tit:txt mid='103895' mdef='전체'/>");
	sheet1.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});

	// 재직상태코드(H10010)
	const statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd), "");
	sheet1.SetColProperty("statusCd", {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]});
}

function getComboList() {
	let baseSYmd = $("#searchSdate").val();

	const searchManageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030", baseSYmd), "<tit:txt mid='103895' mdef='전체'/>");
	$("#searchManageCd").html(searchManageCd[2]);

	// 재직상태코드(H10010)
	const searchStatusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd), "<tit:txt mid='103895' mdef='전체'/>");
	$("#searchStatusCd").html(searchStatusCd[2]);
}

//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {
	case "Search":
					if (!chkInVal(sAction)) {
						break;
					}
					getCommonCodeList();
					$("#multiStatusCd").val(getMultiSelect($("#searchStatusCd").val()));
					sheet1.DoSearch( "${ctx}/EmpInsGradeMgr.do?cmd=getEmpInsGradeMgrList", $("#sendForm").serialize() );
					break;
	case "Save":
					if(!dupChk(sheet1,"benefitBizCd|resNo|sdate", true, true)){break;}
					IBS_SaveName(document.sendForm,sheet1);
					sheet1.DoSave( "${ctx}/EmpInsGradeMgr.do?cmd=saveEmpInsGradeMgr", $("#sendForm").serialize());
					break;
	case "Insert":
					var Row = sheet1.DataInsert(0);
					// 복리후생업무구분코드(B10230)
					sheet1.SetCellValue(Row, "benefitBizCd", "20");
					sheet1.SetCellValue(Row, "sdate", "${curSysYyyyMMddHyphen}");
					sheet1.SelectCell(Row, 'name');
					break;
	case "PrcP_BEN_NP_UPD":
					// 필수값/유효성 체크
					if (!chkInVal(sAction)) {
						break;
					}

					var rowCnt = sheet1.RowCount();
					if (rowCnt < 1) {
						alert("<msg:txt mid='healthInsUploadMgr1' mdef='반영할 자료가 없습니다.'/>");
						break;
					} else {
						for (var i=1; i<rowCnt; i++) {
							if (sheet1.GetCellValue(i, "sStatus") == "U" || sheet1.GetCellValue(i, "sStatus") == "I") {
								alert("<msg:txt mid='healthInsUploadMgr2' mdef='변경되거나 추가된 자료를 먼저 저장하여 주십시오.'/>");
								return;
							}
						}
					}

					if (confirm("고용보험등급변동이력에 반영하시겠습니까?")) {
						var prcSdate = $("#searchSdate").val().replaceAll("-","");

						// 반영작업(고용보험등급변동이력)
						var result = ajaxCall("${ctx}/EmpInsGradeMgr.do?cmd=prcP_BEN_NP_UPD", "sdate="+prcSdate, false);

						if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
							if (result["Result"]["Code"] == "0") {
								alert("고용보험등급변동이력이 반영 되었습니다.");
								// 프로시저 호출 후 재조회
								doAction1("Search");
							} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
								alert(result["Result"]["Message"]);
							}
						} else {
							alert("고용보험등급변동이력 반영 오류입니다.");
						}
					}
					break;

	case "Clear":
					sheet1.RemoveAll();
					break;

	case "LoadExcel":
					// 업로드
					var params = {};
					sheet1.LoadExcel(params);
					break;

	case "Down2Excel":
					//삭제/상태/hidden 지우고 엑셀내려받기
					var downcol = makeHiddenSkipCol(sheet1);
					var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
					sheet1.Down2Excel(param);
					break;

	case "DownTemplate":
					// 양식다운로드
					sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"7|13|15|16|17"});
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
		if (Msg != "") {
			alert(Msg);
		}
		doAction1("Search");
	} catch (ex) {
		alert("OnSaveEnd Event Error " + ex);
	}
}

function sheet1_OnLoadExcel() {
	sheet1.SetRangeValue("20", sheet1.HeaderRows(), 14, sheet1.LastRow(), 14);
}

function sheet1_OnPopupClick(Row, Col) {
	try{
		var colName = sheet1.ColSaveName(Col);
		if (Row > 0) {
			if(colName == "name") {
				// 사원검색 팝업
				empSearchPopup(Row, Col);
			}
		}
	}catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

//사원검색 팝업
function empSearchPopup(Row, Col) {
	if(!isPopup()) {return;}

	var w		= 840;
	var h		= 520;
	var url		= "/Popup.do?cmd=employeePopup";
	var args	= new Array();

	gPRow = Row;
	pGubun = "employeePopup";

	openPopup(url+"&authPg=R", args, w, h);
}

function sheet1_OnLoadExcel(result) {

	if(result) {

		if ( sheet1.RowCount() > 0 ){

			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){


				var params = "&searchRewardTotMon="+sheet1.GetCellValue(i, "mon1") ;

				var result = ajaxCall("${ctx}/EmpInsMgr.do?cmd=getEmpInsMgrF_BEN_NP_SELF_MON"+params, "",false);
				var empMon = result["Map"] != null ? result["Map"]["empMon"] : 0 ;

				sheet1.SetCellValue(i, "benefitBizCd", "20");
				sheet1.SetCellValue(i, "mon6", empMon) ;

			}
		}
	}
}

function sheet1_OnChange(Row, Col, Value) {
	 try{
		var sSaveName = sheet1.ColSaveName(Col);

		if(sSaveName == "mon1"){

			var params = "&searchRewardTotMon="+sheet1.GetCellValue(Row, "mon1") ;
			var result = ajaxCall("${ctx}/EmpInsMgr.do?cmd=getEmpInsMgrF_BEN_NP_SELF_MON"+params, "",false);
			var empMon = result["Map"] != null ? result["Map"]["empMon"] : 0 ;

			sheet1.SetCellValue(Row, "mon6", empMon) ;

		}
	}catch(ex){alert("OnChange Event Error : " + ex);}
}

//팝업 콜백 함수.
function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "employeePopup"){
		sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
		sheet1.SetCellValue(gPRow, "name", rv["name"]);
		sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
		sheet1.SetCellValue(gPRow, "workType", rv["workType"]);
		sheet1.SetCellValue(gPRow, "jikchakCd", rv["jikchakCd"]);
		sheet1.SetCellValue(gPRow, "jikweeCd", rv["jikweeCd"]);
		sheet1.SetCellValue(gPRow, "manageCd", rv["manageCd"]);
		sheet1.SetCellValue(gPRow, "statusCd", rv["statusCd"]);
		sheet1.SetCellValue(gPRow, "empYmd", rv["empYmd"]);
		sheet1.SetCellValue(gPRow, "gempYmd", rv["gempYmd"]);
		sheet1.SetCellValue(gPRow, "resNo", rv["resNo"]);
    }
}

//필수값/유효성 체크
function chkInVal(sAction) {
	if($("#searchSdate").val() == "") {
		alert("<msg:txt mid='alertCrtrnyyInput' mdef='기준일을 입력하십시오.'/>");
		$("#searchSdate").focus();
		return false;
	}

	return true;
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">

	<input type="hidden" id="multiStatusCd" name="multiStatusCd" value="" />

	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='104535' mdef='기준일'/></th>
			<td>  <input type="text" id="searchSdate" name="searchSdate" class="date2 required" value="${curSysYyyyMMddHyphen}"/> </td>
			<th><tit:txt mid='103784' mdef='사원구분'/></th>
			<td>  <select id="searchManageCd" name="searchManageCd" onchange="javascript:doAction1('Search');"> </select> </td>
			<th><tit:txt mid='104472' mdef='재직상태'/></th>
			<td>  <select id="searchStatusCd" name="searchStatusCd" multiple=""> </select> </td>
			<th><tit:txt mid='104330' mdef='사번/성명'/></th>
			<td>  <input type="text" id="searchNm" name="searchNm" class="text" value="" style="ime-mode:active" /> </td>
			<td> <a href="javascript:doAction1('Search');" class="btn dark"><tit:txt mid='104081' mdef='조회'/></a> </td>
		</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">고용보험등급변경관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')"		class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
				<a href="javascript:doAction1('DownTemplate')"		class="btn outline-gray authA"><tit:txt mid='113684' mdef='양식다운로드'/></a>
				<a href="javascript:doAction1('LoadExcel')"			class="btn outline-gray authA"><tit:txt mid='104242' mdef='업로드'/></a>
				<a href="javascript:doAction1('Insert')"			class="btn outline-gray authA"><tit:txt mid='104267' mdef='입력'/></a>
				<a href="javascript:doAction1('Save')"				class="btn soft authA"><tit:txt mid='104476' mdef='저장'/></a>
				<a href="javascript:doAction1('PrcP_BEN_NP_UPD')"	class="btn filled authA"><tit:txt mid='113765' mdef='반영작업'/></a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
