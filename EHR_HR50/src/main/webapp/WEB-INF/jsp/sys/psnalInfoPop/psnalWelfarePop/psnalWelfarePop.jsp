<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html><head> <title><tit:txt mid='104044' mdef='인사기본(병역/보훈/장애)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var sabun = "${param.sabun}";
	var enterCd = "${param.enterCd}";
	var dbLink = "${param.dbLink}";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='transferCd' mdef='병역구분'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"transferCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='transferNm' mdef='병역구분명'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"transferNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyCd' mdef='군별'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"armyCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyNm' mdef='군별명'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"armyNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyGradeCd' mdef='계급'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"armyGradeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyGradeNm' mdef='계급명'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"armyGradeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyNo' mdef='군번'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"armyNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyDCd' mdef='병과'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"armyDCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyDNm' mdef='병과명'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"armyDNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armySYmd' mdef='복무시작일'/>",	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"armySYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyEYmd' mdef='복무종료일'/>",	Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"armyEYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyYear' mdef='복무기간년'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"armyYear",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyMonth' mdef='복무기간월'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"armyMonth",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"armyMemo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
  			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
 			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
 			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
 			{Header:"<sht:txt mid='bohunCd' mdef='보훈구분'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bohunCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='bohunNm' mdef='보훈구분명'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bohunNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='famCdV1' mdef='보훈관계'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"famCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='famNmV1' mdef='보훈관계명'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"famNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='bohunNo' mdef='보훈번호'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bohunNo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata3.Cols = [
  			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
 			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
 			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
 			{Header:"<sht:txt mid='jangCd' mdef='장애구분'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jangCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='jangNm' mdef='장애구분명'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jangNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='jangYmd_V4776' mdef='장애판정일'/>",	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jangYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='jangGradeCd' mdef='장애등급'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jangGradeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='jangGradeNm' mdef='장애등급명'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jangGradeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"jangMemo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);

		var initdata4 = {};
		initdata4.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata4.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata4.Cols = [
  			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
 			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
 			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
 			{Header:"<sht:txt mid='targetYn' mdef='병특대상여부'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"targetYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='armyEduYn' mdef='군사교육수료여부'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"armyEduYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='sdateV5' mdef='특례편입일'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='edateV4' mdef='특례만료일'/>",		Type:"Date",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='armyEduYear' mdef='군사교육기간년'/>",	Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"armyEduYear",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='armyEduMonth' mdef='군사교육기간월'/>",	Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"armyEduMonth",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='armyEduNm' mdef='훈련부대명'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"armyEduNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet4, initdata4);sheet4.SetEditable("${editable}");sheet4.SetVisible(true);sheet4.SetCountPosition(4);

		var userCd1 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H20200"), " ");
		var userCd2 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H20230"), " ");
		var userCd3 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H20220"), " ");
		var userCd4 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H20310"), " ");
		var userCd5 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H20120"), " ");
		var userCd6 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H20320"), " ");
		var userCd7 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H20330"), " ");
		var userCd8 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H20210"), " ");

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
		doAction4("Search");

	});

	$(function() {

        $("#armyNo,#bohunNo").bind("keyup",function(event){
        	makeNumber(this,"A");
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+sabun
						+"&enterCd="+enterCd
						+"&dbLink="+dbLink

			sheet1.DoSearch( "${ctx}/PsnalWelfarePop.do?cmd=getPsnalWelfarePopArmyList", param );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+sabun
						+"&enterCd="+enterCd
						+"&dbLink="+dbLink;

			sheet2.DoSearch( "${ctx}/PsnalWelfarePop.do?cmd=getPsnalWelfarePopBohunList", param );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param);
			break;
		}
	}

	//Sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+sabun
					+"&enterCd="+enterCd
					+"&dbLink="+dbLink;

			sheet3.DoSearch( "${ctx}/PsnalWelfarePop.do?cmd=getPsnalWelfarePopJangList", param );
			break;

		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet3);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet3.Down2Excel(param);
			break;
		}
	}

	//Sheet4 Action
	function doAction4(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+sabun
						+"&enterCd="+enterCd
						+"&dbLink="+dbLink;

			sheet4.DoSearch( "${ctx}/PsnalWelfarePop.do?cmd=getPsnalWelfarePopArmyEduList", param );
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
			getSheetValue(sheet1,1);
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			getSheetValue(sheet2,2);
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			getSheetValue(sheet3,3);
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 조회 후 에러 메시지
	function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			getSheetValue(sheet4,4);
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function getSheetValue(sht,shtNum) {

		var row = sht.LastRow();

		if(row == 0) {
			return false;
		}

		if(shtNum == 1) {

			$("#transferCd").val(sht.GetCellValue(row,"transferCd"));
			$("#transferNm").val(sht.GetCellValue(row,"transferNm"));
			$("#armyCd").val(sht.GetCellValue(row,"armyCd"));
			$("#armyNm").val(sht.GetCellValue(row,"armyNm"));
			$("#armyGradeCd").val(sht.GetCellValue(row,"armyGradeCd"));
			$("#armyGradeNm").val(sht.GetCellValue(row,"armyGradeNm"));
			$("#armyNo").val(sht.GetCellValue(row,"armyNo"));
			$("#armyDCd").val(sht.GetCellValue(row,"armyDCd"));
			$("#armyDNm").val(sht.GetCellValue(row,"armyDNm"));
			$('#armySYmd').val(sht.GetCellText(row,"armySYmd"));
			$('#armyEYmd').val(sht.GetCellText(row,"armyEYmd"));
			$("#armyMemo").val(sht.GetCellValue(row,"armyMemo"));

			var armyYearMonth = "";
			if(sht.GetCellValue(row,"armyYear") != "") {
				armyYearMonth += sht.GetCellValue(row,"armyYear")+"년 ";
			}

			if(sht.GetCellValue(row,"armyMonth") != "") {
				armyYearMonth += sht.GetCellValue(row,"armyMonth")+"개월 ";
			}

			$("#armyYearMonth").text(armyYearMonth);

		} else if(shtNum==2) {

			$("#bohunCd").val(sht.GetCellValue(row,"bohunCd"));
			$("#bohunNm").val(sht.GetCellValue(row,"bohunNm"));
			$("#famCd").val(sht.GetCellValue(row,"famCd"));
			$("#famNm").val(sht.GetCellValue(row,"famNm"));
			$("#bohunNo").val(sht.GetCellValue(row,"bohunNo"));
			$("#note").val(sht.GetCellValue(row,"note"));

		} else if(shtNum==3) {

			$("#jangCd").val(sht.GetCellValue(row,"jangCd"));
			$("#jangNm").val(sht.GetCellValue(row,"jangNm"));
			$('#jangYmd').val(sht.GetCellText(row,"jangYmd"));
			$("#jangGradeCd").val(sht.GetCellValue(row,"jangGradeCd"));
			$("#jangGradeNm").val(sht.GetCellValue(row,"jangGradeNm"));
			$("#jangMemo").val(sht.GetCellValue(row,"jangMemo"));

		} else if(shtNum==4) {


			$("#targetYn").val(sht.GetCellValue(row,"targetYn"));
			$("#targetYnNm").val((sht.GetCellValue(row,"targetYn")=="Y"?"대상":"비대상"));
			$("#armyEduYn").val(sht.GetCellValue(row,"armyEduYn"));
			$("#armyEduYnNm").val((sht.GetCellValue(row,"targetYn")=="Y"?"수료":"미수료"));
			$('#sdate').val(sht.GetCellText(row,"sdate"));
			$('#edate').val(sht.GetCellText(row,"edate"));
			$("#armyEduNm").val(sht.GetCellValue(row,"armyEduNm"));

			var armyEduYearMonth = "";
			if(sht.GetCellValue(row,"armyEduYear") != "") {
				armyEduYearMonth += sht.GetCellValue(row,"armyEduYear")+"년 ";
			}

			if(sht.GetCellValue(row,"armyEduMonth") != "") {
				armyEduYearMonth += sht.GetCellValue(row,"armyEduMonth")+"개월 ";
			}

			$("#armyEduYearMonth").text(armyEduYearMonth);
		}

		return true;
	}

	// 날짜 포맷을 적용한다..
	function formatDate(strDate, saper) {
		if(strDate == "") {
			return strDate;
		}

		if(strDate.length == 10) {
			return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
		} else if(strDate.length == 8) {
			return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
		}
	}

</script>
</head>
<body>
<div class="wrapper">
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="40%" />
		<col width="60%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='104545' mdef='병역사항'/></li>
			</ul>
			</div>

			<table border="0" cellpadding="0" cellspacing="0" class="table">
			<colgroup>
				<col width="30%" />
				<col width="" />
			</colgroup>
			<tr>
				<th><tit:txt mid='104239' mdef='병역구분'/></th>
				<td>
					<input id="transferCd" name="transferCd" type="hidden" class="text transparent" readonly>
					<input id="transferNm" name="transferNm" type="text" class="text transparent" readonly>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='103926' mdef='군별'/></th>
				<td>
					<input id="armyCd" name="armyCd" type="hidden" class="text transparent" readonly>
					<input id="armyNm" name="armyNm" type="text" class="text transparent" readonly>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104219' mdef='계급'/></th>
				<td>
					<input id="armyGradeCd" name="armyGradeCd" type="hidden" class="text transparent" readonly>
					<input id="armyGradeNm" name="armyGradeNm" type="text" class="text transparent" readonly>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104045' mdef='군번'/></th>
				<td>
					<input id="armyNo" name="armyNo" type="text" class="text transparent" maxlength=30 readonly>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='103842' mdef='병과'/></th>
				<td>
					<input id="armyDCd" name="armyDCd" type="hidden" class="text transparent" readonly>
					<input id="armyDNm" name="armyDNm" type="text" class="text transparent" readonly>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104140' mdef='복무시작일'/></th>
				<td>
					<input id="armySYmd" name="armySYmd" type="text" class="text transparent">
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104433' mdef='복무종료일'/></th>
				<td>
					<input id="armyEYmd" name="armyEYmd" type="text" class="text transparent">
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104518' mdef='복무기간'/></th>
				<td>
					<span id="armyYearMonth" name="armyYearMonth"></span>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='103783' mdef='비고'/></th>
				<td>
					<textarea id="armyMemo" name="armyMemo" rows="3" cols="" class="w100p readonly" readonly></textarea>
				</td>
			</tr>
			</table>
		</td>
		<td class="sheet_right">
			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='veterans' mdef='보훈사항'/></li>
			</ul>
			</div>

			<table border="0" cellpadding="0" cellspacing="0" class="table">
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="20%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th><tit:txt mid='103843' mdef='보훈구분'/></th>
				<td>
					<input id="bohunCd" name="bohunCd" type="hidden" class="text transparent" readonly>
					<input id="bohunNm" name="bohunNm" type="text" class="text transparent" readonly>
				</td>
				<th><tit:txt mid='104141' mdef='보훈관계'/></th>
				<td>
					<input id="famCd" name="famCd" type="hidden" class="text transparent" readonly>
					<input id="famNm" name="famNm" type="text" class="text transparent" readonly>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104414' mdef='보훈번호'/></th>
				<td>
					<input id="bohunNo" name="bohunNo" type="text" class="text transparent" maxlength="30" readonly>
				</td>
				<th><tit:txt mid='103783' mdef='비고'/></th>
				<td>
					<textarea id="note" name="note" rows="3" cols="" class="w100p readonly" readonly></textarea>
				</td>
			</tr>
			</table>

			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='obstacle' mdef='장애사항'/></li>
			</ul>
			</div>

			<table border="0" cellpadding="0" cellspacing="0" class="table">
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="20%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th><tit:txt mid='103844' mdef='장애구분'/></th>
				<td>
					<input id="jangCd" name="jangCd" type="hidden" class="text transparent" readonly>
					<input id="jangNm" name="jangNm" type="text" class="text transparent" readonly>
				</td>
				<th><tit:txt mid='104240' mdef='장애판정일'/></th>
				<td>
					<input id="jangYmd" name="jangYmd" type="text" class="text transparent">
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104046' mdef='장애등급'/></th>
				<td>
					<input id="jangGradeCd" name="jangGradeCd" type="hidden" class="text transparent" readonly>
					<input id="jangGradeNm" name="jangGradeNm" type="text" class="text transparent" readonly>
				</td>
				<th><tit:txt mid='103783' mdef='비고'/></th>
				<td>
					<textarea id="jangMemo" name="jangMemo" rows="3" cols="" class="w100p readonly" readonly></textarea>
				</td>
			</tr>
			</table>

			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='milService' mdef='병역특례'/></li>
			</ul>
			</div>

			<table border="0" cellpadding="0" cellspacing="0" class="table">
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="22%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th><tit:txt mid='103845' mdef='병특대상여부'/></th>
				<td>
					<input id="targetYn" name="targetYn" type="hidden" class="text transparent" readonly>
					<input id="targetYnNm" name="targetYnNm" type="text" class="text transparent" readonly>
				</td>
				<th><tit:txt mid='104047' mdef='군사교육수료여부'/></th>
				<td>
					<input id="armyEduYn" name="armyEduYn" type="hidden" class="text transparent" readonly>
					<input id="armyEduYnNm" name="armyEduYnNm" type="text" class="text transparent" readonly>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='103846' mdef='특례편입일'/></th>
				<td>
					<input id="sdate" name="sdate" type="text" class="text transparent">
				</td>
				<th><tit:txt mid='104142' mdef='특례만료일'/></th>
				<td>
					<input id="edate" name="edate" type="text" class="text transparent">
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104143' mdef='군사교육기간'/></th>
				<td>
					<span id="armyEduYearMonth" name="armyEduYearMonth"></span>
				</td>
				<th><tit:txt mid='104144' mdef='훈련부대명'/></th>
				<td>
					<input id="armyEduNm" name="armyEduNm" type="text" class="text transparent w100p" maxlength="100" readonly>
				</td>
			</tr>
			</table>
		</td>
	</tr>
	</table>

	<div class="hide">
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
		<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
		<script type="text/javascript"> createIBSheet("sheet3", "100%", "50%", "${ssnLocaleCd}"); </script>
		<script type="text/javascript"> createIBSheet("sheet4", "100%", "50%", "${ssnLocaleCd}"); </script>
	</div>

</div>
</body>
</html>
