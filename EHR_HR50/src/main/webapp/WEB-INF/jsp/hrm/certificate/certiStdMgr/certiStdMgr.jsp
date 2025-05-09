<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>제증명신청기준설정</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:4};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"신청서종류",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applCd",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"발행소속\n(한글)",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"publishOrgNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"발행소속\n(영문)",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"publishOrgENm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"발행자\n(한글)",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"publisherNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"발행자\n(영문)",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"publisherENm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"발행자\n연락처",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"publisherTelno",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"본인\n출력여부",		Type:"CheckBox",Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"selfPrtYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"도장\n출력여부",		Type:"CheckBox",Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"signPrtYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"최대\n출력부수",		Type:"Int",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"selfPrtLimitCnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"담당자수",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"userCnt",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var applCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getAddlCodeList",""), "<tit:txt mid='103895' mdef='전체'/>");

		sheet1.SetColProperty("applCd",			{ComboText:applCd[0], ComboCode:applCd[1]} );

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"신청서종류",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"소속",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"chargeSabun",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"chargeName",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"호칭",		Type:"Text",	Hidden:Number("${aliasHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"chargeAlias",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급",		Type:"Text",	Hidden:Number("${jgHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위",		Type:"Text",	Hidden:Number("${jwHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"시작일",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 , EndDateCol:"edate"},
			{Header:"종료일",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 , StartDateCol:"sdate"}
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		sheet2.SetFocusAfterProcess(0);

		$("#applCd").html(applCd[2]);

		$("#applCd").bind("change", function() {
			doAction1("Search");
		})

		$(sheet2).sheetAutocomplete({
			Columns: [{ ColSaveName : "chargeName" }]
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

function chkInVal() {

	for (var i = sheet2.HeaderRows(); i <= sheet2.LastRow(); i++) {
		if (sheet2.GetCellValue(i, "sStatus") == "I" || sheet2.GetCellValue(i, "sStatus") == "U") {
			if (sheet2.GetCellValue(i, "sdate") != null && sheet2.GetCellValue(i, "edate") != "") {
				var sdate = sheet2.GetCellValue(i, "sdate");
				var edate = sheet2.GetCellValue(i, "edate");
				if (parseInt(sdate) > parseInt(edate)) {
					alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
					sheet2.SelectCell(i, "edate");
					return false;
				}
			}
		}
	}

	return true;
}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/CertiStdMgr.do?cmd=getCertiStdMgrList", $("#sheetForm").serialize(),1 );
			break;
		case "Save":

			if(!dupChk(sheet1,"applCd", true, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/CertiStdMgr.do?cmd=saveCertiStdMgr", $("#sheetForm").serialize());
			break;
		case "Insert":
			sheet1.DataInsert(0);
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
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
			$("#span_applNm").html(sheet1.GetCellText(sheet1.GetSelectRow(),"applCd"));
			var param = "applCd="+sheet1.GetCellValue(sheet1.GetSelectRow(),"applCd") ;
			var param = "applCd="+sheet1.GetCellValue(sheet1.GetSelectRow(),"applCd") ;
			sheet2.DoSearch( "${ctx}/CertiStdMgr.do?cmd=getCertiStdMgrUserList", param,1 );
			break;
		case "Save":
			if(!chkInVal()){break}
			if(!dupChk(sheet2,"applCd|chargeSabun|sdate", true, true)){break;}
			IBS_SaveName(document.sheetForm,sheet2);
			sheet2.DoSave( "${ctx}/CertiStdMgr.do?cmd=saveCertiStdMgrUser", $("#sheetForm").serialize());
			break;
		case "Insert":
			var selectRow = sheet1.GetSelectRow();

			if(sheet1.RowCount("I") > 0) {
				alert("제증명신청기준설정을 저장후 입력하여 주십시오.");
				return;
			}

			var applCd = sheet1.GetCellValue(selectRow,"applCd");
			var row = sheet2.DataInsert(0);
			sheet2.SetCellValue(row,"applCd",applCd);
			sheet2.SetCellValue(row,"sdate","${curSysYyyyMMdd}");
			break;
		case "Copy":
			sheet2.DataCopy();
			break;
		case "Clear":
			sheet2.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
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
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 체크 되기 직전 발생.
	function sheet1_OnBeforeCheck(Row, Col) {
		try{
            sheet1.SetAllowCheck(true);
		    if(sheet1.ColSaveName(Col) == "sDelete" && sheet1.GetCellValue(Row,"userCnt") > 0) {
	            alert("담당자를 먼저 삭제 하십시오.");
	            sheet1.SetAllowCheck(false);
	            return;
		    }		    
		}catch(ex){
			alert("OnBeforeCheck Event Error : " + ex);
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

			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "sheetAutocomplete"){
			sheet2.SetCellValue(gPRow, "chargeSabun", 	rv["sabun"]);
			sheet2.SetCellValue(gPRow, "chargeName", 	rv["name"]);
			sheet2.SetCellValue(gPRow, "chargeAlias",   rv["alias"] );
			sheet2.SetCellValue(gPRow, "jikgubNm", 		rv["jikgubNm"]);
			sheet2.SetCellValue(gPRow, "jikweeNm", 		rv["jikweeNm"]);
			sheet2.SetCellValue(gPRow, "orgNm", 		rv["orgNm"]);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th>신청서종류</th>
				<td>
					<select id="applCd" name="applCd"></select>
				</td>
				<td>
					<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
				</td>
			</tr>
			</table>
			</div>
		</div>
	</form>
	
	
	<div class="">
		<div class="sheet_title">
		<ul>
			<li class="txt">제증명신청기준설정</li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
				<btn:a href="javascript:doAction1('Copy');" css="btn outline-gray authA" mid='copy' mdef="복사"/>
				<btn:a href="javascript:doAction1('Insert');" css="btn outline-gray authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>

	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><span id="span_applNm" class="tBlue"></span> 담당자</li>
			<li class="btn">
				<btn:a href="javascript:doAction2('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
				<btn:a href="javascript:doAction2('Copy');" css="btn outline-gray authA" mid='copy' mdef="복사"/>
				<btn:a href="javascript:doAction2('Insert');" css="btn outline-gray authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction2('Save');" css="btn filled authA" mid='save' mdef="저장"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>


</div>
</body>
</html>
