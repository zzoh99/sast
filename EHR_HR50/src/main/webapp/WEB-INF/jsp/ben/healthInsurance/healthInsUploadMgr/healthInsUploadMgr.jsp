<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>건강보험등급변경관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 건강보험 자료Upload
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

$(function() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='benefitBizCd' mdef='복리후생업무구분코드'/>",	Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"benefitBizCd",KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='applJobJikgunNmV1' mdef='직군'/>",			Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",			Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='manageCd' mdef='사원구분'/>",			Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",			Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",		Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='edateV1' mdef='퇴사일'/>",			Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"retYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='accResNoV1' mdef='주민번호'/>",			Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:1,	Format:"IdNo",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='sdateV13' mdef='기준일'/>",			Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='mon1V3' mdef='보수월액'/>",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon1",		KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"건강보험료감면률",	Type:"Int",			Hidden:0,					Width:130,			Align:"Right",	ColMerge:0,	SaveName:"reductionRate",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"장기요양보험료감면률",	Type:"Int",			Hidden:0,					Width:150,			Align:"Right",	ColMerge:0,	SaveName:"reductionRate2",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='hiEeMon' mdef='건강보험료'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon3",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mon4V2' mdef='장기요양보험료'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon4",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);

    $("#statusCd").change(function(){
    	if($(this).val() == null){
    		 $(this).select2({placeholder:"<tit:txt mid='103895' mdef='전체'/>"});
    	}
    });

	$(window).smartresize(sheetResize);
	sheetInit();

	// 성명 입력시 자동완성 처리
	$(sheet1).sheetAutocomplete({
		Columns: [
			{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue){
					var rv = $.parseJSON('{' + returnValue+ '}');
					sheet1.SetCellValue(gPRow, "benefitBizCd",	rv["benefitBizCd"]);
					sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
					sheet1.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"]);
					sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
					sheet1.SetCellValue(gPRow, "name",		rv["name"]);
					sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"]);
					sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
					sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"]);
					sheet1.SetCellValue(gPRow, "retYmd",	rv["retYmd"]);
					sheet1.SetCellValue(gPRow, "resNo",		rv["resNo"]);
					sheet1.SetCellValue(gPRow, "manageCd",	rv["manageCd"]);
					sheet1.SetCellValue(gPRow, "workType",	rv["workType"]);
					sheet1.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"]);
				}
			}
		]
	});		

	$("#sdate").datepicker2({
		onReturn: getComboList
	});
	$("#sdate").val("${curSysYyyyMMddHyphen}");

	$("#sabunName,#sdate").bind("keyup",function(event) {
		if (event.keyCode == 13) {
			doAction1("Search");
		}
	});
	getComboList();
});

function getComboList() {
	let baseSYmd = $("#sdate").val();
	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 사원구분코드(H10030)
	var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030", baseSYmd), "");
	$("#manageCd").html(manageCd[2]);
	$("#manageCd").select2({placeholder:" 선택"});

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd), "");
	$("#statusCd").html(statusCd[2]);

	$("#statusCd").select2({placeholder:""});
	$("#statusCd").val(["AA"]).trigger("change");
}

function getCommonCodeList() {
	let baseSYmd = $("#sdate").val();
	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 직군코드(H10050)
	var workType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050", baseSYmd), " ");
	sheet1.SetColProperty("workType", {ComboText:"|"+workType[0], ComboCode:"|"+workType[1]});

	// 직책코드(H20020)
	var jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020", baseSYmd), " ");
	sheet1.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});

	// 직위코드(H20030)
	var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030", baseSYmd), " ");
	sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});

	// 사원구분코드(H10030)
	var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030", baseSYmd), " ");
	sheet1.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd), " ");
	sheet1.SetColProperty("statusCd", {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]});

}

