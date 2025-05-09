<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='ordTypeCdMgr' mdef='발령코드관리'/></title>
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
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='ordTypeCd' mdef='발령코드'/>",			Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='ordDetailCd' mdef='발령'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='languageCd' mdef='어휘코드'/>",			Type:"Text",	Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",		Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='ordType' mdef='발령구분'/>",			Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ordType",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='mainYn' mdef='주요발령여부'/>",		Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mainYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='prtYn' mdef='인사카드\n반영여부'/>",		Type:"Combo",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"prtYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
//			{Header:"<sht:txt mid='workTypeYn' mdef='재직상태'/>",			Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='seqV2' mdef='순서'/>",				Type:"Text",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='useYnV1' mdef='사용여부'/>",				Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var userCd1 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H40001"), "<tit:txt mid='103895' mdef='전체'/>");
		var userCd2 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "");

		sheet1.SetColProperty("ordType", 		{ComboText:userCd1[0], ComboCode:userCd1[1]} );
		sheet1.SetColProperty("mainYn", 		{ComboText:"YES|NO", ComboCode:"Y|N"} );
		sheet1.SetColProperty("prtYn", 			{ComboText:"YES|NO", ComboCode:"Y|N"} );
		sheet1.SetColProperty("useYn", 			{ComboText:"YES|NO", ComboCode:"Y|N"} );
