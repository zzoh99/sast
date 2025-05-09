<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>사회보험통합관리</title>
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

		$("#searchSEmptYmd").datepicker2({startdate:"searchEEmptYmd"});
		$("#searchEEmptYmd").datepicker2({enddate:"searchSEmptYmd"});
		$("#searchSRetYmd").datepicker2({startdate:"searchERetYmd"});
		$("#searchERetYmd").datepicker2({enddate:"searchSRetYmd"});

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='departmentV1' mdef='부서'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",			Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='edateV1' mdef='퇴사일'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },

			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Int",			Hidden:1,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"seq",			KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 , EndDateCol:"edate"},
			{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 , StartDateCol:"sdate"},
			{Header:"<sht:txt mid='socChangeCd' mdef='변동코드'/>",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"socChangeCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='socStateCd' mdef='불입상태'/>",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"socStateCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='grade' mdef='등급'/>",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"grade",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='mon1' mdef='기준소득월액'/>",		Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"rewardTotMon",KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='mon2' mdef='본인부담금'/>",		Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"selfMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		var socChangeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B10190"), "");
		sheet2.SetColProperty("socChangeCd", {ComboText:"|"+socChangeCd[0], ComboCode:"|"+socChangeCd[1]});

		// 불입상태(B10150)
		var socStateCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B10150"), "");
		sheet2.SetColProperty("socStateCd", {ComboText:"|"+socStateCd[0], ComboCode:"|"+socStateCd[1]});

		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly};
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata3.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },

			{Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",					Type:"Text",		Hidden:1,		Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='orderSeq' mdef='순서|순서'/>",					Type:"Int",			Hidden:1,		Width:100,			Align:"Right",	ColMerge:0,	SaveName:"seq",				KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='sDate' mdef='시작일자|시작일자'/>",				Type:"Date",		Hidden:0,		Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sdate",			KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 , EndDateCol:"edate"},
			{Header:"<sht:txt mid='edateV7' mdef='종료일자|종료일자'/>",				Type:"Date",		Hidden:0,		Width:100,			Align:"Center",	ColMerge:0,	SaveName:"edate",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 , StartDateCol:"sdate"},
			{Header:"변동\n코드|변동\n코드",			Type:"Combo",		Hidden:0,		Width:80,			Align:"Center",	ColMerge:0,	SaveName:"socChangeCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"불입\n상태|불입\n상태",			Type:"Combo",		Hidden:0,		Width:80,			Align:"Center",	ColMerge:0,	SaveName:"socStateCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='reductionRate' mdef='감면율|감면율'/>",					Type:"Float",		Hidden:0,		Width:50,			Align:"Right",	ColMerge:0,	SaveName:"reductionRate",	KeyField:0,	Format:"Float",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='reductionRate2' mdef='장기요양\n감면율|장기요양\n감면율'/>",	Type:"Float",		Hidden:0,		Width:60,			Align:"Right",	ColMerge:0,	SaveName:"reductionRate2",	KeyField:0,	Format:"Float",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='gradeV2' mdef='등급|등급'/>",					Type:"Text",		Hidden:1,		Width:60,			Align:"Center",	ColMerge:0,	SaveName:"grade",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='hiMon' mdef='보수월액|보수월액'/>",				Type:"Int",			Hidden:0,		Width:80,			Align:"Right",	ColMerge:0,	SaveName:"rewardTotMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='mon4' mdef='보험료|건강'/>",					Type:"Int",			Hidden:0,		Width:80,			Align:"Right",	ColMerge:0,	SaveName:"mon4",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='mon5' mdef='보험료|장기요양'/>",				Type:"Int",			Hidden:0,		Width:80,			Align:"Right",	ColMerge:0,	SaveName:"mon5",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='totalMon' mdef='보험료|총액'/>",					Type:"Int",			Hidden:0,		Width:80,			Align:"Right",	ColMerge:0,	SaveName:"totalMon",		KeyField:0,	Format:"Integer",	CalcLogic:"|mon4|+|mon5|",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='mon1V1' mdef='산정보험료|건강'/>",				Type:"Int",			Hidden:1,		Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon1",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='mon2V1' mdef='산정보험료|장기요양'/>",				Type:"Int",			Hidden:1,		Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon2",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='mon3' mdef='산정보험료|총액'/>",				Type:"Int",			Hidden:1,		Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon3",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='bigo' mdef='비고|비고'/>",					Type:"Text",		Hidden:0,		Width:100,			Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);

		// 변동코드(B10190)
		var socChangeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B10190"), "");
		sheet3.SetColProperty("socChangeCd", {ComboText:"|"+socChangeCd[0], ComboCode:"|"+socChangeCd[1]});

		// 불입상태(B10130)
		var socStateCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B10130"), "");
		sheet3.SetColProperty("socStateCd", {ComboText:"|"+socStateCd[0], ComboCode:"|"+socStateCd[1]});

		var initdata4 = {};
		initdata4.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata4.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata4.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:1,		Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Int",			Hidden:1,		Width:100,			Align:"Right",	ColMerge:0,	SaveName:"seq",			KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",		Type:"Date",		Hidden:0,		Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 , EndDateCol:"edate"},
			{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",		Type:"Date",		Hidden:0,		Width:100,			Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 , StartDateCol:"sdate"},
			{Header:"<sht:txt mid='socChangeCdV2' mdef='사회보험변동코드'/>",	Type:"Combo",		Hidden:0,		Width:100,			Align:"Center",	ColMerge:0,	SaveName:"socChangeCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='socStateCdV2' mdef='고용보험불입상태'/>",	Type:"Combo",		Hidden:0,		Width:100,			Align:"Center",	ColMerge:0,	SaveName:"socStateCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='mon1V3' mdef='보수월액'/>",		Type:"Int",			Hidden:0,		Width:100,			Align:"Right",	ColMerge:0,	SaveName:"rewardTotMon",KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='eiEeMon' mdef='고용보험료'/>",		Type:"Int",			Hidden:0,		Width:100,			Align:"Right",	ColMerge:0,	SaveName:"empMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet4, initdata4);sheet4.SetEditable("${editable}");sheet4.SetVisible(true);sheet4.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();
		var socChangeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B10190"), "");
		sheet4.SetColProperty("socChangeCd", {ComboText:"|"+socChangeCd[0], ComboCode:"|"+socChangeCd[1]});

		// 고용보험불입상태(B10170)
		var socStateCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B10170"), "");
		sheet4.SetColProperty("socStateCd", {ComboText:"|"+socStateCd[0], ComboCode:"|"+socStateCd[1]});

		var searchStatusCd	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));
		$("#searchStatusCd").html(searchStatusCd[2]);

		doAction1("Search");

		$("#searchSEmptYmd,#searchEEmptYmd,#searchSRetYmd,#searchERetYmd,#searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

	});

	function chkInVal(sAction, sheet) {
		switch (sAction) {
			case "Search" :
				if ($("#searchSEmptYmd").val() != "" && $("#searchEEmptYmd").val() != "") {
					if (!checkFromToDate($("#searchSEmptYmd"), $("#searchEEmptYmd"), "입사일", "입사일", "YYYYMMDD")) {
						return false;
					}
				}

				if ($("#searchSRetYmd").val() != "" && $("#searchERetYmd").val() != "") {
					if (!checkFromToDate($("#searchSRetYmd"), $("#searchERetYmd"), "퇴사일", "퇴사일", "YYYYMMDD")) {
						return false;
					}
				}
				break;
			case "Save" :
				// 시작일자와 종료일자 체크
				for (var i=sheet.HeaderRows(); i<=sheet.LastRow(); i++) {
					if (sheet.GetCellValue(i, "sStatus") == "I" || sheet.GetCellValue(i, "sStatus") == "U") {
						if (sheet.GetCellValue(i, "edate") != null && sheet.GetCellValue(i, "edate") != "") {
							var sdate = sheet.GetCellValue(i, "sdate");
							var edate = sheet.GetCellValue(i, "edate");
							if (parseInt(sdate) > parseInt(edate)) {
								alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
								sheet.SelectCell(i, "edate");
								return false;
							}
						}
					}
				}
				break;
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!chkInVal(sAction, sheet1)){break}
						sheet1.DoSearch( "${ctx}/SocInsMultiMgr.do?cmd=getSocInsMultiMgrListLeft", $("#sendForm").serialize() );
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
						sheet1.Down2Excel(param);

						break;
		}
	}
	//sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
						sheet2.DoSearch( "${ctx}/SocInsMultiMgr.do?cmd=getSocInsMultiMgrListRightTop", $("#sendForm").serialize() );
						break;
		case "Save":
						if(!chkInVal(sAction, sheet2)){break}
						if(!dupChk(sheet2,"sabun|sdate", true, true)){break;}
						IBS_SaveName(document.sendForm,sheet2);
						sheet2.DoSave( "${ctx}/SocInsMultiMgr.do?cmd=saveSocInsMultiMgrRightTop", $("#sendForm").serialize());
						break;
		case "Insert":
						var row = sheet2.DataInsert(0);
						sheet2.SetCellValue(row, "sabun", $("#searchLeftSabun").val());
						sheet2.SetCellValue(row, "sdate", "${curSysYyyyMMdd}");
						sheet2.SelectCell(row, 2);
						break;
		case "Copy":
						var row = sheet2.DataCopy();
						sheet2.SelectCell(row, 2);
						sheet2.SetCellValue(row, "seq","");
						//sheet2.SetCellValue(row, "selfMon", "");
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet2);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
						sheet2.Down2Excel(param);

						break;
		}
	}
	//sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
						sheet3.DoSearch( "${ctx}/SocInsMultiMgr.do?cmd=getSocInsMultiMgrListRightMiddle", $("#sendForm").serialize() );
						break;
		case "Save":
						if(!chkInVal(sAction, sheet3)){break}
						if(!dupChk(sheet3,"sabun|sdate", true, true)){break;}
						IBS_SaveName(document.sendForm,sheet3);
						sheet3.DoSave( "${ctx}/SocInsMultiMgr.do?cmd=saveSocInsMultiMgrRightMiddle", $("#sendForm").serialize());
						break;
		case "Insert":
						var row = sheet3.DataInsert(0);
						sheet3.SetCellValue(row, "sabun",$("#searchLeftSabun").val());
						sheet3.SetCellValue(row, "sdate","${curSysYyyyMMdd}");
						sheet3.SelectCell(row, 2);
						break;
		case "Copy":
						var row = sheet3.DataCopy();
						sheet3.SelectCell(row, 2);
						sheet3.SetCellValue(row, "seq","");
						sheet3.SetCellValue(row, "totalMon","");
						sheet3.SetCellValue(row, "mon3","");
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet3);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
						sheet3.Down2Excel(param);

						break;
		}
	}
	//sheet4 Action
	function doAction4(sAction) {
		switch (sAction) {
		case "Search":
						sheet4.DoSearch( "${ctx}/SocInsMultiMgr.do?cmd=getSocInsMultiMgrListRightBottom", $("#sendForm").serialize() );
						break;
		case "Save":
						if(!chkInVal(sAction, sheet4)){break}
						if(!dupChk(sheet4,"sabun|sdate", true, true)){break;}
						IBS_SaveName(document.sendForm,sheet4);
						sheet4.DoSave( "${ctx}/SocInsMultiMgr.do?cmd=saveSocInsMultiMgrRightBottom", $("#sendForm").serialize());
						break;
		case "Insert":
						var row = sheet4.DataInsert(0);
						sheet4.SetCellValue(row, "sabun", $("#searchLeftSabun").val());
						sheet4.SetCellValue(row, "sdate", "${curSysYyyyMMdd}");
						sheet4.SelectCell(row, 2);
						break;
		case "Copy":
						var row = sheet4.DataCopy();
						sheet4.SelectCell(row, 2);
						sheet4.SetCellValue(row, "seq","");
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet4);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
						sheet4.Down2Excel(param);

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
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {

		selectSheet = sheet1;
		if( OldRow != NewRow ) {
			$("#searchLeftSabun").val(sheet1.GetCellValue(NewRow, "sabun"));
			doAction2("Search");
			doAction3("Search");
			doAction4("Search");
		}
	}
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	function sheet2_OnChange(Row, Col, Value) {
		 try{
			var sSaveName = sheet2.ColSaveName(Col);

			if(sSaveName == "rewardTotMon"){
/*
				var params = "&searchYmd="+sheet2.GetCellValue(Row, "sdate") +
							"&searchRewardTotMon="+sheet2.GetCellValue(Row, "rewardTotMon") ;
				var result = ajaxCall("${ctx}/StaPenMgr.do?cmd=getF_BEN_NP_SELF_MON"+params, "",false);
				var selfMon = result["Map"] != null ? result["Map"]["selfMon"] : 0 ;
	*/			
				
				
				var params = "&searchYmd="+sheet2.GetCellValue(Row, "sdate") +
				"&searchRewardTotMon="+sheet2.GetCellValue(Row, "rewardTotMon") ;
				var result = ajaxCall("${ctx}/StaPenMgr.do?cmd=getStaPenMgrF_BEN_NP_SELF_MON"+params, "",false);
				var selfMon = result["Map"] != null ? result["Map"]["selfMon"] : 0 ;
				

				sheet2.SetCellValue(Row, "selfMon", selfMon) ;

			}
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction3("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	function sheet3_OnChange(Row, Col, Value) {
		 try{
			var sSaveName = sheet3.ColSaveName(Col);

			if(sSaveName == "rewardTotMon" || sSaveName == "reductionRate" || sSaveName == "reductionRate2"){

				var params = "&searchRewardTotMon="+Number(sheet3.GetCellValue(Row, "rewardTotMon")) ;
					params = params + "&reductionRate="+Number(sheet3.GetCellValue(Row, "reductionRate")) ;
					params = params + "&reductionRate2="+Number(sheet3.GetCellValue(Row, "reductionRate2")) ;

				var result = ajaxCall("${ctx}/HealthInsMgr.do?cmd=getSelfMonLongTermCareF_CPN_GET_UPDOWN_MON"+params,"",false);
				var selfMon = result["Map"] != null ? result["Map"]["selfMon"] : 0 ;
				var longtermcareMon = result["Map"] != null ? result["Map"]["longtermcareMon"] : 0 ;

				sheet3.SetCellValue(Row, "mon4", selfMon) ;
				sheet3.SetCellValue(Row, "mon5", longtermcareMon) ;
				//sheet1.SetCellValue(Row, "totalMon", selfMon+longtermcareMon) ;
			}
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
	// 조회 후 에러 메시지
	function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction4("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	function sheet4_OnChange(Row, Col, Value) {
		 try{
			var sSaveName = sheet4.ColSaveName(Col);

			if(sSaveName == "rewardTotMon"){

				var params = "&searchYmd="+sheet4.GetCellValue(Row, "sdate") +
							"&searchRewardTotMon="+sheet4.GetCellValue(Row, "rewardTotMon") ;
				var result = ajaxCall("${ctx}/EmpInsMgr.do?cmd=getEmpInsMgrF_BEN_NP_SELF_MON"+params, "",false);
				var empMon = result["Map"] != null ? result["Map"]["empMon"] : 0 ;

				sheet4.SetCellValue(Row, "empMon", empMon) ;

			}
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
	//소속 팝입
	function orgSearchPopup(){
		try{
			if(!isPopup()) {return;}

			var args    = new Array();

			gPRow = "";
			pGubun = "searchOrgBasicPopup";

			//openPopup("/Popup.do?cmd=orgBasicPopup", args, "740","520");

	            let layerModal = new window.top.document.LayerModal({
	                id : 'orgLayer'
	                , url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
	                , parameters : {}
	                , width : 740
	                , height : 520
	                , title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
	                , trigger :[
	                    {
	                        name : 'orgTrigger'
	                        , callback : function(result){
	                            if(!result.length) return;
	                            $("#searchOrgNm").val(result[0].orgNm);
	                            $("#searchOrgCd").val(result[0].orgCd);
	                        }
	                    }
	                ]
	            });
	            layerModal.show();
		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if(pGubun == "searchOrgBasicPopup") {
			$("#searchOrgCd").val(rv["orgCd"]);
			$("#searchOrgNm").val(rv["orgNm"]);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">

	<input type="hidden" id="searchOrgCd" name="searchOrgCd" value =""/>
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />

	<input type="hidden" id="searchLeftSabun" name="searchLeftSabun" value="" />

	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='103881' mdef='입사일'/></th>
			<td>
				<input id="searchSEmptYmd" name="searchSEmptYmd" type="text" size="10" class="date2" value="" /> ~
				<input id="searchEEmptYmd" name="searchEEmptYmd" type="text" size="10" class="date2" value="" />
			</td>
			<th><tit:txt mid='104090' mdef='퇴사일'/></th>
			<td>
				<input id="searchSRetYmd" name="searchSRetYmd" type="text" size="10" class="date2" value="" /> ~
				<input id="searchERetYmd" name="searchERetYmd" type="text" size="10" class="date2" value="" />
			</td>
			<th><tit:txt mid='104472' mdef='재직상태'/></th>
			<td>
				<select id="searchStatusCd" name="searchStatusCd" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='104330' mdef='사번/성명'/></th>
			<td>
				<input id="searchNm" name="searchNm" type="text" class="text" />
			</td>
			<th>부서</th>
			<td>
				<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" readOnly />
				<a onclick="javascript:orgSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				<a onclick="$('#searchOrgCd,#searchOrgNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
			</td>
			<td colspan="2"><btn:a href="javascript:doAction1('Search')"	css="btn dark" mid='110697' mdef="조회"/></td>
		</tr>
		</table>
		</div>
	</div>
</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="35%" />
		<col width="65%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">사회보험통합관리</li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Down2Excel')"	css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right">
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td class="top">
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt"><tit:txt mid='103995' mdef='국민연금'/></li>
									<li class="btn">
										<btn:a href="javascript:doAction2('Down2Excel')"	css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
										<btn:a href="javascript:doAction2('Copy')"			css="btn outline_gray authA" mid='110696' mdef="복사"/>
										<btn:a href="javascript:doAction2('Insert')"		css="btn outline_gray authA" mid='110700' mdef="입력"/>
										<btn:a href="javascript:doAction2('Save')"			css="btn filled authA" mid='110708' mdef="저장"/>
									</li>
								</ul>
							</div>
						</div>
						<script type="text/javascript">createIBSheet("sheet2", "100%", "33%", "${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td class="top">
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt"><tit:txt mid='103996' mdef='건강보험'/></li>
									<li class="btn">
										<btn:a href="javascript:doAction3('Down2Excel')"	css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
										<btn:a href="javascript:doAction3('Copy')"			css="btn outline_gray authA" mid='110696' mdef="복사"/>
										<btn:a href="javascript:doAction3('Insert')"		css="btn outline_gray authA" mid='110700' mdef="입력"/>
										<btn:a href="javascript:doAction3('Save')"			css="btn filled authA" mid='110708' mdef="저장"/>
									</li>
								</ul>
							</div>
						</div>
						<script type="text/javascript">createIBSheet("sheet3", "100%", "33%", "${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td class="top">
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt"><tit:txt mid='empInsure' mdef='고용보험'/></li>
									<li class="btn">
										<btn:a href="javascript:doAction4('Down2Excel')"	css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
										<btn:a href="javascript:doAction4('Copy')"			css="btn outline_gray authA" mid='110696' mdef="복사"/>
										<btn:a href="javascript:doAction4('Insert')"		css="btn outline_gray authA" mid='110700' mdef="입력"/>
										<btn:a href="javascript:doAction4('Save')"			css="btn filled authA" mid='110708' mdef="저장"/>
									</li>
								</ul>
							</div>
						</div>
						<script type="text/javascript">createIBSheet("sheet4", "100%", "33%", "${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</table>
</div>
</body>
</html>