// 필수값/유효성 체크
function chkInVal(sAction) {
	if ($("#sdate").val() == "") {
		alert("<msg:txt mid='alertCrtrnyyInput' mdef='기준일을 입력하십시오.'/>");
		$("#sdate").focus();
		return false;
	}
	// 일자 유효성 체크
	var rtn = isValidDate($("#sdate").val());
	if (rtn == false) {
		$("#sdate").focus();
		return false;
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			getCommonCodeList();
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#multiManageCd").val(getMultiSelect($("#manageCd").val()));
			$("#multiStatusCd").val(getMultiSelect($("#statusCd").val()));

			sheet1.DoSearch("${ctx}/HealthInsUploadMgr.do?cmd=getHealthInsUploadMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 중복체크
			if (!dupChk(sheet1, "benefitBizCd|resNo|sdate", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/HealthInsUploadMgr.do?cmd=saveHealthInsUploadMgr", $("#sheet1Form").serialize());
			break;

		case "Insert":
			var Row = sheet1.DataInsert(0);
			// 복리후생업무구분코드(B10230) 15.건강보험
			sheet1.SetCellValue(Row, "benefitBizCd", "15");
			sheet1.SetCellValue(Row, "sdate", "${curSysYyyyMMddHyphen}");
			sheet1.SelectCell(Row, 'name');
			break;

		case "Copy":
			sheet1.SelectCell(sheet1.DataCopy(), 'name');
			break;

		case "PrcP_BEN_HI_UPD":
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

			if (confirm("건강보험변동이력에 반영하시겠습니까?")) {
				var prcSdate = $("#sdate").val();
				prcSdate = prcSdate.replace(/\-/g,'').replace(/\//g,'');

				// 반영작업
				var result = ajaxCall("${ctx}/HealthInsUploadMgr.do?cmd=prcP_BEN_HI_UPD", "sdate="+prcSdate, false);

				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (result["Result"]["Code"] == "0") {
						alert("<msg:txt mid='healthInsUploadMgr4' mdef='건강보험변동이력 반영 되었습니다.'/>");
					} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
						alert(result["Result"]["Message"]);
					}
				} else {
					alert("<msg:txt mid='healthInsUploadMgr5' mdef='건강보험변동이력 반영 오류입니다.'/>");
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
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"15|16|17|18|19|20|21"});
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//저장 후 메시지
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

function sheet1_OnPopupClick(Row, Col) {
	try{
		var colName = sheet1.ColSaveName(Col);
		if (Row > 0) {
			if (colName == "name") {
				// 사원검색 팝업
				empSearchPopup(Row, Col);
			}
		}
	} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

// 사원검색 팝업
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

				var params = "&searchRewardTotMon="+Number(sheet1.GetCellValue(i, "mon1")) ;
					params = params + "&reductionRate="+Number(sheet1.GetCellValue(i, "reductionRate")) ;
					params = params + "&reductionRate2="+Number(sheet1.GetCellValue(i, "reductionRate2")) ;

				var result = ajaxCall("${ctx}/HealthInsMgr.do?cmd=getSelfMonLongTermCareF_CPN_GET_UPDOWN_MON"+params,"",false);
				var selfMon = result["Map"] != null ? result["Map"]["selfMon"] : 0 ;
				var longtermcareMon = result["Map"] != null ? result["Map"]["longtermcareMon"] : 0 ;

				sheet1.SetCellValue(i, "benefitBizCd", "15");
				sheet1.SetCellValue(i, "mon3", selfMon) ;
				sheet1.SetCellValue(i, "mon4", longtermcareMon) ;

			}
		}
	}
}

function sheet1_OnChange(Row, Col, Value) {
	 try{
		var sSaveName = sheet1.ColSaveName(Col);

		if(sSaveName == "mon1" || sSaveName == "reductionRate" || sSaveName == "reductionRate2"){

			var params = "&searchRewardTotMon="+Number(sheet1.GetCellValue(Row, "mon1")) ;
				params = params + "&reductionRate="+Number(sheet1.GetCellValue(Row, "reductionRate")) ;
				params = params + "&reductionRate2="+Number(sheet1.GetCellValue(Row, "reductionRate2")) ;

			var result = ajaxCall("${ctx}/HealthInsMgr.do?cmd=getSelfMonLongTermCareF_CPN_GET_UPDOWN_MON"+params,"",false);
			var selfMon = result["Map"] != null ? result["Map"]["selfMon"] : 0 ;
			var longtermcareMon = result["Map"] != null ? result["Map"]["longtermcareMon"] : 0 ;

			sheet1.SetCellValue(Row, "mon3", selfMon) ;
			sheet1.SetCellValue(Row, "mon4", longtermcareMon) ;
			//sheet1.SetCellValue(Row, "totalMon", selfMon+longtermcareMon) ;
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
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="multiManageCd" name="multiManageCd" value="" />
		<input type="hidden" id="multiStatusCd" name="multiStatusCd" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104535' mdef='기준일'/></th>
						<td>  <input type="text" id="sdate" name="sdate" class="date2 required" /> </td>
						<th><tit:txt mid='103784' mdef='사원구분'/></th>
						<td>  <select id="manageCd" name="manageCd" multiple=""> </select> </td>
						<th><tit:txt mid='104472' mdef='재직상태'/></th>
						<td>  <select id="statusCd" name="statusCd" multiple=""> </select> </td>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>  <input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" /> </td>
						<td> <a href="javascript:doAction1('Search')"	class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a> </td>
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
							<li id="txt" class="txt">건강보험등급변경관리</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')"		class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
								<a href="javascript:doAction1('DownTemplate')"		class="btn outline-gray authA"><tit:txt mid='113684' mdef='양식다운로드'/></a>
								<a href="javascript:doAction1('LoadExcel')"			class="btn outline-gray authA"><tit:txt mid='104242' mdef='업로드'/></a>
								<a href="javascript:doAction1('Insert')"			class="btn outline-gray authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction1('Save')"				class="btn soft authA"><tit:txt mid='104476' mdef='저장'/></a>
								<a href="javascript:doAction1('PrcP_BEN_HI_UPD')"	class="btn filled authA"><tit:txt mid='113765' mdef='반영작업'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