//		sheet1.SetColProperty("statusCd", 		{ComboText:userCd2[0], ComboCode:userCd2[1]} );

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='ordTypeCdV1' mdef='발령형태'/>",	Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='chargeSabun' mdef='사번'/>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='teacherNm' mdef='성명'/>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",		        Type:"Popup",	Hidden:Number("${aliasHdn}"),	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='orgYn' mdef='소속'/>",		Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikgubYn' mdef='직급'/>",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikweeYn' mdef='직위'/>",		Type:"Text",	Hidden:Number("${jwHdn}"),	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='sYmdV1' mdef='시작일'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10, EndDateCol:"edate" },
			{Header:"<sht:txt mid='edate' mdef='종료일'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, StartDateCol:"sdate" }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		$(sheet2).sheetAutocomplete({
		  	Columns: [{ ColSaveName : "name" }]
		}); 		

		$("#ordType").html(userCd1[2]);
		
		
		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata3.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='ordTypeCd' mdef='발령코드'/>",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='ordDetailCd' mdef='발령상세코드'/>",			Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='ordDetailNm' mdef='발령상세'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailNm",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='languageCd' mdef='어휘코드'/>",			Type:"Text",	Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",		Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='seqV2' mdef='순서'/>",				Type:"Text",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='useYnV1' mdef='사용여부'/>",			Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 }
		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);

		
		var userCd3 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H40010"), "<tit:txt mid='103895' mdef='전체'/>");

		sheet3.SetColProperty("useYn", 					{ComboText:"YES|NO", ComboCode:"Y|N"} );
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	$(function() {
        $("#ordTypeCd, #ordTypeNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/AppmtCodeMgr.do?cmd=getAppmtCodeMgrList", $("#mySheetForm").serialize(),1 );
			break;
		case "Save":
			if(!dupChk(sheet1,"ordTypeCd", true, true)){break;}
			IBS_SaveName(document.mySheetForm,sheet1);
			sheet1.DoSave( "${ctx}/AppmtCodeMgr.do?cmd=saveAppmtCodeMgr", $("#mySheetForm").serialize());
			break;
		case "Insert":
			sheet1.SelectCell(sheet1.DataInsert(0), "ordTypeCd");
			doAction2('Clear');
			doAction3('Clear');
			break;
		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "languageCd", "" );
			sheet1.SetCellValue(Row, "languageNm", "" );
			doAction2('Clear');
			doAction3('Clear');
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "발령코드관리_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = "ordTypeCd="+sheet1.GetCellValue(sheet1.GetSelectRow(),"ordTypeCd") ;
			sheet2.DoSearch( "${ctx}/AppmtCodeMgr.do?cmd=getAppmtUserMgrList", param,1 );
			break;
		case "Save":

			if(!dupChk(sheet2,"ordTypeCd|sabun|sdate", true, true)){break;}
			IBS_SaveName(document.mySheetForm,sheet2);
			sheet2.DoSave( "${ctx}/AppmtCodeMgr.do?cmd=saveAppmtUserMgr", $("#mySheetForm").serialize());
			break;
		case "Insert":
			var selectRow = sheet1.GetSelectRow();

			if(sheet1.RowCount("I") > 0) {
				alert("<msg:txt mid='110033' mdef='발령을 저장후 입력하여 주십시오.'/>");
				return;
			}

			var ordTypeCd = sheet1.GetCellValue(selectRow,"ordTypeCd");
			var row = sheet2.DataInsert(0);
			sheet2.SetCellValue(row,"ordTypeCd",ordTypeCd);
			sheet2.SelectCell(row, "name");
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
			var d = new Date();
			var fName = "발령담당자관리_" + d.getTime() + ".xlsx";
			sheet2.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		}
	}
	
	//Sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
			var param = "ordTypeCd="+sheet1.GetCellValue(sheet1.GetSelectRow(),"ordTypeCd") ;
			sheet3.DoSearch( "${ctx}/AppmtCodeMgr.do?cmd=getAppmtCodeDetailMgrList", param,1 );
			break;
		case "Save":

			if(!dupChk(sheet3,"ordTypeCd|ordDetailCd|ordDetailNm", true, true)){break;}
			IBS_SaveName(document.mySheetForm,sheet3);
			sheet3.DoSave( "${ctx}/SaveData.do?cmd=saveAppmtCodeDetailMgr", $("#mySheetForm").serialize());
			break;
		case "Insert":
			var selectRow = sheet1.GetSelectRow();

			if(sheet1.RowCount("I") > 0) {
				alert("<msg:txt mid='110033' mdef='발령을 저장후 입력하여 주십시오.'/>");
				return;
			}

			var ordTypeCd = sheet1.GetCellValue(selectRow,"ordTypeCd");
			var row = sheet3.DataInsert(0);
			sheet3.SetCellValue(row,"ordTypeCd",ordTypeCd);
			sheet3.SelectCell(row, "ordDetailCd");
			break;
		case "Copy":
			var Row = sheet3.DataCopy();
			sheet3.SetCellValue(Row, "languageCd", "" );
			sheet3.SetCellValue(Row, "languageNm", "" );
			break;
		case "Clear":
			sheet3.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet3);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "발령상세코드관리_" + d.getTime() + ".xlsx";
			sheet3.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
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

	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(sheet1.GetSelectRow() > 0 && sheet1.GetCellValue(NewRow, 'ordTypeCd') !== '') {
				if(OldRow != NewRow) {
					doAction2("Search");
					doAction3("Search");
				}
			}
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col){
		try{
			if (sheet1.ColSaveName(Col) == "languageNm") {
				lanuagePopup(Row, "sheet1", "tsys011", "languageCd", "languageNm", "ordTypeNm")
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
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

	// 팝업 클릭시 발생
	function sheet2_OnPopupClick(Row,Col) {
		if(sheet2.ColSaveName(Col) == "name") {
			if(!isPopup()) {return;}

			gPRow = Row;
			pGubun = "employeePopup";

            var win = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", "", "740","520");
 		}
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

	function sheet3_OnPopupClick(Row, Col){
		try{
			if (sheet3.ColSaveName(Col) == "languageNm") {
				lanuagePopup(Row, "sheet3", "tsys013", "languageCd", "languageNm", "ordDetailNm")
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "sheetAutocomplete"){
            sheet2.SetCellValue(gPRow, "sabun",  rv["sabun"] );
            sheet2.SetCellValue(gPRow, "name",   rv["name"] );
            sheet2.SetCellValue(gPRow, "alias",   rv["alias"] );
            sheet2.SetCellValue(gPRow, "orgNm",  rv["orgNm"] );
            sheet2.SetCellValue(gPRow, "jikgubNm",   rv["jikgubNm"] );
            sheet2.SetCellValue(gPRow, "jikweeNm",  rv["jikweeNm"] );
        }
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
						<th><tit:txt mid='113178' mdef='발령코드'/></th>
						<td>
							<input id="ordTypeCd" name="ordTypeCd" type="text" class="text" />
						</td>
						<th><tit:txt mid='ordDetail' mdef='발령'/></th>
						<td>
							<input id="ordTypeNm" name="ordTypeNm" type="text" class="text" />
						</td>
						<th><tit:txt mid='113328' mdef='발령구분'/></th>
						<td>
							<select id="ordType" name="ordType"></select>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search');" css="button" mid='search' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="60%" />
		<col width="40%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='ordTypeCdMgr' mdef='발령코드관리'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Insert');" css="basic authA" mid='insert' mdef="입력"/>
						<btn:a href="javascript:doAction1('Copy');" css="basic authA" mid='copy' mdef="복사"/>
						<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='save' mdef="저장"/>
						<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='down2excel' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='ordDetailCd' mdef='발령상세코드관리'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction3('Insert');" css="basic authA" mid='insert' mdef="입력"/>
						<btn:a href="javascript:doAction3('Copy');" css="basic authA" mid='copy' mdef="복사"/>
						<btn:a href="javascript:doAction3('Save');" css="basic authA" mid='save' mdef="저장"/>
						<btn:a href="javascript:doAction3('Down2Excel');" css="basic authR" mid='down2excel' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet3", "50%", "75%", "${ssnLocaleCd}"); </script>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='ordTypeUserMgr' mdef='발령담당자관리'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction2('Insert');" css="basic authA" mid='insert' mdef="입력"/>
						<btn:a href="javascript:doAction2('Copy');" css="basic authA" mid='copy' mdef="복사"/>
						<btn:a href="javascript:doAction2('Save');" css="basic authA" mid='save' mdef="저장"/>
						<btn:a href="javascript:doAction2('Down2Excel');" css="basic authR" mid='down2excel' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "50%", "39%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>

</div>
</body>
</html>
