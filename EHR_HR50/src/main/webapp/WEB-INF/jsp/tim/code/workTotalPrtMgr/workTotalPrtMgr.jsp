<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근태/근무인쇄항목설정</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='\n삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='gubun_V1131' mdef='구분'/>",		Type:"Combo",		Hidden:1,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"type",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='seqV2' mdef='순서'/>",			Type:"Int",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:800 },
			{Header:"<sht:txt mid='reportNm' mdef='출력명'/>",		Type:"Text",		Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"reportNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:800 },
			{Header:"<sht:txt mid='mReportNm' mdef='대분류명'/>",	Type:"Text",		Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"mReportNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:800 },
			{Header:"<sht:txt mid='useYnV1' mdef='사용여부'/>",		Type:"CheckBox",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:800, TrueValue:"Y", FalseValue:"N" },
			{Header:"<sht:txt mid='elementNms' mdef='항목'/>",		Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"elementNms",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:800 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetColProperty("type", 		{ComboText:"|<tit:txt mid='payRateTab2Std' mdef='근태'/>|<tit:txt mid='201705100000143' mdef='근무'/>", ComboCode:"|A|T"} );

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata2.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
  			{Header:"<sht:txt mid='sDelete' mdef='\n삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
  			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
  			{Header:"<sht:txt mid='gubun_V1131' mdef='구분'/>",		Type:"Combo",		Hidden:1,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"type",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
  			{Header:"<sht:txt mid='seqV2' mdef='순서'/>",			Type:"Int",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:800 },
  			{Header:"<sht:txt mid='code' mdef='코드'/>",				Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"timeEleCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:800 },
  			{Header:"<sht:txt mid='useYnV1' mdef='사용여부'/>",		Type:"CheckBox",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:800 , TrueValue:"Y", FalseValue:"N" }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		sheet2.SetColProperty("type", 		{ComboText:"|<tit:txt mid='payRateTab2Std' mdef='근태'/>|<tit:txt mid='201705100000143' mdef='근무'/>", ComboCode:"|A|T"} );
		sheet2.SetColProperty("useYn", 		{ComboText:"|Yes|No", ComboCode:"|Y|N"} );

		sheet2.SetFocusAfterProcess(0);

		$("#searchTypeList").on("change", function() {
			doAction1("Clear");
			doAction2("Clear");
			doAction1("Search");

			setSht2TimeEleCd($(this).val());
		})

		setSht2TimeEleCd();

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	function setSht2TimeEleCd(searchTypeList) {
		let timeEleCdList;

		if (!searchTypeList)
			searchTypeList = $("#searchTypeList").val();

		if (searchTypeList === "A") {
			timeEleCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnGntCdList",false).codeList, "");
		} else {
			timeEleCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWorkCdList",false).codeList, "");
		}
		sheet2.SetColProperty("timeEleCd", {ComboText:timeEleCdList[0], ComboCode:timeEleCdList[1]} );
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/WorkTotalPrtMgr.do?cmd=getWorkTotalPrtMgrList", $("#mySheetForm").serialize(),1 );
			break;
		case "Save":

			if(!dupChk(sheet1,"type|seq", true, true)){break;}
			var deleteFlag = false ;
			for(var i = 1; i < sheet1.LastRow()+1; i++) {
				if( sheet1.GetCellValue( i , "sStatus" ) == "D" ) {
					deleteFlag = "true" ;
				}
			}

			if(deleteFlag) {
				if(confirm("<msg:txt mid='alertWorkTotalMgr1' mdef='삭제되는 근무일집계코드에 해당하는 근무코드가 모두 지워집니다.\n정말 삭제처리를 하시겠습니까?'/>")) {
					IBS_SaveName(document.mySheetForm,sheet1);
					sheet1.DoSave( "${ctx}/WorkTotalPrtMgr.do?cmd=saveWorkTotalPrtMgr", $("#mySheetForm").serialize(), -1, 0);
				}
			} else {
				IBS_SaveName(document.mySheetForm,sheet1);
				sheet1.DoSave( "${ctx}/WorkTotalPrtMgr.do?cmd=saveWorkTotalPrtMgr", $("#mySheetForm").serialize());
			}
			break;
		case "Insert":
			var newRow = sheet1.DataInsert(0) ;

			sheet1.SetCellValue(newRow, "type", $("#searchTypeList").val() ) ;
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			/*입력상태일땐 디테일 조회 안함*/
			//if(sheet1.GetCellValue(sheet1.GetSelectRow(),"sStatus") == "I") {return ;}
			var param = "searchType="+sheet1.GetCellValue(sheet1.GetSelectRow(),"type") + "&searchSeq=" + sheet1.GetCellValue(sheet1.GetSelectRow(),"seq");
			sheet2.DoSearch( "${ctx}/WorkTotalPrtMgr.do?cmd=getWorkTotalPrtMgrUserMgrList", param,1 );
			break;
		case "Save":

			if(!dupChk(sheet2,"type|seq|timeEleCd", true, true)){break;}
			IBS_SaveName(document.mySheetForm,sheet2);
			sheet2.DoSave( "${ctx}/WorkTotalPrtMgr.do?cmd=saveWorkPrtUserMgr" , $("#mySheetForm").serialize());
			break;
		case "Insert":
			var selectRow = sheet1.GetSelectRow();

			if(sheet1.RowCount("I") > 0) {
				alert("<msg:txt mid='alertWorkTotalPrtMgr2' mdef='근태/근무항목관리를 저장후 입력하여 주십시오.'/>");
				return;
			}
			if(sheet1.RowCount() <= 0) {
				alert("<msg:txt mid='alertWorkTotalPrtMgr2' mdef='근태/근무항목관리를 저장후 입력하여 주십시오.'/>");
				return;
			}
			var row = sheet2.DataInsert(0) ;

			var type = sheet1.GetCellValue(selectRow,"type");
			var seq = sheet1.GetCellValue(selectRow,"seq");
			sheet2.SetCellValue(row,"type",type);
			sheet2.SetCellValue(row,"seq",seq);
			break;
		case "Copy":
			sheet2.DataCopy();
			break;
		case "Clear":
			sheet2.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param);
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
			doAction2("Clear");
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(sheet1.GetSelectRow() > 0) {
				if(OldRow != NewRow) {
					doAction2("Search");
				}
			}
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
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

			const sht1SelectRow = sheet1.GetSelectRow();
			const sht1SStatus = sheet1.GetCellValue(sht1SelectRow, "sStatus");
			sheet1.SetCellValue(sht1SelectRow, "elementNms", getSht1ElementNms());
			sheet1.SetCellValue(sht1SelectRow, "sStatus", sht1SStatus);
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function getSht1ElementNms() {
		let elementNms = "";
		for (var i = 0; i < Math.min(5, sheet2.RowCount()); i++) {
			const headerRows = sheet2.HeaderRows();
			const value = sheet2.GetCellText(i+headerRows, "timeEleCd");
			if (!value) continue;
			if (i !== 0) elementNms += ", ";
			elementNms += value;
		}

		return elementNms;
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='tDivision' mdef='구분'/></th>
						<td>
							<select id="searchTypeList" name="searchTypeList">
								<option value="T"><tit:txt mid='201705100000143' mdef='근무'/></option>
								<option value="A"><tit:txt mid='payRateTab2Std' mdef='근태'/></option>
							</select>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main w100p">
	<colgroup>
		<col width="60%" />
		<col width="40%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='workTotalPrtMgr1' mdef='근태/근무 항목관리'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Insert');" css="btn outline_gray authA" mid='insert' mdef="입력"/>
						<btn:a href="javascript:doAction1('Copy');" css="btn outline_gray authA" mid='copy' mdef="복사"/>
						<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
                        <btn:a href="javascript:doAction1('Down2Excel')"   css="btn outline_gray authR" mid='download' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "60%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='workTotalPrtMgr2' mdef='항목 Detail'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction2('Insert');" css="btn outline_gray authA" mid='insert' mdef="입력"/>
						<btn:a href="javascript:doAction2('Save');" css="btn filled authA" mid='save' mdef="저장"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "40%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>