<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='112192' mdef='승진년차'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"현직위",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30 },
			{Header:"승진대상직위",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"riseJikweeCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:30 },
			{Header:"승진대상직급",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:30 },
			{Header:"년한",												Type:"Int",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"yearNum",		KeyField:0,	Format:"##",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='sgPointV2' mdef='승급포인트'/>",											Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"cutlineNum",	KeyField:0,	Format:"##",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",				Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		/* 포상사항 */
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"포상사항",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"prizeCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30 },
			{Header:"가점(회당)",	Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"plusPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:30 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		/* 징계사항 */
		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata3.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"징계사항",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"punishCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30 },
			{Header:"감점(회당)",	Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"minusPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:30 }
		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);

		/* 자격조회 */
		var initdata4 = {};
		initdata4.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata4.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata4.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"자격증",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"licenseCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30 },
			{Header:"가점(회당)",	Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"plusPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:30 }
		]; IBS_InitSheet(sheet4, initdata4);sheet4.SetEditable("${editable}");sheet4.SetVisible(true);sheet4.SetCountPosition(4);

		/* 근태조회 */
		var initdata5 = {};
		initdata5.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata5.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata5.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"근태",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"gntCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30 },
			{Header:"감점(회당)",	Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"minusPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:30 }
		]; IBS_InitSheet(sheet5, initdata5);sheet5.SetEditable("${editable}");sheet5.SetVisible(true);sheet5.SetCountPosition(4);
		
		var userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");
		var userCd2 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "");
		
		sheet1.SetColProperty("jikweeCd", 		{ComboText:userCd1[0], ComboCode:userCd1[1]} );
		sheet1.SetColProperty("riseJikweeCd", 	{ComboText:userCd1[0], ComboCode:userCd1[1]} );
		sheet1.SetColProperty("jikgubCd", 		{ComboText:userCd2[0], ComboCode:userCd2[1]} );
		
		sheet1.SetFocusAfterProcess(0);

		//TAB
		$("#tabs").tabs();
		$("#tabsIndex").val('0');

		initTabsLine(); //탭 하단 라인 추가
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	
	function moveTab(idx){
		$("#tabsIndex").val(idx);
		$("#tabs").tabs( "option", "active", idx );

		if( idx == 0 ) {
			sheetResize();
			doAction2("Search");
			doAction3("Search");
		} else if( idx == 1 ) {
			sheetResize();
			doAction4("Search");
			doAction5("Search");
		}
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/PromStdStayTy.do?cmd=getPromStdStayTyList", $("#mySheetForm").serialize()  );
			doAction2("Search");
			doAction3("Search");
			break;
		case "Save":
			//if(!dupChk(sheet1,"baseJikgubCd", true, true)){break;}  
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/PromStdStayTy.do?cmd=savePromStdStayTy", $("#sheet1Form").serialize()); 
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
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

	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				sheet2.DoSearch( "${ctx}/PromStdStayTy.do?cmd=getPromStdStayTyPrizeList", $("#mySheetForm").serialize()  );
				break;
			case "Save":
				IBS_SaveName(document.sheet1Form, sheet2);
				sheet2.DoSave( "${ctx}/PromStdStayTy.do?cmd=savePromStdStayTyPrize", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet2.DataInsert(0);
				break;
			case "Copy":
				sheet2.DataCopy();
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet2.Down2Excel(param);
				break;
		}
	}

	function doAction3(sAction) {
		switch (sAction) {
			case "Search":
				sheet3.DoSearch( "${ctx}/PromStdStayTy.do?cmd=getPromStdStayTyPunishList", $("#mySheetForm").serialize()  );
				break;
			case "Save":
				IBS_SaveName(document.sheet1Form, sheet3);
				sheet3.DoSave( "${ctx}/PromStdStayTy.do?cmd=savePromStdStayTyPunish", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet3.DataInsert(0);
				break;
			case "Copy":
				sheet3.DataCopy();
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet3);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet3.Down2Excel(param);
				break;
		}
	}

	function doAction4(sAction) {
		switch (sAction) {
			case "Search":
				sheet4.DoSearch( "${ctx}/PromStdStayTy.do?cmd=getPromStdStayTyLicenseList", $("#mySheetForm").serialize()  );
				break;
			case "Save":
				IBS_SaveName(document.sheet1Form, sheet4);
				sheet4.DoSave( "${ctx}/PromStdStayTy.do?cmd=savePromStdStayTyLicense", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet4.DataInsert(0);
				break;
			case "Copy":
				sheet4.DataCopy();
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet4);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet4.Down2Excel(param);
				break;
		}
	}

	function doAction5(sAction) {
		switch (sAction) {
			case "Search":
				sheet5.DoSearch( "${ctx}/PromStdStayTy.do?cmd=getPromStdStayTyGntList", $("#mySheetForm").serialize()  );
				break;
			case "Save":
				IBS_SaveName(document.sheet1Form, sheet5);
				sheet5.DoSave( "${ctx}/PromStdStayTy.do?cmd=savePromStdStayTyGnt", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet5.DataInsert(0);
				break;
			case "Copy":
				sheet5.DataCopy();
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet5);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet5.Down2Excel(param);
				break;
		}
	}

	/* Sheet Event */
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

	// 조회 후 에러 메시지
	function sheet5_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet5_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			doAction5("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	/* Sheet Event End */
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form">
	<div class="wrapper">
		<input type="hidden" id="tabsIndex" name="tabsIndex" />

		<div class="inner">
			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='112192' mdef='승진년차'/></li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel');" class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
					<a href="javascript:doAction1('Copy');" class="btn outline-gray authA"><tit:txt mid='104335' mdef='복사'/></a>
					<a href="javascript:doAction1('Insert');" class="btn outline-gray authA"><tit:txt mid='104267' mdef='입력'/></a>
					<a href="javascript:doAction1('Save');" class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
					<a href="javascript:doAction1('Search')" 	class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a>
				</li>
			</ul>
			</div>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>

		<div class="h10 outer"></div>
		<div style="height:50%;">
			<div id="tabs" class="tab">
				<ul class="tab_bottom">
					<li><a href="#tabs-0" onclick="javascript:moveTab(0)" >가감점(포상/징계)</a></li>
					<li><a href="#tabs-1" onclick="javascript:moveTab(1)" >가감점(자격/근태)</a></li>
				</ul>
				<div id="tabs-0">
					<form id="tab1Form" name="tab1Form">
						<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
							<colgroup>
								<col width="50%" />
								<col width="50%" />
							</colgroup>
							<tr>
								<td class="sheet_left">
									<div class="inner">
										<div class="sheet_title">
											<ul>
												<li id="txt" class="txt">
													포상사항
												</li>
												<li class="btn">
													<a href="javascript:doAction2('Down2Excel');" class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
													<a href="javascript:doAction2('Copy');" class="btn outline-gray authA"><tit:txt mid='104335' mdef='복사'/></a>
													<a href="javascript:doAction2('Insert');" class="btn outline-gray authA"><tit:txt mid='104267' mdef='입력'/></a>
<%--													<a href="javascript:doAction2('Save');" class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>--%>
													<a href="javascript:doAction2('Search')" 	class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a>
												</li>
											</ul>
										</div>
									</div>
									<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
								</td>
								<td class="sheet_right">
									<div class="inner">
										<div class="sheet_title">
											<ul>
												<li class="txt">
													징계사항
												</li>
												<li class="btn">
													<a href="javascript:doAction3('Down2Excel');" class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
													<a href="javascript:doAction3('Copy');" class="btn outline-gray authA"><tit:txt mid='104335' mdef='복사'/></a>
													<a href="javascript:doAction3('Insert');" class="btn outline-gray authA"><tit:txt mid='104267' mdef='입력'/></a>
<%--													<a href="javascript:doAction3('Save');" class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>--%>
													<a href="javascript:doAction3('Search')" 	class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a>
												</li>
											</ul>
										</div>
									</div>
									<script type="text/javascript"> createIBSheet("sheet3", "100%", "50%", "${ssnLocaleCd}"); </script>
								</td>
							</tr>
						</table>
					</form>
				</div>

				<div id="tabs-1">
					<form id="tab2Form" name="tab2Form">
						<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
							<colgroup>
								<col width="50%" />
								<col width="50%" />
							</colgroup>
							<tr>
								<td class="sheet_left">
									<div class="inner">
										<div class="sheet_title">
											<ul>
												<li class="txt">
													자격사항
												</li>
												<li class="btn">
													<a href="javascript:doAction4('Down2Excel');" class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
													<a href="javascript:doAction4('Copy');" class="btn outline-gray authA"><tit:txt mid='104335' mdef='복사'/></a>
													<a href="javascript:doAction4('Insert');" class="btn outline-gray authA"><tit:txt mid='104267' mdef='입력'/></a>
<%--													<a href="javascript:doAction4('Save');" class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>--%>
													<a href="javascript:doAction4('Search')" 	class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a>
												</li>
											</ul>
										</div>
									</div>
									<script type="text/javascript"> createIBSheet("sheet4", "100%", "50%", "${ssnLocaleCd}"); </script>
								</td>
								<td class="sheet_right">
									<div class="inner">
										<div class="sheet_title">
											<ul>
												<li class="txt">
													근태사항
												</li>
												<li class="btn">
													<a href="javascript:doAction5('Down2Excel');" class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
													<a href="javascript:doAction5('Copy');" class="btn outline-gray authA"><tit:txt mid='104335' mdef='복사'/></a>
													<a href="javascript:doAction5('Insert');" class="btn outline-gray authA"><tit:txt mid='104267' mdef='입력'/></a>
<%--													<a href="javascript:doAction5('Save');" class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>--%>
													<a href="javascript:doAction5('Search')" 	class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a>
												</li>
											</ul>
										</div>
									</div>
									<script type="text/javascript"> createIBSheet("sheet5", "100%", "50%", "${ssnLocaleCd}"); </script>
								</td>
							</tr>
						</table>
					</form>
				</div>

			</div><!-- tabs -->
		</div>

	</div>
</form>
</body>
</html>
