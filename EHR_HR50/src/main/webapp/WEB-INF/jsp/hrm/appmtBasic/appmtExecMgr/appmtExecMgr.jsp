<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='113886' mdef='발령처리담당자관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='orgYn' mdef='소속'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='chargeSabun' mdef='사번'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='teacherNm' mdef='성명'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	         	Type:"Text",	Hidden:Number("${aliasHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empAlias",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikchakYn' mdef='직책'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikweeYn' mdef='직위'/>",		Type:"Text",	Hidden:Number("${jwHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikgubYn' mdef='직급'/>",		Type:"Text",	Hidden:Number("${jgHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='sYmdV1' mdef='시작일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10, EndDateCol: "edate" },
			{Header:"<sht:txt mid='edate' mdef='종료일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, StartDateCol: "sdate" }


		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		$(sheet1).sheetAutocomplete({
		  	Columns: [{ ColSaveName : "name" }]
		}); 

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {

        $("#name").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "name="+$("#name").val();

			sheet1.DoSearch( "${ctx}/AppmtExecMgr.do?cmd=getAppmtExecMgrList",param );
			break;
		case "Save":
			if(!dupChk(sheet1,"sabun|sdate", true, true)){break;}
			// 필수값/유효성 체크
			if (!chkInVal()) break;
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/SaveData.do?cmd=saveAppmtExecMgr", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "발령처리담당자관리_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
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

	//키를 눌렀을때 발생.
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			if(sheet1.GetCellEditable(Row,Col) == true) {
				if(sheet1.ColSaveName(Col) == "name" && KeyCode == 46) {
					sheet1.SetCellValue(Row,"sabun","");
					sheet1.SetCellValue(Row,"orgNm","");
					sheet1.SetCellValue(Row,"jikchakNm","");
					sheet1.SetCellValue(Row,"jikgubNm","");
				}
			}
		} catch (ex) {
			alert("OnKeyDown Event Error " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				if(!isPopup()) {return;}
				gPRow = Row;
				var args 	= new Array();
				args["sheetNm"]	= "sheet1";
		        openPopup("/Popup.do?cmd=employeesPopup&authPg=R", args, "740","720");
		        //openPopup("/Popup.do?cmd=employeePopup&authPg=R", "", "740","520");
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function getReturnValue(returnValue) {
       	var rv = $.parseJSON('{' + returnValue+ '}');

		sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"] );
		sheet1.SetCellValue(gPRow, "name",		rv["name"] );
		sheet1.SetCellValue(gPRow, "empAlias",	rv["empAlias"] );
		sheet1.SetCellValue(gPRow, "orgNm", 	rv["orgNm"] );
		sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"] );
		sheet1.SetCellValue(gPRow, "jikgubNm", 	rv["jikgubNm"] );
		sheet1.SetCellValue(gPRow, "jikweeNm", 	rv["jikweeNm"] );
	}

	function chkInVal() {
		// 시작일자와 종료일자 체크
		var rowCnt = sheet1.RowCount();
		for (var i=1; i<=rowCnt; i++) {
			if (sheet1.GetCellValue(i, "edate") != null && sheet1.GetCellValue(i, "edate") != "") {
				var sdate = sheet1.GetCellValue(i, "sdate");
				var edate = sheet1.GetCellValue(i, "edate");
				if (parseInt(sdate) > parseInt(edate)) {
					alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
					sheet1.SelectCell(i, "edate");
					return false;
				}
			}
		}

		return true;
	}

</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='104330' mdef='사번/성명'/></th>
			<td>
				<input id="name" name="name" type="text" class="text"/>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="button" mid='search' mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='113886' mdef='발령처리담당자관리'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Insert');" css="basic authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy');" css="basic authA" mid='copy' mdef="복사"/>
				<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='down2excel' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
